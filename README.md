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
The main function is `get_images`, which will download all available images for a give taxon in the highest resolution available:

```coffee
get_images("Miconia albicans")
get_images("Melastomataceae")
```

Each call above will create a folder named as the taxon in the current working directory. All imagens will be downloaded and stores in these folders. 
Use `setwd()` to change the path of these folders.
