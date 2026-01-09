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

