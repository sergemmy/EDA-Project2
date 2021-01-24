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

SCC<-subset(SCC, SCC.Level.One=="Mobile Sources")
NEI<-subset(NEI, fips=="24510")

d_all<-merge(NEI,SCC,by="SCC")
d_all<-aggregate(Emissions~year, data=d_all, sum)

png("plot5.png", width=480, height=480)

dplot<-ggplot(d_all,aes(x=year,y=Emissions))
dplot+geom_line()+ggtitle("Emissions from Mobile Source in Baltimore City")+
  theme(plot.title = element_text(hjust = 0.5))
dev.off()


