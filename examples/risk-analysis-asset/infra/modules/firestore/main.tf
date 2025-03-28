# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Create a Firestore database instance
resource "google_firestore_database" "risk_db" {
  name    = var.db_name
  project = var.db_project_id
  location_id = var.db_location_id
  type = "FIRESTORE_NATIVE"
  # delete_protection_state = "DELETE_PROTECTION_ENABLED"
}

resource "random_id" "risk_theme_doc_id" {
  for_each = toset(var.risk_themes)
  byte_length = 8
}

resource "google_firestore_document" "risktheme" {
  for_each = toset(var.risk_themes)
  project     = var.db_project_id
  database    = var.db_name
  collection  = "Risk Themes"
  document_id = random_id.risk_theme_doc_id[each.value].hex
  fields = "{\"ThemeName\":{\"stringValue\":\"${each.value}\"}}"
  depends_on = [ google_firestore_database.risk_db ]
}
