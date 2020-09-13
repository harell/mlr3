# R Package Development: Core --------------------------------------------------
FROM rocker/rstudio:4.0.0

# Setup ------------------------------------------------------------------------
RUN apt-get update && apt-get install -y \
    dos2unix \
    libcurl4-openssl-dev \
    libssl-dev \
	libxt-dev \
    libxml2-dev \
    libpq-dev \
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure RStudio Server -----------------------------------------------------
ARG R_REPOS=\'https://mran.microsoft.com/snapshot/2020-04-24\'
RUN touch .env .Rprofile
RUN echo "options(repos = ${R_REPOS})" >> .Rprofile

RUN R -q -e "if(!require(remotes)) install.packages('remotes')"
RUN echo "install_cran <- remotes::install_cran" >> .Rprofile
RUN echo "install_deps <- remotes::install_deps" >> .Rprofile
RUN echo "install_github <- remotes::install_github" >> .Rprofile
RUN R -q -e "install_cran('tidyverse', dependencies = TRUE)"

RUN R -q -e "install_cran(c('profvis', 'renv', 'tinytex'))"
RUN R -q -e "install_cran(c('devtools', 'testthat', 'covr', 'roxygen2'))"
RUN R -q -e "tinytex::install_tinytex()"

# mlr3 Packages ----------------------------------------------------------------
RUN R -q -e "install_cran('mlr3verse', dependencies = TRUE)"
RUN R -q -e "install_cran(c('mlr3db', 'mlr3data', 'mlr3measures', 'mlr3misc'))"
#RUN R -q -e "install_github(c( \
#  'mlr3learners/mlr3learners.randomforest@v0.1.2', \
#  'mlr3learners/mlr3learners.extratrees@v0.2.0' \
#  ))"

# Install Project Dependencies -------------------------------------------------
COPY ./DESCRIPTION ./DESCRIPTION
RUN R -q -e "install_deps(dependencies = 'Depends')"
RUN R -q -e "install_deps(dependencies = 'Imports')"
RUN R -q -e "install_deps(dependencies = 'Suggests')"

# Run RStudio Server -----------------------------------------------------------
ENV HOME /home/rstudio
ENV R_USER /home/rstudio
RUN printenv >> .env
RUN cp .env home/rstudio/.Renviron
RUN chown rstudio:rstudio home/rstudio/
ENV PASSWORD 1234
ENV ROOT true
