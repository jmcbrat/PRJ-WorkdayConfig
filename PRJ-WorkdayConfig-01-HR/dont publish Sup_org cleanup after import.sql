/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM [IT.Macomb_DBA].[dbo].[EMP_Position_MGT]
  --where dept in ('RETG','RETM','RETR','RETS');
  order by 6

 -- delete [IT.Macomb_DBA].[dbo].[EMP_Position_MGT] where dept is null;
 --   delete [IT.Macomb_DBA].[dbo].[EMP_Position_MGT] where [EMP ID] is null;
/*update EMP_Position_MGT
set EMP_Position_MGT.position_number = 'HR49A00001'
where left(emp_id,1) = 'R'*/

select * from EMP_Position_MGT
/*insert into [IT.Macomb_DBA].[dbo].[EMP_Position_MGT]
([Dept]
      ,[Emp ID]
      ,[Position Number]
      ,[Emp Type]
      ,[Position Title]
      ,[SUPERVISORY ORG])
  select  department, replace(id,'R','P'), '' as pos, 'RET', 'Retiree' as postitle,
  case 
   when department = 'RETG' THEN 'RETIREE GENERAL'
	when department = 'RETM' THEN 'RETIREE MTB'
	when department = 'RETR' THEN 'RETIREE ROADS'
	WHEN department = 'RETS' THEN 'RETIREE SHERIFF'
	ELSE 'OTHER - '+department
	END
  from [production_finance].[dbo].[hr_empmstr] hr
  where hr.entity_id ='PENS'
  and hr.hr_status = 'A'
order by 6
*/

/*  update [IT.Macomb_DBA].dbo.EMP_Position_MGT
  set SUPERVISORY_ORG_ID = 'SUP_UNASSIGNED'
  where emp_id in('E022040','E021941','E022072','E010774','E019535')
  */

/*insert into [IT.Macomb_DBA].[dbo].[EMP_Position_MGT]
(Dept,
Emp_ID,
Position_Number,
Emp_Type,
Position_Title,
SUPERVISORY_ORG_ID)
select department,ID,'FTBU','','SUP_UNASSIGNED'
--HR_STATUS, lname,fname, mname
  from [production_finance].[dbo].[hr_empmstr] hr
  where hr.entity_id in ('PENS', 'ROOT')
  and hr.hr_status = 'A'
  and id not in (select epm.[Emp_ID] from [IT.Macomb_DBA].dbo.EMP_Position_MGT epm)
  */
