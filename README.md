# Predicting Daily Physical Activity in Older Adults

<br>

In this project I explored the effect of individual differences such as personality on older adults' daily engagement in physical activity. The data comes from ICPSR's [Midlife in the United States (MIDUS) Series](https://www.icpsr.umich.edu/web/ICPSR/series/203), a national longitudinal survey which contains a daily diary study. 

<br>

This SAS script for the random effects logistic regression model looking at whether or not someone engaged in physical activity is provided below. The full mixed effects model has faced some non-convergence issues.
- [bring in data MIDUS refresher.sas](https://github.com/stcampione/Physical-Activity-Personality/blob/main/bring%20in%20data%20MIDUS%20refresher.sas) 

<br>

I validated MIDUS's factors scoring by calculating my own scale scores and comapring:
- [Scale Scores MIDUS 1.sas](https://github.com/stcampione/Physical-Activity-Personality/blob/main/hand_calculate_scale_scores_M1%20(1).sas)
- [Scale Scores MIDUS Refresher.sas](https://github.com/stcampione/Physical-Activity-Personality/blob/main/Scale%20Scores%20MIDUS%20Refresher.sas)

<br>

I further checked for significant differences in the samples ([M1 MRef Comparison.R](https://github.com/stcampione/Physical-Activity-Personality/blob/main/M1%20MRef%20compare%20samples.R)).


# Abstract
"Physical inactivity in older adults is linked to negative health outcomes and an increased risk of premature death. Previous findings have evidenced personality as a correlate of physical activity. The purpose of the current study was to examine the relationship between personality and daily engagement in physical activity for older adults. Participants come from the Midlife in the United States (MIDUS), a national longitudinal study consisting of multiple waves of data collection across several decades. The sample studied here includes distinct samples of retired older adults from MIDUS 1 and the MIDUS Refresher studies. Participants of both studies completed a comprehensive telephone interview and self-administered questionnaires, followed by daily interviews for 8 consecutive days. Results did not indicate personality as a significant predictor of daily likeliness of engaging in physical activity. Results did show that Openness as a predictor of increased/decreased individual differences in daily likeliness of engaging in physical activity. The findings of this study implicate the importance and benefit of using daily diary methods to obtain more accurate and precise data and to explore unique aspects of behavior. Specifically, repeated measures allow for novel insight into the individual differences in variability of a behavior." 

<br>

Keywords: *older adults, personality, daily physical activity, random-effects model*

<br>

Blozis, S., & Campione, S. (In progress). Exercise and Personality in Older Adults: Using a Random-Effects Model to Predict Daily Physical Activity
