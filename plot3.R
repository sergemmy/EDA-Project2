library(ggplot2)
library(lubridate)

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

d_all<-subset(NEI, NEI$fips=="24510")
d_all<-aggregate(Emissions~type+year, data=d_all, sum)


png("plot3.png", width=480, height=480)

dplot<-ggplot(d_all,aes(x=year,y=Emissions,color=type))
dplot+geom_line()+facet_grid(rows=vars(type), scales = "free_y")

dev.off()















