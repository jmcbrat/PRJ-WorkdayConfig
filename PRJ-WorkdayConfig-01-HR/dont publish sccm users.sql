/****** Script for SelectTopNRows command from SSMS  ******/
SELECT distinct /* [UserID]
      ,*/[FullName]
      ,[Domain]
      ,[UserName]
      /*,[UserSID]
      ,[SiteNumber]*/
  FROM [CM_MCG].[dbo].[v_Users]
  where username not in ('Everyone','Administrator','Techadmin','bcuser', '%$%','(system)','%user%','%support%'
  ,'Cltwpadmin','temp','DSServiceUser','mspont','ftrsupport')
  and domain in('HQ','SHERIFF')
  and not username like '%$%'
  and not username like 'ta%'