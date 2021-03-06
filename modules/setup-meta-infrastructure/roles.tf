#----------------------------------------------------------------------
# Roles
#----------------------------------------------------------------------

module "admin-role" {
  source    = "../cross-account-role"
  aws_cloud = "${var.aws_cloud}"
  name      = "admin"

  trust_account_ids = [
    "${data.aws_caller_identity.current.account_id}",
    "${var.trust_account_ids}",
  ]
}

module "power-user-role" {
  source    = "../cross-account-role"
  aws_cloud = "${var.aws_cloud}"
  name      = "power-user"

  trust_account_ids = [
    "${data.aws_caller_identity.current.account_id}",
    "${var.trust_account_ids}",
  ]
}
