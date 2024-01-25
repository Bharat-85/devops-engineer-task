#_______________________________Module call to provision the stack____________________________
module "web_instances_stack" {
  source = "../modules"

  tag_environment   = var.tag_environment
  ami_name          = var.ami_name
  instance_type     = var.instance_type
  web_asg_max_child = var.web_asg_max_child
  web_asg_min_child = var.web_asg_min_child
  tag_hsn           = var.tag_hsn
  vpc_name          = var.vpc_name
  sg_name           = var.sg_name

}
