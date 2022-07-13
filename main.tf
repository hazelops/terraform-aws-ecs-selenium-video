data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  global_secrets = concat(var.app_secrets, [
  ])

  environment = merge(var.environment, {}
  )

  container_definition = {
    name                 = var.name
    image                = "${var.docker_image_name}:${var.docker_image_tag}",
    memoryReservation    = 128,
    essential            = true,
    resourceRequirements = var.resource_requirements

    environment = [
      for k, v in local.environment : {
        name  = k,
        value = v
      }
    ]

    secrets = [
      for param_name in local.global_secrets :
      {
        name      = param_name
        valueFrom = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.env}/global/${param_name}"
      }
    ]


    logConfiguration = var.cloudwatch_log_group == "" ? {
      logDriver = "json-file"
      options   = {}
      } : {
      logDriver = "awslogs",
      options = {
        awslogs-group         = var.cloudwatch_log_group
        awslogs-region        = data.aws_region.current.name
        awslogs-stream-prefix = var.name
      }
    }
  }

  volumes = concat(var.ecs_launch_type == "FARGATE" ? [] : [
    {
      name      = "videos"
      host_path = "/videos"
    }
    ]
  )

}
