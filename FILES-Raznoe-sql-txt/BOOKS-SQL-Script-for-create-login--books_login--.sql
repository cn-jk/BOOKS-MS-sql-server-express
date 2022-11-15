USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [books_login]    Script Date: 6/3/2022 9:14:35 AM ******/
CREATE LOGIN [books_login]
  WITH PASSWORD=N'1',
	   DEFAULT_LANGUAGE=[us_english],
	   CHECK_EXPIRATION=OFF,
	   CHECK_POLICY=OFF
GO

ALTER LOGIN [books_login] DISABLE
GO

DENY CONNECT SQL TO [books_login]
GO

