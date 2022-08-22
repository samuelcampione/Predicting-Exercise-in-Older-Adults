# Analysis of descriptive statistics of M1 and MRef samples
# MIDUS 1
# Read ICPSR files for m1 and m1 NSDE
# Select variables of interest (in .xclx file "Variables of Interest")
# Merge data from m1 and nsde
# Subset for retired individuals
# Find descriptive stats
# Repeat for MIDUS Refresher
# Perform chi-squared and ind samples t-tests on them

options(scipen = 999)
install.packages("tidyverse")
install.packages("psych")
install.packages("vtable")
library(tidyverse)
library(psych)
library(vtable)


# MIDUS 1

load("./data/ICPSR_02760/DS0001/02760-0001-Data.rda")
da02760.0001 <-
  da02760.0001 %>%
  select(
    c(
      "M2ID",
      "A1SS6_1",
      "A1PRSEX",
      "A1PB1",
      "A1PAGE_M2",
      "A1PB3E",
      "A1SBADL",
      "A1SAGENC",
      "A1SAGREE",
      "A1SCONS",
      "A1SEXTRA",
      "A1SNEURO",
      "A1SOPEN"
    )
  )

m1 <- da02760.0001 %>%
  filter(A1PB3E == "(1) Yes")


load("./data/ICPSR_03725/DS0001/03725-0001-Data.rda")

nsde <- da03725.0001 %>%
  select(c("M2ID", "A2DIMON"))


m1full <- merge(m1, nsde, by = "M2ID")
m1full <- m1full %>%
  select(
    c(
      "M2ID",
      "A1SS6_1",
      "A1PRSEX",
      "A1PB1",
      "A1PAGE_M2",
      "A1SBADL",
      "A1SAGENC",
      "A1SAGREE",
      "A1SCONS",
      "A1SEXTRA",
      "A1SNEURO",
      "A1SOPEN",
      "A2DIMON"
    )
  )

m1full <- m1full %>%
  filter(!duplicated(m1full))

m1sample <- m1full %>%
  filter(A1PAGE_M2 >= 50) %>%
  drop_na(M2ID) %>%
  mutate(A1PRSEX = as.numeric(A1PRSEX),
         Female = ifelse(A1PRSEX == 2, 1, 0)) %>%  # Sex
  mutate(A1SS6_1 = as.numeric(A1SS6_1),
         notWhite = ifelse(m1sample$A1SS6_1 == 2, 1, 0)) %>%  # Race
  mutate(A1PB1 = as.numeric(m1sample$A1PB1),
         noGEDHS = ifelse(m1sample$A1PB1 <= 3, 1, 0)) %>%  # No GED
  mutate(winter =
           ifelse(A2DIMON == 1 |
                    A2DIMON == 2 |
                    A2DIMON == 3,
                  1,
                  0)) %>%
  mutate(spring =               # Seasons
           ifelse(A2DIMON == 4 |
                    A2DIMON == 5 |
                    A2DIMON == 6,
                  1,
                  0)) %>%
  mutate(summer =
           ifelse(A2DIMON == 7 |
                    A2DIMON == 8 |
                    A2DIMON == 9,
                  1,
                  0)) %>%
  mutate(fall =
           ifelse(A2DIMON == 10 |
                    A2DIMON == 11 |
                    A2DIMON == 12,
                  1,
                  0))


m1sample <- m1sample %>%
  select(
    c(
      "M2ID",
      "A1PAGE_M2",
      "A1SBADL",
      "A1SAGENC",
      "A1SAGREE",
      "A1SCONS",
      "A1SEXTRA",
      "A1SNEURO",
      "A1SOPEN",
      "Female",
      "notWhite",
      "noGEDHS",
      "winter",
      "spring",
      "summer",
      "fall"
    )
  )


sumtable(m1sample) %>%
  kable()



# MIDUS Refresher

load("./data/ICPSR_36532/DS0001/36532-0001-Data.rda")

da36532.0001 <- da36532.0001 %>%
  select(
    c(
      "MRID",
      "RA1PRSEX",
      "RA1PB1",
      "RA1PF7A",
      "RA1PRAGE",
      "RA1PB3WK",
      "RA1SBADL2",
      "RA1SAGENC",
      "RA1SAGREE",
      "RA1SCONS2",
      "RA1SEXTRA",
      "RA1SNEURO",
      "RA1SOPEN"
    )
  )

mref <- da36532.0001 %>%
  filter(RA1PB3WK == "(05) RETIRED")


load("./data/ICPSR_37083/DS0001/37083-0001-Data.rda")

