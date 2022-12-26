/*
Macomb_Spend_Template_Sean_9302022.xlsx]
TabName: Supplier_Entity_Contact_Email

Darn the email addresses are duplicated and dirty.
Below will clean them via two temp tables, 
First is to store them for the cleaning process and 
the second is to store the cleaned ones.

Then we will run the query with the cleaned emails
*/
DECLARE @RowsToProcess  int
DECLARE @CurrentRow     int
DECLARE @FindData     int
DECLARE @EmailRaw varchar(128)
DECLARE @EmailPrep varchar(128) -- copy of raw for processing removing whats in Step
DECLARE @EmailStep varchar(128) -- 1 segment of Prep
DECLARE @emailCleaned varchar(128) -- To be saved
DECLARE @ID varchar(12)

DECLARE @SourceEmails TABLE (RowID int not null primary key identity(1,1) 
                       ,PE_ID varchar(12)
							  ,email_addr varchar(128)
							  )
DECLARE @CleanedEmails TABLE (RowID int not null primary key identity(1,1) 
                       ,PE_ID varchar(12)
							  ,email_addr varchar(128)
							  )


INSERT into @SourceEmails (pe_id, email_addr) SELECT pe_id, email_addr 
															FROM [production_finance].[dbo].pe_email_dtl 
															/*WHERE charindex(',',email_Addr) >0*/

SET @RowsToProcess=@@ROWCOUNT

SET @CurrentRow=0
WHILE @CurrentRow<@RowsToProcess
BEGIN
    SET @CurrentRow=@CurrentRow+1
    SELECT 
        @EmailRaw=email_Addr,
		  @ID = pe_id
        FROM @SourceEmails
        WHERE RowID=@CurrentRow

    --do the cleaning thing here--
	 --multiple emails?
	IF charindex(',',@EmailRaw) >0
	BEGIN
	   --select @EmailPrep = @EmailRaw
	/*		Print @EmailRaw
			Print REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),1),'~','.'))))
			Print REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),2),'~','.'))))
			Print REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),3),'~','.'))))
			Print REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),4),'~','.'))))
	*/
		IF len(REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),1),'~','.')))))>0
			AND charindex('.',REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),1),'~','.')))))>0 
			AND charindex('@',REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),1),'~','.')))))>0
	     --insert
		BEGIN
			SET @FindData = 0
			select @FindData = 1 from @CleanedEmails where pe_id = @ID and email_addr = REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),1),'~','.'))))
			IF @FindData = 0 
			BEGIN
			INSERT into @CleanedEmails (pe_id, email_addr) values (@ID, REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),1),'~','.')))))
			END
			else
			BEGIN
			Print 'dup multiple email 1 '+@emailRaw
			END
		END
		IF len(REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),2),'~','.')))))>0
			AND charindex('.',REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),2),'~','.')))))>0 
			AND charindex('@',REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),2),'~','.')))))>0
	     --insert
		BEGIN
			SET @FindData = 0
			select @FindData = 1 from @CleanedEmails where pe_id = @ID and email_addr = REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),2),'~','.'))))
			IF @FindData = 0 
			BEGIN
			INSERT into @CleanedEmails (pe_id, email_addr) values (@ID, REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),2),'~','.')))))
			END
			else
			BEGIN
			Print 'dup multiple email 2 '+@emailRaw
			END
		END
		IF len(REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),3),'~','.')))))>0
			AND charindex('.',REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),3),'~','.')))))>0 
			AND charindex('@',REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),3),'~','.')))))>0
	     --insert
		BEGIN
			SET @FindData = 0
			select @FindData = 1 from @CleanedEmails where pe_id = @ID and email_addr = REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),3),'~','.'))))
			IF @FindData = 0 
			BEGIN
				INSERT into @CleanedEmails (pe_id, email_addr) values (@ID, REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),3),'~','.')))))
			END
			else
			BEGIN
				Print 'dup multiple email 3 '+@emailRaw
			END
		END
		IF len(REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),4),'~','.')))))>0
			AND charindex('.',REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),4),'~','.')))))>0 
			AND charindex('@',REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),4),'~','.')))))>0
	     --insert
		BEGIN
			SET @FindData = 0
			select @FindData = 1 from @CleanedEmails where pe_id = @ID and email_addr = REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),4),'~','.'))))
			IF @FindData = 0 
			BEGIN
				INSERT into @CleanedEmails (pe_id, email_addr) values (@ID, REVERSE(lower(trim(replace(parsename(REVERSE(replace(replace(@emailRaw,'.','~'),',','.')),4),'~','.')))))
			END
		else
			BEGIN
				Print 'dup multiple email 4 '+@emailRaw
			END
		END
		/*WHILE (charindex(',',@EmailPrep) >0 OR LEN(@EmailPrep) >0)
		BEGIN
			select @EmailStep = left(@EmailPrep,charindex(',',@EmailPrep)-1)
			Print @EmailStep
			Print Len(@EmailPrep)
			Print @EmailPrep
			Print len(@EmailStep)
			--Print right(@EmailPrep,(Len(@EmailPrep)-(len(@EmailStep)+1)))
			Print right(@EmailPrep,25)
			Print substring(@EmailPrep,Len(@EmailStep)+2,(Len(@EmailPrep)-(len(@EmailStep))))
			
			select @EmailPrep = right(@EmailPrep,(Len(@EmailPrep)-(len(@EmailStep)+1)))
			Print 'email prep'
			Print @EmailPrep
			IF charindex('@',@EmailStep)>0 and charindex('.',@EmailStep)>0
			Print 'Save email its cleanish'
	 -- end cleaning --
		END */
	END
	ELSE
	BEGIN
		IF len(@emailRaw)>0
			AND charindex('.',@emailRaw)>0 
			AND charindex('@',@emailRaw)>0
		BEGIN
			SET @FindData = 0
			select @FindData = 1 from @CleanedEmails where pe_id = @ID and email_addr = @emailRaw
			IF @FindData = 0 
			BEGIN
				INSERT into @CleanedEmails (pe_id, email_addr) values (@ID, @emailRaw)
			END
		END
		ELSE 
		BEGIN
			Print 'single email Failed to be email '+@emailRaw
		END
	END
