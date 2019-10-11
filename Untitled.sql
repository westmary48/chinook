-- 1. non_usa_customers.sql: Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.
SELECT [CustomerId], [FirstName], [LastName], [Country]
From Customer
WHERE Country <> ('USA');

-- 2. brazil_customers.sql: Provide a query only showing the Customers from Brazil.
Select * FROM Customer
WHERE Country = ('Brazil');

-- 3. brazil_customers_invoices.sql: Provide a query showing the Invoices of customers who are from Brazil. The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.

SELECT [FirstName], [LastName], [InvoiceId], [BillingCountry], [InvoiceDate]
FROM Customer, Invoice
WHERE BillingCountry = ('Brazil');

-- 4. sales_agents.sql: Provide a query showing only the Employees who are Sales Agents.
SELECT * FROM Employee
WHERE Title = ('Sales Support Agent');


-- 5. unique_invoice_countries.sql: Provide a query showing a unique/distinct list of billing countries from the Invoice table.
SELECT DISTINCT [BillingCountry]
FROM Invoice;

-- 6. invoice_totals.sql: Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.

SELECT i.Total, e.FirstName, e.LastName, c.Country
From Employee e
JOIN Invoice i on c.CustomerId= i.CustomerId
JOIN Customer c on e.EmployeeId= c.SupportRepId
ORDER BY i.Total;


-- 7. total_invoices_{year}.sql: How many Invoices were there in 2009 and 2011?


SELECT * FROM Invoice WHERE InvoiceDate between '2009-01-01' and ('2010-01-01') 
OR InvoiceDate BETWEEN ('2011-01-01') and ('2012-01-01');


-- 8. total_sales_{year}.sql: What are the respective total sales for each of those years?

SELECT Count(InvoiceId)
FROM Invoice
WHERE InvoiceDate BETWEEN('2009-01-01') and ('2010-01-01');

-- 83
SELECT COUNT(InvoiceDate)
FROM Invoice
WHERE InvoiceDate BETWEEN('2011-01-01') and ('2012-01-01');
-- 83

SELECT Count(InvoiceId)
FROM Invoice
WHERE InvoiceDate BETWEEN('2009-01-01') and ('2010-01-01');

-- 83

SELECT COUNT(InvoiceDate)
FROM Invoice
WHERE InvoiceDate BETWEEN('2011-01-01') and ('2012-01-01')
OR InvoiceDate BETWEEN('2009-01-01') and ('2010-01-01');

-- 166 together

-- 9. total_sales_{year}.sql: What are the respective total sales for each of those years?

SELECT SUM(Total)
FROM Invoice
WHERE InvoiceDate BETWEEN('2009-01-01') and ('2010-01-01');

-- "449.46 for 2009"

SELECT SUM(Total)
FROM Invoice
WHERE InvoiceDate BETWEEN('2011-01-01') and ('2012-01-01');

-- "469.58 for 2011"

-- 10. invoice_37_line_item_count.sql: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37

select count(InvoiceId) as numberOfLinesFor37 from InvoiceLine where InvoiceId = 37;

SELECT InvoiceId, COUNT(InvoiceId)
FROM InvoiceLine
WHERE InvoiceId = ('37');


-- 4 

-- 11. line_items_per_invoice.sql: Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: GROUP BY

SELECT InvoiceId, COUNT(InvoiceLineId) as line_items_per_invoice
FROM InvoiceLine
GROUP BY InvoiceId;


-- 12. line_item_track.sql: Provide a query that includes the purchased track name with each invoice line item.
SELECT Track.Name, InvoiceLineId
FROM InvoiceLine
JOIN Track on InvoiceLine.TrackId = Track.TrackId
GROUP by InvoiceLineId;


-- 13. line_item_track_artist.sql: Provide a query that includes the purchased track name AND artist name with each invoice line item.
SELECT Track.Name, InvoiceId, Artist.Name
FROM Track
JOIN InvoiceLine on InvoiceLine.TrackId = Track.TrackId
JOIN Album on Track.AlbumId = Album.AlbumId
JOIN Artist on Artist.ArtistId = Album.ArtistId;


-- 14. country_invoices.sql: Provide a query that shows the # of invoices per country. HINT: GROUP BY

SELECT COUNT(InvoiceId), BillingCountry
FROM Invoice
-- JOIN Customer on Invoice.CustomerId = Customer.CustomerId
GROUP By BillingCountry;

-- 15. playlists_track_count.sql: Provide a query that shows the total number of tracks in each playlist. The Playlist name should be include on the resulant table.

SELECT COUNT(Track.TrackId), Playlist.Name as playlists_track_count
FROM Track
Join PlaylistTrack on PlayListTrack.PlaylistId = Track.TrackId;




-- 16. tracks_no_id.sql: Provide a query that shows all the Tracks, but displays no IDs. The result should include the Album name, Media type and Genre.


SELECT COUNT(Track.TrackId) as playlists_track_count, Playlist.Name as Playlist
FROM Track
Join InvoiceLine on InvoiceLine.TrackId = Track.TrackId
JOIN PlaylistTrack on Track.TrackId = PlaylistTrack.PlaylistId
JOIN Playlist on Playlist.PlaylistId = PlaylistTrack.PlaylistId
GROUP BY Playlist.Name;


-- 19 top_2009_agent.sql: Which sales agent made the most in sales in 2009?

SELECT MAX(TotalSales), 
e.FirstName,
e.LastName
FROM (
SELECT 
"$" || printf("%.2f", SUM(i.Total)) AS TotalSales, 
e.FirstName, e.LastName, 
strftime ('%y', 
i.InvoiceDate) As InvoiceYear
FROM 
Invoice i,
Employee e,
Customer c
WHERE
i.CustomerId = c.CustomerId
AND c.SupportRepId = e.EmployeeId
AND InvoiceYear = '2009'
GROUP BY
e.FirstName, e.LastName, InvoiceYear
);


-- 21

SELECT e.FirstName, e.LastName, COUNT(c.CustomerId)
FROM Employee e
LEFT JOIN Customer c ON e.EmployeeId = c.SupportRepId
WHERE
e.Title = 'Sales Support Agent'
GROUP BY
e.FirstName,
e.LastName;

-- 24 top_2013_track.sql: Provide a query that shows the most purchased track of 2013




-- 25
SELECT t.Name, SUM(il.Quantity) as NumberPurchased
FROM
Track t

JOIN InvoiceLine il
 ON il.TrackId = t.TrackId

GROUP BY
t.Name
ORDER BY 
NumberPurchased DESC
LIMIT 5;

-- 26
select ar.Name, sum(total) as totalSales from Invoice i 
join InvoiceLine il ON i.InvoiceId= il.InvoiceId 
join Track t on il.TrackId=t.TrackId 
join Album a on t.AlbumId=a.AlbumId 
join Artist ar on a.ArtistId=ar.ArtistId
group by ar.Name
order by totalSales DESC
LIMIT 3;



-- 27

select (m.Name), sum(total) as totalSales from Invoice i 
JOIN InvoiceLine il on i.InvoiceId=il.InvoiceId 
JOIN Track t on il.TrackId= t.TrackId 
JOIN Album a on t.AlbumId= a.AlbumId 
JOIN Artist ar on a.ArtistId = ar.ArtistId
JOIN MediaType m on t.MediaTypeId =m.MediaTypeId
GROUP BY m.Name
ORDER by totalSales desc
LIMIT 1;








