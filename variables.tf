variable "project" {
  type        = string
  description = "Google Cloud project ID."
  default     = "example-project"
  nullable    = false
}

variable "location" {
  type        = string
  description = "Google Cloud region."
  nullable    = false
  default     = "us-central-1"

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "The location must not be empty."
  }
}

variable "replicas" {
  type        = number
  description = "Number of virtual machines."
  nullable    = false
  default     = 2

  validation {
    condition     = var.replicas >= 0 && var.replicas == floor(var.replicas)
    error_message = "Replicas must be a non-negative integer."
  }
}

variable "enableExternalIP" {
  type        = bool
  description = "Reserve an external IP address for each instance, exposing them to the internet."
  default     = true
}
