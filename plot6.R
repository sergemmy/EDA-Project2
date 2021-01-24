library(dplyr)

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
NEI1<-subset(NEI, fips=="24510")

d_all1<-merge(NEI1,SCC,by="SCC")
d_all1<-aggregate(Emissions~year+fips, data=d_all1, sum)
d_all1<-mutate(d_all1, change.rate=((Emissions/lag(Emissions)-1)*100))


NEI2<-subset(NEI, fips=="06037")
       
d_all2<-merge(NEI2,SCC,by="SCC")
d_all2<-aggregate(Emissions~year+fips, data=d_all2, sum)
d_all2<-mutate(d_all2, change.rate=((Emissions/lag(Emissions)-1)*100))

d_all<-rbind(d_all1,d_all2)

png("plot6.png", width=480, height=480)

dplot<-ggplot(d_all,aes(x=fips,y=change.rate,color=fips))
dplot+
  geom_jitter()+
  geom_boxplot(alpha=I(0.6))+
  ggtitle("Changes in emission 1999-2008 Baltimore vs. LA zip")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlab("LA vs. Baltimore zip code")+
  ylab("change rate")+
  labs(color="zip code")

dev.off()
