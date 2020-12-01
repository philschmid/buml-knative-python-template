provider "google" {
  project = "cloud-run-template-297215"
  credentials =  file("~/.gcloud/cloud-run-template-2bc114a998f8.json") 
}

resource "google_cloud_run_service" "default" {
  name     = "hello-world-tf"
  location = "europe-west1"

  metadata {
    annotations = {
      "run.googleapis.com/client-name"   = "terraform"
      "autoscaling.knative.dev/maxScale" = "1000"
    }
  }

  template {
    spec {
      timeout_seconds = 300
      containers {
        image = "gcr.io/cloudrun-hello-go/hello"
        resources {
          limits = {
            cpu    = "1"
            memory = "512Mi"
          }
        }
        env {
          name  = "SOURCE"
          value = "remote"
        }
        env {
          name  = "TARGET"
          value = "home"
        }
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
  autogenerate_revision_name = true
}

data "google_iam_policy" "noauth" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.default.location
  project  = google_cloud_run_service.default.project
  service  = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}