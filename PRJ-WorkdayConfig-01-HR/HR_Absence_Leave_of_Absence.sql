/*HR_Absence_Leave_of_Absence*/
;with LeaveofAbs_lite_CTE 
AS (select hr_empmstr.entity_id, hr_empmstr.hr_status
,trim(hr_empmstr.id) as 'WorkerID'
,CASE
	WHEN hr_leavinfo.leav_code = 'EDL' THEN  'Personal Leave'
	WHEN hr_leavinfo.leav_code = 'FSL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'IFL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'IPL' THEN  'Personal Leave'
	WHEN hr_leavinfo.leav_code = 'ISL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'MIL' THEN  'Military Leave'
	WHEN hr_leavinfo.leav_code = 'PRL' THEN  'Personal Leave'
	WHEN hr_leavinfo.leav_code = 'SKL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'WCL' THEN  'Worker Compensation'
	ELSE hr_leavinfo.leav_code
	END as 'LeaveType'
,replace(convert(varchar, hr_leavinfo.startdt, 106),' ','-') as 'FirstDayofLeave'
FROM 	  [production_finance].[dbo].[hr_empmstr]
  RIGHT JOIN [production_finance].[dbo].[hr_leavinfo]
    ON hr_empmstr.id = hr_leavinfo.id
	 and hr_leavinfo.leav_code in ('EDL','FSL','IFL','IPL','ISL','MIL','PRL','SKL','WCL')
	 and hr_leavinfo.apprvdate is not null
	 and hr_leavinfo.startdt is not null
	 and hr_leavinfo.startdt in (SELECT max(l.startdt) from [production_finance].[dbo].[hr_leavinfo] l Where hr_leavinfo.id = l.id and hr_leavinfo.leav_code = l.leav_code)
where 
 hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT', 'ROAD')
 )
 insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'USA_Macomb_HCM_CNP_Absence_Template_half Mapped' as Spreadsheet
