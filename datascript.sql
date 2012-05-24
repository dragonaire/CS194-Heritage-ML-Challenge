
/**************************************************************
* SQL Code to create an example data set for the HHP
*
* Edit the path in the 'bulk insert' commands to locate
* the source data
* The end result is a table called 'modelling_set' which can 
* then be used to build predictive models
* 
* created in SQL server express
* http://www.microsoft.com/sqlserver/en/us/editions/express.aspx
*****************************************************************/




/**************************
create a new database
**************************/
CREATE DATABASE HHP_comp
GO
USE HHP_comp




/**************************
load in the raw data
**************************/


--claims
CREATE TABLE Claims
(
MemberID VARCHAR(8) --integers starting with 0, could be text!
, ProviderID VARCHAR(7) --integers starting with 0, could be text!
, Vendor VARCHAR(6) --integers starting with 0, could be text!
, PCP VARCHAR(5) --integers starting with 0, could be text!
, Year VARCHAR(2)
, Specialty VARCHAR(25)
, PlaceSvc VARCHAR(19)
, PayDelay VARCHAR(4)
, LengthOfStay VARCHAR(10)
, DSFS VARCHAR(12)
, PrimaryConditionGroup VARCHAR(8)
, CharlsonIndex VARCHAR(3)
, ProcedureGroup VARCHAR(4)
, SupLOS TINYINT
)


BULK INSERT Claims
FROM 'C:\Users\hong\Documents\Yang\Stanford 2011-2012\Spring 1112\CS194\Data\HHP_release3\Claims.csv'
WITH
(
MAXERRORS = 0,
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)




--members
CREATE TABLE Members
(
MemberID_M VARCHAR(8) --integers starting with 0, could be text!
, AgeAtFirstClaim VARCHAR(5)
, Sex VARCHAR(1)
)


BULK INSERT Members
FROM 'C:\Users\hong\Documents\Yang\Stanford 2011-2012\Spring 1112\CS194\Data\HHP_release3\Members.csv'
WITH
(
MAXERRORS = 0,
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)




-- drug count
CREATE TABLE DrugCount
(
MemberID INT
, Year VARCHAR(2)
, DSFS VARCHAR(12)
, DrugCount VARCHAR(2)
)


BULK INSERT DrugCount
FROM 'C:\Users\hong\Documents\Yang\Stanford 2011-2012\Spring 1112\CS194\Data\HHP_release3\DrugCount.csv'
WITH
(
MAXERRORS = 0,
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)




-- Lab Count
CREATE TABLE LabCount
(
MemberID INT
, Year VARCHAR(2)
, DSFS VARCHAR(12)
, LabCount VARCHAR(3)
)




BULK INSERT LabCount
FROM 'C:\Users\hong\Documents\Yang\Stanford 2011-2012\Spring 1112\CS194\Data\HHP_release3\LabCount.csv'
WITH
(
MAXERRORS = 0,
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)




--DaysInHospital_Y2
CREATE TABLE DaysInHospital_Y2
(
MemberID INT
, ClaimsTruncated TINYINT
, DaysInHospital TINYINT
)




BULK INSERT DaysInHospital_Y2
FROM 'C:\Users\hong\Documents\Yang\Stanford 2011-2012\Spring 1112\CS194\Data\HHP_release3\DaysInHospital_Y2.csv'
WITH
(
MAXERRORS = 0,
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)




-- DaysInHospital_Y3 
CREATE TABLE DaysInHospital_Y3
(
MemberID INT
, ClaimsTruncated TINYINT
, DaysInHospital TINYINT
)




BULK INSERT DaysInHospital_Y3
FROM 'C:\Users\hong\Documents\Yang\Stanford 2011-2012\Spring 1112\CS194\Data\HHP_release3\DaysInHospital_Y3.csv'
WITH
(
MAXERRORS = 0,
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)




-- Target
CREATE TABLE Target
(
MemberID INT
, ClaimsTruncated TINYINT
, DaysInHospital TINYINT
)




BULK INSERT Target
FROM 'C:\Users\hong\Documents\Yang\Stanford 2011-2012\Spring 1112\CS194\Data\HHP_release3\Target.csv'
WITH
(
MAXERRORS = 0,
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)






