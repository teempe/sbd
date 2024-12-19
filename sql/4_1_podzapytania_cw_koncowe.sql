use northwind;


-------------------------------------------------------------------------------
--Cw 1
-------------------------------------------------------------------------------

--1.Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki
--dostarczała firma United Package.
select 
    c.CompanyName, c.Phone
from 
    customers as c
join 
    Orders as o on c.CustomerID = o.CustomerID
join
    Shippers as s on o.ShipVia = s.ShipperID
where 
    s.CompanyName = 'United Package' and year(o.ShippedDate) = 1997;

--2.Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z 
--kategorii Confections.
select distinct
    c.CompanyName, c.Phone
from 
    customers as c
join 
    Orders as o on c.CustomerID = o.CustomerID
join 
    [Order Details] as od on o.OrderID = od.OrderID
join 
    Products as p on od.ProductID = p.ProductID
join 
    Categories as cat on p.CategoryID = cat.CategoryID
where 
    cat.CategoryName = 'Confections';

--3.Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produktów z
--kategorii Confections.
select
    c.CompanyName, c.Phone
from 
    Orders as o 
join 
    [Order Details] as od on o.OrderID = od.OrderID
join 
    Products as p on od.ProductID = p.ProductID
join 
    Categories as cat on p.CategoryID = cat.CategoryID and cat.CategoryName = 'Confections'
right join 
    customers as c on c.CustomerID = o.CustomerID
where 
    o.OrderID is null;


select
    c.CompanyName, c.Phone
from 
    Customers as c
where 
    c.CustomerID not in (
        select distinct 
            o.CustomerID
        from 
            Orders as o
        join 
            [Order Details] as od on o.OrderID = od.OrderID
        join 
            Products as p on od.ProductID = p.ProductID
        join 
            Categories as cat on p.CategoryID = cat.CategoryID and cat.CategoryName = 'Confections'
    );    


-------------------------------------------------------------------------------
--Cw 2
-------------------------------------------------------------------------------

--1.Dla każdego produktu podaj maksymalną liczbę zamówionych jednostek
select 
    p.ProductID, p.ProductName, max(od.Quantity) as max_quantity
from 
    Products as p 
join
    [Order Details] as od on p.ProductID = od.ProductID
group by 
    p.ProductID, p.ProductName;

--2.Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu
select 
    *
from 
    Products as p
where
    p.UnitPrice < (
        select
            avg(UnitPrice)
        from 
            Products
    );

--3.Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu
--danej kategorii
select 
    *
from 
    Products as p
where
    p.UnitPrice < (
        select
            avg(UnitPrice)
        from 
            Products as p_sub
        where 
            p_sub.CategoryID = p.CategoryID
    );


-------------------------------------------------------------------------------
--Cw 3
-------------------------------------------------------------------------------

--1.Dla każdego produktu podaj jego nazwę, cenę, średnią cenę wszystkich
--produktów oraz różnicę między ceną produktu a średnią ceną wszystkich
--produktów
select 
    ProductName,
    UnitPrice,
    (select avg(UnitPrice) from Products) as avg_price,
    UnitPrice - (select avg(UnitPrice) from Products) as diff
from 
    Products;

--2.Dla każdego produktu podaj jego nazwę kategorii, nazwę produktu, cenę, 
--średnią cenę wszystkich produktów danej kategorii oraz różnicę między ceną
--produktu a średnią ceną wszystkich produktów danej kategorii
select
    cat.CategoryName,
    p.ProductName,
    p.UnitPrice,
    (select avg(UnitPrice) from Products as p_in where p_in.CategoryID = p.CategoryID) as avg_unit_price,
    p.UnitPrice - (select avg(UnitPrice) from Products as p_in where p_in.CategoryID = p.CategoryID) as diff
from 
    Products as p
join 
    Categories as cat on p.CategoryID = cat.CategoryID;


-------------------------------------------------------------------------------
--Cw 4
-------------------------------------------------------------------------------

--1.Podaj łączną wartość zamówienia o numerze 1025 (uwzględnij cenę za przesyłkę)
select
    o.OrderID,
    sum(od.Quantity * od.UnitPrice * (1 - Discount)) - o.Freight as price
from 
    Orders as o
join 
    [Order Details] as od on o.OrderID = od.OrderID
where 
    o.OrderId = 10250
group by 
    o.OrderID, o.Freight;

--2.Podaj łączną wartość zamówień każdego zamówienia (uwzględnij cenę za
--przesyłkę)
select
    o.OrderID,
    sum(od.Quantity * od.UnitPrice * (1 - Discount)) - o.Freight as price
from 
    Orders as o
