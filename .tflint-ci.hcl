plugin "terraform" {
  enabled = true
  preset  = "recommended"
}
plugin "aws" {
  enabled = true
  deep_check = false
  version = "0.37.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "terraform_deprecated_interpolation" {
  enabled = true
}
rule "terraform_deprecated_index" {
  enabled = true
}
rule "terraform_unused_declarations" {
  enabled = true
}
rule "terraform_comment_syntax" {
  enabled = true
}
rule "terraform_documented_outputs" {
  enabled = true
}
rule "terraform_documented_variables" {
  enabled = true
}
rule "terraform_typed_variables" {
  enabled = true
}
rule "terraform_module_pinned_source" {
  enabled = true
}
rule "terraform_naming_convention" {
  enabled = true
}
rule "terraform_required_version" {
  enabled = true
}
rule "terraform_required_providers" {
  enabled = true
}
rule "terraform_standard_module_structure" {
  enabled = false
}
rule "terraform_workspace_remote" {
  enabled = true
}
rule "aws_acm_certificate_lifecycle" {
  enabled = false
}