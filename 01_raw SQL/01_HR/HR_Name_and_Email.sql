use [production_finance]
GO 
/*name and email address*/
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





select 
trim(hr_empmstr.id) as 'WorkerID'
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

from /*[IT.Macomb_dba].[dbo].[xref_hr_empmster__x__contact] x
     left join [production_finance].[dbo].[hr_empmstr]
	  on x.id = hr_empmstr.id*/
	  [production_finance].[dbo].[hr_empmstr]
where hr_empmstr.ENTITY_ID in ('ROOT','PENS','ROAD') 
 
 and (hr_empmstr.hr_status = 'A'
   OR (hr_empmstr.hr_status = 'I'
      and hr_empmstr.enddt > convert(datetime,'12/31/2021')))
-- and not (hr_empmstr.e_mail in ('n/a','not valid','not given') 
--     or hr_empmstr.e_mail is null)
/*hr_empmstr.id in (
'E003844', /* - Denise*/
'E006056', /*- Tom*/
'E003770', /*- Anne*/
'E006082', /*- Arlene*/
'E003542', /*- Joe*/
'E021079' /*- Thida*/
)*/
--and hr_empmstr.id = 'E001555'
--and hr_empmstr.id = 'E021169'
--and hr_empmstr.id in('E005090','E017943')

order by 1