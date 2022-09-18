import os

route = os.path.dirname(os.getcwd()) + '/alertmanager-config.yaml'

x  = input("Enter slackwebhook: ")
x1 = 'SLACK_WEBHOOK'
y  = input("Enter slack channel: ")
y1 = 'SLACK_CHANNEL'

file = open(route, "rt")
data = file.read()
data = data.replace(x1,x)
data = data.replace(y1,y)
file.close()
file = open(route, "wt")
file.write(data)
file.close()