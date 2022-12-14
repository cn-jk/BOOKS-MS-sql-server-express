USE [master]
GO
/****** Object:  Database [BOOKS]    Script Date: 11/15/2022 2:04:45 AM ******/
CREATE DATABASE [BOOKS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BOOKS', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\BOOKS.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'BOOKS_log', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\BOOKS_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [BOOKS] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BOOKS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BOOKS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BOOKS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BOOKS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BOOKS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BOOKS] SET ARITHABORT OFF 
GO
ALTER DATABASE [BOOKS] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [BOOKS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BOOKS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BOOKS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BOOKS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BOOKS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BOOKS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BOOKS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BOOKS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BOOKS] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BOOKS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BOOKS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BOOKS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BOOKS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BOOKS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BOOKS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BOOKS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BOOKS] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [BOOKS] SET  MULTI_USER 
GO
ALTER DATABASE [BOOKS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BOOKS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BOOKS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BOOKS] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [BOOKS] SET DELAYED_DURABILITY = DISABLED 
GO
USE [BOOKS]
GO
/****** Object:  User [books_user]    Script Date: 11/15/2022 2:04:45 AM ******/
CREATE USER [books_user] FOR LOGIN [books_login] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [books_user]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Get_GUID_The_Book]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_Get_GUID_The_Book] 
(
    --  @str_for_poisk nvarchar(MAX)
	-- Add the parameters for the function here
            @str_nazvanie nvarchar(MAX) = '',
            @str_autor    nvarchar(MAX) = '',
            @str_year_print nvarchar(MAX)='',
            @str_id_junr  nvarchar(MAX) = ''
)

RETURNS uniqueidentifier -- GUID
AS
BEGIN -- mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
	-- Declare the return variable here
	DECLARE @result uniqueidentifier  = CAST(0x0 AS UNIQUEIDENTIFIER); -- = '0000-0000-0000-0000-0000-0000-0000-0000';
	DECLARE @str_for_poisk nvarchar(MAX) = 
            LTRIM(RTRIM(@str_nazvanie))  +'|'+
            LTRIM(RTRIM(@str_autor))     +'|'+
            LTRIM(RTRIM(@str_year_print))+'|'+
            LTRIM(RTRIM(@str_id_junr));  

	IF EXISTS -- nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn
	  (
		SELECT DISTINCT id_uniq FROM tb_BOOKS b    
		  WHERE @str_for_poisk LIKE     
		  (
            LTRIM(RTRIM(b.nazvanie)) +'|' +
            LTRIM(RTRIM(b.autor))    +'|' +
            LTRIM(RTRIM(CAST(b.year_print as varchar(MAX)))) +'|' +
            LTRIM(RTRIM(CAST(b.id_junr as varchar(MAX))))
          )
	  )

	-- Add the T-SQL statements to compute the return value here
	-- SELECT <@ResultVar, sysname, @Result> = <@Param1, sysname, @p1>
	BEGIN -- nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn
	  SET @result =
	    (
		SELECT TOP 1 id_uniq FROM tb_BOOKS b WHERE @str_for_poisk LIKE     
		  (
            LTRIM(RTRIM(b.nazvanie)) +'|' +
            LTRIM(RTRIM(b.autor))    +'|' +
            LTRIM(RTRIM(CAST(b.year_print as varchar(MAX)))) +'|' +
            LTRIM(RTRIM(CAST(b.id_junr as varchar(MAX))))
          )
		)     
	END;

	-- Return the result of the function
  RETURN @result  -- nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn

END

