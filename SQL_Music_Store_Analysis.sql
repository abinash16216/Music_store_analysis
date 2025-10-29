-- SQL_Music_Store_Analysis.sql

/* Q1: Who is the senior most employee based on job title? */
SELECT
	LEVELS,
	TITLE,
	*
FROM
	EMPLOYEE
ORDER BY
	1 DESC
LIMIT
	1;

/* Q2: Which countries have the most Invoices? */
SELECT
	BILLING_COUNTRY,
	COUNT(BILLING_COUNTRY)
FROM
	INVOICE
GROUP BY
	1
ORDER BY
	2 DESC;

/* Q3: What are top 3 values of total invoice? */
SELECT
	INVOICE_DATE,
	TOTAL
FROM
	INVOICE
ORDER BY
	TOTAL DESC
LIMIT
	3;

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */
SELECT
	BILLING_CITY,
	SUM(TOTAL) AS TOTAL_BILLS
FROM
	INVOICE
GROUP BY
	1
ORDER BY
	2 DESC;

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/
SELECT
	*
FROM
	INVOICE;

SELECT
	C.CUSTOMER_ID,
	C.FIRST_NAME,
	C.LAST_NAME,
	SUM(I.TOTAL) AS TOTAL_EXPENSE
FROM
	CUSTOMER C
	LEFT JOIN INVOICE I ON C.CUSTOMER_ID = I.CUSTOMER_ID
GROUP BY
	1
ORDER BY
	4 DESC
LIMIT
	1;

-- SET 2
/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */
SELECT
	*
FROM
	CUSTOMER;

SELECT
	*
FROM
	GENRE;

SELECT DISTINCT
	EMAIL,
	FIRST_NAME,
	LAST_NAME
FROM
	CUSTOMER
	JOIN INVOICE ON CUSTOMER.CUSTOMER_ID = INVOICE.CUSTOMER_ID
	JOIN INVOICE_LINE ON INVOICE.INVOICE_ID = INVOICE_LINE.INVOICE_ID
WHERE
	TRACK_ID IN (
		SELECT
			T.TRACK_ID
		FROM
			TRACK T
			LEFT JOIN GENRE G ON T.GENRE_ID = G.GENRE_ID
		WHERE
			G.NAME LIKE 'Roc%'
	)
ORDER BY
	EMAIL ASC;

/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */
SELECT
	ARTIST.NAME,
	COUNT(TRACK.NAME) AS TOTAL_TRACK_COUNT
FROM
	ARTIST
	JOIN ALBUM ON ARTIST.ARTIST_ID = ALBUM.ARTIST_ID
	JOIN TRACK ON ALBUM.ALBUM_ID = TRACK.ALBUM_ID
	JOIN GENRE GE ON TRACK.GENRE_ID = GE.GENRE_ID
WHERE
	GE.NAME LIKE 'Roc%'
GROUP BY
	1
ORDER BY
	2 DESC
LIMIT
	10;

/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */
SELECT
	NAME,
	MILLISECONDS
FROM
	TRACK
WHERE
	MILLISECONDS > (
		SELECT
			AVG(MILLISECONDS)
		FROM
			TRACK
	)
ORDER BY
	2 DESC;

/* Question Set 3 - Advance */
/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */
/* Steps to Solve: First, find which artist has earned the most according to the InvoiceLines. Now use this artist to find 
which customer spent the most on this artist. For this query, you will need to use the Invoice, InvoiceLine, Track, Customer, 
Album, and Artist tables. Note, this one is tricky because the Total spent in the Invoice table might not be on a single product, 
so you need to use the InvoiceLine table to find out how many of each product was purchased, and then multiply this by the price
for each artist. */
WITH
	BEST_SELLING_ARTIST AS (
		SELECT
			ARTIST.ARTIST_ID AS ARTIST_ID,
			ARTIST.NAME AS ARTIST_NAME,
			SUM(INVOICE_LINE.UNIT_PRICE * INVOICE_LINE.QUANTITY) AS TOTAL_SALES
		FROM
			INVOICE_LINE
			JOIN TRACK ON TRACK.TRACK_ID = INVOICE_LINE.TRACK_ID
			JOIN ALBUM ON ALBUM.ALBUM_ID = TRACK.ALBUM_ID
			JOIN ARTIST ON ARTIST.ARTIST_ID = ALBUM.ARTIST_ID
		GROUP BY
			1
		ORDER BY
			3 DESC
		LIMIT
			1
	)
