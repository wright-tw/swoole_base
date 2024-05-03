docker build --platform=linux/amd64 -t=wright1992/swoole_base:amd64 .
docker push wright1992/swoole_base:amd64
docker build --platform=linux/s390x -t=wright1992/swoole_base:s390x .
docker push wright1992/swoole_base:s390x
docker manifest rm wright1992/swoole_base
docker manifest create wright1992/swoole_base wright1992/swoole_base:amd64 wright1992/swoole_base:s390x
docker manifest push wright1992/swoole_base