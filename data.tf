# Reads the information from the remote statefile
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "b55-tf-state"
    key    = "vpc/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
  }
}

# Fetches the information of the secret

data "aws_secretsmanager_secret" "secrets" {
  name = "robot/secrets"
}

# fetches the secrets version from the above server
resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id     = data.aws_secretsmanager_secret.secret_version.id
}

output "example" {
  value = jsondecode(aws_secretsmanager_secret_version.secret_version.secret_string)["DOCDB_USERNAME"]
}