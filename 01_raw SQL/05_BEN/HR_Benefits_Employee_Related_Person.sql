--HR_Benefits_Employee_Related_Person
USE [IT.Macomb_DBA]
GO

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'Empl_Related_Person'))
	BEGIN
		create table dbo.Empl_Related_Person 
		(
		EmployeeID varchar(7)
		,Sourcesystem varchar(100)
		,DependentID varchar(100)
		,BeneficiaryID varchar(100)
		,EmergencyContactID varchar(100)
		,RelatedPersonRelationship varchar(100)
		,CountryISOCode_LegalName varchar(3)
		,FirstName varchar(100)
		,MiddleName varchar(100)
		,LastName varchar(100)
		,Prefix varchar(25)
		,Suffix varchar(25)
		,TrustName varchar(25)
		,Language varchar(25)
		,EmergencyContactPriority varchar(25)
		,SamePhoneasEmployee varchar(25)
		,CountryISOCode_PrimaryHome varchar(3)
		,InternationalPhoneCode_PrimaryHome varchar(2)
		,PhoneNumber_PrimaryHome varchar(25)
		,PhoneExtension_PrimaryHome varchar(25)
		,PhoneDeviceType_PrimaryHome varchar(20)
		,CountryISOCode_AdditionalHome_1 varchar(3)
		,InternationalPhoneCode_AdditionalHome_1 varchar(3)
		,PhoneNumber_AdditionalHome_1 varchar(20)
		,PhoneExtension_AdditionalHome_1 varchar(10)
		,PhoneDeviceType_AdditionalHome_1 varchar(20)
		,CountryISOCode_AdditionalHome_2 varchar(3)
		,InternationalPhoneCode_AdditionalHome_2 varchar(2)
		,PhoneNumber_AdditionalHome_2 varchar(20)
		,PhoneExtension_AdditionalHome_2 varchar(2)
		,PhoneDeviceType_AdditionalHome_2 varchar(20)
		,CountryISOCode_PrimaryWork varchar(3)
		,InternationalPhoneCode_PrimaryWork varchar(2)
		,PhoneNumber_PrimaryWork varchar(20)
		,PhoneExtension_PrimaryWork varchar(2)
		,PhoneDeviceType_PrimaryWork  varchar(20)
		,CountryISOCode_AdditionalWork_1 varchar(3)
		,InternationalPhoneCode_AdditionalWork_1 varchar(2)
		,PhoneNumber_AdditionalWork_1 varchar(200)
		,PhoneExtension_AdditionalWork_1 varchar(2)
		,PhoneDeviceType_AdditionalWork_1 varchar(20)
		,CountryISOCode_AdditionalWork_2 varchar(3)
		,InternationalPhoneCode_AdditionalWork_2 varchar(2)
		,PhoneNumber_AdditionalWork_2 varchar(200)
		,PhoneExtension_AdditionalWork_2 varchar(2)
		,PhoneDeviceType_AdditionalWork_2 varchar(20)
		,EmailAddress_PrimaryHome varchar(100)
		,EmailAddress_PrimaryWork varchar(100)
		,EmailAddress_AdditionalHome varchar(100)
		,EmailAddress_AdditionalWork  varchar(100)
		,SameAddressasEmployee  varchar(2)
		,CountryISOCode_Home varchar(3)
		,AddressLine_1_Home varchar(100)
		,AddressLine_2_Home varchar(2)
		,City_Home varchar(50)
		,CitySubdivision_Home varchar(2)
		,CitySubdivision2_Home varchar(2)
		,Region_Home varchar(6)
		,RegionSubdivision_Home varchar(2)
		,RegionSubdivision2_Home varchar(2)
		,PostalCode_Home varchar(9)
		,CountryISOCode_AltHome_1 varchar(3)
		,AddressLine_1_AltHome_1 varchar(2)
		,AddressLine_2_AltHome_1 varchar(2)
		,City_AltHome_1 varchar(2)
		,CitySubdivision_AltHome_1 varchar(2)
		,CitySubdivision2_AltHome_1 varchar(2)
		,Region_AltHome_1 varchar(2)
		,RegionSubdivision_AltHome_1 varchar(2)
		,RegionSubdivision2_AltHome_1 varchar(2)
		,PostalCode_AltHome_1 varchar(2)
		,DateofBirth datetime
		,Gender  varchar(20)
		,NationalID  varchar(20)
		,NationalIDType  varchar(7)
		,EffectiveDate  datetime
		,Reason varchar(20)
		,UsesTobacco varchar(2)
		,Full_timeStudent varchar(2)
		,DependentforPayrollPurposes varchar(2)
		,StudentStatusStartDate varchar(2)
		,StudentStatusEndDate varchar(2)
		,Disabled varchar(2)
		,CouldBeCoveredForHealthCareCoverageElsewhere varchar(2)
		,CouldBeCoveredForHealthCareCoverageElsewhereDate varchar(2)
		,BenefitCoverageType_Medical varchar(20)
		,StartDate_Medical varchar(20)
		,EndDate_Medical varchar(2)
		,BenefitCoverageType_Dental varchar(20)
		,StartDate_Dental varchar(20)
		,EndDate_Dental varchar(2)
		,BenefitCoverageType_Vision varchar(20)
		,StartDate_Vision varchar(2)
		,EndDate_Vision varchar(2)
		,SSN_EXT varchar(2)
		,HR_STATUS varchar(2)
		,ENTITY_ID varchar(4)
		);
		PRINT N'created table.'; 
	END
