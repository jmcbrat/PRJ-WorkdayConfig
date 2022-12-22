/*HR_EMP-JobMgt*/
SELECT
hr_empmstr.id as 'EmployeeID'
,'Denise Krzeminski' as 'SourceSystem'
,CASE
  WHEN hr_empmstr.type = 'RETR' THEN 'RETIREE'
  WHEN hr_empmstr.type = 'RETS' THEN 'BENEFICIARY'
  WHEN hr_empmstr.type = 'RETM' THEN 'RETM'
  WHEN hr_empmstr.type = 'RETG' THEN 'RETG'
  WHEN hr_empmstr.type = 'FTBU' THEN 'Regular'
  WHEN hr_empmstr.type = 'PTBU' THEN 'Regular'
  WHEN hr_empmstr.type = 'EO' THEN 'Regular'
  WHEN hr_empmstr.type = 'ROAD' THEN 'Regular'
  WHEN hr_empmstr.type = 'TEMP' THEN 'Temporary'
  WHEN hr_empmstr.type = 'SUMR' THEN 'JTP Senior'
  ELSE ''
  END as 'EmployeeType'
,'Hire_Employee_Hire_Employee_Conversion' as 'HireReason'
,'' as 'FirstDayofWork'
,IIF( hr_empmstr.beg<hr_empmstr.hdt
  ,replace(convert(varchar,hr_empmstr.beg,106),' ','-')
  ,replace(convert(varchar,hr_empmstr.hdt,106),' ','-')) as 'HireDate'
,'' as 'ProbationStartDate'
,'' as 'ProbationEndDate'
,'' as 'EndEmploymentDate'
,replace(convert(varchar,ISNULL(hr_empmstr.possenr,hr_empmstr.beg),106),' ','-') as 'PositionStartDateforConversion'
,CASE
  WHEN hr_empmstr.entity_id in ('ROOT','ROAD') THEN 'Sup_Terminated Workers'
  WHEN hr_empmstr.entity_id = 'PENS' and hr_empmstr.department = 'RETG' THEN 'Sup_Retiree General'
  WHEN hr_empmstr.entity_id = 'PENS' and hr_empmstr.department = 'RETM' THEN 'Sup_Retiree MTB'
  WHEN hr_empmstr.entity_id = 'PENS' and hr_empmstr.department = 'RETS' THEN 'Sup_Retiree Sheriff'
  WHEN hr_empmstr.entity_id = 'PENS' and hr_empmstr.department = 'RETR' THEN 'Sup_Retiree Roads'
ELSE ''
END as 'SupervisoryOrganizationID'
,substring(hr_emppay.indx_key,4,3) as 'JobCode'
,(select TOP 1 hr_pcntble.long_desc 
  FROM [production_finance].[dbo].hr_pcntble 
  WHERE substring(hr_emppay.indx_key,4,3)+left(hr_emppay.indx_key,2) = hr_pcntble.jobcode )
 as 'PositionTitle'
,'' as 'BusinessTitle'
,CASE
  WHEN hr_empmstr.department = 'FAC' THEN 'LOC001'
  WHEN hr_empmstr.department = 'PDO' THEN 'LOC002'
  WHEN hr_empmstr.department = 'ANC' THEN 'LOC003'
  WHEN hr_empmstr.department in('CES','CSA','SCS','VET') THEN 'LOC004'
  WHEN hr_empmstr.department = 'SHF' THEN 'LOC014'
  WHEN hr_empmstr.department IN ('CIP','FOC','FCJ') THEN 'LOC018'
  WHEN hr_empmstr.department IN ('CIR','PMC','PCW','RMB','CLK') THEN 'LOC019'
  WHEN hr_empmstr.department IN ('BOC','CCO','CEX','EQL','HCS','HRS','LIB','MTB','PLN','PRS','RSK','TRS') THEN 'LOC023'
  WHEN hr_empmstr.department = 'DC2' THEN 'LOC025'
  WHEN hr_empmstr.department = 'DC1' THEN 'LOC026'
  WHEN hr_empmstr.department IN ('FIN','PUR','REG') THEN 'LOC034'
  WHEN hr_empmstr.department IN ('MIS','ROAD') THEN 'LOC035'
  WHEN hr_empmstr.department = 'PWK' THEN 'LOC045'
  WHEN hr_empmstr.department = 'CMH' THEN 'LOC049'
  WHEN hr_empmstr.department IN ('ETA','JTP') THEN 'LOC127'
  ELSE hr_empmstr.department
