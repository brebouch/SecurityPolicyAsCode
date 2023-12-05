#!/usr/bin/env python3
import json
import requests
import datetime
import os

fmc = os.environ.get('FMC_URL')
fmc_domain = os.environ.get('FMC_DOMAIN')
cdfmc_token = os.environ.get('CDFMC_TOKEN')

################################
#
# Create Terraform Variables
#
###############################

tf_var = 'cdo_token = "' + cdfmc_token + '"\n\n'
tf_var += 'cdFMC = "' + fmc + '"\n\n'
tf_var += 'cdfmc_domain_uuid = "' + fmc_domain + '"\n\n'

variable_log = open('terraform.tfvars', 'w')
variable_log.write(tf_var)
variable_log.close()

docker = json.loads(open('ansible_data.json').read())
ports = []
url = 'https://' + fmc + '/api/fmc_config/v1/domain/' + fmc_domain + '/object/protocolportobjects?limit=10000'
headers = {'Authorization': 'Bearer ' + cdfmc_token, 'Accept': 'application/json'}
resp = requests.get(url, headers=headers)
if resp.status_code == 200:
    port_objects = resp.json()
    ports = port_objects['items']


def port_lookup(port_name):
    for p in ports:
        if p['name'] == port_name:
            return True
    return False


def create_policy_rule_string(ports_string):
    now = datetime.datetime.utcnow()
    rule = 'resource "fmc_access_rules" "access_rule" { \n \
        acp                = data.fmc_access_policies.acp.id \n \
        section            = "mandatory" \n \
        name               = "yelb_app_permit_inbound_ ' + now.strftime('%Y-%m-%d-%H-%M-%S') + '" \n \
        action             = "allow" \n \
        enabled            = true \n \
        send_events_to_fmc = true \n \
        log_files          = false \n \
        log_begin          = true \n \
        log_end            = true \n \
        source_networks { \n \
          source_network { \n \
            id   = data.fmc_network_objects.any.id \n \
            type = "Network" \n \
        } \n \
      } \n \
        destination_networks { \n \
          destination_network { \n \
            id   = data.fmc_network_objects.yelb_app_vpc.id \n \
            type = "Network" \n \
        } \n \
      } \n '
    rule += ports_string
    rule += 'ips_policy = data.fmc_ips_policies.ips_policy.id \n \
    new_comments = ["inbound app traffic"] \n \
    }'
    return rule


data = '''
data "fmc_access_policies" "acp" {
    name = "Policy as Code"
}

data "fmc_ips_policies" "ips_policy" {
    name = "Connectivity Over Security"
}

data "fmc_network_objects" "any" {
    name = "any-ipv4"
}

data "fmc_network_objects" "yelb_app_vpc" {
    name = "yelb_app_vpc"
}
'''
resource = ''
variables = ''

rule_ports = ''

for d in docker:
    name = d['container']['Config']['Labels']['com.docker.compose.service']
    if 'Ports' in d['container']['NetworkSettings'].keys():
        for k, v in d['container']['NetworkSettings']['Ports'].items():
            if v is None:
                continue
            internal = k.split('/')
            in_port = internal[0]
            protocol = internal[1]
            for export in v:
                host = export['HostIp']
                port = export['HostPort']
                object_name = f'{name}_{port}_{protocol}'
                checkup = port_lookup(object_name)
                if checkup:
                    data += 'data "fmc_port_objects" "' + object_name + '" {\n    name = "' + object_name + '"\n}\n\n'
                else:
                    resource += 'resource "fmc_port_objects" "' + object_name \
                                + '" {\n    name = "' + object_name + '"\n    port = ' \
                                + port + '\n    protocol = "' + protocol.upper() + '"\n}\n\n'
                    rule_ports += 'destination_port ' \
                                  + ' {\n    id = fmc_port_objects.' \
                                  + object_name + '.id\n type = fmc_port_objects.' + object_name + '.type \n}\n'
if rule_ports:
    rule_ports = 'destination_ports { \n' + rule_ports + '\n}\n'

resource += create_policy_rule_string(rule_ports)

data_log = open('data.tf', 'w')
data_log.write(data)
data_log.close()
resource_log = open('resource.tf', 'w')
resource_log.write(resource)
resource_log.close()
