
locals {
  app_hostname = "${var.app_subdomain}.${var.domain_name}"

  azs = slice(
    data.aws_availability_zones.available.names,
    0,
    3
  )

  categories = {
    clothing = {
      priority = 10
      health   = "/health"
    }

    electronics = {
      priority = 20
      health   = "/health"
    }

    home = {
      priority = 30
      health   = "/health"
    }
  }

  all_target_group_arns = merge(
    {
      storefront = aws_lb_target_group.storefront.arn
    },
    {
      for name, group in aws_lb_target_group.category :
      name => group.arn
    }
  )

  target_registrations = flatten([
    for group_name, group_arn in local.all_target_group_arns : [
      for index, instance in aws_instance.app : {
        key              = "${group_name}-${index}"
        target_group_arn = group_arn
        instance_id      = instance.id
      }
    ]
  ])
}
