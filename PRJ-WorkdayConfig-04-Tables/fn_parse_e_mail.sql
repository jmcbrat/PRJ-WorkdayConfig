USE [production_finance]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_parse_e_mail]    Script Date: 5/25/2022 7:39:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER function [dbo].[fn_parse_e_mail] (@e_mail_txt VARCHAR(70), @type char(1), @seq INT)
RETURNS VARCHAR(70)
AS 
BEGIN
  DECLARE @email1 AS VARCHAR(70)
  DECLARE @email2 AS VARCHAR(70)
  DECLARE @d1 AS VARCHAR(70)
  DECLARE @d2 AS VARCHAR(70)
  DECLARE @acct1 AS VARCHAR(70)
  DECLARE @acct2 AS VARCHAR(70)
  DECLARE @e1_p AS INT
  DECLARE @e2_p AS INT
  DECLARE @w_or_p1 AS char(1)
  DECLARE @w_or_p2 AS char(1)

  IF (@e_mail_txt IS NULL )
    BEGIN 
      RETURN ''  -- nothing to do here
    END

  IF (CHARINDEX('/',@e_mail_txt)>0)  
    BEGIN
      SET @email1 = trim(lower(left(@e_mail_txt,CHARINDEX('/',@e_mail_txt)-1)))
      if (charindex('@',@email1)>0)
		begin
        SET @d1 = right(@email1,len(@email1)-charindex('@',@email1)+1)
        SET @acct1 = left(@email1,charindex('@',@email1)-1) 
        SELECT @d1 = CASE 
          WHEN @d1 = '@macombgov.org' THEN @d1
          WHEN @d1 = '@macombcountymi.gov' THEN @d1
          WHEN @d1 = '@mccmh.net' THEN @d1
          WHEN @d1 = '@macomb-stclairworks.org' THEN @d1
          WHEN @d1 = '@rcmcweb.org' THEN @d1
          WHEN left(@d1,2)='@Y' THEN '@yahoo.com'
          WHEN left(@d1,2)='@g' THEN '@gmail.com'
          WHEN left(@d1,2)='@h' THEN '@hotmail.com' 
	       WHEN @d1 = '@mcombgov.org' THEN '@macombgov.org'
          ELSE @d1
          END

        SELECT @e1_p = CASE 
          WHEN @email1 like '%@macombgov.org' THEN 1
          WHEN @email1 like '%@mcombgov.org' THEN 1
          WHEN @email1 like '%@macombcountymi.gov' THEN 2
          WHEN @email1 like '%@mccmh.net' THEN 3
          WHEN @email1 like '%@macomb-stclairworks.org' THEN 4
          WHEN @email1 like '%@rcmcweb.org' THEN 5
          WHEN @email1 like null THEN 7
          ELSE 6
          END
        SELECT @w_or_p1 = CASE 
          WHEN @email1 like '%@macombgov.org' THEN 'W'
          WHEN @email1 like '%@mcombgov.org' THEN 'W'
          WHEN @email1 like '%@macombcountymi.gov' THEN 'W'
          WHEN @email1 like '%@mccmh.net' THEN 'W'
          WHEN @email1 like '%@macomb-stclairworks.org' THEN 'W'
          WHEN @email1 like '%@rcmcweb.org' THEN 'W'
          WHEN @email1 like null THEN 'P'
          ELSE 'P'
          END
        END
        ELSE
          BEGIN
            RETURN '' --'NOT VALID EMAIL 1'
          END
      SET @email2 = trim(lower(substring(@e_mail_txt,CHARINDEX('/',@e_mail_txt)+1,len(@e_mail_txt))))
		IF (charindex('@',@email2)>0)
		BEGIN
        SET @d2 = right(@email2,len(@email2)-charindex('@',@email2)+1)
        SET @acct2 = left(@email2,charindex('@',@email2)-1) 
        SELECT @d2 = CASE 
          WHEN @d2 = '@macombgov.org' THEN @d2
          WHEN @d2 = '@macombcountymi.gov' THEN @d2
          WHEN @d2 = '@mccmh.net' THEN @d2
          WHEN @d2 = '@macomb-stclairworks.org' THEN @d2
          WHEN @d2 = '@rcmcweb.org' THEN @d2
          WHEN left(@d2,2)='@Y' THEN '@yahoo.com'
          WHEN left(@d2,2)='@g' THEN '@gmail.com'
          WHEN left(@d2,2)='@h' THEN '@hotmail.com'
          WHEN left(@d2,2)='@i' THEN '@icloud.com'
			 WHEN @d2 = '@mcombgov.org' THEN '@macombgov.org'
          ELSE @d2
          END
        SELECT @e2_p = CASE 
          WHEN @email2 like '%@macombgov.org' THEN 1
          WHEN @email2 like '%@mcombgov.org' THEN 1
          WHEN @email2 like '%@macombcountymi.gov' THEN 2
          WHEN @email2 like '%@mccmh.net' THEN 3
          WHEN @email2 like '%@macomb-stclairworks.org' THEN 4
          WHEN @email2 like '%@rcmcweb.org' THEN 5
          WHEN @email2 like null THEN 7
          ELSE 6
          END
        SELECT @w_or_p2 = CASE 
          WHEN @email2 like '%@macombgov.org' THEN 'W'
          WHEN @email2 like '%@mcombgov.org' THEN 'W'
          WHEN @email2 like '%@macombcountymi.gov' THEN 'W'
          WHEN @email2 like '%@mccmh.net' THEN 'W'
          WHEN @email2 like '%@macomb-stclairworks.org' THEN 'W'
          WHEN @email2 like '%@rcmcweb.org' THEN 'W'
          WHEN @email2 like null THEN 'P'
          ELSE 'P'
          END
        END
      ELSE
        BEGIN
          SET @acct2 = ''
			 SET @d2 = ''
          --RETURN 'Not valid email 2'
        END
      /*IF ((@acct1 is null or @acct1 = '') and (@acct2 is not null or @acct2 <> ''))
			set @acct1 = @acct2
			set @acct2 = ''
			set @d1 = @d2
			set @d2 = ''
*/
      IF (@type = 'W' and @seq = 1 and @w_or_p1 = 'W' and @acct1 <> '')
        BEGIN
          RETURN @acct1 + @d1
        END
      IF (@type = 'W' and @seq = 2 and @w_or_p2 = 'W' and @w_or_p1 = 'W')
        BEGIN
          RETURN @acct2 + @d2
        END
      IF (@type = 'P' and @seq = 1 and @w_or_p1 = 'P')
        BEGIN
          RETURN @acct1 + @d1
        END

      IF (@type = 'P' and @seq = 2 and @w_or_p2 = 'P' and @w_or_p1 = 'P') 
        BEGIN
          RETURN @acct2 + @d2
        END
      IF (@type = 'P' and @seq = 1 and @w_or_p2 = 'P' and @w_or_p1 = 'W') 
        BEGIN
          RETURN @acct2 + @d2
        END
