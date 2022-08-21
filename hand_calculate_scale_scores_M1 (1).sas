*-----------------------------------------*; 

* PERSONALILTY TRAITS -- MIDUS 1 

*-----------------------------------------*; 

proc import datafile= "C:\Users\samcamp7\Downloads\M1\02760-0001-Data.sav" out=PERSONALITY dbms = sav replace; run;
DATA PERSONALITY2; SET PERSONALITY;

* MIDUS calculated Personality Scores *;

agency=	A1SAGENC;
agree =	A1SAGREE;
cons =	A1SCONS;
extra =	A1SEXTRA;
neuro =	A1SNEURO;
open=	A1SOPEN;

/*Carelessness is reverse coded*/
IF A1SF4X = 1 or 2 or 3 or 4 then A1SF4X = 5 - A1SF4X;

/*Calm is reverse coded*/
if A1SF4S = 1 or 2 or 3 or 4 then A1SF4S = 5 - A1SF4S;

KEEP 
/*ID number, Retired, Age*/ M2ID A1PB3E A1PAGE_M2
agency agree cons extra neuro open 
/*agency items*/ A1SF4E A1SF4J A1SF4O A1SF4T A1SF4DD 
/*agree items*/ A1SF4B A1SF4G A1SF4L A1SF4R A1SF4Z
/*cons items*/ A1SF4D A1SF4I A1SF4P A1SF4X
/*extra items*/ A1SF4A A1SF4F A1SF4K A1SF4W A1SF4AA
/*neuro items*/ A1SF4C A1SF4H A1SF4M A1SF4S
/*open items*/ A1SF4N A1SF4Q A1SF4U A1SF4V A1SF4Y A1SF4BB A1SF4CC;
RUN;

DATA PERSONALITY3; SET PERSONALITY2;
* New calculated Personality Scores *;

*-----------------------------------------------------------------------*;
* AGENCY *;
*-----------------------------------------------------------------------*;
array agency_orig {*} A1SF4E A1SF4J A1SF4O A1SF4T A1SF4DD;
array agency_arr_new {*} SF4E SF4J SF4O SF4T SF4DD;

do i = 1 to dim(agency_orig);
	if agency_orig {i} = 7 then agency_orig {i} = .N;
	else if agency_orig {i} = 8 then agency_orig {i} = .M;
	else;  
	if agency_orig {i} <= .Z then agency_arr_new {i} = .;
	else agency_arr_new {i} = 5 - agency_orig {i};
end;

if n (of SF4E SF4J SF4O SF4T SF4DD) <= 2 then agency_new = .;
else agency_new = mean(of SF4E SF4J SF4O SF4T SF4DD);


*-----------------------------------------------------------------------*;
* AGREEABLENESS *;
*-----------------------------------------------------------------------*;
array agree_arr_orig {*} A1SF4B A1SF4G A1SF4L A1SF4R A1SF4Z;
array agree_arr_new {*} SF4B SF4G SF4L SF4R SF4Z;

do i = 1 to dim(agree_arr_orig);
	if agree_arr_orig {i} = 7 then agree_arr_orig {i} = .N;
	else if agree_arr_orig {i} = 8 then agree_arr_orig {i} = .M;
	else;  
	if agree_arr_orig {i} <= .Z then agree_arr_new {i} = .;
	else agree_arr_new {i} = 5 - agree_arr_orig {i};
end;

if n (of SF4B SF4G SF4L SF4R SF4Z) <= 2 then agree_new = . ;
else agree_new = mean(of SF4B SF4G SF4L SF4R SF4Z);


*-----------------------------------------------------------------------*;
* CONSCIENTIOUSNESS *;
*-----------------------------------------------------------------------*;
array cons_arr_orig {*} A1SF4D A1SF4I A1SF4P A1SF4X;
array cons_arr_new {*} SF4D SF4I SF4P SF4X;

do i = 1 to dim(cons_arr_orig);
	if cons_arr_orig {i} = 7 then cons_arr_orig {i} = .N;
	else if cons_arr_orig {i} = 8 then cons_arr_orig {i} = .M;
	else;  
	if cons_arr_orig {i} <= .Z then cons_arr_new {i} = .;
	else cons_arr_new {i} = 5 - cons_arr_orig {i};
end;

if n (of SF4D SF4I SF4P SF4X) <= 1 then cons_new = . ;
else cons_new = mean(of SF4D SF4I SF4P SF4X);


*-----------------------------------------------------------------------*;
* EXTRAVERSION *;
*-----------------------------------------------------------------------*;
array extra_arr_orig {*} A1SF4A A1SF4F A1SF4K A1SF4W A1SF4AA;
array extra_arr_new {*} SF4A SF4F SF4K SF4W SF4AA;

do i = 1 to dim(extra_arr_orig);
	if extra_arr_orig {i} = 7 then extra_arr_orig {i} = .N;
	else if extra_arr_orig {i} = 8 then extra_arr_orig {i} = .M;
	else;  
	if extra_arr_orig {i} <= .Z then extra_arr_new {i} = .;
	else extra_arr_new {i} = 5 - extra_arr_orig {i};
