# Custom RStudio notebook for LANDER
ARG OWNER=vvcb
ARG BASE_CONTAINER=jupyter/r-notebook
FROM $BASE_CONTAINER

LABEL maintainer="vvcb"

COPY jupyter_notebook_config.json /etc/jupyter/jupyter_notebook_config.json
RUN pip install --quiet --no-cache-dir \
    jupyter-rsession-proxy \
    jupyter-server-proxy \
    && mamba install --yes  \
    open-fonts \
    openssl \
    r-lme4 \
    r-factominer \
    r-mice \
    r-gam \
    && mamba clean --all -f -y

USER root
RUN apt update
RUN apt install --yes --no-install-recommends software-properties-common dirmngr

RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc

RUN add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

RUN apt install --yes --no-install-recommends r-base

RUN apt-get install --yes gdebi-core 

# Todo: Ensure this next layer is safe
#RUN chown -R ${NB_USER} /var/log/rstudio-server \
#    && chown -R ${NB_USER} /var/lib/rstudio-server \
#    && echo server-user=${NB_USER} > /etc/rstudio/rserver.conf
ENV PATH=$PATH:/usr/lib/rstudio-server/bin
ENV RSESSION_PROXY_RSTUDIO_1_4=True
RUN fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
# Switch back to normal user. Ensure this is always the last step.
USER ${NB_USER}

