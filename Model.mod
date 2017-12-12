#Model for general surgery
#Updated: 12/12/17 12:10 by aos



#-------------------Parameters and sets-----------------------------------#
#Numbers of days in the planning horizon
param n;
param m;

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

#Meet the Demand
subject to MeetDemand{s in Surgeries, t in SurgeryType}: sum{p in Patterns, d in Days}x[p,d]*a[p,s,t] >= Demand[s,t];

# OverTime
subject to OverTime{d in Days}: OT[d] >= sum{p in Patterns} x[p,d]*SurgeryTime[p]-WorkingHours[d];

# Undertime
subject to UnderTime{d in Days}:UT[d] >= WorkingHours[d]-sum{p in Patterns} x[p,d]*SurgeryTime[p];

#Ward stay
subject to WardStay{p in Patterns, d in Days: d <= (card(Days)-card(WardDays))}: card(WardDays)*x[p,d]=sum{wd in WardDays} y[p,d+wd,wd];


#maximize obj: sum{d in Days, p in Patterns}x[p,d];
minimize Objective: sum{d in Days}(OT[d]+UT[d]);



solve;


data;


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
