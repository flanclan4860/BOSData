
con <- url("http://espn.go.com/fantasy/baseball/story/_/page/2015FLBrankings/updated-fantasy-baseball-rankings-position-2015-season")
htmlCode <- readLines(con)
close(con)

