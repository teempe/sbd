use northwind;

--------------------------------------------------------------------------------
--Ćwiczenie 1.
--------------------------------------------------------------------------------

--1. Napisz polecenie, które oblicza wartość sprzedaży dla każdego zamówienia w 
--tablicy order details i zwraca wynik posortowany w malejącej kolejności 
--(wg wartości sprzedaży).
select 
    OrderID, 
    cast(sum(UnitPrice * Quantity * (1 - Discount)) as decimal(8, 2)) as total_price
from 
    [Order Details]
group by 
    OrderID
order by 
    total_price desc;

--2. Zmodyfikuj zapytanie z poprzedniego punktu, tak aby zwracało pierwszych 10
--wierszy
select top 10
    OrderID, 
    cast(sum(UnitPrice * Quantity * (1 - Discount)) as decimal(8, 2)) as total_price
from 
    [Order Details]
group by 
    OrderID
order by 
    total_price desc;

--------------------------------------------------------------------------------
--Ćwiczenie 2.
--------------------------------------------------------------------------------

--1. Podaj liczbę zamówionych jednostek produktów dla produktów, dla których
--productid jest mniejszy niż 3
select 
    ProductID, sum(Quantity) as quantity
from 
    [Order Details]
where
    ProductID < 3
group by
    ProductID;

--2. Zmodyfikuj zapytanie z poprzedniego punktu, tak aby podawało liczbę 
--zamówionych jednostek produktu dla wszystkich produktów
select 
    ProductID, sum(Quantity) as quantity
from 
    [Order Details]
group by
    ProductID;

--3. Podaj nr zamówienia oraz wartość zamówienia, dla zamówień, dla których 
--łączna liczba zamawianych jednostek produktów jest większa niż 250
select 
    OrderID,
    cast(sum(UnitPrice * Quantity * (1 - Discount)) as decimal(8, 2)) as total_price,
    sum(Quantity) as quantity
from 
    [Order Details]
group by
    OrderID
having
    sum(Quantity) > 250;

--------------------------------------------------------------------------------
--Ćwiczenie 3.
--------------------------------------------------------------------------------

--1. Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień
select 
    EmployeeID, count(OrderID) as orders
from    
    orders
group by 
    EmployeeID;

--2. Dla każdego spedytora/przewoźnika podaj łączną wartość "opłat za przesyłkę"
--dla przewożonych przez niego zamówień
select 
    ShipVia,
    sum(Freight) as freight_total
from 
    Orders
group by 
    ShipVia;

--3. Dla każdego spedytora/przewoźnika podaj łączną wartość "opłat za przesyłkę"
--przewożonych przez niego zamówień w latach o 1996 do 1997
select 
    ShipVia,
    sum(Freight) as freight_total
from 
    Orders
where
    year(ShippedDate) between 1996 and 1997
group by 
    ShipVia;

--------------------------------------------------------------------------------
--Ćwiczenie 4.
--------------------------------------------------------------------------------

--1. Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień z
--podziałem na lata i miesiące
select 
    EmployeeID,
    year(OrderDate) as year,
    month(OrderDate) as month,
    count(OrderID) as orders
from 
    Orders
group by 
    EmployeeID, year(OrderDate), month(OrderDate)
order by 
    EmployeeID, year, month;

--2. Dla każdej kategorii podaj maksymalną i minimalną cenę produktu w tej 
--kategorii
select 
    CategoryID, 
    max(UnitPrice) as max_price, 
    min(UnitPrice) as min_price
from    
    Products
group by 
    CategoryID;
