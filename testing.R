library(gemini.R)
library(httr)
library(jsonlite)

setAPI("AIzaSyCQM7Zx6awa2nZ4-MaoUxpPjc4lEVTHIAM")

gemini("do you remember what my last prompt was?")


model_query <- "gemini-1.0-pro:generateContent"

response <- POST(
  url = paste0("https://generativelanguage.googleapis.com/v1beta/models/", model_query),
  query = list(key = Sys.getenv("GEMINI_API_KEY")),
  content_type_json(),
  encode = "json",
  body = list(
    contents = list(
      parts = list(
        list(text = "hello, can you tell me an interesting fact?")
      )
    ),
    generationConfig = list(
      temperature = 0.5,
      maxOutputTokens = 1024
    )
  )
)
x = fromJSON(rawToChar(response$content))

x$candidates

candidates <- content(response)$candidates
outputs <- unlist(lapply(candidates, function(candidate) candidate$content$parts))