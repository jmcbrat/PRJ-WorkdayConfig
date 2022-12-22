/*HCM_BENEFITS_Historical_Health_Care_ACA*/
/*-------
dependent on table being created from Employee Related Person
Table: [IT.Macomb_DBA].dbo.Empl_Related_Person
---------
*/
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'USA_Macomb_HCM_CNP_Benefits_Template_07052022 _jdm Questions.xlsx' as Spreadsheet
,'Historical Health Care-ACA' as TabName
,'HCM_BENEFITS_Health_Savings_Elections_ACA' as QueryName
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
IIF(hr_empmstr.hr_Status = 'I',hr_empmstr.Entity_id+'RET',hr_empmstr.Entity_id+'CNT') as ColName
, count(*) as CNT
/* from taken from the main query below*/
FROM [production_finance].[dbo].hr_empmstr

	RIGHT JOIN [production_finance].[dbo].hr_beneinfo ON hr_empmstr.id = hr_beneinfo.id
	  AND hr_beneinfo.bene_end = '12/31/2050'
WHERE hr_empmstr.Entity_id in ('ROOT','PENS','ZINS')
  AND hr_empmstr.hr_status = 'A'
  
  AND hr_beneinfo.bene_plan IN ('MBHDER1E'/*,'MBHDER2E','MBHDER3E'*/,'MBP6ER1E'/*,'MBP6ER2E','MBP6ER3E'*/,'MBCPER1R'/*,'MBCPER2R','MBCPER3R'*/,'MBNSER1R'/*,'MBNSER2R','MBNSER3R'*/,'MHP2ER1E'/*,'MHP2ER2E','MHP2ER3E'*/
      ,'MMCRER1C'/*,'MMCRER2C'*/,'MHPSER1R'/*,'MHPSER2R','MHPSER3R'*/,'DDDPER1E'/*,'DDDPER2E','DDDPER3E'*/
		,'DDPRAT1E'/*,'DDPRAT2E','DDPRAT3E'*/,'DDPRAT1R'/*,'DDPRAT2R'*/,'DDDPAT1S'/*,'DDDPAT2S'*/,'DDMAT1R'
		/*,'DDMAT2R'*/,'DDMAT1S'/*,'DDMAT2A','DDMATSS'*/,'DGDPER1E'/*,'DGDPER2E','DGDPER3E'*/,'DGDPAT1E'
		/*,'DGDPAT2E','DGDPAT3E'*/,'DGDPER1R'/*,'DGDPER2R','DGDPER1S'*/,'VBCVER1E'/*,'VBCVER2E','VBCVER3E'*/
		,'VBCSAT1R'/*,'VBCSAT2R','VBCSAT1S','VBCSAT2S'*/,'HAUDAT1R'/*,'HAUDAT2R'*/
		/*,'MNTENANA', 'MBONERMC','MARRNANA'*/  /* Opt out of coverage (not qualified, medical bonus and spouse of employee)*/
		,'MBCPER1R'/*,'MBCPER2R','MBCPER3R'*/,'MBCNER1R'/*,'MBCNER2R','MBCNER3R'*/ /*these two lines are ones needing details*/
		,'MHP2ER1E'/*,'MHP2ER2E','MHP2ER3E'*/,'MHPSER1R'/*,'MHPSER2R','MHPSER3R'*/) /*these two lines are ones needing details*/
/* end of grab */
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL
select 
IIF(hr_empmstr.hr_Status = 'I',hr_empmstr.Entity_id+'RET',hr_empmstr.Entity_id+'CNT') as ColName
, count(*) as CNT
/* from taken from the main query below*/
FROM [production_finance].[dbo].hr_empmstr
	RIGHT JOIN [IT.Macomb_DBA].dbo.Empl_Related_Person
	  ON hr_empmstr.id = Empl_Related_Person.EmployeeID
	     AND Empl_Related_Person.DependentID is not null
	RIGHT JOIN [production_finance].[dbo].hr_beneinfo ON Empl_Related_Person.EmployeeID = hr_beneinfo.id
	  AND hr_beneinfo.bene_end = '12/31/2050'
	RIGHT JOIN [production_finance].[dbo].HR_depdbenf ON Empl_Related_Person.EmployeeID = HR_depdbenf.ID 
	  AND  HR_depdbenf.enddt = '12/31/2050'
	  and HR_depdbenf.benecode = left(hr_beneinfo.bene_plan,4)
	  and HR_depdbenf.family_key = Empl_Related_Person.ssn_ext
