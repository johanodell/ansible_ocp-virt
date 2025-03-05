#!/usr/bin/env bash

#################################
# include the -=magic=-
# you can pass command line args
#
# example:
# to disable simulated typing
# . ../demo-magic.sh -d
#
# pass -h to see all options
#################################
. gitops/utils/demo-magic.sh
DEMO_PROMPT="${GREEN}➜${CYAN}[virt-demo]$" #${COLOR_RESET}"
TYPE_SPEED=20
USE_CLICKER=true

# Define colors
BLUE='\033[38;2;102;204;255m' #'\033[38;5;153m' #'\033[0;34m'
GREEN='\033[38;5;41m' #'\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

# Function to print lines with color based on their content
print_colored_output() {
    while IFS= read -r line; do
        if [[ $line == skipping:* || $line == included:* ]]; then
            echo -e "${BLUE}${line}${RESET}"
        elif [[ $line == ok:* ]]; then
            echo -e "${GREEN}${line}${RESET}"
        elif [[ $line == changed:* ]]; then
            echo -e "${YELLOW}${line}${RESET}"
        else
            echo "$line"
        fi
    done
}


# Hide the evidence
clear

wait
figlet -f starwars -S "argocd & ansible demo"| lolcat -a -s 100
wait
clear
viu gitops/pics/start.png
wait
clear
viu gitops/pics/gitops_ansible_provisioning.png
wait
redhatsay -v "So first we will use ArgoCD to create
namespace, nad & VM in OpenShift Virtualization. 
Then sync an AAP CR to trigger a simple 
post provisioning workflow in Ansible"
wait
clear
pei "ls -l gitops"
echo -e "\n"
wait
pei "highlight gitops/application.yaml"
echo -e "\n"
wait
redhatsay -v "The application will create project 00-system1
as the home for our VM. Lets see what else the application contains"
wait
pei "ls -l gitops/base/"
echo -e "\n"
wait
redhatsay "Lets look at the VM"
wait
pei highlight -O ansi gitops/base/rhel9.yaml | less -R
wait
redhatsay -v "and this is the network attachement definition"
wait
pei "highlight gitops/base/NetworkAttachementDefinition.yaml"
wait
redhatsay -v "When the VM is ready and responding on port 22 we will 
kick off the ansible workflow by using this custom resource"
wait
pei "highlight gitops/base/ansible-job.yaml"
wait
redhatsay "Ok, lets start"
wait
pei "oc apply -f gitops/application.yaml"
echo -e "\n"
wait
pei "oc project 00-system1"
echo -e "\n"
wait
pei "oc get vm"
echo -e "\n"
wait
echo "# Monitoring DataVolume clone progress..." | lolcat
monitor_clone_progress() {
    while true; do
        # Retrieve the JSON for the DataVolume (replace with your DataVolume name/namespace)
        dv_json="$(oc get dv rhel9-gitops1-1 -n 00-system1 -o json 2>/dev/null || true)"

        # If the DataVolume no longer exists or can't be retrieved, break (or handle error)
        if [[ -z "$dv_json" || "$dv_json" == "null" ]]; then
            gum style --foreground red --bold "✗ DataVolume not found."
            break
        fi

        # Extract the current phase and progress of the DataVolume
        phase="$(echo "$dv_json" | jq -r '.status.phase // "N/A"')"
        progress="$(echo "$dv_json" | jq -r '.status.progress // "N/A"')"

        case "$phase" in
          "Succeeded")
            gum style --foreground green --bold "✔ Cloning completed at $progress"
            break
            ;;
          "Failed")
            gum style --foreground red --bold "✗ Cloning failed!"
            break
            ;;
          *)
            # Show a spinner, including current phase/progress in the spinner title
            gum spin --spinner dot \
                     --title.foreground cyan \
                     --title "$phase phase... ($progress)" \
                     -- sleep 3
            ;;
        esac
    done
}
monitor_clone_progress
wait
pei "oc get vmi"
wait
redhatsay "Lets have a look in consoles"
wait 
open "https://openshift-gitops-server-openshift-gitops.apps.mothershift.codell.io/applications/openshift-gitops/vms?view=tree&resource="
wait
clear
figlet -f starwars -S "end of the demo"| lolcat -a -s 100
wait