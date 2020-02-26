/*
///////
Leads status
//////
*/

SELECT COUNT(DISTINCT LEAD_ID) as Value, Category FROM
(SELECT 
LEAD_ID,
CASE
WHEN ACCEPTED_FLAG = 'N' AND STATUS = 'UNQUALIFIED' AND REJECT_REASON = 'Not Applicable' THEN  'Unaccepted'
WHEN REJECT_REASON != 'Not Applicable' AND STATUS = 'UNQUALIFIED' THEN 'Rejected'
WHEN RETIRE_REASON IN ('Z-ADMIN: Auto-Expired Not Accepted','Z-ADMIN: Auto-Expired Not Actioned') THEN 'Expired'
WHEN ACCEPTED_FLAG = 'Y' AND STATUS IN ('UNQUALIFIED','QUALIFIED') THEN 'Working'
WHEN lead.STATUS = 'RETIRED' THEN 'Retired'
WHEN lead.STATUS = 'CONVERTED' THEN 'Converted'
ELSE 'Error' END as Category

FROM catalincostin.FY20_LEADS lead
WHERE lead.CAMPAIGN_SOURCE_CODE = :P3_CODE AND RETIRE_REASON NOT LIKE 'Z-ADMIN: Admin Only%')
GROUP BY Category
ORDER BY CASE Category
WHEN 'Rejected' THEN 1
WHEN 'Retired' THEN 2
WHEN 'Expired' THEN 3
WHEN 'Unaccepted' THEN 4
WHEN 'Working' THEN 5
WHEN 'Converted' THEN 6
END




/*
///////
Leads with Interactions 
//////
*/

SELECT 
count(distinct REGISTRY_ID) as Value,
'Leads with interactions' as Category
FROM catalincostin.fy20_interactions WHERE LEAD_CAMPAIGN_CODE = :P3_CODE
UNION
SELECT (
	(SELECT 
	count(distinct lead_ID)
	FROM catalincostin.fy20_leads where CAMPAIGN_SOURCE_CODE = :P3_CODE AND RETIRE_REASON NOT LIKE 'Z-ADMIN: Admin Only%')
		-
	(SELECT 
	count(distinct REGISTRY_ID)
	FROM catalincostin.fy20_interactions WHERE LEAD_CAMPAIGN_CODE = :P3_CODE )
) as Value,
'Leads without interactions' as Category
FROM dual 




/*
///////
Retire Reason
//////
*/

SELECT 
RETIRE_REASON as Category,
COUNT(RETIRE_REASON) as Value
FROM catalincostin.FY20_LEADS lead
WHERE lead.CAMPAIGN_SOURCE_CODE = :P3_CODE AND STATUS = 'RETIRED' AND RETIRE_REASON NOT LIKE 'Z-ADMIN: Admin Only%'
GROUP BY RETIRE_REASON 
ORDER BY Value DESC 


