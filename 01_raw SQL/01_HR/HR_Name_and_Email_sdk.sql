use [production_finance]
GO

/*name and email address*/
/*
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'USA_Macomb_HCM_CNP_HCM_Template_Mapped.xlsx' as Spreadsheet
,'Name and Email' as TabName
,'HR_name and email address' as QueryName
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
from /*[IT.Macomb_dba].[dbo].[xref_hr_empmster__x__contact] x
     left join [production_finance].[dbo].[hr_empmstr]
	  on x.id = hr_empmstr.id*/
	  [production_finance].[dbo].[hr_empmstr]
where hr_empmstr.ENTITY_ID in ('ROOT','PENS','ROAD') 
 
 and (hr_empmstr.hr_status = 'A'
   OR (hr_empmstr.hr_status = 'I'
      and hr_empmstr.enddt > convert(datetime,'12/31/2021')))
/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
from /*[IT.Macomb_dba].[dbo].[xref_hr_empmster__x__contact] x
     left join [production_finance].[dbo].[hr_empmstr]
	  on x.id = hr_empmstr.id*/
	  [production_finance].[dbo].[hr_empmstr]
where hr_empmstr.ENTITY_ID in ('ROOT','PENS','ROAD') 
 
 and (hr_empmstr.hr_status = 'A'
   OR (hr_empmstr.hr_status = 'I'
      and hr_empmstr.enddt > convert(datetime,'12/31/2021')))
/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;
*/




select 
trim(hr_empmstr.id) as 'WorkerID', hr_status, enddt
/*
,'Denise Krzeminski' as 'SourceSystem'
--c&p,'' as 'ApplicantSource'
,trim(hr_empmstr.country) as 'CountryISOCode'
,trim(upper(hr_empmstr.fname)) as 'LegalFirstName'
,trim(upper(replace(isnull(hr_empmstr.mname,''),'.',''))) as 'LegalMiddleName'
,iif(hr_empmstr.lname = 'GOVAERE-BUSQUAERT', 'GOVAERE-BUSQUAERT',trim(upper(replace(hr_empmstr.lname, ' ','')))) as 'LegalLastName'
,'' as 'LegalSecondaryLastName'
,'' /*hr_empmstr.salute*/ as 'NamePrefix'
,'COUNTRY_PREDEFINED_PERSON_NAME_COMPONENT_'+trim(hr_empmstr.suffix) as 'NameSuffix'
,'' as 'FamilyNamePrefix'
,CASE 
  WHEN hr_empmstr.prefname is not null THEN hr_empmstr.prefname 
  ELSE ''
  END as 'PreferredFirstName'
,CASE 
  WHEN hr_empmstr.prefname is not null THEN hr_empmstr.mname 
  ELSE ''
  END as 'PreferredMiddleName'
,CASE 
  WHEN hr_empmstr.prefname is not null THEN hr_empmstr.lname 
  ELSE ''
  END as 'PreferredLastName'
,'' as 'PreferredSecondaryLastName'
,'' as 'PreferredNamePrefix'
,'' as 'PreferredNameSuffix'
,IIF(hr_empmstr.former is not null, 'USA','') as 'AdditionalCountryISOCode'
,IIF(hr_empmstr.former is not null, trim(upper(hr_empmstr.fname)),'') as 'AdditionalFirstName'
,IIF(hr_empmstr.former is not null,trim(upper(replace(isnull(hr_empmstr.mname,''),'.',''))),'') as 'AdditionalMiddleName'
--,'' as 'AdditionalLastName'
,hr_empmstr.former as 'AdditionalLastName'
,'' as 'AdditionalSecondaryLastName'
,'' as 'AdditionalNameType'
,replace(replace(trim(dbo.fn_parse_e_mail(E_Mail,'P',1)),'@@','@'),'@comcastnet','@comcast.net') as 'EmailAddress-PrimaryHome'
,iif(dbo.fn_parse_e_mail(E_Mail,'P',1)= '','','N') as 'Public-PrimaryHome'
,replace(replace(trim(dbo.fn_parse_e_mail(E_Mail,'W',1)),'@@','@'),'@comcastnet','@comcast.net') as 'EmailAddress-PrimaryWork'
,iif(dbo.fn_parse_e_mail(E_Mail,'W',1)='','','Y') as 'Public-PrimaryWork'
,replace(replace(trim(dbo.fn_parse_e_mail(E_Mail,'P',2)),'@@','@'),'@comcastnet','@comcast.net') as 'EmailAddress-AdditionalHome'
,iif(dbo.fn_parse_e_mail(E_Mail,'P',2)='','','N') as 'Public-AdditionalHome'
,replace(replace(trim(dbo.fn_parse_e_mail(E_Mail,'W',2)),'@@','@'),'@comcastnet','@comcast.net') as 'EmailAddress-AdditionalWork'
,iif(dbo.fn_parse_e_mail(E_Mail,'W',2)='','','N') as 'Public-AdditionalWork'
/*,'------ hr_empmstr -------'
,hr_empmstr.*
--*/
*/