diaryproject <- da37083.0001 %>%
  select(c("MRID", "RA2DIMON"))

mref <- merge(mref, diaryproject, by = "MRID")

mref <- mref %>%
  select(
    c(
      "MRID",
      "RA1PRSEX",
      "RA1PB1",
      "RA1PF7A",
      "RA1PRAGE",
      "RA1SBADL2",
      "RA1SAGENC",
      "RA1SAGREE",
      "RA1SCONS2",
      "RA1SEXTRA",
      "RA1SNEURO",
      "RA1SOPEN",
      "RA2DIMON"
    )
  )

mref <- mref %>%
  filter(!duplicated(mref))

mrefsam <- mref %>%
  filter(RA1PRAGE >= 50) %>%
  drop_na(MRID)

mrefsam <- mrefsam %>%
  mutate(RA1PRSEX = as.numeric(RA1PRSEX),
         Female = ifelse(RA1PRSEX == 2, 1, 0)) %>%
  mutate(RA1PF7A = as.numeric(RA1PF7A),
         notWhite = ifelse(RA1PF7A != 1, 1, 0)) %>%
  mutate(RA1PB1 = as.numeric(RA1PB1),
         noGEDHS = ifelse(RA1PB1 <= 3, 1, 0)) %>%
  mutate(
    RA2DIMON = as.numeric(RA2DIMON),
    winter =
      ifelse(RA2DIMON == 1 |
               RA2DIMON == 2 |
               RA2DIMON == 3,
             1,
             0),
    spring =
      ifelse(RA2DIMON == 4 |
               RA2DIMON == 5 |
               RA2DIMON == 6,
             1,
             0),
    summer =
      ifelse(RA2DIMON == 7 |
               RA2DIMON == 8 |
               RA2DIMON == 9,
             1,
             0),
    fall =
      ifelse(RA2DIMON == 10 |
               RA2DIMON == 11 |
               RA2DIMON == 12,
             1,
             0)
  )

mrefsam <-
  mrefsam %>%
  select(
    c(
      "MRID",
      "RA1PRAGE",
      "RA1SBADL2",
      "RA1SAGENC",
      "RA1SAGREE",
      "RA1SCONS2",
      "RA1SEXTRA",
      "RA1SNEURO",
      "RA1SOPEN",
      "Female",
      "notWhite",
      "noGEDHS",
      "winter",
      "spring",
      "summer",
      "fall"
    )
  )

sumtable(mrefsam)


## Testing M1sample and MRefsample t test
tests <- list()
tests[["age"]] = t.test(m1sample$A1PAGE_M2, mrefsam$RA1PRAGE)
tests[["adl"]] = t.test(m1sample$A1SBADL, mrefsam$RA1SBADL2)
tests[["Female"]] = t.test(m1sample$Female, mrefsam$Female)
tests[["notWhite"]] = t.test(m1sample$notWhite, mrefsam$notWhite)
tests[["noGEDHS"]] = t.test(m1sample$noGEDHS, mrefsam$noGEDHS)
tests[["winter"]] = t.test(m1sample$winter, mrefsam$winter)
tests[["spring"]] = t.test(m1sample$spring, mrefsam$spring)
tests[["summer"]] = t.test(m1sample$summer, mrefsam$summer)
tests[["fall"]] = t.test(m1sample$fall, mrefsam$fall)
tests[["agency"]] = t.test(m1sample$A1SAGENC, mrefsam$RA1SAGENC)
tests[["agree"]] = t.test(m1sample$A1SAGREE, mrefsam$RA1SAGREE)
tests[["consc"]] = t.test(m1sample$A1SCONS, mrefsam$RA1SCONS2)
tests[["extra"]] = t.test(m1sample$A1SEXTRA, mrefsam$RA1SEXTRA)
tests[["neuro"]] = t.test(m1sample$A1SNEURO, mrefsam$RA1SNEURO)
tests[["open"]] = t.test(m1sample$A1SOPEN, mrefsam$RA1SOPEN)


tab <- t(sapply(tests, function(x) {
  c(
    x$statistic["t"],
    x$parameter["df"],
    ci.lower = x$conf.int[1],
    ci.upper = x$conf.int[2],
    p.value = x$p.value
  )
})) %>%
  round(digits = 3)

kable(tab, caption = "T Test results: MIDUS 1 sample and MIDUS Refresher sample") %>%
  kable_classic_2(lightable_options = "striped", html_font = "arial") %>%
  row_spec(0, bold = TRUE) %>%
  column_spec(1, bold = TRUE)

