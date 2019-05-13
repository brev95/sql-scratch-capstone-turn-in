--Number of distinct campaigns
SELECT COUNT(DISTINCT utm_campaign) AS 'Number of Campaigns'
FROM page_visits;

--Number of distinct sources
SELECT COUNT(DISTINCT utm_source) AS 'Number of Sources'
FROM page_visits;

--Relation between campaigns and sources
SELECT DISTINCT utm_source AS 'Source',
			 utm_campaign AS 'Campaign'
FROM page_visits;

--Distinct page_names
SELECT DISTINCT page_name AS 'Distinct Pages'
FROM page_visits;

--First touch each campaign is responsible for
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) AS 'first_touch_at'
    FROM page_visits
    GROUP BY user_id)
SELECT pv.utm_campaign AS 'Campaign',
    COUNT(*) AS 'First Touch Count'
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
GROUP BY utm_campaign
ORDER BY 2 DESC;

--Last touch each campaign is responsible for
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) AS 'first_touch_at' -- This wouldn't work if I changed  it to 'last_touch_at' or removed it
    FROM page_visits
    GROUP BY user_id)
SELECT pv.utm_campaign AS 'Campaign',
    COUNT(*) AS 'Last Touch Count'
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.first_touch_at = pv.timestamp
GROUP BY utm_campaign
ORDER BY 2 DESC;

--Number of visitors who made a purchase
SELECT COUNT(DISTINCT user_id) AS 'Distinct User IDs'
FROM page_visits
WHERE page_name = '4 - purchase';

--Last touch purchase each campaign is responsible for
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) AS 'first_touch_at' -- This wouldn't work if I changed  it to 'last_touch_at' or removed it
    FROM page_visits
 		WHERE page_name = '4 - purchase'
    GROUP BY user_id)
SELECT pv.utm_campaign AS 'Campaign',
    COUNT(*) AS 'Last Touch Count'
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.first_touch_at = pv.timestamp
GROUP BY utm_campaign
ORDER BY 2 DESC;