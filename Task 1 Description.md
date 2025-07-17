# Library Management System (SQL Project)

This project is a SQL-based Library Management System developed using MySQL. It is designed to manage book inventories, member details, and borrowing transactions in a library environment.

The database consists of three main tables:

- **Books**: Stores details about each book, including title, author, genre, publication year, and available copies.
- **Members**: Contains information about library members such as name, contact, address, and membership date.
- **BorrowingRecords**: Tracks book borrowings, including which member borrowed which book and when.

# What I've Done in This Project:

- Created and structured relational tables with appropriate primary and foreign keys.
- Inserted realistic sample data into all three tables.
- Written SQL queries to:
  - Retrieve books borrowed by a specific member.
  - Identify members with overdue books.
  - Show available copies grouped by genre.
  - Find the most borrowed books.
  - Detect members who borrowed from at least three different genres.
  - Calculate books borrowed per month.
  - Identify the top 3 most active members.
  - Find authors whose books have been borrowed at least 10 times.
  - List members who have never borrowed a book.
