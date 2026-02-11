# Azure Infrastructure - eKYC (PROD)

**Capability ID:** `azure-infrastructure-ekyc-prod`  
**Owner:** Mr. Ren Rayut  
**Status:** Proposed  
**Last Updated:** 2025-12-04  
**Azure Subscription:** `Cambodia_Government_PRD` (ID: [Your-PRD-Subscription-ID])  
**Project Name:** eKYC

## Purpose

This document specifies the Azure cloud infrastructure for the eKYC project's **production** environment. It details a secure, scalable, and highly available architecture designed to handle approximately 10,000 user requests per day, using Azure Front Door Standard, API Management, Azure Functions, and auto-scaling App Services.

**Naming Convention:** This specification follows [Azure Cloud Adoption Framework naming conventions](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming).

---

## Requirements

### Requirement: PROD Resource Group
The platform SHALL provision a dedicated resource group for the eKYC production environment to ensure isolation, independent management, and accurate cost tracking.

**ID:** `AZ-EKYC-P-001`  
**Priority:** P0  
**Category:** Infrastructure Organization

#### Scenario: PROD Resource Group Provisioning

**Given** the need for the eKYC production environment  
**When** provisioning production infrastructure  
**Then** create a resource group with the following specifications:

**Resource Group:**
- **Name:** `rg-ekyc-prod-sea-001`
- **Region:** Southeast Asia
- **Subscription:** `Cambodia_Government_PRD`
- **Tags:**
  - `Environment`: prod
  - `Project`: ekyc
  - `ManagedBy`: platform-team
  - `CostCenter`: it-department
  - `Purpose`: production

**Resources in rg-ekyc-prod-sea-001:**
1.  **Azure Front Door + WAF:** `afd-ekyc-prod-global-001`
2.  **API Management:** `apim-ekyc-prod-sea-001`
3.  **Azure Function App:** `func-ekyc-prod-sea-001`
4.  **App Service (Portal):** `app-ekyc-portal-prod-sea-001`
5.  **App Service (API):** `app-ekyc-api-prod-sea-001`
6.  **SQL Server:** `sql-ekyc-prod-sea-001`
7.  **Azure Cache for Redis:** `redis-ekyc-prod-sea-001`
8.  **Virtual Network:** `vnet-ekyc-prod-sea-001`

---

### Requirement: Azure Front Door + WAF
The platform SHALL deploy Azure Front Door Standard with an integrated Web Application Firewall (WAF) to act as the global entry point, providing security, SSL offloading, and intelligent routing for production traffic.

**ID:** `AZ-EKYC-P-002`  
**Priority:** P0  
**Category:** Networking & Security

#### Scenario: PROD Front Door and WAF Deployment

**Given** the need for a secure, high-performance public entry point  
**When** deploying the production edge network layer  
**Then** provision with the following specifications:

**Front Door Configuration:**
- **Name:** `afd-ekyc-prod-global-001`
- **Tier:** Standard (includes WAF and content delivery optimization)

**WAF Policy:**
- **Name:** `waf-ekyc-prod-global-001`
- **Mode:** Prevention
- **Managed Rules:** OWASP 3.2

**Frontend Endpoints:**
- **Portal:** `portal.ekyc.gov.kh`
- **API:** `api.ekyc.gov.kh`

**Origin Groups:**
- **`og-ekyc-prod`**: Origin -> `apim-ekyc-prod-sea-001`
- **Note:** All traffic for `portal.ekyc.gov.kh` and `api.ekyc.gov.kh` will be routed to APIM. Access to APIM must be restricted to Front Door's service tag.

---

### Requirement: API Management
The platform SHALL deploy API Management to publish, secure, and manage the eKYC APIs for production traffic.

**ID:** `AZ-EKYC-P-003`  
**Priority:** P0  
**Category:** API Platform

#### Scenario: PROD API Management Deployment

**Given** the need for a robust and scalable API gateway  
**When** deploying the production API layer  
**Then** provision with the following specifications:

**API Management Configuration:**
- **Name:** `apim-ekyc-prod-sea-001`
- **SKU:** Standard (provides an SLA and is suitable for moderate traffic)
- **Virtual Network Type:** Internal

**API Configuration (Backends):**
- **Portal UI:**
  - **Frontend Path:** `/`
  - **Backend Target:** `app-ekyc-portal-prod-sea-001`
- **Backend APIs:**
  - **Frontend Path:** `/api/`
  - **Backend Target:** `app-ekyc-api-prod-sea-001`
- **Function Apps:**
  - **Frontend Path:** `/func/`
  - **Backend Target:** `func-ekyc-prod-sea-001`

---

### Requirement: Azure Function App
The platform SHALL deploy an Azure Function App for scalable, serverless background processing.

**ID:** `AZ-EKYC-P-004`  
**Priority:** P0  
**Category:** Compute

#### Scenario: PROD Function App Deployment

**Given** the need for reliable and scalable background tasks  
**When** deploying production serverless compute  
**Then** provision with the following specifications:

**Function App Configuration:**
- **Name:** `func-ekyc-prod-sea-001`
- **Plan:** Premium (EP1) (to avoid cold starts and for advanced VNet integration)
- **Runtime:** .NET 8

---

### Requirement: App Service for Portal
The platform SHALL deploy a scalable App Service to host the production front-end web portal.

**ID:** `AZ-EKYC-P-005`  
**Priority:** P0  
**Category:** Compute

#### Scenario: PROD Portal App Service Deployment

**Given** the need for a resilient and performant user-facing web application  
**When** deploying the production portal  
**Then** provision with the following specifications:

