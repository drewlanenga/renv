
bashr
==========

[![Build Status](https://travis-ci.org/drewlanenga/bashr.svg?branch=master)](https://travis-ci.org/drewlanenga/bashr)

Read environment variables from a bash file and load them in the current R session.

# Getting Started

## Installation

```r
devtools::install_github("drewlanenga/bashr")
```

## Usage

```r
library(bashr)
load_vars("~/.bashrc")
```