WHERE hr_empmstr.Entity_id in ('ROOT','PENS','ZINS')
  AND hr_empmstr.hr_status = 'A'
  
  AND hr_beneinfo.bene_plan IN (/*'MBHDER1E',*/'MBHDER2E','MBHDER3E'/*,'MBP6ER1E'*/,'MBP6ER2E','MBP6ER3E'/*,'MBCPER1R'*/,'MBCPER2R','MBCPER3R'/*,'MBNSER1R'*/,'MBNSER2R','MBNSER3R'/*,'MHP2ER1E'*/,'MHP2ER2E','MHP2ER3E'
      /*,'MMCRER1C'*/,'MMCRER2C'/*,'MHPSER1R'*/,'MHPSER2R','MHPSER3R'/*,'DDDPER1E'*/,'DDDPER2E','DDDPER3E'
		/*,'DDPRAT1E'*/,'DDPRAT2E','DDPRAT3E'/*,'DDPRAT1R'*/,'DDPRAT2R'/*,'DDDPAT1S'*/,'DDDPAT2S'/*,'DDMAT1R'*/
		,'DDMAT2R'/*,'DDMAT1S'*/,'DDMAT2A','DDMATSS'/*,'DGDPER1E'*/,'DGDPER2E','DGDPER3E'/*,'DGDPAT1E'*/
		,'DGDPAT2E','DGDPAT3E'/*,'DGDPER1R'*/,'DGDPER2R','DGDPER1S'/*,'VBCVER1E'*/,'VBCVER2E','VBCVER3E'
		/*,'VBCSAT1R'*/,'VBCSAT2R'/*,'VBCSAT1S'*/,'VBCSAT2S'/*,'HAUDAT1R'*/,'HAUDAT2R'
		/*,'MBCPER1R'*/,'MBCPER2R','MBCPER3R'/*,'MBCNER1R'*/,'MBCNER2R','MBCNER3R' /*these two lines are cone needing details*/
		/*,'MHP2ER1E'*/,'MHP2ER2E','MHP2ER3E'/*,'MHPSER1R'*/,'MHPSER2R','MHPSER3R') /*these two lines are cone needing details*/
/* end of grab */
GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status

UNION ALL
select 
'TotalRecords' as ColName
, count(*) as CNT
/* from taken from the main query below*/
FROM [production_finance].[dbo].hr_empmstr
	RIGHT JOIN [IT.Macomb_DBA].dbo.Empl_Related_Person
	  ON hr_empmstr.id = Empl_Related_Person.EmployeeID
	     AND Empl_Related_Person.DependentID is not null
	RIGHT JOIN [production_finance].[dbo].hr_beneinfo ON Empl_Related_Person.EmployeeID = hr_beneinfo.id
	  AND hr_beneinfo.bene_end = '12/31/2050'
	RIGHT JOIN [production_finance].[dbo].HR_depdbenf ON Empl_Related_Person.EmployeeID = HR_depdbenf.ID 
	  AND  HR_depdbenf.enddt = '12/31/2050'
	  and HR_depdbenf.benecode = left(hr_beneinfo.bene_plan,4)
	  and HR_depdbenf.family_key = Empl_Related_Person.ssn_ext
