export PATH := $(GOPATH)/bin:$(PATH)
export GO111MODULE=on
LDFLAGS := -s -w
PROJECT:=easy-admin
VERSION := 1.1.0


.PHONY: build

all: 
	make build-ui
	make build

build-ui:
	@echo "build node start"
	cd ./ui/ && npm run build:prod

build:
	CGO_ENABLED=0 go build -ldflags="$(LDFLAGS)" -a -installsuffix "" -o $(PROJECT) .

# make build-linux
build-linux:
	make build-ui
	make build
	@docker build -t $(PROJECT):$(VERSION) .
	@echo "build successful"

build-sqlite:
	go build -tags sqlite3 -ldflags="$(LDFLAGS)" -a -installsuffix -o $(PROJECT) .

test:
	go test

restart:
	make stop
	make start

start:
	nohup ./$(PROJECT) server -c=config/settings.dev_steve.yml >> acc.txt &

stop:
	ps aux | grep $(PROJECT) | grep -v grep | awk '{print $2}' | xargs -r kill -9