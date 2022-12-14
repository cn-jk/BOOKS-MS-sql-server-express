USE [master]
GO
/****** Object:  Database [BOOKS]    Script Date: 6/3/2022 1:09:34 AM ******/
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
/****** Object:  User [books_user]    Script Date: 6/3/2022 1:09:34 AM ******/
CREATE USER [books_user] FOR LOGIN [books_login] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [books_user]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Result_Multiply_Percent]    Script Date: 6/3/2022 1:09:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  Table [dbo].[Balance]    Script Date: 6/3/2022 1:09:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Balance](
	[ID] [smallint] NULL,
	[DateReport] [nchar](8) NULL,
	[Dogovor] [nchar](1) NULL,
	[Dolg] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Statistica]    Script Date: 6/3/2022 1:09:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Statistica](
	[ID] [smallint] NULL,
	[DateReport] [nchar](8) NULL,
	[Days] [tinyint] NULL,
	[Stavka] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Table_1]    Script Date: 6/3/2022 1:09:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Table_1](
	[col1] [nchar](10) NULL,
	[col_bit] [bit] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Table_Derevo]    Script Date: 6/3/2022 1:09:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Table_Derevo](
	[papa] [smallint] NULL,
	[deti] [smallint] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Table_PC]    Script Date: 6/3/2022 1:09:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Table_PC](
	[id] [smallint] NULL,
	[cpu] [int] NULL,
	[memory] [int] NULL,
	[hdd] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tb_books]    Script Date: 6/3/2022 1:09:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tb_books](
	[id_uniq] [uniqueidentifier] NOT NULL,
	[nazvanie] [nvarchar](max) NOT NULL,
	[autor] [nvarchar](max) NOT NULL,
	[year_print] [smallint] NOT NULL,
	[id_junr] [smallint] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tb_junrs]    Script Date: 6/3/2022 1:09:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tb_junrs](
	[id] [smallint] NULL,
	[nazvanie] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tb_result]    Script Date: 6/3/2022 1:09:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tb_result](
	[levelTree] [smallint] NULL,
	[deti] [smallint] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[user]    Script Date: 6/3/2022 1:09:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user](
	[id] [smallint] NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[Age] [tinyint] NULL,
	[Hometown] [nvarchar](50) NULL,
	[Job] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[vw_junrs_for_menu_count_books]    Script Date: 6/3/2022 1:09:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_junrs_for_menu_count_books]
AS
SELECT        COUNT(id_junr) AS count, id_junr
FROM            dbo.tb_books AS b
GROUP BY id_junr

