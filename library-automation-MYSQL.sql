DROP DATABASE IF EXISTS Libraryauto_DB;
CREATE DATABASE Libraryauto_DB;
USE Libraryauto_DB;

CREATE ROLE IF NOT EXISTS librarian;
CREATE ROLE IF NOT EXISTS student;
CREATE ROLE IF NOT EXISTS admin;

GRANT ALL PRIVILEGES ON Libraryauto_DB.* TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Libraryauto_DB.Books TO librarian;
GRANT SELECT, INSERT, UPDATE ON Libraryauto_DB.IssueRecords TO librarian;
GRANT SELECT ON Libraryauto_DB.Books TO student;

CREATE USER 'sharjeel'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'zarmeen'@'localhost' IDENTIFIED BY '1234';
CREATE USER 'abubakar'@'localhost' IDENTIFIED BY '1234';

GRANT librarian TO 'sharjeel'@'localhost';
GRANT student TO 'zarmeen'@'localhost';
GRANT admin TO 'abubakar'@'localhost';

SET DEFAULT ROLE librarian TO 'sharjeel'@'localhost';
SET DEFAULT ROLE student TO 'zarmeen'@'localhost';
SET DEFAULT ROLE admin TO 'abubakar'@'localhost';

REVOKE DELETE ON Libraryauto_DB.Books FROM librarian;
REVOKE SELECT ON Libraryauto_DB.Books FROM student;

CREATE TABLE Departments (
    DeptID INT PRIMARY KEY AUTO_INCREMENT,
    DeptName VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Programs (
    ProgramID INT PRIMARY KEY AUTO_INCREMENT,
    ProgramName VARCHAR(100) UNIQUE NOT NULL,
    DeptID INT,
    DurationYears INT DEFAULT 4,
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100) UNIQUE NOT NULL,
    Description VARCHAR(255)
);

CREATE TABLE Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    ISBN VARCHAR(30) UNIQUE,
    Title VARCHAR(150) NOT NULL,
    Author VARCHAR(100),
    Publisher VARCHAR(100),
    BookType ENUM('Book','Journal','Thesis','Report','Newspaper','Magazine','Document') DEFAULT 'Book',
    CategoryID INT,
    TotalCopies INT DEFAULT 1,
    AvailableCopies INT DEFAULT 1,
    ShelfNo VARCHAR(20),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Students (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    RegNo VARCHAR(50) UNIQUE NOT NULL,
    StudentName VARCHAR(100) NOT NULL,
    DeptID INT,
    ProgramID INT,
    Semester INT,
    Email VARCHAR(100),
    MobileNo VARCHAR(20),
    Address VARCHAR(200),
    MembershipCardNo VARCHAR(50) UNIQUE,
    RegistrationDate DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID),
    FOREIGN KEY (ProgramID) REFERENCES Programs(ProgramID)
);

CREATE TABLE Faculty (
    FacultyID INT PRIMARY KEY AUTO_INCREMENT,
    EmpNo VARCHAR(50) UNIQUE NOT NULL,
    FacultyName VARCHAR(100) NOT NULL,
    DeptID INT,
    Designation VARCHAR(50),
    Email VARCHAR(100),
    MobileNo VARCHAR(20),
    Address VARCHAR(200),
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);

