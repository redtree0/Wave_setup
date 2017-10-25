sudo service docker stop
sudo dockerd -H unix:///var/run/docker.sock -H tcp://0.0.0.0:2376