/*************************
adjust the claims data to
convert text to integers
**************************/




-- PayDelay
ALTER TABLE Claims 
ADD PayDelayI integer
GO


UPDATE Claims
SET PayDelayI = CASE WHEN PayDelay = '162+' THEN 162 ELSE CAST(PayDelay AS integer) END




--dsfs
ALTER TABLE Claims 
ADD dsfsI integer
GO


UPDATE Claims
SET dsfsI =
CASE
WHEN dsfs = '0- 1 month' THEN 1
WHEN dsfs = '1- 2 months' THEN 2
WHEN dsfs = '2- 3 months' THEN 3
WHEN dsfs = '3- 4 months' THEN 4
WHEN dsfs = '4- 5 months' THEN 5
WHEN dsfs = '5- 6 months' THEN 6
WHEN dsfs = '6- 7 months' THEN 7
WHEN dsfs = '7- 8 months' THEN 8
WHEN dsfs = '8- 9 months' THEN 9
WHEN dsfs = '9-10 months' THEN 10
WHEN dsfs = '10-11 months' THEN 11
WHEN dsfs = '11-12 months' THEN 12
WHEN dsfs IS NULL THEN NULL
END




-- CharlsonIndex
ALTER TABLE Claims 
ADD CharlsonIndexI INTEGER
GO


UPDATE Claims
SET CharlsonIndexI =
CASE
WHEN CharlsonIndex = '0' THEN 0 
WHEN CharlsonIndex = '1-2' THEN 2
WHEN CharlsonIndex = '3-4' THEN 4
WHEN CharlsonIndex = '5+' THEN 6 
END




-- LengthOfStay
ALTER TABLE Claims 
ADD LengthOfStayI INTEGER
GO


UPDATE Claims
SET LengthOfStayI =
CASE
WHEN LengthOfStay = '1 day' THEN 1
WHEN LengthOfStay = '2 days' THEN 2
WHEN LengthOfStay = '3 days' THEN 3
WHEN LengthOfStay = '4 days' THEN 4
WHEN LengthOfStay = '5 days' THEN 5
WHEN LengthOfStay = '6 days' THEN 6 
WHEN LengthOfStay = '1- 2 weeks' THEN 11
WHEN LengthOfStay = '2- 4 weeks' THEN 21
WHEN LengthOfStay = '4- 8 weeks' THEN 42
WHEN LengthOfStay = '26+ weeks' THEN 180
WHEN LengthOfStay IS NULL THEN null
END




/**************************
create a summary table 
at the member/year level
***************************/
SELECT 
year
,Memberid


,COUNT(*) AS no_Claims
,COUNT(DISTINCT ProviderID) AS no_Providers
,COUNT(DISTINCT Vendor) AS no_Vendors
,COUNT(DISTINCT PCP) AS no_PCPs
,COUNT(DISTINCT PlaceSvc) AS no_PlaceSvcs
,COUNT(DISTINCT Specialty) AS no_Specialities
,COUNT(DISTINCT PrimaryConditionGroup) AS no_PrimaryConditionGroups
,COUNT(DISTINCT ProcedureGroup) AS no_ProcedureGroups


,MAX(PayDelayI) AS PayDelay_max
,MIN(PayDelayI) AS PayDelay_min
,AVG(PayDelayI) AS PayDelay_ave
,(CASE WHEN COUNT(*) = 1 THEN 0 ELSE STDEV(PayDelayI) END) AS PayDelay_stdev


,MAX(LengthOfStayI) AS LOS_max
,MIN(LengthOfStayI) AS LOS_min
,AVG(LengthOfStayI) AS LOS_ave
,(CASE WHEN COUNT(*) = 1 THEN 0 ELSE STDEV(LengthOfStayI) END) AS LOS_stdev


,SUM(CASE WHEN LENGTHOFSTAY IS NULL AND SUPLOS = 0 THEN 1 ELSE 0 END) AS LOS_TOT_UNKNOWN
,SUM(CASE WHEN LENGTHOFSTAY IS NULL AND SUPLOS = 1 THEN 1 ELSE 0 END) AS LOS_TOT_SUPRESSED 
,SUM(CASE WHEN LENGTHOFSTAY IS NOT NULL THEN 1 ELSE 0 END) AS LOS_TOT_KNOWN 