else
	begin
		delete from [IT.Macomb_DBA].dbo.Empl_Related_Person; 
		PRINT N'deleted table data.'; 
	END 
GO
USE production_finance
GO
--select * from @Empl_Related_Person

insert into [IT.Macomb_DBA].dbo.Empl_Related_Person
--Dependent
SELECT 

trim(hr_empmstr.id) as 'EmployeeID'
,'D-Jen Smiley' as 'SourceSystem'
,trim(hr_family.id) +'-'+ trim(hr_family.family_tp)
   +convert(varchar,ROW_NUMBER() OVER (PARTITION BY hr_empmstr.id ORDER BY hr_empmstr.id )) /*=DEPN*/ as 'DependentID'
,'' /*=BENF*/ as 'BeneficiaryID'
,'' as 'EmergencyContactID'
--,convert(varchar,ROW_NUMBER() OVER (PARTITION BY hr_empmstr.id ORDER BY hr_empmstr.id ))
,CASE 
	WHEN hr_family.relation = 'OT' THEN 'Other'
	WHEN hr_family.relation = 'SI' THEN 'Sibling'
	WHEN hr_family.relation = 'SP' THEN 'Spouse'
	WHEN hr_family.relation = 'IS' THEN 'Ex-Spouse'
	WHEN hr_family.relation = 'PA' THEN 'Parent'
	WHEN hr_family.relation = 'CH' THEN 'Child'
	WHEN hr_family.relation = 'SC' THEN 'Step Child'
	WHEN hr_family.relation = 'DD' THEN 'Disabled Dependent'
	WHEN hr_family.relation = 'ID' THEN 'Ineligible Dependent'
	WHEN hr_family.relation = 'MU' THEN 'Multiple'
	--WHEN hr_family.relation = 'ZZ' THEN 'Same Sex Spouse'
	--WHEN hr_family.relation = 'XX' THEN 'Legal Dependent'
	--WHEN hr_family.relation = 'YY' THEN 'Domestic_Partner_Child'
	--WHEN hr_family.relation = 'WW' THEN 'Domestic Partner'
	--WHEN hr_family.relation = 'VV' THEN 'Ex-Domestic Partner'
	ELSE hr_family.relation
END as 'RelatedPersonRelationship'
,'USA' as 'CountryISOCode_LegalName'
,parsename(replace(IIF(Charindex(' ',parsename(replace(replace(trim(hr_family.familyname),'.',''),', ','.'),1))=0,
    parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),1)+' ~',
	 parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),1)),' ','.'),2) AS FirstName
,replace(parsename(replace(IIF(Charindex(' ',parsename(replace(replace(trim(hr_family.familyname),'.',''),', ','.'),1))=0,
    parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),1)+' ~',
	 parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),1)),' ','.'),1),'~','') AS MiddleName
/*,IIF(trim(hr_family.familyname) = 'MULTIPLE'
     ,'MULTIPLE'
	  ,parsename(replace(IIF(charindex(' ',parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),2))=0,
    parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),2)+' ~',
	 parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),2)),' ','.'),2)) as LastName 
*/
,parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),2) as LastName
,'' as 'Prefix'
,/*replace(parsename(replace(IIF(charindex(' ',parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),2))=0,
    parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),2)+' ~',
	 parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),2)),' ','.'),1),'~','') as 'Suffix'
*/
'' as 'Suffix'
,'' as 'TrustName'
,'' as 'Language'
,'' /*IIF(hr_emerinfo.id is null,'','1')*/ as 'EmergencyContactPriority'
,'' as 'SamePhoneasEmployee'
,IIF(hr_family.phone_no is not null,'USA','') as 'CountryISOCode_PrimaryHome'
,IIF(hr_family.phone_no is not null,'1','') as 'InternationalPhoneCode_PrimaryHome'
,ISNULL(hr_family.phone_no,'') as 'PhoneNumber_PrimaryHome'
,ISNULL(hr_family.phone_ext,'') as 'PhoneExtension_PrimaryHome'
,IIF(hr_family.phone_no is not null,'mobile','') as 'PhoneDeviceType_PrimaryHome'
,IIF(hr_family.phone_no is not null,'USA','') as 'CountryISOCode_AdditionalHome_1'
,IIF(hr_family.phone_no is not null,'1','') as 'InternationalPhoneCode_AdditionalHome_1'
,ISNULL(hr_family.phone_no,'') as 'PhoneNumber_AdditionalHome_1'
,'' as 'PhoneExtension_AdditionalHome_1'
,IIF(hr_family.phone_no is not null,'Mobile','') as 'PhoneDeviceType_AdditionalHome_1'
,IIF(hr_family.phone_no is not null,'USA','') as 'CountryISOCode_AdditionalHome_2'
,'' as 'InternationalPhoneCode_AdditionalHome_2'
,'' as 'PhoneNumber_AdditionalHome_2'
,'' as 'PhoneExtension_AdditionalHome_2'
,'' as 'PhoneDeviceType_AdditionalHome_2'
,'' as 'CountryISOCode_PrimaryWork'
,'' as 'InternationalPhoneCode_PrimaryWork'
,'' as 'PhoneNumber_PrimaryWork'
,'' as 'PhoneExtension_PrimaryWork'
,'' as 'PhoneDeviceType_PrimaryWork'
,'' as 'CountryISOCode_AdditionalWork_1'
,'' as 'InternationalPhoneCode_AdditionalWork_1'
,'' as 'PhoneNumber_AdditionalWork_1'
,'' as 'PhoneExtension_AdditionalWork_1'
,'' as 'PhoneDeviceType_AdditionalWork_1'
,'' as 'CountryISOCode_AdditionalWork_2'
,'' as 'InternationalPhoneCode_AdditionalWork_2'
,'' as 'PhoneNumber_AdditionalWork_2'
,'' as 'PhoneExtension_AdditionalWork_2'
,'' as 'PhoneDeviceType_AdditionalWork_2'
,'' as 'EmailAddress_PrimaryHome'
,'' as 'EmailAddress_PrimaryWork'
,'' as 'EmailAddress_AdditionalHome'
,'' as 'EmailAddress_AdditionalWork'
,'Y' as 'SameAddressasEmployee'
,'USA' as 'CountryISOCode_Home'
,hr_family.ST_1 as 'AddressLine_1_Home'
,'' as 'AddressLine_2_Home'
,hr_family.CITY as 'City_Home'
,'' as 'CitySubdivision_Home'
,'' as 'CitySubdivision2_Home'
,IIF(hr_family.STATE IS NULL,'','USA-'+hr_family.STATE) as 'Region_Home'
,'' as 'RegionSubdivision_Home'
,'' as 'RegionSubdivision2_Home'
,hr_family.ZIP_CODE as 'PostalCode_Home'
,'USA' as 'CountryISOCode_AltHome_1'
,'' as 'AddressLine_1_AltHome_1'
,'' as 'AddressLine_2_AltHome_1'
,'' as 'City_AltHome_1'
,'' as 'CitySubdivision_AltHome_1'
,'' as 'CitySubdivision2_AltHome_1'
,'' as 'Region_AltHome_1'
,'' as 'RegionSubdivision_AltHome_1'
,'' as 'RegionSubdivision2_AltHome_1'
,'' as 'PostalCode_AltHome_1'
,replace(convert(varchar, HR_family.famdob, 106),' ','-') as 'DateofBirth'
,CASE 
  WHEN HR_family.gender = 'F' THEN 'Female'
  WHEN HR_family.gender = 'M' THEN 'Male'
  ELSE ''
  END  as 'Gender'
