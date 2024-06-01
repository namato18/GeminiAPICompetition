library(rvest)
library(dplyr)
main_prompt = paste0("Based on the picture provided, can you please find similar products that contain the same or similar ingredients.",
                     ' The items should also be found for a cheaper price. The products should also have the same function as the original product. ',
                     "Please only return a bulleted list of the names of the similar products.",
                     " I do not want any additional information in your response, just the names of the similar/cheaper products.",
                     " Please return each similar product with the form **(product)**")
SavedAnswer = gemini_vision(main_prompt, "C:/Users/xbox/Pictures/Capture.JPG")
SavedAnswer


# URL of the Amazon search results page
url <- "https://www.amazon.com/s?k=Eucerin+Original+Healing+Cream"

# Read the HTML content of the page
webpage <- read_html(url)

image_urls <- webpage %>%
  html_nodes(".s-image-optimized-rendering") %>%
  html_attr("src")

product_links = webpage %>%
  html_nodes('.a-link-normal.s-no-outline') %>%
  html_attr('href')

# Construct the full tracking URL by adding the base URL
base_url <- "https://www.amazon.com"
full_tracking_url <- paste0(base_url, product_link)

# Follow the redirection to get the final URL
response <- GET(full_tracking_url)

# Extract the final URL
final_url <- response$url

# Print the final URL
print(final_url)

# ---- pick out listings class ----
x = webpage %>% html_nodes('.a-declarative') %>% html_text()

# ---- grab listings ----
testing <- sapply(x, function(y) {
  contains_dollar <- grepl(pattern = '\\$', y)
  does_not_contain_sponsored <- !grepl(pattern = 'Sponsored', y)
  does_not_contain_OverallPick <- !grepl(pattern = 'Overall Pick', y)
  return(contains_dollar & does_not_contain_sponsored & does_not_contain_OverallPick)
})

listings = x[testing][1:5]
product_links = product_links[testing][1:5]
image_urls = image_urls[testing][1:5]


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
product_price = paste0('$',product_price)

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
  "price" = product_price,
  "rating" = product_rating,
  'image' = image_urls,
  'product_url' = final_url
)





