#!/usr/bin/env python3
import json
import requests
import os

secrets = json.loads(open('secret.json').read())

fmc = secrets['FMC_URL']
fmc_domain = secrets['FMC_DOMAIN']
cdfmc_token = secrets['CDFMC_TOKEN']

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


data = ''
resource = ''
variables = ''

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

data_log = open('data.tf', 'w')
data_log.write(data)
data_log.close()
resource_log = open('resource.tf', 'w')
resource_log.write(resource)
resource_log.close()

