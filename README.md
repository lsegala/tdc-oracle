# Criar conta na Oracle Cloud
https://www.oracle.com/cloud/free/
Start for free

# Conhecendo a plataforma
* Overview
* O que iremos precisar?
* Compute -> Instances
* Developer Services -> Kubernetes Clusters (OKE)
* Developer Services -> Container Registry
* Developer Services -> DevOps -> Projects
* Developer Services -> Application Integration -> Notifications
* Identity & Security -> Users
* Identity & Security -> Dynamic Groups
* Identity & Security -> Compartments

## Instalando a ferramenta oci e kubectl

* https://docs.oracle.com/pt-br/iaas/Content/API/SDKDocs/cliinstall.htm
* https://kubernetes.io/docs/tasks/tools/

## Criar usuário para o laboratório

* Grupo OCI_Administrators
* API Keys
* Token Auth

## Criar compartimento e anotar o OCID

## Criar cluster kubernetes

## Criar container registry

## Criar tópico para receber notificações

### Adicionar notificação por email

## Criar projeto DevOps

### Habilitar log

### Criar repositório de código

#### clonar repositório

git config --global user.email "you@example.com"
git config --global user.name "Your Name"
git clone <repositório>
usuário: tenancy/oracleidentitycloudservice/user
senha: <Auth Token>

#### criar projeto helidon

```
mvn "-U" "archetype:generate" "-DinteractiveMode=false" "-DarchetypeGroupId=io.helidon.archetypes" "-DarchetypeArtifactId=helidon-quickstart-mp" "-DarchetypeVersion=1.4.10" "-DgroupId=io.helidon.examples" "-DartifactId=helidon-quickstart-mp" "-Dpackage=io.helidon.examples.quickstart.mp"
cd helidon-quickstart-mp
git add .
git commit -m "commit inicial"
git push
```

#### configurar o projeto para a pipeline

Criar secret
```
kubectl create secret docker-registry ocir --docker-server=gru.ocir.io --docker-username=$NAMESPACE/oracleidentitycloudservice/$USER --docker-password="$TOKEN" --docker-email=$EMAIL
```

modificar o app.yaml

adicionar o pull secret
```
      imagePullSecrets:
        - name: ocir
```

apontar para a imagem do repositório
```
        image: gru.ocir.io/grwiwwxgzucj/hello-world:latest 
```

modificar o service de ClusterIP para LoadBalancer
```
  type: LoadBalancer 
```

modificar versão do deployment
```
apiVersion: apps/v1
```

adicionar o arquivo build_spec.yaml
```
version: 0.1
component: build
timeoutInSeconds: 6000
shell: bash
env:
  exportedVariables:
    - BuildHelloWorldVersion

steps:
  - type: Command
    name: "Build Source"
    timeoutInSeconds: 4000
    command: |
      mvn clean install
  - type: Command
    timeoutInSeconds: 400
    name: "Dockerizer"
    command: |
      BuildHelloWorldVersion=`echo ${OCI_BUILD_RUN_ID} | rev | cut -c 1-7`
      echo $BuildHelloWorldVersion
      docker build -t gru.ocir.io/grwiwwxgzucj/hello-world:latest .

outputArtifacts:
  - name: hello-world
    type: DOCKER_IMAGE
    location: gru.ocir.io/grwiwwxgzucj/hello-world:latest
```

## Criar grupo dinâmico <DeployDynamicGroup> para a pipeline

Any {resource.type = 'devopsdeploypipeline', resource.compartment.id = 'ocid1.tenancy.oc1..***********************'}

## Criar política de segurança para o grupo

Allow dynamic-group DeployDynamicGroup to manage all-resources in compartment id ocid1.tenancy.oc1..******************

## Criar build pipeline

### Build
### Delivery

stage name: delivery

create artifact
- name: <nome>
- type: Container image repository
- artifact source: gru.ocir.io/<namespace>/<repo>:${app_version}
- replace parameters: Yes

## Criar artefato (app.yaml)

## Criar ambiente (enviroment)

## Adicionar etapa de delivery na pipeline

# Helidon Quickstart MP Example

This example implements a simple Hello World REST service using MicroProfile.

## Build and run

With JDK8+
```bash
mvn package
java -jar target/helidon-quickstart-mp.jar
```

## Exercise the application

```
curl -X GET http://localhost:8080/greet
{"message":"Hello World!"}

curl -X GET http://localhost:8080/greet/Joe
{"message":"Hello Joe!"}

curl -X PUT -H "Content-Type: application/json" -d '{"greeting" : "Hola"}' http://localhost:8080/greet/greeting

curl -X GET http://localhost:8080/greet/Jose
{"message":"Hola Jose!"}
```

## Try health and metrics

```
curl -s -X GET http://localhost:8080/health
{"outcome":"UP",...
. . .

# Prometheus Format
curl -s -X GET http://localhost:8080/metrics
# TYPE base:gc_g1_young_generation_count gauge
. . .

# JSON Format
curl -H 'Accept: application/json' -X GET http://localhost:8080/metrics
{"base":...
. . .

```

## Build the Docker Image

```
docker build -t helidon-quickstart-mp .
```

## Start the application with Docker

```
docker run --rm -p 8080:8080 helidon-quickstart-mp:latest
```

Exercise the application as described above

## Deploy the application to Kubernetes

```
kubectl cluster-info                         # Verify which cluster
kubectl get pods                             # Verify connectivity to cluster
kubectl create -f app.yaml               # Deploy application
kubectl get service helidon-quickstart-mp  # Verify deployed service
```
