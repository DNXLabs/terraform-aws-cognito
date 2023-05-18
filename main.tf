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
      dynamic "invate_message_template" {
        for_each = var.admin_create_user_config.invite_template == null ? [] : [1]
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

  email_configuration {
    configuration_set      = try(var.email_configuration.configuration_set, null)
    reply_to_email_address = try(var.email_configuration.reply_to_email_address, null)
    source_arn             = try(var.email_configuration.source_arn, null)
    email_sending_account  = try(var.email_configuration.email_sending_account, null)
    from_email_address     = try(var.email_configuration.from_email_address, null)
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
    for_each = local.password_policy
    content {
      minimum_length                   = lookup(password_policy.value, "minimum_length")
      require_lowercase                = lookup(password_policy.value, "require_lowercase")
      require_numbers                  = lookup(password_policy.value, "require_numbers")
      require_symbols                  = lookup(password_policy.value, "require_symbols")
      require_uppercase                = lookup(password_policy.value, "require_uppercase")
      temporary_password_validity_days = lookup(password_policy.value, "temporary_password_validity_days")
    }
  }

  dynamic "schema" {
    for_each = var.schemas == null ? [] : var.schemas
    content {
      attribute_data_type      = lookup(schema.value, "attribute_data_type")
      developer_only_attribute = lookup(schema.value, "developer_only_attribute")
      mutable                  = lookup(schema.value, "mutable")
      name                     = lookup(schema.value, "name")
      required                 = lookup(schema.value, "required")
    }
  }

  dynamic "schema" {
    for_each = var.string_schemas == null ? [] : var.string_schemas
    content {
      attribute_data_type      = lookup(schema.value, "attribute_data_type")
      developer_only_attribute = lookup(schema.value, "developer_only_attribute")
      mutable                  = lookup(schema.value, "mutable")
      name                     = lookup(schema.value, "name")
      required                 = lookup(schema.value, "required")

      dynamic "string_attribute_constraints" {
        for_each = length(lookup(schema.value, "string_attribute_constraints")) == 0 ? [] : [lookup(schema.value, "string_attribute_constraints", {})]
        content {
          min_length = lookup(string_attribute_constraints.value, "min_length", 0)
          max_length = lookup(string_attribute_constraints.value, "max_length", 0)
        }
      }
    }
  }

  dynamic "schema" {
    for_each = var.number_schemas == null ? [] : var.number_schemas
    content {
      attribute_data_type      = lookup(schema.value, "attribute_data_type")
      developer_only_attribute = lookup(schema.value, "developer_only_attribute")
      mutable                  = lookup(schema.value, "mutable")
      name                     = lookup(schema.value, "name")
      required                 = lookup(schema.value, "required")

      dynamic "number_attribute_constraints" {
        for_each = length(lookup(schema.value, "number_attribute_constraints")) == 0 ? [] : [lookup(schema.value, "number_attribute_constraints", {})]
        content {
          min_value = lookup(number_attribute_constraints.value, "min_value", 0)
          max_value = lookup(number_attribute_constraints.value, "max_value", 0)
        }
      }
    }
  }

  dynamic "user_pool_add_ons" {
    for_each = local.user_pool_add_ons
    content {
      advanced_security_mode = lookup(user_pool_add_ons.value, "advanced_security_mode")
    }
  }

  verification_message_template {
    default_email_option  = try(var.verification_message_template.default_email_option, null)
    email_message         = try(var.verification_message_template.email_message, null)
    email_message_by_link = try(var.verification_message_template.email_message_by_link, null)
    email_subject         = try(var.verification_message_template.email_subject, null)
    email_subject_by_link = try(var.verification_message_template.email_subject_by_link, null)
    sms_message           = try(var.verification_message_template.sms_message, null)

  }

  dynamic "account_recovery_setting" {
    for_each = length(var.recovery_mechanisms) == 0 ? [] : [1]
    content {
      dynamic "recovery_mechanism" {
        for_each = var.recovery_mechanisms
        content {
          name     = lookup(recovery_mechanism.value, "name")
          priority = lookup(recovery_mechanism.value, "priority")
        }
      }
    }
  }

  # tags
  tags = var.tags
}

locals {
  device_configuration_default = {
    challenge_required_on_new_device      = lookup(var.device_configuration, "challenge_required_on_new_device", null) == null ? var.device_configuration_challenge_required_on_new_device : lookup(var.device_configuration, "challenge_required_on_new_device")
    device_only_remembered_on_user_prompt = lookup(var.device_configuration, "device_only_remembered_on_user_prompt", null) == null ? var.device_configuration_device_only_remembered_on_user_prompt : lookup(var.device_configuration, "device_only_remembered_on_user_prompt")
  }

  device_configuration = lookup(local.device_configuration_default, "challenge_required_on_new_device") == false && lookup(local.device_configuration_default, "device_only_remembered_on_user_prompt") == false ? [] : [local.device_configuration_default]

  password_policy_is_null = {
    minimum_length                   = var.password_policy_minimum_length
    require_lowercase                = var.password_policy_require_lowercase
    require_numbers                  = var.password_policy_require_numbers
    require_symbols                  = var.password_policy_require_symbols
    require_uppercase                = var.password_policy_require_uppercase
    temporary_password_validity_days = var.password_policy_temporary_password_validity_days
  }

  password_policy_not_null = var.password_policy == null ? local.password_policy_is_null : {
    minimum_length                   = lookup(var.password_policy, "minimum_length", null) == null ? var.password_policy_minimum_length : lookup(var.password_policy, "minimum_length")
    require_lowercase                = lookup(var.password_policy, "require_lowercase", null) == null ? var.password_policy_require_lowercase : lookup(var.password_policy, "require_lowercase")
    require_numbers                  = lookup(var.password_policy, "require_numbers", null) == null ? var.password_policy_require_numbers : lookup(var.password_policy, "require_numbers")
    require_symbols                  = lookup(var.password_policy, "require_symbols", null) == null ? var.password_policy_require_symbols : lookup(var.password_policy, "require_symbols")
    require_uppercase                = lookup(var.password_policy, "require_uppercase", null) == null ? var.password_policy_require_uppercase : lookup(var.password_policy, "require_uppercase")
    temporary_password_validity_days = lookup(var.password_policy, "temporary_password_validity_days", null) == null ? var.password_policy_temporary_password_validity_days : lookup(var.password_policy, "temporary_password_validity_days")

  }

  password_policy = var.password_policy == null ? [local.password_policy_is_null] : [local.password_policy_not_null]

  user_pool_add_ons_default = {
    advanced_security_mode = lookup(var.user_pool_add_ons, "advanced_security_mode", null) == null ? var.user_pool_add_ons_advanced_security_mode : lookup(var.user_pool_add_ons, "advanced_security_mode")
  }

  user_pool_add_ons = var.user_pool_add_ons_advanced_security_mode == null && length(var.user_pool_add_ons) == 0 ? [] : [local.user_pool_add_ons_default]

  # software_token_mfa_configuration_default = {
  #   enabled = lookup(var.software_token_mfa_configuration, "enabled", null) == null
  #               ? var.software_token_mfa_configuration_enabled
  #               : lookup(var.software_token_mfa_configuration, "enabled")
  # }

  # mfa_configuration = (var.sms_configuration == null || var.software_token_mfa_configuration == null) ?
  # software_token_mfa_configuration = (length(var.sms_configuration) == 0 || local.sms_configuration == null)
  #                                   && var.mfa_configuration == "OFF"
  #                                     ? []
  #                                     : [local.software_token_mfa_configuration_default]

}
