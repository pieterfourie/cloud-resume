# ☁️ Cloud Resume Project — AWS

This is my **Cloud Resume Project**, built to showcase full-stack, serverless architecture and automation skills on AWS using Terraform.

---

## 🧭 Overview

The project is a fully serverless cloud-hosted resume website that integrates both frontend and backend components.  
It demonstrates secure, automated deployment pipelines and AWS infrastructure provisioning via **Infrastructure as Code (IaC)**.

---

## 🧱 Architecture

**Frontend**
- Built with **HTML**, **CSS**, and **JavaScript**
- Hosted as a **static website on Amazon S3**
- Served globally via **Amazon CloudFront** (HTTPS enabled)
- Custom domain managed through **Amazon Route 53**

**Backend**
- **API Gateway** provides an endpoint for the visitor counter
- **AWS Lambda (Python + boto3)** handles database read/write logic
- **Amazon DynamoDB** stores the persistent visitor count
- **Infrastructure managed with Terraform**

**CI/CD**
- **GitHub Actions** automates backend deployments and frontend updates to S3
- **CloudFront cache invalidation** ensures instant propagation of changes

---

## 📂 Repository Structure

cloud-resume/
│
├── frontend/
│ ├── index.html
│ ├── styles.css
│ ├── script.js
│
└── backend/
├── main.tf
├── lambda_function.py
├── variables.tf
├── outputs.tf
├── tests/
│ └── test_lambda.py
└── requirements.txt


---

## 🧰 Tech Stack

Frontend:	HTML • CSS • JavaScript
Hosting:	Amazon S3 + CloudFront
Domain:	    Route 53
Backend:	AWS Lambda (Python + boto3)
API:	    AWS API Gateway
Database:	DynamoDB
IaC:	    Terraform
CI/CD:  	GitHub Actions


## 🪶 Author

**Pieter Faasen Fourie**

📍 Western Cape, South Africa
📧 pfourie507@gmail.com
🔗 LinkedIn


## 📜 License

MIT License — free to use, modify, and distribute.