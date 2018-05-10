-----------------------------------------------SQL Query-----------------------------------------------------------------------------------------
--A2. Determine the YoY growth of Beef Cattle ads in county Tipperary from 2016 to 2017 (using lag).
/* In the below query
   - lag is used to find the total number of ads as of last year. 
   - All the filters are applied in the first level to limit the data that needs to be processed. 
   - yoy ad growth is calculated  [(tot no of ads in this year)/ (tot no of ads last year)] - 1
   - A positive value indicates growth and a negative value indicates drop. (This can also be calculated as percentage if requried)

*/

SELECT year
    , count_ads
    , LAG(count_ads) OVER (ORDER BY year) AS lag_count_ads
    , (count_ads / NULLIF(LAG(count_ads) OVER(ORDER BY year), 0) :: NUMERIC(3,2) ) - 1 AS yoy_ad_growth
  FROM (
         SELECT EXTRACT(year FROM a.publish) AS year
             , COUNT(a.id) AS count_ads
           FROM ads a, category c, region r
           WHERE a.category_id = c.id
             AND a.region_id = r.id
             AND c.subsubcategory = 'Beef Cattle'
             AND r.county = 'Tipperary'
             AND EXTRACT(year FROM a.publish) IN (2016,2017)
           GROUP BY 1 
       ) yearly_data;