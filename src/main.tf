resource "aws_batch_compute_environment" "g5_2xlarge" {
  type                = "MANAGED"
  compute_environment_name = "g5_2xlarge_compute_environment"
  state                = "ENABLED"
  service_role         = aws_iam_role.batch_service_role.arn
  type                 = "MANAGED"
  compute_resources {
    instance_role     = aws_iam_instance_profile.batch_instance_profile.arn
    instance_types    = ["g5.2xlarge"]
    max_vcpus         = 32
    min_vcpus         = 0
    security_group_ids = [aws_security_group.g5_2xlarge_security_group.id]
    subnets           = aws_subnet.g5_2xlarge_subnet.*.id
    type              = "EC2"
  }
}

resource "aws_batch_job_definition" "stable_diffusion" {
  name = "stable_diffusion_job_definition"
  type = "container"

  container_properties = jsonencode({
    image = "${data.aws_ecr_repository.huggingface.repository_url}:latest"
    vcpus = 4
    memory = 30088
    command = ["stable_diffusion"]
  })
}

resource "aws_batch_job_queue" "g5_2xlarge_job_queue" {
  name = "g5_2xlarge_job_queue"
  state = "ENABLED"
  priorities = [1]
  compute_environments = [aws_batch_compute_environment.g5_2xlarge.arn]
}

resource "aws_batch_job" "run_stable_diffusion" {
  job_name = "run_stable_diffusion"
  job_queue = aws_batch_job_queue.g5_2xlarge_job_queue.name
  job_definition = aws_batch_job_definition.stable_diffusion.arn
  depends_on = [aws_batch_job_definition.stable_diffusion]
}