This Code book describes the variables, the data, and any transformations that performed to clean up the data and resulting `tidy_data.txt` file.
`dplyr` and `stringi` packages were used in this code and using its function to replace with the given replacement string every/first/last substring of the input that matches the specified pattern.

## Identifiers

- subject - The ID of the test subject
- activity - The type of activity performed when the corresponding measurements were taken
  - WALKING            : Subject was walking during the test
  - WALKING_UPSTAIRS   : Subject was walking upstairs during the test
  - WALKING_DOWNSTAIRS : Subject was walking dowstairs during the test
  - SITTING            : Subject was sitting during the test
  - STANDING           : Subject was standing during the test
  - LAYING             : Subject was laying down during the test

## Measurement
These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

- tBodyAcc-XYZ
- tGravityAcc-XYZ
- tBodyAccJerk-XYZ
- tBodyGyro-XYZ
- tBodyGyroJerk-XYZ
- tBodyAccMag
- tGravityAccMag
- tBodyAccJerkMag
- tBodyGyroMag
- tBodyGyroJerkMag
- fBodyAcc-XYZ
- fBodyAccJerk-XYZ
- fBodyGyro-XYZ
- fBodyAccMag
- fBodyAccJerkMag
- fBodyGyroMag
- fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

- mean()        : Mean value
- std()         : Standard deviation
- mad()         : Median absolute deviation 
- max()         : Largest value in array
- min()         : Smallest value in array
- sma()         : Signal magnitude area
- energy()      : Energy measure. Sum of the squares divided by the number of values. 
- iqr()         : Interquartile range 
- entropy()     : Signal entropy
- arCoeff()     : Autorregresion coefficients with Burg order equal to 4
- correlation() : correlation coefficient between two signals
- maxInds()     : index of the frequency component with largest magnitude
- meanFreq()    : Weighted average of the frequency components to obtain a mean frequency
- skewness()    : skewness of the frequency domain signal 
- kurtosis()    : kurtosis of the frequency domain signal 
- bandsEnergy() : Energy of a frequency interval within the 64 bins of the FFT of each window.
- angle()       : Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

- gravityMean
- tBodyAccMean
- tBodyAccJerkMean
- tBodyGyroMean
- tBodyGyroJerkMean

All measurements are normalized and bounded within [-1,1].

## Transformations
The data of the project (.zip file) is located at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

The following transformations are applied to the data sets and implemented in `run_analysis.R` R script
1. Training and test data sets were merged them to create full data set and assigned to "TidyData".
2. Mean and standard deviation measurements were extracted from each measurements and the others were discarded using `grepl` function
3. Name of activities in data set which is integers between 1 and 6 were replaced with descriptive activity names (Walking, Walking upstairs, walking downstairs, sitting, standing, and laying)
4. The variables name in data set were replaced with descriptive variable names
  - special characters are removed
  - Initial t and f were expanded to timeDomain and frequencyDomain
  - Acc, Gyro, Mag, Freq, mean, std, and BodyBody were replaced with Accelerometer, Gyroscope, Magnitude, Frequency, Mean, StandardDeviation, and Body respectively. (using `stri_replace_all_regex` function in `stringi` package
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
6. `tidy_data.txt` were created based on the result of step 5
