
output "rg_role_assignments" {
  value = {
    for ra in azurerm_role_assignment.role_assignments :
    ra.id => {
      id                 = ra.id
      role_definition_id = ra.role_definition_id
      principal_id       = ra.principal_id
      scope              = ra.scope
    }
  }
}

