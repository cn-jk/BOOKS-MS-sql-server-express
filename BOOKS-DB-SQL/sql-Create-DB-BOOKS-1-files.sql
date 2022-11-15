USE [master]
GO

/****** Object:  Database [BOOKS]    Script Date: 11/15/2022 2:10:50 AM ******/
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

ALTER DATABASE [BOOKS] SET  READ_WRITE 
GO


