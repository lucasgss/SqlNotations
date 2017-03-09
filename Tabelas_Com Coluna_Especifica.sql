-- Query A - Retorna sobre todas a base atual a tabela com a coluna --
SELECT c.name AS ColName, t.name AS TableName
FROM sys.columns c
    JOIN sys.tables t ON c.object_id = t.object_id
WHERE c.name LIKE '%logId%'

-- Query B - Retorna sobre todas as bases a tabela com a coluna --


SET NOCOUNT ON
begin 
 Declare @hanktst TABLE (
    [TABLE_CATALOG]              NVARCHAR(128) NULL
   ,[TABLE_SCHEMA]               NVARCHAR(128) NULL
   ,[TABLE_NAME]                 sysname NOT NULL
   ,[COLUMN_NAME]                sysname NULL
   ,[ORDINAL_POSITION]           INT NULL
   ,[COLUMN_DEFAULT]             NVARCHAR(4000) NULL
   ,[IS_NULLABLE]                VARCHAR(3) NULL
   ,[DATA_TYPE]                  NVARCHAR(128) NULL
   ,[CHARACTER_MAXIMUM_LENGTH]   INT NULL
   ,[CHARACTER_OCTET_LENGTH]     INT NULL
   ,[NUMERIC_PRECISION]          TINYINT NULL
   ,[NUMERIC_PRECISION_RADIX]    SMALLINT NULL
   ,[NUMERIC_SCALE]              INT NULL
   ,[DATETIME_PRECISION]         SMALLINT NULL
   ,[CHARACTER_SET_CATALOG]      sysname NULL
   ,[CHARACTER_SET_SCHEMA]       sysname NULL
   ,[CHARACTER_SET_NAME]         sysname NULL
   ,[COLLATION_CATALOG]          sysname NULL
   ,[COLLATION_SCHEMA]           sysname NULL
   ,[COLLATION_NAME]             sysname NULL
   ,[DOMAIN_CATALOG]             sysname NULL
   ,[DOMAIN_SCHEMA]              sysname NULL
   ,[DOMAIN_NAME]                sysname NULL
   )
       Declare 
      @DBName sysname
      ,@SQL_String2 nvarchar(4000)
      ,@TempRowCnt varchar(20)
      ,@Dbug bit = 0
      Declare DB_cursor CURSOR
      FOR 
           SELECT  name  FROM sys.databases 
          WHERE STATE = 0  
        --  and Name not IN ('master','msdb','tempdb','model','DocxPress')
          and Name not IN ('msdb','tempdb','model','DocxPress')
      Open DB_cursor
      Fetch next from DB_cursor into @DBName
      While @@FETCH_STATUS = 0
        begin 
        set @SQL_String2 = ' select * into ##Temp_Column_Info from [' + @DBName + '].INFORMATION_SCHEMA.COLUMNS 
        where UPPER(Column_Name) like ''VEICID%''
        ;'
          if @Dbug = 1  Select @SQL_String2 as '@SQL_String2';
          EXEC sp_executesql @SQL_String2;
          insert into @hanktst
          select * from ##Temp_Column_Info;
          drop table ##Temp_Column_Info;
         Fetch next From DB_cursor into @DBName
        end
        select * from @hanktst order by 4,2,3
      CLOSE DB_cursor;
      Deallocate DB_cursor;
      set @TempRowCnt = (select cast(count(1) as varchar(10)) from @hanktst )
       Print ('Rows found: '+ @TempRowCnt +'  end ...') 
end  