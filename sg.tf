# Creates security group
resource "aws_security_group" "allows_docdb" {
  name                      = "allows_docdb"
  description               = "Allows Only private traffic"
  vpc_id                    = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description              = "docdb from private network"
    from_port                = var.DOCDB_INSTANCE_PORT
    to_port                  = var.DOCDB_INSTANCE_PORT
    protocol                 = "tcp"
    cidr_blocks              = [data.terraform_remote_state.vpc.outputs.VPC_CIDR, data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR]
  }

  egress {
    from_port                = 0
    to_port                  = 0
    protocol                 = "-1"
    cidr_blocks              = ["0.0.0.0/0"]
  }

  tags = {
    Name                     = "allow_private_traffic"
  }
}