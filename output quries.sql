-- List tables
SHOW TABLES;

-- Show structure summary counts
SELECT 'Departments' AS `Table`, COUNT(*) AS `Rows` FROM Departments
UNION ALL SELECT 'Programs', COUNT(*) FROM Programs
UNION ALL SELECT 'Roles', COUNT(*) FROM Roles
UNION ALL SELECT 'Users', COUNT(*) FROM Users
UNION ALL SELECT 'Students', COUNT(*) FROM Students
UNION ALL SELECT 'Faculty', COUNT(*) FROM Faculty
UNION ALL SELECT 'Items', COUNT(*) FROM Items
UNION ALL SELECT 'ItemCopies', COUNT(*) FROM ItemCopies
UNION ALL SELECT 'Memberships', COUNT(*) FROM Memberships
UNION ALL SELECT 'IssueRecords', COUNT(*) FROM IssueRecords
UNION ALL SELECT 'Penalties', COUNT(*) FROM Penalties;

-- Full selects (sample outputs)
SELECT * FROM Departments;
SELECT * FROM Programs;
SELECT * FROM Roles;
SELECT * FROM Users;
SELECT * FROM Students;
SELECT * FROM Faculty;
SELECT * FROM Categories;
SELECT * FROM ItemTypes;
SELECT * FROM Items;
SELECT * FROM ItemCopies;
SELECT * FROM ItemStockSummary;
SELECT * FROM Memberships;
SELECT * FROM IssueRecords;
SELECT * FROM Penalties;
SELECT * FROM AuditLogs;

-- Demo: Issue an item (CALL procedure)
-- We will issue CopyID = 1 (AI-0001) to StudentID = 1 by librarian (UserID = 2)
CALL IssueItem(1, 'Student', 1, 2, '2025-10-01', '2025-10-10');

-- Output after issue
SELECT 'After Issue: ItemCopies' AS note; SELECT * FROM ItemCopies WHERE CopyID=1;
SELECT 'After Issue: IssueRecords' AS note; SELECT * FROM IssueRecords WHERE CopyID=1;
SELECT 'After Issue: ItemStockSummary' AS note; SELECT * FROM ItemStockSummary WHERE ItemID = 1;
SELECT * FROM View_CurrentIssued;

-- Demo: Return the item late (CALL procedure)
-- Suppose returned on 2025-10-12 => 2 days late => fine = 2 * 10 = 20
CALL ReturnItem(1, '2025-10-12', 2);

-- Output after return
SELECT 'After Return: IssueRecords' AS note; SELECT * FROM IssueRecords WHERE IssueID=1;
SELECT 'After Return: ItemCopies' AS note; SELECT * FROM ItemCopies WHERE CopyID=1;
SELECT 'After Return: Penalties' AS note; SELECT * FROM Penalties WHERE IssueID=1;
SELECT * FROM View_Overdue;

-- Overdue items with borrower info (join to Students/Faculty)
SELECT
    V.IssueID, V.Title, V.IssuedToType, V.IssuedToID, V.DueDate, V.DaysLate, V.CurrentFine,
    CASE WHEN V.IssuedToType='Student' THEN S.StudentName WHEN V.IssuedToType='Faculty' THEN F.FacultyName ELSE 'External' END AS BorrowerName
FROM View_Overdue V
LEFT JOIN Students S ON V.IssuedToType='Student' AND V.IssuedToID = S.StudentID
LEFT JOIN Faculty F ON V.IssuedToType='Faculty' AND V.IssuedToID = F.FacultyID;

-- Top borrowed items (simple count)
SELECT It.Title, COUNT(*) AS TimesBorrowed
FROM IssueRecords IR
JOIN ItemCopies IC ON IR.CopyID = IC.CopyID
JOIN Items It ON IC.ItemID = It.ItemID
GROUP BY It.Title
ORDER BY TimesBorrowed DESC
LIMIT 10;