
resource "aws_instance" "app" {
  count = var.instance_count

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private[count.index].id
  vpc_security_group_ids = [aws_security_group.app.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2.name

  key_name = var.key_name

  associate_public_ip_address = false


  user_data = templatefile(
    "${path.module}/user-data/bootstrap.sh.tftpl",
    {
      app_bucket = aws_s3_bucket.app_artifacts.bucket
      app_prefix = "release"
    }
  )


  user_data_replace_on_change = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
    volume_size = 12
  }

  tags = {
    Name = "${var.project_name}-app-${count.index + 1}"
  }

  depends_on = [
    aws_route.private_nat,
    aws_iam_role_policy_attachment.ssm
  ]

  lifecycle {
    precondition {
      condition = contains(
        data.aws_availability_zones.available.names,
        local.azs[count.index]
      )
      error_message = "The selected Availability Zone is unavailable."
    }
  }
}
