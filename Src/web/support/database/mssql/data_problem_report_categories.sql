USE [$(database_name)]
GO
SET IDENTITY_INSERT [dbo].[ProblemReportCategories] ON 

INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (1, 3, N'C Compilation', N'Problems related to the compilation of C code generated by the Eiffel compiler.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (2, 3, N'CECIL', N'Problems related to the use of the CECIL technology.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (3, 3, N'Compiler', N'Problems related to the Eiffel compiler (independently from the IDE).', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (4, 4, N'Documentation', N'Problems related to documentation, deprecated (use PR Class instead).', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (5, 3, N'.NET', N'Problems related to the use of the .NET Framework other than compiler problems.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (6, 1, N'EiffelBase', N'Problems related to the use of EiffelBase.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (7, 2, N'EiffelBuild', N'Problems related to the compilation of C code generated by the Eiffel compiler.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (8, 3, N'EiffelCOM', N'Problems related to the use of EiffelCOM.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (9, 2, N'EiffelEnvision', N'Problems related to the use of EiffelEnvision.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (10, 1, N'EiffelLex', N'Problems related to the use of EiffelLex.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (11, 1, N'EiffelMath', N'Problems related to the use of EiffelMath.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (12, 1, N'EiffelNet', N'Problems related to the use of EiffelNet.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (13, 1, N'EiffelParse', N'Problems related to the use of EiffelParse.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (14, 1, N'EiffelStore', N'Problems related to the use of EiffelStore.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (15, 2, N'EiffelStudio', N'Problems related to the use of EiffelStudio other than compiler problems.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (16, 1, N'EiffelTest', N'Problems related to the use of EiffelTest.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (17, 1, N'EiffelThreads', N'Problems related to the use of EiffelThreads.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (18, 1, N'EiffelTime', N'Problems related to the use of EiffelTime.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (19, 1, N'EiffelVision 1', N'Problems related to the use of EiffelVision 1, deprecated (not supported anymore).', 0)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (20, 1, N'EiffelVision', N'Problems related to the use of EiffelVision.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (21, 1, N'EiffelWeb', N'Problems related to the use of EiffelWeb.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (22, 2, N'Legacy', N'Problems related to the use of Legacy++, deprecated (not supported anymore).', 0)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (23, 1, N'Mel', N'Problems related to the use of MEL, deprecated (not supported anymore).', 0)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (24, 4, N'Other', N'Problems that do not fit in any other category.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (25, 2, N'ResourceBench', N'Problems related to the use of ResourceBench.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (26, 3, N'Runtime', N'Problems related to the use of the Eiffel runtime.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (27, 3, N'VMS', N'Problems related to the use of the VMS platform.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (28, 1, N'WEL', N'Problems related to the use of EiffelWeb.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (29, 2, N'EiffelBench', N'Problems related to the use of EiffelBench, deprecated (not supported anymore).', 0)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (30, 2, N'EiffelCase', N'Problems related to the use of EiffelCase, deprecated (not supported anymore).', 0)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (31, 3, N'EiffelASP.NET', N'Problems related to the use of EiffelASP.NET.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (32, 4, N'Installation UNIX', N'Problems related to the installation on UNIX, deprecated (use PR Class instead).', 0)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (33, 4, N'Installation Windows', N'Problems related to the installation on Windows, deprecated (use PR Class instead).', 0)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (34, 2, N'EiffelCommerce', N'Problems related to the use of EiffelCommerce.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (35, 2, N'support.eiffel.com', N'Problems related to the use Eiffel Software''s support web site.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (36, 4, N'TEST', N'Admin test category', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (37, 1, N'Preferences', N'Problems related to the use of the preferences library.', 1)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (38, 4, N'Beta', N'Problems reported by internal beta testers.', 0)
INSERT [dbo].[ProblemReportCategories] ([CategoryID], [CategoryGroupID], [CategorySynopsis], [CategoryDescription], [IsActive]) VALUES (39, 2, N'Debugger', N'Problems related to the debugger (independently from the IDE)', 1)
SET IDENTITY_INSERT [dbo].[ProblemReportCategories] OFF
