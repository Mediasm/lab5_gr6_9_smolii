Commands:
docker build -f .\Dockerfile --build-arg VERSION=3.0.1 -t scratch_nginx:v3 .
docker run -d -p 8083:80 --name web-app-86_64_3 scratch_nginx:v3