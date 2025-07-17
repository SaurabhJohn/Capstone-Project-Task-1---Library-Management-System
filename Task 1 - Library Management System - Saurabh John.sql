-- Create Database
Create Database Library_Managment_System;

-- using database
use Library_Managment_System;

-- Creating the Tables

-- a) Create Books table
CREATE TABLE Books (
    BOOK_ID INT PRIMARY KEY,
    TITLE VARCHAR(100),
    AUTHOR VARCHAR(100),
    GENRE VARCHAR(50),
    YEAR_PUBLISHED INT,
    AVAILABLE_COPIES INT
);

-- b) Create Members table
CREATE TABLE Members (
    MEMBER_ID INT PRIMARY KEY,
    NAME VARCHAR(100),
    EMAIL VARCHAR(100),
    PHONE_NO VARCHAR(15),
    ADDRESS VARCHAR(255),
    MEMBERSHIP_DATE DATE
);

-- c) Create BorrowingRecords table
CREATE TABLE BorrowingRecords (
    BORROW_ID INT PRIMARY KEY,
    MEMBER_ID INT,
    BOOK_ID INT,
    BORROW_DATE DATE,
    RETURN_DATE DATE,
    FOREIGN KEY (MEMBER_ID) REFERENCES Members(MEMBER_ID),
    FOREIGN KEY (BOOK_ID) REFERENCES Books(BOOK_ID)
);

-- Inserting Sample Data into the Tables

-- a) Inserting sample data into Books table
INSERT INTO Books VALUES
(1, 'To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, 4),
(2, '1984', 'George Orwell', 'Dystopian', 1949, 2),
(3, 'The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', 1925, 3),
(4, 'The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 1937, 5),
(5, 'Sapiens', 'Yuval Noah Harari', 'Non-Fiction', 2011, 2),
(6, 'The Alchemist', 'Paulo Coelho', 'Fiction', 1988, 1),
(7, 'Harry Potter and the Sorcerer''s Stone', 'J.K. Rowling', 'Fantasy', 1997, 0);

-- b) Inserting sample data into Members table
INSERT INTO Members VALUES
(101, 'Alice Johnson', 'alice@example.com', '9876543210', '123 Elm Street', '2023-01-15'),
(102, 'Bob Smith', 'bob@example.com', '8765432109', '456 Oak Avenue', '2022-11-20'),
(103, 'Charlie Davis', 'charlie@example.com', '7654321098', '789 Pine Road', '2023-03-10'),
(104, 'Diana Miller', 'diana@example.com', '6543210987', '321 Maple Lane', '2023-02-05'),
(105, 'Ethan Brown', 'ethan@example.com', '5432109876', '159 Cedar Blvd', '2023-04-25');

-- c) Inserting sample data into BorrowingRecords table
INSERT INTO BorrowingRecords VALUES
(1001, 101, 1, '2025-06-01', '2025-06-21'),
(1002, 102, 2, '2025-06-05', NULL),
(1003, 101, 4, '2025-07-01', NULL),
(1004, 103, 3, '2025-05-15', '2025-06-10'),
(1005, 104, 5, '2025-06-20', NULL),
(1006, 102, 6, '2025-05-01', '2025-06-12'),
(1007, 105, 2, '2025-07-05', NULL),
(1008, 105, 7, '2025-07-10', NULL);

-- Information Retreival

-- a) Retrieve list of books currently borrowed by a specific member
SELECT B.TITLE, B.AUTHOR, BR.BORROW_DATE
FROM BorrowingRecords BR
JOIN Books B ON BR.BOOK_ID = B.BOOK_ID
WHERE BR.MEMBER_ID = 105
  AND BR.RETURN_DATE IS NULL;
  
  -- b) Find members who have overdue books (borrowed more than 30 days ago and not returned)
SELECT M.MEMBER_ID, M.NAME, BR.BORROW_DATE
FROM BorrowingRecords BR
JOIN Members M ON BR.MEMBER_ID = M.MEMBER_ID
WHERE BR.RETURN_DATE IS NULL
  AND BR.BORROW_DATE <= (CURRENT_DATE - INTERVAL 30 DAY);
  
  -- c) Retrieve books by genre along with the count of available copies
SELECT GENRE, SUM(AVAILABLE_COPIES) AS TOTAL_AVAILABLE_COPIES
FROM Books
GROUP BY GENRE;

-- d) Find the most borrowed book(s) overall
WITH BorrowCounts AS (
    SELECT B.TITLE, COUNT(*) AS TIMES_BORROWED
    FROM BorrowingRecords BR
    JOIN Books B ON BR.BOOK_ID = B.BOOK_ID
    GROUP BY B.TITLE
)
SELECT TITLE, TIMES_BORROWED
FROM BorrowCounts
WHERE TIMES_BORROWED = (
    SELECT MAX(TIMES_BORROWED) FROM BorrowCounts
);

-- Add new borrowing records to ensure at6least one member 3+ genres
INSERT INTO BorrowingRecords VALUES
(1009, 101, 2, '2023-07-15', NULL), 
(1010, 101, 5, '2023-07-16', NULL); 

-- e) Retrieve members who have borrowed books from at least three different genres
SELECT M.MEMBER_ID, M.NAME
FROM BorrowingRecords BR
JOIN Books B ON BR.BOOK_ID = B.BOOK_ID
JOIN Members M ON BR.MEMBER_ID = M.MEMBER_ID
GROUP BY M.MEMBER_ID, M.NAME
HAVING COUNT(DISTINCT B.GENRE) >= 3;

-- Reporting and Analytics

-- a) Calculate the total number of books borrowed per month
SELECT DATE_FORMAT(BORROW_DATE, '%Y-%m') AS MONTH, COUNT(*) AS TOTAL_BORROWED
FROM BorrowingRecords
GROUP BY MONTH
ORDER BY MONTH;

-- b) Find the top three most active members based on the number of books borrowed
SELECT M.MEMBER_ID, M.NAME, COUNT(*) AS BOOKS_BORROWED
FROM BorrowingRecords BR
JOIN Members M ON BR.MEMBER_ID = M.MEMBER_ID
GROUP BY M.MEMBER_ID, M.NAME
ORDER BY BOOKS_BORROWED DESC
LIMIT 3;

-- c) Retrieve authors whose books have been borrowed at least 10 times
SELECT B.AUTHOR, COUNT(*) AS TIMES_BORROWED
FROM BorrowingRecords BR
JOIN Books B ON BR.BOOK_ID = B.BOOK_ID
GROUP BY B.AUTHOR
HAVING TIMES_BORROWED >= 10;

-- Adding new record to ensure a member who has never borrowed any book
INSERT INTO Members VALUES
(106, 'Farah Khan', 'farah@example.com', '9988776655', '88 Birch Drive', '2023-07-17');

-- d) Identify members who have never borrowed a book
SELECT M.MEMBER_ID, M.NAME
FROM Members M
LEFT JOIN BorrowingRecords BR ON M.MEMBER_ID = BR.MEMBER_ID
WHERE BR.MEMBER_ID IS NULL;