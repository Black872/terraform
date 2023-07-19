output "latest_ubuntu_ami_id" {
  value = data.aws_ami.latest_ubuntu.id
}

output "latest_ubuntu_ami_name" {
  value = data.aws_ami.latest_ubuntu.name
}

output "latest_amazon_linux_ami_id" {
  value = data.aws_ami.latest_amazon_linux.id
}

output "latest_amazon_linux_ami_name" {
  value = data.aws_ami.latest_amazon_linux.name
}

output "latest_windows_server_ami_id" {
  value = data.aws_ami.latest_windows_server.id
}

output "latest_windows_server_ami_name" {
  value = data.aws_ami.latest_windows_server.name
}
