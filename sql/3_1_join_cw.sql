use northwind;

--------------------------------------------------------------------------------
--Ćwiczenie 1.
--------------------------------------------------------------------------------

--1. Dla każdego zamówienia podaj łączną liczbę zamówionych jednostek towaru 
--oraz nazwę klienta.
select 
    od.OrderID, c.CompanyName, sum(od.Quantity) as quantity 
from 
    [Order Details] as od
join
    Orders as o on od.OrderID = o.OrderID
join
    Customers as c on o.CustomerID = c.CustomerID
group by 
    od.OrderID, c.CompanyName;

--2. Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla 
--których łączna liczbę zamówionych jednostek jest większa niż 250
select 
    od.OrderID, c.CompanyName, sum(od.Quantity) as quantity 
from 
    [Order Details] as od
join
    Orders as o on od.OrderID = o.OrderID
join
    Customers as c on o.CustomerID = c.CustomerID
group by 
    od.OrderID, c.CompanyName
having 
    sum(od.Quantity) > 250;

--3. Dla każdego zamówienia podaj łączną wartość tego zamówienia oraz nazwę 
--klienta.
select 
    od.OrderID, c.CompanyName, sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) as order_total
from 
    [Order Details] as od
join
    Orders as o on od.OrderID = o.OrderID
join
    Customers as c on o.CustomerID = c.CustomerID
group by 
    od.OrderID, c.CompanyName;

--4. Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla 
--których łączna liczba jednostek jest większa niż 250.
select 
    od.OrderID, c.CompanyName, sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) as order_total
from 
    [Order Details] as od
join
    Orders as o on od.OrderID = o.OrderID
join
    Customers as c on o.CustomerID = c.CustomerID
group by 
    od.OrderID, c.CompanyName
having 
    sum(od.Quantity) > 250;

--5. Zmodyfikuj poprzedni przykład tak żeby dodać jeszcze imię i nazwisko 
--pracownika obsługującego zamówień
select 
    od.OrderID, c.CompanyName, 
    sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) as order_total,
    max(concat(e.FirstName, ' ', e.LastName)) as employee
from 
    [Order Details] as od
join
    Orders as o on od.OrderID = o.OrderID
join
    Customers as c on o.CustomerID = c.CustomerID
join 
    Employees as e on o.EmployeeID = e.EmployeeID
group by 
    od.OrderID, c.CompanyName
having 
    sum(od.Quantity) > 250;

--------------------------------------------------------------------------------
--Ćwiczenie 2.
--------------------------------------------------------------------------------

--1. Dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych 
--przez klientów jednostek towarów z tej kategorii.
select 
    cat.CategoryName, 
    sum(od.Quantity) as total_quantity
from 
    categories as cat
join 
    Products as p on cat.CategoryID = p.CategoryID
join
    [Order Details] as od on p.ProductID = od.ProductID
group by 
    cat.CategoryName;

--2. Dla każdej kategorii produktu (nazwa), podaj łączną wartość zamówionych 
--przez klientów jednostek towarów z tek kategorii.
select 
    cat.CategoryName, 
    sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) as total_price
from 
    categories as cat
join 
    Products as p on cat.CategoryID = p.CategoryID
join
    [Order Details] as od on p.ProductID = od.ProductID
group by 
    cat.CategoryName;

--3. Posortuj wyniki w zapytaniu z poprzedniego punktu wg:
--a) łącznej wartości zamówień
select 
    cat.CategoryName, 
    sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) as total_price
from 
    categories as cat
join 
    Products as p on cat.CategoryID = p.CategoryID
join
    [Order Details] as od on p.ProductID = od.ProductID
group by 
    cat.CategoryName
order by
    total_price;

--b) łącznej liczby zamówionych przez klientów jednostek towarów.
select 
    cat.CategoryName, 
    sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) as total_price
from 
    categories as cat
join 
    Products as p on cat.CategoryID = p.CategoryID
