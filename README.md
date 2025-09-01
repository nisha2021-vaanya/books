# Bookstore Database Project

## 📚 Project Overview
This project implements a **Bookstore Database** using PostgreSQL. It includes tables for **Books**, **Customers**, and **Orders**, and performs both basic and advanced queries for analysis.

**Objectives:**
- Retrieve and filter books based on genre and publication year.
- Track customer information by city and country.
- Analyze orders by quantity, total amount, and customer spending.
- Aggregate sales, revenue, and stock data.
- Identify top-selling books and authors.

---

## 🗄 Database Structure

**Tables:**

1. **Books**
- `Book_ID` (Primary Key)
- `Title`, `Author`, `Genre`, `Published_Year`
- `Price`, `Stock`

2. **Customers**
- `Customer_ID` (Primary Key)
- `Name`, `Email`, `Phone`, `City`, `Country`

3. **Orders**
- `Order_ID` (Primary Key)
- `Customer_ID` (Foreign Key)
- `Book_ID` (Foreign Key)
- `Order_Date`, `Quantity`, `Total_Amount`

---

## 📝 Sample SQL Queries

### Basic Queries

```sql
-- Retrieve all books in the "Fiction" genre
SELECT * FROM books WHERE genre = 'Fiction';

-- Find books published after 1950
SELECT * FROM books WHERE published_year > 1950;

-- List all customers from Canada
SELECT * FROM customers WHERE country = 'Canada';

-- Show orders placed in November 2023
SELECT * FROM orders WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- Total stock of books available
SELECT SUM(stock) AS total_stock FROM books;

-- Most expensive book
SELECT book_id, MAX(price) AS expensive_book
FROM books
GROUP BY book_id
ORDER BY expensive_book DESC;

-- Customers who ordered more than 1 quantity
SELECT * FROM orders WHERE quantity > 1;

Advanced Queries
-- Total books sold per genre
SELECT b.genre, SUM(o.quantity) AS books_sold
FROM books AS b
JOIN orders AS o ON o.book_id = b.book_id
GROUP BY b.genre;

-- Average price of Fantasy books
SELECT AVG(price) AS average_price
FROM books
WHERE genre = 'Fantasy';

-- Customers with at least 2 orders
SELECT o.customer_id, c.name, COUNT(o.order_id) AS order_count
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(o.order_id) >= 2;

-- Most frequently ordered book
SELECT o.book_id, b.title, COUNT(o.order_id) AS order_count
FROM orders o
JOIN books b ON b.book_id = o.book_id
GROUP BY o.book_id, b.title
ORDER BY order_count DESC
LIMIT 1;

-- Top 3 most expensive Fantasy books
SELECT book_id, title, price AS expensive_book
FROM books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;

-- Total quantity sold by each author
SELECT b.author, SUM(o.quantity) AS total_quantity
FROM orders o
JOIN books b ON b.book_id = o.book_id
GROUP BY b.author;

-- Customers who spent over $30 by city
SELECT c.city, o.total_amount
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.total_amount >= 30
GROUP BY c.city, o.total_amount;

-- Customer who spent the most
SELECT c.customer_id, c.name, SUM(o.total_amount) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 1;

-- Stock remaining after fulfilling all orders
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity), 0) AS order_quantity, 
       b.stock - COALESCE(SUM(o.quantity), 0) AS remaining_quantity
FROM books b
LEFT JOIN orders o ON b.book_id = o.book_id
GROUP BY b.book_id, b.title, b.stock
ORDER BY b.book_id;

## Technologies Used
PostgreSQL
SQL (Joins, Aggregations, Window Functions)
Database Design & Analysis

## Key Insights
Track sales trends by genre and author.
Identify top customers and high-value orders.
Monitor stock levels and inventory management.
Determine pricing trends and revenue contribution per book.

## Project Link
https://github.com/nisha2021-vaanya/books/tree/main