END as 'WorkLocation'
,'' as 'WorkSpace'
,CASE
 WHEN hr_empmstr.entity_id = 'ROOT' THEN  hr_emppay.[actl_hrs]*5 
 WHEN hr_empmstr.entity_id = 'ROAD' THEN  40
 ELSE 0
 END  as 'DefaultWeeklyHours'
,CASE
 WHEN hr_empmstr.entity_id = 'ROOT' THEN  hr_emppay.[actl_hrs]*5 
 WHEN hr_empmstr.entity_id = 'ROAD' THEN  40
 ELSE 0
 END  as 'ScheduledWeeklyHours'
,'' as 'PaidFTE'
,'' as 'WorkingFTE'
,CASE
  WHEN hr_empmstr.type = 'RETR' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'RETS' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'RETM' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'RETG' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'FTBU' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'PTBU' THEN 'Part_Time'
  WHEN hr_empmstr.type = 'EO' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'ROAD' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'TEMP' THEN 'Part_Time'
  WHEN hr_empmstr.type = 'SUMR' THEN 'Part_Time'
  ELSE ''
 END  as 'TimeType'
,CASE
  WHEN hr_empmstr.Entity_id = 'ROADS' THEN 'Salary'
  WHEN hr_emppay.re_calc='A' THEN 'Salary'
  WHEN hr_emppay.re_calc='H' THEN 'Hourly'
  WHEN hr_empmstr.Entity_id = 'PENS' THEN 'Monthly'
  ELSE ''
  END as 'PayRateType'
,'' as 'CompanyInsiderType'
,'' as 'WorkShift'
,'' as 'AdditionalJobClassification#1'
,'' as 'AdditionalJobClassification#2'
,'' as 'AdditionalJobClassification#3'
,'' as 'AdditionalJobClassification#4'

from [production_finance].[dbo].[hr_empmstr]
     right join [production_finance].[dbo].[hr_emppay] 
     on hr_empmstr.id = hr_emppay.id 
	  --left join [it.Macomb_DBA].[dbo].[EMP_Position_Mgt]
	  --on hr_empmstr.id = EMP_Position_Mgt.emp_id 
where hr_emppay.unique_id = (select max(unique_id) from [production_finance].[dbo].[hr_emppay] where hr_empmstr.id = hr_emppay.id)
    and hr_empmstr.hr_status = 'I'
         and hr_empmstr.ENTITY_ID = 'ROOT'
         and hr_empmstr.enddt > convert(datetime,'12/31/2021')

UNION ALL 
/*pens*/
SELECT
hr_empmstr.id as 'EmployeeID'
,'Denise Krzeminski' as 'SourceSystem'
,CASE
  WHEN hr_empmstr.type = 'RETR' THEN 'RETIREE'
  WHEN hr_empmstr.type = 'RETS' THEN 'BENEFICIARY'
  WHEN hr_empmstr.type = 'RETM' THEN 'RETM'
  WHEN hr_empmstr.type = 'RETG' THEN 'RETG'
  WHEN hr_empmstr.type = 'FTBU' THEN 'Regular'
  WHEN hr_empmstr.type = 'PTBU' THEN 'Regular'
  WHEN hr_empmstr.type = 'EO' THEN 'Regular'
  WHEN hr_empmstr.type = 'ROAD' THEN 'Regular'
  WHEN hr_empmstr.type = 'TEMP' THEN 'Temporary'
  WHEN hr_empmstr.type = 'SUMR' THEN 'JTP Senior'
  ELSE ''
  END as 'EmployeeType'
