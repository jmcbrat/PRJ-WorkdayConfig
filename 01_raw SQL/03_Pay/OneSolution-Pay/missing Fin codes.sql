--select * from [IT.Macomb_DBA].[dbo].[Equiv_Earnings]
--where code not in (

select distinct pyx_no from [production_finance].[dbo].[pyx_xtd_dtl]
where not pyx_no in (select distinct code from [IT.Macomb_DBA].[dbo].[Equiv_Earnings])
order by pyx_no


select top 1000 * from [production_finance].[dbo].[pyx_xtd_dtl]

select * from [production_finance].[dbo].py_cdh_mstr
where --not py_cdh_no in (select distinct code from [IT.Macomb_DBA].[dbo].[Equiv_Earnings]) --= 3919
not py_cdh_no in (select distinct code from [IT.Macomb_DBA].[dbo].[Equiv_Deductions])


order by py_cdh_no

SELECT m.py_cdh_no,py_cdh_cd,py_cdh_title
,d.code, e.code
FROM [production_finance].[dbo].py_cdh_mstr m
LEFT JOIN [IT.Macomb_DBA].[dbo].[Equiv_Deductions] d ON d.code = m.PY_CDH_NO
LEFT JOIN [IT.Macomb_DBA].[dbo].[Equiv_Earnings] e ON e.code = m.PY_CDH_NO
WHERE (d.code IS NULL and e.code is null)
order by py_cdh_no

--.py_cdh_cd py_cdh_title py_cdh_no