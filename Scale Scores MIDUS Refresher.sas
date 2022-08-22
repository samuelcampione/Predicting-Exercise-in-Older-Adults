*-----------------------------------------*; 

* PERSONALILTY TRAITS -- MIDUS Refresher 

*-----------------------------------------*; 

proc import datafile= "C:\Users\samcamp7\Downloads\M Refresher\36532-0001-Data.sav" out=PERSONALITY dbms = sav replace; run;
DATA PERSONALITY2; SET PERSONALITY;

* MIDUS calculated Personality Scores *;

agency =	RA1SAGENC;
agree  =	RA1SAGREE;
cons   =	RA1SCONS2;
extra  =	RA1SEXTRA;
neuro  =	RA1SNEURO;
open   =	RA1SOPEN;

/*Carelessness is reverse coded*/
IF RA1SF6X = 1 or 2 or 3 or 4 then RA1SF6X = 5 - RA1SF6X;

/*Calm is reverse coded*/
if RA1SF6S = 1 or 2 or 3 or 4 then RA1SF6S = 5 - RA1SF6S;



KEEP
/*ID number, Retired, Age*/ MRID RA1PB3WK RA1PRAGE
agency agree cons extra neuro open
/*agency items*/ RA1SF6E RA1SF6J RA1SF6O RA1SF6T RA1SF6DD	
/*agree items*/  RA1SF6B RA1SF6G RA1SF6L RA1SF6R RA1SF6Z	
/*cons items*/   RA1SF6D RA1SF6I RA1SF6P RA1SF6X RA1SF6EE	
/*extra items*/  RA1SF6A RA1SF6F RA1SF6K RA1SF6W RA1SF6AA	
/*neuro items*/  RA1SF6C RA1SF6H RA1SF6M RA1SF6S	
/*open items*/   RA1SF6N RA1SF6Q RA1SF6U RA1SF6V RA1SF6Y RA1SF6BB RA1SF6CC;

RUN;

DATA PERSONALITY3; SET PERSONALITY2;
* New calculated Personality Scores *;

*-----------------------------------------------------------------------*;
* AGENCY *;
*-----------------------------------------------------------------------*;
array agency_orig {*} RA1SF6E RA1SF6J RA1SF6O RA1SF6T RA1SF6DD;
array agency_arr_new {*} SF6E SF6J SF6O SF6T SF6DD;

do i = 1 to dim(agency_orig);
	if agency_orig {i} = 7 then agency_orig {i} = .N;
	else if agency_orig {i} = 8 then agency_orig {i} = .M;
	else;  
	if agency_orig {i} <= .Z then agency_arr_new {i} = .;
	else agency_arr_new {i} = 5 - agency_orig {i};
end;

if n (of SF6E SF6J SF6O SF6T SF6DD) <= 2 then agency_new = .;
else agency_new = mean(of SF6E SF6J SF6O SF6T SF6DD);


*-----------------------------------------------------------------------*;
* AGREEABLENESS *;
*-----------------------------------------------------------------------*;
array agree_arr_orig {*} RA1SF6B RA1SF6G RA1SF6L RA1SF6R RA1SF6Z;
array agree_arr_new {*} SF6B SF6G SF6L SF6R SF6Z;

do i = 1 to dim(agree_arr_orig);
	if agree_arr_orig {i} = 7 then agree_arr_orig {i} = .N;
	else if agree_arr_orig {i} = 8 then agree_arr_orig {i} = .M;
	else;  
	if agree_arr_orig {i} <= .Z then agree_arr_new {i} = .;
	else agree_arr_new {i} = 5 - agree_arr_orig {i};
end;

if n (of SF6B SF6G SF6L SF6R SF6Z) <= 2 then agree_new = . ;
else agree_new = mean(of SF6B SF6G SF6L SF6R SF6Z);


*-----------------------------------------------------------------------*;
* CONSCIENTIOUSNESS *;
*-----------------------------------------------------------------------*;
array cons_arr_orig {*} RA1SF6D RA1SF6I RA1SF6P RA1SF6X RA1SF6EE;
array cons_arr_new {*} SF6D SF6I SF6P SF6X SF6EE;

