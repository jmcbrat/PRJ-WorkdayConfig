select 
id,
fname,mname,lname,SUFFIX 
from hr_empmstr /*where id in ('e004080'
,'E017656'
,'E019282'
,'E021320'
,'E021452'
,'E021878'
,'E003542')*/
where trim(lname) like '%,%'
or trim(lname) like '% %'
or trim(lname) like '%''%'
or trim(lname) like '%`%'
