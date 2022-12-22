--PayCommon_Pay Election Enrollment
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'Common_Pay ' as Spreadsheet
,'Election Enrollment' as TabName
,'PayCommon_Pay Election Enrollment' as QueryName
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
--     left join [production_finance].[dbo].[hr_emppay] 
--       on hr_empmstr.id = hr_emppay.id and hr_emppay.unique_id = (select max(unique_id) from [production_finance].[dbo].[hr_emppay] where hr_empmstr.id = hr_emppay.id)
     right JOIN [production_finance].[dbo].[hr_dirdep] hr_dirdep
	    ON hr_empmstr.id = hr_dirdep.ID
		 AND NOT hr_dirdep.enddt <getdate()
		 AND hr_dirdep.no in ('2980','2990','2991')
		 


     left JOIN (select hr_dirdep2980.ID, hr_dirdep2980.account_no, hr_dirdep2980.bankid 
	                from [production_finance].[dbo].[hr_dirdep] hr_dirdep2980 
					 	WHERE NOT hr_dirdep2980.enddt <getdate()
							 AND hr_dirdep2980.no in ('2980'/*'2990','2991'*/)) hdd2980
	    ON hr_empmstr.id = hdd2980.ID

     left JOIN (select hr_dirdep2990.ID, hr_dirdep2990.account_no, hr_dirdep2990.bankid 
	                from [production_finance].[dbo].[hr_dirdep] hr_dirdep2990 
					 	WHERE NOT hr_dirdep2990.enddt <getdate()
							 AND hr_dirdep2990.no in ('2990'/*,'2991'*/)) hdd2990
	    ON hr_empmstr.id = hdd2990.ID

     left JOIN (select hr_dirdep2991.ID, hr_dirdep2991.account_no, hr_dirdep2991.bankid 
	                from [production_finance].[dbo].[hr_dirdep] hr_dirdep2991 
					 	WHERE NOT hr_dirdep2991.enddt <getdate()
							 AND hr_dirdep2991.no in ('2991')) hdd2991
	    ON hr_empmstr.id = hdd2991.ID
		 

		 --AND hr_dirdep.no = '2980' and hr_dirdep.AMT >0
		right JOIN [production_finance].[dbo].[cd_codes_mstr]
		  ON hr_dirdep.BANKID  = right(cd_codes_mstr.CD_category,2)+cd_codes_mstr.CD_CODE
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'
  AND ((hr_dirdep.no = '2980' and (hdd2980.account_no <> hdd2990.account_no or hdd2980.account_no <> hdd2991.account_no))
  OR hr_dirdep.no = '2990' or hr_dirdep.no = '2991')

/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
FROM [production_finance].[dbo].[hr_empmstr]
--     left join [production_finance].[dbo].[hr_emppay] 
--       on hr_empmstr.id = hr_emppay.id and hr_emppay.unique_id = (select max(unique_id) from [production_finance].[dbo].[hr_emppay] where hr_empmstr.id = hr_emppay.id)
     right JOIN [production_finance].[dbo].[hr_dirdep] hr_dirdep
	    ON hr_empmstr.id = hr_dirdep.ID
		 AND NOT hr_dirdep.enddt <getdate()
		 AND hr_dirdep.no in ('2980','2990','2991')
		 


     left JOIN (select hr_dirdep2980.ID, hr_dirdep2980.account_no, hr_dirdep2980.bankid 
	                from [production_finance].[dbo].[hr_dirdep] hr_dirdep2980 
					 	WHERE NOT hr_dirdep2980.enddt <getdate()
							 AND hr_dirdep2980.no in ('2980'/*'2990','2991'*/)) hdd2980
	    ON hr_empmstr.id = hdd2980.ID

     left JOIN (select hr_dirdep2990.ID, hr_dirdep2990.account_no, hr_dirdep2990.bankid 
	                from [production_finance].[dbo].[hr_dirdep] hr_dirdep2990 
					 	WHERE NOT hr_dirdep2990.enddt <getdate()
							 AND hr_dirdep2990.no in ('2990'/*,'2991'*/)) hdd2990
	    ON hr_empmstr.id = hdd2990.ID

     left JOIN (select hr_dirdep2991.ID, hr_dirdep2991.account_no, hr_dirdep2991.bankid 
	                from [production_finance].[dbo].[hr_dirdep] hr_dirdep2991 
					 	WHERE NOT hr_dirdep2991.enddt <getdate()
							 AND hr_dirdep2991.no in ('2991')) hdd2991
	    ON hr_empmstr.id = hdd2991.ID
		 

		 --AND hr_dirdep.no = '2980' and hr_dirdep.AMT >0
		right JOIN [production_finance].[dbo].[cd_codes_mstr]
		  ON hr_dirdep.BANKID  = right(cd_codes_mstr.CD_category,2)+cd_codes_mstr.CD_CODE
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'
  AND ((hr_dirdep.no = '2980' and (hdd2980.account_no <> hdd2990.account_no or hdd2980.account_no <> hdd2991.account_no))
  OR hr_dirdep.no = '2990' or hr_dirdep.no = '2991')

/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;