WHERE hr_empmstr.Entity_id in ('ROOT','PENS','ZINS')
  AND hr_empmstr.hr_status = 'A'
  
  AND hr_beneinfo.bene_plan IN (/*'MBHDER1E',*/'MBHDER2E','MBHDER3E'/*,'MBP6ER1E'*/,'MBP6ER2E','MBP6ER3E'/*,'MBCPER1R'*/,'MBCPER2R','MBCPER3R'/*,'MBNSER1R'*/,'MBNSER2R','MBNSER3R'/*,'MHP2ER1E'*/,'MHP2ER2E','MHP2ER3E'
      /*,'MMCRER1C'*/,'MMCRER2C'/*,'MHPSER1R'*/,'MHPSER2R','MHPSER3R'/*,'DDDPER1E'*/,'DDDPER2E','DDDPER3E'
		/*,'DDPRAT1E'*/,'DDPRAT2E','DDPRAT3E'/*,'DDPRAT1R'*/,'DDPRAT2R'/*,'DDDPAT1S'*/,'DDDPAT2S'/*,'DDMAT1R'*/
		,'DDMAT2R'/*,'DDMAT1S'*/,'DDMAT2A','DDMATSS'/*,'DGDPER1E'*/,'DGDPER2E','DGDPER3E'/*,'DGDPAT1E'*/
		,'DGDPAT2E','DGDPAT3E'/*,'DGDPER1R'*/,'DGDPER2R','DGDPER1S'/*,'VBCVER1E'*/,'VBCVER2E','VBCVER3E'
		/*,'VBCSAT1R'*/,'VBCSAT2R'/*,'VBCSAT1S'*/,'VBCSAT2S'/*,'HAUDAT1R'*/,'HAUDAT2R'
		/*,'MBCPER1R'*/,'MBCPER2R','MBCPER3R'/*,'MBCNER1R'*/,'MBCNER2R','MBCNER3R' /*these two lines are cone needing details*/
		/*,'MHP2ER1E'*/,'MHP2ER2E','MHP2ER3E'/*,'MHPSER1R'*/,'MHPSER2R','MHPSER3R') /*these two lines are cone needing details*/
/*END of Grab*/
UNION ALL
select 
'TotalRecords' as ColName
, count(*) as CNT
/* from taken from the main query below*/
FROM [production_finance].[dbo].hr_empmstr

	RIGHT JOIN [production_finance].[dbo].hr_beneinfo ON hr_empmstr.id = hr_beneinfo.id
	  AND hr_beneinfo.bene_end = '12/31/2050'
WHERE hr_empmstr.Entity_id in ('ROOT','PENS','ZINS')
  AND hr_empmstr.hr_status = 'A'
  
  AND hr_beneinfo.bene_plan IN ('MBHDER1E'/*,'MBHDER2E','MBHDER3E'*/,'MBP6ER1E'/*,'MBP6ER2E','MBP6ER3E'*/,'MBCPER1R'/*,'MBCPER2R','MBCPER3R'*/,'MBNSER1R'/*,'MBNSER2R','MBNSER3R'*/,'MHP2ER1E'/*,'MHP2ER2E','MHP2ER3E'*/
      ,'MMCRER1C'/*,'MMCRER2C'*/,'MHPSER1R'/*,'MHPSER2R','MHPSER3R'*/,'DDDPER1E'/*,'DDDPER2E','DDDPER3E'*/
		,'DDPRAT1E'/*,'DDPRAT2E','DDPRAT3E'*/,'DDPRAT1R'/*,'DDPRAT2R'*/,'DDDPAT1S'/*,'DDDPAT2S'*/,'DDMAT1R'
		/*,'DDMAT2R'*/,'DDMAT1S'/*,'DDMAT2A','DDMATSS'*/,'DGDPER1E'/*,'DGDPER2E','DGDPER3E'*/,'DGDPAT1E'
		/*,'DGDPAT2E','DGDPAT3E'*/,'DGDPER1R'/*,'DGDPER2R','DGDPER1S'*/,'VBCVER1E'/*,'VBCVER2E','VBCVER3E'*/
		,'VBCSAT1R'/*,'VBCSAT2R','VBCSAT1S','VBCSAT2S'*/,'HAUDAT1R'/*,'HAUDAT2R'*/
		/*,'MNTENANA', 'MBONERMC','MARRNANA'*/  /* Opt out of coverage (not qualified, medical bonus and spouse of employee)*/
		,'MBCPER1R'/*,'MBCPER2R','MBCPER3R'*/,'MBCNER1R'/*,'MBCNER2R','MBCNER3R'*/ /*these two lines are ones needing details*/
		,'MHP2ER1E'/*,'MHP2ER2E','MHP2ER3E'*/,'MHPSER1R'/*,'MHPSER2R','MHPSER3R'*/) /*these two lines are ones needing details*/
/* End of second grab*/
) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;


