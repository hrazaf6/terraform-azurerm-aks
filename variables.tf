variable "aks_name" {
  type = string
  description = "Name of the Kubernetes Cluster"
}

variable "dns_prefix" {
  type = string
  description = "DNS Suffix to be used by the AKS"
}

variable "automatic_channel_upgrade" {
  type = string
  description = "The upgrade channel for this Kubernetes Cluster. Possible values are none, patch, rapid, and stable"
  defaut = "none"
}

variable "enable_addon_profile" {
  type = bool
  description = "If you want to enable the addon profile"
  default = false
}

variable "enable_aci_connector_linux" {
  type = bool
  description = "If you want to enable the aci connector linux"
  default = false
}

variable "enable_azure_policy" {
  type = bool
  description = "If you want to enable the azure policy"
  default = false
}

variable "enable_http_application_routing" {
  type = bool
  description = "If you want to enable the http application routing"
  default = false
}

variable "enable_kube_dashboard" {
  type = bool
  description = "If you want to enable the kube dashboard"
  default = false
}

variable "enable_oms_agent" {
  type = bool
  description = "If you want to enable the oms agent"
  default = false
}

variable "log_analytics_workspace_id" {
  type = string
  description = "The ID of the Log Analytics Workspace which the OMS Agent should send data to"
  default = null
}

variable "enable_oms_agent_identity" {
  type = bool
  description = "If you want to enable the oms agent identity"
  default = false
}

variable "client_id" {
  type = string
  description = "Client ID"
  default = null
}

variable "object_id" {
  type = string
  description = "Object ID"
  default = null
}

variable "user_assigned_identity_id" {
  type = string
  description = "The ID of the User Assigned Identity used by the OMS Agents"
  default = null
}

variable "api_server_authorized_ip_ranges" {
  type = list(string)
  description = "The IP ranges to whitelist for incoming traffic to the masters"
  default = null
}

variable "enable_auto_scaler_profile" {
  type = bool
  description = "If auto scaler profile need to be enabled"
  default = false
}

variable "balance_similar_node_groups" {
  type = bool
  description = "Detect similar node groups and balance the number of nodes between them"
  default = false
}

variable "max_graceful_termination_sec" {
  type = number
  description = "Maximum number of seconds the cluster autoscaler waits for pod termination when trying to scale down a node."
  default = 600
}

variable "new_pod_scale_up_delay" {
  type = string
  description = "For scenarios like burst/batch scale where you don't want CA to act before the kubernetes scheduler could schedule all the pods, you can tell CA to ignore unscheduled pods before they're a certain age"
  default = "10s"
}

variable "scale_down_delay_after_add" {
  type = string
  description = "How long after the scale up of AKS nodes the scale down evaluation resumes"
  default = "10m"
}

variable "scale_down_delay_after_delete" {
  type = string
  description = "How long after node deletion that scale down evaluation resumes"
  default = "10s"
}

variable "scale_down_delay_after_failure" {
  type = string
  description = "How long after scale down failure that scale down evaluation resumes"
  default = "3m"
}

variable "scan_interval" {
  type = string
  description = "How often the AKS Cluster should be re-evaluated for scale up/down"
  default = "10s"
}

variable "scale_down_unneeded" {
  type = string
  description = "How long a node should be unneeded before it is eligible for scale down"
  default = "10m"
}

variable "scale_down_unready" {
  type = string
  description = "How long an unready node should be unneeded before it is eligible for scale down"
  default = "20m"
}

variable "scale_down_utilization_threshold" {
  type = string
  description = "Node utilization level, defined as sum of requested resources divided by capacity, below which a node can be considered for scale down"
  default = "0.5"
}

variable "skip_nodes_with_local_storage" {
  type = bool
  description = "If true cluster autoscaler will never delete nodes with pods with local storage, for example, EmptyDir or HostPath"
  default = true
}

variable "skip_nodes_with_system_pods" {
  type = bool
  description = "If true cluster autoscaler will never delete nodes with pods from kube-system (except for DaemonSet or mirror pods)."
  default = true
}

variable "disk_encryption_set_id" {
  type = string
  description = "The ID of the Disk Encryption Set which should be used for the Nodes and Volumes"
  default = null
}

variable "enable_identity" {
  type = bool
  description = "If identity need to be enabled"
  default = false
}

variable "identity_type" {
  type = string
  description = "The type of identity used for the managed cluster. Possible values are SystemAssigned and UserAssigned"
  default = "SystemAssigned"
}

