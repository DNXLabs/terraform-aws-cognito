variable "enabled" {
  description = "Change to false to avoid deploying any resources"
  type        = bool
  default     = true
}

variable "user_pool_name" {
  description = "The name of the user pool"
  type        = string
}

variable "username_configuration" {
  description = "The Username Configuration. Seting `case_sesiteve` specifies whether username case sensitivity will be applied for all users in the user pool through Cognito APIs"
  type = object({
    case_sensitive = bool
  })
  default = null
}

variable "admin_create_user_config" {
  description = "The configuration for AdminCreateUser requests"
  type = object({
    allow_admin_create_user_only = optional(bool, true),
    invite_message_template = optional(object({
      email_message = string,
      email_subject = string,
      sms_message   = string
    }))
  })
  default = null
}

variable "alias_attributes" {
  description = "Attributes supported as an alias for this user pool. Possible values: phone_number, email, or preferred_username. Conflicts with `username_attributes`"
  type        = list(string)
  default     = null
}

variable "username_attributes" {
  description = "Specifies whether email addresses or phone numbers can be specified as usernames when a user signs up. Conflicts with `alias_attributes`"
  type        = list(string)
  default     = null
}

variable "auto_verified_attributes" {
  description = "The attributes to be auto-verified. Possible values: email, phone_number"
  type        = list(string)
  default     = []
}

variable "sms_configuration" {
  description = "The SMS Configuration"
  type = object({
    external_id    = string,
    sns_caller_arn = string,
    sns_region     = optional(string)
  })
  default = null
}

variable "device_configuration" {
  description = "The configuration for the user pool's device tracking"
  type = object({
    challenge_required_on_new_device      = optional(bool)
    device_only_remembered_on_user_prompt = optional(bool)
  })
  default = null
}

# email_configuration
variable "email_configuration" {
  description = "The Email Configuration"
  type = object({
    configuration_set      = optional(string),
    reply_to_email_address = string,
    source_arn             = string,
    email_sending_account  = string,
    from_email_address     = optional(string)
  })
  default = null
}

variable "verification_message_template" {
  description = "The verification message templates configuration"
  type = object({
    default_email_option  = optional(string, "CONFIRM_WITH_CODE"),
    default_email_option  = optional(string, null),
    email_message         = optional(string, null),
    email_message_by_link = optional(string, null),
    email_subject         = optional(string, null),
    email_subject_by_link = optional(string, null),
    sms_message           = optional(string, null)
  })
  default = null
}

variable "lambda_config" {
  description = "A container for the AWS Lambda triggers associated with the user pool"
  type = object({
    create_auth_challenge          = string,
    custom_message                 = string,
    define_auth_challenge          = string,
    post_authentication            = string,
    post_confirmation              = string,
    pre_authentication             = string,
    pre_sign_up                    = string,
    pre_token_generation           = string,
    user_migration                 = string,
    verify_auth_challenge_response = string,
    kms_key_id                     = string,
    custom_email_sender = optional(object({
      lambda_arn     = string,
      lambda_version = string
    })),
    custom_sms_sender = optional(object({
      lambda_arn     = string,
      lambda_version = string
    }))
  })
  default = null
}

variable "mfa_configuration" {
  description = "Set to enable multi-factor authentication."
  type        = string
  default     = "OFF"
  validation {
    condition     = contains(["OFF", "ON", "OPTIONAL"], var.mfa_configuration)
    error_message = "The value must be one of 'OFF', 'ON', 'OPTIONAL'."
  }
}

variable "software_token_mfa_configuration" {
  description = "Configuration block for software token MFA (multifactor-auth). mfa_configuration must also be enabled for this to work"
  type = object({
    enabled = bool
  })
  default = null
}

variable "password_policy" {
  description = "A container for information about the user pool password policy"
  type = object({
    minimum_length                   = number,
    require_lowercase                = bool,
    require_lowercase                = bool,
    require_numbers                  = bool,
    require_symbols                  = bool,
    require_uppercase                = bool,
    temporary_password_validity_days = number
  })
  default = null
}

variable "schemas" {
  description = "A container with the schema attributes of a user pool. Maximum of 50 attributes"
  type = list(object({
    attribute_data_type      = string,
    developer_only_attribute = optional(bool, true),
    mutable                  = optional(bool, true),
    name                     = string
    required                 = optional(bool, true)
  }))
  default = []
}

