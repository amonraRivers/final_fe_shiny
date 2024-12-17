# Use an official R runtime as a parent image
# The 4.4.0 version is choosen for compatibility with libpq-dev library
FROM rocker/shiny:4.3.1

# Install required libraries
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && apt-get clean

# Install R packages, if you want to install also
# the dependencies for Postgres install also
# RPostgres
RUN R -e "install.packages(c('shiny', 'shinyalert','feather','ggplot2', 'dplyr', 'corrplot','tidyverse'))" 

# Copy the app files into the Docker image
COPY ./src/ /srv/shiny-server/

# Expose port
EXPOSE 3838

# Run the app
CMD ["/usr/bin/shiny-server"]
