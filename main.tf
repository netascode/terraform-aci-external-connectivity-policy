locals {
  subnet_list = flatten([
    for prof in var.routing_profiles : [
      for subnet in lookup(prof, "subnets", []) : {
        id      = "${prof.name}-${subnet}"
        profile = prof.name
        subnet  = subnet
      }
    ]
  ])
}

resource "aci_rest" "fvFabricExtConnP" {
  dn         = "uni/tn-infra/fabricExtConnP-${var.fabric_id}"
  class_name = "fvFabricExtConnP"
  content = {
    id     = var.fabric_id
    name   = var.name
    rt     = var.route_target
    siteId = var.site_id
  }
}

resource "aci_rest" "fvPeeringP" {
  dn         = "${aci_rest.fvFabricExtConnP.id}/peeringP"
  class_name = "fvPeeringP"
  content = {
    type     = "automatic_with_full_mesh"
    password = var.bgp_password
  }

  lifecycle {
    ignore_changes = [content["password"]]
  }
}

resource "aci_rest" "l3extFabricExtRoutingP" {
  for_each   = { for profile in var.routing_profiles : profile.name => profile }
  dn         = "${aci_rest.fvFabricExtConnP.id}/fabricExtRoutingP-${each.value.name}"
  class_name = "l3extFabricExtRoutingP"
  content = {
    name  = each.value.name
    descr = each.value.description
  }
}

resource "aci_rest" "l3extSubnet" {
  for_each   = { for subnet in local.subnet_list : subnet.id => subnet }
  dn         = "${aci_rest.l3extFabricExtRoutingP[each.value.profile].id}/extsubnet-[${each.value.subnet}]"
  class_name = "l3extSubnet"
  content = {
    ip    = each.value.subnet
    scope = "import-security"
  }
}

resource "aci_rest" "fvPodConnP" {
  for_each   = { for tep in var.data_plane_teps : tep.pod => tep }
  dn         = "${aci_rest.fvFabricExtConnP.id}/podConnP-${each.value.pod}"
  class_name = "fvPodConnP"
  content = {
    id = each.value.pod
  }
}

resource "aci_rest" "fvIp" {
  for_each   = { for tep in var.data_plane_teps : tep.pod => tep }
  dn         = "${aci_rest.fvPodConnP[each.value.pod].id}/ip-[${each.value.ip}]"
  class_name = "fvIp"
  content = {
    addr = each.value.ip
  }
}
