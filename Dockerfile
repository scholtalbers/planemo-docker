FROM ubuntu:jammy

LABEL maintainer "Jelle Scholtalbers<j.scholtalbers@gmail.com>"

ARG GALAXY=release_22.01
ARG PLANEMO=0.74.9

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y python3 python3-pip git curl && rm -rf /var/lib/apt/lists/* 
RUN pip install --no-cache-dir planemo==$PLANEMO && \
    git clone --depth 1 --branch $GALAXY https://github.com/galaxyproject/galaxy.git /var/opt/galaxy && \
    cd /var/opt/galaxy && ./scripts/common_startup.sh && \
    . ./.venv/bin/activate && \
    pip install --no-cache-dir -r lib/galaxy/dependencies/dev-requirements.txt && \
    planemo test --galaxy_root=/var/opt/galaxy /var/opt/galaxy/tools/sr_mapping; \
    rm -rf ~/.npm ~/.cache /var/opt/galaxy/config/plugins/visualizations

EXPOSE 9090/tcp

ENTRYPOINT ["planemo", "serve", "--port", "9090", "--host", "0.0.0.0", "--galaxy_root", "/var/opt/galaxy", "/var/opt/tools"]
