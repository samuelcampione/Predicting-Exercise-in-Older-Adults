* PERSONALILTY TRAITS; 
proc import datafile= "U:\Documents\Projects\Mine\icpsrdata\36532-0001-Data.sav" out=PERSONALITY dbms = sav replace; run;

DATA PERSONALITY; SET PERSONALITY;
* SEX *;
female=0;
if RA1PRSEX = 2 then female = 1;

* EDUCATION *;
NoGEDHS=RA1PB1;
if RA1PB1 =1 or  RA1PB1 =2 or  RA1PB1 =3 then NoGEDHS=1;
else if RA1PB1 =4 or RA1PB1 =5 or RA1PB1 =6 or RA1PB1 =7 or RA1PB1 =8 or RA1PB1 =9 or RA1PB1 =10 or RA1PB1 =11 or RA1PB1 =12 then NoGEDHS = 0;

* RACE *;
notWhite=.;
if RA1PF7A = 1 then notWhite = 0;
else if RA1PF7A = 0 or RA1PF7A = 2 or RA1PF7A = 3 or RA1PF7A = 4 or RA1PF7A = 5 or RA1PF7A =  6 then notWhite = 1;
if RA1PF7A = 1 then White = 1;
else if RA1PF7A = 0 or RA1PF7A = 2 or RA1PF7A = 3 or RA1PF7A = 4 or RA1PF7A = 5 or RA1PF7A =  6 then White = 0;

* DAILY ACTIVITIES *;
ADL1 = RA1SBADL2;  
ADL_c1 = ADL1-1; *CENTER TO 1;

agency=	RA1SAGENC;
agree =	RA1SAGREE;
cons =	RA1SCONS2;
extra =	RA1SEXTRA;
neuro =	RA1SNEURO;
open=	RA1SOPEN;

KEEP MRID FEMALE  ADL_c1 OPEN NEURO EXTRA CONS AGREE AGENCY NoGEDHS NOTWHITE WHITE RA1PB3WK; 
RUN;

PROC SORT DATA=PERSONALITY OUT=PERSONALITY; BY MrID; RUN; 

proc import datafile= "U:\Documents\Projects\Mine\icpsrdata\37083-0001-Data.sav" out=daily dbms = sav replace; run;
PROC SORT DATA = daily OUT = daily; BY mrid; run; 
proc contents; run;

proc freq; table RA2DIMON; run;

data daily; set daily; winter=.; spring=.; summer=.; fall=.; 
intmonth=.; 
intmonth=RA2DIMON;
if intmonth =  1 or intmonth =  2 or intmonth =  3      then do; winter = 1; spring = 0; summer = 0; fall = -1; end;
else if intmonth =  4 or intmonth =  5 or intmonth =  6 then do; winter = 0; spring = 1; summer = 0; fall = -1; end;
else if intmonth =  7 or intmonth =  8 or intmonth =  9 then do; winter = 0; spring = 0; summer = 1; fall = -1; end;
else if intmonth = 10 or intmonth = 11 or intmonth = 12 then do; winter = 0; spring = 0; summer = 0; fall = -1; end; 
run;



DATA daily; SET daily; KEEP MRID winter spring summer fall RA2DIMON RA2DDAY RA2DWEEKD RA2DA4AH RA2DA4AM RA1PRAGE RA1PRSEX; RUN;

PROC SQL;
CREATE TABLE daily1 AS
SELECT *,
((RA2DA4AH*60 + RA2DA4AM)/60) as PAhours
FROM daily; QUIT;
PROC SORT DATA = daily1 OUT = daily1; BY mrid; run; 


DATA daily1; SET daily1;
		wkend=0; 
             IF RA2DWEEKD=6 or RA2DWEEKD=7 then wkend=1; 
		ELSE IF RA2DWEEKD=. then wkend=.;

		PA_u=0; PA_m=0; 
        IF PAhours = . then PA_u=.; ELSE IF PAhours gt 0 then PA_u=1;
		IF PAhours = 0 then PA_m=.; ELSE IF PAhours = .  then PA_m=.; ELSE IF PAhours gt 0 then PA_m=PAhours;

		agec=0;
        agec=RA1PRAGE-48.2653445; 

		if RA2DWEEKD=1 then mon=1; else mon=0; 
		if RA2DWEEKD=2 then tue=1; else tue=0;
		if RA2DWEEKD=3 then wed=1; else wed=0;
		if RA2DWEEKD=4 then thu=1; else thu=0;
		if RA2DWEEKD=5 then fri=1; else fri=0;
		if RA2DWEEKD=6 then sat=1; else sat=0;
		if RA2DWEEKD=7 then sun=1; else sun=0;
