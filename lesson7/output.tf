#output tf file
#output instance id
output "webserver_instance_id" {
  value = aws_instance.webserver7.id
}
#output public ip
output "webserver_public_ip_address" {
  value = aws_eip.static_ip.public_ip
}
#output security group id
output "webserver_sg_id" {
  value = aws_security_group.webserver7_sec.id
}
#output security group arn
output "webserver_sg_arn" {
  value       = aws_security_group.webserver7_sec.arn
  description = "this is security arn"
}