from /*[IT.Macomb_dba].[dbo].[xref_hr_empmster__x__contact] x
     left join [production_finance].[dbo].[hr_empmstr]
	  on x.id = hr_empmstr.id*/
	  [production_finance].[dbo].[hr_empmstr]
where hr_empmstr.ENTITY_ID in ('ROOT','PENS','ROAD') 
 
 and (hr_empmstr.hr_status = 'A'
   OR (hr_empmstr.hr_status = 'I'
      
	  and hr_empmstr.enddt > '2021-12-31'))


and id in (
'C000036','C000280','C000388','C000390','C000476','C000500','C000603','C000608','C000751','C000758','C001021',
'C001225','C001236','C001249','C001254','E001212','E001522','E001727','E001995','E002027','E002277',
'E002468','E002508','E002620','E002718','E003266','E004032','E004040','E004204','E004222','E004451',
'E004536','E004988','E005293','E005331','E005440','E005510','E005575','E005579','E005585','E005774',
'E005776','E005783','E005808','E005990','E006098','E006183','E006301','E006308','E006582','E006671',
'E006731','E006877','E006908','E006969','E007127','E007153','E007401','E007613','E007651','E007948',
'E007999','E008139','E008655','E009239','E009545','E010154','E016969','E017258',
'E017915','E018159','E018278','E018450','E018884','E019009','E019186','E019204','E019468','E019715',
'E019916','E019921','E020033','E020059','E020078','E020082','E020294','E020470','E020542','E020669',
'E020871','E020908','E020975','E020989','E021007','E021041','E021172','E021203','E021217','E021235',
'E021350','E021379','E021393','E021455','E021525','E021548','E021564','E021580','E021608','E021621',
'E021632','E021639','E021669','E021697','E021740','E021748','E021794','E021800','E021826','E021831',
'E021837','E021870','E021876','E021909','E021927','E021931','E021950','E021977','E021983','E021984',
'E022009','E022013','E022018','E022033','E022048','E022053','E022057','E022061','E022077','R000456',
'R000524','R000681','R000727','R000812','R001053','R001111','R001475','R001685','R001982','R001984',
'R002384','R002492','R003100','R003290','R003382','R003383','R003496','R003943','R004085','R005635',
'R005766','R006699','R006735','R006736','R006752','R006753','R006754','R006757','R006786','R006787',
'R006789','R006790','R006793'
)

order by 1

/*
--150 + 11 + 8 + 3 = 172
select enddt
from hr_empmstr
where id in (
'C000036','C000280','C000388','C000390','C000476','C000500','C000603','C000608','C000751','C000758','C001021',
'C001225','C001236','C001249','C001254','E001212','E001522','E001727','E001995','E002027','E002277',
'E002468','E002508','E002620','E002718','E003266','E004032','E004040','E004204','E004222','E004451',
'E004536','E004988','E005293','E005331','E005440','E005510','E005575','E005579','E005585','E005774',
'E005776','E005783','E005808','E005990','E006098','E006183','E006301','E006308','E006582','E006671',
'E006731','E006877','E006908','E006969','E007127','E007153','E007401','E007613','E007651','E007948',
'E007999','E008139','E008655','E009239','E009545','E010154','E016969','E017258',
'E017915','E018159','E018278','E018450','E018884','E019009','E019186','E019204','E019468','E019715',
'E019916','E019921','E020033','E020059','E020078','E020082','E020294','E020470','E020542','E020669',
'E020871','E020908','E020975','E020989','E021007','E021041','E021172','E021203','E021217','E021235',
'E021350','E021379','E021393','E021455','E021525','E021548','E021564','E021580','E021608','E021621',
'E021632','E021639','E021669','E021697','E021740','E021748','E021794','E021800','E021826','E021831',
'E021837','E021870','E021876','E021909','E021927','E021931','E021950','E021977','E021983','E021984',
'E022009','E022013','E022018','E022033','E022048','E022053','E022057','E022061','E022077','R000456',
'R000524','R000681','R000727','R000812','R001053','R001111','R001475','R001685','R001982','R001984',
'R002384','R002492','R003100','R003290','R003382','R003383','R003496','R003943','R004085','R005635',
'R005766','R006699','R006735','R006736','R006752','R006753','R006754','R006757','R006786','R006787',
'R006789','R006790','R006793'
)
 
 and (hr_empmstr.hr_status = 'A'
   OR (hr_empmstr.hr_status = 'I'
      and hr_empmstr.enddt > convert(datetime,'12/31/2021')))

*/

/*
select *
from hr_empmstr
where id = 'E005440'
*/