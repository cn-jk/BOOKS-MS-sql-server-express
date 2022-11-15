USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [books_login]    Script Date: 6/3/2022 1:40:43 AM ******/
CREATE LOGIN [books_login] WITH PASSWORD=N'1', DEFAULT_DATABASE=[BOOKS], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [books_login] DISABLE
GO

