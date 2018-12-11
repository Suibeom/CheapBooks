library(imager)
camelchart = load.image("~/Nonpara/RGBA{N0f8}(0.8,0.2,0.0,1.0).png")
#3054 days; one tic corresponds to 
BW = apply(camelchart, MARGIN=c(1,2), norm)
dat = which(BW>0.1,arr.ind=TRUE)
X = dat[,1]
Y = dat[,2]
#X's are upside down now, but here's our raw data!
#It needs a bit of cleaning and rescaling, but the hard part is done.

CleanX = X[(X < 675) & (Y < 400)]
ScaledX = (min(CleanX):(max(CleanX)-1)*(3054/365)/(max(CleanX)-min(CleanX)))
YearlyX = ScaledX %% 1
CleanY = -Y[(X < 675) & (Y < 400)]

#Trim some bits off, and flip things rightside up, and rescale...
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


#sinX1 = sin((Xs/17) *2*pi)
#cosX1 = cos((Xs/17) *2*pi)

sinX2 = sin((Xs/56) *2*pi)
cosX2 = cos((Xs/56) *2*pi)


sinX3 = sin((Xs/34) *2*pi)
cosX3 = cos((Xs/34) *2*pi)
fit = lm(YFunc~ Xs+ sinX1 + cosX1 + sinX2 + cosX2+ sinX3 + cosX3)
summary(fit)


#Let's try another method that should work somewhat better. I want my function to be periodic:
#Lets fit against a bunch of levelset vectors for each time click. This will be a little imperfect
#because it'll drift a little bit...
pc = c(replicate(9,1:80))[1:615]
year = c()
for(i in 1:9){
  year = c(year,replicate(80,i))
}

YFuncmins = vector("numeric",length(YFunc))
for(i in 3:(length(YFunc)-2)){
  YFuncmins[i]=min(YFunc[(i-2):(i+2)])
}
onehotdate=data.frame(Y=YFuncmins,XX=year[1:615]) #hah!!
for(i in 1:80){
  onehotdate[paste("X",as.character(i),sep="")] = (pc == i)
}

#Now let's do the real deal: Using lags, fit a linear model to predict the next step.
#We'll use five steps back.

YFuncLags = cbind(YFunc[5:614],YFunc[4:613],YFunc[3:612],YFunc[2:611],YFunc[1:610])
YTarg = YFunc[6:615]
yts = lm(YTarg~YFuncLags)
plot(YTarg,type="l")
lines(yts$fitted.values,col="red")
#Ahhhh. That's more like it!

