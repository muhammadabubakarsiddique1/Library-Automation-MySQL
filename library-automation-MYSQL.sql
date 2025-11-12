DROP DATABASE IF EXISTS LibraryM_DB;
CREATE DATABASE LibraryM_DB;
USE LibraryM_DB;

CREATE TABLE Departments (
    DeptID INT PRIMARY KEY AUTO_INCREMENT,
    DeptName VARCHAR(100) UNIQUE NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Programs (
    ProgramID INT PRIMARY KEY AUTO_INCREMENT,
    ProgramName VARCHAR(150) NOT NULL,
    DeptID INT NOT NULL,
    DurationMonths INT,
    UNIQUE (ProgramName, DeptID),
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID) ON DELETE CASCADE
);

CREATE TABLE Roles (
    RoleID INT PRIMARY KEY AUTO_INCREMENT,
    RoleName VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(100) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    RoleID INT NOT NULL,
    FullName VARCHAR(150),
    Email VARCHAR(150),
    MobileNo VARCHAR(30),
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    LastLogin DATETIME NULL,
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
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

CREATE TABLE Memberships (
    MembershipID INT PRIMARY KEY AUTO_INCREMENT,
    MemberType ENUM('Student','Faculty','External') NOT NULL,
    MemberRefID INT NOT NULL,
    CardNumber VARCHAR(50) UNIQUE NOT NULL,
    IssuedByUserID INT,
    IssueDate DATE NOT NULL,
    ExpiryDate DATE NOT NULL,
    IsActive BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (IssuedByUserID) REFERENCES Users(UserID)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    MembershipID INT,
    PaymentFor ENUM('Membership','Fine','Other') NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaidVia ENUM('Cash','Card','Online') DEFAULT 'Cash',
    PaidAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (MembershipID) REFERENCES Memberships(MembershipID)
);

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100) UNIQUE NOT NULL,
    Description VARCHAR(255)
);