/*employee*/
SELECT
trim(hr_empmstr.id) as 'EmployeeID'
,'Employee only- Jen Smiley' as 'SourceSystem'
,CASE
  --WHEN hr_empmstr.hdt > '12/31/2021' THEN replace(convert(varchar,hr_empmstr.hdt,106),' ','-') -- hired this year
  WHEN hr_beneinfo.bene_end> convert(date,'12/31/2021') 
       AND hr_beneinfo.bene_end < convert(date,'1/1/2023')
		 THEN replace(convert(varchar,hr_beneinfo.bene_end,106),' ','-')  -- term this year
  WHEN hr_beneinfo.bene_beg < convert(date,'1/1/2022') THEN replace(convert(varchar,hr_beneinfo.bene_beg,106),' ','-')
  ELSE ''
  END as 'EventDate'
,IIF(hr_beneinfo.bene_plan in ('MNTENANA', 'MBONERMC','MARRNANA'),'Y','N') as 'Waived' -- opt'd to skip this round....
,CASE
  WHEN hr_beneinfo.bene_plan IN ('MBHDER1E','MBHDER2E','MBHDER3E') THEN 'Medical - HDHP'
  WHEN hr_beneinfo.bene_plan IN ('MBP6ER1E','MBP6ER2E','MBP6ER3E') THEN 'Spouse'
  WHEN hr_beneinfo.bene_plan IN ('MBCPER1R','MBCPER2R','MBCPER3R') THEN 'Spouse' /*FIX THIS*/
  /*---need correct workday code---*/
  WHEN hr_beneinfo.bene_plan IN ('MBPSER1R','MBPSER2R','MBPSER3R') THEN 'Medical - PPO with Non Medicare' 
  WHEN hr_beneinfo.bene_plan IN ('MBN3ER1R','MBN3ER2R','MBN3ER3R') THEN 'Medical - HMO Blue Care' /*Fix This*/
  WHEN hr_beneinfo.bene_plan IN ('MBCNER1R','MBCNER2R','MBCNER3R') THEN 'Medical - HMO Blue Care'
  WHEN hr_beneinfo.bene_plan IN ('MBNSER1R','MBNSER2R','MBNSER3R') THEN 'Medical - HMO Blue Care'
  /*---need correct workday code---*/
  WHEN hr_beneinfo.bene_plan IN ('MHP2ER1E','MHP2ER2E','MHP2ER3E') THEN 'Medical - PPO Health Alliance' 
  WHEN hr_beneinfo.bene_plan IN ('MMCRER1C','MMCRER2C')            THEN 'Medical - PPO Medicare Advantage'
  /*---need correct workday code---*/
  WHEN hr_beneinfo.bene_plan IN ('MHPSER1R','MHPSER2R','MHPSER3R') THEN 'Medical - PPO Health Alliance' 
  WHEN hr_beneinfo.bene_plan IN ('DDDPER1E','DDDPER2E','DDDPER3E', 
                                 'DDPRAT1E','DDPRAT2E','DDPRAT3E',
											'DDPRAT1R','DDPRAT2R',
											'DDDPAT1S','DDDPAT2S',
											'DDMAT1R','DDMAT2R', 
											'DDMAT1S','DDMAT2A','DDMATSS')     THEN 'Dental - DPO'
  WHEN hr_beneinfo.bene_plan IN ('DGDPER1E','DGDPER2E','DGDPER3E',
                                 'DGDPAT1E','DGDPAT2E','DGDPAT3E',
											'DGDPER1R','DGDPER2R','DGDPER1S')  THEN 'Dental - DMO'
  WHEN hr_beneinfo.bene_plan IN ('VBCVER1E','VBCVER2E','VBCVER3E',
                                 'VBCSAT1R','VBCSAT2R','VBCSAT1S',
											'VBCSAT2S')                        THEN 'Vision - VIS'
  WHEN hr_beneinfo.bene_plan IN ('HAUDAT1R','HAUDAT2R')             THEN 'Hearing'
  WHEN hr_beneinfo.bene_plan in ('MNTENANA', 'MBONERMC','MARRNANA') THEN 'MedicalWaived'
  ELSE '' 
  END as 'HealthCareCoveragePlan'
 /*--- validate closely could be wrong ---*/