END

/*
Macomb_Spend_Template_Sean_V1.xlsx]
TabName: Supplier_Entity_Contact_Email
*/
SELECT
 trim(pe_name_mstr.pe_id) as 'SupplierContactID'
,'"Steve Smigiel, Lynne Lapierre"' as 'SourceSystem'
,ROW_NUMBER() OVER (PARTITION BY pe_name_mstr.pe_id ORDER BY pe_name_mstr.pe_id) as 'SortOrder'
,IIF(ROW_NUMBER() OVER (PARTITION BY pe_name_mstr.pe_id ORDER BY pe_name_mstr.pe_id)=1,'Y','N') as 'Primary'
,trim(CE.email_addr) as 'EmailAddress'
,'Y' as 'Public'
,0 as 'EmailComments'
,0 as 'UseForReference'
,0 as 'UseForReference2'
,0 as 'UseForReference3'

from [production_finance].[dbo].[pe_name_mstr]
     RIGHT JOIN @CleanedEmails CE
	  ON pe_name_mstr.pe_id  = CE.pe_id 
WHERE pe_name_mstr.PE_ID in (select distinct oh_pe_id
	FROM [production_finance].[dbo].oh_dtl
	RIGHT JOIN [production_finance].[dbo].[pe_name_mstr]
	  ON  oh_dtl.oh_pe_id = pe_name_mstr.pe_id
	RIGHT JOIN [production_finance].[dbo].glk_key_mstr
	  ON oh_dtl.oh_gl_key = glk_key_mstr.glk_key
	where oh_dtl.oh_ck_dt between case
		WHEN glk_key_mstr.GLK_SEL_CODE07 = 'DEC' THEN convert(date,'12/31/'+cast(year(getdate())-2 as varchar),101)
		WHEN glk_key_mstr.GLK_SEL_CODE07 = 'JUN' THEN convert(date,'06/30/'+cast(year(getdate())-1 as varchar),101)
		WHEN glk_key_mstr.GLK_SEL_CODE07 = 'SEP' THEN convert(date,'09/30/'+cast(year(getdate())-1 as varchar),101)
	END and getdate())
order by 1

--select * from [production_finance].[dbo].pe_email_dtl order by 1