resource "aws_cognito_resource_server" "resource" {
  count = var.enabled ? length(var.resource_servers) : 0

  name       = var.resource_servers[count.index].name
  identifier = var.resource_servers[count.index].identifier

  dynamic "scope" {
    for_each = var.resource_servers[count.index].scopes
    content {
      scope_name        = scope.value.scope_name
      scope_description = scope.value.scope_description
    }
  }

  user_pool_id = aws_cognito_user_pool.pool[0].id
}
