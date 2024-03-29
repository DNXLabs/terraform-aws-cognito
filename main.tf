resource "aws_cognito_user_pool" "pool" {
  count = var.enabled ? 1 : 0

  alias_attributes           = var.alias_attributes
  auto_verified_attributes   = var.auto_verified_attributes
  name                       = var.user_pool_name
  sms_authentication_message = var.sms_authentication_message
  username_attributes        = var.username_attributes

  mfa_configuration = var.mfa_configuration
  dynamic "software_token_mfa_configuration" {
    for_each = var.software_token_mfa_configuration == null ? [] : [1]
    content {
      enabled = var.software_token_mfa_configuration.enabled
    }
  }

  dynamic "username_configuration" {
    for_each = var.username_configuration == null ? [] : [1]
    content {
      case_sensitive = var.username_configuration.case_sensitive
    }
  }

  dynamic "admin_create_user_config" {
    for_each = var.admin_create_user_config == null ? [] : [1]
    content {
      allow_admin_create_user_only = var.admin_create_user_config.allow_admin_create_user_only
      dynamic "invite_message_template" {
        for_each = var.admin_create_user_config.invite_message_template == null ? [] : [1]
        content {
          email_message = var.admin_create_user_config.invite_message_template.email_message
          email_subject = var.admin_create_user_config.invite_message_template.email_subject
          sms_message   = var.admin_create_user_config.invite_message_template.sms_message
        }
      }
    }
  }

  dynamic "device_configuration" {
    for_each = var.device_configuration == null ? [] : [1]
    content {
      challenge_required_on_new_device      = var.device_configuration.challenge_required_on_new_device
      device_only_remembered_on_user_prompt = var.device_configuration.device_only_remembered_on_user_prompt
    }
  }

  dynamic "email_configuration" {
    for_each = var.email_configuration == null ? [] : [1]
    content {
      configuration_set      = var.email_configuration.configuration_set
      reply_to_email_address = var.email_configuration.reply_to_email_address
      source_arn             = var.email_configuration.source_arn
      email_sending_account  = var.email_configuration.email_sending_account
      from_email_address     = var.email_configuration.from_email_address
    }
  }

  dynamic "lambda_config" {
    for_each = var.lambda_config == null ? [] : [1]
    content {
      create_auth_challenge          = var.lambda_config.create_auth_challenge
      custom_message                 = var.lambda_config.custom_message
      define_auth_challenge          = var.lambda_config.define_auth_challenge
      post_authentication            = var.lambda_config.post_authentication
      post_confirmation              = var.lambda_config.post_confirmation
      pre_authentication             = var.lambda_config.pre_authentication
      pre_sign_up                    = var.lambda_config.pre_sign_up
      pre_token_generation           = var.lambda_config.pre_token_generation
      user_migration                 = var.lambda_config.user_migration
      verify_auth_challenge_response = var.lambda_config.verify_auth_challenge_response
      kms_key_id                     = var.lambda_config.kms_key_id
    }
  }

  dynamic "sms_configuration" {
    for_each = var.sms_configuration == null ? [] : [1]
    content {
      external_id    = var.sms_configuration.external_id
      sns_caller_arn = var.sms_configuration.sns_caller_arn
    }
  }

  dynamic "password_policy" {
    for_each = var.password_policy == null ? [] : [1]
    content {
      minimum_length                   = var.password_policy.minimum_length
      require_lowercase                = var.password_policy.require_lowercase
      require_numbers                  = var.password_policy.require_numbers
      require_symbols                  = var.password_policy.require_symbols
      require_uppercase                = var.password_policy.require_uppercase
      temporary_password_validity_days = var.password_policy.temporary_password_validity_days
    }
  }

  dynamic "schema" {
    for_each = var.schemas == null ? [] : var.schemas
    content {
      name                     = schema.value.name
      attribute_data_type      = schema.value.attribute_data_type
      required                 = schema.value.required
      developer_only_attribute = schema.value.developer_only_attribute
      mutable                  = schema.value.mutable
    }
  }

  dynamic "schema" {
    for_each = var.string_schemas == null ? [] : var.string_schemas
    iterator = string_schema
    content {
      attribute_data_type      = "String"
      developer_only_attribute = string_schema.value.developer_only_attribute
      mutable                  = string_schema.value.mutable
      name                     = string_schema.value.name
      required                 = string_schema.value.required
      string_attribute_constraints {
        min_length = string_schema.value.string_attribute_constraints.min_length
        max_length = string_schema.value.string_attribute_constraints.max_length
      }
    }
  }

  dynamic "schema" {
    for_each = var.number_schemas == null ? [] : var.number_schemas
    iterator = number_schema
    content {
      attribute_data_type      = number_schema.value.attribute_data_type
      developer_only_attribute = number_schema.value.developer_only_attribute
      mutable                  = number_schema.value.mutable
      name                     = number_schema.value.name
      required                 = number_schema.value.required
      number_attribute_constraints {
        min_value = number_schema.number_attribute_constraints.min_value
        max_value = number_schema.number_attribute_constraints.max_value
      }
    }
  }

  dynamic "user_pool_add_ons" {
    for_each = var.user_pool_add_ons == null ? [] : [1]
    content {
      advanced_security_mode = var.user_pool_add_ons.advanced_security_mode
    }
  }

  dynamic "verification_message_template" {
    for_each = var.verification_message_template == null ? [] : [1]
    content {
      default_email_option  = var.verification_message_template.default_email_option
      email_message         = var.verification_message_template.email_message
      email_message_by_link = var.verification_message_template.email_message_by_link
      email_subject         = var.verification_message_template.email_subject
      email_subject_by_link = var.verification_message_template.email_subject_by_link
      sms_message           = var.verification_message_template.sms_message
    }
  }

  dynamic "account_recovery_setting" {
    for_each = var.account_recovery_setting == 0 ? [] : [1]
    content {
      dynamic "recovery_mechanism" {
        for_each = var.account_recovery_setting.recovery_mechanism == null ? [] : var.account_recovery_setting.recovery_mechanism
        content {
          name     = recovery_mechanism.value.name
          priority = recovery_mechanism.value.priority
        }
      }
    }
  }

  tags = var.tags
}
