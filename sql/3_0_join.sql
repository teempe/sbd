--------------------------------------------------------------------------------
--str 14
--Ćwiczenie
--------------------------------------------------------------------------------
use northwind;

--1.Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej
--pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy
select 
    p.ProductID, p.ProductName, p.UnitPrice,
    s.CompanyName, s.Address, s.City, s.PostalCode, s.Country
from 
    Products as p
join
    Suppliers as s on p.SupplierID = s.SupplierID
where 
    UnitPrice between 20 and 30;

--2.Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów
--dostarczanych przez firmę ‘Tokyo Traders’
select 
    p.ProductID, p.ProductName, p.UnitsInStock, s.CompanyName
from 
    Products as p
join
    Suppliers as s on p.SupplierID = s.SupplierID
where
    s.CompanyName = 'Tokyo Traders';

--3.Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, 
--jeśli tak to pokaż ich dane adresowe
select distinct 
    o.CustomerID, c.CompanyName, c.Address, c.City, c.PostalCode, c.Country 
from 
    Orders as o
join 
    Customers as c on o.CustomerID = c.CustomerID
where
    year(o.OrderDate) <> 1997;

--4.Wybierz nazwy i numery telefonów dostawców, dostarczających produkty,
--których aktualnie nie ma w magazynie
select 
    p.ProductName, s.CompanyName, s.Phone
from 
    Products as p
join 
    Suppliers as s on p.SupplierID = s.SupplierID
where
    p.UnitsInStock = 0;

--------------------------------------------------------------------------------
--str 15
--Ćwiczenia
--------------------------------------------------------------------------------
use library;

--1.Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki 
--(baza library). Interesuje nas imię, nazwisko i data urodzenia dziecka.
select 
    m.firstname, m.lastname, j.birth_date
from 
    juvenile as j
join 
    member as m on j.member_no = m.member_no;

--2.Napisz polecenie, które podaje tytuły aktualnie wypożyczonych książek
select distinct
    t.title
from 
    copy as c
join 
    title as t on c.title_no = t.title_no
where 
    c.on_loan = 'Y';

-- select distinct
--     t.title
-- from 
--     loan as l
-- join 
--     title as t on l.title_no = t.title_no;

--3.Podaj informacje o karach zapłaconych za przetrzymywanie książki o tytule 
--‘Tao Teh King’. Interesuje nas data oddania książki, ile dni była 
--przetrzymywana i jaką zapłacono karę
select 
    lh.in_date, 
    lh.fine_paid, 
    datediff(day, lh.in_date, lh.due_date) as overdue_in_days
from 
    loanhist as lh
join 
    title as t on lh.title_no = t.title_no
where 
    t.title = 'Tao Teh King' and
    lh.fine_paid is not null;

--4.Napisz polecenie które podaje listę książek (mumery ISBN) zarezerwowanych
--przez osobę o nazwisku: Stephen A. Graff
select 
    r.isbn
from 
    reservation as r
join 
    member as m on r.member_no = m.member_no
where 
    m.firstname = 'Stephen' and
    m.middleinitial = 'A' and
    m.lastname = 'Graff';

--------------------------------------------------------------------------------
--str 20
--Ćwiczenia
--------------------------------------------------------------------------------
use northwind;

--1.Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej
--pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy,
--interesują nas tylko produkty z kategorii ‘Meat/Poultry’
select 
    p.ProductName, p.UnitPrice, s.CompanyName, s.Address, s.City, s.PostalCode, s.Country
from 
    Products as p
join 
    Categories as cat on p.CategoryID = cat.CategoryID
join 
    Suppliers as s on p.SupplierID = s.SupplierID
where
    p.UnitPrice between 20 and 30 and
    cat.CategoryName = 'Meat/Poultry';

--2.Wybierz nazwy i ceny produktów z kategorii ‘Confections’ dla każdego produktu
--podaj nazwę dostawcy.
select 
    p.ProductName, p.UnitPrice, s.CompanyName
from 
    Products as p
join 
    Categories as cat on p.CategoryID = cat.CategoryID
join 
    Suppliers as s on p.SupplierID = s.SupplierID
where
    cat.CategoryName = 'Confections';

--3.Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki
--dostarczała firma ‘United Package’
-- select distinct
--     c.CompanyName, c.Phone
-- from 
--     Customers as c
-- join 
--     Orders as o on c.CustomerID = o.CustomerID and year(o.ShippedDate) = 1997
-- join
--     Shippers as s on o.ShipVia = s.ShipperID and s.CompanyName = 'United Package';

select distinct
    c.CompanyName, c.Phone
from 
    Customers as c
join 
    Orders as o on c.CustomerID = o.CustomerID
join
    Shippers as s on o.ShipVia = s.ShipperID
where
    year(o.ShippedDate) = 1997 and
    s.CompanyName = 'United Package';

--4.Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z 
--kategorii ‘Confections’
select distinct
    c.CompanyName, c.Phone
from 
    Customers as c
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

--------------------------------------------------------------------------------
--str 21
--Ćwiczenia
--------------------------------------------------------------------------------
use library;

--1.Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki
--(baza library). Interesuje nas imię, nazwisko, data urodzenia dziecka i adres
--zamieszkania dziecka.
select 
    m.firstname, m.lastname,
    j.birth_date,
    a.street, a.zip, a.city
from 
    juvenile as j
join 
    member as m on j.member_no = m.member_no
join
    adult as a on j.adult_member_no = a.member_no;

