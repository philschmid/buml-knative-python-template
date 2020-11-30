# How to use managed Cloud Run on GCP

## Ressources
[Quick Starts](https://cloud.google.com/run/docs/quickstarts/build-and-deploy#python)  
[Service Account configuration](https://cloud.google.com/run/docs/configuring/service-accounts#gcloud)  
[How-to Guides](https://cloud.google.com/run/docs/how-to#configure)  
[Deploy with Terraform](https://cloud.google.com/run/docs/deploying#terraform)


## Change values in Yaml File with `yq` 

### [for local usage install `yq` on your local machine](https://mikefarah.gitbook.io/yq/) 

```bash
brew install yq
```

### [Github Actions usage](https://github.com/marketplace/actions/yq-portable-yaml-processor)

TODO: currently not working
```yaml
- name: yq - portable yaml processor
  uses: mikefarah/yq@4.0.0-alpha2
  with:
    cmds: 
```

### change values in place

```bash
yq w -i service.yaml metadata.name cat
```

## [Managing access using IAM](https://cloud.google.com/sdk/gcloud/reference/beta/run/services/replace)

```bash
  gcloud run services add-iam-policy-binding [SERVICE_NAME] \
    --member="allUsers" \
    --role="roles/run.invoker"
```

**allow everyone to call (for https trigger)**


```bash
gcloud run deploy [SERVICE_NAME] ... --allow-unauthenticated
```


## [Deploy Cloud run with `Service.yaml`](https://cloud.google.com/run/docs/deploying#service)
```bash
gcloud beta run services replace service.yaml --platform managed
```

## Extract Cloud Run configuration

```bash
gcloud run services describe SERVICE --format export > service.yaml
```


## [Managing Cloud Run Service](https://cloud.google.com/run/docs/managing/services#command-line_1)

**list all cloud run services**

```bash
gcloud run services list
```
**Copying a service**

```bash
gcloud run services describe SERVICE --format export > service.yaml
```

adjust yaml configuration

```bash
gcloud beta run services replace service.yaml
```


**Viewing more details about a service**

To view details about a service:

```bash
gcloud run services describe SERVICE
```
Replace SERVICE with the name of the service.
You can use the `--format` flag to format the output. For example as YAML:


```bash
gcloud run services describe SERVICE `--format` yaml
```
You can use `--format` export to export as YAML without automatically generated labels or status:


```bash
gcloud run services describe SERVICE --format export
```
You can also use the `--format` flag to get the URL of the service:

```bash
gcloud run services describe SERVICE --format='value(status.url)'
```

**Deleting existing services**

```bash
gcloud run services delete [SERVICE]
```

## [Define Specific Google Cloud Service Account](https://cloud.google.com/run/docs/configuring/service-accounts#gcloud)


You can download and view existing service configuration using the gcloud run services describe --format export command, which yields cleaned results in YAML format. You can then modify the fields described below and upload the modified YAML using the `gcloud beta run services replace` command. Make sure you only modify fields as documented.

To view and download the configuration:

```bash
gcloud run services describe SERVICE --format export > service.yaml
```

Update the serviceAccountName: attribute:

```yaml
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: SERVICE
spec:
  template:
    spec:
      serviceAccountName: SERVICE_ACCOUNT
```
Replace

**SERVICE** with the name of your Cloud Run service.
**SERVICE_ACCOUNT** with the service account associated with the new identity.
Replace the service with its new configuration using the following command:

```bash
gcloud beta run services replace service.yaml
```


