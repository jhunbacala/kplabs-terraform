# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"  # You can change this to your preferred region
}

# Create IAM User
resource "aws_iam_user" "admin_user" {
  name = "admin-user"  # Change this to your desired username
  path = "/"

  tags = {
    Name        = "Admin User"
    Environment = "Production"
  }
}

# Create Admin Group (or use existing one)
resource "aws_iam_group" "admin_group" {
  name = "Administrators"
  path = "/"
}

# Attach AdministratorAccess policy to the group
resource "aws_iam_group_policy_attachment" "admin_policy" {
  group      = aws_iam_group.admin_group.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Add user to admin group
resource "aws_iam_group_membership" "admin_team" {
  name = "admin-group-membership"

  users = [
    aws_iam_user.admin_user.name
  ]

  group = aws_iam_group.admin_group.name
}

# Optional: Create login profile (if you want console access)
resource "aws_iam_user_login_profile" "admin_profile" {
  user    = aws_iam_user.admin_user.name
  pgp_key = "keybase:some_keybase_user"  # Replace with your PGP key or remove this line
  password_reset_required = true
}

# Optional: Create access keys (if you need programmatic access)
resource "aws_iam_access_key" "admin_key" {
  user = aws_iam_user.admin_user.name
}

# Output the access key ID and secret (be careful with these in production)
output "access_key_id" {
  value     = aws_iam_access_key.admin_key.id
  sensitive = true
}

output "secret_access_key" {
  value     = aws_iam_access_key.admin_key.secret
  sensitive = true
}