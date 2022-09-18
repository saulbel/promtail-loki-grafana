import os

route = os.path.dirname(os.getcwd()) + '/scripts/setup.sh'

x  = input("Enter your username: ")
x1 = 'USERNAME'

file = open(route, "rt")
data = file.read()
data = data.replace(x1,x)
file.close()
file = open(route, "wt")
file.write(data)
file.close()