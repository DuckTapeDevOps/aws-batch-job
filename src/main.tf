resource "aws_batch_compute_environment" "g5_4xlarge" {
  type                = "MANAGED"
  compute_environment_name = "g5_4xlarge_compute_environment"
  state                = "ENABLED"
  service_role         = aws_iam_role.batch_service_role.arn
  compute_resources {
    instance_role     = aws_iam_instance_profile.batch_instance_profile.arn
    instance_types    = ["g5.4xlarge", "g5.2xlarge"]
    max_vcpus         = 48
    min_vcpus         = 0
    security_group_ids = [aws_security_group.g5_4xlarge_security_group.id]
    subnets           = [for subnet in var.private_subnets : subnet.arn]
    type              = "SPOT"
    bid_percentage     = 100
    tags = {
      "Environment" = "Ephemeral"
    }
  }
}

resource "aws_batch_job_definition" "stable_diffusion" {
  name = "stable_diffusion_job_definition"
  type = "container"

   container_properties = data.template_file.stable_diffusion_container_properties.rendered
}

resource "aws_batch_job_queue" "g5_4xlarge_job_queue" {
  name = "g5_4xlarge_job_queue"
  state = "ENABLED"
  priorities = [1]
  compute_environments = [aws_batch_compute_environment.g5_4xlarge.arn]
}

data "template_file" "stable_diffusion_container_properties" {
  template = file("${path.module}/sdxl_container_properties.json")
}