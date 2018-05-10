-----------------------------------------------SQL Query-----------------------------------------------------------------------------------------
 
--A1. Determine the number of active ads on the site per day (using generate_series).

/* In the below query:
   ad1 generates a series of all days between the min and max publish date in the ads table. 
       This range can be customized as needed eg: date till current day instead of max date etc.
   ad2 creates a subset of data by substituting a default future date for active ads in case these are represented as NULL in the table.
       This is done to avoid missing out those dates with no active ads i.e. count 0.
       This substitution step is not needed if we only require the days with 1 or more active ads, in that case a simple where clause would work too.  
   Publish date is used here since that is the date on which the ad goes on the site.
*/ 
  
SELECT ad1.day 
    , SUM(CASE WHEN ad2.delete_date = '12-31-9999' THEN 1 ELSE 0 END) AS no_of_active_ads
  FROM (SELECT DATE(generate_series(MIN(publish), MAX(publish), '1 day' )) AS Day FROM ads) ad1
   LEFT OUTER JOIN
   (SELECT id, publish, COALESCE(delete, '12-31-9999') AS delete_date FROM ads ) ad2
   ON ad1.day = ad2.publish
  GROUP BY ad1.day;