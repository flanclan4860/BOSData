
# con <- url("http://espn.go.com/fantasy/baseball/story/_/page/2015FLBrankings/updated-fantasy-baseball-rankings-position-2015-season")
# htmlCode <- readLines(con)
# close(con)

# u <- "http://games.espn.go.com/flb/tools/projections?&startIndex=240"

# repeat for each page, and for pitchers
# split v2 string
u <- "http://games.espn.go.com/flb/tools/projections?"
doc <- htmlParse(u)
tableNodes <- getNodeSet(doc, "//table")
tb <- readHTMLTable(tableNodes[[2]], stringsAsFactors=FALSE, skip=1)
tb$V1 #Rank chr
tb$V2 #"Name, Team Pos"
tb$V3 #Runs
#V4 HR 
#V5 RBI
#V6 SB
#V7 Avg

# CBS, repeat for each position
v <- "http://fantasynews.cbssports.com/fantasybaseball/stats/sortable/cbs/1B/season/standard/projections?&start_row=1"
doc <- htmlParse(v)
tableNodes <- getNodeSet(doc, "//table")
tb <- readHTMLTable(tableNodes[[5]], stringsAsFactors=FALSE, skip=2)
# $V1 "Name,A Team"
# V2 AB
# V14 AVG
