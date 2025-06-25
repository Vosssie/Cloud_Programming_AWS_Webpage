resource "aws_cognito_user_pool" "user-pool" {
  name = var.cognito_user_pool_id

  auto_verified_attributes = ["email"] #What needs to be auto-verified
  username_attributes = ["email"] # Set that emails can be usernames

  password_policy {
    minimum_length = 8
    require_numbers = true
    require_uppercase = true
  }

  #schema{
  #  attribute_data_type = "String"
  #  name = "email-address"
  #  developer_only_attribute = false
  #  mutable = true #Allow attribute to be changed once created
  #  required = true #User must supply an email

  #  string_attribute_constraints {
  #    min_length = 1
  #    max_length = 100
  #  }
  #}

#  schema{
#    attribute_data_type = "String"
#    name = "role"
#    developer_only_attribute = false
#    mutable = true #Allow attribute to be changed once created
#    required = true #User must supply an email

#    string_attribute_constraints {
#      min_length = 1
#      max_length = 100
#    }
#  }
}

resource "aws_cognito_user_pool_client" "client" {
  name = var.cognito_client_id
  provider = aws
  region = "us-east-1" #To fix aws provider issue
  #name = "${var.domain}-client"

  user_pool_id = aws_cognito_user_pool.user-pool.id

  explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  prevent_user_existence_errors = "ENABLED"
  refresh_token_validity = 30

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cognito_user_pool_domain" "user-pool-domain" {
  domain       = "auth-4seeable1"
  user_pool_id = aws_cognito_user_pool.user-pool.id
}

resource "aws_cognito_user_group" "admin-group" {
  name         = "admin-group"
  user_pool_id = aws_cognito_user_pool.user-pool.id
  description  = "Admin group"
  precedence   = 1
}

resource "aws_cognito_user_group" "user_group" {
  name         = "user"
  user_pool_id = aws_cognito_user_pool.user-pool.id
  description  = "Regular users - Students"
  precedence   = 2
}