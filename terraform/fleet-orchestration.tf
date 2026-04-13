# ==============================================================================
# PROJECT AEGIS: ENTERPRISE ECOSYSTEM ORCHESTRATION
# Component: GKE Fleet Manager & GPU Provisioning
# Target: 1,400 Distributed Logistics Sites | 200+ Autonomous Units
# ==============================================================================

# Local configuration for site-specific scaling
locals {
  orchestration_sites = 1400
  gpu_architecture    = "nvidia-h100-80gb"
}

# Principal AI Infrastructure Control Plane
module "aegis_gke_fleet" {
  source  = "./modules/gpu-node-pool"
  version = "3.2.1"

  # Scaled Infrastructure for Distributed Global Footprint
  cluster_count   = local.orchestration_sites
  machine_type    = "a3-highgpu-8g" # H100 Optimized Instances
  accelerator_type = local.gpu_architecture

  # Fleet Management & Orchestration
  fleet_membership = true
  fleet_id         = "aegis-fleet-alpha-200"
  telemetry_prefix = "aegis-ai-logs"

  # --- SUCCESS-DRIVEN DESIGN: FINOPS & TOPOLOGY ---
  # Enabling Topology-Aware Hints to eliminate inter-AZ data taxes (Ref: Level 3)
  enable_topology_aware_routing = true
  cost_allocation_tag           = "finops-optimization"

  # --- SUCCESS-DRIVEN DESIGN: GOVERNANCE ---
  # Enforcing NIST AI RMF compliance & Agentic Guardrails (Ref: Level 4)
  nist_rmf_compliance_mode = "ENFORCE"
  shielded_nodes           = true
  encryption_at_rest       = true
  
  # Metadata for LLMOps Lifecycle Management
  labels = {
    environment = "production"
    workflow    = "agentic-ai-control-plane"
    managed_by  = "project-aegis"
  }
}

# Provider Level Governance - Preventing Cloud Sprawl
resource "google_gke_hub_feature" "fleet_observability" {
  name     = "fleetobservability"
  location = "global"
  fleet    = module.aegis_gke_fleet.fleet_id
}

