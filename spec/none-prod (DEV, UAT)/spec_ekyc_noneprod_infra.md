# Azure Infrastructure - eKYC (NON-PROD - DEV/UAT)

**Capability ID:** `azure-infrastructure-ekyc-nonprod`  
**Owner:** Mr. Ren Rayut  
**Status:** Proposed  
**Last Updated:** 2025-12-04  
**Azure Subscription:** `Cambodia_Government_UAT` (ID: 8150183d-7510-49d6-94c9-24b4b1583228)  
**Project Name:** eKYC

## Purpose

This document specifies the Azure cloud infrastructure for the eKYC project's consolidated non-production environments, hosting both **DEV** and **UAT**. It details a secure and scalable architecture using a combination of shared and environment-specific resources, including Azure Front Door, API Management, Azure Functions, App Services, SQL Server, and Azure Cache for Redis.

**Naming Convention:** This specification follows [Azure Cloud Adoption Framework naming conventions](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming), incorporating `dev` and `uat` identifiers for environment-specific resources.

---

## Requirements

### Requirement: NON-PROD Resource Group
The platform SHALL provision a single, dedicated resource group for the eKYC non-production environments to ensure isolation, simplified management, and accurate cost tracking.

**ID:** `AZ-EKYC-NP-001`  
**Priority:** P0  
**Category:** Infrastructure Organization

#### Scenario: NON-PROD Resource Group Provisioning

**Given** the need for consolidated eKYC development and UAT environments  
**When** provisioning non-production infrastructure  
**Then** create a resource group with the following specifications:

**Resource Group:**
- **Name:** `rg-ekyc-nonprod-sea-001`
- **Region:** Southeast Asia
- **Subscription:** `Cambodia_Government_UAT`
- **Tags:**
  - `Environment`: nonprod
  - `Project`: ekyc
  - `ManagedBy`: platform-team
  - `CostCenter`: it-department
  - `Purpose`: dev-uat-environments

**Resources in rg-ekyc-nonprod-sea-001:**
1.  **Shared Azure Front Door + WAF:** `afd-ekyc-nonprod-global-001`
2.  **Shared API Management:** `apim-ekyc-nonprod-sea-001`
3.  **Azure Function App (DEV):** `func-ekyc-dev-sea-001`
4.  **Azure Function App (UAT):** `func-ekyc-uat-sea-001`
5.  **App Service (Portal DEV):** `app-ekyc-portal-dev-sea-001`
6.  **App Service (Portal UAT):** `app-ekyc-portal-uat-sea-001`
7.  **App Service (API DEV):** `app-ekyc-api-dev-sea-001`
8.  **App Service (API UAT):** `app-ekyc-api-uat-sea-001`
9.  **SQL Server (DEV):** `sql-ekyc-dev-sea-001`
10. **SQL Server (UAT):** `sql-ekyc-uat-sea-001`
11. **Shared Azure Cache for Redis:** `redis-ekyc-nonprod-sea-001`
12. **Shared Virtual Network:** `vnet-ekyc-nonprod-sea-001`

---

### Requirement: Shared Azure Front Door + WAF
The platform SHALL deploy a single Azure Front Door Premium instance to act as the global entry point for both DEV and UAT environments, providing shared security, SSL offloading, and routing.

**ID:** `AZ-EKYC-NP-002`  
**Priority:** P0  
**Category:** Networking & Security

#### Scenario: Shared NON-PROD Front Door and WAF Deployment

**Given** the need for a secure, public-facing entry point for DEV and UAT  
**When** deploying the edge network layer  
**Then** provision a single, shared instance with the following specifications:

**Front Door Configuration:**
- **Name:** `afd-ekyc-nonprod-global-001`
- **Tier:** Standard

**WAF Policy:**
- **Name:** `waf-ekyc-nonprod-global-001`
- **Mode:** Prevention
- **Managed Rules:** None (Using Custom Rules for Standard Tier)
- **Custom Rules:** Basic protection against SQL injection and XSS patterns.

**Frontend Endpoints:**
- **DEV Portal:** `portal-dev-ekyc.azurefd.net`
- **UAT Portal:** `portal-uat-ekyc.azurefd.net`

- **DEV API:** `api-dev-ekyc.azurefd.net`
- **UAT API:** `api-uat-ekyc.azurefd.net`

