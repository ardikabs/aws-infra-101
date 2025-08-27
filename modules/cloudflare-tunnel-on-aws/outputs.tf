output "container_definition" {
  value = try(module.ecs_deployment[0].container_definition, "No container definition found")
}
