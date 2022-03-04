# Jakarta EE on Microsoft Azure with Cargo Tracker

This workshop include self guided and instructor lead activities.
Self-guided activites will be labeled.  Otherwise, assume instructor
leads the students in the execution of steps.

## Why a non-official repo?

This workshop is work in progress destined for https://github.com/Azure-Samples/cargotracker-azure-workshop.

## Etherpad for sharing text between students and instructors

The instructor will use an etherpad to share credentials and other
details not suitable for putting in the live repository.

## Common set up for the rest of the day

<details>
  <summary>
    <b>25min</b> Configure essential credentials for the workshop.
  </summary>

1. **10min** **Self-guided**. Activate your azure pass to create your subscription.

1. **5min** **Self-guided**. Make sure Azure Cloud Shell works in your subscription.

   - [Cloud Shell overview](https://docs.microsoft.com/en-us/azure/cloud-shell/overview)
   - We will be using the **bash** variant of Azure Cloud Shell.
   
   - The first time you open the cloud shell, you must accept creating
     some cloud storage within your subscription.

1. **10min** **Self-guided**. Perform set up steps in your Azure Cloud Shell.

   1. Make a fork of the workshop repo [https://github.com/{{ site.data.var.repoOwner }}/{{ site.data.var.repoPath }}](https://github.com/{{ site.data.var.repoOwner }}/{{ site.data.var.repoPath }}).

   2. Enable GitHub Actions in the fork.
   
      a. You may need to click a big green "I understand" button.

   3. In the Azure Cloud Shell, do `gh auth login`.

      a. Select SSH

      b. Yes generate a new SSH key.

   4. `gh repo clone` the fork

   5. `cd {{ site.data.var.repoPath }}/.github/workflows/`

   6. Run the `setup.sh` script and answer the prompts.
   
      a. Instructor will put any shared credentials necessary in the
         Etherpad.
         
      b. For the `Enter owner/reponame` enter your github username and
      the name of your fork. This allows the script to set GitHub
      Actions repository secrets.
         
      c. Copy the entire output of the script to a text file and save
      it.  You might need to refer to the contents to allow the
      instructor to help you if you get stuck.  Also, if the Cloud
      Shell is allowed to time out, you will need these values.
   
   1. **15min** Perform set up steps in the Azure Portal [https://aka.ms/publicportal](https://aka.ms/publicportal)

   1. User Assigned Managed Identities
   
      1. Why this is important in general?
     
         Absolutely everything done in Azure is done under the
         authority of a "Managed Identity".

         You may have heard the term "Service Principal".  Managed Identity is a more 
         modern concept built around the older concept of Service Principal.

         [Overview of Managed Identities](https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/overview)

            > a managed identity is a service principal of a special type that can only be used with Azure resources. When the managed identity is deleted, the corresponding service principal is automatically removed.
           
      2. Why this is important for Jakarta EE on AKS
    
         The offers we are using for Jakarta EE on AKS require a User Assigned Managed Identity to successfully operate.
        
   2. Specific actions every student must do in their own Azure subscription.
    
      a. You already did this: Run script to create UAMI and assign
         **Owner** role in the subscription.

      b. Use the Portal to assign the **Directory Readers** role in Azure AD.

</details> <!-- Common set up -->

## Open Liberty on AKS

[Liberty on AKS](liberty)

## WebLogic Server on AKS

[WebLogic Server on AKS](wls)

## JBoss EAP on Azure App Service

[JBoss EAP on Azure App Service](https://github.com/Azure-Samples/workshop-migrate-jboss-on-app-service)



## WORK IN PROGRESS

<details>
  <summary>
    WORK IN PROGRESS
  </summary>
  
<details>
  <summary>
    PENDING ACTIONS BEFORE WORKSHOP DELIVERY
  </summary>

PENDING Update with link to etherpad from [riseup.net](https://pad.riseup.net/).

PENDING: fill in after morning reaches second draft state.

PENDING: remove /en-us from all embedded links.

PENDING: ensure the `setup.sh` script does what we need it to do.

PENDING: create slides for instructor lead training for Open Liberty on AKS

PENDING: TOC https://github.com/toshimaru/jekyll-toc/#installation

</details>

   C. Cargotracker
   
      1. Run locally with Liberty Maven Plugin devc mode.
      
IV. WebLogic on AKS

   A. Explain the role of the WebLogic Kubernetes Operator
   
      1. Domain home source types
      
         a. Domain on PV
         
         b. Model in image
         
      2. Why did Oracle do it this way?
      
         a. WebLogic has not been modularized like Liberty.
         
         b. Therefore, it is less "cloud native".
         
         c. The Operator is a very feature-packed piece of software.
         
   B. Deploy minimum viable runtime with Portal
   
   C. Deploy minimum viable runtime with GitHub Actions Infrastructure as Code
   
   D. Cargotracker
   
      1. Update workflow.
      
</details>
