/*SECURITY-Assign Role Based Security*/
SELECT
Organization_ID as 'OrganizationID'
,Organization_Type as 'OrganizationType'
,Organization_Role_ID as 'OrganizationRoleID'
,Source_System as 'SourceSystem'
,Worker_ID as 'WorkerID'
,Position_ID as 'PositionID'
,Effective_Date as 'EffectiveDate'
FROM [IT.Macomb_dba].[dbo].Security_Assign_Role_based 
/*UNION ALL
SELECT
SUPERVISORY_ORG_ID as 'OrganizationID'
,'Organization_Reference_ID' as 'OrganizationType'
,'HR_Partner_Supervisory' as 'OrganizationRoleID'
,'Arlene Zdybel' as 'SourceSystem'
,Emp_ID as 'WorkerID'
,Position_Number as 'PositionID'
,null as 'EffectiveDate'
FROM [IT.Macomb_dba].[dbo].Supervisory_Org
WHERE emp_id is not null*/
 /*where  trim(worker_id) in (
'E003844', /* - Denise*/
'E006056', /*- Tom*/
'E003770', /*- Anne*/
'E006082', /*- Arlene*/
'E003542', /*- Joe*/
'E021079' /*- Thida*/
-- pull in sup org people with the details below:
-- org id is - supervisory org id
-- org role id - HR_Partner_Supervisory
) --*/

order by 5