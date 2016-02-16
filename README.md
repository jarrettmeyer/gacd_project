# Getting and Cleaning Data - Course Project

To run the script, source the script from R.

> source("run_analysis.R")

Two result sets will be returned. The `all_data` result set contains the merged train and test data. The `summary_data` set contains the means of all `mean()` and `std()` columns, grouped by subject and activity.

To view either data set, use the `View()` function with the appropriate data set.

> View(all_data)
> View(summary_data)
