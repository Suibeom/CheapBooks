using FileIO
using Images


img = load("./camelchart-locale-usasin-0471062596pricetypes-usedforce-1zero-0w-725h-440desired-falselegend-1ilt-1tp-allfo-0lang-en2018-09-2323_11_16.png")
#This is just what I happened to be loading at the time...
yl, xl = size(img) #Remember; this is rows and columns, not x's and y's


Counts = Dict()
for i in img
Counts[i] = get(Counts,i,0) + 1
end
#Heuristic; A monochrome chunk that's got a number of pixels in it
#on the same order of magnitude as the x-width of the image
# ... might be a graph!!
ColorCands = filter(x-> 50*xl>x[2]>.5*xl,Counts)

#Save all the graph-ish chunks we've found as images
#That way we can easily visually inspect them.
nameheader = "./"
for i in keys(ColorCands)
Graph = [img[h,k]==i for h in 1:yl, k in 1:xl]
save(nameheader*string(i)*".png", colorview(Gray,Graph))
end
