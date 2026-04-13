# ==============================================================================
# PROJECT AEGIS: SYSTEMIC GOVERNANCE
# Framework: NIST AI Risk Management Framework (RMF)
# Scope: 1,400+ Distributed Sites | 200+ Autonomous Fleets
# ==============================================================================

package project_aegis.compliance

import future.keywords.if

default allow = false

# --- NIST RMF: DATA PRIVACY & ENCRYPTION ENFORCEMENT ---
# Blocks any AI Cluster deployment lacking Hardware-level Encryption or Database Secrets Encryption.
deny[msg] if {
    input.resource_type == "google_container_cluster"
    not input.attributes.database_encryption_state == "ENCRYPTED"
    msg := "CRITICAL: NIST AI RMF Violation - Cluster deployment denied. Database encryption is mandatory for AI telemetry."
}

# --- FLEET GOVERNANCE: IDENTITY & TAGGING ---
# Ensures every autonomous unit is traceable and assigned to a Governance Tier.
deny[msg] if {
    input.resource_type == "google_container_node_pool"
    not input.attributes.labels["governance-tier"]
    msg := "GOVERNANCE ERROR: Site deployment rejected. Missing mandatory 'governance-tier' label for fleet tracking."
}

# --- AGENTIC GUARDRAIL: GPU RESOURCE QUOTAS ---
# Prevents "Cloud Sprawl" by ensuring H100 clusters have explicit resource limits.
deny[msg] if {
    input.resource_type == "google_container_node_pool"
    input.attributes.machine_type == "a3-highgpu-8g"
    not input.attributes.autoscaling
    msg := "FINOPS WARNING: H100 GPU clusters must have autoscaling enabled to prevent idle resource tax."
}
