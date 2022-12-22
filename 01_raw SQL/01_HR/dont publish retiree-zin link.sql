/****** Script for SelectTopNRows command from SSMS  ******/
SELECT h.[ENTITY_ID]
      ,h.[FNAME]
      ,h.[GENDER]
      ,h.[ID]
      ,h.[LNAME]
      ,h.[MNAME]
      ,h.[NAME]
      ,h.[NOTES]
,'------- h2 ---------'
      ,h2.[FNAME]
      ,h2.[GENDER]
      ,h2.[ID]
      ,h2.[LNAME]
      ,h2.[MNAME]
      ,h2.[NAME]
      ,h2.[NOTES]
  FROM [production_finance].[dbo].[hr_empmstr] h
       LEFT OUTER JOIN [production_finance].[dbo].[hr_empmstr] h2
		 ON (h.id = left(h2.notes,7)  OR left(h.notes,7) = h2.id)
		    and left(h2.notes,1) = 'R'
  where --(h.id = 'Z000404' or h.id = 'R002238')
    left(h.id,1) in ('R'/*,'E','C'*/)
	 --and h.id = 'R000225'