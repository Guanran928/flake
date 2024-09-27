output "nodes" {
  value = merge(module.vultr, module.aws)
}
