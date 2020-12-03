FROM golang:alpine as builder

WORKDIR /go/src/app

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags "-w -s" -installsuffix cgo -o /app main.go

FROM scratch

COPY --from=builder /app /app

CMD ["/app"]