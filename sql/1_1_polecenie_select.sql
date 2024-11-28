USE northwind;

--------------------------------------------------------------------------------
--str 4
--Wybór kolumn - ćwiczenia
--------------------------------------------------------------------------------

--1. Wybierz nazwy i adresy wszystkich klientów
select
    CompanyName, Address
from
    Customers;

--2. Wybierz nazwiska i numery telefonów pracowników
select
    LastName, HomePhone
from
    Employees;

--3. Wybierz nazwy i ceny produktów
select
    ProductName, UnitPrice
from 
    Products;

--4. Pokaż wszystkie kategorie produktów (nazwy i opisy)
select
    CategoryName, Description
from 
    Categories;

--5. Pokaż nazwy i adresy stron www dostawców
select 
    CompanyName, HomePage
from 
    Suppliers;

--------------------------------------------------------------------------------
--str 9
--Wybór wierszy — ćwiczenia
--------------------------------------------------------------------------------

--1. Wybierz nazwy i adresy wszystkich klientów mających siedziby w Londynie
select 
    CompanyName, Address, PostalCode, City, Country
from 
    Customers
where 
    City = 'London';

--2. Wybierz nazwy i adresy wszystkich klientów mających siedziby we Francji lub
--w Hiszpanii
select 
    CompanyName, Address, PostalCode, City, Country
from 
    Customers
where 
    Country in ('France', 'Spain');

--3. Wybierz nazwy i ceny produktów o cenie jednostkowej pomiędzy 20.00 a 30.00
select 
    ProductName, UnitPrice
from 
    Products
where 
    UnitPrice between 20 and 30
order by 
    UnitPrice;

--4. Wybierz nazwy i ceny produktów z kategorii 'Meat/Poultry'
select 
    CategoryID 
from 
    Categories
where 
    CategoryName = 'Meat/Poultry';

select 
    ProductName, UnitPrice, CategoryID
from 
    Products
where
    CategoryID = 6;

--5. Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów
--dostarczanych przez firmę ‘Tokyo Traders’
select 
    SupplierID
from 
    Suppliers
where 
    CompanyName = 'Tokyo Traders';

select 
    ProductName, UnitsInStock, SupplierID
from 
    Products
where
    SupplierID = 4;

--6. Wybierz nazwy produktów których nie ma w magazynie
select 
    ProductName
from 
    Products
where 
    UnitsInStock = 0;

--------------------------------------------------------------------------------
--str 13
--Porównywanie napisów — ćwiczenia
--------------------------------------------------------------------------------

--1. Szukamy informacji o produktach sprzedawanych w butelkach (‘bottle’)
select 
    *
from 
    Products
where
    QuantityPerUnit like '%bottle%';

--2. Wyszukaj informacje o stanowisku pracowników, których nazwiska 
--zaczynają się na literę z zakresu od B do L
select 
    LastName, Title
from 
    Employees
where
    LastName like '[B-L]%';

--3. Wyszukaj informacje o stanowisku pracowników, których nazwiska 
--zaczynają się na literę B lub L
select 
    LastName, Title
from 
    Employees
where
    LastName like '[BL]%';

--4. Znajdź nazwy kategorii, które w opisie zawierają przecinek
select 
    *
from 
    Categories
where 
    Description like '%,%';

--5. Znajdź klientów, którzy w swojej nazwie mają w którymś miejscu słowo 'Store'
select 
    *
from 
    Customers
where 
    CompanyName like '%Store%';

--------------------------------------------------------------------------------
--str 17
--Zakres wartości — ćwiczenia
--------------------------------------------------------------------------------

--1. Szukamy informacji o produktach o cenach mniejszych niż 10 lub 
--większych niż 20
select 
    ProductName, UnitPrice
from 
    Products
where 
    UnitPrice not between 20 and 30
order by 
    UnitPrice;

--2. Wybierz nazwy i ceny produktów o cenie jednostkowej pomiędzy 20.00 a 30.00
select 
    ProductName, UnitPrice
from 
    Products
where 
    UnitPrice between 20 and 30
order by 
    UnitPrice;

--3. Wybierz zamówienia złożone w 1997 roku
select 
    *
from 
    Orders
where 
    year(OrderDate) = 1997;

--------------------------------------------------------------------------------
--str 20
--Ćwiczenie
--------------------------------------------------------------------------------

--Napisz instrukcję select tak aby wybrać numer zlecenia, datę zamówienia, numer
--klienta dla wszystkich niezrealizowanych jeszcze zleceń, dla których krajem 
--odbiorcy jest Argentyna
select 
    *
from 
    Orders
where 
    ShipCountry = 'Argentina' and
    ShippedDate is null;

--------------------------------------------------------------------------------
--str 24
--ORDER BY — ćwiczenia
--------------------------------------------------------------------------------

--1. Wybierz nazwy i kraje wszystkich klientów, wyniki posortuj według kraju, 
--w ramach danego kraju nazwy firm posortuj alfabetycznie
select 
    CompanyName, Country
from
    Customers
order by 
    Country, CompanyName;

--2. Wybierz nazwy i kraje wszystkich klientów mających siedziby we Francji lub 
--w Hiszpanii, wyniki posortuj według kraju, w ramach danego kraju nazwy firm 
--posortuj alfabetycznie
select 
    CompanyName, Country
from 
    Customers
where 
    Country in ('France', 'Spain')
order by 
    Country, CompanyName;

--3. Wybierz zamówienia złożone w 1997 r. Wynik po sortuj malejąco wg numeru
--miesiąca, a w ramach danego miesiąca rosnąco według ceny za przesyłkę
select 
    *
from 
    Orders
where 
    year(OrderDate) = 1997
order by
    month(OrderDate) desc, Freight asc;

--------------------------------------------------------------------------------
--str 33
--Ćwiczenie
--------------------------------------------------------------------------------

--1. Napisz polecenie, które oblicza wartość każdej pozycji zamówienia o numerze 
--10250
select 
    round(UnitPrice * Quantity * (1 - Discount), 2) as price
from 
    [Order Details]
where 
    OrderID = 10250;

--2. Napisz polecenie które dla każdego dostawcy (supplier) pokaże pojedynczą 
--kolumnę zawierającą nr telefonu i nr faksu w formacie (numer telefonu i faksu 
--mają być oddzielone przecinkiem)
select
    case 
        when Fax is null then Phone
        else concat(Phone, ', ', Fax)
    end as phone_and_fax
from 
    Suppliers;

select
    concat(Phone, ', ', isnull(Fax, '-')) as phone_and_fax
from 
    Suppliers;
