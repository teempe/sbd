use northwind;

--------------------------------------------------------------------------------
--str 7
--Ćwiczenie
--------------------------------------------------------------------------------

--1. Podaj liczbę produktów o cenach mniejszych niż 10 lub większych niż 20
select 
    count(*)
from 
    Products
where 
    UnitPrice not between 10 and 20;

--2. Podaj maksymalną cenę produktu dla produktów o cenach poniżej 20
select 
    max(UnitPrice)
from 
    Products
where 
    UnitPrice < 20;

--3. Podaj maksymalną i minimalną i średnią cenę produktu dla produktów o 
--produktach sprzedawanych w butelkach (‘bottle’)
select 
    max(UnitPrice) as max_unit_price,
    min(UnitPrice) as min_unit_price,
    avg(UnitPrice) as avg_unit_price
from 
    Products
where 
    QuantityPerUnit like '%bottle%';

--4. Wypisz informację o wszystkich produktach o cenie powyżej średniej
select 
    *
from 
    Products
where
    UnitPrice > (select avg(UnitPrice) from Products);

--5. Podaj sumę/wartość zamówienia o numerze 10250
select 
    sum(UnitPrice * Quantity * (1 - Discount)) as order_total
from 
    [Order Details]
where 
    OrderID = 10250;


--------------------------------------------------------------------------------
--str 12
--Ćwiczenia
--------------------------------------------------------------------------------

--1. Podaj maksymalną cenę zamawianego produktu dla każdego zamówienia
select 
    OrderID, max(UnitPrice) as max_price
from 
    [Order Details]
group by 
    OrderID;

--2. Posortuj zamówienia wg maksymalnej ceny produktu
select 
    OrderID, max(UnitPrice) as max_price
from 
    [Order Details]
group by 
    OrderID
order by 
    max_price;

--3. Podaj maksymalną i minimalną cenę zamawianego produktu dla każdego 
--zamówienia
select 
    OrderID, max(UnitPrice) as max_price, min(UnitPrice) as min_price
from 
    [Order Details]
group by 
    OrderID;

--4. Podaj liczbę zamówień dostarczanych przez poszczególnych spedytorów
--(przewoźników)
select 
    ShipVia, count(OrderID) as orders
from 
    Orders
group by
    ShipVia;

--5. Który ze spedytorów był najaktywniejszy w 1997 roku
select top 1
    ShipVia, count(OrderID) as orders
from 
    Orders
where 
    year(ShippedDate) = 1997
group by
    ShipVia
order by 
    orders desc;

--------------------------------------------------------------------------------
--str 16
--Ćwiczenia
--------------------------------------------------------------------------------

--1. Wyświetl zamówienia dla których liczba pozycji zamówienia jest większa 
--niż 5
select 
    OrderID, count(ProductID) as products
from 
    [Order Details]
group by
    OrderID
having 
    count(ProductID) > 5;

--2. Wyświetl klientów dla których w 1998 roku zrealizowano więcej niż 8 
--zamówień (wyniki posortuj malejąco wg łącznej kwoty za dostarczenie zamówień 
--dla każdego z klientów)
select 
    CustomerID, count(OrderID) as orders, sum(Freight) as freight_total
from 
    Orders
where 
    year(ShippedDate) = 1998
group by 
    CustomerID
having 
    count(OrderID) > 8
order by
    freight_total desc;
