create database airbnb_data;
use airbnb_data;

CREATE TABLE airbnb (
    id BIGINT PRIMARY KEY,
    price DECIMAL(20,2),
    property_type VARCHAR(100),
    room_type VARCHAR(100),
    accommodates INT,
    bathrooms DECIMAL(3,1),
    bed_type VARCHAR(50),
    cancellation_policy VARCHAR(50),
    cleaning_fee BOOLEAN,
    city VARCHAR(50),
    first_review DATE,
    host_has_profile_pic boolean,
    host_identity_verified boolean,
    host_response_rate int,
    host_since DATE,
    instant_bookable boolean,
    last_review DATE,
    name VARCHAR(255),
    neighbourhood VARCHAR(100),
    number_of_reviews INT,
    review_scores_rating DECIMAL(5,2),
    zipcode VARCHAR(50),
    bedrooms DECIMAL(3,1),
    beds DECIMAL(3,1)
);



LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/airbnb.csv'
INTO TABLE airbnb
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    id,
    price,
    property_type,
    room_type,
    accommodates,
    @bathrooms,
    bed_type,
    cancellation_policy,
    @cleaning_fee,
    city,
    @first_review,
    host_has_profile_pic,
    host_identity_verified,
    @host_response_rate,
    @host_since,
    instant_bookable,
    @last_review,
    name,
    neighbourhood,
    number_of_reviews,
    @review_scores_rating,
    zipcode,
    bedrooms,
    beds
)
SET
	first_review =
    CASE
        WHEN @first_review = '' THEN NULL
        ELSE STR_TO_DATE(@first_review, '%d-%m-%Y')
    END,
    host_since =
    CASE
        WHEN @host_since = '' THEN NULL
        ELSE STR_TO_DATE(@host_since, '%d-%m-%Y')
    END,
    last_review =
    CASE
        WHEN @last_review = '' THEN NULL
        ELSE STR_TO_DATE(@last_review, '%d-%m-%Y')
    END,
    host_response_rate = NULLIF(REPLACE(@host_response_rate, '%', ''), ''),
    review_scores_rating = NULLIF(@review_scores_rating, ''),
    bathrooms = NULLIF(@bathrooms, '');
    
SHOW WARNINGS;

SELECT DISTINCT review_scores_rating 
FROM airbnb 
ORDER BY review_scores_rating DESC
LIMIT 10;

SELECT MIN(review_scores_rating),
       MAX(review_scores_rating)
FROM airbnb;
    
SHOW VARIABLES LIKE "secure_file_priv";

select count(*) from airbnb;



-- / -- 🔥 PRICING POWER (Revenue Strategy)  -- /
## 1. Which city has the highest average listing price?
select city, avg(price) as avg_listing from airbnb group by city order by avg_listing desc limit 1;

## 2. Which neighbourhoods command premium pricing?
select neighbourhood, avg(price) as avg_price, count(*) as listings from airbnb group by neighbourhood having listings>20 order by avg_price desc;

## 3. How does price vary across room types (Entire home vs Private vs Shared)?
select room_type, avg(price) as avg_price, count(*) as listings from airbnb group by room_type having listings>20 order by avg_price desc;

## 4. How strongly does price increase with number of bedrooms?
select bedrooms, avg(price) as avg_listing from airbnb group by bedrooms order by bedrooms desc;

## 5. Does adding bathrooms significantly increase listing price?
select bathrooms, avg(price) as avg_listing from airbnb group by bathrooms order by avg_listing desc;

## 6. What is the average price per bed?
select round(avg(price/beds),2) as avg_price_per_bed from airbnb;

## 7. Are instant bookable listings priced higher than non-instant ones?
select instant_bookable, avg(price) as avg_listing from airbnb group by instant_bookable order by avg_listing desc;

## 8. Do verified hosts charge more than non-verified hosts?
select host_identity_verified, avg(price) as avg_listing from airbnb group by host_identity_verified order by avg_listing desc;

## 9. Do hosts with profile pictures command higher prices?
select host_has_profile_pic, avg(price) as avg_listing from airbnb group by host_has_profile_pic order by avg_listing desc;

## 10. Does host response rate influence pricing power?
select case when host_response_rate>90 then 'High' when host_response_rate>75 then 'Mid' else 'Low' end as response_category, 
avg(price) as avg_listing from airbnb group by response_category order by avg_listing desc;



-- /-- ⭐ TRUST & QUALITY SIGNALS (What Drives Ratings?) -- /
## 11. Do verified hosts receive higher review scores?
select host_identity_verified, avg(review_scores_rating) as reviews from airbnb group by host_identity_verified order by reviews desc;

## 12. Do hosts with profile pictures receive better ratings?
select host_has_profile_pic, avg(review_scores_rating) as reviews from airbnb group by host_has_profile_pic order by reviews desc;

## 13. Is higher host response rate linked to better review scores?
select case when host_response_rate>90 then 'High' when host_response_rate>75 then 'Mid' else 'Low' end as response_category
, avg(review_scores_rating) as reviews from airbnb group by response_category order by reviews desc;

## 14. Do higher-priced listings actually receive better ratings?
select case when price>1500 then 'High' when price>750 then 'Mid' else 'Low' end as price_category
, avg(review_scores_rating) as reviews from airbnb group by price_category order by reviews desc;

