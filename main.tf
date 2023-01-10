# Module SG
module "accor_sg" {
  source =   "./modules/subnet"
  my_ip = var.my_ip
  env_prefix = var.env_prefix

}

module "accor_ec2" {
  source = "./modules/webserver"
  public_key_ssh_location = var.public_key_ssh_location
  private_key_location = var.private_key_location
  env_prefix = var.env_prefix
  image_name = var.image_name
  sg_id =  module.accor_sg.sg_id.id
  instance_type = var.instance_type
}