CREATE TABLE ItemTypes (
    ItemTypeID INT PRIMARY KEY AUTO_INCREMENT,
    TypeName VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Items (
    ItemID INT PRIMARY KEY AUTO_INCREMENT,
    ISBN VARCHAR(64),
    Title VARCHAR(300) NOT NULL,
    Author VARCHAR(200),
    Publisher VARCHAR(200),
    CategoryID INT,
    ItemTypeID INT NOT NULL,
    Edition VARCHAR(50),
    PublicationYear INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (ItemTypeID) REFERENCES ItemTypes(ItemTypeID)
);

CREATE TABLE ItemCopies (
    CopyID INT PRIMARY KEY AUTO_INCREMENT,
    ItemID INT NOT NULL,
    CopyBarcode VARCHAR(100) UNIQUE,
    ShelfNo VARCHAR(64),
    Status ENUM('Available','Issued','Lost','Damaged','ReferenceOnly') DEFAULT 'Available',
    AcquisitionDate DATE,
    FOREIGN KEY (ItemID) REFERENCES Items(ItemID) ON DELETE CASCADE
);

CREATE TABLE ItemStockSummary (
    ItemID INT PRIMARY KEY,
    TotalCopies INT DEFAULT 0,
    AvailableCopies INT DEFAULT 0,
    IssuedCopies INT DEFAULT 0,
    FOREIGN KEY (ItemID) REFERENCES Items(ItemID)
);

CREATE TABLE IssueRecords (
    IssueID INT PRIMARY KEY AUTO_INCREMENT,
    CopyID INT NOT NULL,
    IssueDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE NULL,
    IssuedToType ENUM('Student','Faculty','External') NOT NULL,
    IssuedToID INT NOT NULL,
    IssuedByUserID INT NOT NULL,
    FOREIGN KEY (CopyID) REFERENCES ItemCopies(CopyID),
    FOREIGN KEY (IssuedByUserID) REFERENCES Users(UserID)
);

CREATE TABLE Penalties (
    PenaltyID INT PRIMARY KEY AUTO_INCREMENT,
    IssueID INT UNIQUE,
    DaysOverdue INT DEFAULT 0,
    FineAmount DECIMAL(10,2) DEFAULT 0.00,
    IsCleared BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (IssueID) REFERENCES IssueRecords(IssueID) ON DELETE CASCADE
);

CREATE TABLE AuditLogs (
    LogID BIGINT PRIMARY KEY AUTO_INCREMENT,
    EventTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UserID INT NULL,
    Action VARCHAR(100),
    ObjectType VARCHAR(100),
    ObjectID VARCHAR(100),
    Details JSON NULL,
    IPAddress VARCHAR(50),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE INDEX idx_students_dept ON Students(DeptID);
CREATE INDEX idx_programs_dept ON Programs(DeptID);
CREATE INDEX idx_items_cat ON Items(CategoryID);
CREATE INDEX idx_itemcopies_item ON ItemCopies(ItemID);
CREATE INDEX idx_issue_issuedto ON IssueRecords(IssuedToType, IssuedToID);
CREATE INDEX idx_penalties_issueid ON Penalties(IssueID);

INSERT INTO Roles (RoleName) VALUES ('Admin'),('Staff'),('Member');
INSERT INTO Departments (DeptName) VALUES ('Computer Science'),('Information Technology'),('Artificial Intelligence');
INSERT INTO Programs (ProgramName, DeptID, DurationMonths) VALUES ('BS CS',1,48), ('MS AI',3,24);
INSERT INTO ItemTypes (TypeName) VALUES ('Book'),('Journal'),('Magazine'),('Newspaper'),('Thesis'),('eBook');
INSERT INTO Categories (CategoryName, Description)
VALUES
('Artificial Intelligence','AI and Machine Learning'),
('Database','Database Design and Management'),
('Programming','Coding and Best Practices'),
('Networking','Computer Networks'),
('Cyber Security','Security and Forensics');

INSERT INTO Users (Username, PasswordHash, RoleID, FullName, Email)
VALUES
('admin','$hash$',1,'System Administrator','admin@example.com'),
('lib1','$hash$',2,'Librarian One','lib1@example.com');

INSERT INTO Students (RegNo, StudentName, DeptID, ProgramID, Semester, Email, MobileNo, Address)
VALUES
('B2433073','Abu Bakar',3,2,4,'abu.ba@example.com','0300-1111111','Lyari, Karachi'),
('B2433078','Awais Abdullah',3,2,4,'awais.chandio@example.com','0301-2222222','Gulshan Iqbal, Karachi');

INSERT INTO Faculty (EmpNo, FacultyName, DeptID, Designation, Email, MobileNo, Address)
VALUES
('EMP1001','Dr. Mazhar Dootio',1,'Professor','mazhar.d@example.com','0311-1111111','Karachi'),
('EMP1002','Mr. Anwar Sathio',2,'Lecturer','anwar.s@example.com','0312-2222222','Karachi');

INSERT INTO Items (ISBN, Title, Author, Publisher, CategoryID, ItemTypeID, Edition, PublicationYear)
VALUES
('978-1','Artificial Intelligence Basics','Dr. Imran Siddiqui','Oxford',1,1,'1st',2024),
('978-2','Database Management Systems','Dr. Farhan Ahmed','Pearson',2,1,'3rd',2019),
('978-3','Clean Coding Practices','Engr. Saad Khalid','McGraw Hill',3,1,'2nd',2021),
('NA-NEWSP-001','Daily Tech','Editorial Team','DailyPress',4,4,NULL,2025);

INSERT INTO ItemCopies (ItemID, CopyBarcode, ShelfNo, Status, AcquisitionDate)
VALUES
(1,'AI-0001','A-1','Available','2025-01-01'),
(1,'AI-0002','A-1','Available','2025-01-01'),
(2,'DB-0001','B-1','Available','2024-05-10'),
(3,'CC-0001','C-2','Available','2023-08-15'),
(4,'DT-0001','D-1','ReferenceOnly','2025-10-01');

INSERT INTO Memberships (MemberType, MemberRefID, CardNumber, IssuedByUserID, IssueDate, ExpiryDate)
VALUES
('Student',1,'CARD-1001',2,'2025-01-01','2026-01-01'),
('Faculty',1,'CARD-F1001',2,'2025-01-01','2027-01-01');

DELIMITER $$
CREATE TRIGGER trg_copy_insert AFTER INSERT ON ItemCopies
FOR EACH ROW
BEGIN
    INSERT INTO ItemStockSummary (ItemID, TotalCopies, AvailableCopies, IssuedCopies)
    VALUES (NEW.ItemID, 1, IF(NEW.Status='Available',1,0), IF(NEW.Status='Issued',1,0))
    ON DUPLICATE KEY UPDATE
        TotalCopies = TotalCopies + 1,
        AvailableCopies = AvailableCopies + IF(NEW.Status='Available',1,0),
        IssuedCopies = IssuedCopies + IF(NEW.Status='Issued',1,0);
END$$

CREATE TRIGGER trg_copy_update AFTER UPDATE ON ItemCopies
FOR EACH ROW
BEGIN
    IF NEW.Status <> OLD.Status THEN
        UPDATE ItemStockSummary
        SET AvailableCopies = AvailableCopies - IF(OLD.Status='Available',1,0) + IF(NEW.Status='Available',1,0),
            IssuedCopies = IssuedCopies - IF(OLD.Status='Issued',1,0) + IF(NEW.Status='Issued',1,0)
        WHERE ItemID = NEW.ItemID;
    END IF;
END$$

CREATE TRIGGER trg_copy_delete AFTER DELETE ON ItemCopies
FOR EACH ROW
BEGIN
    UPDATE ItemStockSummary
    SET TotalCopies = GREATEST(TotalCopies - 1,0),
        AvailableCopies = GREATEST(AvailableCopies - IF(OLD.Status='Available',1,0),0),
        IssuedCopies = GREATEST(IssuedCopies - IF(OLD.Status='Issued',1,0),0)
    WHERE ItemID = OLD.ItemID;
END$$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE IssueItem(
    IN p_CopyID INT,
    IN p_Type ENUM('Student','Faculty','External'),
    IN p_ID INT,
    IN p_ByUser INT,
    IN p_Issue DATE,
    IN p_Due DATE
)
BEGIN
    DECLARE v_available INT DEFAULT 0;
    DECLARE v_membership INT DEFAULT 0;
    DECLARE v_open_issues INT DEFAULT 0;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_available FROM ItemCopies WHERE CopyID = p_CopyID AND Status = 'Available' FOR UPDATE;
    IF v_available = 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Copy not available for issue';
    END IF;

    IF p_Type IN ('Student','Faculty') THEN
        SELECT COUNT(*) INTO v_membership FROM Memberships
        WHERE MemberType = p_Type AND MemberRefID = p_ID AND IsActive = 1 AND ExpiryDate >= p_Issue FOR UPDATE;
        IF v_membership = 0 THEN
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Active membership required';
        END IF;
    END IF;

    SELECT COUNT(*) INTO v_open_issues FROM IssueRecords
    WHERE IssuedToType = p_Type AND IssuedToID = p_ID AND ReturnDate IS NULL FOR UPDATE;
    IF p_Type = 'Student' AND v_open_issues >= 5 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Student has reached maximum active loans (5)';
    END IF;

    INSERT INTO IssueRecords (CopyID, IssueDate, DueDate, IssuedToType, IssuedToID, IssuedByUserID)
    VALUES (p_CopyID, p_Issue, p_Due, p_Type, p_ID, p_ByUser);

    UPDATE ItemCopies SET Status='Issued' WHERE CopyID = p_CopyID;

    INSERT INTO AuditLogs (UserID, Action, ObjectType, ObjectID, Details)
    VALUES (p_ByUser, 'IssueItem', 'Copy', CAST(p_CopyID AS CHAR), JSON_OBJECT('IssuedToType', p_Type, 'IssuedToID', p_ID));

    COMMIT;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE ReturnItem(
    IN p_IssueID INT,
    IN p_Return DATE,
    IN p_ProcessedBy INT
)
BEGIN
    DECLARE v_copy INT;
    DECLARE v_due DATE;
    DECLARE v_days INT;
    DECLARE v_fine DECIMAL(10,2);

    START TRANSACTION;

    SELECT CopyID, DueDate INTO v_copy, v_due FROM IssueRecords WHERE IssueID = p_IssueID FOR UPDATE;
    IF v_copy IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Issue record not found';
    END IF;

    UPDATE IssueRecords SET ReturnDate = p_Return WHERE IssueID = p_IssueID;
    UPDATE ItemCopies SET Status = 'Available' WHERE CopyID = v_copy;

    SET v_days = GREATEST(DATEDIFF(p_Return, v_due), 0);
    SET v_fine = v_days * 10.00;

    IF v_fine > 0 THEN
        INSERT INTO Penalties (IssueID, DaysOverdue, FineAmount, IsCleared)
        VALUES (p_IssueID, v_days, v_fine, FALSE)
        ON DUPLICATE KEY UPDATE
            DaysOverdue = v_days,
            FineAmount = v_fine,
            IsCleared = IsCleared;
    END IF;

    INSERT INTO AuditLogs (UserID, Action, ObjectType, ObjectID, Details)
    VALUES (p_ProcessedBy, 'ReturnItem', 'Issue', CAST(p_IssueID AS CHAR), JSON_OBJECT('ReturnDate', p_Return, 'Fine', v_fine));

    COMMIT;
END$$
DELIMITER ;

DELIMITER $$
CREATE EVENT IF NOT EXISTS ev_penalty_recalc
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    INSERT INTO Penalties (IssueID, DaysOverdue, FineAmount, IsCleared)
    SELECT IR.IssueID,
           GREATEST(DATEDIFF(CURDATE(), IR.DueDate), 0) AS DaysOver,
           GREATEST(DATEDIFF(CURDATE(), IR.DueDate), 0) * 10.00 AS FineAmt,
           FALSE
    FROM IssueRecords IR
    WHERE IR.ReturnDate IS NULL AND DATEDIFF(CURDATE(), IR.DueDate) > 0
    ON DUPLICATE KEY UPDATE
        DaysOverdue = VALUES(DaysOverdue),
        FineAmount = VALUES(FineAmount);
END$$
DELIMITER ;

CREATE OR REPLACE VIEW View_CurrentIssued AS
SELECT IR.IssueID, IC.CopyID, It.ItemID, It.Title, It.Author,
       IR.IssuedToType, IR.IssuedToID, IR.IssueDate, IR.DueDate, IR.ReturnDate, U.FullName AS IssuedBy
FROM IssueRecords IR
JOIN ItemCopies IC ON IR.CopyID = IC.CopyID
JOIN Items It ON IC.ItemID = It.ItemID
LEFT JOIN Users U ON IR.IssuedByUserID = U.UserID
WHERE IR.ReturnDate IS NULL;

CREATE OR REPLACE VIEW View_Overdue AS
SELECT IR.IssueID, It.Title, IR.IssuedToType, IR.IssuedToID, IR.DueDate,
       GREATEST(DATEDIFF(CURDATE(), IR.DueDate), 0) AS DaysLate,
       GREATEST(DATEDIFF(CURDATE(), IR.DueDate), 0) * 10.00 AS CurrentFine
FROM IssueRecords IR
JOIN ItemCopies IC ON IR.CopyID = IC.CopyID
JOIN Items It ON IC.ItemID = It.ItemID
WHERE IR.ReturnDate IS NULL AND IR.DueDate < CURDATE();

CREATE USER IF NOT EXISTS 'lib_admin'@'localhost' IDENTIFIED BY 'Admin@123';
CREATE USER IF NOT EXISTS 'lib_staff'@'localhost' IDENTIFIED BY 'Staff@123';

GRANT ALL PRIVILEGES ON LibraryM_DB.* TO 'lib_admin'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON LibraryM_DB.* TO 'lib_staff'@'localhost';
REVOKE SHUTDOWN, PROCESS, DROP ON *.* FROM 'lib_staff'@'localhost'; -- limit staff
FLUSH PRIVILEGES;