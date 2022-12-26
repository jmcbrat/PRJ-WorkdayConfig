select us_id, us_name_u, us_name,  us_email 
from  us_usno_mstr
Where us_status = 'A'
and left(us_id,1) = 'E'
and us_email is not null 
and us_email like '%@m%' and not us_email like '%/%';

select ID, Fname, Mname, Lname, e_mail, gender 
,trim(dbo.fn_parse_e_mail(E_Mail,'W',1)) as 'R-EmailAddress-PrimaryWork'
--,iif(dbo.fn_parse_e_mail(E_Mail,'W',1)='','','Y') as 'R-Public-PrimaryWork'
,trim(dbo.fn_parse_e_mail(E_Mail,'W',2)) as 'R-EmailAddress-AdditionalWork'
--,iif(dbo.fn_parse_e_mail(E_Mail,'W',2)='','','N') as 'R-Public-AdditionalWork'
,'  ' as ADAccount
from hr_empmstr 
where entity_id = 'ROOT' 
--and hr_empmstr.hr_status = 'A' 
order by 1



select * from  hr_addrwloc where entity_id = 'ROOT' and e_mail is not null;

select top 10 * from  hr_addrwloc_l;
