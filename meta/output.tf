# Output Block

output "ec2-arn" {
  value = aws_instance.my-ec2[*].arn
}