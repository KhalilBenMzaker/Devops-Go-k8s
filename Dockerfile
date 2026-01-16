# ---------- Build stage ----------
FROM golang:1.25-alpine AS build
WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app .

# ---------- Runtime stage ----------
FROM gcr.io/distroless/static:nonroot
WORKDIR /

COPY --from=build /app/app /app

EXPOSE 8080
USER 65532:65532
ENTRYPOINT ["/app"]
