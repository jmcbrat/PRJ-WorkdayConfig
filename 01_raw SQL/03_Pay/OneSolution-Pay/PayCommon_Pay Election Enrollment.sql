--PayCommon_Pay Election Enrollment
/*
issues: 
  account numbers are null what do i do?
  remove hr_dirdep.no
*/

SELECT 
	hr_empmstr.id as 'R-EmployeeID'
	,'OneSolution' as 'O-SourceSystem'
	,'USA' as 'R-CountryISOCode'
	,'USD' as 'R-CurrencyCode'
	,'Regular' as 'R-PaymentElectionRule'
	,ROW_NUMBER() OVER (PARTITION BY hr_empmstr.id ORDER BY hr_empmstr.id ) as 'R-DistributionOrder'
	,hr_dirdep.amt as 'O-DistributionAmount'
	,'' as 'O-DistributionPercentage'
	,CASE 
		WHEN hr_empmstr.entity_id = 'ROOT' and hr_dirdep.no = 2980 THEN 'N'
		WHEN hr_empmstr.entity_id = 'ROOT' and hr_dirdep.no = 2990 THEN 'Y'
		WHEN hr_empmstr.entity_id = 'PENS' and hr_dirdep.no = 2991 THEN 'Y'
		ELSE 'y' 
	 END as 'O-DistributionBalance'
	 ,'----- remove me ----'
	 ,hr_dirdep.no
	 ,'--------------------'
	,'Direct_Deposit' as 'R-PaymentType'
	,CASE 
		WHEN hr_dirdep.check_sav='Checking' THEN 'DDA'
		WHEN hr_dirdep.check_sav='Savings' THEN 'SA'
		ELSE hr_dirdep.check_sav
		END  as 'O-BankAccountNickname'
	,'' as 'O-BankAccountName'
	,hr_dirdep.account_no as 'R-AccountNumber'
	,CASE 
		WHEN hr_dirdep.check_sav='C' THEN 'DDA'
		WHEN hr_dirdep.check_sav='S' THEN 'SA'
		ELSE hr_dirdep.check_sav
		END as 'R-AccountType'
	,cd_codes_mstr.CD_DESCM as 'R-BankName'
	,hr_dirdep.bankid  as 'R-BankIDNumber'
	,'' as 'O-BIC'
	,'' as 'O-CheckDigit'
	,'' as 'O-BranchName'
FROM [production_finance].[dbo].[hr_empmstr]
--     left join [production_finance].[dbo].[hr_emppay] 
--       on hr_empmstr.id = hr_emppay.id and hr_emppay.unique_id = (select max(unique_id) from [production_finance].[dbo].[hr_emppay] where hr_empmstr.id = hr_emppay.id)
     LEFT JOIN [production_finance].[dbo].[hr_dirdep]
	    ON hr_empmstr.id = hr_dirdep.ID
		LEFT JOIN [production_finance].[dbo].[cd_codes_mstr]
		  ON hr_dirdep.BANKID  = right(cd_codes_mstr.CD_category,2)+cd_codes_mstr.CD_CODE
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'
order by hr_empmstr.id 