--2.Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki
--(baza library). Interesuje nas imię, nazwisko, data urodzenia dziecka, adres
--zamieszkania dziecka oraz imię i nazwisko rodzica.
select 
    m.firstname, m.lastname,
    j.birth_date,
    a.street, a.zip, a.city,
    mp.firstname as parent_firstname,
    mp.lastname as parent_lastname
from 
    juvenile as j
join 
    member as m on j.member_no = m.member_no
join
    adult as a on j.adult_member_no = a.member_no
join
    member as mp on a.member_no = mp.member_no;

--------------------------------------------------------------------------------
--str 26
--Ćwiczenia
--------------------------------------------------------------------------------
use northwind;

--1.Napisz polecenie, które wyświetla pracowników oraz ich podwładnych (baza
--northwind)
-- 2
-- |
-- 1 3 4 5 8
--       |
--       6 7 9
select 
    sup.EmployeeID as superior_id, concat(sup.FirstName, ' ', sup.LastName) as superior_name, 
    sub.EmployeeID as subordinate_id, concat(sub.FirstName, ' ', sub.LastName) as subordinate_name
from 
    Employees as sub
join
    Employees as sup on sub.ReportsTo = sup.EmployeeID
order by 
    superior_id, subordinate_id;

--2.Napisz polecenie, które wyświetla pracowników, którzy nie mają podwładnych
--(baza northwind)
select 
    emp.EmployeeID as employee_id, 
    concat(emp.FirstName, ' ', emp.LastName) as employee_name
    -- sub.EmployeeID as subordinate_id
from 
    Employees as emp
left join
    Employees as sub on emp.EmployeeID = sub.ReportsTo
where
    sub.EmployeeID is null;

--3.Napisz polecenie, które wyświetla adresy członków biblioteki, którzy mają 
--dzieci urodzone przed 1 stycznia 1996
use library;

select distinct
    a.member_no, a.street, a.zip, a.city
from 
    adult as a
join 
    juvenile as j on a.member_no = j.adult_member_no
where
    j.birth_date <= '1/1/1996';

--4.Napisz polecenie, które wyświetla adresy członków biblioteki, którzy mają
--dzieci urodzone przed 1 stycznia 1996. Interesują nas tylko adresy takich
--członków biblioteki, którzy aktualnie nie przetrzymują książek.
select distinct
    a.member_no, a.street, a.zip, a.city
from
    adult as a
join 
    juvenile as j on a.member_no = j.adult_member_no
left join
    loan as l on a.member_no = l.member_no
where
    j.birth_date <= '1/1/1996' and
    l.member_no is null;

--------------------------------------------------------------------------------
--str 28
--Ćwiczenie
--------------------------------------------------------------------------------
use library;

--1.Napisz polecenie które zwraca imię i nazwisko (jako pojedynczą kolumnę –
--name), oraz informacje o adresie: ulica, miasto, stan kod (jako pojedynczą
--kolumnę – address) dla wszystkich dorosłych członków biblioteki
select 
    concat(m.firstname, ' ', m.lastname) as name,
    concat(a.street, ' ', a.city, ' ', a.[state], ' ', a.zip) as address
from 
    member as m
join
    adult as a on m.member_no = a.member_no;

--2.Napisz polecenie, które zwraca: isbn, copy_no, on_loan, title, translation,
--cover, dla książek o isbn 1, 500 i 1000. Wynik posortuj wg ISBN
select 
    c.isbn, c.copy_no, c.on_loan, t.title, it.translation, it.cover
from 
   copy as c
join
    title as t on c.title_no = t.title_no
join
    item as it on c.isbn = it.isbn
where
    it.isbn in (1, 500, 1000); 

--3.Napisz polecenie które zwraca o użytkownikach biblioteki o nr 250, 342, i 
--1675 (dla każdego użytkownika: nr, imię i nazwisko członka biblioteki), oraz
--informację o zarezerwowanych książkach (isbn, data)
select 
    m.member_no, m.firstname, m.lastname, r.log_date, r.isbn
from 
    member as m
join
    reservation as r on m.member_no = r.member_no;

--4.Podaj listę członków biblioteki mieszkających w Arizonie (AZ) mają więcej niż
--dwoje dzieci zapisanych do biblioteki
select 
    a.member_no, m.firstname, m.lastname
from 
    adult as a
join 
    juvenile as j on a.member_no = j.adult_member_no
join 
    member as m on a.member_no = m.member_no
where
    a.[state] = 'AZ'
group by
    a.member_no, m.firstname, m.lastname
having 
    count(j.adult_member_no) > 2;

--------------------------------------------------------------------------------
--str 29
--Ćwiczenie
--------------------------------------------------------------------------------
use library;

--1.Podaj listę członków biblioteki mieszkających w Arizonie (AZ) którzy mają
--więcej niż dwoje dzieci zapisanych do biblioteki oraz takich którzy mieszkają 
--w Kaliforni (CA) i mają więcej niż troje dzieci zapisanych do biblioteki
(select 
    a.member_no, m.firstname, m.lastname
from 
    adult as a
join 
    juvenile as j on a.member_no = j.adult_member_no
join 
    member as m on a.member_no = m.member_no
where
    a.[state] = 'AZ'
group by
    a.member_no, m.firstname, m.lastname
having 
    count(j.adult_member_no) > 2)

union

(select 
    a.member_no, m.firstname, m.lastname
from 
    adult as a
join 
    juvenile as j on a.member_no = j.adult_member_no
join 
    member as m on a.member_no = m.member_no
where
    a.[state] = 'CA'
group by
    a.member_no, m.firstname, m.lastname
having 
    count(j.adult_member_no) > 3);