,IIF(Hr_family.family_SSN='999999999','',Hr_family.family_SSN) as 'NationalID' -- Look for BENF1 and BENF2
,'USA-SSN' as 'NationalIDType'
,replace(convert(varchar, GETDATE(), 106),' ','-') as 'EffectiveDate'
,'Conversion' as 'Reason'
,'' as 'UsesTobacco'
,'' as 'Full_timeStudent'
,'' as 'DependentforPayrollPurposes'
,'' as 'StudentStatusStartDate'
,'' as 'StudentStatusEndDate'
,IIF(HR_family.relation='dd','Y','') as 'Disabled'
,'' as 'CouldBeCoveredForHealthCareCoverageElsewhere'
,'' as 'CouldBeCoveredForHealthCareCoverageElsewhereDate'
,'' as 'BenefitCoverageType_Medical'
,'1-JAN-2022' as 'StartDate_Medical'
,'' as 'EndDate_Medical'
,'' as 'BenefitCoverageType_Dental'
,'1-JAN-2022' as 'StartDate_Dental'
,'' as 'EndDate_Dental'
,'' as 'BenefitCoverageType_Vision'
,'' as 'StartDate_Vision'
,'' as 'EndDate_Vision'
,hr_family.SSN_EXT as SSN_EXT
,hr_empmstr.HR_STATUS
,hr_empmstr.ENTITY_ID
from [production_finance].[dbo].hr_empmstr
  RIGHT JOIN [production_finance].[dbo].hr_Family
   ON hr_empmstr.ID = hr_family.id 
	   /* NOT TRUE --- and hr_family.enddt = '12/31/2050'*/
		and (not hr_family.enddt < '4/14/2022' or hr_family.enddt is null)
	   and hr_family.FAMILY_TP = 'DEPN'
		and hr_family.RELATION NOT in ('ID','IS')
where 
 hr_empmstr.entity_id in ('ROOT','PENS','ZINS')
 and hr_empmstr.hr_status = 'A'
 --and (hr_empmstr.id = 'E003542' OR 
 --     hr_empmstr.id = 'E008620')

 order by hr_empmstr.ID,hr_family.SSN_EXT;



/*insert into [IT.Macomb_DBA].dbo.Empl_Related_Person
--beneficiary
SELECT
trim(hr_empmstr.id) as 'EmployeeID'
,'B-Jen Smiley' as 'SourceSystem'
,'' AS 'DependentID'
--,trim(hr_family.id) +'-'+ trim(hr_family.family_tp)
--   +convert(varchar,ROW_NUMBER() OVER (PARTITION BY hr_empmstr.id ORDER BY hr_empmstr.id )) /*=DEPN*/ as 'DependentID'
,trim(hr_family.id) +'-'+ left(hr_family.family_tp,3)
   +convert(varchar,ROW_NUMBER() OVER (PARTITION BY hr_empmstr.id ORDER BY hr_empmstr.id )) /*=BENF*/ as 'BeneficiaryID'
