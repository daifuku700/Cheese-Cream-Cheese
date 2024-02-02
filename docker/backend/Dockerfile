FROM golang:1.21.6-alpine

WORKDIR /app

COPY go.mod /app

RUN go mod download

RUN apk add --no-cache git sqlite-dev gcc musl-dev
