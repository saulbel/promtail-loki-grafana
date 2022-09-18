# Promtail-loki-grafana
## Prerequisites
* `Docker`
* `Docker-compose`
* `Slack`

## Project structure
```
promtail-loki-grafana
|── alertmanager-config.yaml
|── docker-compose.yaml
|── loki-config.yaml
|── promtail-config.yaml
|── rules.yml
|── provisioning
|    └── datasources
|         └── loki-ds.yml
└── scripts
     └── setup.sh
     └── replace-slack.py
     └── replace-setup.py
```
## Tasks to accomplish
- The main idea of this project is to implement a logging solution to monitorize our infra. We are gonna use the `PLG` stack.
- Configure `loki`, `promtail`, `grafana` ,`alertmanager` using `docker-compose`.
- Use `Slack` to recieve the alerts.

## How to install the tools
I have included a custom script `setup.sh` that allows you to install `docker`, `docker-compose` on `Debian`.
I recommend to download it and change it with your `username` because I have decided to add my `user` to `docker group`. It is a good practice to run docker with a user instead of as `root`.
In order to change your username you can do it manually or you can use `replace-setup.py` script.

## How to setup this project locally
- First we should download it with either `git clone` or as `.zip`.
- Then we will execute `/scripts/replace-setup.py` in order to change `setup.sh` username.
- Finally we will execute `/scripts/setup.sh`

## First task: configure Slack
- We will have to install `Slack` and create a `channel`. Then we will create a `webhook` for that channel and we will include both in `alermanager-config.yaml`. In order to do it we can execute `/scripts/replace-slack.py`.

## Scond task: configure the monitoring stack
- In order to do this we are gonna use `docker-compose.yml`. The whole idea of using `docker-compose` is to simplify it as much as posible because we could install all these tools as services. So where are gonna use `docker images` and `volumes` to both install and put the config files in containers.
- Once we have all ready, we just have to:
````
$ docker-compose up -d
Creating promtail-loki-grafana_promtail_1 ... done
Creating promtail-loki-grafana_grafana_1  ... done
Creating alertmanager                     ... done
Creating loki                             ... done
Creating webservice                       ... done
Creating http-client                      ... done
````
- To check the status of the containers:
````
$ docker ps
CONTAINER ID   IMAGE                        COMMAND                  CREATED          STATUS          PORTS                                       NAMES
72bc1d84875f   alpine                       "sh -c 'sh -s << EOF…"   12 seconds ago   Up 11 seconds                                               http-client
7c51fe417a6f   nginx                        "/docker-entrypoint.…"   14 seconds ago   Up 12 seconds   0.0.0.0:8000->80/tcp, :::8000->80/tcp       webservice
f004e74b6cd9   grafana/loki:latest          "/usr/bin/loki -conf…"   15 seconds ago   Up 13 seconds   0.0.0.0:3100->3100/tcp, :::3100->3100/tcp   loki
0ab35811b4dc   prom/alertmanager:latest     "/bin/alertmanager -…"   18 seconds ago   Up 15 seconds   0.0.0.0:9093->9093/tcp, :::9093->9093/tcp   alertmanager
ae6d780652ae   grafana/grafana-oss:latest   "/run.sh"                18 seconds ago   Up 15 seconds   0.0.0.0:3000->3000/tcp, :::3000->3000/tcp   promtail-loki-grafana_grafana_1
44d1198cd4f5   grafana/promtail:latest      "/usr/bin/promtail -…"   18 seconds ago   Up 15 seconds                                               promtail-loki-grafana_promtail_1
````

## To sum up
Now we can have access to all these tools with a web browser.
- To access grafana
````
localhost:3000
````
- To access alertmanager
````
localhost:9093
````
- To access loki
````
localhost:3100/metrics
````

Let´s explain a little bit more about how this stack works. 
- `Loki` --> this tool allows to store logs from other servers, in this case we have used promtail as agent.
- `Alertmanager` --> taking the data we have in Loki, we are able to create alerts. These alerts can be sent to programs such us `telegram`, `teams` or in this case `slack`. We can use email to send this alerts too.
- `Promtail` --> this is the agent in charge of collecting the logs in the server/container for Loki. There are more agents, for example we can use `fluentbit/fluentd`.
- `Grafana` --> this software allows us to create dashboards to have all our data configured in a good looking way. It will connect to loki in order to do so.
- `Slack` --> if your company uses this communication tool, you can propose it as an alert reciever too. With this set up all the alerts go to a single channel but we could configure more than one. We can use tags in `rules.yml` to change the severity or even the enviroment of the alerts and we can send them to one channel or another.
- You may wonder about `webservice` and `http-client` containers. The porpouse of these two are just to send petitions with `curl` (http-client) into an `nginx` (webservice) so we can get these logs and create an alert through `alertmanager`.