variable "string_schemas" {
  description = "A container with the string schema attributes of a user pool. Maximum of 50 attributes"
  type = list(object({
    name                     = string
    developer_only_attribute = optional(bool, true),
    mutable                  = optional(bool, true),
    required                 = optional(bool, true)
    string_attribute_constraints = object({
      min_length = number,
      max_length = number
    })
  }))
  default = []
}

variable "number_schemas" {
  description = "A container with the number schema attributes of a user pool. Maximum of 50 attributes"
  type = list(object({
    name                     = string
    developer_only_attribute = optional(bool, true),
    mutable                  = optional(bool, true),
    required                 = optional(bool, true)
    number_attribute_constraints = object({
      min_value = number,
      max_value = number
    })
  }))
  default = []
}

# sms messages
variable "sms_authentication_message" {
  description = "A string representing the SMS authentication message"
  type        = string
  default     = null
}

# tags
variable "tags" {
  description = "A mapping of tags to assign to the User Pool"
  type        = map(string)
  default     = {}
}

variable "user_pool_add_ons" {
  description = "Configuration block for user pool add-ons to enable user pool advanced security mode features"
  type = object({
    advanced_security_mode = string
  })
  default = null
}

variable "domain" {
  description = "Cognito User Pool domain"
  type        = string
  default     = null
}

variable "domain_certificate_arn" {
  description = "The ARN of an ISSUED ACM certificate in us-east-1 for a custom domain"
  type        = string
  default     = null
}

variable "clients" {
  description = "A container with the clients definitions"
  type = list(object({
    name                                          = string,
    allowed_oauth_flows                           = optional(list(string)),
    allowed_oauth_flows_user_pool_client          = optional(bool),
    allowed_oauth_scopes                          = optional(list(string)),
    auth_session_validity                         = optional(number, 3)
    callback_urls                                 = optional(list(string)),
    default_redirect_uri                          = optional(string),
    explicit_auth_flows                           = optional(string),
    generate_secret                               = optional(string),
    logout_urls                                   = optional(list(string)),
    read_attributes                               = optional(list(string)),
    supported_identity_providers                  = optional(list(string)),
    prevent_user_existence_errors                 = optional(string, "ENABLED"),
    write_attributes                              = optional(list(string), []),
    enable_token_revocation                       = optional(bool),
    enable_propagate_additional_user_context_data = optional(bool),
    token_validity_units = optional(object({
      access_token  = optional(string, "hours"),
      id_token      = optional(string, "hours"),
      refresh_token = optional(string, "days")
    })),
    analytics_configuration = optional(object({
      application_arn  = optional(string),
      application_id   = optional(string),
      external_id      = optional(string),
      role_arn         = optional(string),
      user_data_shared = optional(bool)
    }))
  }))
  default = []
}

#=== User Groups ===#
variable "user_groups" {
  description = "A container with the user_groups definitions"
  type        = list(any)
  default     = []
}

variable "user_group_name" {
  description = "The name of the user group"
  type        = string
  default     = null
}

variable "user_group_description" {
  description = "The description of the user group"
  type        = string
  default     = null
}

variable "user_group_precedence" {
  description = "The precedence of the user group"
  type        = number
  default     = null
}

variable "user_group_role_arn" {
  description = "The ARN of the IAM role to be associated with the user group"
  type        = string
  default     = null
}

variable "resource_servers" {
  description = "A container with the user_groups definitions"
  type        = list(any)
  default     = []
}

variable "resource_server_name" {
  description = "A name for the resource server"
  type        = string
  default     = null
}

variable "resource_server_identifier" {
  description = "An identifier for the resource server"
  type        = string
  default     = null
}

variable "resource_server_scope_name" {
  description = "The scope name"
  type        = string
  default     = null
}

variable "resource_server_scope_description" {
  description = "The scope description"
  type        = string
  default     = null
}

#
# Account Recovery Setting
#
variable "account_recovery_setting" {
  description = "The list of Account Recovery Options"
  type = object({
    recovery_mechanism = list(object({
      name     = string,
      priority = number
    }))
  })
  default = null
}

#
# aws_cognito_identity_provider
#
variable "identity_providers" {
  description = "Cognito Pool Identity Providers"
  type        = list(any)
  default     = []
}