,MAX(dsfsI) AS dsfs_max
,MIN(dsfsI) AS dsfs_min
,MAX(dsfsI) - MIN(dsfsI) AS dsfs_range
,AVG(dsfsI) AS dsfs_ave
,(CASE WHEN COUNT(*) = 1 THEN 0 ELSE STDEV(dsfsI) END) AS dsfs_stdev


,MAX(CharlsonIndexI) AS CharlsonIndexI_max
,MIN(CharlsonIndexI) AS CharlsonIndexI_min
,AVG(CharlsonIndexI) AS CharlsonIndexI_ave
,MAX(CharlsonIndexI) - MIN(CharlsonIndexI) AS CharlsonIndexI_range
,(CASE WHEN COUNT(*) = 1 THEN 0 ELSE STDEV(CharlsonIndexI) END) AS CharlsonIndexI_stdev




,SUM(CASE WHEN PrimaryConditionGroup = 'MSC2a3' THEN 1 ELSE 0 END) AS pcg1
,SUM(CASE WHEN PrimaryConditionGroup = 'METAB3' THEN 1 ELSE 0 END) AS pcg2
,SUM(CASE WHEN PrimaryConditionGroup = 'ARTHSPIN' THEN 1 ELSE 0 END) AS pcg3
,SUM(CASE WHEN PrimaryConditionGroup = 'NEUMENT' THEN 1 ELSE 0 END) AS pcg4
,SUM(CASE WHEN PrimaryConditionGroup = 'RESPR4' THEN 1 ELSE 0 END) AS pcg5
,SUM(CASE WHEN PrimaryConditionGroup = 'MISCHRT' THEN 1 ELSE 0 END) AS pcg6
,SUM(CASE WHEN PrimaryConditionGroup = 'SKNAUT' THEN 1 ELSE 0 END) AS pcg7
,SUM(CASE WHEN PrimaryConditionGroup = 'GIBLEED' THEN 1 ELSE 0 END) AS pcg8
,SUM(CASE WHEN PrimaryConditionGroup = 'INFEC4' THEN 1 ELSE 0 END) AS pcg9
,SUM(CASE WHEN PrimaryConditionGroup = 'TRAUMA' THEN 1 ELSE 0 END) AS pcg10
,SUM(CASE WHEN PrimaryConditionGroup = 'HEART2' THEN 1 ELSE 0 END) AS pcg11
,SUM(CASE WHEN PrimaryConditionGroup = 'RENAL3' THEN 1 ELSE 0 END) AS pcg12
,SUM(CASE WHEN PrimaryConditionGroup = 'ROAMI' THEN 1 ELSE 0 END) AS pcg13
,SUM(CASE WHEN PrimaryConditionGroup = 'MISCL5' THEN 1 ELSE 0 END) AS pcg14
,SUM(CASE WHEN PrimaryConditionGroup = 'ODaBNCA' THEN 1 ELSE 0 END) AS pcg15
,SUM(CASE WHEN PrimaryConditionGroup = 'UTI' THEN 1 ELSE 0 END) AS pcg16
,SUM(CASE WHEN PrimaryConditionGroup = 'COPD' THEN 1 ELSE 0 END) AS pcg17
,SUM(CASE WHEN PrimaryConditionGroup = 'GYNEC1' THEN 1 ELSE 0 END) AS pcg18
,SUM(CASE WHEN PrimaryConditionGroup = 'CANCRB' THEN 1 ELSE 0 END) AS pcg19
,SUM(CASE WHEN PrimaryConditionGroup = 'FXDISLC' THEN 1 ELSE 0 END) AS pcg20
,SUM(CASE WHEN PrimaryConditionGroup = 'AMI' THEN 1 ELSE 0 END) AS pcg21
,SUM(CASE WHEN PrimaryConditionGroup = 'PRGNCY' THEN 1 ELSE 0 END) AS pcg22
,SUM(CASE WHEN PrimaryConditionGroup = 'HEMTOL' THEN 1 ELSE 0 END) AS pcg23
,SUM(CASE WHEN PrimaryConditionGroup = 'HEART4' THEN 1 ELSE 0 END) AS pcg24
,SUM(CASE WHEN PrimaryConditionGroup = 'SEIZURE' THEN 1 ELSE 0 END) AS pcg25
,SUM(CASE WHEN PrimaryConditionGroup = 'APPCHOL' THEN 1 ELSE 0 END) AS pcg26
,SUM(CASE WHEN PrimaryConditionGroup = 'CHF' THEN 1 ELSE 0 END) AS pcg27
,SUM(CASE WHEN PrimaryConditionGroup = 'GYNECA' THEN 1 ELSE 0 END) AS pcg28
,SUM(CASE WHEN PrimaryConditionGroup IS NULL THEN 1 ELSE 0 END) AS pcg29
,SUM(CASE WHEN PrimaryConditionGroup = 'PNEUM' THEN 1 ELSE 0 END) AS pcg30
,SUM(CASE WHEN PrimaryConditionGroup = 'RENAL2' THEN 1 ELSE 0 END) AS pcg31
,SUM(CASE WHEN PrimaryConditionGroup = 'GIOBSENT' THEN 1 ELSE 0 END) AS pcg32
,SUM(CASE WHEN PrimaryConditionGroup = 'STROKE' THEN 1 ELSE 0 END) AS pcg33
,SUM(CASE WHEN PrimaryConditionGroup = 'CANCRA' THEN 1 ELSE 0 END) AS pcg34
,SUM(CASE WHEN PrimaryConditionGroup = 'FLaELEC' THEN 1 ELSE 0 END) AS pcg35
,SUM(CASE WHEN PrimaryConditionGroup = 'MISCL1' THEN 1 ELSE 0 END) AS pcg36
,SUM(CASE WHEN PrimaryConditionGroup = 'HIPFX' THEN 1 ELSE 0 END) AS pcg37
,SUM(CASE WHEN PrimaryConditionGroup = 'METAB1' THEN 1 ELSE 0 END) AS pcg38
,SUM(CASE WHEN PrimaryConditionGroup = 'PERVALV' THEN 1 ELSE 0 END) AS pcg39
,SUM(CASE WHEN PrimaryConditionGroup = 'LIVERDZ' THEN 1 ELSE 0 END) AS pcg40
,SUM(CASE WHEN PrimaryConditionGroup = 'CATAST' THEN 1 ELSE 0 END) AS pcg41
,SUM(CASE WHEN PrimaryConditionGroup = 'CANCRM' THEN 1 ELSE 0 END) AS pcg42
,SUM(CASE WHEN PrimaryConditionGroup = 'PERINTL' THEN 1 ELSE 0 END) AS pcg43
,SUM(CASE WHEN PrimaryConditionGroup = 'PNCRDZ' THEN 1 ELSE 0 END) AS pcg44
,SUM(CASE WHEN PrimaryConditionGroup = 'RENAL1' THEN 1 ELSE 0 END) AS pcg45
,SUM(CASE WHEN PrimaryConditionGroup = 'SEPSIS' THEN 1 ELSE 0 END) AS pcg46


