# script in R to extract a schedule to simulate
# Date: 6th of dec 
#--------------------------------------------------------------------------------------------------------------------#
require(lubridate) # https://www.r-statistics.com/2012/03/do-more-with-dates-and-times-in-r-with-lubridate-1-1-0/
library(xlsx)  
# clean up the workspace memory
rm(list=ls())

#----------------------------------Excel file load---------------------------------------#
# Load data from Excel file
fname <- c("schedule.xlsx")
xlsxFile <- system.file(fname, package = "openxlsx")
wb = loadWorkbook(fname)

planid <- readWorkbook(fname, sheet = 1, startRow = 1, colNames = TRUE,detectDates = TRUE)
sort(planid)

#----------------------------------------------------------------------------------------#
code = planid['Aðgerðarkóði']
dagur = parse_date_time(planid$Skipulagður.upphafstími, "%y-%m-%d %H:%M:%S") #This must be used
day = format(dagur, "%m/%d/%y")
timi = format(dagur, "%H:%M:%S")
room = planid['Skipulögð.stofa']
age = planid['Aldur.sjúklings.í.dag']
surgeon = planid['Umbeðinn.læknir']
innlogn = planid['Tegund.innlagnar']
sergrein= planid['Sérgrein']



starttime =as.Date(dagur)+as.difftime(timi, units="days")

#-------------------------------------Binary operations------------------------------------------------#


Elective = planid['Val/bráða'] == 'Valaðgerð'
idx = Elective & starttime >= dmy('11.12.2017') & starttime <=dmy('15.12.2017') 

#------------------------------------New dataframe-----------------------------------------------------#
theplan = data.frame(day=day[idx], timi= timi[idx], code = code[idx], room=room[idx],innlogn=innlogn[idx],surgeon=surgeon[idx],
                     age = ceiling(age[idx]), sergrein=sergrein[idx]) 



#Lets search for general surgery 
PlanForSimulation= subset(theplan, theplan$sergrein=='Hb. Alm.')



levels(PlanForSimulation$innlogn)[1] <-"Nei"
levels(PlanForSimulation$innlogn)[2] <-"Já"
PlanForSimulation = PlanForSimulation[order(as.Date(PlanForSimulation$day, format="%m/%d/%Y")),]
PlanForSimulation = PlanForSimulation[order(as.Date(PlanForSimulation$day, format="%m/%d/%Y")),]

#----------------------------------Write tables------------------------------------------------------#
write.table(PlanForSimulation, file="theplan.csv", row.names = F, col.names= F, quote = F)
save(file='Stuff2.Rdata', list=c("PlanForSimulation"))