--		SET @d2 = substring(substring(@email2,1,CHARINDEX('/',@email2)-1),CHARINDEX('@',substring(@email2,1,CHARINDEX('/',@email2)-1))+1,Len(substring(@email2,1,CHARINDEX('/',@email2)-1))-CHARINDEX('@',substring(@email2,1,CHARINDEX('/',@email2)-1)))
    END
  ELSE
  BEGIN
    SET @email1 = trim(lower(trim(@e_mail_txt)))
    IF (charindex('@',@email1))=0
      BEGIN 
        RETURN '' --'not valid 3' 
      END
    SET @d1 = right(@email1,len(@email1)-charindex('@',@email1)+1)
    SET @acct1 = left(@email1,charindex('@',@email1)-1) 
    SELECT @d1 = CASE 
             WHEN @d1 = '@macombgov.org' THEN @d1
             WHEN @d1 = '@macombcountymi.gov' THEN @d1
             WHEN @d1 = '@mccmh.net' THEN @d1
             WHEN @d1 = '@macomb-stclairworks.org' THEN @d1
             WHEN @d1 = '@rcmcweb.org' THEN @d1
             WHEN left(@d1,2)='@Y' THEN '@yahoo.com'
             WHEN left(@d1,2)='@g' THEN '@gmail.com'
             WHEN left(@d1,2)='@h' THEN '@hotmail.com'
             WHEN left(@d2,2)='@i' THEN '@icloud.com'
             ELSE @d1
             END
    SELECT @e1_p = CASE 
         WHEN @email1 like '%@macombgov.org' THEN 1
         WHEN @email1 like '%@macombcountymi.gov' THEN 2
         WHEN @email1 like '%@mccmh.net' THEN 3
         WHEN @email1 like '%@macomb-stclairworks.org' THEN 4
         WHEN @email1 like '%@rcmcweb.org' THEN 5
         WHEN @email1 like null THEN 7
         ELSE 6
         END
    SELECT @w_or_p1 = CASE 
         WHEN @email1 like '%@macombgov.org' THEN 'W'
         WHEN @email1 like '%@macombcountymi.gov' THEN 'W'
         WHEN @email1 like '%@mccmh.net' THEN 'W'
         WHEN @email1 like '%@macomb-stclairworks.org' THEN 'W'
         WHEN @email1 like '%@rcmcweb.org' THEN 'W'
         WHEN @email1 like null THEN 'P'
         ELSE 'P'
         END
/*
      IF ((@acct1 is null or @acct1 = '') and (@acct2 is not null or @acct2 <> ''))
			set @acct1 = @acct2
			set @acct2 = ''
			set @d1 = @d2
			set @d2 = ''
*/

    IF (@type = 'W' and @seq = 1 and @w_or_p1 = 'W')
      BEGIN
        RETURN @acct1 + @d1
      END
    IF (@type = 'W' and @seq = 2 and @w_or_p2 = 'W')
      BEGIN
        RETURN @acct2 + @d2
      END

    IF (@type = 'P' and @seq = 1 and @w_or_p1 = 'P')
      BEGIN
        RETURN @acct1 + @d1
      END
    IF (@type = 'P' and @seq = 2 and @w_or_p2 = 'P')
      BEGIN
        RETURN @acct2 + @d2
      END
  END
  RETURN ''
END