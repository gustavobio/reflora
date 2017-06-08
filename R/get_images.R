#' Download images from the Reflora Website.
#'
#' @param any A search query to be matched against all fields.
#' @param family Family name.
#' @param institution_code An institution code.
#'
#' @return \code{get_base_url} Returns the base url for a given taxon. Not very
#' useful by itself. \code{get_number_of_images} returns the number of images available
#' for a given taxon. \code{get_image_urls} returns the urls for all images of a given
#' taxon. \code{get_images} returns NULL and downloads all imagens for the taxon.
#' @examples
#' taxon <- "Miconia albicans"
#' \dontrun{
#' get_number_of_images(taxon)
#' get_image_urls(taxon)
#' get_images(taxon)
#' }
#' @export
get_images <- function(any = NULL, family = NULL, institution_code = NULL) {
  check_args(any, family, institution_code)
  image_urls <- get_image_urls(any, family, institution_code)
  if (is.null(image_urls)) {
    message("There aren't any images for the provided query.")
    return(NULL)
  }
  image_names <-
    regmatches(image_urls,
               regexpr("(?<=/imagecode/)(.*)(?=/size)", image_urls, perl = T))
  path <- paste(any, family, institution_code, sep = "_")
  path <- gsub("\\_{2}", "_", path)
  path <- gsub("^\\_+|\\_+$", "", path)
  if (!dir.exists(path))
    dir.create(path)
  cat("Downloading", length(image_urls), "images:\n")
  pb <- txtProgressBar(min = 0, max = length(image_urls), style = 3)
  for (i in seq_along(image_urls)) {
    # print(i)
    tries <- 1
    repeat {
      if (tries >= 3) Sys.sleep(30)
      if (tries > 5) stop("Can't reach the website. Please try again later.")
      success <- try({
        temp <- gsub("=600", "=3000", GET(image_urls[i])$url)
        # print(temp)
        setTxtProgressBar(pb, i)
        download.file(temp,
                      destfile = paste0(paste0(path, "/"), image_names[i], ".jpg"),
                      mode = "wb", quiet = TRUE)
      })
      if (!inherits(success, "try-error")) break
      tries <- tries + 1
    }
  }
  close(pb)
  cat("Images downloaded to", paste0(getwd(), "/", path, "/\n"))
}

#' Get the base url for a taxon
#'
#' @param any A search query to be matched against all fields.
#' @param family Family name.
#' @param institution_code An institution code.
#' @param offset Page offset
#' @export
get_base_url <- function(any = NULL, family = NULL, institution_code = NULL, offset = 0) {
  check_args(any, family, institution_code)
  URLencode(
    paste(
      "http://www.splink.org.br/showImages?ts_any=",
      any,
      "&ts_family=",
      family,
      "&ts_institutioncode=",
      institution_code,
      "&extra=withImages&search_id=2&search_seq=8&size=thumb&offset=",
      offset,
      sep = ""
    )
  )
}

#' Get the number of images for a given taxon
#'
#' @param any A search query to be matched against all fields.
#' @param family Family name.
#' @param institution_code An institution code.
#' @export
get_number_of_images <- function(any = NULL, family = NULL, institution_code = NULL) {
  check_args(any, family, institution_code)
  n <- read_html(get_base_url(any, family, institution_code)) %>%
    html_node("b") %>%
    html_text()
  regexp <- gregexpr("\\d+", n, perl = T)
  as.numeric(regmatches(n, regexp)[[1]][3])
}

#' Get the urls for a taxon
#'
#' @param any A search query to be matched against all fields.
#' @param family Family name.
#' @param institution_code An institution code.
#' @export
get_image_urls <- function(any = NULL, family = NULL, institution_code = NULL) {
  check_args(any, family, institution_code)
  n <- get_number_of_images(any, family, institution_code)
  if (n == 0) return(NULL)
  links <- NULL
  for (i in 1:floor(n/100)) {
    tries <- 1
    repeat {
      if (tries > 3) stop("Can't reach the website. Please try again later.")
      link <- try(read_html(get_base_url(any, family, institution_code, offset = i * 100)) %>%
                    html_nodes(xpath = '//a[@class="highslide"]') %>%
                    html_attr(name = "href"))
      if (!inherits(link, "try-error")) break
      tries <- tries + 1
    }
    links <- c(links, link)
  }
  links
}

check_args <- function(any, family, institution_code) {
  if (is.null(any) & is.null(family) & is.null(institution_code)) stop("Please provide at least one search field.")
}
