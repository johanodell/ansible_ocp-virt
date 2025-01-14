# ansible_ocp-virt
This repo contains some stuff around ansible and OpenShift Virtualization 

# ansible collections for VM management in OpenShift virtualization

Red Hat Ansible Automation Platform (Certified & supported content): 
https://console.redhat.com/ansible/automation-hub/repo/published/redhat/openshift_virtualization/

AWX (Upstream & Community based support): 
https://kubevirt.io/kubevirt.core/1.0.0/README.html 


# Setting up a project-based Kubevirt Inventory in AWX/AAP Controller

First we need a credential. This token should be scoped but for now let's just add a cluster-admin scoped token. In your AWX/AAP namespace. 

1. Add a ServiceAccount:  ```oc create sa awx-credential ```

2. Add cluster-admin rights to the service account: ```oc adm policy add-cluster-role-to-user cluster-admin -z controller-credential```
   
3. Create a token for the SA: ```oc create token awx-credential --duration=4294967296s``` (hmm 136 years, 29 weeks, 3 days, 6 hours, 28 minutes, 16 seconds. :-0). 
Copy it and add it as a Credential in the controller:

![Alt text](images/create_controller_credential.png)



