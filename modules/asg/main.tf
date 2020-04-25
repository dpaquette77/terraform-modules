resource "aws_launch_configuration" "lc" {
    image_id = var.ami
    instance_type = var.instance_type
    user_data = var.user_data
    lifecycle {
        create_before_destroy = true
    }
    security_groups = [aws_security_group.instance_sg.id]
}

resource "aws_autoscaling_group" "asg" {
    name = "asg-${aws_launch_configuration.lc.name}"
    launch_configuration = aws_launch_configuration.lc.id
    min_size = var.min_size
    max_size = var.max_size
    desired_capacity = var.desired_capacity
    vpc_zone_identifier = var.subnet_ids
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_security_group" "instance_sg" {
    name = "asg_instance_sg"
    description = "security group used for all instances of the asg"
    vpc_id = var.vpc_id

    ingress {
        description = "allow ${var.port} from anywhere"
        from_port   = var.port
        to_port     = var.port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow-${var.port}-from-anywhere"
    }
}