## 15. Which neighbourhoods have both high price and high ratings?
select neighbourhood, avg(price) as avg_price, avg(review_scores_rating) as ratings from airbnb group by neighbourhood 
having avg_price > (select avg(price) from airbnb) and ratings > (select avg(review_scores_rating) from airbnb) order by avg_price desc;




-- / -- 📊 DEMAND & MARKET STRUCTURE -- /
## 16. Which neighbourhoods have the highest number of listings (supply concentration)?
select neighbourhood, count(*) as listings from airbnb group by neighbourhood order by listings desc limit 10 offset 1;

## 17. Which bedroom category receives the most reviews (proxy for demand)?
		-- Method 1 : Category-wise
select case when bedrooms > 5 then 'High' when bedrooms > 2 then 'Mid' else 'Low' end as bedroom_category, 
avg(review_scores_rating) as ratings, count(*) as listings from airbnb group by bedroom_category order by ratings desc;   

		-- Method 2 : Bedrooms wise
select bedrooms, avg(review_scores_rating) as ratings, count(*) as listings from airbnb group by bedrooms order by ratings desc;


## 18. Do higher-priced listings receive fewer reviews (price elasticity effect)?
select case when price>1500 then 'High' when price>750 then 'Mid' else 'Low' end as price_category,
avg(review_scores_rating) as reviews from airbnb group by price_category;




-- / --  🏆 STRATEGIC / ADVANCED INSIGHTS -- /
## 19. What differentiates the top 10% most expensive listings from the rest?
with ranked as(select *, ntile(10) over (order by price desc) as price_decile from airbnb)
select case when price_decile=1 then 'Top10' else 'Others' end as price_segment,
round(avg(price),2) as avg_listing, round(avg(review_scores_rating),2) as avg_rating,
round(avg(bedrooms),2) as avg_bedrooms, round(avg(host_response_rate),2) as avg_response,
count(*) as listings from ranked group by price_segment;

## 20. Where are undervalued opportunities (high rating + below average price)?
select id, neighbourhood, city, price, review_scores_rating from airbnb where review_scores_rating > (select avg(review_scores_rating) from airbnb)
and price < (Select avg(price) from airbnb) order by review_scores_rating desc limit 20;


## 21. Do experienced hosts (based on host_since) charge higher prices than newer hosts?
select case when year(host_since) <= year(curdate()) - 15 then 'Experienced' else 'New' end as host_exp,
round(avg(price),2) as avg_price, count(*) as listings from airbnb where host_since is not null group by host_exp;

## 22. Does host response rate influence the number of reviews (proxy for booking frequency)?
select case when host_response_rate > 90 then 'Good' when host_response_rate > 70 then 'Mid' else 'Low' end as response, 
round(avg(review_scores_rating),2) as avg_reviews from airbnb group by response;

## 23. Which neighbourhoods show low competition but above-average pricing (entry opportunity zones)?
select neighbourhood, count(*) as total_listings, round(avg(price),2) as avg_price from airbnb group by neighbourhood
having total_listings > (select avg(cnt) from (select count(*) as cnt from airbnb group by neighbourhood) t)
and avg_price > (select avg(price) from airbnb) order by avg_price desc;

## 24. Are new hosts underpricing their listings to compete in the market?
select case when year(host_since) >= year(curdate()) - 5 then 'New' else 'Experienced' end as host_exp,
round(avg(price),2) as avg_price from airbnb where host_since is not null group by host_exp;

## 25. What defines a high-performing listing (high rating + high reviews + above-average price)?
select count(*), round(avg(price),2) as avg_price, round(avg(number_of_reviews),2) as avg_reviews, round(avg(review_scores_rating),2) as avg_rating,
round(avg(host_response_rate),2) as avg_response from airbnb where review_scores_rating > (Select avg(review_scores_rating) from airbnb) and
number_of_reviews > (Select avg(number_of_reviews) from airbnb) and price > (Select avg(price) from airbnb);

## 26. Which listings are overpriced (high price + low rating + low reviews)?
select id, neighbourhood, price, review_scores_rating, number_of_reviews from airbnb where price > (Select avg(price) from airbnb) and 
review_scores_rating < (Select avg(review_scores_rating) from airbnb) and number_of_reviews < (Select avg(number_of_reviews) from airbnb);

## 27. Which listings are underpriced (high rating + below-average price)?
select id, neighbourhood, price, review_scores_rating, number_of_reviews from airbnb where price < (Select avg(price) from airbnb) and 
review_scores_rating < (Select avg(review_scores_rating) from airbnb);

## 28. Does cancellation policy impact pricing power?
select count(*) as listing, round(avg(price),2) as avg_price, cancellation_policy from airbnb group by cancellation_policy order by avg_price;

## 29. Do trust signals collectively (verification + profile pic + high response rate) impact pricing more than property size?
select case when host_identity_verified = 1 and host_has_profile_pic = 1 and host_response_rate > 90 then 'Trustworthy' else 'Mistrust' end as trust_factor,
round(avg(price),2) as avg_price, round(avg(bedrooms),2) as avg_bedrooms from airbnb group by trust_factor;

## 30. What combination of features most commonly appears in the top 10% most expensive listings?
with ranked as (select *, ntile(10) over (order by price desc) as price_decile from airbnb)
select round(avg(bedrooms),2) as avg_bedrooms, round(avg(bathrooms),2) as avg_bathrooms, round(avg(host_response_rate),2) as responses, 
avg(host_identity_verified) as verification, avg(host_has_profile_pic) as profile from ranked where price_decile=1;




