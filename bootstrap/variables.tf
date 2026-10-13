variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "team_id" {
  description = "The team ID"
  type        = number
}

variable "github_repositories" {
  description = "GitHub repositories in 'owner/repo' format allowed to authenticate via WIF"
  type        = set(string)
}

variable "os_admin_users" {
  description = "Google identities granted IAP tunnel access by privileged bootstrap"
  type        = set(string)
  default = [
    "dennis.heimbert@chasacademy.se",
    "fajk.zhupa@chasacademy.se",
    "jonny.nguyen@chasacademy.se",
    "lars.torngren@chasacademy.se",
    "tim.rundquist@chasacademy.se",
    "willibroad.ngebi@chasacademy.se",
  ]
}
