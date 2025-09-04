resource "aws_lb_target_group" "app" {
  name_prefix = "app-"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"

  health_check { path = "/" }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = module.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}


resource "aws_autoscaling_attachment" "asg_to_tg" {
  autoscaling_group_name = module.asg.autoscaling_group_name
  lb_target_group_arn    = aws_lb_target_group.app.arn
}
