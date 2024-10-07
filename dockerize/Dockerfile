##STEP1
FROM golang:1.22 as builder

RUN mkdir -p /web && touch /log.txt && chmod 666 /log.txt 

WORKDIR /web/

RUN go mod init webserver && go mod tidy 

COPY . /web/

#Be attention to your archicteture
RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o main ./webserver.go

EXPOSE 8080

CMD ["./main" ]

#STEP2
FROM alpine:latest

#Set the working directory
WORKDIR /web

#Copy the built executable from the builder stage
COPY --from=builder /web/main .
COPY --from=builder /web/src ./src 
COPY --from=builder /web/webserver ./webserver

# Add a user for running the application
RUN adduser -S -D -H -h /web web && chown -R web: /web && apk add curl 

# Switch to the new user
USER web

# Command to run the executable
CMD ["./main"]
