output "website_url" {
  value = "http://${module.alb_system.public_alb_dns}"
}