,SUM(CASE WHEN Specialty = 'Internal' THEN 1 ELSE 0 END) AS sp1
,SUM(CASE WHEN Specialty = 'Laboratory' THEN 1 ELSE 0 END) AS sp2
,SUM(CASE WHEN Specialty = 'General Practice' THEN 1 ELSE 0 END) AS sp3
,SUM(CASE WHEN Specialty = 'Surgery' THEN 1 ELSE 0 END) AS sp4
,SUM(CASE WHEN Specialty = 'Diagnostic Imaging' THEN 1 ELSE 0 END) AS sp5
,SUM(CASE WHEN Specialty = 'Emergency' THEN 1 ELSE 0 END) AS sp6
,SUM(CASE WHEN Specialty = 'Other' THEN 1 ELSE 0 END) AS sp7
,SUM(CASE WHEN Specialty = 'Pediatrics' THEN 1 ELSE 0 END) AS sp8
,SUM(CASE WHEN Specialty = 'Rehabilitation' THEN 1 ELSE 0 END) AS sp9
,SUM(CASE WHEN Specialty = 'Obstetrics and Gynecology' THEN 1 ELSE 0 END) AS sp10
,SUM(CASE WHEN Specialty = 'Anesthesiology' THEN 1 ELSE 0 END) AS sp11
,SUM(CASE WHEN Specialty = 'Pathology' THEN 1 ELSE 0 END) AS sp12
,SUM(CASE WHEN Specialty IS NULL THEN 1 ELSE 0 END) AS sp13


