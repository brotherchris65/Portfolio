use diabetes;

select * from pima

/*Check for null values and get a count for each column*/

select sum(case when Pregnancies is null then 1 else 0 end) as Preg, 
sum(case when Glucose is null then 1 else 0 end) as Gluc,
sum(case when BloodPressure is null then 1 else 0 end) as BP,
sum(case when SkinThickness is null then 1 else 0 end) as Skin,
sum(case when Insulin is null then 1 else 0 end) as Ins,
sum(case when BMI is null then 1 else 0 end) as BMI,
sum(case when DiabetesPedigreeFunction is null then 1 else 0 end) as Pedigree,
sum(case when Age is null then 1 else 0 end) as Age,
sum(case when Outcome is null then 1 else 0 end) as Outcome from pima; 

-- Look at values to see if they make sense
select count(Pregnancies) as P_count from pima
where Pregnancies >10;

select max(Pregnancies) from pima;
select avg(Pregnancies) from pima;

-- look for unreasonable Glucose numbers
select count(Glucose) as low_Gluc from pima
where Glucose < 50;

select Glucose from pima
where Glucose < 50;

select avg(Glucose) from pima
where Glucose>=50;
-- The average of Glucose readings above 50 is 121.79

set @row := 0;
select avg(r.Glucose) as Median from
(select Glucose, @row:=@row+1 as row_index
from pima
where pima.Glucose >=44
order by pima.Glucose
) as r
where r.row_index in (floor(@row/2), ceil(@row/2))
-- Replace Glucose readings of 0 with 117 which is both avg and median of readings 50 and higher
update pima
set Glucose = 117
where Glucose = 0

-- check to ensure data is updated
select Glucose from pima
where Glucose <50
-- we will leave the 44 that is the one remaining value below 50

/* The BloodPressure column represents diastolic BP where 60-90 is a normal safe range */

select max(BloodPressure) from pima -- 122

select min(BloodPressure) from pima -- 0 for now

select avg(BloodPressure) from pima -- 69

select BloodPressure from pima
where BloodPressure <50

select avg(BloodPressure) from pima
where BloodPressure>0  -- average blood pressure not counting zeros is 72

SET @rowindex := -1;
 
SELECT
   AVG(g.BloodPressure) as Median
FROM
   (SELECT @rowindex:=@rowindex + 1 AS rowindex,
           BloodPressure 
    FROM pima
    WHERE pima.BloodPressure != 0
    ORDER BY BloodPressure) AS g
WHERE g.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));
-- The median is 72 so we will replace 0 with 72

update pima
set BloodPressure = 72
where BloodPressure = 0
-- let's check to make sure

select Glucose from pima
where Glucose = 0 --All zeroes have been replaced

select SkinThickness from pima
select avg(SkinThickness) from pima -- 20.5 is average
select max(SkinThickness) from pima -- 99 is the max
select min(SkinThickness) from pima -- 0 which is not possible
select count(SkinThickness) from pima
where SkinThickness = 0 -- 227 records with no skin thickness

select avg(SkinThickness) from pima
where  SkinThickness != 0

select count(SkinThickness) from pima
where SkinThickness > 29 -- 265

select count(SkinThickness) from pima
where SkinThickness between 1 and 29 -- 276 records

/* Since there are so many records with zeroes, I would need to determine how useful this column would be
only 22% of type II diabetics have skin thickening. This might not be a column to use. I would check with
supervisor and/or specialist to determine how to handle the zeroes */

select Insulin from pima
select count(Insulin) from pima
where Insulin = 0
/* Nearly half the records show a 2-hour serum insulin of 0. Again, this is something I would have to check to see how this data might be used.
if this data is to be used for machine learing (AI) to predict developing diabetes, we would have to probably convert the data to categorical
and then OneHotEncode the categories into their own columns and mark each as true or False.

This would not be a good column for visualization without some guidance as to how to handle the zeroes

This dataset is beginning to look incomplete now that two columns have a significant number of zeroes */

select BMI from pima

select count(BMI) from pima
where BMI = 0

select round(avg(BMI), 2) as Average_BMI from pima 
select count(BMI) from pima
where BMI between 1 and 32.3 -- 380 records

select count(BMI) from pima
where BMI > 32.3 -- 377 records

-- Replace 0 with 32.3 the median

update pima
set BMI = 32.3
where BMI = 0

/* The DiabetesPedigreeFunction is a predictor of diabetes based on family history and a range of values already calculated
I will not change any of this data as it is all valid data */

select DiabetesPedigreeFunction from pima

select max(DiabetesPedigreeFunction) from pima

select min(DiabetesPedigreeFunction) from pima

-- A look at age for this dataset. According to originator of data this is all female 21 and older

select avg(Age) from pima -- 33.24
select min(Age) from pima -- 21 just as the description said
select max(Age) from pima -- 81
