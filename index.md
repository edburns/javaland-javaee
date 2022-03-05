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
   
      a. Select the **Actions** tab.
      
      b. You may need to click a big green "I understand my workflows, go ahead and enable them" button.

   3. In the Azure Cloud Shell, do `gh auth login`.
   
      a. Select **GitHub.com**.

      a. Select **SSH**

      b. Generate a new SSH key **Yes**.
      
      b. Select **Login with a web browser**.
      
      c. Copy the code.
      
      c. If the browser fails to open, select the hyperlink in the
      Cloud Shell, or copy paste it to a new tab.
      
      d. Paste the code into the GitHub tab.
      
      e. If you are logged in successfully, you should see something
      like the following in your Cloud Shell.
      
         ```bash
         ✓ Authentication complete.
         - gh config set -h github.com git_protocol ssh
         ✓ Configured git protocol
         ✓ Uploaded the SSH key to your GitHub account: /home/cf9af31d-cea6-4763-b8f2-3ded0806/.ssh/id_ed25519.pub
         ✓ Logged in as edburns
         ```

   4. `gh repo clone` the fork using SSH **NOT HTTPS**.
   
      ```bash
      gh repo clone git@github.com:<your github name>/{{ site.data.var.repoPath }}.git
      ```
      
   4. Say `yes` to the SSH question.

   5. `cd {{ site.data.var.repoPath }}/.github/workflows/`

   6. Run the `setup.sh` script and answer the prompts.
   
      a. Instructor will put any shared credentials necessary in the
         Etherpad.
         
      a. You may need to use Ctrl-Shift-v to paste into the Cloud Shell.
         
      b. For the `Enter owner/reponame` enter your github username and
      the `{{ site.data.var.repoPath }}`. This allows the script to
      set GitHub Actions repository secrets.
         
      c. Copy the entire output of the script to a text file and save
      it.  You might need to refer to the contents to allow the
      instructor to help you if you get stuck.  Also, if the Cloud
      Shell is allowed to time out, you will need these values.
   
1. **15min** Perform additional set up steps in the Azure Portal [https://aka.ms/publicportal](https://aka.ms/publicportal)
   
   The instructor will direct you to perform the following steps.
   
   1. In the Portal toolbar, select Azure Active Directory. The icon
      is a pyramid.
      
   1. Under **Manage**, select **Roles and administrators**.
   
   1. In the textfield labeled **Search by name or description**,
      without pressing enter, type **Directory readers**.  When the
      auto-suggest fills in, select **Directory readers**.
      
   1. Select **+ Add assignments**.
   
   1. In the textfield labeled **Search**, enter the prefix you
      entered for the first question in the `setup.sh`.  In the
      suggestions, be sure to select the one that matches
      `<prefix>mmyyu` where `mmyy` is today's date in mmyy format.
      The `u` is for User Assigned Managed Identity.
      
   1. Select **Add**.
   
   1. In the Portal messages you should see **Successfully added assignment**.
   
   1. In the middle of the table you should see `<prefix>mmyyu`.
   
   It is very important to verify this role is correctly assigned.

   Why this is important in general?
     
      * Absolutely everything done in Azure is done under the
        authority of a "Managed Identity" concept.
        
      * This concept is implemented with a combination of two Azure
        role based access control (RBAC) technologies:
        
         - [Azure RBAC](https://docs.microsoft.com/en-us/azure/role-based-access-control/overview)

          - [Azure AD RBAC](https://docs.microsoft.com/en-us/azure/active-directory/roles/custom-overview)
            
         Why two? Evolution. This quote is about Amazon, but it
         applies to any evolving public cloud:
         
         > An analogy: Evolving a Cessna prop‐plane into a 747 jumbo
         > jet in‐flight
         
          Source: Marvin Theimer, Amazon Web Services LLC at [ACM
          SigOPS
          2009](https://www.cs.cornell.edu/projects/ladis2009/talks/theimer-keynote-ladis2009.pdf).
          
         For some more history, see [Classic subscription administrator roles, Azure roles, and Azure AD roles](https://docs.microsoft.com/en-us/azure/role-based-access-control/rbac-and-directory-admin-roles).

      * You may have heard the term "Service Principal".  Managed Identity is a more 
        modern concept built around the older concept of Service Principal.

      * [Overview of Managed Identities](https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/overview)

         > a managed identity is a service principal of a special type
         > that can only be used with Azure resources. When the
         > managed identity is deleted, the corresponding service
         > principal is automatically removed.
         
      * However, the concept of Service Principal is still relevant to
        Azure AD.  And because Azure

   Why this is important for Jakarta EE on AKS
    
      * The offers we are using for Jakarta EE on AKS require a User
        Assigned Managed Identity to successfully operate.
        
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
