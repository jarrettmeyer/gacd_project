# Remove all variables
rm(list = ls())

# Load necessary packages.
library(dplyr)
library(reshape)

# Always build platform-independent paths.
data_folder <- file.path(".", "UCI HAR Dataset")

# Get the activity labels. Set the column names.
activity_labels <- read.table(file.path(data_folder, "activity_labels.txt"), header = FALSE, stringsAsFactors = FALSE)
activity_labels <- tbl_df(activity_labels)
colnames(activity_labels) <- c("id", "activity")

# Get the feature labels. Set the column names. Remove ugly characters from the
# values. The feature_label values are not unique, so we are going to combine the
# id and the feature_label to make a unique column.
feature_labels <- read.table(file.path(data_folder, "features.txt"), header = FALSE, stringsAsFactors = FALSE)
feature_labels <- tbl_df(feature_labels)
colnames(feature_labels) <- c("id", "feature_label")
feature_labels <- feature_labels %>%
    mutate(unique_label = paste0(id, "_", feature_label)) %>%
    mutate(unique_label = gsub("\\(|\\)", "", unique_label)) %>%
    mutate(unique_label = gsub("\\-|\\,", "_", unique_label)) %>%
    mutate(unique_label = tolower(unique_label))


# Get all data for the given type ("test" or "train"), searching in the given
# folder. This will include the subjects, activities, and sensor values, all
# joined together into a single data set.
get_data <- function (root_path, type) {
    folder_path <- file.path(root_path, type)

    # Get the subjects for type.
    subjects <- get_table_data(folder_path, "subject_", type)
    colnames(subjects) <- c("subject")
    subjects <- tbl_df(subjects) %>% mutate(type = as.factor(type))

    # Get the activities for type.
    y <- get_table_data(folder_path, "y_", type)
    colnames(y) <- c("activity_id")
    y <- inner_join(y, activity_labels, by = c("activity_id" = "id"))

    # Get the values for type.
    x <- get_table_data(folder_path, "X_", type)
    colnames(x) <- feature_labels$unique_label

    # Put the subjects, activities, and values together.
    dat <- cbind(subjects, y, x) %>%
        mutate(subject = as.factor(subject)) %>%
        mutate(activity_id = as.factor(activity_id)) %>%
        mutate(activity = as.factor(activity))

    return(dat)
}


# Get path to file. Fortunately, a common naming convention, file type, and
# layout is used.
get_file_path <- function (folder, prefix, type, ext = ".txt") {
    file_name <- paste0(prefix, type, ext)
    path <- file.path(folder, file_name)
    return(path)
}


# Get table data. This function will construct the path to the file, read the
# data as a table, and return the data set.
get_table_data <- function (folder, prefix, type, ext = ".txt") {
    file_path <- get_file_path(folder, prefix, type, ext)
    tbl <- read.table(file_path, header = FALSE, stringsAsFactors = FALSE)
    tbl <- tbl_df(tbl)
    return(tbl)
}


# Save output. This is required by the assignment.
save_output <- function (dat, path) {
    write.table(dat, path, row.name = FALSE)
}

test_data <- get_data(data_folder, "test")
train_data <- get_data(data_folder, "train")

# Create a data set holding all of our data. As instructed in the assignment, we
# are only keeping mean and std data points.
all_data <- rbind(test_data, train_data) %>%
    select(subject, type, activity, contains("_mean_"), contains("_std_"))

# Collect the summary data. Take the mean of each column.
summary_data <- all_data %>%
    group_by(subject, type, activity) %>%
    arrange(subject, type, activity) %>%
    summarize_each(funs(mean))

# Save the summary output. This is required by the assignment.
save_output(summary_data, "upload.txt")

# Clean up all remaining extra variables.
rm("activity_labels", "data_folder", "feature_labels", "save_output",
    "test_data", "train_data")
