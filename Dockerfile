# Start from the latest golang base image
FROM golang:latest

ENV ALLOWED_ORIGIN='http://0.0.0.0:3000'
ENV REDIS_ADDR=0.0.0.0:6379

# Add Maintainer Info
LABEL maintainer="Heberson Aguiar <hebersonaguiar@gmail.com>"

# Set the Current Working Directory inside the container
WORKDIR /app                                               

COPY client.go hub.go main.go go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go get ./...

# Build the Go app
RUN go build .
                                                                                                       
# Expose port 8080 to the outside world                                                                
EXPOSE 8080

# Command to run the executable                                                                        
CMD [./backend]