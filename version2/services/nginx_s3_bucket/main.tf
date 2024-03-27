#-----------------------------
# Service: Nginx s3_Bucket
#-----------------------------

module "module_s3_bucket" {
  source = "../../modules/s3/basic"

  bucket              = var.bucket_name
  force_destroy       = var.force_destroy
  block_public_acls   = var.block_public_acls
  block_public_policy = var.block_public_policy
  ignore_public_acls  = var.ignore_public_acls
}


