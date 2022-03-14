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

### (Optional) Run the Cargo Tracker app with liberty:dev

<details>
  <summary>
    <b>60min</b> Use a local or cloud based development environment to run Cargo Tracker
  </summary>
  
If you want to run cargo tracker locally, you need a fully equipped
Java development environment with the following requirements.

- JDK 11 or later
- Maven 3.6.1 or later
- Unix shell environment

Or you could use a cloud based development environment such as GitHub
Codespaces or GitPod.

If you choose to use GitHub Codespaces, simply open the repository in
Codespaces.

If you choose to use GitPod, please follow the steps from the JBoss
EAP afternoon exercise introduction section 1.1 only, **but use your
fork of the {{ site.data.var.repoPath }} repository instead of
workshop-migrate-jboss-on-app-service** as the project name. [Introduction section 1.1]({{ site.data.var.jbossEAPWorkshopRoot }}/{{ jbossEAPWorkshopInstructions }}/1-environment-setup.md#11---gitpod-setup)

### Enable access from your development environment to the Azure Database for PostgreSQL

1. Visit the Portal

1. Find the resource group for your database deployment. It will be something like `wlsd-db-1953611437-2`.

1. Within the resource group, select the resource of type **Azure Database for PostgreSQL single server**.

1. In the **Settings** panel, select **Connection security**.

1. In the middle of the page is the **Firewall rules** section.
   Select the most secure option you can tolerate.
   
   1. If the portal has correctly determined IP address of your
      development environment, as in parenthesis next to **+ Add current
      client IP address**, select this option.
      
   1. If you know how to get the IP address of your cloud development
      environment, you can enter the value in the **Start IP** and
      **End IP** fields.
      
      1. You can try `nslookup`.  At the time writing, doing `nslookup
         gitpod.io` and using the first octet from the IP address for
         the **Start IP** and **End IP** values, followed by `.0.0.0`
         and `.255.255.255`, respectively, worked.
      
   1. If there is no more secure option, you can open the database to
      the entire public Internet by selecting **+ Add 0.0.0.0 -
      255.255.255.254**.

1. Select **Save**.  While the configuration is updating, you may
   continue to the next step.

### Edit the server.xml

This section uses the `liberty:dev` to run Open Liberty in a JVM in
your development environment.  For an introduction to `liberty:dev` see [Open Liberty development mode](https://www.openliberty.io/blog/2019/10/22/liberty-dev-mode.html).  For complete reference material see [the reference documentation](https://github.com/OpenLiberty/ci.maven#liberty-maven-plugin).

1. In you development environment, open the `server.xml` file.  This
   file is located at
   `cargotracker-liberty/src/main/liberty/config/server.xml` in your
   forked repository.
   
1. find the section with the xml element `<properties.postgresql>`.

1. Make the edits as shown in this diff, hard coding the values using
   the parameters collected previously.
   
   ```diff
   --- a/cargotracker-liberty/src/main/liberty/config/server.xml
   +++ b/cargotracker-liberty/src/main/liberty/config/server.xml
   @@ -34,11 +34,11 @@
        <dataSource id="CargoTrackerDB" jndiName="jdbc/CargoTrackerDB">
            <jdbcDriver libraryRef="driver-library" />
            <properties.postgresql
   -            serverName="${db.server.name}"
   -            portNumber="${db.port.number}"
   -            databaseName="${db.name}"
   -            user="${db.user}"
   -            password="${db.password}"
   +            serverName="wlsdb19536114372.postgres.database.azure.com"
   +            portNumber="5432"
   +            databaseName="postgres"
   +            user="weblogic@wlsdb19536114372"
   +            password="Secret123!"
                ssl="${db.ssl}" />
        </dataSource>
        <variable name="db.ssl" defaultValue="false"/>
   ```

### Run the Liberty Maven Plugin in dev mode 

1. In the terminal of your development environment, run `cd cargotracker-liberty`.

1. `mvn -PopenLibertyOnAks clean package`

1. `mvn -PopenLibertyOnAks liberty:dev`

   If you are running in a cloud development environment, you may see
   a pop up about port 9080, and it might give you the option to make
   this port public.  You must say yes to this option.  If you do not
   see this option, you will need to use your cloud development
   environment steps to make this port public.

   When you see this output text, you know the server is running successfully.
   
   ```bash
   [INFO] *******************************************************************
   [INFO] *** WARNING: Apache MyFaces-2 is running in DEVELOPMENT mode.   ***
   [INFO] ***                                         ^^^^^^^^^^^         ***
   [INFO] *** Do NOT deploy to your live server(s) without changing this. ***
   [INFO] *** See Application#getProjectStage() for more information.     ***
   [INFO] *******************************************************************
   [INFO] 
   [INFO] [AUDIT   ] CWWKZ0003I: The application cargo-tracker updated in 2.720 seconds.
   ```

{{ site.data.var.jsfBoast }}

1. Obtain the URL for the cargotracker from your development environment.

   1. If you are running locally, the url is simply `http://localhost:9080/`.
   
   1. If you are running in a cloud development environment, the
      instructions vary depending on your environment.
      
      For GitPod, the following was known to work at the time of this
      writing.
      
      1. In the lower right hand corner of the browser window is a
         list of ports.  Select this list.
         
      1. The **Ports** tab should open.
      
      1. Hover the mouse over **9080** and options should appear.  One
         option looks like a globe.  Select the globe.  A new tab
         should open on that URL.
         
      1. If you see the Open Liberty start page, append a `/` to the URL.

### Exercise the Cargo Tracker app

The Cargo Tracker main URL is the URL constructed in the preceding step.

{% include exercise-cargotracker.md %}

### Restore database security

Follow the same steps as in the section where you enabled access to
the database from your development environment, but remove the
firewall rule that allowed the access.

Remember to select **Save**.

### Clean up your development environment

In the terminal for your development environment, cd to the top level
of your cloned repository and run `git reset --hard`.

</details>

[home](index.md)
