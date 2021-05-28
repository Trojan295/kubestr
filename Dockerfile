FROM golang:alpine3.12 AS builder

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=$TARGETPLATFORM

WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN go build -o /dist/kubestr -ldflags="-w -s" .

FROM alpine:3.12

RUN apk --no-cache add fio

COPY --from=builder /dist/kubestr /

ENTRYPOINT ["/kubestr"]