SELECT
	C.CUSTOMER_ID,
	C.FIRST_NAME,
	C.LAST_NAME,
	BSA.ARTIST_NAME,
	SUM(IL.UNIT_PRICE * IL.QUANTITY) AS AMOUNT_SPENT
FROM
	INVOICE I
	JOIN CUSTOMER C ON C.CUSTOMER_ID = I.CUSTOMER_ID
	JOIN INVOICE_LINE IL ON IL.INVOICE_ID = I.INVOICE_ID
	JOIN TRACK T ON T.TRACK_ID = IL.TRACK_ID
	JOIN ALBUM ALB ON ALB.ALBUM_ID = T.ALBUM_ID
	JOIN BEST_SELLING_ARTIST BSA ON BSA.ARTIST_ID = ALB.ARTIST_ID
GROUP BY
	1,
	2,
	3,
	4
ORDER BY
	5 DESC;

/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */
/* Steps to Solve:  There are two parts in question- first most popular music genre and second need data at country level. */
WITH
	POPULAR_GENRE AS (
		SELECT
			COUNT(INVOICE_LINE.QUANTITY) AS PURCHASES,
			CUSTOMER.COUNTRY,
			GENRE.NAME,
			GENRE.GENRE_ID,
			ROW_NUMBER() OVER (
				PARTITION BY
					CUSTOMER.COUNTRY
				ORDER BY
					COUNT(INVOICE_LINE.QUANTITY) DESC
			) AS ROWNO
		FROM
			INVOICE_LINE
			JOIN INVOICE ON INVOICE.INVOICE_ID = INVOICE_LINE.INVOICE_ID
			JOIN CUSTOMER ON CUSTOMER.CUSTOMER_ID = INVOICE.CUSTOMER_ID
			JOIN TRACK ON TRACK.TRACK_ID = INVOICE_LINE.TRACK_ID
			JOIN GENRE ON GENRE.GENRE_ID = TRACK.GENRE_ID
		GROUP BY
			2,
			3,
			4
		ORDER BY
			2 ASC,
			1 DESC
	)
SELECT
	*
FROM
	POPULAR_GENRE
WHERE
	ROWNO <= 1
ORDER BY
	PURCHASES DESC;

/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */
/* Steps to Solve:  Similar to the above question. There are two parts in question- 
first find the most spent on music for each country and second filter the data for respective customers. */
WITH RECURSIVE
	CUSTOMER_WITH_COUNTRY AS (
		SELECT
			CUSTOMER.CUSTOMER_ID,
			FIRST_NAME,
			LAST_NAME,
			BILLING_COUNTRY,
			SUM(TOTAL) AS TOTAL_SPENDING
		FROM
			INVOICE
			JOIN CUSTOMER ON CUSTOMER.CUSTOMER_ID = INVOICE.CUSTOMER_ID
		GROUP BY
			1,
			2,
			3,
			4
		ORDER BY
			2,
			3 DESC
	), -- COMMA added/confirmed here to separate CTEs
	COUNTRY_MAX_SPENDING AS (
		SELECT
			BILLING_COUNTRY,
			MAX(TOTAL_SPENDING) AS MAX_SPENDING
		FROM
			CUSTOMER_WITH_COUNTRY
		GROUP BY
			BILLING_COUNTRY
	) -- NO semicolon here
SELECT
	CC.BILLING_COUNTRY,
	CC.TOTAL_SPENDING,
	CC.FIRST_NAME,
	CC.LAST_NAME,
	CC.CUSTOMER_ID
FROM
	CUSTOMER_WITH_COUNTRY CC
	JOIN COUNTRY_MAX_SPENDING MS ON CC.BILLING_COUNTRY = MS.BILLING_COUNTRY
WHERE
	CC.TOTAL_SPENDING = MS.MAX_SPENDING
ORDER BY
	1;


