CREATE TABLE BookStock (
    StockID INT PRIMARY KEY AUTO_INCREMENT,
    BookID INT,
    TotalCopies INT,
    AvailableCopies INT,
    LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

CREATE TABLE IssueRecords (
    IssueID INT PRIMARY KEY AUTO_INCREMENT,
    BookID INT,
    IssueDate DATE,
    DueDate DATE,
    ReturnDate DATE NULL,
    IssuedToType ENUM('Student','Faculty'),
    IssuedToID INT,
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    UserType ENUM('Student','Faculty'),
    UserID INT,
    PaymentType ENUM('Membership','Fine') DEFAULT 'Membership',
    Amount DECIMAL(10,2),
    PaymentDate DATE DEFAULT (CURRENT_DATE),
    VoucherNo VARCHAR(50) UNIQUE,
    Status ENUM('Paid','Pending') DEFAULT 'Paid'
);

CREATE TABLE FinesRecord (
    FineID INT PRIMARY KEY AUTO_INCREMENT,
    IssueID INT,
    FineAmount DECIMAL(10,2) DEFAULT 0.00,
    IsCleared BOOLEAN DEFAULT FALSE,
    ClearedDate DATE NULL,
    FOREIGN KEY (IssueID) REFERENCES IssueRecords(IssueID)
);

CREATE TABLE NOC_Records (
    NOC_ID INT PRIMARY KEY AUTO_INCREMENT,
    UserType ENUM('Student','Faculty'),
    UserID INT,
    IssueDate DATE DEFAULT (CURRENT_DATE),
    Cleared BOOLEAN DEFAULT FALSE,
    Remarks VARCHAR(255)
);

INSERT INTO Departments (DeptName) VALUES
('Computer Science'),
('Information Technology'),
('Artificial Intelligence');

INSERT INTO Programs (ProgramName, DeptID, DurationYears) VALUES
('BS Computer Science', 1, 4),
('BS Information Technology', 2, 4),
('BS Artificial Intelligence', 3, 4);

INSERT INTO Students (RegNo, StudentName, DeptID, ProgramID, Semester, Email, MobileNo, Address, MembershipCardNo) VALUES
('B2433073', 'Abu Bakar', 3, 3, 4, 'abu.ba@example.com', '0300-1111111', 'Lyari, Karachi', 'LIB-001'),
('B2433078', 'Awais Abdullah', 3, 3, 4, 'awais.chandio@example.com', '0301-2222222', 'Gulshan Iqbal, Karachi', 'LIB-002'),
('B2433113', 'Sharjeel Ahmed', 3, 3, 4, 'Sharjeel.ahmed@example.com', '0302-3333333', 'Garden, West', 'LTB-003'),
('B2433136', 'Warda Nasir', 3, 3, 4, 'warda.nasi@example.com', '0303-4444444', 'Shershah, Karachi', 'LTB-004'),
('B2433130', 'Zarmeen Moosa', 3, 3, 4, 'zarmeen.m@example.com', '0304-5555555', 'Lyari, Karachi', 'LTB-005');

INSERT INTO Faculty (EmpNo, FacultyName, DeptID, Designation, Email, MobileNo, Address) VALUES
('EMP1001', 'Dr. Mazhar Dootio', 1, 'Professor', 'mazhar.d@example.com', '0312-1111112', 'Karachi'),
('EMP1002', 'Mr. Anwar Ali Sathio', 1, 'Lecturer', 'anwarsathio@example.com', '0311-1111111', 'Karachi'),
('EMP1003', 'Mr. Khuda Baksh', 3, 'Associate Professor', 'k.b@example.com', '0313-3333333', 'Karachi'),
('EMP1004', 'Ms. Nadia Murad', 2, 'Assistant Professor', 'nadia.m@example.com', '0314-4444444', 'Karachi'),
('EMP1005', 'Mr. Faisal', 1, 'Lecturer', 'faisal@example.com', '0315-5555555', 'Karachi');

INSERT INTO Categories (CategoryName, Description) VALUES
('Artificial Intelligence', 'AI and Machine Learning'),
('Database', 'Database Design and Management'),
('Programming', 'Coding and Best Practices'),
('Networking', 'Computer Networks'),
('Cyber Security', 'Security and Forensics');

INSERT INTO Books (ISBN, Title, Author, Publisher, BookType, CategoryID, TotalCopies, AvailableCopies, ShelfNo) VALUES
('978-1', 'Artificial Intelligence Basics', 'Dr. Imran Siddiqui', 'Oxford', 'Book', 1, 5, 5, 'A-1'),
('978-2', 'Machine Learning Journal', 'Dr. Sana', 'IEEE', 'Journal', 1, 2, 2, 'A-2'),
('978-3', 'Network Security Report 2024', 'Cyber Team', 'NCC', 'Report', 5, 1, 1, 'E-3'),
('978-4', 'University Newspaper', 'Media Dept', 'Campus Press', 'Newspaper', 4, 10, 10, 'N-1');

INSERT INTO IssueRecords (BookID, IssueDate, DueDate, IssuedToType, IssuedToID)
VALUES (1, '2025-10-01', '2025-10-10', 'Student', 1);

INSERT INTO Payments (UserType, UserID, PaymentType, Amount, VoucherNo, Status)
VALUES ('Student', 1, 'Membership', 500.00, 'VCH-001', 'Paid');

INSERT INTO BookStock (BookID, TotalCopies, AvailableCopies)
SELECT BookID, TotalCopies, AvailableCopies FROM Books;

INSERT INTO IssueRecords (BookID, IssueDate, DueDate, IssuedToType, IssuedToID)
VALUES (1, '2025-10-01', '2025-10-10', 'Student', 1);

DELIMITER $$
CREATE TRIGGER trg_book_return_update
AFTER UPDATE ON IssueRecords
FOR EACH ROW
BEGIN
    IF NEW.ReturnDate IS NOT NULL AND OLD.ReturnDate IS NULL THEN
        UPDATE Books
        SET AvailableCopies = AvailableCopies + 1
        WHERE BookID = NEW.BookID;
        UPDATE BookStock
        SET AvailableCopies = AvailableCopies + 1
        WHERE BookID = NEW.BookID;
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE CheckNoDues(IN userType VARCHAR(10), IN userID INT)
BEGIN
    DECLARE unpaidFines INT DEFAULT 0;
    SELECT COUNT(*) INTO unpaidFines
    FROM FinesRecord F
    JOIN IssueRecords IR ON F.IssueID = IR.IssueID
    WHERE F.IsCleared = FALSE
    AND IR.IssuedToType = userType
    AND IR.IssuedToID = userID;
    IF unpaidFines > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot issue book. User has pending dues/fines.';
    END IF;
END$$

CREATE PROCEDURE GenerateVoucher(
    IN userType VARCHAR(10),
    IN userID INT,
    IN paymentType VARCHAR(10),
    IN amount DECIMAL(10,2)
)
BEGIN
    INSERT INTO Payments(UserType, UserID, PaymentType, Amount, VoucherNo)
    VALUES (userType, userID, paymentType, amount, CONCAT('VCH-', UUID()));
END$$
DELIMITER ;

CREATE OR REPLACE VIEW View_BalanceOfBooks AS
SELECT B.BookID, B.Title, B.BookType, B.TotalCopies, B.AvailableCopies,
       (B.TotalCopies - B.AvailableCopies) AS IssuedCopies
FROM Books B;

CREATE OR REPLACE VIEW View_PendingFines AS
SELECT 
    F.FineID,
    B.Title,
    CASE 
        WHEN IR.IssuedToType='Student' THEN S.StudentName
        ELSE T.FacultyName
    END AS Borrower,
    F.FineAmount,
    F.IsCleared
FROM FinesRecord F
JOIN IssueRecords IR ON F.IssueID = IR.IssueID
JOIN Books B ON IR.BookID = B.BookID
LEFT JOIN Students S ON IR.IssuedToType='Student' AND IR.IssuedToID=S.StudentID
LEFT JOIN Faculty T ON IR.IssuedToType='Faculty' AND IR.IssuedToID=T.FacultyID;

-- ye output queries ha 
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
