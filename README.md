## reflora R package

Download specimen images from the Reflora program.

## Description

+ [Gustavo Carvalho](https://github.com/gustavobio)

This R package contains tools to download images from Brazil's Reflora Program (http://inct.florabrasil.net/reflora/ and http://www.splink.org.br).

## Installation

```coffee
install.packages(devtools)
devtools::install_github("gustavobio/reflora")
```

## Usage
The main function is `get_images`, which will download all available images for a given combination of any field, family, and institution code in the highest resolution available:

```coffee
get_images("Miconia albicans")
get_images(family = "Melastomataceae", institution_code = "UNICAMP")
get_images("UEC175546")
```

Institution codes can be found at http://www.splink.org.br. Each call above will create a folder in the current working directory named as the combination of search queries. All images will be downloaded and stored in these folders. 
Use `setwd()` to change the root path of these folders.
