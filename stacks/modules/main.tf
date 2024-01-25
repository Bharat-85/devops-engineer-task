#------------------------------VPC DataSource-----------------------------------------------------
data "aws_vpc" "web_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }

  state = "available"
}
#------------------------------Subnets DataSource-----------------------------------------------------

data "aws_subnets" "web_subnet" {
  filter {
    name   = "vpc-id"
    values = data.aws_vpc.web_vpc.id
  }
}
#------------------------------SG DataSource-----------------------------------------------------
data "aws_security_group" "web_sg" {
  name   = var.sg_name
  vpc_id = data.aws_vpc.web_vpc.id
}

#------------------------------Launch Comfiguration-----------------------------------------------------
resource "aws_launch_configuration" "web_launchconfig" {
   name_prefix                 = "${var.tag_environment}-lc"
   image_id                    = var.ami_name
   instance_type               = var.instance_type
   security_groups             = [data.aws_security_group.web_sg.id]
   associate_public_ip_address = true

   user_data = <<-EOF
                #!/bin/bash
                echo "Hello World"
                EOF
  
   lifecycle {
    create_before_destroy = true
  }
}

#------------------------------ASG-----------------------------------------------------

resource "aws_autoscaling_group" "web_asg" {
  name                      = "${var.tag_environment}-Web"
  vpc_zone_identifier       = data.aws_subnets.web_subnet.id
  launch_configuration      = aws_launch_configuration.web_launchconfig.name
  max_size                  = var.web_asg_max_child
  min_size                  = var.web_asg_min_child
    
  tag {
    key = "HSN"
    value = var.tag_hsn
    propagate_at_launch = true
  }
  tag {
    key = "Name"
    value = "web-asg-${var.tag_environment}"
    propagate_at_launch = true
  }
  tag {
   key =  "env"
   value = var.tag_environment
   propagate_at_launch = true
  }

lifecycle {
    create_before_destroy = true
  }
}