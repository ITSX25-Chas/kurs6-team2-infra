terraform {
  backend "gcs" {
    bucket = "itsx25-comerit-team2-tfstate"
    prefix = "terraform/state"
  }
}
