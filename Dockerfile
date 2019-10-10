# Start from the latest golang base image
FROM golang:latest

RUN apt-get update -y && \
    apt install -y dnsutils


# Add Maintainer Info
LABEL maintainer="Heberson Aguiar <hebersonaguiar@gmail.com>"

# Set the Current Working Directory inside the container
WORKDIR /app                                               

COPY client.go hub.go main.go go.mod go.sum ./
COPY docker-entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
ENTRYPOINT ["/entrypoint.sh"]

RUN go get ./...

# Build the Go app
RUN go build ./
                                                                                                       
# Expose port 8080 to the outside world                                                                
EXPOSE 8080

# Command to run the executable                                                                        
CMD ["./ditochatbackend"]
