#' Download images from the Reflora Website.
#'
#' @param taxon A unique taxon name. Can be anything (species, family, order).
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
get_images <- function(taxon) {
  image_urls <- get_image_urls(taxon)
  image_names <-
    regmatches(image_urls,
               regexpr("(?<=/imagecode/)(.*)(?=/size)", image_urls, perl = T))
  if (!dir.exists(taxon))
    dir.create(taxon)
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
                      destfile = paste0(paste0(taxon, "/"), image_names[i], ".jpg"),
                      mode = "wb", quiet = TRUE)
      })
      if (!inherits(success, "try-error")) break
      tries <- tries + 1
    }
  }
  close(pb)
}

#' Get the base url for a taxon
#'
#' @param taxon A unique taxon name.
#' @param offset Page offset
#' @export
get_base_url <- function(taxon, offset = 0) {
  URLencode(
    paste(
      "http://www.splink.org.br/showImages?ts_any=",
      taxon,
      "&extra=withImages&search_id=2&search_seq=8&size=thumb&offset=",
      offset,
      sep = ""
    )
  )
}

#' Get the number of images for a given taxon
#'
#' @param taxon A unique taxon name
#' @export
get_number_of_images <- function(taxon) {
  n <- read_html(get_base_url(taxon)) %>%
    html_node("b") %>%
    html_text()
  regexp <- gregexpr("\\d+", n, perl = T)
  as.numeric(regmatches(n, regexp)[[1]][3])
}

#' Get the urls for a taxon
#'
#' @param taxon A unique taxon name
#' @export
get_image_urls <- function(taxon) {
  n <- get_number_of_images(taxon)
  links <- NULL
  for (i in 1:floor(n/100)) {
    tries <- 1
    repeat {
      if (tries > 3) stop("Can't reach the website. Please try again later.")
      link <- try(read_html(get_base_url(taxon, offset = i * 100)) %>%
                    html_nodes(xpath = '//a[@class="highslide"]') %>%
                    html_attr(name = "href"))
      if (!inherits(link, "try-error")) break
      tries <- tries + 1
    }
    links <- c(links, link)
  }
  links
}

