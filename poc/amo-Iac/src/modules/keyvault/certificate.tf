#####************************* create certificate and assigned into azure keyvault *****************######### 
#https://azure.github.io/AppService/2016/05/24/Deploying-Azure-Web-App-Certificate-through-Key-Vault.html

resource "azurerm_key_vault_certificate" "certificate" {
    count = var.createSslCertificate ? 1 : 0
  name         = "generated-cert"
  key_vault_id = azurerm_key_vault.keyvault.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = var.action_type
      }

      trigger {
        days_before_expiry = var.days_before_expiry
      }
    }

    secret_properties {
      content_type = var.content_type
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject_alternative_names {
        dns_names = var.dns_names
      }

      subject            = var.subject
      validity_in_months = 12
    }
  }
}
