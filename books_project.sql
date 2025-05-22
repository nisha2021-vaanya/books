DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

Select * From books;
Select * From Customers;
Select * From orders;

-- 1) Retrieve all books in the "Fiction" genre:
Select * From books
Where genre = 'Fiction';

- 2) Find books published after the year 1950:
Select * From books
Where published_year > 1950;

-- 3) List all customers from the Canada:
Select * From Customers
Where country = 'Canada';

-- 4) Show orders placed in November 2023:
SELECT * FROM Orders 
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';


-- 5) Retrieve the total stock of books available:
 Select 
 Sum(stock) As total_stock
  from books

  -- 6) Find the details of the most expensive book:
  Select 
  	book_id,
   Max(price) As expensive_book
  from books
  Group by book_id
  Order by 2 Desc

  -- 7) Show all customers who ordered more than 1 quantity of a book:
  Select * from orders
  Where quantity > 1

  -- 8) Retrieve all orders where the total amount exceeds $20:
   Select * from orders
   where total_amount > 20

  -- 9) List all genres available in the Books table: 
  select Distinct genre from books

  
  -- 10) Find the book with the lowest stock:
  Select  *
  from books
  Where stock =( select MIN(stock) From books);

 -- Alternate way
 SELECT * FROM Books 
ORDER BY stock 
LIMIT 1;

-- 11) Calculate the total revenue generated from all orders:
Select Sum(total_amount) As total_revnue from orders


-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
Select 
b.genre,
Sum(o.quantity) As books_sold
from books As b
JOIN orders As o 
ON o.book_id = b.book_id
Group By 1


-- 2) Find the average price of books in the "Fantasy" genre:
Select 
AVG(price) As average_price
from books
Where genre = 'Fantasy'


-- 3) List customers who have placed at least 2 orders:
SELECT o.customer_id, c.name, COUNT(o.Order_id) AS ORDER_COUNT
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id) >=2;


-- 4) Find the most frequently ordered book:
SELECT o.Book_id, b.title, COUNT(o.order_id) AS ORDER_COUNT
FROM orders o
Join books As b
ON b.book_id = o.book_id
Group by 1,2
Order by 3 DESC
LIMIT 1


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT 
    book_id,
    title,
    price AS expensive_book
FROM books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;


--6) Retrieve the total quantity of books sold by each author:
Select b.book_id,
b.author,
Sum(o.quantity) As total_quantity
From orders As o
JOIN books As b 
ON b.book_id = o.book_id
Group by 1


-- 7) List the cities where customers who spent over $30 are located:
Select 
c.city ,
o.total_amount 
from customers As c
JOIN orders As o 
On o.customer_id = c.customer_id
Where o.total_amount >= 30
Group by 1,2


-- 8) Find the customer who spent the most on orders:
Select c.customer_id, 
c.name,
SUM(o.total_amount) As total_spent
from orders As o
JOIN customers c ON o.customer_id=c.customer_id
Group by 1,2
Order by 3
LIMIT 1


--9) Calculate the stock remaining after fulfilling all orders:

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;

-- End_of_project
