App backend em Go que transmite mensagens recebidas para todos os clientes conectados usando Websockets. Além disso, persiste as últimas 1000 mensagens no Redis e expõe uma API json para recuperá-la.

Inspirado no projeto [https://github.com/gorilla/websocket/tree/master/examples/chat](https://github.com/gorilla/websocket/tree/master/examples/chat)

## Docker
O Docker é uma plataforma para desenvolvedores e administradores de sistemas para desenvolver, enviar e executar aplicativos. O Docker permite montar aplicativos rapidamente a partir de componentes e elimina o atrito que pode ocorrer no envio do código. O Docker permite que seu código seja testado e implantado na produção o mais rápido possível.
	Originalmente essa aplicação não foi desenvolvida para docker, porém sua criação é simples, abaixo e rápido. 

## Dockerfile
No Dockerfile encontra-se todas as informações para a criação da imagem, para esse projeto foi utilizado como base a imagem `golang:latest`, mais abaixo o código da aplicação e a compilação são realizadas para que seja executada corretamente.

## Entrypoint
No Docekrfile é copiado um arquivo chamado docker-entrypoint.sh no qual é um ShellScript que recebe os parâmentros necessários para execução da aplicação são eles:
- `ALLOWED_ORIGIN`: resposável pro aceitar requisições de uma determinada origem. Ex: `http://localhost:3000`
- `REDIS_ADDR`: resposável por receber as mensagem enviadas. Ex: `localhost:6379`

O docker-entrypoint.sh realiza uma checagem verificando se os valores foram informados, se sim as variáveis são alteradas no arquivo `main.go`, se não o container não inicializa infomrmando log de como inicializar o container.

## Build da imagem local
```bash
git clone https://github.com/hebersonaguiar/ditochatbackend.git
docker build -t hebersonaguiar/ditochatbackend ./ditochatbackend
```
## Uso da imagem
* Para o pleno funcionamento da aplicação é necessário o apontamento do serviço do redis na porta 6379
```bash
docker run docker run -dti -e ALLOWED_ORIGIN='http://localhost:3000' \
	   -e REDIS_ADDR='localhost:6379' \
	   hebersonaguiar/ditochatbackend
```

## Helm Chart
O Helm é um gerenciador de aplicações Kubernetes cria, versiona, compartilha e publica os artefatos. Com ele é possível desenvolver templates dos arquivos YAML e durante a instalaçao de cada aplicação persnalizar os parâmentros com facilidade.
Para esse repositório o Helm Chart esta dentro da pasta chart na raiz do projeto e dentro contém os arquivos do Chart, na implantação do projeto o arquivo `values.yaml` deve ser alterado alguns parâmentros como, quantidade de replicas, portas de serviço, resources e outros dados necessários para implantação no kuberntes.

Parametros alerados para essa aplicação:
```yaml
service:
  name: backend
  type: LoadBalancer
  externalPort: 8080
  internalPort: 8080
```
* Importante:
No arquivo `chart/template/deployment.yaml` possui duas variáveis `ALLOWED_ORIGIN` e `REDIS_ADDR` que foram informadas no tópico Entrypoint, para que elas sejam informadas para o container foi criado um configmap do Kubernetes com o nome chat-backend-values, sua execução foi informada anteriormente no topico Kubernetes.


## Jenkinsfile
O Jenkisfile é um arquivo de configuração utilizado para criação de papeline no Jenkins, ele suporta três formatos diferentes: Scripted, Declarative e Groovy. 
Para esse repositório ele foi criado na instlação do Jenkins X no cluster Kubernetes descrito no repositório {repositorio de doc}, nele possuem alguns estágios 
* Build e Push da imagem
* Alteração do Chart e push para o Chart Museum
* Promoção para o ambiente de produção Kubernetes
O acionamento do deploy é executado após a execução de um commit, uma vez acionado o Jenkins X executa o Jenkinsfile e o deploy da aplicação é realizada.

## Skaffold
Skaffold é uma ferramenta de linha de comando que facilita o desenvolvimento contínuo de aplicações no Kubernetes. O Skaffold lida com o fluxo de trabalho para implantar a aplicação.
No arquivo skaffold.yaml possuem as variáveis como a do registry, imagem, tag, helm chart, não é necessário nehnhuma alteração, elas são realizadas pelo Jenkins X