,CASE 
  WHEN CONVERT(int,ROUND(DATEDIFF(hour,hr_empmstr.BDT,GETDATE())/8766.0,0))>=65 
    AND left(right(hr_beneinfo.bene_plan,2),1)='1' THEN 'MedicareRet_Dep'
  WHEN CONVERT(int,ROUND(DATEDIFF(hour,hr_empmstr.BDT,GETDATE())/8766.0,0))>=65 
    AND left(right(hr_beneinfo.bene_plan,2),1)='2' THEN 'MedicareRet_2Dep'
  WHEN CONVERT(int,ROUND(DATEDIFF(hour,hr_empmstr.BDT,GETDATE())/8766.0,0))>=65 
    AND left(right(hr_beneinfo.bene_plan,2),1)='2' THEN 'MedicareRet_3Dep'
  WHEN left(right(hr_beneinfo.bene_plan,2),1)='1' THEN '1Person'
  WHEN left(right(hr_beneinfo.bene_plan,2),1)='2' THEN '2Person'
  WHEN left(right(hr_beneinfo.bene_plan,2),1)='3' THEN 'Family'
  WHEN left(right(hr_beneinfo.bene_plan,2),1)='S' THEN '1Person'
  ELSE ''
  END as 'HealthCareCoverageTarget'
,''  as 'DependentID'
/*hr_family.id + hr_family.family_tp=DEPN*/
FROM [production_finance].[dbo].hr_empmstr

	RIGHT JOIN [production_finance].[dbo].hr_beneinfo ON hr_empmstr.id = hr_beneinfo.id
	  AND hr_beneinfo.bene_end = '12/31/2050'
WHERE hr_empmstr.Entity_id in ('ROOT','PENS','ZINS')
  AND hr_empmstr.hr_status = 'A'
  
  AND hr_beneinfo.bene_plan IN ('MBHDER1E'/*,'MBHDER2E','MBHDER3E'*/,'MBP6ER1E'/*,'MBP6ER2E','MBP6ER3E'*/,'MBCPER1R'/*,'MBCPER2R','MBCPER3R'*/,'MBNSER1R'/*,'MBNSER2R','MBNSER3R'*/,'MHP2ER1E'/*,'MHP2ER2E','MHP2ER3E'*/
      ,'MMCRER1C'/*,'MMCRER2C'*/,'MHPSER1R'/*,'MHPSER2R','MHPSER3R'*/,'DDDPER1E'/*,'DDDPER2E','DDDPER3E'*/
		,'DDPRAT1E'/*,'DDPRAT2E','DDPRAT3E'*/,'DDPRAT1R'/*,'DDPRAT2R'*/,'DDDPAT1S'/*,'DDDPAT2S'*/,'DDMAT1R'
		/*,'DDMAT2R'*/,'DDMAT1S'/*,'DDMAT2A','DDMATSS'*/,'DGDPER1E'/*,'DGDPER2E','DGDPER3E'*/,'DGDPAT1E'
		/*,'DGDPAT2E','DGDPAT3E'*/,'DGDPER1R'/*,'DGDPER2R','DGDPER1S'*/,'VBCVER1E'/*,'VBCVER2E','VBCVER3E'*/
		,'VBCSAT1R'/*,'VBCSAT2R','VBCSAT1S','VBCSAT2S'*/,'HAUDAT1R'/*,'HAUDAT2R'*/
		/*,'MNTENANA', 'MBONERMC','MARRNANA'*/  /* Opt out of coverage (not qualified, medical bonus and spouse of employee)*/
		,'MBCPER1R'/*,'MBCPER2R','MBCPER3R'*/,'MBCNER1R'/*,'MBCNER2R','MBCNER3R'*/ /*these two lines are ones needing details*/
		,'MHP2ER1E'/*,'MHP2ER2E','MHP2ER3E'*/,'MHPSER1R'/*,'MHPSER2R','MHPSER3R'*/) /*these two lines are ones needing details*/


union all

/*depentents*/
SELECT
trim(hr_empmstr.id) as 'EmployeeID'
,'Dependent- Jen Smiley' as 'SourceSystem'
/*,2 scenarios for beginnning coverage or having coverage ended, as follows:
On employee record:
1) If (hr_beneinfo.bene_end (for coverage) > 12/31/2021 and hr_beneinfo.bene_end <  01/01/2023) then use hr_beneinfo.bene_end as Event Date
2) If hr_beneinfo.bene_beg > 01/01/2022, use hr_beneinfo.bene_beg date as the Event Date 

On dependent coverage record:
1) If (hr_depdbenf.enddt > 12/31/2021 and hr_depdbenf.enddt < 01/01/2023 then use hr.depdbenf.enddate as Event Date
2) If hr_depdbenf.begdt > 01/01/2022, use hr_depdbenf.begdt as Event Date
See note below for further explanation */

