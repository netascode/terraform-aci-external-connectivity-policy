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

  name         = "EXT-POL1"
  route_target = "extended:as2-nn4:5:17"
  fabric_id    = 1
  site_id      = 2
  bgp_password = "SECRETPW"
  routing_profiles = [{
    name        = "PROF1"
    description = "My Description"
    subnets     = ["10.0.0.0/24"]
  }]
  data_plane_teps = [{
    pod_id = 5
    ip     = "11.1.1.11"
  }]
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

  equal "id" {
    description = "id"
    got         = data.aci_rest.fvFabricExtConnP.content.id
    want        = "1"
  }

  equal "rt" {
    description = "rt"
    got         = data.aci_rest.fvFabricExtConnP.content.rt
    want        = "extended:as2-nn4:5:17"
  }

  equal "siteId" {
    description = "siteId"
    got         = data.aci_rest.fvFabricExtConnP.content.siteId
    want        = "2"
  }
}

data "aci_rest" "fvPeeringP" {
  dn = "${data.aci_rest.fvFabricExtConnP.id}/peeringP"

  depends_on = [module.main]
}

resource "test_assertions" "fvPeeringP" {
  component = "fvPeeringP"

  equal "type" {
    description = "type"
    got         = data.aci_rest.fvPeeringP.content.type
    want        = "automatic_with_full_mesh"
  }
}

data "aci_rest" "l3extFabricExtRoutingP" {
  dn = "${data.aci_rest.fvFabricExtConnP.id}/fabricExtRoutingP-PROF1"

  depends_on = [module.main]
}

resource "test_assertions" "l3extFabricExtRoutingP" {
  component = "l3extFabricExtRoutingP"

  equal "name" {
    description = "name"
    got         = data.aci_rest.l3extFabricExtRoutingP.content.name
    want        = "PROF1"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest.l3extFabricExtRoutingP.content.descr
    want        = "My Description"
  }
}

data "aci_rest" "l3extSubnet" {
  dn = "${data.aci_rest.l3extFabricExtRoutingP.id}/extsubnet-[10.0.0.0/24]"

  depends_on = [module.main]
}

resource "test_assertions" "l3extSubnet" {
  component = "l3extSubnet"

  equal "ip" {
    description = "ip"
    got         = data.aci_rest.l3extSubnet.content.ip
    want        = "10.0.0.0/24"
  }

  equal "scope" {
    description = "scope"
    got         = data.aci_rest.l3extSubnet.content.scope
    want        = "import-security"
  }
}

data "aci_rest" "fvPodConnP" {
  dn = "${data.aci_rest.fvFabricExtConnP.id}/podConnP-5"

  depends_on = [module.main]
}

resource "test_assertions" "fvPodConnP" {
  component = "fvPodConnP"

  equal "id" {
    description = "id"
    got         = data.aci_rest.fvPodConnP.content.id
    want        = "5"
  }
}

data "aci_rest" "fvIp" {
  dn = "${data.aci_rest.fvPodConnP.id}/ip-[11.1.1.11]"

  depends_on = [module.main]
}

resource "test_assertions" "fvIp" {
  component = "fvIp"

  equal "addr" {
    description = "addr"
    got         = data.aci_rest.fvIp.content.addr
    want        = "11.1.1.11"
  }
}
