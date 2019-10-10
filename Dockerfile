# Imagem base 
FROM golang:latest

# Atualização da imagem
RUN apt-get -y update 

# Mantenedor da Imagem
LABEL maintainer="Heberson Aguiar <hebersonaguiar@gmail.com>"

# Diretório padrão da imagem
WORKDIR /app                                               

#Cópia do código fonte para o diretório padrão
COPY client.go hub.go main.go go.mod go.sum ./

# Download das dependências. As Dependências serão chacheadas se os arquivos go.mod and go.sum não forem alterados
RUN go get ./...

# Compilação da aplicação Go
RUN go build ./
                                                                                                       
# Expondo a porta 8080                                                                
EXPOSE 8080

# Comando de execução da aplicação.
CMD ["./ditochatbackend"]