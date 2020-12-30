calculate_rating <- function(path, group_number, group_size)
{
  
  temp1 <- start %>%
    group_by(name) %>%
    summarize(
      group_size = n()
    ) %>%
    select(-group_size)
  
  temp2 <- temp1 %>%
    mutate(
      given_to = name
    ) %>%
    select(given_to)
  
  full <- crossing(temp1, temp2)
  
  data <- full_join(full, data, by = c("name" = "own_name", "given_to" = "name")) %>%
    mutate(
      group = group_number # get from the file name or from iterator
    )
  data <- data %>%
    mutate(
      rating = as.numeric(rating),
      rating = ifelse(is.na(rating), 0, rating)
    ) 
  
  
  awarded <- data %>%
    group_by(name) %>%
    summarize(
      total_awarded = sum(rating)
    ) 
  
  received <- data %>%
    group_by(given_to) %>%
    summarize(
      total_received = sum(rating)
    )
  
  data_full <- full_join(data, awarded, by = c("name" = "name"))
  data_full <- full_join(data_full, received, by = c("name" = "given_to"))
  data_full_normalized <- data_full %>%
    mutate(
      awarded_rating = ifelse(is.na(rating / total_awarded), 0, rating / total_awarded)
    )
  
  data_summary <- data_full_normalized %>%
    group_by(given_to) %>%
    summarize(
      rating = sum(awarded_rating)
    )
  
  fudge_factor = group_size / number_of_submissions
  data_summary <- data_summary %>%
    mutate(
      rating = rating * fudge_factor, 
      group_number = group_number
    )
  
  return(data_summary)
}