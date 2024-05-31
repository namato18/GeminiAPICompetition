library(httr)
library(jsonlite)
library(base64enc)


api_key <- Sys.setenv(GEMINI_API_KEY = "AIzaSyCFCKa8CM0c_khCk8qBtGZWInPO2pFvKak")
gemini <- function(prompt, 
                   temperature=0.5,
                   max_output_tokens=1024,
                   api_key=Sys.getenv("GEMINI_API_KEY"),
                   model = "gemini-1.0-pro") {
  
  if(nchar(api_key)<1) {
    api_key <- readline("Paste your API key here: ")
    Sys.setenv(GEMINI_API_KEY = api_key)
  }
  
  model_query <- paste0(model, ":generateContent")
  
  response <- POST(
    url = paste0("https://generativelanguage.googleapis.com/v1beta/models/", model_query),
    query = list(key = api_key),
    content_type_json(),
    encode = "json",
    body = list(
      contents = list(
        parts = list(
          list(text = prompt)
        )),
      generationConfig = list(
        temperature = temperature,
        maxOutputTokens = max_output_tokens
      )
    )
  )
  
  if(response$status_code>200) {
    stop(paste("Error - ", content(response)$error$message))
  }
  
  candidates <- content(response)$candidates
  outputs <- unlist(lapply(candidates, function(candidate) candidate$content$parts))
  
  return(outputs)
  
}


chat_gemini <- function(prompt, 
                        temperature=0.5,
                        api_key=Sys.getenv("GEMINI_API_KEY"),
                        model="gemini-1.0-pro") {
  
  if(nchar(api_key)<1) {
    api_key <- readline("Paste your API key here: ")
    Sys.setenv(GEMINI_API_KEY = api_key)
  }
  
  model_query <- paste0(model, ":generateContent")
  
  # Add new message
  chatHistory <<- append(chatHistory, list(list(role = 'user', 
                                                parts = list(
                                                  list(text = prompt)
                                                ))))
  
  response <- POST(
    url = paste0("https://generativelanguage.googleapis.com/v1beta/models/", model_query),
    query = list(key = api_key),
    content_type_json(),
    body = toJSON(list(
      contents = chatHistory,
      generationConfig = list(
        temperature = temperature
      )
    ),  auto_unbox = T))
  
  if(response$status_code>200) {
    chatHistory <<- chatHistory[-length(chatHistory)]
    stop(paste("Status Code - ", response$status_code))
  } else {
    answer <- content(response)$candidates[[1]]$content$parts[[1]]$text
    chatHistory <<- append(chatHistory, list(list(role = 'model', 
                                                  parts = list(list(text = answer)))))
  }
  
  return(answer)
  
}

# Function
gemini_vision <- function(prompt, 
                          image,
                          temperature=0.5,
                          max_output_tokens=4096,
                          api_key=Sys.getenv("GEMINI_API_KEY"),
                          model = "gemini-pro-vision") {
  
  if(nchar(api_key)<1) {
    api_key <- readline("Paste your API key here: ")
    Sys.setenv(GEMINI_API_KEY = api_key)
  }
  
  model_query <- paste0(model, ":generateContent")
  
  response <- POST(
    url = paste0("https://generativelanguage.googleapis.com/v1beta/models/", model_query),
    query = list(key = api_key),
    content_type_json(),
    encode = "json",
    body = list(
      contents = list(
        parts = list(
          list(
            text = prompt
          ),
          list(
            inlineData = list(
              mimeType = "image/png",
              data = base64encode(image)
            )
          )
        )
      ),
      generationConfig = list(
        temperature = temperature,
        maxOutputTokens = max_output_tokens
      )
    )
  )
  
  if(response$status_code>200) {
    stop(paste("Error - ", content(response)$error$message))
  }
  
  candidates <- content(response)$candidates
  outputs <- unlist(lapply(candidates, function(candidate) candidate$content$parts))
  
  return(outputs)
  
}

