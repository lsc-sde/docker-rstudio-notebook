# docker-r-rstudio
Docker Image for Jupyter R RStudio

## Building the docker image
```bash
az acr build -r crlander -f Dockerfile -t vvcb/rstudio-notebook:latest -t vvcb/rstudio-notebook:0.2.0 .
```