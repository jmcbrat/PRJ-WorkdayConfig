USE [IT.Macomb_DBA]
GO

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'smoketest'))
	BEGIN
		create table dbo.smoketest 
		(
		Spreadsheet varchar(200)
		,TabName varchar(100)
		,QueryName varchar(200)
		,ROOTCnt int
		,ROADCnt int
		,PENSCnt int
		,ZINSCnt int
		,ROOTRet int
		,ROADRet int
		,PENSRet int
		,TotalRecords int
		);
		PRINT N'created table.'; 
	END
else
	begin
		delete from [IT.Macomb_DBA].dbo.smoketest; 
		PRINT N'deleted table data.'; 
	END 
GO
USE production_finance
GO


/*
SELECT * from [IT.Macomb_DBA].dbo.smoketest
*/