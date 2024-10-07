terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
locals {
  # Split the file app.yaml - deploy + service.
  documents = split("---", file("${path.module}/../kubernetes/app.yaml"))
}

# Iterate over file
resource "kubernetes_manifest" "webserver_app" {
  for_each = { for idx, doc in local.documents : idx => doc if doc != "" }

  manifest = yamldecode(each.value)
}
