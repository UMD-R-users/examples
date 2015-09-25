# Crop each column in a data frame based on values derived from the column itself

### Read the data

```r
data <- read.csv('~/Documents/dev/r/r_group/examples/64_Rn.csv', header = TRUE)
```

```r
nrow(data)
```
```r
[1] 31
```

```r
ncol(data)
```
```r
[1] 26
```

View a sample:

```r
data[c(1:3, 14, 26)]
```
```r
   Cycles Repl..999..B_Low.A..FAM A1..5.32e.006..FAM B6..5.00e.000..FAM H10..NTC_B..FAM
1      15                 0.76952            0.76867            0.75901         0.75567
2      16                 0.76904            0.77513            0.76421         0.75820
3      17                 0.77155            0.77932            0.76216         0.75763
4      18                 0.77098            0.80209            0.76443         0.76412
5      19                 0.77350            0.83517            0.76639         0.75523
6      20                 0.77313            0.89908            0.76163         0.76012
7      21                 0.77373            0.99642            0.76110         0.76231
8      22                 0.76819            1.08958            0.76658         0.75894
9      23                 0.77271            1.18357            0.76354         0.76492
10     24                 0.77547            1.25953            0.76582         0.76389
11     25                 0.77356            1.33224            0.76037         0.76195
12     26                 0.77430            1.39359            0.76180         0.76274
13     27                 0.77674            1.46492            0.75948         0.75958
14     28                 0.78107            1.50655            0.76785         0.76409
15     29                 0.78631            1.56516            0.76369         0.75689
16     30                 0.80173            1.60982            0.76572         0.75893
17     31                 0.83198            1.64625            0.76327         0.76187
18     32                 0.88461            1.67208            0.77024         0.75997
19     33                 0.97273            1.70037            0.78749         0.75945
20     34                 1.10207            1.71598            0.81231         0.76361
21     35                 1.22321            1.74597            0.85513         0.76831
22     36                 1.33459            1.76088            0.92996         0.76884
23     37                 1.43002            1.77873            1.02466         0.76314
24     38                 1.51682            1.79429            1.11642         0.76789
25     39                 1.59161            1.79273            1.19971         0.76770
26     40                 1.64270            1.83417            1.27650         0.76541
27     41                 1.68379            1.84250            1.34554         0.76611
28     42                 1.71989            1.84352            1.39007         0.76372
29     43                 1.75417            1.85533            1.43467         0.76583
30     44                 1.78271            1.85961            1.48085         0.76594
31     45                 1.79987            1.86876            1.49716         0.76245
```

### Derive values for lower and upper crop points

Use `lapply()` to generate quartiles for each column, except the first column (`Cycles`). You could use any calculation -- quartiles are used for demonstration. The result will be structured as a list. Process the quartiles list and return another list with only the 1st and 3rd quartiles.

```r
cropPoints <- lapply(data[-1], function(x) {
  quantile(x) # replace with your preferred calculation
})

# We only need the 1st and 3rd quartiles. We can access these by the name attributes.
# (This is not really necessary, but instructive.)
cropPoints <- lapply(cropPoints, function(x) {
  x[c("25%", "75%")]
})

# view a sample
cropPoints[c(1:3, 14, 25)]
```
```r
$Repl..999..B_Low.A..FAM
    25%     75% 
0.77353 1.47342 

$A1..5.32e.006..FAM
     25%      75% 
1.136575 1.785730 

$A2..5.32e.005..FAM
     25%      75% 
0.890450 1.678885 

$C1..238_2..FAM
    25%     75% 
0.76815 0.77315 

$H10..NTC_B..FAM
     25%      75% 
0.759515 0.765165
```

### Crop each column

Process the original data, except the first column, and replace all values less than the 1st quartile and greater than the 3rd quartile with NA.

The `cropPoints` list is shorter than the original data frame by 1 element (the code for `cropPoints` excludes the 1st column from the original data frame), so each iteration through the original data requires subsetting into different indices simultaneously. For example, `cropped[2]` and `cropPoints[1]`. Hence the `length(cropped[-1])` and `cropped[i + 1]` trickery for modifying the correct column. 

```r
cropped <- data

for (i in 1:length(cropped[-1])) {
  cropped[i + 1][cropped[i + 1] < cropPoints[[i]][1]] <- NA
  cropped[i + 1][cropped[i + 1] > cropPoints[[i]][2]] <- NA
}

# view a sample
cropped[c(1:3, 14, 26)]
```
```r
   Cycles Repl..999..B_Low.A..FAM A1..5.32e.006..FAM B6..5.00e.000..FAM H10..NTC_B..FAM
1      15                      NA                 NA                 NA              NA
2      16                      NA                 NA            0.76421              NA
3      17                      NA                 NA                 NA              NA
4      18                      NA                 NA            0.76443         0.76412
5      19                      NA                 NA            0.76639              NA
6      20                      NA                 NA                 NA         0.76012
7      21                 0.77373                 NA                 NA         0.76231
8      22                      NA                 NA            0.76658              NA
9      23                      NA            1.18357            0.76354         0.76492
10     24                 0.77547            1.25953            0.76582         0.76389
11     25                 0.77356            1.33224                 NA         0.76195
12     26                 0.77430            1.39359                 NA         0.76274
13     27                 0.77674            1.46492                 NA         0.75958
14     28                 0.78107            1.50655            0.76785         0.76409
15     29                 0.78631            1.56516            0.76369              NA
16     30                 0.80173            1.60982            0.76572              NA
17     31                 0.83198            1.64625                 NA         0.76187
18     32                 0.88461            1.67208            0.77024         0.75997
19     33                 0.97273            1.70037            0.78749              NA
20     34                 1.10207            1.71598            0.81231         0.76361
21     35                 1.22321            1.74597            0.85513              NA
22     36                 1.33459            1.76088            0.92996              NA
23     37                 1.43002            1.77873            1.02466         0.76314
24     38                      NA                 NA                 NA              NA
25     39                      NA                 NA                 NA              NA
26     40                      NA                 NA                 NA              NA
27     41                      NA                 NA                 NA              NA
28     42                      NA                 NA                 NA         0.76372
29     43                      NA                 NA                 NA              NA
30     44                      NA                 NA                 NA              NA
31     45                      NA                 NA                 NA         0.76245
```