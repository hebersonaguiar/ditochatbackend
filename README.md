App backend em Go que transmite mensagens recebidas para todos os clientes conectados usando Websockets. Além disso, persiste as últimas 1000 mensagens no Redis e expõe uma API json para recuperá-la.

Repositório base: https://github.com/ditointernet/dito-chat/tree/master/backend

Inspirado no projeto [https://github.com/gorilla/websocket/tree/master/examples/chat](https://github.com/gorilla/websocket/tree/master/examples/chat)

DNS utilizado para essa aplicação: `backend.ditochallenge.com` 

## Tópicos
[Docker](https://github.com/hebersonaguiar/ditochatbackend#docker)

[Dockerfile](https://github.com/hebersonaguiar/ditochatbackend#dockerfile)

[Buil da imagem](https://github.com/hebersonaguiar/ditochatbackend#build-da-imagem)

[Push da imagem](https://github.com/hebersonaguiar/ditochatbackend#push-da-imagem)

[Uso da imagem](https://github.com/hebersonaguiar/ditochatbackend#uso-da-imagem)

[Google Cloud Plataform](https://github.com/hebersonaguiar/ditochatbackend#google-cloud-plataform)

[Jenkins X](https://github.com/hebersonaguiar/ditochatbackend#jenkins-x)

[Kubernetes Engine](https://github.com/hebersonaguiar/ditochatbackend#kubernetes)

[Helm Chart](https://github.com/hebersonaguiar/ditochatbackend#helm-chart)

[Jenkinsfile](https://github.com/hebersonaguiar/ditochatbackend#jenkinsfile)

[Skaffold](https://github.com/hebersonaguiar/ditochatbackend#skaffold)

## Docker
O Docker é uma plataforma para desenvolvedores e administradores de sistemas para desenvolver, enviar e executar aplicativos. O Docker permite montar aplicativos rapidamente a partir de componentes e elimina o atrito que pode ocorrer no envio do código. O Docker permite que seu código seja testado e implantado na produção o mais rápido possível.
Originalmente essa aplicação não foi desenvolvida para docker, porém sua criação é simples e rápido. 

## Dockerfile
No Dockerfile encontra-se todas as informações para a criação da imagem, para esse projeto foi utilizado como base a imagem `golang:latest`, mais abaixo é copiado código da aplicação e a compilação são realizadas para que seja executada corretamente.

Nota: na aplicação é necessário informar alguns dados importantes para o funcionamento, que é a origem da conexão de envio das mensagens, ou seja, o [frontend](https://github.com/hebersonaguiar/ditochatfrontend) e o redis, que é o responsável por salvar as mensagens. Para esse projeto foi criado e configurado os domínios  `frontend.ditochallenge.com` e `redis.ditochallenge.com`, eles são informados no código da aplicação em `main.go`.


## Build da imagem
```bash
git clone https://github.com/hebersonaguiar/ditochatbackend.git
docker build -t hebersonaguiar/ditochatbackend ./ditochatbackend
```
## Push da imagem
```bash
docker push hebersonaguiar/ditochatbackend:latest
```

## Uso da imagem
```bash
docker run docker -dti hebersonaguiar/ditochatbackend
```
## Google Cloud Plataform
Google Cloud Platform é uma suíte de cloud oferecida pelo Google, funcionando na mesma infraestrutura que a empresa usa para seus produtos dirigidos aos usuários, dentre eles o Buscador Google e o Youtube.

Para essa aplicação foram utilizados os seguintes produtos, Cloud DNS, utilizado para o apontamento DNS da aplicação do domínio `ditochallenge.com` para o serviço do kubernetes utilizando o Kubernetes Engine, no qual foi criado um cluster. Todas as informações de como criar o cluster e acessar utilizando o gloud e kubectl estão no repositório [Dito Desafio Docs](https://github.com/hebersonaguiar/ditodesafiodocs#google-cloud-plataform)

## Jenkins X
O Jenkins X possui os conceitos de Aplicativos e Ambientes. Você não instala o Jenkins diretamente para usar o Jenkins X, pois o Jenkins é incorporado como um mecanismo de pipeline como parte da instalação.

Após a criação do cluster kubernetes na GCP utilizando o Jenkins X como informado no repositório [Dito Desafio Docs](https://github.com/hebersonaguiar/ditodesafiodocs#jenkins-x) é necessário importar esse repositório para isso foi utilizado o comando abaixo:

```bash
jx import --url https://github.com/hebersonaguiar/ditochatbackend.git
```
Ao importar esse repositório o Jenkins X se encarrega de criar os artefatos como Jenkinsfile, chart e o skaffold. Após a importação as alterações de vairávies desejadas podem ser realizadas. Lembrando que após o commit das alterações o deploy é iniciado.

Caso não queria que o Jenkins X não crie os artefatos basta executar o comando abaixo:

```bash
jx import --no-draft --url https://github.com/hebersonaguiar/ditochatbackend.git
```

## Kubernetes
Kubernetes ou como é conhecido também K8s é um produto Open Source utilizado para automatizar a implantação, o dimensionamento e o gerenciamento de aplicativos em contêiner no qual agrupa contêineres que compõem uma aplicação em unidades lógicas para facilitar o gerenciamento e a descoberta de serviço

Para essa aplicação foi utilizado o kubernetes na versão `v1.13.7-gke.24`, na Google Cloud Plataform - GCP utilizando o Kubernetes Engine, ou seja, a criação do cluster kubernetes é realizado pela própria GCP, nesse caso utilizamos também o Jenkins X para a criação do cluster e integração entre si, dados de criação do cluster e acessos estão no repositório [Dito Desafio Docs](https://github.com/hebersonaguiar/ditodesafiodocs#kubernetes)

Para essa aplicação foi criado um namespace chamado chatdito, segue abaixo:

```bash
kubectl create namespace chatdito
```
* Importante: Para esse repositório foi criado um namespace específco, caso já exista algum a criação do mesmo não é necessária.

## Helm Chart
O Helm é um gerenciador de aplicações Kubernetes cria, versiona, compartilha e publica os artefatos. Com ele é possível desenvolver templates dos arquivos YAML e durante a instalaçao de cada aplicação personalizar os parâmentros com facilidade.
Para esse repositório o Helm Chart esta dentro da pasta chart na raiz do projeto e dentro contém os arquivos do Chart. Após implantação do projeto descrito no tópico [Jenkins X](https://github.com/hebersonaguiar/ditochatbackend#jenkins-x) o arquivo `values.yaml` deve ser alterado alguns parâmentros como, quantidade de replicas, portas de serviço, resources e outros dados necessários para implantação no kuberntes.

Parametros alterados para essa aplicação em `chart/values.yaml`:
```yaml
...
service:
  name: ditochatbackend
  type: LoadBalancer
  externalPort: 8080
  internalPort: 8080
...
```
Esse paramêtros foram alterados para que o pod seja exposto na porta 8080, dessa forma a aplicação ficará visível pela url http://backend.ditochallenge.com:8080

## Jenkinsfile
O Jenkisfile é um arquivo de configuração utilizado para criação de papeline no Jenkins X, ele suporta três formatos diferentes: Scripted, Declarative e Groovy. 
O jenkinsfile possui alguns estágios
	* Build e Push da imagem
	* Alteração do Chart e push para o Chart Museum
	* Promoção para o ambiente de produção Kubernetes

O acionamento do deploy é iniciado após a execução de um commit, uma vez acionado o Jenkins X executa o jenkinsfile e o fluxo CI/CD é executado.

## Skaffold
Skaffold é uma ferramenta de linha de comando que facilita o desenvolvimento contínuo de aplicações no Kubernetes. O Skaffold lida com o fluxo de trabalho para implantar a aplicação.
No arquivo skaffold.yaml possuem as variáveis como a do registry, imagem, tag, helm chart, não é necessário nehnhuma alteração, elas são realizadas pelo Jenkins X