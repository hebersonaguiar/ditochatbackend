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


## Build
Entre no diretório `backend`:
* Execução sem Docker

```bash
go get ./...
go build .
```

## Usage
* Execução sem Docker

```bash
./backend --help

Usage of ./backend:
  -addr string
    	http service address (default ":8080")
```

## Run
* Execução sem Docker

```bash
ALLOWED_ORIGIN='http://localhost:3000' REDIS_ADDR=localhost:6379 ./backend
```
