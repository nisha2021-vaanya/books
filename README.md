-- ================================================
--📚 Bookstore Database Project (PostgreSQL)
-- ================================================

-- Drop existing tables if they exist
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Books;

-- =========================
-- 1) Create Books Table
-- =========================
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

-- =========================
-- 2) Create Customers Table
-- =========================
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

-- =========================
-- 3) Create Orders Table
-- =========================
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

-- ================================================
-- 🔹 Basic Queries
-- ================================================

-- 1) Retrieve all books in the "Fiction" genre
SELECT * FROM Books WHERE Genre = 'Fiction';

-- 2) Find books published after 1950
SELECT * FROM Books WHERE Published_Year > 1950;

-- 3) List all customers from Canada
SELECT * FROM Customers WHERE Country = 'Canada';

-- 4) Show orders placed in November 2023
SELECT * FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available
SELECT SUM(Stock) AS Total_Stock FROM Books;

-- 6) Find the details of the most expensive book
SELECT * FROM Books ORDER BY Price DESC LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity
SELECT * FROM Orders WHERE Quantity > 1;

-- 8) Retrieve all orders where total amount exceeds $20
SELECT * FROM Orders WHERE Total_Amount > 20;

-- 9) List all unique genres
SELECT DISTINCT Genre FROM Books;

-- 10) Find the book with the lowest stock
SELECT * FROM Books ORDER BY Stock ASC LIMIT 1;

-- 11) Calculate the total revenue generated
SELECT SUM(Total_Amount) AS Total_Revenue FROM Orders;

-- ================================================
-- 🔹 Advanced Queries
-- ================================================

-- 1) Total number of books sold per genre
SELECT b.Genre, SUM(o.Quantity) AS Books_Sold
FROM Books b
JOIN Orders o ON o.Book_ID = b.Book_ID
GROUP BY b.Genre;

-- 2) Average price of Fantasy books
SELECT AVG(Price) AS Avg_Price
FROM Books
WHERE Genre = 'Fantasy';

-- 3) Customers with at least 2 orders
SELECT o.Customer_ID, c.Name, COUNT(o.Order_ID) AS Order_Count
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY o.Customer_ID, c.Name
HAVING COUNT(o.Order_ID) >= 2;

-- 4) Most frequently ordered book
SELECT o.Book_ID, b.Title, COUNT(o.Order_ID) AS Order_Count
FROM Orders o
JOIN Books b ON b.Book_ID = o.Book_ID
GROUP BY o.Book_ID, b.Title
ORDER BY Order_Count DESC
LIMIT 1;

-- 5) Top 3 expensive Fantasy books
SELECT Book_ID, Title, Price
FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC
LIMIT 3;

-- 6) Total quantity of books sold by each author
SELECT b.Author, SUM(o.Quantity) AS Total_Quantity
FROM Orders o
JOIN Books b ON b.Book_ID = o.Book_ID
GROUP BY b.Author;

-- 7) Cities where customers spent over $30
SELECT c.City, SUM(o.Total_Amount) AS City_Spending
FROM Customers c
JOIN Orders o ON o.Customer_ID = c.Customer_ID
GROUP BY c.City
HAVING SUM(o.Total_Amount) > 30;

-- 8) Customer who spent the most
SELECT c.Customer_ID, c.Name, SUM(o.Total_Amount) AS Total_Spent
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Name
ORDER BY Total_Spent DESC
LIMIT 1;

-- 9) Stock remaining after fulfilling all orders
SELECT b.Book_ID, b.Title, b.Stock,
       COALESCE(SUM(o.Quantity), 0) AS Ordered_Qty,
       b.Stock - COALESCE(SUM(o.Quantity), 0) AS Remaining_Qty
FROM Books b
LEFT JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Stock
ORDER BY b.Book_ID;
