BROKER_BINARY=brokerApp
LOGGER_BINARY=loggerApp

# Images name to be pushed to docker hub
BROKER_IMAGE := biostech/grpc-broker-service:1.0.0
LOGGER_IMAGE := biostech/grpc-logger-service:1.0.0


# up: starts all containers in the background without forcing build
up: ## Start all containers in the background without forcing build
	@echo "Starting Docker images..."
	docker compose up -d
	@echo "Docker images started!"

# down: stop docker compose
down: ## Stop Docker Compose
	@echo "Stopping Docker Compose..."
	docker compose down
	@echo "Done!"

# up_build: stops docker compose (if running), builds all projects and starts docker compose
up_build:   build_broker_service  build_logger_service  ## Stop, build, and start Docker Compose
	@echo "Stopping Docker images (if running...)"
	docker compose down
	@echo "Building (when required) and starting Docker images..."
	docker compose up --build
	@echo "Docker images built and started!"



# build_broker_service: builds the broker binary as a linux executable
build_broker_service: ## Build the broker service binary
	@echo "Building broker service binary..."
	@cd ../broker-service && env GOOS=linux CGO_ENABLED=0 go build -o ${BROKER_BINARY} ./cmd/api
	@echo "Done!"


# build_logger_service: builds the logger binary as a linux executable
build_logger_service: ## Build the logger service binary
	@echo "Building logger service binary..."
	@cd ../logger-service && env GOOS=linux CGO_ENABLED=0 go build -o ${LOGGER_BINARY} ./cmd/api
	@echo "Done!"




# push_broker_service: push broker service to docker hub
build_push_broker_service: ## Push the broker service to Docker Hub
	cd ../broker-service/ && docker build --no-cache -f Dockerfile -t $(BROKER_IMAGE) . && docker push $(BROKER_IMAGE)


# push_logger_service: push logger service to docker hub
build_push_logger_service: ## Push the logger service to Docker Hub
	cd ../logger-service/ && docker build --no-cache -f Dockerfile -t $(LOGGER_IMAGE) . && docker push $(LOGGER_IMAGE)



# help: list all make commands
help: ## Show this help
	@echo "Available commands:"
	@awk 'BEGIN {FS = ":.*##"; printf "\n"} /^[a-zA-Z0-9_-]+:.*##/ { printf "  %-30s %s\n", $$1, $$2 } /^##@/ { printf "\n%s\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: build_broker_service build_logger_service 
		





#----------------------------------------Kubernetes commands-----------------------------------------------#
# encode a secret - base64: echo -n 'redis' | base64
# decode a secret - base64: echo 'cmVkaXMuCg==' | base64 --decode; echo
# decode a secret - kubectl: kubectl get secret secret -o jsonpath="{.data.REDIS_URL}" | base64 --decode




#------------------------------------Packages installed for react-native app-----------------------------------------#
#1. create reat-app - expo init my-new-project
#2. react-navigation   https://reactnavigation.org/docs/getting-started
#3. screen components get {route, navigation } props automatically
#4. icons -  https://docs.expo.dev/guides/icons/
# cd cmp/api go test -v .