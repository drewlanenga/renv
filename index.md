---
title       : renv
subtitle    : Load environment files in R
projecturl  : https://drewlanenga.github.io/renv
author      : Drew Lanenga
authorurl   : https://github.com/drewlanenga
authortitle : Data Scientist, Lytics
when        : Cascadia R Conf 2017, 3 June 2017
framework   : material
highlighter : highlight.js
hitheme     : arta
widgets     : []
mode        : selfcontained

--- .shout

## [renv](https://github.com/drewlanenga/renv)

---

## R vs. Environment Variables

<figure>
	<blockquote>
		<p>The <a href="https://12factor.net">twelve-factor app</a> stores config in environment variables.</p>
	</blockquote>
	<figcaption>Adam Wiggins, Heroku Founder</figcaption>
</figure>

<figure>
	<blockquote>
		<p>If you want to set environment variables for your R session, you don't want to use <code>.bashrc</code>; use <code>.Renviron</code> (user) or <code>.Renviron.site</code> (system).</p>
	</blockquote>
	<figcaption><a href="https://support.rstudio.com/hc/en-us/community/posts/207644217-Rstudio-server-doesn-t-have-login-user-s-environment-variables-">RStudio Support Ticket</a></figcaption>
</figure>


---

## Why not Renviron?

- You might be **already using bash** (or other shell scripting) to manage environment settings, anyway.
- **Shared environment variables** make them available across a range of processes.
- Having multiple locations for identical configuration settings is **annoying**.

<figure>
	<blockquote>
		<p><strong>Drew's Law</strong>: If you ever have the same configuration data stored in multiple locations, at some point it will cause a headache.</p>
	</blockquote>
	<figcaption><a href="https://github.com/drewlanenga">Drew Lanenga</a></figcaption>
</figure>

---

## When to use?

- Think: *"When does my code contain configuration settings?"*
    - Data Location
        - Local directory, S3, FTP, Dropbox, remote database/tables
    - Secure Credentials
        - API usernames, passwords, keys
    - Staging Environments
        - Different API endpoints/credentials for staging/sandbox vs. production settings

--- .shout

## Usage

---

## Usage

```
# get variables from standard Sys.getenv call
renv::load_vars("~/.bashrc")
foo <- Sys.getenv("foo")

# alternatively, assign value at load
vars <- renv::load_vars("~/.bashrc")
foo <- vars$foo
```

--- .shout

## Examples

---

## Example: Plotly!

According to Plotly's [Getting Started Guide](https://plot.ly/r/getting-started#initialization-for-online-plotting), save this in your `.Rprofile` file:


```r
Sys.setenv("plotly_username" = "your_plotly_username")
Sys.setenv("plotly_api_key" = "your_api_key")
```

---

## Example: Plotly!

`plotly.sh`


```bash
export plotly_username=your_plotly_username
export plotly_api_key=your_api_key
```

`plotly.R` or `.Rprofile`


```r
renv::load_vars("plotly.sh")
```

---

## Example: Storing S3 Information

`s3info.sh`


```bash
export S3_ROOT=https://mybucket.s3.amazonaws.com
export S3_PATH=rawdata
export S3_URL=$S3_ROOT/$S3_PATH
```

`read.R`


```r
vars <- renv::load_vars("s3info.sh")
mydata <- read.csv(paste0(vars$S3_URL, "/mydata.csv"))
```