join
    [Order Details] as od on p.ProductID = od.ProductID
group by 
    cat.CategoryName
order by
    sum(od.Quantity);

--4. Dla każdego zamówienia podaj jego wartość uwzględniając opłatę za przesyłkę
select 
    od.OrderID,
    sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) - max(o.Freight) as total_price
from 
    [Order Details] as od
join 
    Orders as o on od.OrderID = o.OrderID
group by 
    od.OrderID;

--------------------------------------------------------------------------------
--Ćwiczenie 3.
--------------------------------------------------------------------------------

--1. Dla każdego przewoźnika (nazwa) podaj liczbę zamówień które przewieźli w 
--1997r
select 
    s.CompanyName, count(o.OrderID) as orders
from 
    Orders as o
join
    Shippers as s on o.ShipVia = s.ShipperID
where 
    year(o.ShippedDate) = 1997
group by 
    s.CompanyName;

--2. Który z przewoźników był najaktywniejszy (przewiózł największą liczbę 
--zamówień) w 1997r, podaj nazwę tego przewoźnika
select top 1
    s.CompanyName
from 
    Orders as o
join
    Shippers as s on o.ShipVia = s.ShipperID
where 
    year(o.ShippedDate) = 1997
group by 
    s.CompanyName
order by 
    count(o.OrderID) desc;

--3. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
--obsłużonych przez tego pracownika
select 
    e.FirstName, 
    e.LastName, 
    round(sum(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) as total
from 
    Employees as e
join 
    Orders as o on e.EmployeeID = o.EmployeeID
join 
    [Order Details] as od on o.OrderID = od.OrderID
group by 
    e.LastName, e.FirstName;

--4. Który z pracowników obsłużył największą liczbę zamówień w 1997r, podaj 
--imię i nazwisko takiego pracownika
select top 1
    e.FirstName, e.LastName
from 
    Employees as e
join
    Orders as o on e.EmployeeID = o.EmployeeID
where 
    year(o.OrderDate) = 1997
group by 
    e.LastName, e.FirstName
order by 
    count(o.OrderID) desc;

--5. Który z pracowników obsłużył najaktywniejszy (obsłużył zamówienia o 
--największej wartości) w 1997r, podaj imię i nazwisko takiego pracownika
select top 1
    e.FirstName, 
    e.LastName, 
    round(sum(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) as total
from 
    Employees as e
join 
    Orders as o on e.EmployeeID = o.EmployeeID
join 
    [Order Details] as od on o.OrderID = od.OrderID
group by 
    e.LastName, e.FirstName
order by 
    total desc;


--------------------------------------------------------------------------------
--Ćwiczenie 4.
--------------------------------------------------------------------------------

--1. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
--obsłużonych przez tego pracownika
select 
    e.FirstName, 
    e.LastName, 
    round(sum(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) as total
from 
    Employees as e
join 
    Orders as o on e.EmployeeID = o.EmployeeID
join 
    [Order Details] as od on o.OrderID = od.OrderID
group by 
    e.LastName, e.FirstName;

--Ogranicz wynik tylko do pracowników
--a) którzy mają podwładnych
select 
    sup.FirstName, 
    sup.LastName, 
    round(sum(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) as total
from 
    Employees as e
join 
    Orders as o on e.EmployeeID = o.EmployeeID
join 
    [Order Details] as od on o.OrderID = od.OrderID
join
    Employees as sup on e.ReportsTo = sup.EmployeeID
group by 
    sup.LastName, sup.FirstName;

--b) którzy nie mają podwładnych
select 
    e.FirstName, 
    e.LastName, 
    round(sum(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) as total
from 
    Employees as e
join 
    Orders as o on e.EmployeeID = o.EmployeeID
join 
    [Order Details] as od on o.OrderID = od.OrderID
left join
    Employees as sub on e.EmployeeID = sub.ReportsTo
where 
    sub.EmployeeID is null
group by 
    e.LastName, e.FirstName;
