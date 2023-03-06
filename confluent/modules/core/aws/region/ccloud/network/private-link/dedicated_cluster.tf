resource "confluent_kafka_cluster" "dedicated" {
  display_name = "source"
  availability = "MULTI_ZONE"
  cloud        = confluent_network.private-link.cloud
  region       = confluent_network.private-link.region
  dedicated {
    cku = 2
  }
  environment {
    id = var.ccloud_env_id
  }
  network {
    id = confluent_network.private-link.id
  }
}


# resource "confluent_kafka_cluster" "dedicated_2" {
#   display_name = "destination"
#   availability = "MULTI_ZONE"
#   cloud        = confluent_network.private-link.cloud
#   region       = confluent_network.private-link.region
#   dedicated {
#     cku = 2
#   }
#   environment {
#     id = var.ccloud_env_id
#   }
#   network {
#     id = confluent_network.private-link.id
#   }
# }