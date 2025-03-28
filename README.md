# 🌍 **AWS Terraform Workshop for Begineers**🚀  

A beginner-friendly guide to setting up AWS infrastructure using **Terraform**! Learn how to **automate** and **manage** cloud resources with ease.  

---

## 📌 **What You’ll Learn**  

✅ **Deploy AWS Resources** using Terraform  
✅ **Manage Infrastructure as Code (IaC)**  
✅ **Use Remote State Storage** with S3 + DynamoDB  
✅ **Work with Different Environments** (Dev, Staging, Prod)  

---

## 🏗️ **Project Structure (What’s Inside?)**  

```tree
AWS-Terraform-Workshop/
│── modules/          # Pre-built reusable templates (VPC, EC2, etc.)
│── environments/     # Configurations for different environments (dev/staging/prod)
│── main.tf           # Main Terraform script
│── variables.tf      # Input values for easy customization
│── outputs.tf        # Output values of deployed resources
│── backend.tf        # Remote state setup (S3 + DynamoDB)
│── provider.tf       # AWS connection settings
│── README.md         # This guide! 📖
```

---

## 🚀 **Getting Started (Step-by-Step)**  

### **1️⃣ Install Required Tools**  

🔹 [Download Terraform](https://developer.hashicorp.com/terraform/downloads) and install it  
🔹 Install **AWS CLI** and set up credentials using:  

```sh
aws configure
```

🔹 Ensure you have an **S3 bucket & DynamoDB table** for storing Terraform state  

---

### **2️⃣ Clone the Project**  

```sh
git clone https://github.com/NotHarshhaa/AWS-Terraform-Workshop.git
cd AWS-Terraform-Workshop
```

---

### **3️⃣ Initialize Terraform**  

```sh
terraform init
```

👉 This sets up Terraform by downloading necessary plugins and connecting to AWS.

---

### **4️⃣ Plan & Apply Changes**  

```sh
terraform plan     # Preview the infrastructure changes
terraform apply    # Deploy the AWS resources
```

⚡ This will create AWS services like **EC2, VPC, and more!**

---

### **5️⃣ Destroy Infrastructure (If Needed)**  

```sh
terraform destroy
```

⛔ This will **delete** all deployed AWS resources.

---

## 📝 **Best Practices for Beginners**  

🔹 **Always use Remote State** – Store Terraform state in S3 to prevent conflicts.  
🔹 **Use Modules** – Pre-built Terraform modules save time and effort.  
🔹 **Check Plan Before Applying** – Always run `terraform plan` first!  
🔹 **Security First** – Use IAM roles and policies carefully.  

---

## 🤝 **Contributing**  

🔹 Found something to improve? Open a **pull request**!  
🔹 Have questions? Feel free to **open an issue**!  

---

## 📜 **License**  

📝 This project is licensed under **MIT License** – Free to use and modify!  

🚀 **Happy Terraforming!** 🌍