RUN;

PROC SORT DATA = daily1 OUT = daily1; BY mrid; run; 

DATA mergeddata; 
  MERGE daily1 personality; 
  BY mrid; 
keep MRID RA1PB3WK winter spring summer fall RA2DDAY wkend PA_u PA_m PAhours RA1PRAGE agec mon tue wed thu fri sat sun female NoGEDHS notWhite White ADL_c1 agency agree cons extra neuro open;
RUN; 

PROC SORT DATA = mergeddata out = PA_personality; BY mrid; run; 

proc sort data=pa_personality out=pa_personality; where RA2DDAY >=1 and NoGEDHS >=0 and pa_u >=0 and open>=0 and adl_c1 >=0 and notwhite>=0 and RA1PRAGE >=0 ; by mrid; run;

data onerecord; set PA_personality; keep mrid RA1PRAGE female OPEN NEURO AGREE CONS EXTRA nogedhs notwhite adl_c1 winter spring summer; run; 
proc sort data=onerecord NODUPKEY out=onerecord; by mrid; run;
proc means data=onerecord; run;

data PA_personality2; set PA_personality; where RA1PB3WK=5; run;
data onerecord; set PA_personality2; keep mrid mon tue wed thu fri sat RA1PRAGE female OPEN NEURO AGREE CONS EXTRA nogedhs notwhite adl_c1 winter spring summer; run; 
proc sort data=onerecord NODUPKEY out=onerecord; by mrid; run;
proc means data=onerecord; run;

title1 "conditional logit model";
proc nlmixed data=PA_personality2 qpoints=5 gconv=0; 
pi = arcos(-1); log2pi = log(2*pi); 
parms 
a0	1.5156
a1a	1.0056
a1b	0.7514
a1c	0.4487
a1d	1.1529
a1e	0.9449
a1f	0.3849
a2	-0.03528
a3	-0.7844
a6	-0.8363
a7a	0.9955
a7b	-0.1474
a7c	0.08967
a7d	-0.3926
a7e	0.1569
a8c	-0.5721
alp0	-1.4872
a1pa	-0.01808
a1pb	-0.379
a1pc	-0.4513
a1pd	-0.2325
a1pe	0.5533
a1pf	-0.1958
alp2	0.04521
alp3	0.3246
alp6	0.2862
alp7a	2.321
alp7b	-0.6961
alp7c	2.3787
alp7d	-2.0756
alp7e	-0.3509
alp8c	0.8493;

sda=sqrt(exp(alp0 + a1pa*Mon + a1pb*Tue + a1pc*Wed + a1pd*Thu + a1pe*Fri + a1pf*Sat + alp2*agec + alp3*female + alp6*ADL_c1 +
alp7a*(open-2.9169) + alp7b*(cons-3.3527) + alp7c*(extra-3.0609) + alp7d*(agree-3.36) + alp7e*(neuro-2.1475) + alp8c*summer
));
ueta = a0 + a1a*Mon + a1b*Tue + a1c*Wed + a1d*Thu + a1e*Fri + a1f*Sat + a2*agec + a3*female + a6*ADL_c1 +
a7a*(open-3.06) + a7b*(cons-3.45) + a7c*(extra-3.17) + a7d*(agree-3.42) + a7e*(neuro-1.93) + a8c*summer  + theta*sda;
expeta = exp(ueta); p = expeta/(1+expeta); 
LL = log((1-p)**(1-PA_u)) + log(p**(PA_u)); 

model PAhours ~ general(LL);
random theta ~ normal ([0], [1]) subject=mrid;
run;

title1 "conditional two part MELS for binary PA by personality ";
proc mcmc data=PA_personality2 seed=2021 nbi = 100000 nmc=20000000 ntu=2000 outpost=outMixed plots = all nthreads=-1;
parms 
a0	0.5749
a1a	1.058
a1b	0.7148
a1c	0.4871
a1d	1.2983
a1e	1.1017
a1f	0.4037
a2	-0.0245
a3	-0.6741
a6	-0.6712
a7a	0.5126
a7b	-0.1414
a7c	0.4965
a7d	-0.3518
a7e	0.1084
a8c	0.3546
alp0	-1.3936

