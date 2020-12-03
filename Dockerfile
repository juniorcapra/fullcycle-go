# FROM golang:1.14.12-alpine3.11 as builder

# ADD . /app
# WORKDIR /app

# RUN go build -o main .


# FROM alpine
# WORKDIR /var/www
# COPY --from=builder /app .
# CMD ["/var/www/main"]


# Multi-stage Builds
FROM golang:1.14.4-alpine AS builder
WORKDIR /go/src/github.com/juniorcapra/api/
COPY . .
RUN CGO_ENABLED=0 GOOS=linux \
  go build -a -installsuffix cgo -ldflags="-s -w" -o web_api ./main.go

FROM alpine:latest AS runtime
WORKDIR /root/
RUN apk --no-cache add ca-certificates
COPY --from=builder /go/src/github.com/seu-repo/api/web_api .
CMD ["./web_api"]


# FROM golang:1.7.3 AS builder
# WORKDIR /var/www
# RUN go get -d -v golang.org/x/net/html
# COPY app.go .
# RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .
# FROM alpine:latest
# RUN apk --no-cache add ca-certificates
# WORKDIR /root/
# COPY --from=builder /var/www/app .
# CMD ["./app"]