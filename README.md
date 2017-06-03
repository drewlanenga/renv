
renv
==========

[![Build Status](https://travis-ci.org/drewlanenga/renv.svg?branch=master)](https://travis-ci.org/drewlanenga/renv)

Read environment variables from an environment file and load them in the current R session.

`renv` supports reading both shell formats and `.env` formats.

```{bash}
export $FOO=bar
thing1=thing2
```

# Getting Started

## Installation

```r
devtools::install_github("drewlanenga/renv")
```

## Usage

```r
library(renv)
load_vars("~/.bashrc")
```
