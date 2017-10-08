.PHONY: clean init build test save publish build_only publish_only

.DEFAULT_GOAL:=build

CONTAINER_NAME:=telegraf

clean:
	sudo docker rmi ${CONTAINER_NAME}\:snapshot | true

init:
	# Download telegraf artifact - really need to be pulling this from a Nexus repo
	wget https://dl.influxdata.com/telegraf/releases/telegraf-1.4.1_linux_armhf.tar.gz
	docker pull docker.io/arm32v7/busybox:latest

build: clean init build_only

build_only:
	sudo docker build -t ${CONTAINER_NAME}\:snapshot .
	# sudo docker tag -t ${CONTAINER_NAME}\:snapshot ${CONTAINER_NAME}\:prod

save:
	sudo docker save -o telegraf_snapshot.tar telegraf:snapshot
	sudo chown `whoami` telegraf_snapshot.tar

publish: save publish_only

publish_only:
	# scp telegraf_snapshot.tar nickv@nighthawk.local:~/.
	ssh nickv@nighthawk.local -C '/usr/bin/docker load -i ./telegraf_snapshot.tar'

test:
	echo 'testing'
