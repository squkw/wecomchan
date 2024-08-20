FROM --platform=$TARGETPLATFORM golang:alpine3.20 as gobuilder

ENV GO111MODULE="on"
ENV CGO_ENABLED=0

WORKDIR /go/src/app
COPY . .

RUN apk update && apk upgrade && apk add --no-cache ca-certificates
RUN update-ca-certificates
RUN go build

FROM scratch

WORKDIR /root

COPY --from=gobuilder /go/src/app/wecomchan .
COPY --from=gobuilder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

EXPOSE 8080

CMD ["./wecomchan"]
