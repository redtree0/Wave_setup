#!/bin/bash

if [ $# -lt 1 ]; then
	echo "HOST IP Addree Need"
	exit 0
fi 
HOST=$1

sudo openssl genrsa -aes256 -out ca-key.pem 4096
sudo openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
sudo openssl genrsa -out server-key.pem 4096
sudo openssl req -subj "/CN=HOST" -sha256 -new -key server-key.pem -out server.csr



echo "subjectAltName = IP:$HOST,IP:127.0.0.1" > extfile.cnf

sudo openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf

ls 

sudo sudo openssl genrsa -out key.pem 4096 
openssl req -subj '/CN=client' -new -key key.pem -out client.csr

echo extendedKeyUsage = clientAuth > extfile.cnf

sudo openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out cert.pem -extfile extfile.cnf

sudo rm -v client.csr server.csr
sudo chmod -v 0400 ca-key.pem key.pem server-key.pem
sudo chmod -v 0444 ca.pem server-cert.pem cert.pem

sudo service docker stop
sudo dockerd --tlsverify --tlscacert=ca.pem --tlscert=server-cert.pem --tlskey=server-key.pem -H=0.0.0.0:2376