,'Leave of Absence' as TabName
,'HR_EMP_VET_ID' as QueryName
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
IIF(LeaveofAbs_lite_CTE.hr_Status = 'I',LeaveofAbs_lite_CTE.Entity_id+'RET',LeaveofAbs_lite_CTE.Entity_id+'CNT') as ColName
, count(*) as CNT
/* from taken from the main query below*/
 FROM LeaveofAbs_lite_CTE
 where LeaveofAbs_lite_CTE.firstdayOfLeave in (select max(y.firstdayOfLeave) FROM (
select
trim(hr_empmstr.id) as 'WorkerID'
,CASE
	WHEN hr_leavinfo.leav_code = 'EDL' THEN  'Personal Leave'
	WHEN hr_leavinfo.leav_code = 'FSL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'IFL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'IPL' THEN  'Personal Leave'
	WHEN hr_leavinfo.leav_code = 'ISL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'MIL' THEN  'Military Leave'
	WHEN hr_leavinfo.leav_code = 'PRL' THEN  'Personal Leave'
	WHEN hr_leavinfo.leav_code = 'SKL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'WCL' THEN  'Worker Compensation'
	ELSE hr_leavinfo.leav_code
	END as 'LeaveType'
,replace(convert(varchar, hr_leavinfo.startdt, 106),' ','-') as 'FirstDayofLeave'
FROM 	  [production_finance].[dbo].[hr_empmstr]
  RIGHT JOIN [production_finance].[dbo].[hr_leavinfo]
    ON hr_empmstr.id = hr_leavinfo.id
	 and hr_leavinfo.leav_code in ('EDL','FSL','IFL','IPL','ISL','MIL','PRL','SKL','WCL')
	 and hr_leavinfo.apprvdate is not null
	 and hr_leavinfo.startdt is not null
	 and hr_leavinfo.startdt in (SELECT max(l.startdt) from [production_finance].[dbo].[hr_leavinfo] l Where hr_leavinfo.id = l.id and hr_leavinfo.leav_code = l.leav_code)
where 
 hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT', 'ROAD')
) y 
where LeaveofAbs_lite_CTE.Workerid = y.workerid and y.leavetype = LeaveofAbs_lite_CTE.leavetype ) 
/* end of grab */ 
  GROUP BY LeaveofAbs_lite_CTE.Entity_id, LeaveofAbs_lite_CTE.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
 FROM LeaveofAbs_lite_CTE
 where LeaveofAbs_lite_CTE.firstdayOfLeave in (select max(y.firstdayOfLeave) FROM (
select
trim(hr_empmstr.id) as 'WorkerID'
,CASE
	WHEN hr_leavinfo.leav_code = 'EDL' THEN  'Personal Leave'
	WHEN hr_leavinfo.leav_code = 'FSL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'IFL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'IPL' THEN  'Personal Leave'
	WHEN hr_leavinfo.leav_code = 'ISL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'MIL' THEN  'Military Leave'
	WHEN hr_leavinfo.leav_code = 'PRL' THEN  'Personal Leave'
	WHEN hr_leavinfo.leav_code = 'SKL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'WCL' THEN  'Worker Compensation'
	ELSE hr_leavinfo.leav_code
	END as 'LeaveType'
,replace(convert(varchar, hr_leavinfo.startdt, 106),' ','-') as 'FirstDayofLeave'
FROM 	  [production_finance].[dbo].[hr_empmstr]
  RIGHT JOIN [production_finance].[dbo].[hr_leavinfo]
    ON hr_empmstr.id = hr_leavinfo.id
	 and hr_leavinfo.leav_code in ('EDL','FSL','IFL','IPL','ISL','MIL','PRL','SKL','WCL')
	 and hr_leavinfo.apprvdate is not null
	 and hr_leavinfo.startdt is not null
	 and hr_leavinfo.startdt in (SELECT max(l.startdt) from [production_finance].[dbo].[hr_leavinfo] l Where hr_leavinfo.id = l.id and hr_leavinfo.leav_code = l.leav_code)
where 
 hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT', 'ROAD')
) y 
where LeaveofAbs_lite_CTE.Workerid = y.workerid and y.leavetype = LeaveofAbs_lite_CTE.leavetype ) 
/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;








