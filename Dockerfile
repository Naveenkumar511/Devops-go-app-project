#Stage 1: Build
FROM golang:1.22.5 AS build
WORKDIR /app
COPY go.mod ./
RUN go mod download
COPY main.go ./
COPY main_test.go ./
COPY static ./static  
#RUN go build -o myapp .
RUN CGO_ENABLED=0 GOOS=linux go build -o myapp .

#Stage 2: Running 

FROM istio/distroless:1.30-2026-07-05T19-03-13 
WORKDIR /app
COPY --from=build /app/myapp .
COPY --from=build /app/static ./static
EXPOSE 8080
CMD ["./myapp"]



