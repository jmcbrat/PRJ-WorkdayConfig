/*create view for fin_cust_email 
this breaks the emails into multiple rows based on comma
*/
create view fin_cust_email
as
WITH tmp(pe_id, email, email_addr) AS
(
SELECT peed.pe_id /*, peed.email_addr*/
       ,LEFT(email_addr, CHARINDEX(',', email_addr + ',') - 1)
       ,STUFF(email_addr, 1, CHARINDEX(',', email_addr + ','), '')
FROM [production_finance].[dbo].pe_email_dtl peed

    UNION all

SELECT peed.pe_id /*, peed.email_addr*/
       ,LEFT(email_addr, CHARINDEX(',', email_addr + ',') - 1)
       ,STUFF(email_addr, 1, CHARINDEX(',', email_addr + ','), '')
FROM [production_finance].[dbo].pe_email_dtl peed
    WHERE
        email_addr > ''
)
SELECT DISTINCT
    pe_id,
    email
FROM tmp
WHERE pe_id = 'V04997'
ORDER BY pe_id;


select distinct email_type_cd, count(*)
from pe_email_dtl
group by email_type_cd

select *
from pe_email_dtl
where pe_id = 'V04997'