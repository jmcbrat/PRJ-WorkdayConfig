--PayCommon_Pay Group Assignments
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'PayCommon_Pay ' as Spreadsheet
,'Group Assignments' as TabName
,'PayCommon_Pay Group Assignments' as QueryName
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
FROM [production_finance].[dbo].[hr_empmstr]
     right join [production_finance].[dbo].[hr_emppay] 
       on hr_empmstr.id = hr_emppay.id 
		 and hr_emppay.pay_beg = (select max(e2.pay_beg) from [production_finance].[dbo].[hr_emppay] e2 where hr_empmstr.id = e2.id)
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
    AND (hr_empmstr.hr_status = 'A'
    OR (hr_empmstr.hr_status = 'I' AND hr_empmstr.ENDDT>'12/31/2021'
	 and hr_empmstr.termcode <> 'NVST'))

/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
FROM [production_finance].[dbo].[hr_empmstr]
     right join [production_finance].[dbo].[hr_emppay] 
       on hr_empmstr.id = hr_emppay.id 
		 and hr_emppay.pay_beg = (select max(e2.pay_beg) from [production_finance].[dbo].[hr_emppay] e2 where hr_empmstr.id = e2.id)
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
    AND (hr_empmstr.hr_status = 'A'
    OR (hr_empmstr.hr_status = 'I' AND hr_empmstr.ENDDT>'12/31/2021'
	 and hr_empmstr.termcode <> 'NVST'))

/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;







SELECT 
	trim(hr_empmstr.id) as 'EmployeeID'
	,'Steve Smigiel' AS 'SourceSystem'
	,'01-JAN-2022'  as 'EffectiveDate'
	,CASE 
		WHEN hr_empmstr.entity_id = 'PENS' THEN 'Monthly' -- Retiree
		WHEN hr_empmstr.entity_id = 'ROOT' and hr_empmstr.type = 'EO' THEN 'Elected' -- Elected 
		WHEN hr_empmstr.entity_id = 'ROOT' and hr_emppay.PAYCLASS = '008' THEN 'Executive' -- Exec
		WHEN hr_empmstr.entity_id = 'ROOT' and hr_empmstr.id = 'E018194' THEN 'Executive' -- Exec
		ELSE 'Biweekly' -- rest of roots
		END AS 'PayGroupID'
--,hr_empmstr.*
FROM [production_finance].[dbo].[hr_empmstr]
     right join [production_finance].[dbo].[hr_emppay] 
       on hr_empmstr.id = hr_emppay.id 
		 and hr_emppay.pay_beg = (select max(e2.pay_beg) from [production_finance].[dbo].[hr_emppay] e2 where hr_empmstr.id = e2.id)
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
    AND (hr_empmstr.hr_status = 'A'
    OR (hr_empmstr.hr_status = 'I' AND hr_empmstr.ENDDT>'12/31/2021'
	 and hr_empmstr.termcode <> 'NVST'))
/*  and hr_empmstr.id in(/*line 185*/
  'C000036     ','C000280     ','C000388     ','C000390     ','C000476     ','C000500     ','C000603     ','C000608     ','C000751     ','C000758     ','C001021     ','C001225     ','C001236     ','C001249     ','C001254     ','E001212     ','E001522     ','E001727     ','E001995     ','E002027     ','E002277     ','E002468     ','E002508     ','E002620     ','E002718     ','E003266     ','E004032     ','E004040     ','E004204     ','E004222     ','E004451     ','E004536     ','E004988     ','E005293     ','E005331     ','E005440     ','E005510     ','E005575     ','E005579     ','E005585     ','E005774     ','E005776     ','E005783     ','E005808     ','E005990     ','E006098     ','E006183     ','E006301     ','E006308     ','E006582     ','E006671     ','E006731     ','E006877     ','E006908     ','E006969     ','E007127     ','E007153     ','E007401     ','E007613     ','E007651     ','E007948     ','E007999     ','E008139     ','E008655     ','E009239     ','E009545     ','E010154     ','E016969     ','E017258     ','E017915     ','E018159     ','E018278     ','E018450     ','E018884     ','E019009     ','E019186     ','E019204     ','E019468     ','E019715     ','E019916     ','E019921     ','E020033     ','E020059     ','E020078     ','E020082     ','E020294     ','E020470     ','E020542     ','E020669     ','E020871     ','E020908     ','E020975     ','E020989     ','E021007     ','E021041     ','E021172     ','E021203     ','E021217     ','E021235     ','E021350     ','E021379     ','E021393     ','E021455     ','E021525     ','E021548     ','E021564     ','E021580     ','E021608     ','E021621     ','E021632     ','E021639     ','E021669     ','E021697     ','E021740     ','E021748     ','E021794     ','E021800     ','E021826     ','E021831     ','E021837     ','E021870     ','E021876     ','E021909     ','E021927     ','E021931     ','E021950     ','E021977     ','E021983     ','E021984     ','E022009     ','E022013     ','E022018     ','E022033     ','E022048     ','E022053     ','E022057     ','E022061     ','E022077'
  )*/
order by 1