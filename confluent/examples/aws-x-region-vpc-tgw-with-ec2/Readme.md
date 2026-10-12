# terraform init
# terraform apply
# terraform destroy
# terrafrom output > results.txt
# alias tf=terraform



Initialize Backend with custom vars
terraform init -backend-config="backend.tfvars

"Run a Plan with custom vars
terraform plan -var-file="custom.tfvars"

Apply infrastructure with custom vars
terraform apply -var-file="custom.tfvars"


# For creating Region 1
terraform init 

terraform plan -var-file="step1-reg1-setup.tfvars"

terraform apply -var-file="step1-reg1-setup.tfvars"
terraform output > reg1-output.txt

terraform apply -var-file="step2-reg2-setup.tfvars"
terraform output > reg2-output.txt

terraform destroy  -var-file="step1-reg1-setup.tfvars"
terraform destroy -var-file="step2-reg2-setup.tfvars"
