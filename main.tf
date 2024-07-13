provider "netbox" {
  server_url = var.nb_address
  api_token  = var.nb_token
}

provider "cml2" {
  address  = var.cml_address
  username = var.cml_user
  password = var.cml_pass
  skip_verify = true
}

provider "http" {}

data "netbox_devices" "nb_devices" {}

data "netbox_site" "nb_sites" {
 for_each = {for device in data.netbox_devices.nb_devices.devices: device.site_id => device.site_id...}
 id = each.key
}

data "http" "nb_configs" {
 for_each = {for device in data.netbox_devices.nb_devices.devices: device.device_id => device.device_id}
 url = "${var.nb_address}/api/dcim/devices/${each.key}/render-config/"
 method = "POST"
 request_headers = {
  Authorization = "Token ${var.nb_token}"
 }
}

data "http" "nb_cables" {
 url = "${var.nb_address}/api/dcim/cables/"
 method = "GET"
 request_headers = {
  Authorization = "Token ${var.nb_token}"
 }
}

resource "cml2_lab" "lab_labs" {
  for_each = data.netbox_site.nb_sites
  title = each.value["name"]
  description = each.value["id"]
}

resource "cml2_node" "lab_devices" {
  for_each = {for device in data.netbox_devices.nb_devices.devices: device.name => device }
  lab_id = resource.cml2_lab.lab_labs[each.value["site_id"]].id
  label = each.value["name"]
  nodedefinition = lower(each.value["model"])
  configuration = jsondecode(data.http.nb_configs[each.value["device_id"]].response_body).content
}

resource "cml2_link" "lab_connections" {
  count = length(jsondecode(data.http.nb_cables.response_body).results)
  lab_id = resource.cml2_node.lab_devices["${jsondecode(data.http.nb_cables.response_body).results[count.index].a_terminations[0].object.device.name}"].lab_id
  node_a = jsondecode(data.http.nb_cables.response_body).results[count.index].a_terminations[0].object.device.name
  slot_a = split("/",jsondecode(data.http.nb_cables.response_body).results[count.index].a_terminations[0].object.name)[0] == "port" ? "0" : split("/",jsondecode(data.http.nb_cables.response_body).results[count.index].a_terminations[0].object.name)[1]
  node_b = jsondecode(data.http.nb_cables.response_body).results[count.index].b_terminations[0].object.device.name
  slot_b = split("/",jsondecode(data.http.nb_cables.response_body).results[count.index].b_terminations[0].object.name)[0] == "port" ? "0" : split("/",jsondecode(data.http.nb_cables.response_body).results[count.index].b_terminations[0].object.name)[1]
}