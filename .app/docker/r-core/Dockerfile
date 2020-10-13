# R Package Development: Core --------------------------------------------------
FROM rocker/rstudio:4.0.2

# Setup ------------------------------------------------------------------------
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    dos2unix \
    libcurl4-openssl-dev \
    libssl-dev \
	libxt-dev \
    libxml2-dev \
    libcairo2-dev \
    libsqlite-dev \
    libmariadbd-dev \
    libmariadbclient-dev \
    libpq-dev \
    libssh2-1-dev \
    libsasl2-dev \
    unixodbc-dev \
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure RStudio Server -----------------------------------------------------
ARG R_REPOS=\'https://mran.microsoft.com/snapshot/2020-06-22\'
RUN touch .env .Rprofile
RUN echo "options(repos = ${R_REPOS})" >> .Rprofile
RUN echo "require(remotes)" >> .Rprofile
RUN R -q -e "if(!require(remotes)) install.packages('remotes')"
RUN R -q -e "install_cran('tidyverse', dependencies = TRUE)"
RUN R -q -e "install_cran(c('profvis', 'renv'))"
RUN R -q -e "install_cran(c('devtools', 'testthat', 'covr', 'roxygen2'))"
RUN R -q -e "install_cran(('tinytex')); tinytex::install_tinytex()"


# Install Project Dependencies -------------------------------------------------
RUN R -q -e "install_cran('mlr3learners', dependencies = TRUE)"
RUN R -q -e "install_cran('mlr3verse', dependencies = TRUE)"
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
