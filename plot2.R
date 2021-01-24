#file location

wd<-getwd()
temp <- tempfile()
file1<-paste0(wd,"/Source_Classification_Code.rds")
file2<-paste0(wd,"/summarySCC_PM25.rds")

fileURL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

#check if files exist in wd

if ((!file.exists(file1))|(!file.exists(file2)))
{
  download.file(fileURL,temp)
  unzip(temp)
  unlink(temp)
}

#create data frames
if (("Source_Classification_Code.rds" %in% dir()) & ("summarySCC_PM25.rds" %in% dir()))
{
  NEI <- readRDS("summarySCC_PM25.rds")
  SCC <- readRDS("Source_Classification_Code.rds")
}

#create a list of emissions and years from 1 county
fcnt<-as.logical(NEI[1]=="24510")  
emmcnty<-NEI$Emissions[which(fcnt)]
yearcnty<-NEI$year[which(fcnt)]

pm<-with(NEI, tapply(Emissions, year, FUN = sum))

#creating plot

png("plot2.png", width=480, height=480)

plot(c("1999","2002","2005","2008"),tapply(emmcnty, yearcnty, FUN=sum)/1000, xlab="year", 
                                          ylab="total ppm2.5 tnd ton",
                                          ylim=c(1,3.5),
                                          frame=FALSE,
                                          col="red",
                                          type="l",
                                          pch=2,
                                          xaxt="none")
axis(1,seq(1999,2008,3))

dev.off()

