provider "google" {
  project = "elvis-devops-iac"
  region  = "us-central1"
  zone    = "us-central1-c"
  credentials = "${file("serviceaccount.yaml")}"
}

resource "google_folder" "Comercial" {
  display_name = "Comercial"
  parent       = "organizations/931783052405"
}

resource "google_folder" "ERP" {
  display_name = "ERP"
  parent       = google_folder.ERP.name
}

resource "google_folder" "Desenvolvimento" {
  display_name = "Desenvolvimento"
  parent       = google_folder.ERP.name
}

resource "google_folder" "Producao" {
  display_name = "Producao"
  parent       = google_folder.ERP.name
}


resource "google_project" "elvis-ERP-dev" {
  name       = "ERP-Dev"
  project_id = "elvis-ERP-dev"
  folder_id  = google_folder.Desenvolvimento.name
  auto_create_network=false
  billing_account = "01B4ED-FE44F8-E83DBE"

}

resource "google_project" "elvis-ERP-prod" {
  name       = "ERP-Prod"
  project_id = "elvis-ERP-prod"
  folder_id  = google_folder.Producao.name
  auto_create_network=false
  billing_account = "01B4ED-FE44F8-E83DBE"
}

provider "googleworkspace" {
  credentials             = "${file("serviceaccount.yaml")}"
  customer_id             = "E005diesh"
  impersonated_user_email = "****@elvismaster.com"
  oauth_scopes = [
    "https://www.googleapis.com/auth/admin.directory.user",
    "https://www.googleapis.com/auth/admin.directory.userschema",
    "https://www.googleapis.com/auth/admin.directory.group",	
    # include scopes as needed
  ]
}

resource "googleworkspace_group" "devops" {
  email       = "*****@elvismaster.com"
  name        = "Devops"
  description = "Devops Group"

  aliases = ["*****@elvismaster.com"]

  timeouts {
    create = "1m"
    update = "1m"
  }
}

resource "googleworkspace_user" "maicol" {
  primary_email = "maicol@elvismaster.com"
  password      = "*********"
  hash_function = "MD5"

  name {
    family_name = "Maicol"
    given_name  = "Ninguem"
  }
}

resource "googleworkspace_group_member" "manager" {
  group_id = googleworkspace_group.devops.id
  email    = googleworkspace_user.maicol.primary_email

  role = "MANAGER"
}