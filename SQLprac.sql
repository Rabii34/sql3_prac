create database practical;
use practical;

--Create a table named Orders with columns: OrderID, CustomerID, OrderDate, and TotalAmount.
--Insert sample data into the Customers, Products, and Orders tables.
create table Orders(
OrderID int,
CustomerID int primary key,
OrderDate date,
TotalAmount decimal(10,2)
);
insert into Orders(OrderID,CustomerID,OrderDate,TotalAmount)
values
(101,1,'2025-10-23',344.00),
(102,2,'2021-11-13',456.00),
(103,3,'2023-09-19',374.00),
(104,4,'2024-01-04',984.00),
(105,5,'2011-03-27',123.00),
(106,6,'2020-11-18',344.00),
(107,7,'2025-11-13',566.00),
(108,8,'2023-01-13',654.00),
(109,9,'2021-11-30',344.00),
(110,10,'2022-10-23',344.00);
select * from orders;

--Create a table named Customers with columns: CustomerID, FirstName, LastName, Email, and PhoneNumber.
create table Cutomers(
CustomerID int not null,
FirstName varchar(255) not null,
LastName varchar(255)not null,
Email varchar(255) not null unique,
PhoneNumber varchar(11)not null,
foreign key(CustomerID) references Orders(CustomerID)
);

insert into Cutomers(CustomerID,FirstName,LastName,Email,PhoneNumber) 
values
(3,'Rabia','kanwal','rk@gmail.com','123-34-76'),
(7,'Rimsha','khan','rim@gmail.com','1426-76-2'),
(2,'Isra','kanwal','isra@gmail.com','12346-76'),
(3,'Irsa','khan','irsa@gmail.com','45672-43'),
(3,'Amna','Rajpoot','amna@gmail.com','75421-98'),
(7,'Ana','Jamal','ana@gmail.com','72021-98-9'),
(4,'Anum','Sajad','anum@gmail.com','75410-664'),
(1,'Liza','Rajpoot','liza@gmail.com','754-219-8'),
(6,'Fiza','Bashir','fiz@gmail.com','75421-98'),
(10,'Tooba','Jamal','tob@gmail.com','421-98-56');
select * from Cutomers;

--Create a table named Products with columns: ProductID, ProductName, UnitPrice, and InStockQuantity.
Insert sample data into the Customers, Products,
create table Products(
ProductID int primary key,
ProductName varchar(255) not null,
UnitPrice decimal(10,2) not null,
InStockQuantity int not null
)

insert into Products(ProductID,ProductName,UnitPrice,InStockQuantity)
values
(501,'perfume',34.00,5),
(502,'mobile_cover',76.00,34),
(503,'pens',47.00,62),
(504,'lipstick',98.00,76),
(505,'charger',65.00,22);
select * from Products;

--Create a table named OrderDetails with columns: OrderDetailID, OrderID, ProductID, Quantity, and UnitPrice.
create table OrderDetails(
OrderDetailID int not null,
OrderID int not null,
ProductID int not null,
Quantity int not null,
UnitPrice decimal(10,2)not null,
foreign key(ProductID) references Products(ProductID)
);
select * from OrderDetails;

--1) Create a new user named Order_Clerk with permission to insert new orders and update order details in the Orders and OrderDetails tables.
create login "OrderClerk" with password='prac';
create user "OrderClerk" for login "OrderClerk";
grant insert,update on dbo.orders to OrderClerk;

insert into Orders(OrderID,CustomerID,OrderDate,TotalAmount)
values
(111,11,'2025-10-23',344.00);
update orders set OrderDate='2011-04-30' where OrderID=111;

insert into OrderDetails(OrderDetailID,OrderID,ProductID,Quantity,UnitPrice)
values
(2001,103,502,43,87.00);
update OrderDetails set UnitPrice=548.00 where OrderDetailID=2001;

--2) Create a trigger named Update_Stock_Audit that logs any updates made to the InStockQuantity 
--column of the Products table into a Stock_Update_Audit table.
create table Audit(
Audit_ID int,
Audit_Info varchar(255)
);

create trigger Update_Stock_Audit on Products
for update
as
begin
declare @pid int, @pname varchar(50),@pstock int
select @pid=ProductID, @pname=ProductName,@pstock=InStockQuantity  from Products
insert into Audit values('pro with id '+ CAST(@pid as varchar(50))+ 'with pname '+@pname + 'is updated in the table')
end
select * from Update_Stock_Audit;
--3) Write a SQL query that retrieves the FirstName, LastName, OrderDate, and TotalAmount of orders along with
--the customer details by joining the Customers and Orders tables.
select FirstName,LastName,OrderDate,TotalAmount from Cutomers as c join Orders as o on c.CustomerID=o.CustomerID

--4) Write a SQL query that retrieves the ProductName, Quantity, and TotalPrice of products ordered in orders with a total 
--amount greater than the average total amount of all orders.
select ProductName,InStockQuantity,UnitPrice from Products where ProductID >any(select avg(TotalAmount) from Orders)
select (Quantity*UnitPrice) as TotalPrice from OrderDetails; 
select ProductName,Quantity from  Products as p join OrderDetails as od on p.ProductID=od.ProductID;


--5) Create a stored procedure named GetOrdersByCustomer that takes a CustomerID as input and returns all
--orders placed by that customer along with their details.
create procedure GetOrderByCustomer 
@id int
as 
begin
select * from Orders where CustomerID=@id 
end
exec GetOrderByCustomer @id=5;
--6) Write a SQL query to create a view named OrderSummary that displays the OrderID, OrderDate,
--CustomerID, and TotalAmount from the Orders table.
create view OrderSummary 
as
select OrderID,OrderDate,CustomerID,TotalAmount from Orders;
select * from OrderSummary;
--7) Create a view named ProductInventory that shows the ProductName and InStockQuantity from the Products table.
create view ProductInventory 
as
select ProductName,InStockQuantity from Products;
select * from  ProductInventory;
--8) Write a SQL query that joins the OrderSummary view with the Customers table to retrieve the customer's
--first name and last name along with their order details.
select * from OrderSummary as os join Cutomers as c on os.CustomerID=c.CustomerID;