end;

if n (of SF4A SF4F SF4K SF4W SF4AA) <= 2 then extra_new = . ;
else extra_new = mean(of SF4A SF4F SF4K SF4W SF4AA);


*-----------------------------------------------------------------------*;
* NEUROTICISM *;
*-----------------------------------------------------------------------*;
array neuro_arr_orig {*} A1SF4C A1SF4H A1SF4M A1SF4S;
array neuro_arr_new {*} SF4C SF4H SF4M SF4S;

do i = 1 to dim(neuro_arr_orig);
	if neuro_arr_orig {i} = 7 then neuro_arr_orig {i} = .N;
	else if neuro_arr_orig {i} = 8 then neuro_arr_orig {i} = .M;
	else;  
	if neuro_arr_orig {i} <= .Z then neuro_arr_new {i} = .;
	else neuro_arr_new {i} = 5 - neuro_arr_orig {i};
end;

if n (of SF4C SF4H SF4M SF4S) <= 1 then neuro_new = . ;
else neuro_new = mean(of SF4C SF4H SF4M SF4S);


*-----------------------------------------------------------------------*;
* OPENNESS  *;
*-----------------------------------------------------------------------*;
array open_arr_orig {*} A1SF4N A1SF4Q A1SF4U A1SF4V A1SF4Y A1SF4BB A1SF4CC;
array open_arr_new {*} SF4N SF4Q SF4U SF4V SF4Y SF4BB SF4CC;

do i = 1 to dim(open_arr_orig);
		 if open_arr_orig {i} = 7 then open_arr_orig {i} = .N;
	else if open_arr_orig {i} = 8 then open_arr_orig {i} = .M;
	else;  
	if open_arr_orig {i} <= .Z then open_arr_new {i} = .;
	else open_arr_new {i} = 5 - open_arr_orig {i};
end;

if n (of SF4N SF4Q SF4U SF4V SF4Y SF4BB SF4CC) <= 3 then open_new = . ;
else open_new = mean(of SF4N SF4Q SF4U SF4V SF4Y SF4BB SF4CC);



KEEP 
M2ID A1PB3E	A1PAGE_M2
agency 	agency_new   
agree 	agree_new   
cons 	cons_new   
extra 	extra_new   
neuro 	neuro_new   
open 	open_new; 
RUN;

title1 "Entire MIDUS 1 Sample";
proc means data = PERSONALITY3; 
vars
agency 	agency_new   
agree 	agree_new   
cons 	cons_new   
extra 	extra_new   
neuro 	neuro_new   
open 	open_new;
run;

PROC SORT DATA=PERSONALITY3 OUT= PERSONALITY4; 
BY M2ID; 
RUN;




*----------------------------------------------------------------------------------------------------------------------------------------------*;
* CHECKING IF THE VALUES ARE THE SAME FOR PROJECT SAMPLE:
* 	> Retired and 55+ years old
* 	> Participated in both MIDUS 1 and Daily Diary Project
*----------------------------------------------------------------------------------------------------------------------------------------------*;

PROC IMPORT datafile= "C:\Users\samcamp7\Downloads\M1\03725-0001-Data.sav" out=DAILY dbms = sav replace; run;
PROC SORT DATA = DAILY OUT = DAILY1; BY M2ID; run; 

DATA mergeddata;
	MERGE DAILY1 PERSONALITY4;
	BY M2ID;
KEEP 
M2ID A1PB3E A1PAGE_M2
agency 	agency_new   
agree 	agree_new   
cons 	cons_new   
extra 	extra_new   
neuro 	neuro_new   
open 	open_new;
RUN; 

PROC SORT DATA= MERGEDDATA OUT = MERGEDDATA1; BY M2ID; RUN;

PROC SORT DATA = MERGEDDATA1 OUT = MERGEDDATA2; 
	WHERE A1PB3E=1 and A1PAGE_M2 >= 55 and agree >=0 and cons >=0 and extra >=0 and neuro >=0 and open >=0; 
	BY M2ID;
RUN;

DATA oursample; SET MERGEDDATA2;
KEEP 
M2ID A1PB3E A1PAGE_M2
agency 	agency_new   
agree 	agree_new   
cons 	cons_new   
extra 	extra_new   
neuro 	neuro_new   
open 	open_new;
RUN;

PROC SORT data= oursample NODUPKEY out = oursample; 
BY M2ID; 
RUN;

title1 "Retired 55+ Adult Participants of Both MIDUS 1 Main Study and Daily Diary Project";
PROC MEANS DATA = oursample;
VARS
agree 	agree_new   
cons 	cons_new   
extra 	extra_new   
neuro 	neuro_new   
open 	open_new;
RUN;

/*Values not the same. Sample size is bigger than previously calculated descriptive statistics*/
