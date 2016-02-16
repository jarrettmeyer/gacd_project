# Code Book

## all_data

```
subject:    Subject identifier. 30 levels. 1-30.

type:       Type of data collected on subject. 2 levels. "test" or "train".

activity:   Type of activity performed by subject. 6 levels. "LAYING", "SITTING",
            "STANDING", "WALKING", "WALKING_DOWNSTAIRS", "WALKING_UPSTAIRS".

columns 4-51:   Mean and standard deviation data for various sensor inputs. Data
                is collected on x, y, and z axes for all data points.
```

## summary_data

The `summary_data` computes the mean by subject and activity for the data collected as part of `all_data`.

```
subject:    Subject identifier. 30 levels. 1-30.

type:       Type of data collected on subject. 2 levels. "test" or "train".

activity:   Type of activity performed by subject. 6 levels. "LAYING", "SITTING",
            "STANDING", "WALKING", "WALKING_DOWNSTAIRS", "WALKING_UPSTAIRS".

columns 4-51:   Computes the mean of the mean and standard deviation data for
                various sensor inputs. Data is collected on x, y, and z axes for
                all data points.
```
