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

pm<-with(NEI, tapply(Emissions, year, FUN = sum))
yearx<-c("1999","2002","2005","2008")

#drawing plot in png

png("plot1.png", width=480, height=480)
plot(yearx,pm/1000000, type = "l", xlab="year", ylab="total ppm2.5 mln ton", col="red", pch=2, ylim=c(0,10),frame=FALSE)

dev.off()
