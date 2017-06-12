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
The main function is `get_images`, which will download all available images for a given combination of three arguments:

 - any, which searches for the provided query in all fields
 - family, which searches for images of a given family
 - institution_code, which searches for images from a given institution.
 
 ![reflora](https://user-images.githubusercontent.com/30267/26937083-ce2319f6-4c46-11e7-94da-17b8a366536d.png)

Example queries: 

```coffee
get_images("Miconia albicans")
get_images("Miconia albicans", institution_code = "UNICAMP")
get_images(family = "Melastomataceae", institution_code = "UNICAMP")
get_images("UEC175546")
get_images(family = "Rubiaceae")
```

![screenshot1](https://user-images.githubusercontent.com/30267/26937199-226d5e4a-4c47-11e7-8419-a1fc9ae1d991.png)

Institution codes can be found at http://www.splink.org.br. Each call above will create a folder in the current working directory named as the combination of search queries. All images will be downloaded and stored in these folders. 
Use `setwd()` to change the root path where the folders will be created.

![screenshot2](https://user-images.githubusercontent.com/30267/26937361-8afab9f8-4c47-11e7-83ec-1283b41fe093.png)
