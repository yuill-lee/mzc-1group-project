# Hosted Zone 생성
resource "aws_route53_zone" "route53_zone" {
    name = "mzcg1u1.click"

    tags = { Name = "mzcg1u1-Hosted-Zone" }
}

resource "aws_route53_record" "rds_endpoint_dns" {
    zone_id = aws_route53_zone.route53_zone.id
    name = "db.${aws_route53_zone.route53_zone.name}"
    type = "CNAME"
    ttl = "300"

    records = [var.rds_endpoint]
}