join 
    [Order Details] as od on o.OrderID = od.OrderID
group by 
    o.OrderID, o.Freight;

--3.Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, 
--jeśli tak to pokaż ich dane adresowe
select distinct
    c.CompanyName,
    c.Address,
    c.City,
    c.PostalCode,
    c.Country
from
    Customers as c
left join
    Orders as o on c.CustomerID = o.CustomerID and year(o.OrderDate) = 1997
where 
    o.OrderID is null;

select distinct
    c.CompanyName,
    c.Address,
    c.City,
    c.PostalCode,
    c.Country
from
    Customers as c
where
    c.CustomerID not in (
        select CustomerID from Orders where year(OrderDate) = 1997
    );

--4.Podaj produkty kupowane przez więcej niż jednego klienta
select
    ProductID, ProductName
from 
    Products
where 
    ProductID in (
        select
            od.ProductID--, count(distinct o.CustomerID)
        from 
            Orders as o
        join 
            [Order Details] as od on o.OrderID = od.OrderID
        group by 
            od.ProductID
        having 
            count(distinct o.CustomerID) > 1);

select 
    p.ProductID, p.ProductName
from 
    Products as p
join 
    [Order Details] as od on p.ProductID = od.ProductID
join
    Orders as o on od.OrderID = o.OrderID
group by 
    p.ProductID, p.ProductName
having 
    count(distinct o.CustomerID) > 1;


-------------------------------------------------------------------------------
--Cw 5
-------------------------------------------------------------------------------

--1.Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
--obsłużonych przez tego pracownika (przy obliczaniu wartości zamówień
--uwzględnij cenę za przesyłkę
select 
    e.EmployeeID, 
    e.FirstName, 
    e.LastName, 
    round(sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) + sum(o.Freight), 2) as price
from
    Employees as e
join 
    Orders as o on e.EmployeeID = o.EmployeeID
join 
    [Order Details] as od on o.OrderID = od.OrderID
group by 
    e.EmployeeID, e.FirstName, e.LastName
order by 
    e.EmployeeID;

--2.Który z pracowników obsłużył najaktywniejszy (obsłużył zamówienia o
--największej wartości) w 1997r, podaj imię i nazwisko takiego pracownika
select top 1
    e.EmployeeID, 
    e.FirstName, 
    e.LastName, 
    round(sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) + sum(o.Freight), 2) as price
from
    Employees as e
join 
    Orders as o on e.EmployeeID = o.EmployeeID and year(o.OrderDate) = 1997
join 
    [Order Details] as od on o.OrderID = od.OrderID
group by 
    e.EmployeeID, e.FirstName, e.LastName
order by 
    price desc;

--3.Ogranicz wynik z pkt 1 tylko do pracowników

--a) którzy mają podwładnych
select 
    e.EmployeeID, 
    e.FirstName, 
    e.LastName, 
    round(sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) + sum(o.Freight), 2) as price
from
    Employees as e
join 
    Orders as o on e.EmployeeID = o.EmployeeID
join 
    [Order Details] as od on o.OrderID = od.OrderID
where 
    e.EmployeeID in (
        select distinct
            sup.EmployeeID
        from 
            Employees as sup
        join 
            Employees as sub on sup.EmployeeID = sub.ReportsTo
    )
group by 
    e.EmployeeID, e.FirstName, e.LastName
order by 
    e.EmployeeID;

--b) którzy nie mają podwładnych
select 
    e.EmployeeID, 
    e.FirstName, 
    e.LastName, 
    round(sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) + sum(o.Freight), 2) as price
from
    Employees as e
join 
    Orders as o on e.EmployeeID = o.EmployeeID
join 
    [Order Details] as od on o.OrderID = od.OrderID
where 
    e.EmployeeID not in (
        select distinct
            sup.EmployeeID
        from 
            Employees as sup
        join 
            Employees as sub on sup.EmployeeID = sub.ReportsTo
    )
group by 
    e.EmployeeID, e.FirstName, e.LastName
order by 
    e.EmployeeID;

--4.Zmodyfikuj rozwiązania z pkt 3 tak aby dla pracowników pokazać jeszcze datę
--ostatnio obsłużonego zamówienia
select 
    e.EmployeeID, 
    e.FirstName, 
    e.LastName, 
    round(sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) + sum(o.Freight), 2) as price,
    max(o.OrderDate) as date
from
    Employees as e
join 
    Orders as o on e.EmployeeID = o.EmployeeID
join 
    [Order Details] as od on o.OrderID = od.OrderID
group by 
    e.EmployeeID, e.FirstName, e.LastName
order by 
    e.EmployeeID;
