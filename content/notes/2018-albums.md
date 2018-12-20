---
title: "My Top Albums of 2018"
author: ["Carl Colglazier"]
date: 2018-12-09
draft: true
---

If your social media feed is anything like mine, you probably
see a lot of posts like this toward the end of the year.

{{< figure src="/images/spotify_unwrapped_2018_promo.jpg" caption="Figure 1: Spotify promomotional image for \"Spotify Wrapped 2018\"." >}}

It can be fun to see what kind of music other people like and to share
your own music tastes. It's also a great advertisement campaign for
Spotify (see their nice logo in the top left of these graphics).

The only problem for me is that I'm not a Spotify user, so when I try
to open my #2018Wrapped data, I am greeted with a very nicely packaged
empty box. Fortunately, as I wrote about in my [last post](/notes/2017-albums-in-2018/), I log all
of my music streaming using a free, open-source service called
ListenBrainz. I am going to use that data to create my own end-of-year
music graphic similar to the ones posted by my friends who use Spotify.


### Initial analysis {#initial-analysis}

```R
library("jsonlite")
plays <- fromJSON(lb)
stamp <- as.numeric(as.POSIXct("2018-01-01", format="%Y-%m-%d"))
recentPlays <- plays[plays$timestamp > stamp, ]
nrow(recentPlays)
```

| x     |
|-------|
| 12482 |


#### Top Artists {#top-artists}

We can use this data to answer some pretty easy questions. For
example, who were my top artists in 2018?

```R
top_artists <- head(
    sort(table(unlist(recentPlays$artist_name)), decreasing=TRUE),
    n=5
)
top_artists
```

| Var1             | Freq |
|------------------|------|
| Charli XCX       | 840  |
| Carly Rae Jepsen | 425  |
| Ariana Grande    | 294  |
| Kacey Musgraves  | 277  |
| SOPHIE           | 211  |

