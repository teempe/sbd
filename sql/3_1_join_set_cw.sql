use northwind;


--------------------------------------------------------------------------------
--Ćwiczenie 1
--------------------------------------------------------------------------------

--1. Dla każdego zamówienia podaj łączną liczbę zamówionych jednostek towaru 
--oraz nazwę klienta.
select 
    od.OrderID, 
    sum(od.Quantity) as quantity,
    c.CompanyName as customer
from
    orders as o
join 
    [Order Details] as od on o.OrderID = od.OrderID
join 
    Customers as c on o.CustomerID = c.CustomerID
group by 
    od.OrderID, c.CompanyName
order by 
    od.OrderID;

--2. Dla każdego zamówienia podaj łączną wartość zamówionych produktów (wartość
--zamówienia bez opłaty za przesyłkę) oraz nazwę klienta.
select 
    od.OrderID,
    round(sum(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) as total_price,
    c.CompanyName as customer
from 
    [Order Details] as od 
join 
    Orders as o on od.OrderID = o.OrderID
join 
    Customers as c on o.CustomerID = c.CustomerID
group by 
    od.OrderID, c.CompanyName
order by 
    od.OrderID;

--3. Dla każdego zamówienia podaj łączną wartość tego zamówienia (wartość
--zamówienia wraz z opłatą za przesyłkę) oraz nazwę klienta.
select 
    od.OrderID,
    round(sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) - o.Freight, 2) as total_price,
    c.CompanyName as customer
from 
    [Order Details] as od 
join 
    Orders as o on od.OrderID = o.OrderID
join 
    Customers as c on o.CustomerID = c.CustomerID
group by 
    od.OrderID, c.CompanyName, o.Freight
order by 
    od.OrderID;

--4. Zmodyfikuj poprzednie przykłady tak żeby dodać jeszcze imię i nazwisko
--pracownika obsługującego zamówienie
select 
    od.OrderID,
    round(sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) - o.Freight, 2) as total_price,
    c.CompanyName as customer,
    concat(e.FirstName, ' ', e.LastName) as employee_name
from 
    [Order Details] as od 
join 
    Orders as o on od.OrderID = o.OrderID
join 
    Customers as c on o.CustomerID = c.CustomerID
join 
    Employees as e on o.EmployeeID = e.EmployeeID
group by 
    od.OrderID, c.CompanyName, o.Freight, concat(e.FirstName, ' ', e.LastName)
order by 
    od.OrderID;

--------------------------------------------------------------------------------
--Ćwiczenie 2
--------------------------------------------------------------------------------

--1. Podaj nazwy przewoźników, którzy w marcu 1998 przewozili produkty z 
--kategorii 'Meat/Poultry'
select distinct
    s.CompanyName
from 
    Shippers as s
join 
    Orders as o on s.ShipperID = o.ShipVia and year(o.ShippedDate) = 1997 and month(o.ShippedDate) = 3
join 
    [Order Details] as od on o.OrderID = od.OrderID
join 
    Products as p on od.ProductID = p.ProductID
join 
    Categories as cat on p.CategoryID = cat.CategoryID and cat.CategoryName = 'Meat/Poultry'

--2. Podaj nazwy przewoźników, którzy w marcu 1997r nie przewozili produktów z
--kategorii 'Meat/Poultry'
select
    s.CompanyName
from 
    Shippers as s

except

select
    s.CompanyName
from 
    Shippers as s
join 
    Orders as o on s.ShipperID = o.ShipVia and year(o.ShippedDate) = 1997 and month(o.ShippedDate) = 3
join 
    [Order Details] as od on o.OrderID = od.OrderID
join 
    Products as p on od.ProductID = p.ProductID
join 
    Categories as cat on p.CategoryID = cat.CategoryID and cat.CategoryName = 'Meat/Poultry';

--3. Dla każdego przewoźnika podaj wartość produktów z kategorii 'Meat/Poultry' 
--które ten przewoźnik przewiózł w marcu 1997
select
    s.ShipperID, s.CompanyName, sum(od.Quantity * od.Quantity) as value
from 
    Shippers as s
join 
    Orders as o on s.ShipperID = o.ShipVia and year(o.ShippedDate) = 1997 and month(o.ShippedDate) = 3
join 
    [Order Details] as od on o.OrderID = od.OrderID
join 
    Products as p on od.ProductID = p.ProductID
join 
    Categories as cat on p.CategoryID = cat.CategoryID and cat.CategoryName = 'Meat/Poultry'