,'Hire_Employee_Hire_Employee_Conversion' as 'HireReason'
,'' as 'FirstDayofWork'
,IIF( hr_empmstr.beg<hr_empmstr.hdt
  ,replace(convert(varchar,hr_empmstr.beg,106),' ','-')
  ,replace(convert(varchar,hr_empmstr.hdt,106),' ','-')) as 'HireDate'
,'' as 'ProbationStartDate'
,'' as 'ProbationEndDate'
,'' as 'EndEmploymentDate'
,replace(convert(varchar,ISNULL(hr_empmstr.possenr,hr_empmstr.beg),106),' ','-') as 'PositionStartDateforConversion'
,CASE
  WHEN hr_empmstr.entity_id in ('ROOT','ROAD') THEN 'Sup_Terminated Workers'
  WHEN hr_empmstr.entity_id = 'PENS' and hr_empmstr.department = 'RETG' THEN 'Sup_Retiree General'
  WHEN hr_empmstr.entity_id = 'PENS' and hr_empmstr.department = 'RETM' THEN 'Sup_Retiree MTB'
  WHEN hr_empmstr.entity_id = 'PENS' and hr_empmstr.department = 'RETS' THEN 'Sup_Retiree Sheriff'
  WHEN hr_empmstr.entity_id = 'PENS' and hr_empmstr.department = 'RETR' THEN 'Sup_Retiree Roads'
ELSE ''
END as 'SupervisoryOrganizationID'
,substring(hr_emppay.indx_key,4,3) as 'JobCode'
,(select TOP 1 hr_pcntble.long_desc 
  FROM [production_finance].[dbo].hr_pcntble 
  WHERE substring(hr_emppay.indx_key,4,3)+left(hr_emppay.indx_key,2) = hr_pcntble.jobcode )
 as 'PositionTitle'
,'' as 'BusinessTitle'
,CASE
  WHEN hr_empmstr.department = 'FAC' THEN 'LOC001'
  WHEN hr_empmstr.department = 'PDO' THEN 'LOC002'
  WHEN hr_empmstr.department = 'ANC' THEN 'LOC003'
  WHEN hr_empmstr.department in('CES','CSA','SCS','VET') THEN 'LOC004'
  WHEN hr_empmstr.department = 'SHF' THEN 'LOC014'
  WHEN hr_empmstr.department IN ('CIP','FOC','FCJ') THEN 'LOC018'
  WHEN hr_empmstr.department IN ('CIR','PMC','PCW','RMB','CLK') THEN 'LOC019'
  WHEN hr_empmstr.department IN ('BOC','CCO','CEX','EQL','HCS','HRS','LIB','MTB','PLN','PRS','RSK','TRS') THEN 'LOC023'
  WHEN hr_empmstr.department = 'DC2' THEN 'LOC025'
  WHEN hr_empmstr.department = 'DC1' THEN 'LOC026'
  WHEN hr_empmstr.department IN ('FIN','PUR','REG') THEN 'LOC034'
  WHEN hr_empmstr.department IN ('MIS','ROAD') THEN 'LOC035'
  WHEN hr_empmstr.department = 'PWK' THEN 'LOC045'
  WHEN hr_empmstr.department = 'CMH' THEN 'LOC049'
  WHEN hr_empmstr.department IN ('ETA','JTP') THEN 'LOC127'
  ELSE hr_empmstr.department
END as 'WorkLocation'
,'' as 'WorkSpace'
,CASE
 WHEN hr_empmstr.entity_id = 'ROOT' THEN  hr_emppay.[actl_hrs]*5 
 WHEN hr_empmstr.entity_id = 'ROAD' THEN  40
 ELSE 0
 END  as 'DefaultWeeklyHours'
,CASE
 WHEN hr_empmstr.entity_id = 'ROOT' THEN  hr_emppay.[actl_hrs]*5 
 WHEN hr_empmstr.entity_id = 'ROAD' THEN  40
 ELSE 0
 END  as 'ScheduledWeeklyHours'
