/*SECURITY-Assign User Based Security*/
SELECT 
User_Based_Security_Group as 'User-Based Security Group' /*How do i define this???*/
,Source_System as 'SourceSystem'
,trim(Worker_ID) as 'Worker ID'

FROM [IT.Macomb_dba].dbo.Security_Assign_User_based
/*UNION ALL
SELECT
'HR_Administrator' as 'User-Based Security Group'
,'Arlene Zdybel' as 'SourceSystem'
,Emp_ID as 'WorkerID'

FROM [IT.Macomb_dba].[dbo].Supervisory_Org
WHERE emp_id is not null*/

 /*where  trim(worker_id) in (
'E003844', /* - Denise*/
'E006056', /*- Tom*/
'E003770', /*- Anne*/
'E006082', /*- Arlene*/
'E003542', /*- Joe*/
'E021079' /*- Thida*/
) --*/
--User_Based_Security_Group -- HR_Administrator

order by 3