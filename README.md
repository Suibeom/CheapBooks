# CheapBooks
I wanted some time price data to help figure out when I could snag some cheap math books, but camelcamelcamel doesn't give you .csv files. 

This had two parts, one easy in R and infuriating in Julia, and one easy in Julia and infuriating in R.

I wrote a Julia script to digest the images it spits out, find a likely graph, and spit it back out as a monochrome image, and then an R script gets an empirical function out of the monochrome image that is suitible for stats. I tried pretty hard to get R to do both steps but I was simultaneously fighting off machine zero problems comparing different pixel colors, and its headstrong vectorization... So I decided to just offload that part.