,'' as 'EmergencyContactID'
--,convert(varchar,ROW_NUMBER() OVER (PARTITION BY hr_empmstr.id ORDER BY hr_empmstr.id ))
,CASE 
	WHEN hr_family.relation = 'OT' THEN 'Other'
	WHEN hr_family.relation = 'SI' THEN 'Sibling'
	WHEN hr_family.relation = 'SP' THEN 'Spouse'
	WHEN hr_family.relation = 'IS' THEN 'Ex-Spouse'
	WHEN hr_family.relation = 'PA' THEN 'Parent'
	WHEN hr_family.relation = 'CH' THEN 'Child'
	WHEN hr_family.relation = 'SC' THEN 'Step Child'
	WHEN hr_family.relation = 'DD' THEN 'Disabled Dependent'
	WHEN hr_family.relation = 'ID' THEN 'Ineligible Dependent'
	WHEN hr_family.relation = 'MU' THEN 'Multiple'
	--WHEN hr_family.relation = 'ZZ' THEN 'Same Sex Spouse'
	--WHEN hr_family.relation = 'XX' THEN 'Legal Dependent'
	--WHEN hr_family.relation = 'YY' THEN 'Domestic_Partner_Child'
	--WHEN hr_family.relation = 'WW' THEN 'Domestic Partner'
	--WHEN hr_family.relation = 'VV' THEN 'Ex-Domestic Partner'
	ELSE hr_family.relation
END as 'RelatedPersonRelationship'
,'USA' as 'CountryISOCode-LegalName'

,parsename(replace(IIF(Charindex(' ',parsename(replace(replace(trim(hr_family.familyname),'.',''),', ','.'),1))=0,
    parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),1)+' ~',
	 parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),1)),' ','.'),2) AS FirstName
,replace(parsename(replace(IIF(Charindex(' ',parsename(replace(replace(trim(hr_family.familyname),'.',''),', ','.'),1))=0,
    parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),1)+' ~',
	 parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),1)),' ','.'),1),'~','') AS MiddleName
/*,IIF(trim(hr_family.familyname) = 'MULTIPLE'
     ,'MULTIPLE'
	  ,parsename(replace(IIF(charindex(' ',parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),2))=0,
    parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),2)+' ~',
	 parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),2)),' ','.'),2)) as LastName 
*/
,parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),2) as LastName
,'' as 'Prefix'
,/*replace(parsename(replace(IIF(charindex(' ',parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),2))=0,
    parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),2)+' ~',
	 parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),2)),' ','.'),1),'~','') as 'Suffix'
*/
'' as 'Suffix'

/*,IIF(trim(hr_family.familyname) = 'MULTIPLE','MULTIPLE',parsename(replace(IIF(charindex(' ',parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),2))=0,
    parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),2)+' ~',
	 parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),2)),' ','.'),2)) as LastName
,'' as 'Prefix'

,replace(parsename(replace(IIF(charindex(' ',parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),2))=0,
    parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),2)+' ~',
	 parsename(replace(replace(trim(hr_family.familyname),'.',''),',','.'),2)),' ','.'),1),'~','') as 'Suffix'
*/
,'' as 'TrustName'
,'' as 'Language'
,'' /*IIF(hr_emerinfo.id is null,'','1')*/ as 'EmergencyContactPriority'
,'' as 'SamePhoneasEmployee'
,IIF(hr_family.phone_no is not null,'USA','') as 'CountryISOCode-PrimaryHome'
,IIF(hr_family.phone_no is not null,'1','') as 'InternationalPhoneCode-PrimaryHome'
,ISNULL(hr_family.phone_no,'') as 'PhoneNumber-PrimaryHome'
,ISNULL(hr_family.phone_ext,'') as 'PhoneExtension-PrimaryHome'
,IIF(hr_family.phone_no is not null,'mobile','') as 'PhoneDeviceType-PrimaryHome'
,IIF(hr_family.phone_no is not null,'USA','') as 'CountryISOCode-AdditionalHome_1'
,IIF(hr_family.phone_no is not null,'1','') as 'InternationalPhoneCode-AdditionalHome_1'
,ISNULL(hr_family.phone_no,'') as 'PhoneNumber-AdditionalHome_1'
,'' as 'PhoneExtension-AdditionalHome_1'
,IIF(hr_family.phone_no is not null,'Mobile','') as 'PhoneDeviceType-AdditionalHome_1'
,IIF(hr_family.phone_no is not null,'USA','') as 'CountryISOCode-AdditionalHome_2'
,'' as 'InternationalPhoneCode-AdditionalHome_2'
,'' as 'PhoneNumber-AdditionalHome_2'
,'' as 'PhoneExtension-AdditionalHome_2'
,'' as 'PhoneDeviceType-AdditionalHome_2'
,'' as 'CountryISOCode-PrimaryWork'
,'' as 'InternationalPhoneCode-PrimaryWork'
,'' as 'PhoneNumber-PrimaryWork'
,'' as 'PhoneExtension-PrimaryWork'
,'' as 'PhoneDeviceType-PrimaryWork'
,'' as 'CountryISOCode-AdditionalWork_1'
,'' as 'InternationalPhoneCode-AdditionalWork_1'
,'' as 'PhoneNumber-AdditionalWork_1'
,'' as 'PhoneExtension-AdditionalWork_1'
,'' as 'PhoneDeviceType-AdditionalWork_1'
,'' as 'CountryISOCode-AdditionalWork_2'
,'' as 'InternationalPhoneCode-AdditionalWork_2'
,'' as 'PhoneNumber-AdditionalWork_2'
,'' as 'PhoneExtension-AdditionalWork_2'
,'' as 'PhoneDeviceType-AdditionalWork_2'
,'' as 'EmailAddress-PrimaryHome'
,'' as 'EmailAddress-PrimaryWork'
,'' as 'EmailAddress-AdditionalHome'
,'' as 'EmailAddress-AdditionalWork'
,'Y' as 'SameAddressasEmployee'
,'USA' as 'CountryISOCode-Home'
,hr_family.ST_1 as 'AddressLine_1-Home'
,'' as 'AddressLine_2-Home'
,hr_family.CITY as 'City-Home'
,'' as 'CitySubdivision-Home'
,'' as 'CitySubdivision2-Home'
,IIF(hr_family.STATE IS NULL,'','USA-'+hr_family.STATE) as 'Region-Home'
,'' as 'RegionSubdivision-Home'
,'' as 'RegionSubdivision2-Home'
,'' as 'PostalCode-Home'
,'USA' as 'CountryISOCode-AltHome_1'
,'' as 'AddressLine_1-AltHome_1'
,'' as 'AddressLine_2-AltHome_1'
,'' as 'City-AltHome_1'
,'' as 'CitySubdivision-AltHome_1'
,'' as 'CitySubdivision2-AltHome_1'
,'' as 'Region-AltHome_1'
,'' as 'RegionSubdivision-AltHome_1'
,'' as 'RegionSubdivision2-AltHome_1'
,'' as 'PostalCode-AltHome_1'
,replace(convert(varchar, HR_family.famdob, 106),' ','-') as 'DateofBirth'
,CASE 
  WHEN HR_family.gender = 'F' THEN 'Female'
  WHEN HR_family.gender = 'M' THEN 'Male'
  ELSE ''
  END  as 'Gender'