**App Service Plan:**
- **Name:** `plan-ekyc-prod-sea-001`
- **SKU:** Standard S1

**App Service Configuration:**
- **Name:** `app-ekyc-portal-prod-sea-001`
- **Runtime:** .net 4.5
- **OS:** Window

**Auto-Scaling Configuration:**
- **Minimum Instances:** 2 (for high availability)
- **Maximum Instances:** 5
- **Scale-Out Rule:**
  - **Metric:** CPU Percentage
  - **Threshold:** > 70%
  - **Duration:** 10 minutes
  - **Action:** Increase count by 1
- **Scale-In Rule:**
  - **Metric:** CPU Percentage
  - **Threshold:** < 30%
  - **Duration:** 10 minutes
  - **Action:** Decrease count by 1

---

### Requirement: App Service for API
The platform SHALL deploy a scalable App Service to host the production back-end REST APIs.

**ID:** `AZ-EKYC-P-006`  
**Priority:** P0  
**Category:** Compute

#### Scenario: PROD API App Service Deployment

**Given** the need for a resilient and performant back-end API  
**When** deploying the production API  
**Then** provision with the following specifications:

**App Service Plan:**
- **Name:** `plan-ekyc-prod-sea-001` (Shared with Portal)
- **SKU:** Standard S1

**App Service Configuration:**
- **Name:** `app-ekyc-api-prod-sea-001`
- **Runtime:** .NET 8
- **OS:** Linux 24.04 LTS

**Auto-Scaling Configuration:**
- **Minimum Instances:** 2 (for high availability)
- **Maximum Instances:** 8
- **Scale-Out Rule:**
  - **Metric:** CPU Percentage
  - **Threshold:** > 75%
  - **Duration:** 5 minutes
  - **Action:** Increase count by 1
- **Scale-In Rule:**
  - **Metric:** CPU Percentage
  - **Threshold:** < 25%
  - **Duration:** 15 minutes
  - **Action:** Decrease count by 1

---

### Requirement: SQL Server
The platform SHALL deploy a production-tier Azure SQL Server with a recommendation for high availability.

**ID:** `AZ-EKYC-P-007`  
**Priority:** P0  
**Category:** Database

#### Scenario: PROD SQL Server Deployment

**Given** the need for a highly available and performant relational database  
**When** provisioning the production data layer  
**Then** deploy with the following specifications:

**SQL Server Configuration:**
- **Name:** `sql-ekyc-prod-sea-001`
- **Public Access:** Disabled
- **Private Endpoint:** `pe-sql-prod-sea-001` in `snet-private-endpoints-prod-001`

**Database:**
- **Name:** `db-ekyc-prod-001`
- **Tier:** Standard S2 (50 DTUs)

**High Availability Recommendation:**
- Configure a **Failover Group** with a secondary server (`sql-ekyc-prod-westeu-001`) in a paired region (e.g., West Europe) for disaster recovery.

---

### Requirement: Azure Cache for Redis
The platform SHALL deploy a production-tier Azure Cache for Redis for distributed caching.

**ID:** `AZ-EKYC-P-008`  
**Priority:** P0  
**Category:** Cache

#### Scenario: PROD Redis Deployment

**Given** the need for a fast and reliable distributed cache  
**When** provisioning the production caching layer  
**Then** deploy with the following specifications:

**Redis Configuration:**
- **Name:** `redis-ekyc-prod-sea-001`
- **SKU:** Standard C1 (1 GB)
- **Public Access:** Disabled
- **Private Endpoint:** `pe-redis-prod-sea-001` in `snet-private-endpoints-prod-001`

---

### Requirement: Virtual Network
The platform SHALL provision a dedicated virtual network for the production environment.

**ID:** `AZ-EKYC-P-009`  
**Priority:** P0  
**Category:** Networking

#### Scenario: PROD Virtual Network Deployment

**Given** the need for a secure and isolated production network  
**When** provisioning the network infrastructure  
**Then** deploy a virtual network with the following specifications:

**Virtual Network Configuration:**
- **Name:** `vnet-ekyc-prod-sea-001`
- **Address Space:** `10.200.0.0/16`

**Subnets:**
- **`snet-apim-prod-001`**: `10.200.1.0/24`
- **`snet-app-integration-prod-001`**: `10.200.2.0/24`
- **`snet-private-endpoints-prod-001`**: `10.200.3.0/24`

---

### Requirement: Cost Estimation
This section provides a high-level, non-binding monthly cost estimate for the production resources.

**ID:** `AZ-EKYC-P-010`  
**Priority:** P2  
**Category:** Cost Management

| Resource Type                  | Tier / SKU        | Quantity | Estimated Monthly Cost (USD) | Notes                                                     |
| ------------------------------ | ----------------- | -------- | ---------------------------- | --------------------------------------------------------- |
| Azure Front Door               | Standard          | 1        | ~$50                         | Includes base fee and WAF policy.                         |
| API Management                 | standard          | 1        | ~$150                        | Production SLA included.                                  |
| App Service Plan               | Standard S1       | 1        | ~$73                         | Shared plan, cost based on average of 2-3 instances.    |
| Azure Functions Plan           | Premium EP1       | 1        | ~$150                        | For avoiding cold starts.                                 |
| Azure SQL Server               | Standard S2       | 1        | ~$150                        | Does not include cost of failover replica.                |
| Azure Cache for Redis          | Standard C1 (1 GB)| 1        | ~$112                        | Includes replication.                                     |
| Private Endpoints              | -                 | 2        | ~$15                         | For SQL and Redis.                                        |
| **Total Estimated Monthly Cost** |                   |          | **~$700**                    | **Excludes storage, logging, and data transfer.**         |
