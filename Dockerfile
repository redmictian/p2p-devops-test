# Build
FROM golang:1.20-alpine AS builder

WORKDIR /app

COPY . .

RUN go mod init app && go mod tidy

RUN go build -o main .

# Run
FROM alpine:latest

# non-root user and group setup
ARG USER_ID=10001
ARG GROUP_ID=10001

RUN addgroup -g $GROUP_ID appgroup && \
    adduser -u $USER_ID -G appgroup -S appuser

WORKDIR /app

COPY --from=builder /app/main ./main

RUN chown -R $USER_ID:$GROUP_ID /app

USER $USER_ID:$GROUP_ID

EXPOSE 3000

CMD ["./main"]