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

#capturing indices with word Coal
coal_ind<-which(grepl("(Coal)",SCC$Short.Name)|grepl("(Coal)", SCC$EI.Sector))
SCC<-SCC[coal_ind,,drop=F]
d_all<-merge(NEI,SCC,by="SCC")
d_all<-aggregate(Emissions~year, data=d_all, sum)

png("plot4.png", width=480, height=480)

dplot<-ggplot(d_all,aes(x=year,y=Emissions/1000000))
dplot+geom_line()+ylim(0,0.6)
dev.off()
