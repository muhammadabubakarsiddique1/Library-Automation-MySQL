-- Show all tables
SHOW TABLES;

-- Display Departments data
SELECT * FROM Departments;

-- Display Programs data
SELECT * FROM Programs;

-- Display Students data
SELECT * FROM Students;

-- Display Faculty data
SELECT * FROM Faculty;

-- Display Categories data
SELECT * FROM Categories;

-- Display Books data
SELECT * FROM Books;

-- Display Book Stock
SELECT * FROM BookStock;

-- Display Issue Records
SELECT * FROM IssueRecords;

-- Display Fines Record
SELECT * FROM FinesRecord;

-- Display Payments
SELECT * FROM Payments;

-- Display NOC Records
SELECT * FROM NOC_Records;

-- Show all roles
SHOW GRANTS;

-- View available book balances
SELECT * FROM View_BalanceOfBooks;

-- View pending fines
SELECT * FROM View_PendingFines;

-- Test Trigger (Return a book)
UPDATE IssueRecords 
SET ReturnDate = '2025-10-15'
WHERE IssueID = 1;

-- Check IssueRecords after return
SELECT * FROM IssueRecords;

-- Check FinesRecord after update
SELECT * FROM FinesRecord;

-- Show Triggers
SHOW TRIGGERS;

-- Show Users List
SELECT user, host FROM mysql.user;

-- Check Privileges of a role/user
SHOW GRANTS FOR 'sharjeel'@'localhost';
SHOW GRANTS FOR 'zarmeen'@'localhost';
SHOW GRANTS FOR 'abubakar'@'localhost';