,'' as 'PaidFTE'
,'' as 'WorkingFTE'
,CASE
  WHEN hr_empmstr.type = 'RETR' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'RETS' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'RETM' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'RETG' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'FTBU' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'PTBU' THEN 'Part_Time'
  WHEN hr_empmstr.type = 'EO' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'ROAD' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'TEMP' THEN 'Part_Time'
  WHEN hr_empmstr.type = 'SUMR' THEN 'Part_Time'
  ELSE ''
 END  as 'TimeType'
,CASE
  WHEN hr_empmstr.Entity_id = 'ROADS' THEN 'Salary'
  WHEN hr_emppay.re_calc='A' THEN 'Salary'
  WHEN hr_emppay.re_calc='H' THEN 'Hourly'
  WHEN hr_empmstr.Entity_id = 'PENS' THEN 'Monthly'
  ELSE ''
  END as 'PayRateType'
,'' as 'CompanyInsiderType'
,'' as 'WorkShift'
,'' as 'AdditionalJobClassification#1'
,'' as 'AdditionalJobClassification#2'
,'' as 'AdditionalJobClassification#3'
,'' as 'AdditionalJobClassification#4'

from [production_finance].[dbo].[hr_empmstr]
     right join [production_finance].[dbo].[hr_emppay] 
     on hr_empmstr.id = hr_emppay.id 
	  --left join [it.Macomb_DBA].[dbo].[EMP_Position_Mgt]
	  --on hr_empmstr.id = EMP_Position_Mgt.emp_id 
where hr_emppay.unique_id = (select max(unique_id) from [production_finance].[dbo].[hr_emppay] where hr_empmstr.id = hr_emppay.id)
    and hr_empmstr.hr_status = 'I'
         and hr_empmstr.ENTITY_ID = 'PENS'
         and hr_empmstr.enddt > convert(datetime,'12/31/2021')

UNION ALL
/*roads*/
SELECT

hr_empmstr.id as 'EmployeeID'
,'Denise Krzeminski' as 'SourceSystem'
,CASE
  WHEN hr_empmstr.type = 'RETR' THEN 'RETIREE'
  WHEN hr_empmstr.type = 'RETS' THEN 'BENEFICIARY'
  WHEN hr_empmstr.type = 'RETM' THEN 'RETM'
  WHEN hr_empmstr.type = 'RETG' THEN 'RETG'
  WHEN hr_empmstr.type = 'FTBU' THEN 'Regular'
  WHEN hr_empmstr.type = 'PTBU' THEN 'Regular'
  WHEN hr_empmstr.type = 'EO' THEN 'Regular'
  WHEN hr_empmstr.type = 'ROAD' THEN 'Regular'
  WHEN hr_empmstr.type = 'TEMP' THEN 'Temporary'
  WHEN hr_empmstr.type = 'SUMR' THEN 'JTP Senior'
  ELSE ''
  END as 'EmployeeType'
,'Hire_Employee_Hire_Employee_Conversion' as 'HireReason'
,'' as 'FirstDayofWork'
,IIF( hr_empmstr.beg<hr_empmstr.hdt
  ,replace(convert(varchar,hr_empmstr.beg,106),' ','-')
  ,replace(convert(varchar,hr_empmstr.hdt,106),' ','-')) as 'HireDate'
,'' as 'ProbationStartDate'
,'' as 'ProbationEndDate'
,'' as 'EndEmploymentDate'
,replace(convert(varchar,ISNULL(hr_empmstr.possenr,hr_empmstr.beg),106),' ','-') as 'PositionStartDateforConversion'
,CASE
  WHEN hr_empmstr.entity_id in ('ROOT','ROAD') THEN 'Sup_Terminated Workers'
  WHEN hr_empmstr.entity_id = 'PENS' and hr_empmstr.department = 'RETG' THEN 'Sup_Retiree-General'
  WHEN hr_empmstr.entity_id = 'PENS' and hr_empmstr.department = 'RETM' THEN 'Sup_Retiree-MTB'
  WHEN hr_empmstr.entity_id = 'PENS' and hr_empmstr.department = 'RETS' THEN 'Sup_Retiree-Sheriff'
  WHEN hr_empmstr.entity_id = 'PENS' and hr_empmstr.department = 'RETR' THEN 'Sup_Retiree-Roads'
