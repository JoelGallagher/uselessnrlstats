##### Description #####
# An R script to look at players who played in all 4 spine positions in a season

##### Libraries #####
{
  library(lubridate)
  library(readr)
  library(tidyverse)
  library(formattable)
  library(htmltools)
  library(htmlwidgets)
  library(webshot2)
}

##### Load Data #####
player_data <- read_csv("cleaned_data/nrl/player_data.csv")
player_match_data <- read_csv("cleaned_data/nrl/player_match_data.csv")
match_data <- read_csv("cleaned_data/nrl/match_data.csv")
team_data <- read_csv("cleaned_data/nrl/team_data.csv")
team_logos <- read_csv("cleaned_data/nrl/team_logos.csv")

##### Helper Stats #####

##### Analysis #####

# spine positions
all_spine_seasons <- player_match_data |>
  left_join(match_data |> select(match_id, date),
            by = "match_id") |>
  mutate(year = year(date)) |>
  count(player_id, year, team, position) |>
  # filter(position %in% c("FB", "FE", "HB", "HK")) |>
  rename(number_matches = n) |>
  group_by(player_id, year) |>
  mutate(position = ifelse(position %in% c("FB", "FE", "HB", "HK"),
                           paste0("<b>", position, "</b>"),
                           position),
         position = factor(position,
                           levels = c("<b>FB</b>", "W", "C", "<b>FE</b>", "<b>HB</b>", "FR", "<b>HK</b>", "2R", "L", "B"), 
                           ordered = TRUE)) |>
  arrange(position) |>
  summarise(n_positions = length(unique(position)),
            unique_positions = paste0(unique(position), collapse = " "),
            n_matches = sum(number_matches),
            team = paste(unique(team), collapse = ", "),
            .groups = "drop") |>
  left_join(player_data |> select(player_id, full_name), 
            by = "player_id") |>
  filter((str_detect(unique_positions, "FB") +
            str_detect(unique_positions, "FE") +
            str_detect(unique_positions, "HB") +
            str_detect(unique_positions, "HK")) >= 4) |>
  #filter(n_positions == 4) |>
  arrange(year)


##### Table Formatting #####
luminance <- function(col) {c(c(.299, .587, .114) %*% col2rgb(col)/255)}

team_formatter <- 
  formatter("span", 
            style = x ~ style(
              display = "block", 
              padding = "0 4px", 
              `border-radius` = "4px",
              font.weight = "bold", 
              `vertical.align` = "center",
              `background-color` = data.frame(team_name = x) |>
                left_join(team_data, by = "team_name") |>
                left_join(team_logos, by = "team_unique") |>
                pull(team_colour),
              color = data.frame(team_name = x) |>
                left_join(team_data, by = "team_name") |>
                left_join(team_logos, by = "team_unique") |>
                mutate(lum = luminance(team_colour),
                       text_col = ifelse(lum < 0.4, "#F2F2F2", "#1A1A1A")) |>
                pull(text_col)))

bold_formatter <- 
  formatter("span", 
            style = x ~ style(
              font.weight = "bold"
            ))

number_formatter <-
  formatter("span",
            style = x ~ style(
              font.size = "12px"
            ))

# Final table formatting
final_table <- all_spine_seasons |>
  select(year, full_name, team, n_matches, n_positions, unique_positions) |>
  rename(
    Year = year,
    Player = full_name,
    Team = team,
    `Matches` = n_matches,
    `# Positions` = n_positions,
    `Unique Positions` = unique_positions
  ) |>
  formattable(
    list(
      Team = team_formatter,
      Player = bold_formatter
    ),
    align = c("r", "c", "r", "c", "c", "l"),
    table.attr = 'class=\"table table-striped\" style="font-size: 12px; font-family: Helvetica; vertical-align: middle"'
  ) |>
  as.htmlwidget() |>
  prependContent(h4(class = "title", 
                    style = "font-family: Helvetica;",
                    "\u2003Players to start in all four spine positions in a season"))
final_table

saveWidget(final_table, "tables/html/spine_positions_year.html")
webshot(url = "tables/html/spine_positions_year.html", 
        file = "tables/png/spine_positions_year.png", 
        selector = "body", zoom = 4,
        vwidth = 750)
