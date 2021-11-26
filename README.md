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

 * API Keys
 * Token Auth

## Criar compartimento

## Criar grupo dinâmico <DeployDynamicGroup> para a pipeline

Any {resource.type = 'devopsdeploypipeline', resource.compartment.id = 'ocid1.tenancy.oc1..***********************'}

## Criar política de segurança para o grupo

Allow dynamic-group DeployDynamicGroup to manage all-resources in compartment id ocid1.tenancy.oc1..******************
 
## Criar cluster kubernetes
 
## Criar container registry
 
## Criar tópico para receber notificações
 
## Criar projeto DevOps
 
### Criar repositório de código
 
#### clonar repositório

git clone <repositório>
usuário: tenancy/oracleidentitycloudservice/user
senha: <Auth Token>
 
#### criar projeto helidon
 
```
mvn "-U" "archetype:generate" "-DinteractiveMode=false" "-DarchetypeGroupId=io.helidon.archetypes" "-DarchetypeArtifactId=helidon-quickstart-mp" "-DarchetypeVersion=1.4.0" "-DgroupId=io.helidon.examples" "-DartifactId=helidon-quickstart-mp" "-Dpackage=io.helidon.examples.quickstart.mp"
cd helidon-quickstart-mp
git add .
git commit -m "commit inicial"
git push
```
 
#### configurar o projeto para a pipeline
 
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