ELSE ''
END as 'SupervisoryOrganizationID'
,'Default_Job_Profile' as 'JobCode'
,CASE 
  WHEN hr_empmstr.entity_id = 'ROOT' THEN substring(hr_emppay.indx_key,4,3)+left(hr_emppay.indx_key,2) 
  WHEN hr_empmstr.entity_id = 'ROAD' THEN '' 
  ELSE ''
  END as 'PositionTitle'
,'' as 'BusinessTitle'
,CASE
  WHEN hr_empmstr.department = 'FAC' THEN 'LOC001'
  WHEN hr_empmstr.department = 'PDO' THEN 'LOC002'
  WHEN hr_empmstr.department = 'ANC' THEN 'LOC003'
  WHEN hr_empmstr.department in('CES','CSA','SCS','VET') THEN 'LOC004'
  WHEN hr_empmstr.department = 'SHF' THEN 'LOC014'
  WHEN hr_empmstr.department IN ('CIP','FOC','FCJ') THEN 'LOC018'
  WHEN hr_empmstr.department IN ('CIR','PMC','PCW','RMB','CLK') THEN 'LOC019'
  WHEN hr_empmstr.department IN ('BOC','CCO','CEX','EQL','HCS','HRS','LIB','MTB','PLN','PRS','RSK','TRS') THEN 'LOC023'
  WHEN hr_empmstr.department = 'DC2' THEN 'LOC025'
  WHEN hr_empmstr.department = 'DC1' THEN 'LOC026'
  WHEN hr_empmstr.department IN ('FIN','PUR','REG') THEN 'LOC034'
  WHEN hr_empmstr.department IN ('MIS','ROAD') THEN 'LOC035'
  WHEN hr_empmstr.department = 'PWK' THEN 'LOC045'
  WHEN hr_empmstr.department = 'CMH' THEN 'LOC049'
  WHEN hr_empmstr.department IN ('ETA','JTP') THEN 'LOC127'
  ELSE hr_empmstr.department
END as 'WorkLocation'
,'' as 'WorkSpace'
,CASE
 WHEN hr_empmstr.entity_id = 'ROOT' THEN  hr_emppay.[actl_hrs]*5 
 WHEN hr_empmstr.entity_id = 'ROAD' THEN  40
 ELSE 0
 END  as 'DefaultWeeklyHours'
,CASE
 WHEN hr_empmstr.entity_id = 'ROOT' THEN  hr_emppay.[actl_hrs]*5 
 WHEN hr_empmstr.entity_id = 'ROAD' THEN  40
 ELSE 0
 END  as 'ScheduledWeeklyHours'
,'' as 'PaidFTE'
,'' as 'WorkingFTE'
,CASE
  WHEN hr_empmstr.type = 'RETR' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'RETS' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'RETM' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'RETG' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'FTBU' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'PTBU' THEN 'Part_Time'
  WHEN hr_empmstr.type = 'EO' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'ROAD' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'TEMP' THEN 'Part_Time'
  WHEN hr_empmstr.type = 'SUMR' THEN 'Part_Time'
  ELSE ''
 END  as 'TimeType'
,CASE
  WHEN hr_empmstr.Entity_id = 'ROAD' THEN 'Salary'
  WHEN hr_emppay.re_calc='A' THEN 'Salary'
  WHEN hr_emppay.re_calc='H' THEN 'Hourly'
  WHEN hr_empmstr.Entity_id = 'PENS' THEN 'Monthly'
  ELSE ''
  END as 'PayRateType'