,CASE
  --WHEN hr_empmstr.hdt > '12/31/2021' THEN replace(convert(varchar,hr_empmstr.hdt,106),' ','-') -- hired this year
  WHEN hr_depdbenf.enddt> convert(date,'12/31/2021') 
       AND hr_depdbenf.enddt < convert(date,'1/1/2023')
		 THEN replace(convert(varchar,hr_depdbenf.enddt,106),' ','-')  --emp term this year
  WHEN hr_depdbenf.begdt < convert(date,'1/1/2022') THEN replace(convert(varchar,hr_depdbenf.begdt,106),' ','-')
  ELSE ''
  END as 'EventDate'
,IIF(hr_beneinfo.bene_plan in ('MNTENANA', 'MBONERMC','MARRNANA'),'Y','N') as 'Waived' -- opt'd to skip this round....
,CASE
  WHEN hr_beneinfo.bene_plan IN ('MBHDER1E','MBHDER2E','MBHDER3E') THEN 'Medical - HDHP'
  WHEN hr_beneinfo.bene_plan IN ('MBP6ER1E','MBP6ER2E','MBP6ER3E') THEN 'Spouse'
  WHEN hr_beneinfo.bene_plan IN ('MBCPER1R','MBCPER2R','MBCPER3R') THEN 'Spouse' /*FIX THIS*/
  /*---need correct workday code---*/
  WHEN hr_beneinfo.bene_plan IN ('MBPSER1R','MBPSER2R','MBPSER3R') THEN 'Medical - PPO with Non Medicare' 
  WHEN hr_beneinfo.bene_plan IN ('MBN3ER1R','MBN3ER2R','MBN3ER3R') THEN 'Medical - HMO Blue Care' /*Fix This*/
  WHEN hr_beneinfo.bene_plan IN ('MBCNER1R','MBCNER2R','MBCNER3R') THEN 'Medical - HMO Blue Care'
  WHEN hr_beneinfo.bene_plan IN ('MBNSER1R','MBNSER2R','MBNSER3R') THEN 'Medical - HMO Blue Care'
  /*---need correct workday code---*/
  WHEN hr_beneinfo.bene_plan IN ('MHP2ER1E','MHP2ER2E','MHP2ER3E') THEN 'Medical - PPO Health Alliance' 
  WHEN hr_beneinfo.bene_plan IN ('MMCRER1C','MMCRER2C')            THEN 'Medical - PPO Medicare Advantage'
  /*---need correct workday code---*/
  WHEN hr_beneinfo.bene_plan IN ('MHPSER1R','MHPSER2R','MHPSER3R') THEN 'Medical - PPO Health Alliance' 
  WHEN hr_beneinfo.bene_plan IN ('DDDPER1E','DDDPER2E','DDDPER3E', 
                                 'DDPRAT1E','DDPRAT2E','DDPRAT3E',
											'DDPRAT1R','DDPRAT2R',
											'DDDPAT1S','DDDPAT2S',
											'DDMAT1R','DDMAT2R', 
											'DDMAT1S','DDMAT2A','DDMATSS')     THEN 'Dental - DPO'
  WHEN hr_beneinfo.bene_plan IN ('DGDPER1E','DGDPER2E','DGDPER3E',
                                 'DGDPAT1E','DGDPAT2E','DGDPAT3E',
											'DGDPER1R','DGDPER2R','DGDPER1S')  THEN 'Dental - DMO'
  WHEN hr_beneinfo.bene_plan IN ('VBCVER1E','VBCVER2E','VBCVER3E',
                                 'VBCSAT1R','VBCSAT2R','VBCSAT1S',
											'VBCSAT2S')                        THEN 'Vision - VIS'
  WHEN hr_beneinfo.bene_plan IN ('HAUDAT1R','HAUDAT2R')             THEN 'Hearing'
  WHEN hr_beneinfo.bene_plan in ('MNTENANA', 'MBONERMC','MARRNANA') THEN 'MedicalWaived'
  ELSE '' 
  END as 'HealthCareCoveragePlan'
 /*--- validate closely could be wrong ---*/
