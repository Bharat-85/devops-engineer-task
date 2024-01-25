#------------------------------VPC DataSource-----------------------------------------------------
data "aws_vpc" "web_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }

  state = "available"
}

#------------------------------Security Group-----------------------------------------------------
resource "aws_security_group" "web_sg" {
    name            = var.sg_name
    vpc_id          = data.aws_vpc.web_vpc.id
    ingress {
        from_port   = 8080
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}