,'' as 'CompanyInsiderType'
,'' as 'WorkShift'
,'' as 'AdditionalJobClassification#1'
,'' as 'AdditionalJobClassification#2'
,'' as 'AdditionalJobClassification#3'
,'' as 'AdditionalJobClassification#4'

from [production_finance].[dbo].[hr_empmstr]
     right join [production_finance].[dbo].[hr_emppay] 
     on hr_empmstr.id = hr_emppay.id 
--	  left join [it.Macomb_DBA].[dbo].[EMP_Position_Mgt]
--	  on hr_empmstr.id = EMP_Position_Mgt.emp_id 
where hr_emppay.unique_id = (select max(unique_id) from [production_finance].[dbo].[hr_emppay] where hr_empmstr.id = hr_emppay.id)
    and hr_empmstr.hr_status = 'I'
         and hr_empmstr.ENTITY_ID ='ROAD'
         and hr_empmstr.enddt > convert(datetime,'12/31/2021')
UNION ALL 
/*retirees*/
SELECT

hr_empmstr.id as 'EmployeeID'
,'Denise Krzeminski' as 'SourceSystem'
,CASE
  WHEN hr_empmstr.type = 'RETR' THEN 'RETIREE'
  WHEN hr_empmstr.type = 'RETS' THEN 'BENEFICIARY'
  WHEN hr_empmstr.type = 'RETM' THEN 'RETM'
  WHEN hr_empmstr.type = 'RETG' THEN 'RETG'
  WHEN hr_empmstr.type = 'FTBU' THEN 'Regular'
  WHEN hr_empmstr.type = 'PTBU' THEN 'Regular'
  WHEN hr_empmstr.type = 'EO' THEN 'Regular'
  WHEN hr_empmstr.type = 'ROAD' THEN 'Regular'
  WHEN hr_empmstr.type = 'TEMP' THEN 'Temporary'
  WHEN hr_empmstr.type = 'SUMR' THEN 'JTP Senior'
  ELSE ''
  END as 'EmployeeType'
,'Hire_Employee_Hire_Employee_Conversion' as 'HireReason'
,'' as 'FirstDayofWork'
,IIF( hr_empmstr.beg<hr_empmstr.hdt
  ,replace(convert(varchar,hr_empmstr.beg,106),' ','-')
  ,replace(convert(varchar,hr_empmstr.hdt,106),' ','-')) as 'HireDate'
,'' as 'ProbationStartDate'
,'' as 'ProbationEndDate'
,'' as 'EndEmploymentDate'
,replace(convert(varchar,ISNULL(hr_empmstr.possenr,hr_empmstr.beg),106),' ','-') as 'PositionStartDateforConversion'
,CASE
  WHEN hr_empmstr.entity_id in ('ROOT','ROAD') THEN 'Sup_Terminated Workers'
  WHEN hr_empmstr.entity_id = 'PENS' and hr_empmstr.department = 'RETG' THEN 'Sup_Retiree-General'
  WHEN hr_empmstr.entity_id = 'PENS' and hr_empmstr.department = 'RETM' THEN 'Sup_Retiree-MTB'
  WHEN hr_empmstr.entity_id = 'PENS' and hr_empmstr.department = 'RETS' THEN 'Sup_Retiree-Sheriff'
  WHEN hr_empmstr.entity_id = 'PENS' and hr_empmstr.department = 'RETR' THEN 'Sup_Retiree-Roads'
