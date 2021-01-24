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



nrdbln<-as.logical(NEI[5]=="NON-ROAD")
npntbln<-as.logical(NEI[5]=="NONPOINT")
rdbln<-as.logical(NEI[5]=="ON-ROAD")
pntbln<-as.logical(NEI[5]=="POINT")
pmnrd<-NEI$Emissions[which(nrdbln)]
pmnpnt<-NEI$Emissions[which(npntbln)]
pmrd<-NEI$Emissions[which(rdbln)]
pmpnt<-NEI$Emissions[which(pntbln)]
yearnrd<-NEI$year[which(nrdbln)]
yearnpnt<-NEI$year[which(npntbln)]
yearrd<-NEI$year[which(rdbln)]
yearpnt<-NEI$year[which(pntbln)]
d_nrd<-data.frame(pm25=tapply(pmnrd,yearnrd, FUN=sum),year=c(1999,2002,2005,2008),type=rep("non_road",4))
d_npnt<-data.frame(pm25=tapply(pmnpnt,yearnpnt, FUN=sum),year=c(1999,2002,2005,2008),type=rep("nonpoint",4))
d_rd<-data.frame(pm25=tapply(pmrd,yearrd, FUN=sum),year=c(1999,2002,2005,2008),type=rep("on_road",4))
d_pnt<-data.frame(pm25=tapply(pmpnt,yearpnt, FUN=sum),year=c(1999,2002,2005,2008),type=rep("on_point",4))

d_all<-rbind(d_nrd,d_npnt,d_rd,d_pnt)