/*
issues: 

*/
SELECT 
	trim(hr_empmstr.id) as 'EmployeeID'
	,'Steve Smigiel' as 'SourceSystem'
	,'USA' as 'CountryISOCode'
	,'USD' as 'CurrencyCode'
	,'Regular' as 'PaymentElectionRule'
	,convert(varchar,ROW_NUMBER() OVER (PARTITION BY hr_empmstr.id ORDER BY hr_empmstr.id,IIF(hr_empmstr.entity_id = 'ROOT' and hr_dirdep.no = 2980,2,1)))  as 'DistributionOrder'
	,IIF(hr_empmstr.entity_id = 'ROOT' and hr_dirdep.no = 2980,hr_dirdep.amt,null) as 'DistributionAmount'
	,null as 'DistributionPercentage'
	,CASE 
		WHEN hr_empmstr.entity_id = 'ROOT' and hr_dirdep.no = 2980 THEN ''
		WHEN hr_empmstr.entity_id = 'ROOT' and hr_dirdep.no = 2990 THEN 'Y'
		WHEN hr_empmstr.entity_id = 'PENS' and hr_dirdep.no = 2991 THEN 'Y'
		ELSE 'z' 
	 END as 'DistributionBalance'
	-- ,hr_dirdep.no
	,IIF(hr_dirdep.no is null,'CHECK','Direct_Deposit') as 'PaymentType'
	,CASE 
		WHEN hr_dirdep.check_sav='Checking' THEN 'DDA'
		WHEN hr_dirdep.check_sav='Savings' THEN 'SA'
		ELSE ''
		END  as 'BankAccountNickname'
	,'' as 'BankAccountName'
	,convert(varchar,hr_dirdep.account_no) as 'AccountNumber'
	,CASE 
		WHEN hr_dirdep.check_sav='C' THEN 'DDA'
		WHEN hr_dirdep.check_sav='S' THEN 'SA'
		ELSE ''
		END as 'AccountType'
	,CASE
	WHEN hr_dirdep.bankid ='074900657' THEN 'FIRST MERCHANTS BANK'
	WHEN hr_dirdep.no is NOT null THEN cd_codes_mstr.CD_DESCM
	ELSE ''
	END  as 'BankName'
	
	,IIF(hr_dirdep.no is null,'',convert(varchar,hr_dirdep.bankid))  as 'BankIDNumber'
	,'' as 'BIC'
	,'' as 'CheckDigit'
	,'' as 'BranchName'
/*,'--- hr_dirdep ---'
,hr_dirdep.*
,'--- cd_codes_mstr ---'
,cd_codes_mstr.* 
*/
FROM [production_finance].[dbo].[hr_empmstr]
--     left join [production_finance].[dbo].[hr_emppay] 
--       on hr_empmstr.id = hr_emppay.id and hr_emppay.unique_id = (select max(unique_id) from [production_finance].[dbo].[hr_emppay] where hr_empmstr.id = hr_emppay.id)
     right JOIN [production_finance].[dbo].[hr_dirdep] hr_dirdep
	    ON hr_empmstr.id = hr_dirdep.ID
		 AND NOT hr_dirdep.enddt <getdate()
		 AND hr_dirdep.no in ('2980','2990','2991')
		 


     left JOIN (select hr_dirdep2980.ID, hr_dirdep2980.account_no, hr_dirdep2980.bankid 
	                from [production_finance].[dbo].[hr_dirdep] hr_dirdep2980 
					 	WHERE NOT hr_dirdep2980.enddt <getdate()
							 AND hr_dirdep2980.no in ('2980'/*'2990','2991'*/)) hdd2980
	    ON hr_empmstr.id = hdd2980.ID

     left JOIN (select hr_dirdep2990.ID, hr_dirdep2990.account_no, hr_dirdep2990.bankid 
	                from [production_finance].[dbo].[hr_dirdep] hr_dirdep2990 
					 	WHERE NOT hr_dirdep2990.enddt <getdate()
							 AND hr_dirdep2990.no in ('2990'/*,'2991'*/)) hdd2990
	    ON hr_empmstr.id = hdd2990.ID

     left JOIN (select hr_dirdep2991.ID, hr_dirdep2991.account_no, hr_dirdep2991.bankid 
	                from [production_finance].[dbo].[hr_dirdep] hr_dirdep2991 
					 	WHERE NOT hr_dirdep2991.enddt <getdate()
							 AND hr_dirdep2991.no in ('2991')) hdd2991
	    ON hr_empmstr.id = hdd2991.ID
		 

		 --AND hr_dirdep.no = '2980' and hr_dirdep.AMT >0
		right JOIN [production_finance].[dbo].[cd_codes_mstr]
		  ON hr_dirdep.BANKID  = right(cd_codes_mstr.CD_category,2)+cd_codes_mstr.CD_CODE
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'
  AND ((hr_dirdep.no = '2980' and (hdd2980.account_no <> hdd2990.account_no or hdd2980.account_no <> hdd2991.account_no))
  OR hr_dirdep.no = '2990' or hr_dirdep.no = '2991')

ORDER BY EmployeeID
