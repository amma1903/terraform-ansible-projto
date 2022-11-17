# Group assignment
**Due by 23:00 today**, only one submission per group, sent by email to Paulo.Peixoto@criticaltechworks.com
- Deploy the Prometheus stack (Prometheus, Alertmanager and Grafana), using Terraform and Ansible on a single `Standard_D2s_v3` VM instance; DONE
- The Terraform code should be configured to use the cloud provider to store the `tfstate` file;
- Only the ports required for a user to connect to the three components of the stack should be accessible; DONE
- After the stack is deployed, import the three dashboards found in the `resources` folder into Grafana; 
- Try to keep the manual steps to an absolute minimum. FYI, the minimum will be 5, out of which, running Terraform and Ansible are two. DONE

# Groups
## Group 1
- João Martins Oliveira
- Fernando Afonso
- José Pinto Santos
- Vitor Luís

## Group 2
- Arnaldo Alves
- João Leão
- Tiago Cruz Sousa
- Tomás Pinto Ferreira

# Individual questions
**Please note**: Answers should be sent by email to Paulo.Peixoto@criticaltechworks.com

- What modification should be done to the terraform code in order to deploy three virtual machines instead of one?  

- During the group assignment, various files will have to be downloaded from the internet (the Prometheus stack binaries), is there a way for ansible to be sure that these files are the originals and have not been tampered with?  

- What is metric scraping?  