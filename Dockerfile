# ---------- Etapa 1: build ----------
FROM golang:1.23-alpine AS builder

WORKDIR /app

COPY go.mod go.sum* ./
COPY . .

RUN go mod tidy

RUN CGO_ENABLED=0 GOOS=linux go build -o auth-service .

# ---------- Etapa 2: imagem final ----------
FROM alpine:3.20

WORKDIR /app

RUN apk add --no-cache ca-certificates

COPY --from=builder /app/auth-service .

EXPOSE 8001

ENTRYPOINT ["./auth-service"]