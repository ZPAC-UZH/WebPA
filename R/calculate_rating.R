calculate_rating <- function(path, group_number, group_size)
{
  paths <- list.files(path = path, pattern='*.xlsx', full.names = TRUE)
  number_of_submissions = length(paths)
  
  start <- 
    read_excel(paths[1], skip = 10) %>% # TODO: 10 is hard-coded. Better determine it from the template
    # tail(-9) %>%  # TODO: -9 is hard-coded
    select(
      `x` = "My name (x)",
      `name` = "Person",
      `rating` = "Rating",
      `comment` = "Comments",
      `group` = "Team") %>% 
    mutate(own_name = start$name[which(start$x == "x")]) %>% 
    select(-comment, -x)
  
  data <- start
  
  for (i in 2:(length(paths))) {
    current <- read_excel(paste(path, paths[i], sep = "")) %>%
      tail(-9) %>%
      set_colnames(c("own_name", 
                     "name", 
                     "rating", 
                     "comment", 
                     "group", 
                     "team_member")) %>%
      select(-comment)
    
    temp <- current %>%
      drop_na()
    author_name = temp$name
    current <- current %>%
      mutate(
        own_name = author_name
      )
    data <- rbind(data, current)
  }
  
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