,CASE 
  WHEN CONVERT(int,ROUND(DATEDIFF(hour,hr_empmstr.BDT,GETDATE())/8766.0,0))>=65 
    AND left(right(hr_beneinfo.bene_plan,2),1)='1' THEN 'MedicareRet_Dep'
  WHEN CONVERT(int,ROUND(DATEDIFF(hour,hr_empmstr.BDT,GETDATE())/8766.0,0))>=65 
    AND left(right(hr_beneinfo.bene_plan,2),1)='2' THEN 'MedicareRet_2Dep'
  WHEN CONVERT(int,ROUND(DATEDIFF(hour,hr_empmstr.BDT,GETDATE())/8766.0,0))>=65 
    AND left(right(hr_beneinfo.bene_plan,2),1)='2' THEN 'MedicareRet_3Dep'
  WHEN left(right(hr_beneinfo.bene_plan,2),1)='1' THEN '1Person'
  WHEN left(right(hr_beneinfo.bene_plan,2),1)='2' THEN '2Person'
  WHEN left(right(hr_beneinfo.bene_plan,2),1)='3' THEN 'Family'
  WHEN left(right(hr_beneinfo.bene_plan,2),1)='S' THEN '1Person'
  ELSE ''
  END as 'HealthCareCoverageTarget'
,Empl_Related_Person.dependentid  as 'DependentID'
/*hr_family.id + hr_family.family_tp=DEPN*/
FROM [production_finance].[dbo].hr_empmstr
	RIGHT JOIN [IT.Macomb_DBA].dbo.Empl_Related_Person
	  ON hr_empmstr.id = Empl_Related_Person.EmployeeID
	     AND Empl_Related_Person.DependentID is not null
	RIGHT JOIN [production_finance].[dbo].hr_beneinfo ON Empl_Related_Person.EmployeeID = hr_beneinfo.id
	  AND hr_beneinfo.bene_end = '12/31/2050'
	RIGHT JOIN [production_finance].[dbo].HR_depdbenf ON Empl_Related_Person.EmployeeID = HR_depdbenf.ID 
	  AND  HR_depdbenf.enddt = '12/31/2050'
	  and HR_depdbenf.benecode = left(hr_beneinfo.bene_plan,4)
	  and HR_depdbenf.family_key = Empl_Related_Person.ssn_ext
WHERE hr_empmstr.Entity_id in ('ROOT','PENS','ZINS')
  AND hr_empmstr.hr_status = 'A'
  
  AND hr_beneinfo.bene_plan IN (/*'MBHDER1E',*/'MBHDER2E','MBHDER3E'/*,'MBP6ER1E'*/,'MBP6ER2E','MBP6ER3E'/*,'MBCPER1R'*/,'MBCPER2R','MBCPER3R'/*,'MBNSER1R'*/,'MBNSER2R','MBNSER3R'/*,'MHP2ER1E'*/,'MHP2ER2E','MHP2ER3E'
      /*,'MMCRER1C'*/,'MMCRER2C'/*,'MHPSER1R'*/,'MHPSER2R','MHPSER3R'/*,'DDDPER1E'*/,'DDDPER2E','DDDPER3E'
		/*,'DDPRAT1E'*/,'DDPRAT2E','DDPRAT3E'/*,'DDPRAT1R'*/,'DDPRAT2R'/*,'DDDPAT1S'*/,'DDDPAT2S'/*,'DDMAT1R'*/
		,'DDMAT2R'/*,'DDMAT1S'*/,'DDMAT2A','DDMATSS'/*,'DGDPER1E'*/,'DGDPER2E','DGDPER3E'/*,'DGDPAT1E'*/
		,'DGDPAT2E','DGDPAT3E'/*,'DGDPER1R'*/,'DGDPER2R','DGDPER1S'/*,'VBCVER1E'*/,'VBCVER2E','VBCVER3E'
		/*,'VBCSAT1R'*/,'VBCSAT2R'/*,'VBCSAT1S'*/,'VBCSAT2S'/*,'HAUDAT1R'*/,'HAUDAT2R'
		/*,'MBCPER1R'*/,'MBCPER2R','MBCPER3R'/*,'MBCNER1R'*/,'MBCNER2R','MBCNER3R' /*these two lines are cone needing details*/
		/*,'MHP2ER1E'*/,'MHP2ER2E','MHP2ER3E'/*,'MHPSER1R'*/,'MHPSER2R','MHPSER3R') /*these two lines are cone needing details*/

ORDER BY 1
