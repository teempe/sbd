--------------------------------------------------------------------------------
--Ćwiczenie 1
--------------------------------------------------------------------------------
use northwind;


--1. Podaj łączną wartość zamówienia o numerze 10250 (uwzględnij cenę za przesyłkę)
select 
    o.OrderID,
    round(sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) + o.Freight, 2) as price
from 
    Orders as o 
join 
    [Order Details] as od on o.OrderID = od.OrderID
where 
    o.OrderID = 10250
group by 
    o.OrderID, o.Freight;

--2. Podaj łączną wartość każdego zamówienia (uwzględnij cenę za przesyłkę)
select 
    o.OrderID,
    round(sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) + o.Freight, 2) as price
from 
    Orders as o 
join 
    [Order Details] as od on o.OrderID = od.OrderID
group by 
    o.OrderID, o.Freight;

--3. Dla każdego produktu podaj maksymalną wartość zakupu tego produktu
select 
    p.ProductID,
    p.ProductName,
    round(max(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) as max_price
from 
    Products as p
join 
    [Order Details] as od on p.ProductID = od.ProductID
group by 
    p.ProductID, p.ProductName;

--4. Dla każdego produktu podaj maksymalną wartość zakupu tego produktu w 1997r
select 
    p.ProductID, 
    p.ProductName,
    round(max(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) as max_price
from 
    Products as p
join
    [Order Details] as od on p.ProductID = od.ProductID
join 
    Orders as o on od.OrderID = o.OrderID and year(o.OrderDate) = 1997
group by 
    p.ProductID, p.ProductName;


--------------------------------------------------------------------------------
--Ćwiczenie 2
--------------------------------------------------------------------------------

--1. Dla każdego klienta podaj łączną wartość jego zamówień (bez opłaty za 
--przesyłkę) z 1996r
select 
    c.CustomerID, 
    c.CompanyName,
    round(sum(od.Quantity * od.UnitPrice * (1 - od.Discount)), 2) as total_price
from 
    Customers as c
join 
    Orders as o on c.CustomerID = o.CustomerID and year(o.OrderDate) = 1996
join 
    [Order Details] as od on o.OrderID = od.OrderID
group by 
    c.CustomerID, c.CompanyName;

--2. Dla każdego klienta podaj łączną wartość jego zamówień (uwzględnij opłatę
--za przesyłkę) z 1996r
select 
    c.CustomerID, c.CompanyName, 
    round(sum(od.Quantity * od.UnitPrice * (1 - od.Discount)) + o.Freight, 2) as price
from 
    Customers as c
join 
    Orders as o on c.CustomerID = o.CustomerID and year(o.OrderDate) = 1996
join 
    [Order Details] as od on o.OrderID = od.OrderID
group by
    c.CustomerID, c.CompanyName, o.Freight;

--3. Dla każdego klienta podaj maksymalną wartość zamówienia złożonego przez tego
--klienta w 1997r
select  
    c.CustomerID, c.CompanyName,
    max(od.Quantity * od.UnitPrice * (1 - od.Discount)) as max_price
from 
    Customers as c
join 
    Orders as o on c.CustomerID = o.CustomerID and year(o.OrderDate) = 1997
join 
    [Order Details] as od on o.OrderID = od.OrderID
group by 
    c.CustomerID, c.CompanyName;


--------------------------------------------------------------------------------
--Ćwiczenie 3
--------------------------------------------------------------------------------
use library;

--1. Dla każdego dorosłego członka biblioteki podaj jego imię, nazwisko oraz
--liczbę jego dzieci.
select 
    a.member_no,
    m.firstname,
    m.lastname,
    count(j.member_no) as children
from 
    adult as a
join
    member as m on a.member_no = m.member_no
left join 
    juvenile as j on a.member_no = j.adult_member_no
group by 
    a.member_no, m.firstname, m.lastname
order by 
    a.member_no;

--2. Dla każdego dorosłego członka biblioteki podaj jego imię, nazwisko, liczbę
--jego dzieci, liczbę zarezerwowanych książek oraz liczbę wypożyczonych książek.
select 
    a.member_no,
    m.firstname,
    m.lastname,
    count(j.member_no) as children,
    count(r.isbn) as reserved_books,
    count(l.copy_no) as loaned_books
from 
    adult as a
join
    member as m on a.member_no = m.member_no
left join 
    juvenile as j on a.member_no = j.adult_member_no
left join
    reservation as r on a.member_no = r.member_no
left join 
    loan as l on a.member_no = l.member_no
group by 
    a.member_no, m.firstname, m.lastname
order by 
    a.member_no;

--3. Dla każdego dorosłego członka biblioteki podaj jego imię, nazwisko, liczbę
--jego dzieci, oraz liczbę książek zarezerwowanych i wypożyczonych przez niego i
--jego dzieci.
with kids_books as (
    select 
        count(r.isbn) as reserved, count(l.copy_no) as loaned, j.adult_member_no
    from 
        juvenile as j
    left join
        reservation as r on j.member_no = r.member_no
    left join 
        loan as l on j.member_no = l.member_no
    group by 
        j.adult_member_no
)

select 
    a.member_no,
    m.firstname,
    m.lastname,
    count(j.member_no) as children,
    count(r.isbn) as reserved_books,
    count(l.copy_no) as loaned_books,
    coalesce(max(kb.reserved), 0) as reserved_by_children,
    coalesce(max(kb.loaned), 0) as loaned_by_children
from 
    adult as a
join
    member as m on a.member_no = m.member_no
left join 
    juvenile as j on a.member_no = j.adult_member_no
left join
    reservation as r on a.member_no = r.member_no
left join 
    loan as l on a.member_no = l.member_no
left join 
    kids_books as kb on a.member_no = kb.adult_member_no
group by 
    a.member_no, m.firstname, m.lastname
order by 
    a.member_no;

--4. Dla każdego tytułu książki podaj ile razy ten tytuł był wypożyczany w 2001r
select
    lh.title_no, t.title, t.author, count(*)
from 
    loanhist as lh
join 
    title as t on lh.title_no = t.title_no
where 
    year(lh.out_date) = 2001
group by 
    lh.title_no, t.title, t.author;

--5. Dla każdego tytułu książki podaj ile razy ten tytuł był wypożyczany w 2002r
select
    lh.title_no, t.title, t.author, count(*)
from 
    loanhist as lh
join 
    title as t on lh.title_no = t.title_no
where 
    year(lh.out_date) = 2002
group by 
    lh.title_no, t.title, t.author;


--------------------------------------------------------------------------------
--Ćwiczenie 4
--------------------------------------------------------------------------------
use northwind;

--1. Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, 
--jeśli tak to pokaż ich dane adresowe
select 
    CompanyName, Address, PostalCode, City, Country
from 
    Customers
where 
    CustomerID not in (
        select distinct 
            c.CustomerID
        from 
            Customers as c
        join
            Orders as o on c.CustomerID = o.CustomerID and year(o.OrderDate) = 1997
    );

select distinct 
    CompanyName, Address, PostalCode, City, Country
from 
    Customers as c
left join
    Orders as o on c.CustomerID = o.CustomerID and year(o.OrderDate) = 1997
where
    o.OrderID is null;

select 
    CompanyName, Address, PostalCode, City, Country
from 
    Customers as c
where 
    not exists (
        select * 
        from Orders as o 
        where c.CustomerID = o.CustomerID and year(o.OrderDate) = 1997
    );

--2. Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki
--dostarczała firma United Package.
select 
    c.CompanyName, c.Phone
from 
    Customers as c
join 
    Orders as o on c.CustomerID = o.CustomerID and year(o.ShippedDate) = 1997
join 
    Shippers as s on o.ShipVia = s.ShipperID and s.CompanyName = 'United Package';

--3. Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłek 
--nie dostarczała firma United Package.
select 
    c.CompanyName, c.Phone
from 
    Customers as c
join 
    Orders as o on c.CustomerID = o.CustomerID and year(o.ShippedDate) = 1997
left join 
    Shippers as s on o.ShipVia = s.ShipperID and s.CompanyName = 'United Package'
where
    s.ShipperID is null;

--4. Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z 
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

--5. Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produktów z 
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

--6. Wybierz nazwy i numery telefonów klientów, którzy w 1997r nie kupowali 
--produktów z kategorii Confections.
select
    c.CompanyName, c.Phone
from 
    Orders as o 
join 
    [Order Details] as od on o.OrderID = od.OrderID
join 
    Products as p on od.ProductID = p.ProductID
join 
    Categories as cat on p.CategoryID = cat.CategoryID and cat.CategoryName = 'Confections' and year(o.OrderDate) = 1997
right join 
    customers as c on c.CustomerID = o.CustomerID
where 
    o.OrderID is null;


--------------------------------------------------------------------------------
--Ćwiczenie 5
--------------------------------------------------------------------------------

--1. Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu
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

--2. Podaj wszystkie produkty których cena jest mniejsza niż średnia cena 
--produktu danej kategorii
select 
    p.ProductName, p.UnitPrice
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

--3. Dla każdego produktu podaj jego nazwę, cenę, średnią cenę wszystkich produktów
--oraz różnicę między ceną produktu a średnią ceną wszystkich produktów
select 
    ProductName,
    UnitPrice,
    (select avg(UnitPrice) from Products) as avg_price,
    UnitPrice - (select avg(UnitPrice) from Products) as diff
from 
    Products;

--4. Dla każdego produktu podaj jego nazwę kategorii, nazwę produktu, cenę, 
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


--------------------------------------------------------------------------------
--Ćwiczenie 6
--------------------------------------------------------------------------------

--1. Podaj produkty kupowane przez więcej niż jednego klienta
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

--2. Podaj produkty kupowane w 1997r przez więcej niż jednego klienta
select 
    p.ProductID, p.ProductName
from 
    Products as p
join 
    [Order Details] as od on p.ProductID = od.ProductID
join
    Orders as o on od.OrderID = o.OrderID and year(o.OrderDate) = 1997
group by 
    p.ProductID, p.ProductName
having 
    count(distinct o.CustomerID) > 1;

--3. Podaj nazwy klientów którzy w 1997r kupili co najmniej dwa różne produkty z 
--kategorii 'Confections'
select 
    c.CustomerID, c.CompanyName
from 
    Customers as c
join 
    Orders as o on c.CustomerID = o.CustomerID and year(OrderDate) = 1997
join 
    [Order Details] as od on o.OrderID = od.OrderID
join
    Products as p on od.ProductID = p.ProductID
join 
    Categories as cat on p.CategoryID = cat.CategoryID and cat.CategoryName = 'Confections'
group by    
    c.CustomerID, c.CompanyName
having 
    count(distinct p.ProductID) > 1;

--------------------------------------------------------------------------------
--Ćwiczenia 7
--------------------------------------------------------------------------------

--1. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
--obsłużonych przez tego pracownika, przy obliczaniu wartości zamówień uwzględnij
--cenę za przesyłkę
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

--2. Który z pracowników był najaktywniejszy (obsłużył zamówienia o największej
--wartości) w 1997r, podaj imię i nazwisko takiego pracownika
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

--3. Ogranicz wynik z pkt 1 tylko do pracowników
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

--4. Zmodyfikuj rozwiązania z pkt 3 tak aby dla pracowników pokazać jeszcze datę
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
