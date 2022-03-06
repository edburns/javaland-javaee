# Jakarta EE on Microsoft Azure with Cargo Tracker

## Open Liberty on AKS

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

   1. `az aks` command reference [docs.microsoft.com]({{ site.data.var.docsMicrosoftCom }}/cli/azure/aks?view=azure-cli-latest)

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

      1. [Azure Database for PostgreSQL documentation]({{ site.data.var.docsMicrosoftCom }}/azure/postgresql/)

      1. [Storage account overview]({{ site.data.var.docsMicrosoftCom }}/azure/storage/common/storage-account-overview)

      1. [Azure storage container]({{ site.data.var.docsMicrosoftCom }}/cli/azure/storage/container?view=azure-cli-latest)

1. <a name="liberty-aks-pipeline-values">Capture values from outputs.</a> You will
   [need these later](#wls-aks-pipeline-values).

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
   
   1. In the Cloud Shell, type `gh --repo <your github name>/{{ site.data.var.repoPath }} secret set
      AZURE_OPEN_LIBERTY_ACR_PASSWORD -b` and paste the saved value.
      **Ensure there is no space after `-b`**.  Press enter.
      
      * You should see **✓ Set secret AZURE_OPEN_LIBERTY_ACR_PASSWORD for your github name/{{ site.data.var.repoPath }}**.

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

[home](/)
