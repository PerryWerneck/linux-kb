#!/usr/bin/python3

import requests
import os

repository_root = '/repo-sle15sp5'
destination_path = '/tmp/repos/'
server_address = '127.0.0.1'

def getFiles():

	list = []
	with open('/var/log/apache2/access_log') as logfile:
		for line in logfile.readlines():
			index = line.find('"GET ' + repository_root)
			if index < 0:
				continue
			line = line[(index+5):(line.find(' ',index+6))]
			list.append(line)

	list.sort()

	return set(list)
        
list = getFiles()
print('Baixar {} arquivos'.format(len(list)))

for path in list:
	target = destination_path + path

	if os.path.exists(target):
		print('{} já existe'.format(path))
		continue

	os.makedirs(os.path.dirname(target), exist_ok=True)
	print('Baixando {}'.format(path))

	response = requests.get('http://' + server_address + path)
	
	if response.status_code == 200:
		with open(target, "wb") as file:
			file.write(response.content)
