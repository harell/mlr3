
# `template.project` <img src='https://i.imgur.com/cLcAYfz.png' align="right" height="50"/>

<!-- badges: start -->

[![continuous-integration](https://travis-ci.org/data-science-competitions/template.project.svg?branch=master)](https://travis-ci.org/data-science-competitions/template.project)
[![code-coverage](https://codecov.io/gh/data-science-competitions/template.project/branch/master/graph/badge.svg)](https://codecov.io/github/data-science-competitions/template.project/?branch=master)
<!-- badges: end -->

## R Project Template for Analytic Applications

<img src="https://i.imgur.com/RLEQkhe.png" width="75%" style="display: block; margin: auto;" />

## Overview

This template conforms to a conceptual model of **Analysis Projects**
suggested by [Hadley
Wickham](https://docs.google.com/document/d/1LzZKS44y4OEJa4Azg5reGToNAZL0e0HSUwxamNY7E-Y/).  
Using this template reduces:  
\* Unnecessary variance between projects configurations; and  
\* Development time spent on making a barebone project working for the
first time.  
This is possible as the boilerplate comes with:  
\* Fully configured test-suite, including code-coverage; and  
\* Fully configured continuous-integration (CI) script for Travis.

## Installation

You can install `template.project` by using:

    install.packages("remotes")
    remotes::install_local("template.project")
