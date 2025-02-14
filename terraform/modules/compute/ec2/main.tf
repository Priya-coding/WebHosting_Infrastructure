# EC2 Instances Module for Web Hosting Infrastructure

resource "aws_instance" "ec2_instances" {
  count = length(var.instance_config)

  ami           = var.instance_config[count.index].ami
  instance_type = var.instance_config[count.index].instance_type
  subnet_id     = element(var.subnets, count.index)

  # Spot instance configuration
  instance_lifecycle = "spot"

  tags = merge(
    var.tags,
    {
      Name = "ec2-spot-instance-${count.index}"
    }
  )
}

# Outputs
output "ec2_instance_ids" {
  description = "List of EC2 instance IDs."
  value       = aws_instance.ec2_instances[*].id
}

output "ec2_private_ips" {
  description = "List of private IPs for the EC2 instances."
  value       = aws_instance.ec2_instances[*].private_ip
}

output "ec2_spot_instance_requests" {
  description = "List of Spot Instance requests."
  value       = aws_instance.ec2_instances[*].spot_instance_request_id
}
