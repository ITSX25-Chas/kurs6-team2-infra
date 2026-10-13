# Project-level IAM is managed by the privileged bootstrap configuration.
# Forget the existing bindings here without deleting them from Google Cloud.
removed {
  from = google_project_iam_member.iap_tunnel_access

  lifecycle {
    destroy = false
  }
}
