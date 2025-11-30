FROM golang:1.25 AS builder

WORKDIR /app


COPY go.mod go.sum* ./
RUN go mod download

COPY main.go ./

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -o backend main.go


FROM alpine:latest

WORKDIR /app

# Copy binary from builder
COPY --from=builder /app/backend .

EXPOSE 5000

CMD ["./backend"]