GO
/****** Object:  UserDefinedFunction [dbo].[fn_Is_Clone_Book]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_Is_Clone_Book] (
                                          @str_nazvanie nvarchar(MAX) = '',
                                          @str_autor    nvarchar(MAX) = '',
                                          @str_year_print nvarchar(MAX)='',
                                          @str_id_junr  nvarchar(MAX) = '')   --  @str_for_poisk nvarchar(MAX)

RETURNS varchar(3)

AS

BEGIN

	DECLARE @result varchar(3) = 'no';
	DECLARE @str_for_poisk nvarchar(MAX) = 
                           LTRIM(RTRIM(@str_nazvanie))  +'|'+
                           LTRIM(RTRIM(@str_autor))     +'|'+
                           LTRIM(RTRIM(@str_year_print))+'|'+
                           LTRIM(RTRIM(@str_id_junr));  

	IF EXISTS
	  (
		SELECT id_uniq FROM tb_BOOKS b    
		  WHERE @str_for_poisk LIKE     
		  (
           LTRIM(RTRIM(b.nazvanie)) +'|' +
           LTRIM(RTRIM(b.autor))    +'|' +
           LTRIM(RTRIM(CAST(b.year_print as varchar(MAX)))) +'|' +
           LTRIM(RTRIM(CAST(b.id_junr as varchar(MAX)))
          )
	 -- (LTRIM(b.nazvanie)+'|'+LTRIM(b.autor)+'|'+LTRIM(CAST(b.year_print as char(4)))+'|'+LTRIM(CAST(b.id_junr as nvarchar(4)) )
	  )
    )
		BEGIN
		    SET @result = 'yes'
		END;

	RETURN @result
END

GO
/****** Object:  UserDefinedFunction [dbo].[fn_Is_Junr]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================
-- Author:		<Author,,Name>
-- Create date: 2022-06-24, ,>
-- Description:	PROVERKA? @int_id_junr, ,>
	--
	-- PROVERKA? @int_id_junr	----2022-06-24----------------------------------
	--
-- =============================================================================
CREATE FUNCTION [dbo].[fn_Is_Junr] (@int_id_junr int)
RETURNS varchar(3)

AS BEGIN

	DECLARE @result varchar(3) = 'no';
	
	IF EXISTS
	  (SELECT j.id  FROM [BOOKS].[dbo].[tb_junrs] as j WHERE j.id LIKE @int_id_junr)
		BEGIN
		    SET @result = 'yes'
		END;

	RETURN @result
END

GO
/****** Object:  UserDefinedFunction [dbo].[fn_Result_Multiply_Percent]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: BOOKS-DB-SCRIPT-DB.sql|87|0|Z:\_MY_LIFE========----====\_RABOTA_\_TESTOVYE_ZADANIA_\Voltmart---========\BOOKS-DB-SCRIPT-DB.sql
-- =============================================
--
-- =============================================

CREATE FUNCTION [dbo].[fn_Result_Multiply_Percent] (@str_Percent nvarchar(MAX))

RETURNS float

AS
BEGIN

DECLARE @var_index_mult SMALLINT
	   ,@var_index_div  SMALLINT
	   ,@var_result		   FLOAT = 1
	   ,@var_cur_percent   FLOAT
	   ,@var_length_max SMALLINT
	   ,@var_length     SMALLINT;


	SET @str_Percent =    '*' + LTRIM(@str_Percent);
	SET @var_length_max = LEN(@str_Percent);

	LABEL_DO_LOOP:	--\\DO..WHILE()\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

	SET @var_length = LEN(@str_Percent);

	IF (@var_length = 0) GOTO LABEL_FINISH;


	SET @var_index_mult =
	IIF(CHARINDEX('*', REVERSE(@str_Percent)) = 0, @var_length_max, CHARINDEX('*', REVERSE(@str_Percent)));

	SET @var_index_div  =
	IIF(CHARINDEX('/', REVERSE(@str_Percent)) = 0,(@var_length_max+1), CHARINDEX('/', REVERSE(@str_Percent)));


	IF (@var_index_mult < @var_index_div)
		BEGIN
			SET @var_cur_percent = CAST(REVERSE(LEFT(REVERSE(@str_Percent), (@var_index_mult-1))) as float);
			SET @var_result =      @var_result * @var_cur_percent;
			SET @str_Percent =     REVERSE(SUBSTRING( REVERSE(@str_Percent), (@var_index_mult + 1),  (@var_length_max+1)))
		END
	ELSE  --*---------------------------------------------
		BEGIN
			SET @var_cur_percent = CAST(REVERSE(LEFT(REVERSE(@str_Percent), (@var_index_div-1))) as float);
			SET @var_result =      @var_result / @var_cur_percent;
			SET @str_Percent =     REVERSE(SUBSTRING( REVERSE(@str_Percent), (@var_index_div + 1),  (@var_length_max+1)))
		END;  --*-----------------------------------------

	IF (@var_length <> 0) GOTO LABEL_DO_LOOP;	--GOTO LABEL_DO_LOOP \\\\\\\\\\

	LABEL_FINISH:	--END -- WHILE	-------------------------------

	RETURN CAST(@var_result as float);
	--RETURN @var_result;
END


GO
/****** Object:  Table [dbo].[Pet]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pet](
	[Pet_Id] [int] IDENTITY(100000,1) NOT NULL,
	[Pet_Name] [nvarchar](50) NOT NULL,
	[Pet_Type] [nvarchar](50) NOT NULL,
	[Pet_Colour] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Pet_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tb_books]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tb_books](
	[id_uniq] [uniqueidentifier] NOT NULL,
	[nazvanie] [nvarchar](max) NOT NULL,
	[autor] [nvarchar](max) NOT NULL,
	[year_print] [smallint] NOT NULL,
	[id_junr] [smallint] NOT NULL,
 CONSTRAINT [PK_tb_books] PRIMARY KEY CLUSTERED 
(
	[id_uniq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tb_junrs]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tb_junrs](
	[id] [smallint] IDENTITY(10,10) NOT NULL,
	[nazvanie] [nvarchar](50) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tb_junrs2]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tb_junrs2](
	[id] [smallint] IDENTITY(10,10) NOT NULL,
	[nazvanie] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tb_junrs2] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbBooks]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbBooks](
	[id] [int] IDENTITY(2,10) NOT NULL,
	[nazvanie] [nvarchar](max) NOT NULL,
	[autor] [nvarchar](max) NOT NULL,
	[year_print] [smallint] NOT NULL,
	[id_junr] [smallint] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbKontakts]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbKontakts](
	[id] [int] IDENTITY(0,10) NOT NULL,
	[KontaktName] [nvarchar](50) NULL,
	[PhoneNumber] [varchar](25) NULL,
	[Email] [varchar](100) NULL,
	[Address] [nvarchar](255) NULL,
 CONSTRAINT [PK_tbKontakts] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TblContacto]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TblContacto](
	[Id] [int] NULL,
	[Nombre] [varchar](50) NULL,
	[Telefono] [varchar](20) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[xCategories]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xCategories](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Categories] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[xProducts]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xProducts](
	[ProductId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CategoryId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Products] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  View [dbo].[vw_junrs_for_menu_count_books]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: BOOKS-DB-SCRIPT-DB.sql|262|0|Z:\_MY_LIFE========----====\_RABOTA_\_TESTOVYE_ZADANIA_\Voltmart---========\BOOKS-DB-SCRIPT-DB.sql
CREATE VIEW [dbo].[vw_junrs_for_menu_count_books]
AS
SELECT        COUNT(id_junr) AS count, id_junr
FROM            dbo.tb_books AS b
GROUP BY id_junr


GO
/****** Object:  View [dbo].[vw_junrs_for_menu_count_books_2]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: BOOKS-DB-SCRIPT-DB.sql|274|0|Z:\_MY_LIFE========----====\_RABOTA_\_TESTOVYE_ZADANIA_\Voltmart---========\BOOKS-DB-SCRIPT-DB.sql
CREATE VIEW [dbo].[vw_junrs_for_menu_count_books_2]
AS
SELECT        tb_j.nazvanie AS Expr1, vw_j.count
FROM            dbo.tb_junrs AS tb_j INNER JOIN
                         dbo.vw_junrs_for_menu_count_books AS vw_j ON tb_j.id = vw_j.id_junr


GO
/****** Object:  View [dbo].[vw_junrs_for_menu_count_books_3]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: BOOKS-DB-SCRIPT-DB.sql|286|0|Z:\_MY_LIFE========----====\_RABOTA_\_TESTOVYE_ZADANIA_\Voltmart---========\BOOKS-DB-SCRIPT-DB.sql
CREATE VIEW [dbo].[vw_junrs_for_menu_count_books_3]
AS
SELECT        vw_j.id_junr AS id_value, tb_j.nazvanie + '--(' + CAST(vw_j.count AS nvarchar(5)) + ')' AS nazvanie
FROM            dbo.tb_junrs AS tb_j INNER JOIN
                         dbo.vw_junrs_for_menu_count_books AS vw_j ON tb_j.id = vw_j.id_junr


GO
/****** Object:  View [dbo].[vw_books]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: BOOKS-DB-SCRIPT-DB.sql|316|0|Z:\_MY_LIFE========----====\_RABOTA_\_TESTOVYE_ZADANIA_\Voltmart---========\BOOKS-DB-SCRIPT-DB.sql
CREATE VIEW [dbo].[vw_books]
AS
SELECT        dbo.tb_books.id_uniq, dbo.tb_books.nazvanie, dbo.tb_books.autor, dbo.tb_books.year_print, dbo.tb_junrs.Nazvanie AS junr
FROM            dbo.tb_books INNER JOIN
                         dbo.tb_junrs ON dbo.tb_books.id_junr = dbo.tb_junrs.id


GO
/****** Object:  View [dbo].[vw_books2]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: BOOKS-DB-SCRIPT-DB.sql|328|0|Z:\_MY_LIFE========----====\_RABOTA_\_TESTOVYE_ZADANIA_\Voltmart---========\BOOKS-DB-SCRIPT-DB.sql
CREATE VIEW [dbo].[vw_books2]
AS
SELECT        dbo.tb_books.id_uniq, dbo.tb_books.nazvanie, dbo.tb_books.autor, dbo.tb_books.year_print, dbo.tb_junrs.nazvanie AS junr, dbo.tb_books.id_junr
FROM            dbo.tb_books INNER JOIN
                         dbo.tb_junrs ON dbo.tb_books.id_junr = dbo.tb_junrs.id


GO
/****** Object:  View [dbo].[vw_books4]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_books4]
AS
SELECT
 ROW_NUMBER() OVER (ORDER BY id_uniq) AS nn,
  dbo.tb_books.nazvanie,
  dbo.tb_books.autor,
  dbo.tb_books.year_print AS PublicYear,
  dbo.tb_junrs.nazvanie AS name_junr,
  dbo.tb_junrs.id AS id_junr

FROM   dbo.tb_books INNER JOIN
             dbo.tb_junrs ON dbo.tb_books.id_junr = dbo.tb_junrs.id

GO
/****** Object:  View [dbo].[vw_books6]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_books6]
AS
SELECT ROW_NUMBER() OVER (ORDER BY id_uniq) AS nn, dbo.tb_books.nazvanie, dbo.tb_books.autor, dbo.tb_books.year_print AS PublicYear, dbo.tb_junrs2.nazvanie AS name_junr, dbo.tb_junrs2.id AS id_junr, dbo.tb_books.id_uniq AS id_book
FROM   dbo.tb_books INNER JOIN
             dbo.tb_junrs2 ON dbo.tb_books.id_junr = dbo.tb_junrs2.id

GO
/****** Object:  View [dbo].[vw_junrs_for_menu]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: DROP-VIEW-dbo-vw_junrs_for_menu.sql|21|0|C:\Users\j\Documents\SQL Server Management Studio\DROP-VIEW-dbo-vw_junrs_for_menu.sql

-- Batch submitted through debugger: BOOKS-DB-SCRIPT-DB.sql|340|0|Z:\_MY_LIFE========----====\_RABOTA_\_TESTOVYE_ZADANIA_\Voltmart---========\BOOKS-DB-SCRIPT-DB.sql
CREATE VIEW [dbo].[vw_junrs_for_menu]
AS
SELECT ISNULL(id, -1) AS id_value, nazvanie
--SELECT id AS id_value, nazvanie, ROW_NUMBER() OVER(ORDER BY id ASC) AS pri_key#
FROM   dbo.tb_junrs



GO
/****** Object:  View [dbo].[vw_junrs_for_menu2]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_junrs_for_menu2]
AS
SELECT id AS id_value, nazvanie
FROM   dbo.tb_junrs2

GO
/****** Object:  Index [IX_CategoryId]    Script Date: 11/15/2022 2:04:45 AM ******/
CREATE NONCLUSTERED INDEX [IX_CategoryId] ON [dbo].[xProducts]
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_books] ADD  CONSTRAINT [DF_tb_books_id_uniq]  DEFAULT (newid()) FOR [id_uniq]
GO
ALTER TABLE [dbo].[tb_books] ADD  CONSTRAINT [DF_tb_books_name]  DEFAULT ('--') FOR [nazvanie]
GO
ALTER TABLE [dbo].[tb_books] ADD  CONSTRAINT [DF_tb_books_autor]  DEFAULT ('--') FOR [autor]
GO
ALTER TABLE [dbo].[tb_books] ADD  CONSTRAINT [DF_tb_books_year_print]  DEFAULT ((0)) FOR [year_print]
GO
ALTER TABLE [dbo].[tb_books] ADD  CONSTRAINT [DF_tb_books_id_junr]  DEFAULT ((0)) FOR [id_junr]
GO
ALTER TABLE [dbo].[tbBooks] ADD  CONSTRAINT [DF_tbBooks_name]  DEFAULT ('--') FOR [nazvanie]
GO
ALTER TABLE [dbo].[tbBooks] ADD  CONSTRAINT [DF_tbBooks_autor]  DEFAULT ('--') FOR [autor]
GO
ALTER TABLE [dbo].[tbBooks] ADD  CONSTRAINT [DF_tbBooks_year_print]  DEFAULT ((0)) FOR [year_print]
GO
ALTER TABLE [dbo].[tbBooks] ADD  CONSTRAINT [DF_tbBooks_id_junr]  DEFAULT ((0)) FOR [id_junr]
GO
ALTER TABLE [dbo].[tb_books]  WITH CHECK ADD FOREIGN KEY([id_junr])
REFERENCES [dbo].[tb_junrs2] ([id])
GO
ALTER TABLE [dbo].[tb_books]  WITH CHECK ADD  CONSTRAINT [FK_PersonOrder] FOREIGN KEY([id_junr])
REFERENCES [dbo].[tb_junrs2] ([id])
GO
ALTER TABLE [dbo].[tb_books] CHECK CONSTRAINT [FK_PersonOrder]
GO
ALTER TABLE [dbo].[xProducts]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Products_dbo.Categories_CategoryId] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[xCategories] ([CategoryId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[xProducts] CHECK CONSTRAINT [FK_dbo.Products_dbo.Categories_CategoryId]
GO
/****** Object:  StoredProcedure [dbo].[sp_book_delete]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_book_delete] @str_id_uniq varchar(MAX)
AS BEGIN
	--
	-- Begin	----------------------------------------------------------------
	--
	SET NOCOUNT ON;

	DECLARE  @error int = (-100);
	DECLARE	 @uniq_var  as uniqueidentifier;
	--
	-- CAST --- @str_id_uniq  from string to unique --- 2022-06-24 -------------
	--
	BEGIN TRY
		SET @uniq_var = CAST(LTRIM(RTRIM(@str_id_uniq)) AS UNIQUEIDENTIFIER);
	END TRY
	BEGIN CATCH
		SET @error= (-1); 			--PRINT '----' + CONVERT(char(4), @@ERROR);
		GOTO MARKER_EXIT 			--RETURN (-1)  -- '======' + CONVERT(char(8), @@ERROR)
	END CATCH
	--
	-- DELETE  -----------------------------------------------------------------
	--
	BEGIN TRY
	    BEGIN TRANSACTION;  
		    DELETE FROM tb_books WHERE (id_uniq LIKE @uniq_var);
		COMMIT TRANSACTION; 
	END TRY
	BEGIN CATCH
	    IF @@TRANCOUNT > 0  ROLLBACK TRANSACTION;
	    SET @error= (-2);
	    GOTO MARKER_EXIT
	END CATCH

	SET @error = @@ERROR;
 	--
	-- Finish	---------------------------------------------------------------
	--
	MARKER_EXIT:
	SELECT @error AS Out_result_error,
	       CAST(@@ERROR AS varchar(MAX)) AS Out_ERROR;

END

GO
/****** Object:  StoredProcedure [dbo].[sp_book_insert]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: SQLQuery13.sql|7|0|D:\TEMP\~vs97F0.sql
-- Batch submitted through debugger: SQLQuery7.sql|7|0|D:\TEMP\~vs8F36.sql
-- Batch submitted through debugger: BOOKS-DB-SCRIPT-DB.sql|361|0|Z:\_MY_LIFE========----====\_RABOTA_\_TESTOVYE_ZADANIA_\Voltmart---========\BOOKS-DB-SCRIPT-DB.sql
--
-- ============================================================================
--
CREATE PROCEDURE [dbo].[sp_book_insert]
			 @str_nazvanie   nvarchar(MAX)
			,@str_autor      nvarchar(MAX)
			,@str_year_print  varchar(MAX)
			,@str_id_junr     varchar(MAX)
AS  BEGIN
	--
	-- Begin	---------------------------------------------------------------
	--
	SET NOCOUNT ON;

	DECLARE  @error int = (-100)
	    	,@str_for_poisk  as nvarchar(MAX)
			,@int_year_print as smallint =IIF((ISNUMERIC(@str_year_print)= 1), CAST(@str_year_print as smallint), -32000)
			,@int_id_junr    as smallint =IIF((ISNUMERIC(@str_id_junr)= 1),    CAST(@str_id_junr as smallint), -50);
	--
	-- PROVERKA? @str_year_print	--------------------------------------------
	--
	IF (@int_year_print < -32000) -- 2022-06-24
		BEGIN
			SET @error= (-1); 			--PRINT '----' + CONVERT(char(4), @@ERROR);
			GOTO MARKER_EXIT 			--RETURN (-1)  -- '======' + CONVERT(char(8), @@ERROR)
		END
	--
	-- SET	--------------------------------------------------------------------
	--
	SET	 @str_nazvanie = LTRIM(RTRIM(@str_nazvanie));
	SET  @str_autor    = LTRIM(RTRIM(@str_autor));
	--
	-- PROVERKA? @int_id_junr	-----------------------------------------------
	--
	IF [dbo].fn_Is_Junr(@int_id_junr) = 'no'
		BEGIN
		    SET @error= (-2);
			GOTO MARKER_EXIT
		END;
    --
	-- PROVERKA? Mojet eta kniga uje est_	-----------------------------------
	--
	IF [dbo].fn_Is_Clone_Book(@str_nazvanie, @str_autor, @str_year_print, @str_id_junr) = 'yes'
		BEGIN
			SET @error= (-3);
			GOTO MARKER_EXIT
		END
	--
	-- Adding	---------------------------------------------------------------
	--
	INSERT INTO tb_books (nazvanie, autor, year_print, id_junr)
	VALUES (@str_nazvanie ,@str_autor ,@int_year_print, @int_id_junr);
    --
	-- PROVERKA? Insert -------------------------------------------------------
	--
	IF (@@ERROR != 0)
		BEGIN
			SET @error= (-4); --2022-06-24 SET @error = (0 - @@ERROR);
			GOTO MARKER_EXIT
		END

	SET @error= 0;
 	--
	-- Finish	---------------------------------------------------------------
	--
	MARKER_EXIT:
	SELECT @error AS Out_result_error,
	      -- CAST(@@ERROR AS varchar(MAX)) AS Out_ERROR;
		     LTRIM(@str_nazvanie) AS In_param_nazvanie,  -- 2022-06-28 !!
		     LTRIM(@str_autor)    AS In_param_autor,
	         LTRIM(@str_year_print) AS In_param_year_print,
		     LTRIM(@str_id_junr)  AS In_param_id_junr;
END


GO
/****** Object:  StoredProcedure [dbo].[sp_book_insert2]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: SQLQuery13.sql|7|0|D:\TEMP\~vs97F0.sql
-- Batch submitted through debugger: SQLQuery7.sql|7|0|D:\TEMP\~vs8F36.sql
-- Batch submitted through debugger: BOOKS-DB-SCRIPT-DB.sql|361|0|Z:\_MY_LIFE========----====\_RABOTA_\_TESTOVYE_ZADANIA_\Voltmart---========\BOOKS-DB-SCRIPT-DB.sql
--
-- ============================================================================
--
CREATE PROCEDURE [dbo].[sp_book_insert2]
			 @str_nazvanie   nvarchar(MAX)
			,@str_autor      nvarchar(MAX)
			,@str_year_print  varchar(MAX)
			,@str_id_junr     varchar(MAX)

AS  BEGIN
	--
	-- Begin	---------------------------------------------------------------
	--
	SET NOCOUNT ON;

	DECLARE @id_uniq uniqueidentifier = CAST(0x0 AS uniqueidentifier);
	DECLARE @error int = (-100);
	DECLARE @str_for_poisk  as nvarchar(MAX);
	DECLARE @int_year_print as smallint =IIF((ISNUMERIC(@str_year_print)= 1), CAST(@str_year_print as smallint), -32000);
	DECLARE @int_id_junr    as smallint =IIF((ISNUMERIC(@str_id_junr)= 1),    CAST(@str_id_junr as smallint), -50);
	--
	-- PROVERKA? @str_year_print	--------------------------------------------
	--
	IF (@int_year_print < -32000) -- 2022-06-24
		BEGIN
			SET @error= (-1); 			--PRINT '----' + CONVERT(char(4), @@ERROR);
			GOTO MARKER_EXIT 			--RETURN (-1)  -- '======' + CONVERT(char(8), @@ERROR)
		END
	--
	-- SET	--------------------------------------------------------------------
	--
	SET	 @str_nazvanie = LTRIM(RTRIM(@str_nazvanie));
	SET  @str_autor    = LTRIM(RTRIM(@str_autor));
	--
	-- PROVERKA? @int_id_junr	-----------------------------------------------
	--
	IF [dbo].fn_Is_Junr(@int_id_junr) = 'no'
		BEGIN
		    SET @error= (-2);
			GOTO MARKER_EXIT
		END;
    --
	-- PROVERKA? Mojet eta kniga uje est_	-----------------------------------
	--
	IF [dbo].fn_Is_Clone_Book(@str_nazvanie, @str_autor, @str_year_print, @str_id_junr) = 'yes'
		BEGIN
			SET @error= (-3);
			GOTO MARKER_EXIT
		END
	--
	-- Adding	---------------------------------------------------------------
	--
	INSERT INTO tb_books (nazvanie, autor, year_print, id_junr)
	VALUES (@str_nazvanie ,@str_autor ,@int_year_print, @int_id_junr);
    --
	-- PROVERKA? Insert -------------------------------------------------------
	--
	IF (@@ERROR != 0)
		BEGIN
			SET @error= (-4); --2022-06-24 SET @error = (0 - @@ERROR);
			GOTO MARKER_EXIT
		END

	SET @error= 0;
 	--
	-- Finish	---------------------------------------------------------------
	--
	SET @id_uniq =
	[dbo].fn_Get_GUID_The_Book(@str_nazvanie, @str_autor, @str_year_print, @str_id_junr);

	MARKER_EXIT:
	SELECT         @error AS Out_result_error,
	               @id_uniq AS id_uniq,
	      -- CAST(@@ERROR AS varchar(MAX)) AS Out_ERROR;
		     LTRIM(@str_nazvanie) AS In_param_nazvanie,  -- 2022-06-28 !!
		     LTRIM(@str_autor)    AS In_param_autor,
	         LTRIM(@str_year_print) AS In_param_year_print,
		     LTRIM(@str_id_junr)  AS In_param_id_junr;
END


GO
/****** Object:  StoredProcedure [dbo].[sp_book_update]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: BOOKS-DB-SCRIPT-DB.sql|421|0|Z:\_MY_LIFE========----====\_RABOTA_\_TESTOVYE_ZADANIA_\Voltmart---========\BOOKS-DB-SCRIPT-DB.sql
--
-- ============================================================================
--
CREATE PROCEDURE [dbo].[sp_book_update] 
			 @str_id_uniq     varchar(MAX) = '--'
			 --@str_uniqID      varchar(MAX) = '--'
			,@str_nazvanie   nvarchar(MAX) = '--'
			,@str_autor      nvarchar(MAX) = '--'
			,@str_year_print  varchar(MAX)
			,@str_id_junr     varchar(MAX)
AS BEGIN
	--
	-- Begin	---------------------------------------------------------------
	--
	SET NOCOUNT ON;
	-- TRY --- CATCH ---
	DECLARE  @error       as int = (-100);
	DECLARE	 @uniq_uniqID as uniqueidentifier =CAST(@str_id_uniq as uniqueidentifier);
	DECLARE	 @int_year_print as smallint =IIF((ISNUMERIC(@str_year_print)= 1), CAST(@str_year_print as smallint), -32000)
	DECLARE  @int_id_junr as smallint    =IIF((ISNUMERIC(@str_id_junr)= 1), CAST(@str_id_junr as smallint), -50);
	--
	-- PROVERKA? @str_year_print	--------------------------------------------
	--
	IF (@int_year_print < -32000) -- 2022-06-24
		BEGIN
			SET @error= (-1); 			--PRINT '----' + CONVERT(char(4), @@ERROR);
			GOTO MARKER_EXIT 			--RETURN (-1)  -- '======' + CONVERT(char(8), @@ERROR)
		END
	--
	-- SET	--------------------------------------------------------------------
	--
	SET	 @str_nazvanie = LTRIM(RTRIM(@str_nazvanie));
	SET  @str_autor    = LTRIM(RTRIM(@str_autor));
	--
	-- PROVERKA? @int_id_junr	-----------------------------------------------
	--
	IF [dbo].fn_Is_Junr(@int_id_junr) = 'no'
		BEGIN
		    SET @error= (-2);
			GOTO MARKER_EXIT
		END;
    --
	-- PROVERKA? Mojet eta kniga uje est_	-----------------------------------
	--
	IF [dbo].fn_Is_Clone_Book(@str_nazvanie, @str_autor, @str_year_print, @str_id_junr) = 'yes'
		BEGIN
			SET @error= (-3);
			GOTO MARKER_EXIT
		END
	--
	-- Updating	---------------------------------------------------------------
	--
	UPDATE [dbo].[tb_books]
	   SET [nazvanie] = RTRIM(LTRIM(@str_nazvanie))
		  ,[autor]    = RTRIM(LTRIM(@str_autor))
		  ,[year_print]=@int_year_print
		  ,[id_junr]  = @int_id_junr
	 WHERE [id_uniq]  = @uniq_uniqID;
    --
	-- PROVERKA? Update -------------------------------------------------------
	--
	IF (@@ERROR != 0)
		BEGIN
			SET @error= (-4); --2022-06-24 SET @error = (0 - @@ERROR);
			GOTO MARKER_EXIT
		END

	SET @error = @@ERROR;
 	--
	-- Finish	---------------------------------------------------------------
	--
	MARKER_EXIT:
	SELECT @error AS Out_result_error,
	       CAST(@@ERROR AS varchar(MAX)) AS Out_ERROR;
END

GO
/****** Object:  StoredProcedure [dbo].[SPContacto]    Script Date: 11/15/2022 2:04:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: SQLQuery3.sql|0|0|D:\TEMP\~vsF70F.sql
CREATE PROCEDURE [dbo].[SPContacto]
  @opc int = 1,
  @Id int = 0,
  @Nombre varchar(50) = " ",
  @Telefono varchar(20) = " "
AS

IF @opc = 1
BEGIN
  SELECT * FROM TblContacto
END


IF @opc = 2
BEGIN
  INSERT INTO TblContacto (Id, Nombre, Telefono)
         VALUES (@Id, @Nombre, @Telefono)
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[44] 4[27] 2[14] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tb_books"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 275
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tb_junrs"
            Begin Extent = 
               Top = 13
               Left = 444
               Bottom = 109
               Right = 614
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_books'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_books'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[11] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tb_books"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 247
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tb_junrs"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 194
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 2040
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_books2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_books2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[12] 4[24] 2[16] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 480
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_books4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_books4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 460
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_books6'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_books6'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[31] 4[20] 2[21] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tb_junrs"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 102
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 2070
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_junrs_for_menu'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_junrs_for_menu'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "b"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_junrs_for_menu_count_books'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_junrs_for_menu_count_books'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[32] 4[16] 2[18] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tb_j"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 139
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vw_j"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 102
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_junrs_for_menu_count_books_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_junrs_for_menu_count_books_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tb_j"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 102
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vw_j"
            Begin Extent = 
               Top = 6
               Left = 282
               Bottom = 102
               Right = 452
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 945
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_junrs_for_menu_count_books_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_junrs_for_menu_count_books_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[10] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tb_junrs2"
            Begin Extent = 
               Top = 9
               Left = 57
               Bottom = 152
               Right = 279
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_junrs_for_menu2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_junrs_for_menu2'
GO
USE [master]
GO
ALTER DATABASE [BOOKS] SET  READ_WRITE 
GO
