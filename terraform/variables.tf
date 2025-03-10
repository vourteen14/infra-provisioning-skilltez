variable "project_id" {
  type        = string
  default     = "angga-suriana"
}

variable "region" {
  type        = string
  default     = "asia-southeast2"
}

variable "zone" {
  type        = string
  default     = "asia-southeast2-a"
}

variable "namespaces" {
  type        = list(string)
  default     = ["airbyte", "emissary", "cert-manager"]
}