,IIF(Hr_family.family_SSN='999999999','',Hr_family.family_SSN) as 'NationalID'
,'USA-SSN' as 'NationalIDType'
,'' as 'EffectiveDate'
,'' as 'Reason'
,'' as 'UsesTobacco'
,'' as 'Full-timeStudent'
,'' as 'DependentforPayrollPurposes'
,'' as 'StudentStatusStartDate'
,'' as 'StudentStatusEndDate'
,'' as 'Disabled'
,'' as 'CouldBeCoveredForHealthCareCoverageElsewhere'
,'' as 'CouldBeCoveredForHealthCareCoverageElsewhereDate'
,'' as 'BenefitCoverageType-Medical'
,'' as 'StartDate-Medical'
,'' as 'EndDate-Medical'
,'' as 'BenefitCoverageType-Dental'
,'' as 'StartDate-Dental'
,'' as 'EndDate-Dental'
,'' as 'BenefitCoverageType-Vision'
,'' as 'StartDate-Vision'
,'' as 'EndDate-Vision'
,hr_family.SSN_EXT
,hr_empmstr.HR_STATUS
,hr_empmstr.ENTITY_ID
from [production_finance].[dbo].hr_empmstr
  RIGHT JOIN [production_finance].[dbo].hr_Family
   ON hr_empmstr.ID = hr_family.id 
	   and left(hr_family.family_tp,3) ='BEN' --bene, benf 
-- no needed in family  left JOIN [production_finance].[dbo].hr_empmstr h2 ON hr_empmstr.ID =left(h2.notes,7)
where 
 hr_empmstr.entity_id in ('ROOT','PENS','ZINS')
 and hr_empmstr.hr_status = 'A'
order by hr_empmstr.ID,hr_family.SSN_EXT;
*/


insert into [IT.Macomb_DBA].dbo.Empl_Related_Person
-- Emergancy contact
SELECT
trim(hr_empmstr.id) as 'EmployeeID'
,'E-Jen Smiley' as 'SourceSystem'
,'' /*trim(hr_family.id) +'-'+ trim(hr_family.family_tp)
   +convert(varchar,ROW_NUMBER() OVER (PARTITION BY hr_empmstr.id ORDER BY hr_empmstr.id ))*/ /*=DEPN*/ as 'DependentID'
,'' /*trim(hr_family.id) +'-'+ trim(hr_family.family_tp) 
   +convert(varchar,ROW_NUMBER() OVER (PARTITION BY hr_empmstr.id ORDER BY hr_empmstr.id ))*/ /*=BENF*/ as 'BeneficiaryID'
,ISNULL(trim(hr_emerinfo.id)+'-EO'+
convert(varchar,ROW_NUMBER() OVER (PARTITION BY hr_empmstr.id ORDER BY hr_empmstr.id )),'') as 'EmergencyContactID'
--,convert(varchar,ROW_NUMBER() OVER (PARTITION BY hr_empmstr.id ORDER BY hr_empmstr.id ))
,CASE 
	WHEN hr_emerinfo.relation = 'OT' THEN 'Other'
	WHEN hr_emerinfo.relation = 'SI' THEN 'Sibling'
	WHEN hr_emerinfo.relation = 'SP' THEN 'Spouse'
	WHEN hr_emerinfo.relation = 'IS' THEN 'Ex-Spouse'
	WHEN hr_emerinfo.relation = 'PA' THEN 'Parent'
	WHEN hr_emerinfo.relation = 'CH' THEN 'Child'
	WHEN hr_emerinfo.relation = 'SC' THEN 'Step Child'
	WHEN hr_emerinfo.relation = 'DD' THEN 'Disabled Dependent'
	WHEN hr_emerinfo.relation = 'ID' THEN 'Ineligible Dependent'
	WHEN hr_emerinfo.relation = 'MU' THEN 'Multiple'
	--WHEN hr_emerinfo.relation = 'ZZ' THEN 'Same Sex Spouse'
	--WHEN hr_emerinfo.relation = 'XX' THEN 'Legal Dependent'
	--WHEN hr_emerinfo.relation = 'YY' THEN 'Domestic_Partner_Child'
	--WHEN hr_emerinfo.relation = 'WW' THEN 'Domestic Partner'
	--WHEN hr_emerinfo.relation = 'VV' THEN 'Ex-Domestic Partner'
	ELSE hr_emerinfo.relation