;with LeaveofAbs_CTE 
AS (select
trim(hr_empmstr.id) as 'WorkerID'
,'Denise Krzeminski' as 'SourceSystem'
,'' as 'PositionID'
,CASE
	WHEN hr_leavinfo.leav_code = 'EDL' THEN  'Personal Leave'
	WHEN hr_leavinfo.leav_code = 'FSL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'IFL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'IPL' THEN  'Personal Leave'
	WHEN hr_leavinfo.leav_code = 'ISL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'MIL' THEN  'Military Leave'
	WHEN hr_leavinfo.leav_code = 'PRL' THEN  'Personal Leave'
	WHEN hr_leavinfo.leav_code = 'SKL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'WCL' THEN  'Worker Compensation'
	ELSE hr_leavinfo.leav_code
	END as 'LeaveType'
,'' as 'Reason'
,CASE
WHEN DATEPART(dw,hr_leavinfo.startdt) = 1 THEN replace(convert(varchar, dateadd(day,-2,hr_leavinfo.startdt), 106),' ','-')
WHEN DATEPART(dw,hr_leavinfo.startdt) between 3 and 7 THEN replace(convert(varchar, dateadd(day,-1,hr_leavinfo.startdt), 106),' ','-')
WHEN DATEPART(dw,hr_leavinfo.startdt) = 2 THEN replace(convert(varchar, dateadd(day,-3,hr_leavinfo.startdt), 106),' ','-')
ELSE ''
END as 'LastDayofWork'
,replace(convert(varchar, hr_leavinfo.startdt, 106),' ','-') as 'FirstDayofLeave'
,IIF( hr_leavinfo.startdt>hr_leavinfo.estenddt
	,replace(convert(varchar, hr_leavinfo.startdt, 106),' ','-') 
	,replace(convert(varchar, hr_leavinfo.estenddt, 106),' ','-')) as 'EstimatedLastDayofLeave'
	,'' as 'Comments'
FROM 	  [production_finance].[dbo].[hr_empmstr]
  RIGHT JOIN [production_finance].[dbo].[hr_leavinfo]
    ON hr_empmstr.id = hr_leavinfo.id
	 and hr_leavinfo.leav_code in ('EDL','FSL','IFL','IPL','ISL','MIL','PRL','SKL','WCL')
	 and hr_leavinfo.apprvdate is not null
	 and hr_leavinfo.startdt is not null
	 and hr_leavinfo.startdt in (SELECT max(l.startdt) from [production_finance].[dbo].[hr_leavinfo] l Where hr_leavinfo.id = l.id and hr_leavinfo.leav_code = l.leav_code)
where 
 hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT', 'ROAD')
 )
 SELECT * 
 FROM LeaveofAbs_CTE
 where LeaveofAbs_CTE.firstdayOfLeave in (select max(y.firstdayOfLeave) FROM (
select
trim(hr_empmstr.id) as 'WorkerID'
,'Denise Krzeminski' as 'SourceSystem'
,'' as 'PositionID'
,CASE
	WHEN hr_leavinfo.leav_code = 'EDL' THEN  'Personal Leave'
	WHEN hr_leavinfo.leav_code = 'FSL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'IFL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'IPL' THEN  'Personal Leave'
	WHEN hr_leavinfo.leav_code = 'ISL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'MIL' THEN  'Military Leave'
	WHEN hr_leavinfo.leav_code = 'PRL' THEN  'Personal Leave'
	WHEN hr_leavinfo.leav_code = 'SKL' THEN  'FMLA'
	WHEN hr_leavinfo.leav_code = 'WCL' THEN  'Worker Compensation'
	ELSE hr_leavinfo.leav_code
	END as 'LeaveType'
,'' as 'Reason'
,CASE
WHEN DATEPART(dw,hr_leavinfo.startdt) = 1 THEN replace(convert(varchar, dateadd(day,-2,hr_leavinfo.startdt), 106),' ','-')
WHEN DATEPART(dw,hr_leavinfo.startdt) between 3 and 7 THEN replace(convert(varchar, dateadd(day,-1,hr_leavinfo.startdt), 106),' ','-')
WHEN DATEPART(dw,hr_leavinfo.startdt) = 2 THEN replace(convert(varchar, dateadd(day,-3,hr_leavinfo.startdt), 106),' ','-')
ELSE ''
END as 'LastDayofWork'
,replace(convert(varchar, hr_leavinfo.startdt, 106),' ','-') as 'FirstDayofLeave'
,IIF( hr_leavinfo.startdt>hr_leavinfo.estenddt
	,replace(convert(varchar, hr_leavinfo.startdt, 106),' ','-') 
	,replace(convert(varchar, hr_leavinfo.estenddt, 106),' ','-')) as 'EstimatedLastDayofLeave'
	,'' as 'Comments'
FROM 	  [production_finance].[dbo].[hr_empmstr]
  RIGHT JOIN [production_finance].[dbo].[hr_leavinfo]
    ON hr_empmstr.id = hr_leavinfo.id
	 and hr_leavinfo.leav_code in ('EDL','FSL','IFL','IPL','ISL','MIL','PRL','SKL','WCL')
	 and hr_leavinfo.apprvdate is not null
	 and hr_leavinfo.startdt is not null
	 and hr_leavinfo.startdt in (SELECT max(l.startdt) from [production_finance].[dbo].[hr_leavinfo] l Where hr_leavinfo.id = l.id and hr_leavinfo.leav_code = l.leav_code)
where 
 hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT', 'ROAD')
) y 
where LeaveofAbs_CTE.Workerid = y.workerid and y.leavetype = LeaveofAbs_CTE.leavetype ) 
order by 1