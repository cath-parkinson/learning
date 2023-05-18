FROM openanalytics/r-base:4.0.2

# system libraries of general use
# updated libssl1.0.0 to libssl1.1 as it has been dropped from ubuntu now
# added xml2 cmake libnlopt-dev needed for these r packages
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libssl1.0.0 \
    libxml2-dev \
    cmake \
    libnlopt-dev

# install packages
RUN R -e "install.packages('shiny', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "install.packages('googleCloudStorageR', repos = c(CRAN = 'https://cloud.r-project.org'))"

# create and navigate to working directory called app
WORKDIR /app

# copy over the file that sets the port options for shiny
COPY Rprofile.site /usr/lib/R/etc/

# create and navigate to working directory called app
WORKDIR /app

# copy all files into the docker image with period for source and destination
ADD . .

# set up relevant port
EXPOSE 3838

# final COMMAND instruction which tells the container how to run the actual application
# note this command is in exec form a run of strings
# unlike a regular command it does not set up a shell session
CMD ["R", "-e", "shiny::runApp()"]
