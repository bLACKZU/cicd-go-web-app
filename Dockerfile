FROM golang:1.22.5 AS build
RUN groupadd -g 1200 gouser && \
        useradd -u 1200 -g gouser -s /bin/bash gouser
WORKDIR /app
COPY . .
RUN go mod download
RUN go build -o main .

FROM gcr.io/distroless/base
COPY --from=build /app/main .
COPY --from=build /app/static ./static
EXPOSE 8080
USER 1200:1200
CMD ["./main"]