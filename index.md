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

</details>

## Open Liberty on AKS


<details>
  <summary>
    <b>90min</b> Run IBM Open Liberty on AKS.
  </summary>

### Deploy the minimum viable cluster with the Portal

<details>
  <summary>
    <b>15min</b> <b>Self-guided</b>. Use the Portal to deploy a sample app.
  </summary>

1. Visit the Portal [https://aka.ms/publicportal](https://aka.ms/publicportal).

1. In the search box, without pressing enter, type "websphere" without the quotes.

1. In the section of suggested results labeled **Marketplace** select **IBM WebSphere Liberty and Open Liberty on Azure Kubrenets Service**.

1. Select **Create**.

{% include new-resource-group.md %}

1. In **Region** enter `{{ site.data.var.region }}`.

{% include add-uami.md %}

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

</details>

### During deployment, instructor lead training for Open Liberty

### After deployment completes

<details>
  <summary>
    <b>15Min</b> Take a tour of the deployment.
  </summary>

{% include find-resource-groups.md %}

{% include find-outputs.md %}

1. Examine the outputs.

1. How to connect to cluster with `kubectl` in Cloud Shell.

   1. `az aks` command reference [docs.microsoft.com](https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest)

1. **Self-guided**. How to visit the sample app.

   1. Execute the **cmdToGetAppService**.
   
   1. Fashion the **EXTERNAL-IP** and **PORT** values into a URL such as `http://52.182.209.67:9080/`.
   
   1. Visit the URL in your browser.  Explore the sample app.
   
1. Examine **appDeploymentTemplateYamlEncoded**.

   1. Copy the value of that output using the icon.
   
   1. In the Cloud Shell, execute `echo <paste> | base64 -d` and press enter.
   
   1. This is the deployment YAML you can use to update the offer.
      The pipeline will revisit use this value.  You do not need to save it now.

</details>

### Remove deployment

<details>
  <summary>
    <b>5min</b> Remove resources to save your subscription cost.
  </summary>

You must remove the deployment to avoid consuming more Azure resources
than your pass allows.

1. In Cloud Shell, enter `az aks delete --no-wait --name <your cluster name> --resource-group <your resource group>`.

1. In the Portal, find `<your resource group>` and select **Delete resource group**.

1. Copy past the name of the resource group and select **Delete**.

</details>


### Deploy a non-trivial sample app with GitHub Actions Infrastructure as Code

<details>
  <summary>
    <b>60min</b> Go further and add database an JMS support.
  </summary>

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

</details>

</details>

<details>
  <summary>
    <b>90min</b> Run IBM Open Liberty locally. (Optional)
  </summary>
  
### Install summary 

</details>

## WebLogic Server on AKS

<details>
  <summary>
    <b>90min</b> Deploy a reasonably capable cluster with the Portal
  </summary>
  
### Deploy a WLS cluster with Azure App Gateway with the Portal

<details>
  <summary>
    <b>20min</b> <b>Self-guided</b>. Use the Portal to deploy cargotracker inside of WLS on AKS.
  </summary>
  
1. Visit the Portal [https://aka.ms/publicportal](https://aka.ms/publicportal).

1. In the search box, without pressing enter, type "weblogic" without the quotes.

1. In the section of suggested results labeled **Marketplace**, select **Oracle WebLogic Server on Azure Kubrenets Service**.

1. Select **Create**.

{% include new-resource-group.md %}

1. In **Region** enter `{{ site.data.var.region }}`.

1. Leave **Username for WebLogic Administrator** with the default value.

1. For **Password for WebLogic Administrator** and following password fields use `{{ site.data.var.workshopPassword }}`.

{% include add-uami.md %}

1. On **Optional Basic Configuration** select **No** and examine the options.  Note you can specify Java JVM options here.

1. Select **Yes** to close the **Optional Basic Configuration**.

1. Scroll down and note the hyperlinks in the **Report issues, get
   help, and share feedback** section.  The links will open in a new
   tab.  We especially encourage you to take the survey about Java EE
   usage.  this will help us create better Java EE on Azure offers.
   
1. Select **Next: Configure AKS cluster**.

1. Explore the options available, but do not select any of the following.
   
   1. [Azure Container Insights integration](https://aka.ms/wls-aks-container-insights)
   
   1. [Persist Volume integration](https://docs.microsoft.com/en-us/azure/aks/concepts-storage)

1. In **Image selection** leave the values at the defaults.

1. In **Username for Oracle Single Sign-On authentication** and the
   corresponding password field, use the values provided by the
   instructor in the Etherpad.
   
1. In **Is the specified SSO account associated with an active Oracle
   support contract?**, select **No**.
   
      **IMPORTANT** This offer really should only be used with an
      active Oracle support contract.  Without a support contract, you
      are running software that has not been patched against the
      latest security vulnerabilities, including the infamous
      Log4shell.
      
      Thankfully, for this workshop, we are also deploying Azure App
      Gateway, and the offer sets up OWASP rules to protect against
      some of the vulnerabilities.
      
1. In the **Select desired combination of WebLogic...** drop down,
   leave the default, but explore the other available options.
   
1. In the **Java EE Application** section, ensure **Yes** is selected.

1. Select the **Browse** button.

1. In the **Storage accounts** browser, select the storage account
   created by the workflow you ran previously. It will be something
   like `wlsdsa19251229631`.
   
1. In the **Containers** section, select the storage container
   created by the workflow you ran previously. It will be something
   like `wlsdcon19251229631`.
   
1. In the **Container**, select **cargo-tracker.war**.  This also was
   generated by the workflow you ran previously.
   
1. Select **Select**.

1. Leave the remaining values at their defaults.

1. Select **Next: TLS/SSL configuration**.

1. This tab lets you configure end-to-end TLS connections.  Explore the values, but leave it set at **No**.

1. Select **Next: Networking**.

1. Leave **Standard Load Balancer service** at **No**, but feel free
   to explore the documentation link.
   
1. In **Application Gateway Ingress Controller** select **Yes**.

1. The offer provides several ways to upload the certificates
   necessary to enable App Gateway integration.  Select **Generate a
   self-signed front-end certificate**.
   
1. For **Service Principal** refer to the output from the `setup.sh`
   script you ran at the beginning of the workshop.  Find the value
   for `SERVICE_PRINCIPAL`.  Copy it to the clipboard.  Be extremely
   careful to get the whole value.
   
1. To verify you have it all, you can enter the following command in
   the Cloud Shell.
   
      `echo <paste> | base64 -d` and press enter.`
      
      If you see valid JSON, you have captured the entire base64
      string to the clipboard.  Save the decoded value in your text
      file, in case you need it later.
   
1. Paste this value into the **Service Principal** and **Confirm password** fields.

1. Ensure **Enable cookie based affinity** is checked.

1. Leave the remaining values at their defaults.

1. Select **Next: DNS configuration**.

1. This tab lets you connect a DNS zone to your WLS on AKS.  Explore
   the values, but leave it set at **No**.
   
1. Select **Next: Database**.

1. For **Connect to database?** select **Yes**.

1. For the **Choose database type** select **Azure Database for PostgreSQL**.

1. For **JNDI name** enter `jdbc/CargoTrackerDB`.

1. For **Datasource Connection String** enter `jdbc:postgresql://<dbName>.postgres.database.azure.com:5432/postgres`, where `<dbName>` is the value you captured above for database name.  This will be something like `wlsdb19251229631`.

1. For **Global transactions protocol** Select **EmulateTwoPhaseCommit**.

1. For **Database username** enter `weblogic`.  This value was set as a secret in `setup.sh`.

1. For **Database Password** enter `Secret123!`.  This value was set as a secret in `setup.sh`.  Make sure to get the exclamation point.

1. Select **Next: Review + create**.

1. When the green **Validation passed** message appears, select
   **Create**.  This starts deployment.

</details>

### During deployment, instructor lead training for WebLogic Server

### After deployment completes

<details>
  <summary>
    <b>15Min</b> Take a tour of the deployment.
  </summary>

{% include find-resource-groups.md %}

{% include find-outputs.md %}

PENDING: START HERE
1. Examine the outputs.

1. How to connect to cluster with `kubectl` in Cloud Shell.

   1. `az aks` command reference [docs.microsoft.com](https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest)

1. **Self-guided**. How to visit the sample app.

   1. Execute the **cmdToGetAppService**.
   
   1. Fashion the **EXTERNAL-IP** and **PORT** values into a URL such as `http://52.182.209.67:9080/`.
   
   1. Visit the URL in your browser.  Explore the sample app.
   
1. Examine **appDeploymentTemplateYamlEncoded**.

   1. Copy the value of that output using the icon.
   
   1. In the Cloud Shell, execute `echo <paste> | base64 -d` and press enter.
   
   1. This is the deployment YAML you can use to update the offer.
      The pipeline will revisit use this value.  You do not need to save it now.

</details>

### Remove deployment

<details>
  <summary>
    <b>5min</b> Remove resources to save your subscription cost.
  </summary>

You must remove the deployment to avoid consuming more Azure resources
than your pass allows.

1. In Cloud Shell, enter `az aks delete --no-wait --name <your cluster name> --resource-group <your resource group>`.

1. In the Portal, find `<your resource group>` and select **Delete resource group**.

1. Copy past the name of the resource group and select **Delete**.

</details>

</details>



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
      

##### Afternoon: JBoss EAP on App Service

  Copy Jason Freeberg's workshop.  See https://dev.azure.com/{{ site.data.var.repoOwner }}-msft/Ed%20Burns%20Personal/_workitems/edit/1296

</details>
