library(rvest)
library(dplyr)
library(stringr)

source('OurApp/GeminiFuncs.R')

# URL of the Amazon search results page
url <- "https://www.amazon.com/s?k=Eucerin+Original+Healing+Cream"

# Read the HTML content of the page
webpage <- read_html(url)

image_urls <- webpage %>%
  html_nodes("img.s-image.s-image-optimized-rendering") %>%
  html_attr("src")

product_links = webpage %>%
  html_nodes('.a-link-normal.s-no-outline') %>%
  html_attr('href')


# ---- pick out listings class ----
x = webpage %>% html_nodes('.a-declarative') %>% html_text()

# ---- grab listings ----
testing <- sapply(x, function(y) {
  contains_dollar <- grepl(pattern = '\\$', y)
  return(contains_dollar)
})


listings = x[testing]

sponsored_overallpick_remove_ind = grep(pattern = 'Sponsored|Overall Pick', listings)

listings = listings[-sponsored_overallpick_remove_ind][1:10]
product_links = product_links[-sponsored_overallpick_remove_ind][1:10]
image_urls = image_urls[-sponsored_overallpick_remove_ind][1:10]


# ---- grab product names ----
product_names = lapply(listings, function(x) {
  str_match(string = x, pattern = "(.*?),")[,2]
})
product_names = unlist(product_names)
product_names

# ---- grab product price ----
product_price = lapply(listings, function(x) {
  str_match(string = x, pattern = "\\$(.*?)\\$")[,2]
})

product_price = unlist(product_price)
# product_price = paste0('$',product_price)

product_price

# ---- grab product rating ----
product_rating = lapply(listings, function(x) {
  str_match(string = x, pattern = "\\)(.*?)stars")[,2]
})

product_rating = unlist(product_rating)
product_rating

for(i in 1:length(product_rating)){
  if(grepl(pattern = 'Options', product_rating[i])){
    cleaned_string <- sub(".*(\\d\\.\\d out of 5).*", "\\1", product_rating[i])
    
    product_rating[i] = cleaned_string
  }else{
    
  }
}

product_rating

product_df = data.frame(
  "product" = product_names,
  "price" = as.numeric(product_price),
  "rating" = product_rating,
  'image' = image_urls
  )

cheap_ind = which(product_df$price == min(product_df$price))[1]

# Construct the full tracking URL by adding the base URL
base_url <- "https://www.amazon.com"
full_tracking_url <- paste0(base_url, product_links[cheap_ind])

# Follow the redirection to get the final URL
response <- GET(full_tracking_url)

# Extract the final URL
final_url <- response$url







