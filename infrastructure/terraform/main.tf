terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # PREREQUISITE: Create this S3 bucket manually (with versioning enabled)
  # before running `terraform init` for the first time:
  #   aws s3api create-bucket --bucket academyapp-terraform-state --region us-east-1
  #   aws s3api put-bucket-versioning \
  #     --bucket academyapp-terraform-state \
  #     --versioning-configuration Status=Enabled
  backend "s3" {
    bucket = "academyapp-terraform-state"
    key    = "infra/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

# ─── VPC ────────────────────────────────────────────────────────────────────

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet("10.0.0.0/16", 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-public-${count.index}"
    Environment = var.environment
  }
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet("10.0.0.0/16", 8, count.index + 10)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name        = "${var.project_name}-private-${count.index}"
    Environment = var.environment
  }
}

data "aws_availability_zones" "available" {}

# ─── Security Groups ─────────────────────────────────────────────────────────

resource "aws_security_group" "api" {
  name        = "${var.project_name}-api-sg"
  description = "Security group for the API service"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    # Restrict to known CIDR ranges (e.g. load balancer or VPN). Defaults to
    # VPC CIDR so the API is not directly exposed to the public internet.
    cidr_blocks = [var.api_ingress_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-api-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "db" {
  name        = "${var.project_name}-db-sg"
  description = "Security group for the PostgreSQL database"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.api.id]
  }

  tags = {
    Name        = "${var.project_name}-db-sg"
    Environment = var.environment
  }
}

# ─── RDS (PostgreSQL) ────────────────────────────────────────────────────────

resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name        = "${var.project_name}-db-subnet-group"
    Environment = var.environment
  }
}

resource "aws_db_instance" "main" {
  identifier        = "${var.project_name}-db"
  engine            = "postgres"
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  allocated_storage = 20
  storage_encrypted = true

  db_name  = "academyapp_db"
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]

  backup_retention_period = 7
  skip_final_snapshot     = var.environment != "production"

  tags = {
    Name        = "${var.project_name}-db"
    Environment = var.environment
  }
}

# ─── ElastiCache (Redis) ─────────────────────────────────────────────────────

resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.project_name}-cache-subnet-group"
  subnet_ids = aws_subnet.private[*].id
}

resource "aws_elasticache_cluster" "main" {
  cluster_id           = "${var.project_name}-cache"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  engine_version       = var.redis_engine_version
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.main.name

  tags = {
    Name        = "${var.project_name}-cache"
    Environment = var.environment
  }
}
