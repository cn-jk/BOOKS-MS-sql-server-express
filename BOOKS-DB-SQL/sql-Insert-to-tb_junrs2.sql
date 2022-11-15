USE [BOOKS]
GO

INSERT INTO [dbo].[tb_junrs2] ([id], [nazvanie])
     VALUES
            (20, 'другое')
           ,(30, 'мелодрама')
           ,(40, 'фантастика')
           ,(50, 'приключения')
           ,(60, 'детектив')
GO
SELECT TOP 1000 [id] ,[nazvanie] FROM [BOOKS].[dbo].[tb_junrs2]