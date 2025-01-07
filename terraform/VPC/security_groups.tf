resource "aws_security_group" "main" {
  name        = "SG-${var.suffix}"
  description = "Allow inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    { Name = "main_sg" },
    local.tags
  )
}
resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  tags = merge(
    { Name = "HTTPS" },
    local.tags
  )
}
resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  tags = merge(
    { Name = "HTTP" },
    local.tags
  )
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
  tags = merge(
    { Name = "INTERNET" },
    local.tags
  )
}
