#Model for general surgery
#Updated: 13/12/17 13:12 by aos



#-------------------Parameters and sets-----------------------------------#
#Numbers of days in the planning horizon
param n;
param m;
param MaxDailyWardLoad :=5;

# set of available patterns
set Patterns;
# set of all days
set Days:= 1..(n);
set WardDays:= 1..(m);
display(WardDays);
display(Days);
set SurgeryType :={'acute', 'elective'};

#Expected surgery time for each pattern
param SurgeryTime{p in Patterns} default 0;

param WorkingHours{Days} default 480;

#Set of all surgeries
set Surgeries;


#-----------------------------------Tolerances and Parameters---------------------------------#
#Number of surgeries of j and type t on Pattern i
param a{Patterns, Surgeries, SurgeryType} default 0;

#Demand for each surgery over planning horizon
param Demand{Surgeries, SurgeryType} default 0;

#Probability that Operation j will be in ward in day d
#Note that Days and WardDays are different sets
param WardStayProb{Surgeries, WardDays, SurgeryType};

#Days when certaint patterns are not available
set PatternNotAvail{p in Patterns} within Days default {};


#----------------------------------Decision variables----------------------------------------#

# Assignment on patterns to days
var x {Patterns, Days} binary;
#Decision variable for ward stay
var y{Patterns, Days, WardDays } >= 0, <= 1;
#Overtime variable
var OT{Days}>=0;
#Undertime variable
var UT{Days}>=0;

#-----------------------------------MODEL---------------------------------------------------#

#One pattern per day
subject to OnePatternPerDay{d in Days}: sum{p in Patterns} x[p, d] = 1;

#Certaint patterns are just only available certain days due  doctors availability
subject to OnlyCertainDays{p in Patterns: card(PatternNotAvail[p])>0}: sum{d in PatternNotAvail[p]} x[p,d]=0;

#Meet the Demand
subject to MeetDemand{s in Surgeries, t in SurgeryType}: sum{p in Patterns, d in Days}x[p,d]*a[p,s,t] >= Demand[s,t];

# OverTime
subject to OverTime{d in Days}: OT[d] >= sum{p in Patterns} x[p,d]*SurgeryTime[p]-WorkingHours[d];

# Undertime
subject to UnderTime{d in Days}:UT[d] >= WorkingHours[d]-sum{p in Patterns} x[p,d]*SurgeryTime[p];


#Ward load - Admission of p or less patients to a ward on daily basis.
#comment: Maybe it is nice to have this constraint if they want to have an upper limit on the daily number of patients 
#         admitted to the ward - aos 
#comment: This is not working properly since some patients don't need to go to the ward after a surgery. 
subject to NoOverload{d in Days}: sum{s in Surgeries, t in SurgeryType,p in Patterns} x[p,d]*a[p,s,t] <= MaxDailyWardLoad;


#Ward stay
subject to WardStay{p in Patterns, d in Days: d <= (card(Days)-card(WardDays))}: card(WardDays)*x[p,d]=sum{wd in WardDays} y[p,d+wd,wd];

#Costraints that are needed:
  #Guarantee that each patient does not stay longer than expected
  #Make sure that beds are available for a given plan
  #Force the recovery to start only once

#maximize obj: sum{d in Days, p in Patterns}x[p,d];
minimize Objective: sum{d in Days}(OT[d]+UT[d]);



solve;


data;

set PatternNotAvail[1] := 1 3 5 7 9;
set PatternNotAvail[2] := 2 4 6 8 10;

param a :=
1 A elective 2
1 B elective 3
2 A elective 3
2 B elective 2
;



param Demand :=
A 'elective' 2
B 'elective' 3
;

set Patterns:=
1
2
;




set Surgeries :=
A
B
;


param n :=10;
param m :=10;

param SurgeryTime :=
1 450
2 360
;
