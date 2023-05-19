resource "aws_cognito_user_pool_client" "client" {
  count = var.enabled ? length(var.clients) : 0

  allowed_oauth_flows                  = var.clients[count.index].allowed_oauth_flows
  allowed_oauth_flows_user_pool_client = var.clients[count.index].allowed_oauth_flows_user_pool_client
  allowed_oauth_scopes                 = var.clients[count.index].allowed_oauth_scopes
  callback_urls                        = var.clients[count.index].callback_urls
  default_redirect_uri                 = var.clients[count.index].default_redirect_uri
  explicit_auth_flows                  = var.clients[count.index].explicit_auth_flows
  generate_secret                      = var.clients[count.index].generate_secret
  logout_urls                          = var.clients[count.index].logout_urls
  name                                 = var.clients[count.index].name
  read_attributes                      = var.clients[count.index].read_attributes
  supported_identity_providers         = var.clients[count.index].supported_identity_providers
  prevent_user_existence_errors        = var.clients[count.index].prevent_user_existence_errors
  write_attributes                     = var.clients[count.index].write_attributes
  enable_token_revocation              = var.clients[count.index].enable_token_revocation
  user_pool_id                         = aws_cognito_user_pool.pool[0].id

  dynamic "token_validity_units" {
    for_each = var.clients[count.index].token_validity_units == null ? [] : [1]
    content {
      access_token  = var.clients[count.index].token_validity_units.access_token
      id_token      = var.clients[count.index].token_validity_units.id_token
      refresh_token = var.clients[count.index].token_validity_units.refresh_token
    }
  }

  depends_on = [
    aws_cognito_resource_server.resource,
    aws_cognito_identity_provider.identity_provider
  ]
}