**Origin Groups:**
- **`og-ekyc-portal-dev`**: Origin -> `app-ekyc-portal-dev-sea-001`
- **`og-ekyc-portal-uat`**: Origin -> `app-ekyc-portal-uat-sea-001`

- **`og-ekyc-api-dev`**: Origin -> `apim-ekyc-nonprod-sea-001`
- **`og-ekyc-api-uat`**: Origin -> `apim-ekyc-nonprod-sea-001`

**Routing Rules:**
- Route `portal-dev-ekyc...` to `og-ekyc-portal-dev`.
- Route `portal-uat-ekyc...` to `og-ekyc-portal-uat`.

- Route `api-dev-ekyc...` to `og-ekyc-api-dev`.
- Route `api-uat-ekyc...` to `og-ekyc-api-uat`.
- Enforce HTTP to HTTPS redirection.

---

### Requirement: Shared API Management
The platform SHALL deploy a single API Management instance to publish, secure, and manage APIs for both DEV and UAT.

**ID:** `AZ-EKYC-NP-003`  
**Priority:** P0  
**Category:** API Platform

#### Scenario: Shared NON-PROD API Management Deployment

**Given** the need for a centralized API gateway for DEV and UAT  
**When** deploying the API layer  
**Then** provision a single, shared instance with the following specifications:

**API Management Configuration:**
- **Name:** `apim-ekyc-nonprod-sea-001`
- **SKU:** Developer

**APIs:**
- **eKYC DEV API (v1):**
  - **DEV Backend:** `app-ekyc-api-dev-sea-001` (e.g., via a policy that routes based on hostname)
**APIs:**
- **eKYC UAT API (v1):** 
  - **UAT Backend:** `app-ekyc-api-uat-sea-001`
  
- **URL Path:** `/api/v1`

### Requirement: Azure Function Apps (DEV and UAT)
The platform SHALL deploy two separate Azure Function Apps for serverless processing, one for DEV and one for UAT.

**ID:** `AZ-EKYC-NP-004`  
**Priority:** P0  
**Category:** Compute

#### Scenario: NON-PROD Function App Deployment

**Given** the need for isolated background tasks for DEV and UAT  
**When** deploying serverless compute  
**Then** provision two separate Function Apps:

**Function App Configuration (DEV):**
- **Name:** `func-ekyc-dev-sea-001`
- **Plan:** Consumption
- **Region:** Southeast Asia
- **Operation System:** Window
- **Runtime:** .NET 8

**Function App Configuration (UAT):**
- **Name:** `func-ekyc-uat-sea-001`
- **Plan:** Consumption
- **Region:** Southeast Asia
- **Operation System:** Window
- **Runtime:** .NET 8

---

### Requirement: App Services for Portal (DEV and UAT)
The platform SHALL deploy two separate App Services to host the DEV and UAT front-end web portals.

**ID:** `AZ-EKYC-NP-005`  
**Priority:** P0  
**Category:** Compute

#### Scenario: NON-PROD Portal App Service Deployment

**Given** the need for isolated user-facing web applications  
**When** deploying the portals  
**Then** provision two separate App Services:



**App Service Configuration (DEV):**
- **Plan:** `plan-ekyc-nonprod-sea-001` (Basic B1 SKU)
- **Name:** `app-ekyc-portal-dev-sea-001`
- **Runtime:** .net 4.8
- **OS:** Window

**App Service Configuration (UAT):**
- **Plan:** `plan-ekyc-nonprod-sea-001` (Basic B1 SKU)
- **Name:** `app-ekyc-portal-uat-sea-001`
- **Runtime:** .net 4.8
- **OS:** Window

The platform SHALL deploy two separate App Services to host the DEV and UAT back-end REST APIs.

**ID:** `AZ-EKYC-NP-006`  
**Priority:** P0  
**Category:** Compute

#### Scenario: NON-PROD API App Service Deployment

**Given** the need for isolated back-end API applications  
**When** deploying the APIs  
**Then** provision two separate App Services:


**App Service Configuration (DEV):**
- **Plan:** `plan-ekyc-nonprod-sea-002` (Basic B1 SKU)
- **Name:** `app-ekyc-api-dev-sea-001`
- **Runtime:** .NET 8
- **OS:** Linux 24.04 LTS

**App Service Configuration (UAT):**
- **Plan:** `plan-ekyc-nonprod-sea-002` (Basic B1 SKU)
- **Name:** `app-ekyc-api-uat-sea-001`
- **Runtime:** .NET 8
- **OS:** Linux 24.04 LTS