do i = 1 to dim(cons_arr_orig);
	if cons_arr_orig {i} = 7 then cons_arr_orig {i} = .N;
	else if cons_arr_orig {i} = 8 then cons_arr_orig {i} = .M;
	else;  
	if cons_arr_orig {i} <= .Z then cons_arr_new {i} = .;
	else cons_arr_new {i} = 5 - cons_arr_orig {i};
end;

if n (of SF6D SF6I SF6P SF6X SF6EE) <= 2 then cons_new = . ;
else cons_new = mean(of SF6D SF6I SF6P SF6X SF6EE);


*-----------------------------------------------------------------------*;
* EXTRAVERSION *;
*-----------------------------------------------------------------------*;
array extra_arr_orig {*} RA1SF6A RA1SF6F RA1SF6K RA1SF6W RA1SF6AA;
array extra_arr_new {*} SF6A SF6F SF6K SF6W SF6AA;

do i = 1 to dim(extra_arr_orig);
	if extra_arr_orig {i} = 7 then extra_arr_orig {i} = .N;
	else if extra_arr_orig {i} = 8 then extra_arr_orig {i} = .M;
	else;  
	if extra_arr_orig {i} <= .Z then extra_arr_new {i} = .;
	else extra_arr_new {i} = 5 - extra_arr_orig {i};
end;

if n (of SF6A SF6F SF6K SF6W SF6AA) <= 2 then extra_new = . ;
else extra_new = mean(of SF6A SF6F SF6K SF6W SF6AA);


*-----------------------------------------------------------------------*;
* NEUROTICISM *;
*-----------------------------------------------------------------------*;
array neuro_arr_orig {*} RA1SF6C RA1SF6H RA1SF6M RA1SF6S;
array neuro_arr_new {*} SF6C SF6H SF6M SF6S;

do i = 1 to dim(neuro_arr_orig);
	if neuro_arr_orig {i} = 7 then neuro_arr_orig {i} = .N;
	else if neuro_arr_orig {i} = 8 then neuro_arr_orig {i} = .M;
	else;  
	if neuro_arr_orig {i} <= .Z then neuro_arr_new {i} = .;
	else neuro_arr_new {i} = 5 - neuro_arr_orig {i};
end;

if n (of SF6C SF6H SF6M SF6S) <= 1 then neuro_new = . ;
else neuro_new = mean(of SF6C SF6H SF6M SF6S);


*-----------------------------------------------------------------------*;
* OPENNESS  *;
*-----------------------------------------------------------------------*;
array open_arr_orig {*} RA1SF6N RA1SF6Q RA1SF6U RA1SF6V RA1SF6Y RA1SF6BB RA1SF6CC;
array open_arr_new {*} SF6N SF6Q SF6U SF6V SF6Y SF6BB SF6CC;

do i = 1 to dim(open_arr_orig);
		 if open_arr_orig {i} = 7 then open_arr_orig {i} = .N;
	else if open_arr_orig {i} = 8 then open_arr_orig {i} = .M;
	else;  
	if open_arr_orig {i} <= .Z then open_arr_new {i} = .;
	else open_arr_new {i} = 5 - open_arr_orig {i};
end;

if n (of SF6N SF6Q SF6U SF6V SF6Y SF6BB SF6CC) <= 3 then open_new = . ;
else open_new = mean(of SF6N SF6Q SF6U SF6V SF6Y SF6BB SF6CC);


KEEP 
MRID RA1PB3WK RA1PRAGE
agency 	agency_new   
agree 	agree_new   
cons 	cons_new   
extra 	extra_new   
neuro 	neuro_new   
open 	open_new; 
RUN;

title1 "Entire MIDUS Refresher Sample";
proc means data = PERSONALITY3; 
vars
agency 	agency_new   
agree 	agree_new   
cons 	cons_new   
extra 	extra_new   
neuro 	neuro_new   
open 	open_new;
run;
