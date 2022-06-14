#API Spotify
#install.packages("spotidy")
library(spotidy)
library(dplyr)

SPOTIFY_CLIENT_ID <-"79ba4f46f96048509889804d6ae01f8c"
SPOTIFY_CLIENT_SECRET <- "840aa37dd39a4b01a3d388f4d61ec931"

my_token <- get_spotify_api_token(SPOTIFY_CLIENT_ID, SPOTIFY_CLIENT_SECRET)

artist <- search_artists(
  "Rosalía",
  output = c("tidy"),
  limit = 1,
  offset = 0,
  token = my_token
)

#Seleccionas el id de Rosalia
id <- artist[1,2]


artist_related <- get_artist_related_artists(
  id,
  output = c("tidy"),
  limit = 100,
  offset = 0,
  token = my_token
)

artist_related <- arrange(artist_related, -popularity)

artist_related <- as.vector(artist_related[1:10,4])

tracks_artists_related <- data.frame()

for (i in 1:10) {
  artista <- artist_related[i]
  
  aux <- get_artist_top_tracks(
    artist_id=artista,
    country="US",
    output = c("tidy"),
    limit = 100,
    offset = 0,
    token = my_token
  )
  tracks_artists_related <- rbind(aux, tracks_artists_related)
}

tracks_artists_related  <- tracks_artists_related[which(tracks_artists_related$artist_id %in% artist_related), ]

tracks_artists_related$release_date <- as.Date(tracks_artists_related$release_date)
tracks_artists_related <- arrange(tracks_artists_related, release_date)

ARTIST_1 <- 'Rosalía'
ARTIST_2 <- tracks_artists_related[nrow(tracks_artists_related),1]
TRACK <- tracks_artists_related[nrow(tracks_artists_related),3]
POPULARIDAD <- tracks_artists_related[nrow(tracks_artists_related),6]

print(paste("La canción", TRACK, "del cantante", ARTIST_2, "tiene una popularidad de", POPULARIDAD,". Este artista se hizo muy famoso por colaborar con", ARTIST_1))

