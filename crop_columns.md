# Crop each column in a data frame based on values derived from each column

### Read the data

```r
data <- read.csv('~/Documents/dev/r/r_group/examples/64_Rn.csv', header = TRUE)
```

```r
nrow(data)
```
```r
## [1] 31
```

```r
ncol(data)
```
```r
## [1] 26
```

View a sample:

```r
data[c(1:3, 14, 26)]
```
```r
##    Cycles Repl..999..B_Low.A..FAM A1..5.32e.006..FAM B6..5.00e.000..FAM
## 1      15                 0.76952            0.76867            0.75901
## 2      16                 0.76904            0.77513            0.76421
## 3      17                 0.77155            0.77932            0.76216
## 4      18                 0.77098            0.80209            0.76443
## 5      19                 0.77350            0.83517            0.76639
## 6      20                 0.77313            0.89908            0.76163
## 7      21                 0.77373            0.99642            0.76110
## 8      22                 0.76819            1.08958            0.76658
## 9      23                 0.77271            1.18357            0.76354
## 10     24                 0.77547            1.25953            0.76582
## 11     25                 0.77356            1.33224            0.76037
## 12     26                 0.77430            1.39359            0.76180
## 13     27                 0.77674            1.46492            0.75948
## 14     28                 0.78107            1.50655            0.76785
## 15     29                 0.78631            1.56516            0.76369
## 16     30                 0.80173            1.60982            0.76572
## 17     31                 0.83198            1.64625            0.76327
## 18     32                 0.88461            1.67208            0.77024
## 19     33                 0.97273            1.70037            0.78749
## 20     34                 1.10207            1.71598            0.81231
## 21     35                 1.22321            1.74597            0.85513
## 22     36                 1.33459            1.76088            0.92996
## 23     37                 1.43002            1.77873            1.02466
## 24     38                 1.51682            1.79429            1.11642
## 25     39                 1.59161            1.79273            1.19971
## 26     40                 1.64270            1.83417            1.27650
## 27     41                 1.68379            1.84250            1.34554
## 28     42                 1.71989            1.84352            1.39007
## 29     43                 1.75417            1.85533            1.43467
## 30     44                 1.78271            1.85961            1.48085
## 31     45                 1.79987            1.86876            1.49716
##    H10..NTC_B..FAM
## 1          0.75567
## 2          0.75820
## 3          0.75763
## 4          0.76412
## 5          0.75523
## 6          0.76012
## 7          0.76231
## 8          0.75894
## 9          0.76492
## 10         0.76389
## 11         0.76195
## 12         0.76274
## 13         0.75958
## 14         0.76409
## 15         0.75689
## 16         0.75893
## 17         0.76187
## 18         0.75997
## 19         0.75945
## 20         0.76361
## 21         0.76831
## 22         0.76884
## 23         0.76314
## 24         0.76789
## 25         0.76770
## 26         0.76541
## 27         0.76611
## 28         0.76372
## 29         0.76583
## 30         0.76594
## 31         0.76245
```

### Derive values for lower and upper crop points

Use `lapply()` to generate quartiles for each column, except the first
column (`Cycles`). You could use any calculation -- quartiles are merely
for demonstration. The result will be structured as a list. Process the
quartiles list and return another list with only the 1st and 3rd
quartiles.

```r
cropPoints <- lapply(data[-1], function(x) {
  quantile(x) # replace with your preferred calculation
})

# We only need the 1st and 3rd quartiles. We can access these by the name attributes. This is not really necessary, but instructive.

cropPoints <- lapply(cropPoints, function(x) {
  x[c("25%", "75%")]
})

# view a sample
cropPoints[c(1:3, 14, 25)]
```
```r
## $Repl..999..B_Low.A..FAM
##     25%     75% 
## 0.77353 1.47342 
## 
## $A1..5.32e.006..FAM
##      25%      75% 
## 1.136575 1.785730 
## 
## $A2..5.32e.005..FAM
##      25%      75% 
## 0.890450 1.678885 
## 
## $C1..238_2..FAM
##     25%     75% 
## 0.76815 0.77315 
## 
## $H10..NTC_B..FAM
##      25%      75% 
## 0.759515 0.765165
```

### Crop each column

Process the original data, except the first column, and replace all
values less than the 1st quartile and greater than the 3rd quartile with
NA.

```r
cropped <- data

for (i in 1:length(cropped)) {
  try(cropped[i + 1][cropped[i + 1] < cropPoints[[i]][1]] <- NA, silent = FALSE)
  try(cropped[i + 1][cropped[i + 1] > cropPoints[[i]][2]] <- NA, silent = FALSE)
}

# view a sample
cropped[c(1:3, 14, 26)]
```
```r
##    Cycles Repl..999..B_Low.A..FAM A1..5.32e.006..FAM B6..5.00e.000..FAM
## 1      15                      NA                 NA                 NA
## 2      16                      NA                 NA            0.76421
## 3      17                      NA                 NA                 NA
## 4      18                      NA                 NA            0.76443
## 5      19                      NA                 NA            0.76639
## 6      20                      NA                 NA                 NA
## 7      21                 0.77373                 NA                 NA
## 8      22                      NA                 NA            0.76658
## 9      23                      NA            1.18357            0.76354
## 10     24                 0.77547            1.25953            0.76582
## 11     25                 0.77356            1.33224                 NA
## 12     26                 0.77430            1.39359                 NA
## 13     27                 0.77674            1.46492                 NA
## 14     28                 0.78107            1.50655            0.76785
## 15     29                 0.78631            1.56516            0.76369
## 16     30                 0.80173            1.60982            0.76572
## 17     31                 0.83198            1.64625                 NA
## 18     32                 0.88461            1.67208            0.77024
## 19     33                 0.97273            1.70037            0.78749
## 20     34                 1.10207            1.71598            0.81231
## 21     35                 1.22321            1.74597            0.85513
## 22     36                 1.33459            1.76088            0.92996
## 23     37                 1.43002            1.77873            1.02466
## 24     38                      NA                 NA                 NA
## 25     39                      NA                 NA                 NA
## 26     40                      NA                 NA                 NA
## 27     41                      NA                 NA                 NA
## 28     42                      NA                 NA                 NA
## 29     43                      NA                 NA                 NA
## 30     44                      NA                 NA                 NA
## 31     45                      NA                 NA                 NA
##    H10..NTC_B..FAM
## 1               NA
## 2               NA
## 3               NA
## 4          0.76412
## 5               NA
## 6          0.76012
## 7          0.76231
## 8               NA
## 9          0.76492
## 10         0.76389
## 11         0.76195
## 12         0.76274
## 13         0.75958
## 14         0.76409
## 15              NA
## 16              NA
## 17         0.76187
## 18         0.75997
## 19              NA
## 20         0.76361
## 21              NA
## 22              NA
## 23         0.76314
## 24              NA
## 25              NA
## 26              NA
## 27              NA
## 28         0.76372
## 29              NA
## 30              NA
## 31         0.76245
```