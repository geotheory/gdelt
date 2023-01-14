gdelt = function(u){
  message(u)
  u = stringr::str_replace_all(u, ' ', '%20') |> stringr::str_replace_all('"', '%22')
  if(!stringr::str_detect(u, stringr::fixed('json', ignore_case=TRUE))) u = paste0(u, '&format=json')
  g = tryCatch({ jsonlite::fromJSON(u) }, error = function(e) {
    message('*** alternative parse ***')
    fileIn = file(u, open="rb", encoding="UTF-8")
    lines = readLines(fileIn, warn = FALSE)
    clean_lines = gsub("[\001-\026]*", "", lines) # remove problematic chars
    jsonlite::fromJSON(clean_lines)
  })
  if('features' %in% names(g)){
    geoms = g$features$geometry |> dplyr::as_tibble() |>
      dplyr::mutate(coordinates = purrr::map(coordinates, ~ tibble(lon = .x[1], lat = .x[2]))) |>
      tidyr::unnest(coordinates)
    props = g$features$properties |> dplyr::as_tibble()
    if('urlpubtimedate' %in% names(props)) props = props |>
      dplyr::mutate(urlpubtimedate = as.POSIXct(urlpubtimedate, format = '%Y-%m-%dT%H:%M:%SZ'))
    out = bind_cols(geoms, props)
  }
  if('articles' %in% names(g)){
    out = g$articles |> dplyr::as_tibble()
  }
  if('timeline' %in% names(g)){
    out = purrr::map2_df(g$timeline$series, g$timeline$data, { ~ dplyr::as_tibble(.y) |>
        dplyr::mutate(series = .x) |>
        dplyr::mutate(date = as.POSIXct(date, format='%Y%m%dT%H%M%SZ'))
    }) |> dplyr::mutate(series = stringr::str_remove(series, ' Volume Intensity$'))
    if('toparts' %in% names(out)) out = out |> tidyr::unnest(toparts)
  }
  out
}