END as 'RelatedPersonRelationship'
,'USA' as 'CountryISOCode-LegalName'

,parsename(replace(IIF(Charindex(' ',parsename(replace(replace(trim(hr_emerinfo.contact),'.',''),', ','.'),1))=0,
    parsename(replace(replace(trim(hr_emerinfo.contact),'.',''),',','.'),1)+' ~',
	 parsename(replace(replace(trim(hr_emerinfo.contact),'.',''),',','.'),1)),' ','.'),2) AS FirstName
,'' AS MiddleName
,replace(parsename(replace(IIF(Charindex(' ',parsename(replace(replace(trim(hr_emerinfo.contact),'.',''),', ','.'),1))=0,
    parsename(replace(replace(trim(hr_emerinfo.contact),'.',''),',','.'),1)+' ~',
	 parsename(replace(replace(trim(hr_emerinfo.contact),'.',''),',','.'),1)),' ','.'),1),'~','') as LastName
,'' as 'Prefix'

,'' as 'Suffix'
,'' as 'TrustName'
,'' as 'Language'
,IIF(hr_emerinfo.pri_cont = 'Y','1','2') as 'EmergencyContactPriority'
,'' as 'SamePhoneasEmployee'
,IIF(hr_emerinfo.emer_ph1 is NOT null,'USA','') as 'CountryISOCode-PrimaryHome'
,IIF(hr_emerinfo.emer_ph1 is NOT null,'1','') as 'InternationalPhoneCode-PrimaryHome'
,ISNULL(hr_emerinfo.emer_ph1,'') as 'PhoneNumber-PrimaryHome'
,'' as 'PhoneExtension-PrimaryHome'
,CASE
   WHEN hr_emerinfo.emer_ph1 is NOT null and LEFT(hr_emerinfo.emer_code1,1)='H' THEN 'Landline'
	WHEN hr_emerinfo.emer_ph1 is NOT null and LEFT(hr_emerinfo.emer_code1,1)='C' THEN 'Mobile'
	ELSE ''
	END as 'PhoneDeviceType-PrimaryHome'
,IIF(hr_emerinfo.emer_ph2 is NOT null,'USA','') as 'CountryISOCode-AdditionalHome_1'
,IIF(hr_emerinfo.emer_ph2 is NOT null,'1','') as 'InternationalPhoneCode-AdditionalHome_1'
,ISNULL(hr_emerinfo.emer_ph2,'') as 'PhoneNumber-AdditionalHome_1'
,'' as 'PhoneExtension-AdditionalHome_1'
,CASE
   WHEN hr_emerinfo.emer_ph2 is not null and LEFT(hr_emerinfo.emer_code2,2)='H' THEN 'Landline'
	WHEN hr_emerinfo.emer_ph2 is not null and LEFT(hr_emerinfo.emer_code2,2)='C' THEN 'Mobile'
	WHEN hr_emerinfo.emer_ph2 is not null  THEN 'Mobile'
	ELSE ''
	END  as 'PhoneDeviceType-AdditionalHome_1'
,IIF(hr_emerinfo.emer_ph2 is not null,'USA','') as 'CountryISOCode-AdditionalHome_2'
,'' as 'InternationalPhoneCode-AdditionalHome_2'
,'' as 'PhoneNumber-AdditionalHome_2'
,'' as 'PhoneExtension-AdditionalHome_2'
,'' as 'PhoneDeviceType-AdditionalHome_2'
,'' as 'CountryISOCode-PrimaryWork'
,'' as 'InternationalPhoneCode-PrimaryWork'
,'' as 'PhoneNumber-PrimaryWork'
,'' as 'PhoneExtension-PrimaryWork'
,'' as 'PhoneDeviceType-PrimaryWork'
,IIF(IIF(charindex('@',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),1),'~','.'))>0 AND 
      charindex('.',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),1),'~','.'))>0,'email',
		IIF(charindex('phone',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),1),'~','.')) >0,'phone','Note'))='phone','USA','') as 'CountryISOCode-AdditionalWork_1'
,IIF(IIF(charindex('@',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),1),'~','.'))>0 AND 
      charindex('.',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),1),'~','.'))>0,'email',
		IIF(charindex('phone',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),1),'~','.')) >0,'phone','Note'))='phone','1','') as 'InternationalPhoneCode-AdditionalWork_1'
, IIF(IIF(charindex('@',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),1),'~','.'))>0 AND 
      charindex('.',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),1),'~','.'))>0,'email',
		IIF(charindex('phone',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),1),'~','.')) >0,'phone','Note'))='phone',
         trim(replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),1),'~','.')),'')  as 'PhoneNumber-AdditionalWork_1'
,'' as 'PhoneExtension-AdditionalWork_1'
,IIF(IIF(charindex('@',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),1),'~','.'))>0 AND 
      charindex('.',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),1),'~','.'))>0,'email',
		IIF(charindex('phone',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),1),'~','.')) >0,'phone','Note'))='phone','MOBILE','') as 'PhoneDeviceType-AdditionalWork_1'
,IIF(IIF(charindex('@',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),2),'~','.'))>0 AND 
      charindex('.',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),2),'~','.'))>0,'email',
		IIF(charindex('phone',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),2),'~','.')) >0,'phone','Note'))='phone','USA','')  as 'CountryISOCode-AdditionalWork_2'
