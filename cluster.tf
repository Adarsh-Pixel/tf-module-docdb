# Creates DOCDB cluster
resource "aws_docdb_cluster" "docdb" {
  cluster_identifier      = "roboshop-${var.ENV}-docdb"
  engine                  = "docdb"
  master_username         = jsondecode(data.aws_secretsmanager_secret_version.secret_version.secret_string)["DOCDB_USERNAME"]
  master_password         = jsondecode(data.aws_secretsmanager_secret_version.secret_version.secret_string)["DOCDB_PASSWORD"]
  skip_final_snapshot     = true            # value will be false in production. In lab, we will be using true
  db_subnet_group_name    = aws_docdb_subnet_group.docdb.name
  vpc_security_group_ids  = [aws_security_group.allows_docdb.id]
}
# Creates DocDB instances and adds to the cluster

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = var.DOCDB_INSTANCE_COUNT
  identifier         = "roboshop-${var.ENV}-docdb"
  cluster_identifier = aws_docdb_cluster.docdb.id
  instance_class     = var.DOCDB_INSTANCE_TYPE
}


# Create DocDB subnet group

resource "aws_docdb_subnet_group" "docdb" {
  name       = "roboshop-${var.ENV}-docdb-subnet-group"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS

  tags = {
    Name = "roboshop-${var.ENV}-docdb-subnet-group"
  }
}