,SUM(CASE WHEN ProcedureGroup = 'EM' THEN 1 ELSE 0 END ) AS pg1
,SUM(CASE WHEN ProcedureGroup = 'PL' THEN 1 ELSE 0 END ) AS pg2
,SUM(CASE WHEN ProcedureGroup = 'MED' THEN 1 ELSE 0 END ) AS pg3
,SUM(CASE WHEN ProcedureGroup = 'SCS' THEN 1 ELSE 0 END ) AS pg4
,SUM(CASE WHEN ProcedureGroup = 'RAD' THEN 1 ELSE 0 END ) AS pg5
,SUM(CASE WHEN ProcedureGroup = 'SDS' THEN 1 ELSE 0 END ) AS pg6
,SUM(CASE WHEN ProcedureGroup = 'SIS' THEN 1 ELSE 0 END ) AS pg7
,SUM(CASE WHEN ProcedureGroup = 'SMS' THEN 1 ELSE 0 END ) AS pg8
,SUM(CASE WHEN ProcedureGroup = 'ANES' THEN 1 ELSE 0 END ) AS pg9
,SUM(CASE WHEN ProcedureGroup = 'SGS' THEN 1 ELSE 0 END ) AS pg10
,SUM(CASE WHEN ProcedureGroup = 'SEOA' THEN 1 ELSE 0 END ) AS pg11
,SUM(CASE WHEN ProcedureGroup = 'SRS' THEN 1 ELSE 0 END ) AS pg12
,SUM(CASE WHEN ProcedureGroup = 'SNS' THEN 1 ELSE 0 END ) AS pg13
,SUM(CASE WHEN ProcedureGroup = 'SAS' THEN 1 ELSE 0 END ) AS pg14
,SUM(CASE WHEN ProcedureGroup = 'SUS' THEN 1 ELSE 0 END ) AS pg15
,SUM(CASE WHEN ProcedureGroup IS NULL THEN 1 ELSE 0 END ) AS pg16
,SUM(CASE WHEN ProcedureGroup = 'SMCD' THEN 1 ELSE 0 END ) AS pg17
,SUM(CASE WHEN ProcedureGroup = 'SO' THEN 1 ELSE 0 END ) AS pg18


,SUM(CASE WHEN PlaceSvc = 'Office' THEN 1 ELSE 0 END) AS ps1
,SUM(CASE WHEN PlaceSvc = 'Independent Lab' THEN 1 ELSE 0 END) AS ps2
,SUM(CASE WHEN PlaceSvc = 'Urgent Care' THEN 1 ELSE 0 END) AS ps3
,SUM(CASE WHEN PlaceSvc = 'Outpatient Hospital' THEN 1 ELSE 0 END) AS ps4
,SUM(CASE WHEN PlaceSvc = 'Inpatient Hospital' THEN 1 ELSE 0 END) AS ps5
,SUM(CASE WHEN PlaceSvc = 'Ambulance' THEN 1 ELSE 0 END) AS ps6
,SUM(CASE WHEN PlaceSvc = 'Other' THEN 1 ELSE 0 END) AS ps7
,SUM(CASE WHEN PlaceSvc = 'Home' THEN 1 ELSE 0 END) AS ps8
,SUM(CASE WHEN PlaceSvc IS NULL THEN 1 ELSE 0 END) AS ps9


INTO claims_per_member
FROM Claims
GROUP BY year,Memberid


-- remove some nulls
UPDATE claims_per_member
SET LOS_max = 0 WHERE LOS_max IS NULL


