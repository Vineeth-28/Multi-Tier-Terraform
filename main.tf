module "vpc" {
  source = "./modules/vpc"
}

module "sg" {
  source = "./modules/security-group"

  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source = "./modules/ec2"

  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.sg.security_group_id
}

module "s3" {
  source = "./modules/s3"

  bucket_name = "${terraform.workspace}-vineet-app-bucket"
}

module "dynamodb" {
  source = "./modules/dynamodb"

  table_name = "${terraform.workspace}-users-table"
}