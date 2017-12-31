encrypt: terraform.tfstate
	gpg -aer joshua.s.lindsey@gmail.com terraform.tfstate

decrypt: terraform.tfstate.asc
	gpg --batch --yes -do terraform.tfstate terraform.tfstate.asc

clean:
	rm -f *.asc
	rm -f *.backup
	rm -f *.tfplan

plan.tfplan:
	terraform plan -out plan.tfplan

apply: plan.tfplan
	terraform apply plan.tfplan

plan: plan.tfplan

.PHONY: encrypt decrypt clean apply plan