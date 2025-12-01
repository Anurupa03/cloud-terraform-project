# Project 2 - Cloud Terraform Project

This project is a hand-on experience with Infrastructure as Code (IaC) practices using Terraform to manage two different environments:

- Docker-based infrastructure 
- Kubernetes cluster

Both projects showcase core Terraform concepts including modules, variables, outputs, state management, and resource dependencies.

---

## **Table of Contents**

1. [Part 1 — Docker Terraform Project](#part-1--docker-terraform-project)

   * [Architecture](#architecture)
   * [Enhancement](#enhancement)
   * [How to Run](#how-to-run-docker-project)
2. [Part 2 — Kubernetes Terraform Project](#part-2--kubernetes-terraform-project)

   * [Kubernetes Resources](#kubernetes-resources)
   * [Enhancement](#kubernetes-enhancement)
   * [How to Run](#how-to-run-kubernetes-project)
3. [Screenshots](#screenshots)
    
    * [Docker Terraform Project Screenshots](#docker-terraform-project-screenshots)
    * [Kubernetes Terraform Project Screenshots](#kubernetes-terraform-project-screenshots)
4. [Reflection](#reflection)

---

# **PART 1 — Docker Terraform Project**

The first part uses Terraform to build a small “local cloud” using Docker containers. Everything is managed through Terraform modules.

## **Architecture**

* **Frontend:** Nginx
* **Backend:** a simple API (written in *Golang*)
* **Database:** Postgres
* **Custom Docker network**
* **Redis cache** *(my enhancement)*

Each service is its own Terraform module, and the containers share a custom network so they can communicate. I used a `.tfvars` file to keep secrets like the Postgres password out of the main configuration files.

## **Enhancement**

I added **Redis** as an extra module. The goal was to extend the infrastructure and wiring in additional services using environment variables and shared networking.


## **How to Run (Docker Project)**

1. Install Docker and Golang
2. Go into the Docker project folder:

   ```sh
   cd docker
   ```
3. Initialize Terraform:

   ```sh
   terraform init
   ```
4. Review the planned changes:

   ```sh
   terraform plan
   ```
5. Apply the configuration:

   ```sh
   terraform apply
   ```
6. Once everything is running, open the frontend:

   ```
   http://localhost:8080
   ```

---
# **PART 2 — Kubernetes Terraform Project**

For the second part, I used Terraform to deploy a small application into a local Kubernetes cluster created using **k3d**.

## **Kubernetes Resources**

Terraform created the following:

* **Namespace**
* **Deployment**
* **Service**
* **ConfigMap** *(my enhancement)*

The ConfigMap stored configuration values that the Deployment used. It was a good way to learn how Kubernetes separates configuration from application code, and how Terraform can manage both.

## **How to Run (Kubernetes Project)**

### 1. Create a lightweight cluster

Using **k3d**:

```sh
k3d cluster create myapp
```

### 2. Go into the Kubernetes project folder

```sh
cd kubernetes
```

### 3. Initialize Terraform

```sh
terraform init
```

### 4. Apply the configuration

```sh
terraform apply
```

### 5. Verify the resources

```sh
kubectl get all -n myapp
kubectl describe configmap nginx-config -n myapp
```

# **Screenshots**

## **Docker Terraform Project Screenshots**

For the Docker part, I included screeshots of:

- [Docker Terraform Apply](docker-terraform/screenshots/docker-terraform-apply.png)

- [All 4 containers running](docker-terraform/screenshots/docker-containers.png)

- [Health endpoint](docker-terraform/screenshots/docker-health-check.png)

- [API responses with cache stats](docker-terraform/screenshots/docker-api-cache-demo.png)

- [Backend startup logs](docker-terraform/screenshots/docker-backend-logs.png)

- [Network inspection](docker-terraform/screenshots/docker-network.png)

- [Terraform plan](docker-terraform/screenshots/docker-terraform-plan.png)


## **Kubernetes Terraform Project Screenshots**

For the Kubernetes part, I included screenshots of:

- [Cluster creation](k8s-terraform/screenshots/k8s-create-cluster.png)

- [Terraform apply output](k8s-terraform/screenshots/k8s-terraform-apply.png)  

- [All K8s resources](k8s-terraform/screenshots/k8s-all-resources.png)  

- [ConfigMap details](k8s-terraform/screenshots/k8s-configmap.png)  

- [Custom HTML page](k8s-terraform/screenshots/k8s-custom-page.png)  

- [Pod configuration](k8s-terraform/screenshots/k8s-pod-details.png)  

- [Nginx logs](k8s-terraform/screenshots/k8s-logs.png)

# **Reflection**

This project helped me understand how Terraform can manage different types of environments using the same workflow. In the Docker part, I learned how modules and resources come together to build a small multi-service setup. Adding Redis made the system feel more realistic and showed how easy it is to expand the infrastructure.

The Kubernetes part was a good introduction to deploying workloads in a cluster using Terraform instead of applying YAML files directly. Creating the Deployment, Service, and ConfigMap helped me see how everything fits together. Using Terraform for both Docker and Kubernetes made the whole process feel more organized and consistent.