### Requirement: SQL Servers (DEV and UAT)
The platform SHALL deploy two separate Azure SQL Servers to host dedicated databases for DEV and UAT, ensuring environment isolation.

**ID:** `AZ-EKYC-NP-007`  
**Priority:** P0  
**Category:** Database

#### Scenario: NON-PROD SQL Server Deployment

**SQL Server Configuration (DEV):**
- **Name:** `sql-ekyc-dev-sea-001`
- **Public Access:** Enable (with restriction within only DGC IP)
- **Admin User**: ekycadmin
- **Password User**: ***
- **Database:**
  - **Name:** `db-ekyc-noneprod-001`
  - **Tier:** Basic (5 DTUs)

**SQL Server Configuration (UAT):**
- **Name:** `sql-ekyc-uat-sea-001`
- **Public Access:** Enable (with restriction within only DGC IP)
- **Database:**
  - **Name:** `db-ekyc-noneprod-001`
  - **Tier:** Basic (5 DTUs)

---

### Requirement: Shared Azure Cache for Redis
The platform SHALL deploy a single Azure Cache for Redis to be shared by DEV and UAT environments.

**ID:** `AZ-EKYC-NP-008`  
**Priority:** P0  
**Category:** Cache

#### Scenario: Shared NON-PROD Redis Deployment

**Given** the need for a distributed cache for DEV and UAT  
**When** provisioning the caching layer  
**Then** deploy a single, shared instance:

**Redis Configuration:**
- **Name:** `redis-ekyc-nonprod-sea-001`
- **SKU:** Basic C0 (250 MB)
- **Public Access:** Enable (Enable with restriction within only DGC IP)
- **Data Separation:** Use different database indexes (e.g., DB 0 for DEV, DB 1 for UAT) or key prefixes.

---

### Requirement: Virtual Network (UAT only)
The platform SHALL provision a dedicated virtual network with appropriate subnets to ensure network isolation and security for all non-production resources.

**ID:** `AZ-EKYC-NP-009`  
**Priority:** P0  
**Category:** Networking

#### Scenario: NON-PROD Virtual Network Deployment

**Given** the need for a secure and isolated network for DEV and UAT environments  
**When** provisioning the network infrastructure  
**Then** deploy a virtual network with the following specifications:

**Virtual Network Configuration:**
- **Name:** `vnet-ekyc-nonprod-sea-001`
- **Address Space:** `10.100.0.0/16`

**Subnets:**
- **`snet-apim-nonprod-001`**:
  - **Address Range:** `10.100.1.0/24`
  - **Purpose:** For the shared API Management service.
- **`snet-app-integration-nonprod-001`**:
  - **Address Range:** `10.100.2.0/24`
  - **Purpose:** For App Service and Azure Functions VNet integration.
- **`snet-private-endpoints-nonprod-001`**:
  - **Address Range:** `10.100.3.0/24`
  - **Purpose:** For all private endpoints (SQL, Redis).

---

### Requirement: Cost Estimation
This section provides a high-level, non-binding monthly cost estimate for the resources defined in this specification. Actual costs may vary based on usage, data transfer, and other factors.

**ID:** `AZ-EKYC-NP-010`   
**Priority:** P2  
**Category:** Cost Management

| Resource Type                  | Tier / SKU        | Quantity | Estimated Monthly Cost (USD) | Notes                                           |
| ------------------------------ | ----------------- | -------- | ---------------------------- | ----------------------------------------------- |
| Azure Front Door               | Standard          | 1        | ~$35                         | Base fee. Data transfer costs are extra.        |
| API Management                 | Developer         | 1        | ~$50                         | For non-production, no SLA.                     |
| App Service Plan               | Basic B1          | 2        | ~$110                         | Shared by 4 App Service instances.              |
| Azure Functions                | Consumption       | 2        | ~$10                         | Based on estimated low usage for DEV/UAT.       |
| Azure SQL Server (DEV & UAT)   | Basic (5 DTUs)    | 2        | ~$10                         | ~$5 per database.                               |
| Azure Cache for Redis          | Basic C0 (250 MB) | 2        | ~$34                         |                                                 |
| Virtual Network                | -                 | 1        | Free                         |                                                 |
| Private Endpoints              | -                 | 3        | ~$22                         | ~$7.30 per endpoint/month.                      |
| **Total Estimated Monthly Cost** |                   |          | **~$271**                    | **Excludes storage, logging, and data transfer.** |