GO
/****** Object:  View [dbo].[vw_junrs_for_menu_count_books_2]    Script Date: 6/3/2022 1:09:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_junrs_for_menu_count_books_2]
AS
SELECT        tb_j.nazvanie AS Expr1, vw_j.count
FROM            dbo.tb_junrs AS tb_j INNER JOIN
                         dbo.vw_junrs_for_menu_count_books AS vw_j ON tb_j.id = vw_j.id_junr

GO
/****** Object:  View [dbo].[vw_junrs_for_menu_count_books_3]    Script Date: 6/3/2022 1:09:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_junrs_for_menu_count_books_3]
AS
SELECT        vw_j.id_junr AS id_value, tb_j.nazvanie + '--(' + CAST(vw_j.count AS nvarchar(5)) + ')' AS nazvanie
FROM            dbo.tb_junrs AS tb_j INNER JOIN
                         dbo.vw_junrs_for_menu_count_books AS vw_j ON tb_j.id = vw_j.id_junr

GO
/****** Object:  View [dbo].[vw_Balance_Dolg_split_sum]    Script Date: 6/3/2022 1:09:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Balance_Dolg_split_sum]
AS
SELECT [B].[ID],[B].[DateReport],[B].[Dogovor]
      ,(SELECT SUM( CAST(LTRIM(RTRIM(Split.a.value('.', 'nvarchar(MAX)'))) AS int)) 'SUM_Value'
		FROM
		(
		SELECT
		CAST('<M>' + REPLACE([B].[Dolg], '-', '</M><M>') + '</M>' AS XML) AS Data
		) AS A
		CROSS APPLY Data.nodes ('/M') AS Split(a)) as Dolg_split_sum
FROM [BOOKS].[dbo].[Balance] B

GO
/****** Object:  View [dbo].[vw_books]    Script Date: 6/3/2022 1:09:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_books]
AS
SELECT        dbo.tb_books.id_uniq, dbo.tb_books.nazvanie, dbo.tb_books.autor, dbo.tb_books.year_print, dbo.tb_junrs.Nazvanie AS junr
FROM            dbo.tb_books INNER JOIN
                         dbo.tb_junrs ON dbo.tb_books.id_junr = dbo.tb_junrs.id

GO
/****** Object:  View [dbo].[vw_books_2]    Script Date: 6/3/2022 1:09:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_books_2]
AS
SELECT        dbo.tb_books.id_uniq, dbo.tb_books.nazvanie, dbo.tb_books.autor, dbo.tb_books.year_print, dbo.tb_junrs.nazvanie AS junr, dbo.tb_books.id_junr
FROM            dbo.tb_books INNER JOIN
                         dbo.tb_junrs ON dbo.tb_books.id_junr = dbo.tb_junrs.id

GO
/****** Object:  View [dbo].[vw_junrs_for_menu]    Script Date: 6/3/2022 1:09:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_junrs_for_menu]
AS
SELECT        id AS id_value, nazvanie
FROM            dbo.tb_junrs

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
/****** Object:  StoredProcedure [dbo].[sp_book_insert]    Script Date: 6/3/2022 1:09:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
-- ============================================================================
--
CREATE PROCEDURE [dbo].[sp_book_insert]

			 @str_uniqID     nvarchar(MAX)
			,@str_nazvanie   nvarchar(MAX)
			,@str_autor      nvarchar(MAX)
			,@str_year_print nvarchar(MAX)
			,@str_id_junr    nvarchar(MAX)

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE	 @str_for_poisk  as nvarchar(MAX)
			,@int_year_print as smallint
			=IIF( (ISNUMERIC(@str_year_print)= 1), CAST(@str_year_print as smallint), -100000)
			,@int_id_junr    as smallint
			=IIF( (ISNUMERIC(@str_id_junr)= 1),    CAST(@str_id_junr as smallint), -100000);

	SET @str_for_poisk =
	LTRIM(@str_nazvanie)+'|'+LTRIM(@str_autor)+'|'+LTRIM(CAST(@str_year_print as char(4)))+'|'+LTRIM(@str_id_junr);
	--
	-- PROVERKA? @int_id_junr	-----------------------------------------------
	--
	IF NOT EXISTS ( SELECT j.id  FROM [BOOKS].[dbo].[tb_junrs] as j WHERE j.id LIKE @int_id_junr )
		BEGIN
			RETURN
		END;
    --
	-- PROVERKA? Mojet eta kniga uje est_	-----------------------------------
	--
	IF EXISTS
		(
		SELECT id_uniq FROM tb_BOOKSb
		 WHERE @str_for_poisk LIKE
		 (LTRIM(b.nazvanie)+'|'+LTRIM(b.autor)+'|'+LTRIM(CAST(b.year_print as char(4)))+'|'+LTRIM(CAST(b.id_junr as nvarchar(4)) )
		 )
		)
		BEGIN
			RETURN
		END;
	--
	-- Adding	---------------------------------------------------------------
	--
	INSERT INTO tb_books
	VALUES (NEWID(), @str_nazvanie ,@str_autor ,@int_year_print, @int_id_junr);
 
	RETURN
END

GO
/****** Object:  StoredProcedure [dbo].[sp_book_update]    Script Date: 6/3/2022 1:09:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
-- ============================================================================
--
CREATE PROCEDURE [dbo].[sp_book_update]
 
			 @str_uniqID     nvarchar(MAX) = '--'
			,@str_nazvanie   nvarchar(MAX) = '--'
			,@str_autor      nvarchar(MAX) = '--'
			,@str_year_print nvarchar(MAX)
			,@str_junr       nvarchar(MAX)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE	 @int_year_print smallint
	=IIF( (ISNUMERIC(@str_year_print)= 1), CAST(@str_year_print as smallint), -100000)

			,@uniq_uniqID uniqueidentifier =CAST(@str_uniqID as uniqueidentifier);

	UPDATE [dbo].[tb_books]
	   SET [nazvanie] = RTRIM(LTRIM(@str_nazvanie))
		  ,[autor]    = RTRIM(LTRIM(@str_autor))
		  ,[year_print]=@int_year_print
		  ,[id_junr]  = RTRIM(LTRIM(@str_junr))
	 WHERE [id_uniq]  = @uniq_uniqID
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Vyborka_detey]    Script Date: 6/3/2022 1:09:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[sp_Vyborka_detey]	
			 @Parameter_id_papa	smallint
			,@out_str_deti nvarchar(MAX) OUT

AS
BEGIN
		DECLARE
			@select_1 as nvarchar(MAX) =
			 N'  SELECT [d1].[papa] ,[d1].[deti]
				   FROM [BOOKS].[dbo].[Table_Derevo] d1
				  WHERE [d1].[papa] = @id_papa_Top'

			,@insert_3 as nvarchar(MAX) =
			 N'INSERT INTO [BOOKS].[dbo].[tb_result]
			   SELECT @level, [d1].[deti]
				   FROM [BOOKS].[dbo].[Table_Derevo] d1
			 inner join [BOOKS].[dbo].[tb_result]    d2
					 on [d1].[papa] = [d2].[deti]
					AND [d2].[levelTree] = @level-1'

			,@ParmDefinition as nvarchar(MAX) = N'@id_papa_Top smallint'

			,@RowCount  as int = 0
			,@levelTree as smallint = 0;

		SET @out_str_deti = '** (-1) U nas net takogo papy ! **';

		--
		-- CLEANING ------------------------------
		--
		DELETE FROM [BOOKS].[dbo].[tb_result];
		--
		-- PROVERKA: U nas est' takoy papa ?------
		--
		EXECUTE sp_executesql @select_1
								, @ParmDefinition
								, @id_papa_Top=@Parameter_id_papa;

		SET @RowCount = @@ROWCOUNT;

		IF (@RowCount > 0)
			BEGIN

			SET @levelTree += 1;
			INSERT INTO [BOOKS].[dbo].[tb_result]
				 VALUES (@levelTree, @Parameter_id_papa);

			SET @RowCount = @@ROWCOUNT;
			END
		ELSE
			RETURN;
		--
		-- Smenim nabor parammetrov dlia "EXECUTE sp_executesql @insert_3 .."
		--
		SET @ParmDefinition = N'@level smallint, @id_papa_Top smallint';
		--
		-- Nachalo cycla 
		--
		LABEL_do_while:
			SET @levelTree += 1;
			EXECUTE sp_executesql @insert_3
									, @ParmDefinition
									, @level=@levelTree
									, @id_papa_Top=@Parameter_id_Papa;

			SET @RowCount = @@ROWCOUNT;
		--
		-- Uslovia vyhoda iz cykla
		--
		IF (@RowCount > 0) GOTO LABEL_do_while;

SET @out_str_deti= '** (0) Smotri tablicu tb_result ! **'
RETURN
END

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[19] 4[12] 2[29] 3) )"
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
         Begin Table = "Balance"
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Balance_Dolg_split_sum'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Balance_Dolg_split_sum'
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_books_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_books_2'
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
USE [master]
GO
ALTER DATABASE [BOOKS] SET  READ_WRITE 
GO
