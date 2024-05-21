terraform {
  cloud {
    organization = "Global-Security-Automation-Team"

    workspaces {
      name = "yelb-dev"
    }
  }
}