UPDATE claims_per_member
SET LOS_min = 0 WHERE LOS_min IS NULL


UPDATE claims_per_member
SET LOS_ave = 0 WHERE LOS_ave IS NULL


UPDATE claims_per_member
SET LOS_stdev = -1 WHERE LOS_stdev IS NULL


UPDATE claims_per_member
SET dsfs_max = 0 WHERE dsfs_max IS NULL


UPDATE claims_per_member
SET dsfs_min = 0 WHERE dsfs_min IS NULL


UPDATE claims_per_member
SET dsfs_ave = 0 WHERE dsfs_ave IS NULL


UPDATE claims_per_member
SET dsfs_stdev = -1 WHERE dsfs_stdev IS NULL


UPDATE claims_per_member
SET dsfs_range = -1 WHERE dsfs_range IS NULL


UPDATE claims_per_member
SET CharlsonIndexI_range = -1 WHERE CharlsonIndexI_range IS NULL






/***********************************
Members
***********************************/


-- create binary flags for age
ALTER TABLE Members ADD age_05 INT
ALTER TABLE Members ADD age_15 INT
ALTER TABLE Members ADD age_25 INT
ALTER TABLE Members ADD age_35 INT
ALTER TABLE Members ADD age_45 INT
ALTER TABLE Members ADD age_55 INT
ALTER TABLE Members ADD age_65 INT
ALTER TABLE Members ADD age_75 INT
ALTER TABLE Members ADD age_85 INT
ALTER TABLE Members ADD age_MISS INT


GO


UPDATE Members SET age_05 = CASE WHEN ageATfirstclaim = '0-9' THEN 1 ELSE 0 END
UPDATE Members SET age_15 = CASE WHEN ageATfirstclaim = '10-19' THEN 1 ELSE 0 END
UPDATE Members SET age_25 = CASE WHEN ageATfirstclaim = '20-29' THEN 1 ELSE 0 END
UPDATE Members SET age_35 = CASE WHEN ageATfirstclaim = '30-39' THEN 1 ELSE 0 END
UPDATE Members SET age_45 = CASE WHEN ageATfirstclaim = '40-49' THEN 1 ELSE 0 END
UPDATE Members SET age_55 = CASE WHEN ageATfirstclaim = '50-59' THEN 1 ELSE 0 END
UPDATE Members SET age_65 = CASE WHEN ageATfirstclaim = '60-69' THEN 1 ELSE 0 END
UPDATE Members SET age_75 = CASE WHEN ageATfirstclaim = '70-79' THEN 1 ELSE 0 END
UPDATE Members SET age_85 = CASE WHEN ageATfirstclaim = '80+' THEN 1 ELSE 0 END
UPDATE Members SET age_MISS = CASE WHEN ageATfirstclaim IS NULL THEN 1 ELSE 0 END




--create binary flags for sex
ALTER TABLE Members
ADD sexMALE INT
GO


UPDATE Members
SET SexMALE = 
CASE
WHEN Sex = 'M' THEN 1 ELSE 0
END




ALTER TABLE Members
ADD sexFEMALE INT
GO


UPDATE Members
SET SexFEMALE = 
CASE
WHEN Sex = 'F' THEN 1 ELSE 0
END




ALTER TABLE Members
ADD sexMISS INT
GO


UPDATE Members
SET SexMISS = 
CASE
WHEN Sex IS NULL THEN 1 ELSE 0
END






/******************
DRUG COUNTS
******************/


-- convert to integers
ALTER TABLE drugcount ADD DrugCountI INT
GO
UPDATE DRUGCOUNT
SET DrugCountI = 
CASE WHEN DrugCount = '7+' THEN 7 ELSE DrugCount END




SELECT
memberID AS memberID_dc
,Year AS YEAR_dc
,MAX(drugcountI) AS drugCount_max
,MIN(drugcountI) AS drugCount_min
,AVG(drugcountI * 1.0) AS drugCount_ave
,COUNT(*) AS drugcount_months
INTO DRUGCOUNT_SUMMARY
FROM
drugcount
GROUP BY 
memberID
,Year






/******************
LAB COUNTS
******************/


