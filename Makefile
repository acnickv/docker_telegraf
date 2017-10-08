.PHONY: clean init build test save publish build_only publish_only

.DEFAULT_GOAL:=build

CONTAINER_NAME:=telegraf
ARTIFACT_NAME:=telegraf-1.4.1_linux_armhf.tar.gz
clean:
	sudo docker rmi ${CONTAINER_NAME}\:snapshot | true

init:
# Download artifact if the file does not exist locally
# TODO: Be sure that a local proxy is present for this action - remove IF logic to always pull, since proxy will be very fast

	test -e ${ARTIFACT_NAME} && \
		echo '${ARTIFACT_NAME} already present' || \
		wget https://dl.influxdata.com/telegraf/releases/${ARTIFACT_NAME} \

# Check for the latest version of this image and pull if available
	docker pull docker.io/arm32v7/busybox:latest

build: clean init build_only

build_only:
	sudo docker build -t ${CONTAINER_NAME}\:snapshot .
	# sudo docker tag -t ${CONTAINER_NAME}\:snapshot ${CONTAINER_NAME}\:prod

save:
	sudo docker save -o ${CONTAINER_NAME}_snapshot.tar ${CONTAINER_NAME}:snapshot
	sudo chown `whoami` ${CONTAINER_NAME}_snapshot.tar

publish: save publish_only

publish_only:
	# scp telegraf_snapshot.tar nickv@nighthawk.local:~/.
	ssh nickv@nighthawk.local -C '/usr/bin/docker load -i ./${CONTAINER_NAME}_snapshot.tar'

test:
	echo 'testing'
