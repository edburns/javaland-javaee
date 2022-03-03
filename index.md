# Jakarta EE on Microsoft Azure with Cargo Tracker

This workshop include self guided and instructor lead activities.
Self-guided activites will be labeled.  Otherwise, assume instructor
leads the students in the execution of steps.

## Why a non-official repo?

This workshop is work in progress for the currently 404
https://github.com/Azure-Samples/cargotracker-azure-workshop .

## Etherpad for sharing text between students and instructors

The instructor will use an etherpad to share credentials and other
details not suitable for putting in the live repository.

Update with link to etherpad from
[riseup.net](https://pad.riseup.net/).

## Outline

PENDING: fill in after morning reaches second draft state.

PENDING: remove /en-us from all embedded links.

PENDING: ensure the `setup.sh` script does what we need it to do.

PENDING: create slides for instructor lead training for Open Liberty on AKS

PENDING: TOC https://github.com/toshimaru/jekyll-toc/#installation

## Common set up for the rest of the day

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

## Open Liberty on AKS

### Deploy the minimum viable cluster with the Portal

1. Visit the Portal [https://aka.ms/publicportal](https://aka.ms/publicportal).

1. In the search box, without pressing enter, type "websphere" without the quotes.

1. In the section of suggested results labeled **Marketplace** select **IBM WebSphere Liberty and Open Liberty on Azure Kubrenets Service".

1. Select **Create**.

1. In **Resource group** select **Create new**.  In the dialog that appears, enter the next number to the sequence number you entered in `setup.sh`, followed by the date in mmdd syntax.  For example, if you entered `ejb01`, you would enter `ejb02{{ site.data.var.workshopmmdd }}`.

1. In **Region** enter `{{ site.data.var.region }}`.

1. Read warning box.  This is why we had you create the UAMI and
   assign it the necessary roles.
   
1. Select the **+Add** control.

1. In the sidebar, select the UAMI created by script.  It should be something like `ejb01{{ site.data.var.workshopmmdd }}u`.

1. In the sidebar, select **Add**.  This should dismiss the sidebar and cause the warning box to disappear.

1. Scroll down and note the hyperlinks in the **Report issues, get
   help, and share feedback** section.  The links will open in a new
   tab.  We especially encourage you to take the survey about Java EE
   usage.  this will help us create better Java EE on Azure offers.
   
1. Select **Next: Configure cluster**.

1. Leave the values at their defaults, but allow the instructor to
   talk about what the values do.
   
1. Select **Next: Configure application**.

1. Next to **Deploy an application?** select **Yes**.

1. In the UI that appears, select **The Open Liberty sample image**
   but allow the instructor to explain what the other options are.
   
1. Select **Review + create**.

1. When the green **Validation passed** message appears, select
   **Create**.  This starts deployment.
   
### During deployment, instructor lead training for Open Liberty

### When deployment completes

1. **Self-guided**. How to find resource groups in the Portal.

   1. Visit the Portal.
   
   1. Select **Resource groups**.
   
   1. In the filter, enter the first three characters of the prefix
      you used in `setup.sh`.
      
   1. Select your resource group.
   
1. **Self-guided**. How to find outputs in a resource group.

   1. In the pane under the **Resource group** name, in the
      **Settings** section, select **Deployments**.
      
   1. Select the bottom most deployment in the list.
   
   1. In the left pane, select **Outputs**.

1. Examine the outputs.

1. How to connect to cluster with `kubectl` in Cloud Shell.

   1. `az aks` command reference [docs.microsoft.com](https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest)

1. **Self-guided**. How to visit the sample app.

   1. Execute the **cmdToGetAppService**.
   
   1. Fashion the **EXTERNAL-IP** and **PORT** values into a URL such as `http://52.182.209.67:9080/`.
   
   1. Visit the URL in your browser.  Explore the sample app.
   
1. Examine **appDeploymentTemplateYamlEncoded **.

   1. Copy the value of that output using the icon.
   
   1. In the Cloud Shell, execute `echo <paste> | base64 -d` and press enter.
   
   1. This is the deployment YAML you can use to update the offer.
      The pipeline will revisit use this value.  You do not need to save it now.

### Remove deployment

You must remove the deployment to avoid consuming more Azure resources
than your pass allows.

1. In Cloud Shell, enter `az aks delete --no-wait --name <your cluster name> --resource-group <your resource group>`.

1. In the Portal, find `<your resource group>` and select **Delete resource group**.

1. Copy past the name of the resource group and select **Delete**.

### Deploy with minimum viable runtime with GitHub Actions Infrastructure as Code

#### Deploy Database and Storage Account for Cargotracker on Liberty and WLS on AKS

1. Visit your fork of [https://github.com/{{ site.data.var.repoOwner }}/{{ site.data.var.repoPath }}](https://github.com/{{ site.data.var.repoOwner }}/{{ site.data.var.repoPath }}).

1. Select **Actions**.

1. Select **DB and Storage Account**.

1. Select **Run workflow** and **Run workflow**.

1.  Instructor will walk you through
    `.github/workflows/setupDBandStorage.yml`, which you have in your
    repo.  Briefly, this workflow uses the repository secrets you
    created earlier to create an Azure Database for PostgreSQL
    instance, Storage Account, and Storage Container, build the
    **cargotracker.war** and upload it to the Storage Container.

      1. [Azure Database for PostgreSQL documentation](https://docs.microsoft.com/en-us/azure/postgresql/)

      1. [Storage account overview](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview)

      1. [Azure storage container](https://docs.microsoft.com/en-us/cli/azure/storage/container?view=azure-cli-latest)

1. Capture values from outputs.  You will need these later.

   1. Disambiguation prefix.  This will be something like `19251229631`.
   
   1. Database name.  This will be something like `wlsdb19251229631`.
   
   1. Storage account name.  This will be something like `wlsdsa19251229631`.
   
   1. Storage container within storage account.  This will be
      something like `wlsdcon19251229631`.

#### Deploy Open Liberty on AKS from workflow
   
1. Visit your fork of [https://github.com/{{ site.data.var.repoOwner }}/{{ site.data.var.repoPath }}](https://github.com/{{ site.data.var.repoOwner }}/{{ site.data.var.repoPath }}).

1. Select **Actions**.

1. Select **Setup OpenLiberty on AKS**.

1. Select **Run workflow**.

1. In the drop down:

   1. Enter the disambiguation prefix from above.
   
   1. Enter your region.

1. Select **Run workflow**.

1.  Instructor will walk you through
    `.github/workflows/setupOpenLibertyAks.yml`, which you have in
    your repo.  Briefly, this workflow uses the repository secrets you
    created earlier to execute the same steps you did in the Portal,
    but uses the underlying GitHub repo for Liberty on AKS to deploy
    the arm template manually.
    
    It then uses the `cargotracker/cargotracker-liberty` version of
    CargoTracker to create a parameters file that is used to deploy
    the offer.
    
    **IMPORTANT** The deployment of cargotracker is not complete at
    this point because we have not pushed the docker image to the
    Azure Container Registry.
    
1. **Self-guided**. After the workflow succeeds, go into the Portal
   and find the resource group created by the workflow.  It will start
   with `ol-aks-<your disambiguation suffix>`.
   
1. **Self-guided**. Select **Overview**.  Observe the list of resources in the middle pane.
   
1. **Self-guided**. Capture the Azure Container Registry and create a
   repository secret with the value.
   
   1. In the resource group for the AKS cluster, find the
      Container Registry resource and select it.
      
   1. In the **Settings** section, select **Access keys**.
   
   1. There are two **password** entries.  Hover the mouse over the
      **Copy** icon to the right of the first one and single click.
      
   1. Paste the value to your saved text file, labeling it accordingly.
   
   1. In the Cloud Shell, type `gh secret set
      AZURE_OPEN_LIBERTY_ACR_PASSWORD -b` and paste the saved value.
      **Ensure there is no space after `-b`**.  Press enter.
      
      * You should see **✓ Set secret AZURE_OPEN_LIBERTY_ACR_PASSWORD for {{ site.data.var.repoOwner }}/{{ site.data.var.repoPath }}**.

1. **Self-guided**. In the Portal find the resource group for the AKS cluster.

1. **Self-guided**. As you did before, inspect the outputs.

1. **Self-guided**. Collect parameters necessary for the next step.  Use the **Copy** icon next to each output.
   
      1. **clusterRGName** Name of the resource group into which the
         AKS cluster is deployed.
      
      1. **clusterName** The name of the AKS cluster.
      
      1. **acrName** The name of the container registry, but you must
         append `.azurecr.io` when you save this value aside.
      
      1. ACR user name.  This is the same as **acrName** .

#### Deploy cargotracker on Open Liberty on AKS from the workflow

1. Visit your fork of [https://github.com/{{ site.data.var.repoOwner }}/{{ site.data.var.repoPath }}](https://github.com/{{ site.data.var.repoOwner }}/{{ site.data.var.repoPath }}).

1. Select **Actions**.

1. Select **Update Cargo Tracker to OpenLiberty on Aks**.

1. Select **Run workflow**.

1. Fill in the values you captured in the preceding step.

1. For the database, fill in the value you saved earlier.

1. Select **Run workflow**.

1.  Instructor will walk you through
    `.github/workflows/updateCargoTrackerToOpenLibertyOnAks.yml`,
    which you have in your repo.  Briefly, this workflow does the same
    steps done above to run cargotracker on liberty locally, but
    instead of running it locally, it does the following:
    
      - Checkout cargotracker
      - Build the app
      - Query version string for deployment verification
      - Build image and upload to ACR
      - Connect to AKS cluster
      - Apply deployment files
      - Verify pods are ready
      - Query Application URL
      - Verify that the app is update
      
  1. Inspect the workflow output and expand the **Query Application
     URL** step.  Construct a URL using the IP, such as
     `http://20.62.216.80:9080/`.
     
#### Exercise the Cargo Tracker app

The Cargo Tracker main URL is the URL constructed in the preceding step.

{% include exercise-cargotracker.md %}

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

##### Afternoon: JBoss EAP on App Service

  Copy Jason Freeberg's workshop.  See https://dev.azure.com/{{ site.data.var.repoOwner }}-msft/Ed%20Burns%20Personal/_workitems/edit/1296