-- convert to integers
ALTER TABLE LabCount ADD LabCountI INT
GO
UPDATE LabCount
SET LabCountI = 
CASE WHEN LabCount = '10+' THEN 10 ELSE LabCount END


SELECT
memberID AS memberID_lc
,Year AS YEAR_lc
,MAX(labcountI) AS labCount_max
,MIN(labcountI) AS labCount_min
,AVG(labcountI * 1.0) AS labCount_ave
,COUNT(*) AS labcount_months
INTO LABCOUNT_SUMMARY
FROM
labcount
GROUP BY 
memberID
,Year




/********************************
Targets
********************************/


SELECT * 
INTO DIH
FROM
(
SELECT 
MemberID AS MemberID_t
,'Y1' AS YEAR_t
,ClaimsTruncated
,DaysInHospital 
,1 AS trainset
FROM DaysInHospital_Y2


UNION ALL


SELECT 
MemberID AS MemberID_t
,'Y2' AS YEAR_t
,ClaimsTruncated
,DaysInHospital 
,1 AS trainset
FROM DaysInHospital_Y3


UNION ALL


SELECT
MemberID AS MemberID_t
,'Y3' AS YEAR_t
,ClaimsTruncated
,null AS DaysInHospital
,0 AS trainset
FROM Target
) a






/*****************************
Now merge them all together to
create the modeling data SET
******************************/
SELECT a.*,b.*
INTO #temp1
FROM 
DIH a
LEFT OUTER JOIN 
members b
on a.MemberID_t = B.Memberid_M


ALTER TABLE #temp1 DROP COLUMN Memberid_M
ALTER TABLE #temp1 DROP COLUMN AgeAtFirstClaim
ALTER TABLE #temp1 DROP COLUMN Sex
GO






SELECT a.*,b.*
INTO #temp2
FROM
#temp1 a
LEFT OUTER JOIN
claims_per_member b
on a.MemberID_t = B.Memberid
AND a.YEAR_t = b.year


ALTER TABLE #temp2 DROP COLUMN Memberid
ALTER TABLE #temp2 DROP COLUMN year
GO




SELECT a.*,b.*
INTO #temp3
FROM
#temp2 a
LEFT OUTER JOIN
DRUGCOUNT_SUMMARY b
on a.MemberID_t = B.Memberid_dc
AND a.YEAR_t = b.YEAR_dc


ALTER TABLE #temp3 DROP COLUMN Memberid_dc
ALTER TABLE #temp3 DROP COLUMN YEAR_dc
GO






SELECT a.*,b.*
INTO #temp4
FROM
#temp3 a
LEFT OUTER JOIN
LABCOUNT_SUMMARY b
on a.MemberID_t = B.Memberid_lc
AND a.YEAR_t = b.YEAR_lc


ALTER TABLE #temp4 DROP COLUMN Memberid_lc
ALTER TABLE #temp4 DROP COLUMN YEAR_lc
GO






-- removel nulls for those who had 
-- no lab or drug information
ALTER TABLE #temp4 ADD labNull INT
ALTER TABLE #temp4 ADD drugNull INT
GO


UPDATE #temp4 SET labNull = 0
UPDATE #temp4 SET labNull = 1 WHERE labCount_max IS NULL


UPDATE #temp4 SET drugNull = 0
UPDATE #temp4 SET drugNull = 1 WHERE drugCount_max IS NULL


UPDATE #temp4 SET labCount_max = 0 WHERE labCount_max IS NULL
UPDATE #temp4 SET labCount_min = 0 WHERE labCount_min IS NULL
UPDATE #temp4 SET labCount_ave = 0 WHERE labCount_ave IS NULL
UPDATE #temp4 SET labcount_months = 0 WHERE labcount_months IS NULL


UPDATE #temp4 SET drugCount_max = 0 WHERE drugCount_max IS NULL
UPDATE #temp4 SET drugCount_min = 0 WHERE drugCount_min IS NULL
UPDATE #temp4 SET drugCount_ave = 0 WHERE drugCount_ave IS NULL
UPDATE #temp4 SET drugcount_months = 0 WHERE drugcount_months IS NULL




SELECT * 
INTO modelling_set
FROM #temp4