alp6	0.1029
alp7a	2.0421
alp7b	-0.8416
alp7c	2.4533
alp7d	-1.9347
alp7e	-0.3579
alp8c	0.8707;

prior a: ~ normal(0,var=100);

sda=sqrt(exp(alp0 + alp6*ADL_c1 +
alp7a*(open-2.9169) + alp7b*(cons-3.3527) + alp7c*(extra-3.0609) + alp7d*(agree-3.36) + alp7e*(neuro-2.1475) + alp8c*summer));

ueta = logistic(a0 + a1a*Mon + a1b*Tue + a1c*Wed + a1d*Thu + a1e*Fri + a1f*Sat + a2*agec + a3*female + a6*ADL_c1 +
a7a*(open-2.9169) + a7b*(cons-3.3527) + a7c*(extra-3.0609) + a7d*(agree-3.36) + a7e*(neuro-2.1475) + a8c*summer  + ai*sda);

model PA_u ~ binary(ueta);
random ai ~ normal(0,var=1) subject = mrid;
run;   

proc means data=PA_personality2; var pa_u; run;

title1 "conditional two part MELS for binary PA by personality ";
proc mcmc data=PA_personality2 seed=2021 nbi = 50000 nmc=20000000 ntu=2000 thin=2000 outpost=outMixed plots = all nthreads=-1;
parms 
a0	1.2465
a1a	1.0151
a1b	0.7322
a1c	0.4546
a1d	1.2188
a1e	0.9444
a1f	0.3842
a2	-0.0384
a3	-0.5915
a6	-0.8637
a7a	0.6842
a7b	0.0394
a7c	0.2336
a7d	-0.6689
a7e	-0.0197
a8c	-0.2933
alp0	-0.6132
alpa	-0.434
alpb	-0.8845
alpc	-0.8864
alpd	-0.5364
alpe	0.1682
alpf	-0.4934
alp2	0.0676
alp3	0.3291
alp6	0.0388
alp7a	2.0396
alp7b	-1.0755
alp7c	2.4387
alp7d	-1.9269
alp7e	-0.3045
alp8c 0;

prior a: ~ normal(0,var=100);

sda=sqrt(exp(alp0 + alpa*Mon + alpb*Tue + alpc*Wed + alpd*Thu + alpe*Fri + alpf*Sat + alp2*(RA1PRAGE-66.1893831) + alp3*female + alp6*ADL_c1 +
alp7a*(open-2.9169) + alp7b*(cons-3.3527) + alp7c*(extra-3.0609) + alp7d*(agree-3.36) + alp7e*(neuro-2.1475) + alp8c*summer));

ueta = logistic(a0 + a1a*Mon + a1b*Tue + a1c*Wed + a1d*Thu + a1e*Fri + a1f*Sat + a2*(RA1PRAGE-66.1893831) + a3*female + a6*ADL_c1 +
a7a*(open-2.9169) + a7b*(cons-3.3527) + a7c*(extra-3.0609) + a7d*(agree-3.36) + a7e*(neuro-2.1475) + a8c*summer  + ai*sda);

model PA_u ~ binary(ueta);
random ai ~ normal(0,sd=1) subject = mrid;
run;   



title1 "conditional two part MELS for binary PA by personality ";
proc mcmc data=PA_personality2 seed=2021 nbi = 50000 nmc=20000000 ntu=2000 thin=2000 outpost=outMixed plots = all nthreads=-1;
parms 
a0	1.2465
a1a	1.0151
a1b	0.7322
a1c	0.4546
a1d	1.2188
a1e	0.9444
a1f	0.3842
a2	-0.0384
a3	-0.5915
a6	-0.8637
a7a	0.6842
a7b	0.0394
a7c	0.2336
a7d	-0.6689
a7e	-0.0197
a8c	-0.2933
alp0	-0.6132;

prior a: ~ normal(0,var=100);

sda=sqrt(exp(alp0));

ueta = logistic(a0 + a1a*Mon + a1b*Tue + a1c*Wed + a1d*Thu + a1e*Fri + a1f*Sat + a2*(RA1PRAGE-66.1893831) + a3*female + a6*ADL_c1 +
a7a*(open-2.9169) + a7b*(cons-3.3527) + a7c*(extra-3.0609) + a7d*(agree-3.36) + a7e*(neuro-2.1475) + a8c*summer  + ai*sda);

model PA_u ~ binary(ueta);
random ai ~ normal(0,sd=1) subject = mrid;
run;   

