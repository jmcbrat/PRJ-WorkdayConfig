--PayCommon_Payee Input Data
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'PayCommon' as Spreadsheet
,'Payee Input Data' as TabName
,'PayCommon_Payee Input Data' as QueryName
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
	RIGHT JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
		  and PYD_AMT > 0
		  and PY_CDH_NO > 0
		  AND (PY_CDH_NO in (1101,1102,1103,1200,1201,
										1204,1205,1206,1207,1208,
										1209,1210,1211,1212,
										1218,1221,1223,1224,1226,
										1230,1231,1234,1240,1241,
										1244,1250,1252,1256,1261,
										1262,1270,1301,1303,1305,
										1306,1307,1308)
				OR
					py_cdh_no in (3800,3801,3802,3803,
									  3804,3805,3806,3807,
									  3808,3809,3810,3811,
									  3812,3815,3816,3817,3818, 
									  3828,3829,3833,3913,
									  2417,2419,2425,2426,
									  2428,2429,2435,2437,
									  2438,2463,2464,2465,
									  2466,2467,2490,2491,
									  2493,2495,2808,2812,
									  2910,2911,2913,2980)
				)
		and pyd_cdh_dtl.pyd_end>getdate()
	LEFT JOIN [IT.Macomb_DBA].[dbo].[Equiv_Deductions] deduct
		ON PY_CDH_NO = deduct.[Code]
	LEFT JOIN [IT.Macomb_DBA].[dbo].[Equiv_Earnings] earn
		ON PY_CDH_NO = earn.[Code]
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'
--and hr_empmstr.id in ('E003542','E021079')

/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
FROM [production_finance].[dbo].[hr_empmstr]
	RIGHT JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
		  and PYD_AMT > 0
		  and PY_CDH_NO > 0
		  AND (PY_CDH_NO in (1101,1102,1103,1200,1201,
										1204,1205,1206,1207,1208,
										1209,1210,1211,1212,
										1218,1221,1223,1224,1226,
										1230,1231,1234,1240,1241,
										1244,1250,1252,1256,1261,
										1262,1270,1301,1303,1305,
										1306,1307,1308)
				OR
					py_cdh_no in (3800,3801,3802,3803,
									  3804,3805,3806,3807,
									  3808,3809,3810,3811,
									  3812,3815,3816,3817,3818, 
									  3828,3829,3833,3913,
									  2417,2419,2425,2426,
									  2428,2429,2435,2437,
									  2438,2463,2464,2465,
									  2466,2467,2490,2491,
									  2493,2495,2808,2812,
									  2910,2911,2913,2980)
				)
		and pyd_cdh_dtl.pyd_end>getdate()
	LEFT JOIN [IT.Macomb_DBA].[dbo].[Equiv_Deductions] deduct
		ON PY_CDH_NO = deduct.[Code]
	LEFT JOIN [IT.Macomb_DBA].[dbo].[Equiv_Earnings] earn
		ON PY_CDH_NO = earn.[Code]
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'
--and hr_empmstr.id in ('E003542','E021079')

/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;






SELECT 
	trim(hr_empmstr.id) as 'EmployeeID'
	,'Steve Smigiel'   as 'SourceSystem'
	,'' as 'PositionID'
	,'Y' as 'OngoingInput'
	,replace(convert(varchar,pyd_cdh_dtl.pyd_beg, 106),' ','-') as 'StartDate'
	,replace(convert(varchar,pyd_cdh_dtl.pyd_end, 106),' ','-') as 'EndDate'
	,IIF(earn.[earnDesc] is null,'',earn.[earnDesc]) as  'EarningCode' 
	,IIF(deduct.[DeductDesc] is null,'',deduct.[DeductDesc]) as 'DeductionCode'
	,convert(numeric(12,2),convert(numeric(12,2),pyd_cdh_dtl.pyd_amt)/100) as 'Amount'
	,'' as 'Hours'
	,'' as 'Rate'
	,'' as 'Adjustment'
	,'' as 'Comment'
	,'USD' as 'Currency'
	,'' as 'StateAuthority'
	,'' as 'FlexiblePaymentDeductionWorktag'
	,'' as 'CustomWorktag#1'
	,'' as 'CustomWorktag#2'
	,'' as 'CustomWorktag#3'
	,'' as 'CustomWorktag#4'
	,'' as 'CustomWorktag#5'
	,'' as 'RelatedCalculationID'
	,'' as 'InputValue'
	,'' as 'RelatedCalculationID#2'
	,'' as 'InputValue#2'
	,'' as 'RelatedCalculationID#3'
	,'' as 'InputValue#3'
FROM [production_finance].[dbo].[hr_empmstr]
	RIGHT JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
		  and PYD_AMT > 0
		  and PY_CDH_NO > 0
		  AND (PY_CDH_NO in (1101,1102,1103,1200,1201,
										1204,1205,1206,1207,1208,
										1209,1210,1211,1212,
										1218,1221,1223,1224,1226,
										1230,1231,1234,1240,1241,
										1244,1250,1252,1256,1261,
										1262,1270,1301,1303,1305,
										1306,1307,1308)
				OR
					py_cdh_no in (3800,3801,3802,3803,
									  3804,3805,3806,3807,
									  3808,3809,3810,3811,
									  3812,3815,3816,3817,3818, 
									  3828,3829,3833,3913,
									  2417,2419,2425,2426,
									  2428,2429,2435,2437,
									  2438,2463,2464,2465,
									  2466,2467,2490,2491,
									  2493,2495,2808,2812,
									  2910,2911,2913,2980)
				)
		and pyd_cdh_dtl.pyd_end>getdate()
	LEFT JOIN [IT.Macomb_DBA].[dbo].[Equiv_Deductions] deduct
		ON PY_CDH_NO = deduct.[Code]
	LEFT JOIN [IT.Macomb_DBA].[dbo].[Equiv_Earnings] earn
		ON PY_CDH_NO = earn.[Code]
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'
--and hr_empmstr.id in ('E003542','E021079')

ORDER BY hr_empmstr.id