[Critically](https://pitchfork.com/reviews/albums/charli-xcx-pop-2/) [acclaimed](https://music.avclub.com/carly-rae-jepsen-lands-her-romantic-80s-pop-daydream-1798184677) [pop](https://www.thelineofbestfit.com/reviews/albums/ariana-grande-sweetener-album-review) [perfection](https://consequenceofsound.net/2018/03/album-review-kacey-musgraves-absolutely-shines-on-golden-hour/) [yes](https://www.tinymixtapes.com/music-review/sophie-oil-every-pearls-un-insides)!


#### Top Songs {#top-songs}

I can also do something similar to find my top tracks for the year.

```R
head(
      sort(table(unlist(recentPlays$track_name)), decreasing=TRUE),
      n=5
  )
```

| Var1                                                      | Freq |
|-----------------------------------------------------------|------|
| No Angel                                                  | 40   |
| Immaterial                                                | 37   |
| I Got It (feat. Brooke Candy, CupcakKe and Pabllo Vittar) | 35   |
| Focus                                                     | 34   |
| Lucky                                                     | 32   |

I listen to a _lot_ of Charli XCX, so this list doesn't really have a
lot of variety (though Charli is absolutely one of the most versatile
artists in pop today). Let's filter the results to only show one song
per artist.

```R
top_songs <- head(playCounts[ !duplicated(playCounts$artist_name),], n=5)
top_songs
```

| artist\_name     | track\_name   | freq |
|------------------|---------------|------|
| Charli XCX       | No Angel      | 40   |
| SOPHIE           | Immaterial    | 37   |
| Kacey Musgraves  | High Horse    | 31   |
| Troye Sivan      | My My My!     | 31   |
| Carly Rae Jepsen | Party For One | 26   |


#### Top Albums {#top-albums}

```R
library(xml2)
library(RCurl)

# This is a pretty costly function because the MusicBrainz API
# rate limits us to one request per second. Thus, we'll set up
# a cache to eliminate redundant requests.
cacheEnv <- new.env()

getAlbums <- function(artist, song) {
    hash <- paste(artist, song)
    if (exists(hash, envir=cacheEnv)){
        return(get(hash, envir=cacheEnv))
    }
    song_stripped <- trimws(sub("\\(.*\\)", "", song))
    mburl <- sprintf(
        'https://beta.musicbrainz.org/ws/2/recording/?query=artist:"%s"+AND+recording:"%s"',
        curlEscape(artist),
        curlEscape(song_stripped)
    )
    # To comply with the rate limit.
    Sys.sleep(0.5)
    albumData <- read_xml(mburl)
    xml_ns_strip(albumData)
    releases <- xml_find_all(albumData, "/metadata/recording-list/recording/release-list//release")
    officialAlbums <- xml_find_all(albumData, '//release/status[.="Official"]/..')
    albums <- xml_find_all(officialAlbums, '//release/release-group[@type="Album" or @type="EP"]')
    results <- unique(xml_attr(albums, "id"))
    assign(hash, results, envir=cacheEnv)
    return(results)
}
```

```R
albums <- mostGroups[!is.na(mostGroups$date) & mostGroups$date >= as.Date('2018-01-01'),]
aTable <- albums[,c("title", "artist", "freq")]
aTable <- aTable[!duplicated(aTable$title),]
head(aTable[order(aTable$freq, decreasing=T), ], n=17)
```

<div class="table-caption">
  <span class="table-number">Table 1</span>:
  My most-streamed albums released in the last year.
</div>

| title                                     | artist            | freq |
|-------------------------------------------|-------------------|------|
| Golden Hour                               | Kacey Musgraves   | 247  |
| Bloom                                     | Troye Sivan       | 133  |
| OIL OF EVERY PEARL'S UN-INSIDES           | SOPHIE            | 118  |
| THINK: PEACE                              | Clarence Clarity  | 106  |
| Sweetener                                 | Ariana Grande     | 105  |
| Joy as an Act of Resistance.              | IDLES             | 103  |
| Be the Cowboy                             | Mitski            | 94   |
| I’m All Ears                              | Let’s Eat Grandma | 94   |
| 7                                         | Beach House       | 87   |
| Twin Fantasy (Face to Face)               | Car Seat Headrest | 75   |
| Primal Heart                              | Kimbra            | 67   |
| A Brief Inquiry Into Online Relationships | The 1975          | 56   |
| [Untitled]                                | mewithoutYou      | 55   |
| Confident Music for Confident People      | Confidence Man    | 53   |
| Transangelic Exodus                       | Ezra Furman       | 51   |
| Trench                                    | twenty one pilots | 50   |
| Voicenotes                                | Charlie Puth      | 49   |

```R
aTable2 <- mostGroups[,c("title", "artist", "freq")]
aTable2 <- aTable2[!duplicated(aTable2$title),]
head(aTable2[order(aTable2$freq, decreasing=T), ], n=25)
```

<div class="table-caption">
  <span class="table-number">Table 2</span>:
  My most-streamed albums of 2018.
</div>

| title                           | artist                  | freq |
|---------------------------------|-------------------------|------|
| Pop 2                           | Charli XCX              | 287  |
| Golden Hour                     | Kacey Musgraves         | 247  |
| E•MO•TION                       | Carly Rae Jepsen        | 209  |
| Emotion                         | Carly Rae Jepsen        | 209  |
| Electra Heart                   | Marina and the Diamonds | 165  |
| Dangerous Woman                 | Ariana Grande           | 147  |
| Melodrama                       | Lorde                   | 144  |
| The Fame                        | Lady Gaga               | 143  |
| Bloom                           | Troye Sivan             | 133  |
| Number 1 Angel                  | Charli XCX              | 133  |
| OIL OF EVERY PEARL'S UN-INSIDES | SOPHIE                  | 118  |
| E•MO•TION: Side B               | Carly Rae Jepsen        | 117  |
| Blackout                        | Britney Spears          | 114  |
| THINK: PEACE                    | Clarence Clarity        | 106  |
| Sweetener                       | Ariana Grande           | 105  |
| Vroom Vroom                     | Charli XCX              | 105  |
| Joy as an Act of Resistance.    | IDLES                   | 103  |
| RINA                            | Rina Sawayama           | 102  |
| Be the Cowboy                   | Mitski                  | 94   |
| I’m All Ears                    | Let’s Eat Grandma       | 94   |
| After Laughter                  | Paramore                | 90   |
| Sucker                          | Charli XCX              | 87   |
| 7                               | Beach House             | 87   |
| Loss Memory                     | Coma Cinema             | 85   |
| Age                             | The Hidden Cameras      | 78   |


#### Minutes streamed {#minutes-streamed}

Initially I considered a brute-force approach to this problem.

```R
getLengths <- function(artist, song) {
     song_stripped <- trimws(sub("\\(.*\\)", "", song))
     mburl <- sprintf(
         'https://beta.musicbrainz.org/ws/2/recording/?query=artist:%s+AND+recording:%s',
         curlEscape(artist),
         curlEscape(song_stripped)
     )
     # To comply with the rate limit.
     Sys.sleep(0.5)
     albumData <- read_xml(mburl)
     xml_ns_strip(albumData)
     length <- xml_integer(xml_find_first(albumData, "//length"))
     return(length)
 }
```

```R
set.seed(425368203)
sample <- playCounts[sample(nrow(playCounts), 100), ]
lengths <- apply(sample, 1, function(x) getLengths(x["artist_name"], x["track_name"]))
```

```R
lens <- lengths[!is.na(lengths)]
ggplot() + aes(lens) + geom_histogram(binwidth=60000)
```

```R
mins <- nrow(recentPlays) * mean(lens) / 60000
```

| x                |
|------------------|
| 49768.0639733333 |


#### Top Genre {#top-genre}

```R
topAlbums <- mostGroups[,c("title", "artistId", "freq")]
topAlbums <- topAlbums[!duplicated(topAlbums$title),]
#ids <- topAlbums[topAlbums$freq > 10,]$artistId
nrow(topAlbums[topAlbums$freq > 10,])
```

```text
114
```

```R
topAlbums$freq %>% sum()
```

```text
6375
```

```R
fetchGenres <- function(mbid) {
    mburl <- sprintf(
        "https://beta.musicbrainz.org/ws/2/artist/%s?inc=genres",
        mbid
    )
    Sys.sleep(0.25)
    groupData <- read_xml(mburl)
    xml_ns_strip(groupData)
    genres <- xml_text(xml_find_all(groupData, "//genre/name"))
    return(genres)
}
```

```R
ids <- topAlbums %>%
    group_by(artistId) %>%
    summarise(Freq=sum(freq)) %>%
    arrange(desc(Freq))
ids$genres <- lapply(ids$artistId, fetchGenres)
topGenres <- ids %>%
    unnest(genres) %>%
    group_by(genres) %>%
    summarise(Count=sum(Freq)) %>%
    arrange(desc(Count))
head(topGenres)
```

| genres     | Count |
|------------|-------|
| pop        | 2928  |
| electropop | 2405  |
| dance-pop  | 2190  |
| electronic | 1486  |
| pop rock   | 1362  |
| synth-pop  | 842   |


## Creating the graphic {#creating-the-graphic}

```R
library("plyr")
playCounts <- count(recentPlays, c("artist_name", "track_name"))
playCounts <- playCounts[order(playCounts$freq, decreasing=T), ]
p <- ggplot(data=playCounts, aes(playCounts$freq)) + geom_histogram(binwidth=1) +
     scale_y_sqrt() +
     theme(panel.border = element_blank(),
           legend.key = element_blank(),
           panel.background = element_blank(),
           plot.background = element_rect(fill = "transparent",colour = NA))
ggsave(file=fname, plot=p, width=7, height=4, dpi=300, bg="transparent")
fname
```

```R
library(ggpubr)
library(png)
library(raster)

top_artist_names <- attr(top_artists, "name")
artistTable <- ggtexttable(top_artist_names, rows = NULL, theme = ttheme("blank"), cols=c("Top Artists"))
trackTable <- ggtexttable(top_songs$track_name, rows = NULL, theme = ttheme("blank"), cols=c("Top Songs"))
minutes <- text_grob(paste("Minutes Listened", toString(round(mins)), "", "Top Genre", toString(topGenres[1,1]), sep="\n"))
img <- readPNG("images/albums.png")
im_A <- ggplot() +
    background_image(img[1:250, 1:250, 1:3]) +
    theme(plot.margin = margin(t=.1, l=.1, r=.1, b=.1, unit = "cm"))
p <- ggarrange(im_A, artistTable, minutes, trackTable, ncol=2, nrow=2) + bgcolor("#FFFFFF")
ggsave(file=fname, plot=p, width=4, height=4, dpi=300)
fname
```

{{< figure src="/images/2018wrapped.png" >}}
