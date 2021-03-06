# Create a new, coded variable based on another variable

Data are `EssayMarks.dat` from [http://studysites.sagepub.com/dsur/study/articles.htm](http://studysites.sagepub.com/dsur/study/articles.htm).

Import and view data.

```r
data <- read.delim("~/Documents/dev/data_samples/tables/EssayMarks.dat")

head(data)
```

```
     essay     hours              grade
1 61.67550 10.630337 Upper Second Class
2 69.54501  7.285226        First Class
3 48.22930  5.052048        Third Class
4 70.67865  2.886614        First Class
5 59.89962  9.545012 Lower Second Class
6 61.16202 11.310838 Upper Second Class
```

The goal is to create a coded variable with values 1, 2, 3, or 4 for each factor level in `data$grade`. The desired mapping is:

string | code
-------|-----
First Class | 1
Upper Second Class | 2
Lower Second Class | 3
Third Class | 4

#### Using `ifelse()`


```r
data$gradeCode <- ifelse(data$grade == "First Class", 1, ifelse(data$grade == "Upper Second Class", 2, ifelse(data$grade == "Lower Second Class", 3, 4)))

head(data)
```

```
     essay     hours              grade gradeCode
1 61.67550 10.630337 Upper Second Class         2
2 69.54501  7.285226        First Class         1
3 48.22930  5.052048        Third Class         4
4 70.67865  2.886614        First Class         1
5 59.89962  9.545012 Lower Second Class         3
6 61.16202 11.310838 Upper Second Class         2
```

#### Using `match()` with a dictionary

Build a dictionary that maps the `data$grade` values to the new codes.


```r
dict <- data.frame(grade = c("First Class", "Upper Second Class", "Lower Second Class", "Third Class"), gradeCode = c(1, 2, 3, 4))

dict
```

```
               grade gradeCode
1        First Class         1
2 Upper Second Class         2
3 Lower Second Class         3
4        Third Class         4
```

Where each value in `data$grade` has a match in `dict$grade`, assign the value of `dict$gradeCode` to a new variable in `data`.


```r
data$gradeCode <- dict$gradeCode[match(data$grade, dict$grade)]

head(data)
```

```
     essay     hours              grade gradeCode
1 61.67550 10.630337 Upper Second Class         2
2 69.54501  7.285226        First Class         1
3 48.22930  5.052048        Third Class         4
4 70.67865  2.886614        First Class         1
5 59.89962  9.545012 Lower Second Class         3
6 61.16202 11.310838 Upper Second Class         2
```


