resource "aws_iam_role" "github_actions" {
  name = "github-actions-ecs-deployer"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        # considire use :ref:refs/heads/main (suffix) to restrict to main branch only
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:RefaelR92/checkpoint-home-assignment:*"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "github_actions_ecr" {
  role = aws_iam_role.github_actions.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
        Resource = [
          "arn:aws:ecr:us-east-2:114118973103:repository/home-assign/service-1-api",
          "arn:aws:ecr:us-east-2:114118973103:repository/home-assign/service-2-worker"
        ]
      }
    ]
  })
}


resource "aws_iam_role_policy" "github_actions_ecs_deploy" {
  role = aws_iam_role.github_actions.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:UpdateService",
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition"
        ]
        Resource = [
          "arn:aws:ecs:us-east-2:114118973103:service/home-assign-ecs/api",
          "arn:aws:ecs:us-east-2:114118973103:service/home-assign-ecs/worker"
        ]
      }
    ]
  })
}

