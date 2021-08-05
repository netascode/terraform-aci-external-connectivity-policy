terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "netascode/aci"
      version = ">=0.2.0"
    }
  }
}

module "main" {
  source = "../.."

  name = "EXT-POL1"
}

data "aci_rest" "fvFabricExtConnP" {
  dn = "uni/tn-infra/fabricExtConnP-1"

  depends_on = [module.main]
}

resource "test_assertions" "fvFabricExtConnP" {
  component = "fvFabricExtConnP"

  equal "name" {
    description = "name"
    got         = data.aci_rest.fvFabricExtConnP.content.name
    want        = module.main.name
  }
}