ELSE ''
END as 'SupervisoryOrganizationID'
,substring(hr_emppay.PCN,3,5) as 'JobCode'
,(SELECT TOP 1 hr_pcntble.long_desc
 FROM [production_finance].[dbo].[HR_pcntble]
 WHERE substring(hr_emppay.PCN,8,3) = HR_pcntble.assg_no
and substring(hr_emppay.PCN,3,5) = HR_pcntble.JOBCODE) as 'PositionTitle'
,'' as 'BusinessTitle'
,CASE
  WHEN hr_empmstr.department = 'FAC' THEN 'LOC001'
  WHEN hr_empmstr.department = 'PDO' THEN 'LOC002'
  WHEN hr_empmstr.department = 'ANC' THEN 'LOC003'
  WHEN hr_empmstr.department in('CES','CSA','SCS','VET') THEN 'LOC004'
  WHEN hr_empmstr.department = 'SHF' THEN 'LOC014'
  WHEN hr_empmstr.department IN ('CIP','FOC','FCJ') THEN 'LOC018'
  WHEN hr_empmstr.department IN ('CIR','PMC','PCW','RMB','CLK') THEN 'LOC019'
  WHEN hr_empmstr.department IN ('BOC','CCO','CEX','EQL','HCS','HRS','LIB','MTB','PLN','PRS','RSK','TRS') THEN 'LOC023'
  WHEN hr_empmstr.department = 'DC2' THEN 'LOC025'
  WHEN hr_empmstr.department = 'DC1' THEN 'LOC026'
  WHEN hr_empmstr.department IN ('FIN','PUR','REG') THEN 'LOC034'
  WHEN hr_empmstr.department IN ('MIS','ROAD') THEN 'LOC035'
  WHEN hr_empmstr.department = 'PWK' THEN 'LOC045'
  WHEN hr_empmstr.department = 'CMH' THEN 'LOC049'
  WHEN hr_empmstr.department IN ('ETA','JTP') THEN 'LOC127'
  ELSE hr_empmstr.department
END as 'WorkLocation'
,'' as 'WorkSpace'
,CASE
 WHEN hr_empmstr.entity_id = 'ROOT' THEN  hr_emppay.[actl_hrs]*5 
 WHEN hr_empmstr.entity_id = 'ROAD' THEN  40
 ELSE 0
 END  as 'DefaultWeeklyHours'
,CASE
 WHEN hr_empmstr.entity_id = 'ROOT' THEN  hr_emppay.[actl_hrs]*5 
 WHEN hr_empmstr.entity_id = 'ROAD' THEN  40
 ELSE 0
 END  as 'ScheduledWeeklyHours'
,'' as 'PaidFTE'
,'' as 'WorkingFTE'
,CASE
  WHEN hr_empmstr.type = 'RETR' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'RETS' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'RETM' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'RETG' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'FTBU' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'PTBU' THEN 'Part_Time'
  WHEN hr_empmstr.type = 'EO' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'ROAD' THEN 'Full_Time'
  WHEN hr_empmstr.type = 'TEMP' THEN 'Part_Time'
  WHEN hr_empmstr.type = 'SUMR' THEN 'Part_Time'
  ELSE ''
 END  as 'TimeType'
,CASE
  WHEN hr_empmstr.Entity_id = 'ROAD' THEN 'Salary'
  WHEN hr_emppay.re_calc='A' THEN 'Salary'
  WHEN hr_emppay.re_calc='H' THEN 'Hourly'
  WHEN hr_empmstr.Entity_id = 'PENS' THEN 'Salary'
  ELSE ''
  END as 'PayRateType'
,'' as 'CompanyInsiderType'
,'' as 'WorkShift'
,'' as 'AdditionalJobClassification#1'
,'' as 'AdditionalJobClassification#2'
,'' as 'AdditionalJobClassification#3'
,'' as 'AdditionalJobClassification#4'

from [production_finance].[dbo].[hr_empmstr]
     right join [production_finance].[dbo].[hr_emppay] 
     on hr_empmstr.id = hr_emppay.id --and hr_emppay.PAY_END=convert(datetime,'12/31/2050')
	  		 and hr_emppay.pay_beg = (select max(e2.pay_beg) from [production_finance].[dbo].[hr_emppay] e2 where hr_empmstr.id = e2.id)

	  --left join [it.Macomb_DBA].[dbo].[EMP_Position_Mgt]
	  --on hr_empmstr.id = EMP_Position_Mgt.emp_id 
where hr_empmstr.hr_status = 'A'
     and hr_empmstr.ENTITY_ID IN ('PENS')
  order by 1


