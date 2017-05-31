---
title       : bashr
subtitle    : Reading bash files in R
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

## [bashr](https://github.com/drewlanenga/bashr)

---

## bashr

- Confession: `bashr != bash + r`
- More about *environment variables* than about *bash*
- Reads bash formatted variable exporting
    - `export FOO=bar`
- Also supports reading [`.env`](https://github.com/bkeepers/dotenv) formatted files
    - `FOO=bar`

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

- Having multiple locations for identical configuration settings is **annoying**.
- You might be **already using bash** (or other shell scripting) to manage environment settings, anyway.
- **Shared environment variables** make them available across a range of processes.

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
bashr::load_vars("~/.bashrc")
foo <- Sys.getenv("foo")

# alternatively, assign value at load
vars <- bashr::load_vars("~/.bashrc")
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
bashr::load_vars("plotly.sh")
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
vars <- bashr::load_vars("s3info.sh")
mydata <- read.csv(paste0(vars$S3_URL, "/mydata.csv"))
```
