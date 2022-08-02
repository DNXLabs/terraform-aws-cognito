![Terraform]
# terraform-aws-cognito-user-pool

Terraform module to create [Amazon Cognito User Pools](https://aws.amazon.com/cognito/), configure its attributes and resources such as  **app clients**, **domain**, **resource servers**. Amazon Cognito User Pools provide a secure user directory that scales to hundreds of millions of users. As a fully managed service, User Pools are easy to set up without any worries about standing up server infrastructure.

## Usage

You can use this module to create a Cognito User Pool using the default values or use the detailed definition to set every aspect of the Cognito User Pool

Check the [examples](examples/) where you can see the **simple** example using the default values, the **simple_extended** version which adds  **app clients**, **domain**, **resource servers** resources, or the **complete** version with a detailed example.

### Example (simple)

This simple example creates a AWS Cognito User Pool with the default values:

```
module "aws_cognito_user_pool_simple" {

  source  = "cognito-user-pool/aws"

  user_pool_name = "mypool"

  tags = {
    Owner       = "infra"
    Environment = "production"
    Terraform   = true
  }
```

### Example (conditional creation)

If you need to create Cognito User Pool resources conditionally in ealierform  versions such as 0.11, 0,12 and 0.13 you can set the input variable `enabled` to false:

```
# This Cognito User Pool will not be created
module "aws_cognito_user_pool_conditional_creation" {

  source  = "cognito-user-pool/aws"

  user_pool_name = "conditional_user_pool"

  enabled = false

  tags = {
    Owner       = "infra"
    Environment = "production"
    Terraform   = true
  }

}
```

For Terraform 0.14 and later you can use `count` inside `module` blocks, or use the input variable `enabled` as described above.

### Example (complete)

This more complete example creates a AWS Cognito User Pool using a detailed configuration. Please check the example folder to get the example with all options:

```
module "aws_cognito_user_pool_complete" {

  source  = "cognito-user-pool/aws"

  user_pool_name           = "mypool"
  alias_attributes         = ["email", "phone_number"]
  auto_verified_attributes = ["email"]

  admin_create_user_config = {
    email_subject = "Here, your verification code baby"
  }

  email_configuration = {
    email_sending_account  = "DEVELOPER"
    reply_to_email_address = "email@example.com"
    source_arn             = "arn:aws:ses:us-east-1:888888888888:identity/example.com"
  }

  password_policy = {
    minimum_length    = 10
    require_lowercase = false
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  schemas = [
    {
      attribute_data_type      = "Boolean"
      developer_only_attribute = false
      mutable                  = true
      name                     = "available"
      required                 = false
    },
    {
      attribute_data_type      = "Boolean"
      developer_only_attribute = true
      mutable                  = true
      name                     = "registered"
      required                 = false
    }
  ]

  string_schemas = [
    {
      attribute_data_type      = "String"
      developer_only_attribute = false
      mutable                  = false
      name                     = "email"
      required                 = true

      string_attribute_constraints = {
        min_length = 7
        max_length = 15
      }
    }
  ]

  recovery_mechanisms = [
     {
      name     = "verified_email"
      priority = 1
    },
    {
      name     = "verified_phone_number"
      priority = 2
    }
  ]

  tags = {
    Owner       = "infra"
    Environment = "production"
    Terraform   = true
  }

`
