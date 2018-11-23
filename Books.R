camelchart = load.image("~/Nonpara/RGBA{N0f8}(0.8,0.2,0.0,1.0).png")
BW = apply(camelchart, MARGIN=c(1,2), norm)
data = which(BW>0.1,arr.ind=TRUE)
#X's are upside down now, but here's our raw data!
#It needs a bit of cleaning and rescaling, but the hard part is done.

CleanX = X[(X < 675) & (Y < 400)]

CleanY = -Y[(X < 675) & (Y < 400)]

#Trim some bits off, and flip things rightside up...
plot(CleanX,CleanY)

#Let's pull an actual function out of these, though...
YFunc = vector("numeric")
for(i in min(CleanX):max(CleanX)){
  YFunc[i-min(CleanX)] = -max(which(BW[i,]>0.1))
}
library(stats)
plot(acf(YFunc,500))
#Nothing too stunning here; prices are positively correlated from a given point in time to that same time next semester,
#and there is some negative correlation from one year to the next that is pushing back.
#Let's fit a periodic function with period~24 ticks (one semester length in the data)

Xs = min(CleanX):(max(CleanX)-1)
sinX = sin((Xs/24) *2*pi)
cosX = cos((Xs/24) *2*pi)
fit = lm(YFunc~ sinX + cosX)
summary(fit)

#Not an amazing fit, but pretty good. Residuals are definitely still holding a lot of data.
#Could do a generalize linear model if I felt like I wanted more!

