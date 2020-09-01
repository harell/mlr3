# R Package Development: Core --------------------------------------------------
FROM rocker/tidyverse:4.0.0

# Setup ------------------------------------------------------------------------
RUN apt-get update && apt-get install -y \
    dos2unix \
    r-cran-rjava \
    libcurl4-openssl-dev \
    libssl-dev \
	  libxt-dev \
    libxml2-dev \
    libpq-dev \
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN R CMD javareconf -e

# Configure RStudio Server -----------------------------------------------------
ARG R_REPOS=\'https://mran.microsoft.com/snapshot/2020-04-24\'
RUN touch .env .Rprofile
RUN echo "options(repos = ${R_REPOS})" >> .Rprofile
RUN R -q -e "if(!require(remotes)) install.packages('remotes')"
RUN R -q -e "remotes::install_cran(c('profvis', 'renv', 'tinytex'))"
RUN R -q -e "remotes::install_cran(c('devtools', 'testthat', 'covr', 'roxygen2'))"
RUN R -q -e "tinytex::install_tinytex()"

# mlr3 Packages ----------------------------------------------------------------
RUN R -q -e "remotes::install_cran(c(\
    'mlr3',     'mlr3learners', 'mlr3pipelines', \
    'mlr3db',   'mlr3data',     'mlr3measures', \
    'mlr3misc', 'mlr3verse',    'mlr3viz', \
    'paradox'  \
  ))"

#RUN R -q -e "remotes::install_github(c( \
#  'mlr3learners/mlr3learners.randomforest@v0.1.2', \
#  'mlr3learners/mlr3learners.extratrees@v0.2.0' \
#  ))"

# Install Project Dependencies -------------------------------------------------
COPY ./DESCRIPTION ./DESCRIPTION
RUN R -q -e "remotes::install_deps(dependencies = 'Depends')"
RUN R -q -e "remotes::install_deps(dependencies = 'Imports')"
RUN R -q -e "remotes::install_deps(dependencies = 'Suggests')"

# Run RStudio Server -----------------------------------------------------------
ENV HOME /home/rstudio
ENV R_USER /home/rstudio
RUN printenv >> .env
RUN cp .env home/rstudio/.Renviron
RUN chown rstudio:rstudio home/rstudio/
ENV PASSWORD 1234
ENV ROOT true