,IIF(IIF(charindex('@',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),2),'~','.'))>0 AND 
      charindex('.',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),2),'~','.'))>0,'email',
		IIF(charindex('phone',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),2),'~','.')) >0,'phone','Note'))='phone','1','') as 'InternationalPhoneCode-AdditionalWork_2'
, IIF(IIF(charindex('@',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),2),'~','.'))>0 AND 
      charindex('.',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),2),'~','.'))>0,'email',
		IIF(charindex('phone',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),2),'~','.')) >0,'phone','Note'))='phone',
         trim(replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),2),'~','.')),'')  as 'PhoneNumber-AdditionalWork_2'
,'' as 'PhoneExtension-AdditionalWork_2'
,IIF(IIF(charindex('@',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),2),'~','.'))>0 AND 
      charindex('.',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),2),'~','.'))>0,'email',
		IIF(charindex('phone',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),2),'~','.')) >0,'phone','Note'))='phone','MOBILE','') as 'PhoneDeviceType-AdditionalWork_2'
, IIF(IIF(charindex('@',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),1),'~','.'))>0 AND 
      charindex('.',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),1),'~','.'))>0,'email',
		IIF(charindex('phone',replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),1),'~','.')) >0,'phone','Note'))='email',
         replace(replace(replace(replace(replace(replace(replace(replace(parsename(replace(replace(replace(replace(hr_emerinfo.notes,'.','~'),' / ','.'),': ',':'),'/','.'),1),'~','.'),' - NIECE',''),'GIRLFRIEND - ',''),'FINANCE - ',''),'FIANCE - ',''),'EMAIL:',''),' (FIANCE)',''),'BROTHER-IN-LAW ; ',''),'') as 'EmailAddress-PrimaryHome'
,'' as 'EmailAddress-PrimaryWork'
,'' as 'EmailAddress-AdditionalHome'
,'' as 'EmailAddress-AdditionalWork'
,'Y' as 'SameAddressasEmployee'
,'USA' as 'CountryISOCode-Home'
,hr_emerinfo.st_1 as 'AddressLine_1-Home'
,'' as 'AddressLine_2-Home'
,hr_emerinfo.CITY as 'City-Home'
,'' as 'CitySubdivision-Home'
,'' as 'CitySubdivision2-Home'
,IIF(hr_emerinfo.state is not null,'USA-'+hr_emerinfo.state,'') as 'Region-Home'
,'' as 'RegionSubdivision-Home'
,'' as 'RegionSubdivision2-Home'
,hr_emerinfo.zip as 'PostalCode-Home'
,'' as 'CountryISOCode-AltHome_1'
,'' as 'AddressLine_1-AltHome_1'
,'' as 'AddressLine_2-AltHome_1'
,'' as 'City-AltHome_1'
,'' as 'CitySubdivision-AltHome_1'
,'' as 'CitySubdivision2-AltHome_1'
,'' as 'Region-AltHome_1'
,'' as 'RegionSubdivision-AltHome_1'
,'' as 'RegionSubdivision2-AltHome_1'
,'' as 'PostalCode-AltHome_1'
,'' as 'DateofBirth'
,'' as 'Gender'
,'' as 'NationalID'
,'' as 'NationalIDType'
,'' as 'EffectiveDate'
,'' as 'Reason'
,'' as 'UsesTobacco'
,'' as 'Full-timeStudent'
,'' as 'DependentforPayrollPurposes'
,'' as 'StudentStatusStartDate'
,'' as 'StudentStatusEndDate'
,'' as 'Disabled'
,'' as 'CouldBeCoveredForHealthCareCoverageElsewhere'
,'' as 'CouldBeCoveredForHealthCareCoverageElsewhereDate'
,'' as 'BenefitCoverageType-Medical'
,'' as 'StartDate-Medical'
,'' as 'EndDate-Medical'
,'' as 'BenefitCoverageType-Dental'
,'' as 'StartDate-Dental'
,'' as 'EndDate-Dental'
,'' as 'BenefitCoverageType-Vision'
,'' as 'StartDate-Vision'
,'' as 'EndDate-Vision'
,99 as ssn_ext
,hr_empmstr.HR_STATUS
,hr_empmstr.ENTITY_ID
from [production_finance].[dbo].hr_empmstr
   RIGHT JOIN [production_finance].[dbo].hr_emerinfo
	ON hr_empmstr.ID  = hr_emerinfo.id
where hr_empmstr.entity_id in ('ROOT','PENS','ZINS')
  AND hr_empmstr.hr_status = 'A'
  AND NOT (hr_emerinfo.emer_ph1 = hr_empmstr.phone_no
  OR hr_emerinfo.st_1 in ('SAME AS EMPLOYEE','SAME AS EMPLOYEES','SAME AS EE')
  OR replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(hr_emerinfo.st_1,'AVENUE',''),'STREET',''),'DRIVE',''),'ROAD',''),'.',''),'RD',''),'CT',''),'ST',''),'AVE',''),'DR',''),'LN',''),'LANE','')
      = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(hr_empmstr.st_1,'AVENUE',''),'STREET',''),'DRIVE',''),'ROAD',''),'.',''),'RD',''),'CT',''),'ST',''),'AVE',''),'DR',''),'LN',''),'LANE',''))
order by hr_empmstr.ID;


insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'USA_Macomb_HCM_CNP_Benefits_Template_07052022 _jdm Questions.xlsx' as Spreadsheet
,'Employee Related Person' as TabName
,'HR_Benefits_Employee_Related_Person' as QueryName
,ISNULL(ROOTCnt,0) as ROOTCNT
,ISNULL(RoadCNT,0) as ROADCNT
,ISNULL(PENSCnt,0) as PENSCNT
,ISNULL(ZINSCNT,0) as ZINSCNT
,ISNULL(ROOTRet,0) as ROOTRet
,ISNULL(ROADRet,0) as ROADRet
,ISNULL(PENSRet,0) as PENSRet
,ISNULL(TotalRecords,0) as TotalRecords
FROM (
select 
IIF(hr_Status = 'I',Entity_id+'RET',Entity_id+'CNT') as ColName
, count(*) as CNT
/* from taken from the main query below*/
from [IT.Macomb_DBA].dbo.Empl_Related_Person  /*  end first union */
  GROUP BY Entity_id, hr_status
UNION ALL /*totals */
select 
'TotalRecords' as ColName
, count(*) as CNT
/* from taken from the main query below*/
from [IT.Macomb_DBA].dbo.Empl_Related_Person) AS Tb2Pivot
/* end of grab*/
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;






/*--- Outputs the Employee Related Person data ---*/
select [EmployeeID]
      ,[Sourcesystem]
      ,[DependentID]
      ,[BeneficiaryID]
      ,[EmergencyContactID]
      ,[RelatedPersonRelationship]
      ,[CountryISOCode_LegalName]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[Prefix]
      ,[Suffix]
      ,[TrustName]
      ,[Language]
      ,[EmergencyContactPriority]
      ,[SamePhoneasEmployee]
      ,[CountryISOCode_PrimaryHome]
      ,[InternationalPhoneCode_PrimaryHome]
      ,[PhoneNumber_PrimaryHome]
      ,[PhoneExtension_PrimaryHome]
      ,[PhoneDeviceType_PrimaryHome]
      ,[CountryISOCode_AdditionalHome_1]
      ,[InternationalPhoneCode_AdditionalHome_1]
      ,[PhoneNumber_AdditionalHome_1]
      ,[PhoneExtension_AdditionalHome_1]
      ,[PhoneDeviceType_AdditionalHome_1]
      ,[CountryISOCode_AdditionalHome_2]
      ,[InternationalPhoneCode_AdditionalHome_2]
      ,[PhoneNumber_AdditionalHome_2]
      ,[PhoneExtension_AdditionalHome_2]
      ,[PhoneDeviceType_AdditionalHome_2]
      ,[CountryISOCode_PrimaryWork]
      ,[InternationalPhoneCode_PrimaryWork]
      ,[PhoneNumber_PrimaryWork]
      ,[PhoneExtension_PrimaryWork]
      ,[PhoneDeviceType_PrimaryWork]
      ,[CountryISOCode_AdditionalWork_1]
      ,[InternationalPhoneCode_AdditionalWork_1]
      ,[PhoneNumber_AdditionalWork_1]
      ,[PhoneExtension_AdditionalWork_1]
      ,[PhoneDeviceType_AdditionalWork_1]
      ,[CountryISOCode_AdditionalWork_2]
      ,[InternationalPhoneCode_AdditionalWork_2]
      ,[PhoneNumber_AdditionalWork_2]
      ,[PhoneExtension_AdditionalWork_2]
      ,[PhoneDeviceType_AdditionalWork_2]
      ,[EmailAddress_PrimaryHome]
      ,[EmailAddress_PrimaryWork]
      ,[EmailAddress_AdditionalHome]
      ,[EmailAddress_AdditionalWork]
      ,[SameAddressasEmployee]
      ,[CountryISOCode_Home]
      ,[AddressLine_1_Home]
      ,[AddressLine_2_Home]
      ,[City_Home]
      ,[CitySubdivision_Home]
      ,[CitySubdivision2_Home]
      ,[Region_Home]
      ,[RegionSubdivision_Home]
      ,[RegionSubdivision2_Home]
      ,[PostalCode_Home]
      ,[CountryISOCode_AltHome_1]
      ,[AddressLine_1_AltHome_1]
      ,[AddressLine_2_AltHome_1]
      ,[City_AltHome_1]
      ,[CitySubdivision_AltHome_1]
      ,[CitySubdivision2_AltHome_1]
      ,[Region_AltHome_1]
      ,[RegionSubdivision_AltHome_1]
      ,[RegionSubdivision2_AltHome_1]
      ,[PostalCode_AltHome_1]
      ,[DateofBirth]
      ,[Gender]
      ,[NationalID]
      ,[NationalIDType]
      ,[EffectiveDate]
      ,[Reason]
      ,[UsesTobacco]
      ,[Full_timeStudent]
      ,[DependentforPayrollPurposes]
      ,[StudentStatusStartDate]
      ,[StudentStatusEndDate]
      ,[Disabled]
      ,[CouldBeCoveredForHealthCareCoverageElsewhere]
      ,[CouldBeCoveredForHealthCareCoverageElsewhereDate]
      ,[BenefitCoverageType_Medical]
      ,[StartDate_Medical]
      ,[EndDate_Medical]
      ,[BenefitCoverageType_Dental]
      ,[StartDate_Dental]
      ,[EndDate_Dental]
      ,[BenefitCoverageType_Vision]
      ,[StartDate_Vision]
      ,[EndDate_Vision] 
from [IT.Macomb_DBA].dbo.Empl_Related_Person
order by employeeid, SSN_EXT
