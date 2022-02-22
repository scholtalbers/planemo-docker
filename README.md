# Planemo Docker

Yet another Docker image containing Planemo and a pre-initialized Galaxy instance.

# Use

- You can start the container from a directory that contains Galaxy tools. The entrypoint of the image runs `planemo serve` and thus
your tools will be hosted in a Galaxy instance.


  ```
  # note that you can change the source directory to another location
  docker run -it --name planemo-docker --mount type=bind,source="$(pwd)",target=/var/opt/tools -P planemo-docker:galaxy-22.01
  ```

- Find the port on which Galaxy is hosted:

  ```
  docker port planemo-docker
  # 9090/tcp -> 0.0.0.0:55002
  ```

  Alternatively if the name is not found:
  ```
  docker ps | grep planemo-docker | cut -d " " -f 1 | xargs docker port
  # 9090/tcp -> 0.0.0.0:55002
  ```

- Test the tool on e.g. http://localhost:55002

# Planemo test

You can start a bash session in the running container and `lint` and `test` your tools:

```
docker exec -it planemo-serve bash
cd /var/opt/tools
planemo test
```

# Build

You can combine different versions of Planemo and Galaxy when building the image. `PLANEMO` specifies the planemo version
available on pypi. `GALAXY` specifies the branch to clone from https://github.com/galaxyproject/galaxy/

```
docker build --build-arg PLANEMO=0.74.9 --build-arg GALAXY=22.01 -t planemo-docker:0.74.9-22.01 .
# or use the dev branch
docker build --build-arg GALAXY=dev -t planemo-docker:0.74.9-dev .
```

