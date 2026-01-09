# checkpoint-home-assignment

- Im using terraform vpc module and use single NAT gateway for 2 subnets just
  because cost optimization. In production environment its better to have one NAT gateway for each subnet for HA.

- i've connected my aws account to github actions by set oidc identity provider and created role with proper trust relationship (IaC with terraform)

- My ci will build for pr and build and push for merged to main branch, the
  service owner need to handle the version.txt file manually for each microservice.(will improve to auto bump version with auto merge to main)

- The task requires to create ELB therefore i created ECS with EC2 instances that
  managed by ASG with launch template and instance profile.

- For simplicity im using latest as image tag, and force deployment in my cd
  after new image is pushed via the ci, in real production will use some tools
  like argoCD that will handle the deployment based on git repo changes.