group by 
    s.ShipperID, s.CompanyName;

--------------------------------------------------------------------------------
--Ćwiczenie 3
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

--2. Dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych w 
--1997r jednostek towarów z tej kategorii.
select 
    cat.CategoryName, 
    sum(od.Quantity) as total_quantity
from 
    categories as cat
join 
    Products as p on cat.CategoryID = p.CategoryID
join
    [Order Details] as od on p.ProductID = od.ProductID
join 
    Orders as o on od.OrderID = o.OrderID and year(o.OrderDate) = 1997
group by 
    cat.CategoryName;

--3. Dla każdej kategorii produktu (nazwa), podaj łączną wartość zamówionych 
--towarów z tej kategorii.
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

--------------------------------------------------------------------------------
--Ćwiczenie 4
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

--3. Dla każdego przewoźnika podaj łączną wartość "opłat za przesyłkę" 
--przewożonych przez niego zamówień od '1998-05-03' do '1998-05-29'
select 
    s.CompanyName, 
    SUM(o.Freight) as total_freight
from 
    Orders o
join 
    Shippers s on o.ShipVia = s.ShipperID
where 
    o.OrderDate between '1998-05-03' and '1998-05-29'
group by 
    s.CompanyName;

--4. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
--obsłużonych przez tego pracownika w maju 1996
select 
    concat(e.FirstName, ' ', e.LastName) as employee,
    round(sum(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) as total_price
from 
    Employees as e
join 
    Orders as o on e.EmployeeID = o.EmployeeID and year(o.OrderDate) = 1996 and month(o.OrderDate) = 5
join
    [Order Details] as od on o.OrderID = od.OrderID
group by 
    concat(e.FirstName, ' ', e.LastName);

--5. Który z pracowników obsłużył największą liczbę zamówień w 1996r, podaj 
--imię i nazwisko takiego pracownika
select top 1
    concat(e.FirstName, ' ', e.LastName) as employee
from 
    Employees as e
join
    Orders as o on e.EmployeeID = o.EmployeeID
where 
    year(o.OrderDate) = 1997
group by 
    concat(e.FirstName, ' ', e.LastName)
order by 
    count(o.OrderID) desc;

--6. Który z pracowników był najaktywniejszy (obsłużył zamówienia o największej
--wartości) w 1996r, podaj imię i nazwisko takiego pracownika
select top 1
    concat(e.FirstName, ' ', e.LastName) as employee,
    round(sum(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) as total
from 
    Employees as e
join 
    Orders as o on e.EmployeeID = o.EmployeeID
join 
    [Order Details] as od on o.OrderID = od.OrderID
group by 
    concat(e.FirstName, ' ', e.LastName)
order by 
    total desc;

--------------------------------------------------------------------------------
--Ćwiczenie 5
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

--2. Napisz polecenie, które wyświetla klientów z Francji którzy w 1998r złożyli
--więcej niż dwa zamówienia oraz klientów z Niemiec którzy w 1997r złożyli 
--więcej niż trzy zamówienia
-- select
--     c.CustomerID, c.CompanyName, c.Country, count(o.OrderID) as orders
-- from 
--     Customers as c
-- join 
--     Orders as o on c.CustomerID = o.CustomerID and year(o.OrderDate) = 1998
-- where 
--     c.Country = 'France'
-- group by 
--     c.CustomerID, c.CompanyName, c.Country
-- having 
--     count(o.OrderID) > 2;

-- select
--     c.CustomerID, c.CompanyName, c.Country, count(o.OrderID) as orders
-- from 
--     Customers as c
-- join 
--     Orders as o on c.CustomerID = o.CustomerID and year(o.OrderDate) = 1997
-- where 
--     c.Country = 'Germany'
-- group by 
--     c.CustomerID, c.CompanyName, c.Country
-- having 
--     count(o.OrderID) > 3;

select
    c.CustomerID, c.CompanyName, c.Country, count(o.OrderID) as orders
from 
    Customers as c
join 
    Orders as o on c.CustomerID = o.CustomerID
where 
    c.Country = 'Germany' or c.Country = 'France'
group by 
    c.CustomerID, c.CompanyName, c.Country, year(o.OrderDate)
having 
    count(o.OrderID) > 3 and c.Country = 'Germany' and year(o.OrderDate) = 1997 
    or 
    count(o.OrderID) > 2 and c.Country = 'France' and year(o.OrderDate) = 1998;
