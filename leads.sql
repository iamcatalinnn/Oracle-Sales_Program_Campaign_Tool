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
LEFT JOIN FLM_SALES S on S.REP = lead.TERRITORY_OWNER_E_MAIL
WHERE lead.CAMPAIGN_SOURCE_CODE = :P3_CODE AND RETIRE_REASON NOT LIKE 'Z-ADMIN: Admin Only%' 
AND (:P1_VP = S.VP OR :P1_VP = '<All>') AND (:P1_DIR = S.DIR OR :P1_DIR = '<All>') AND (:P1_FLM = S.FLM OR :P1_FLM = '<All>') AND (:P1_REP = S.REP OR :P1_REP = '<All>'))
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
FROM catalincostin.fy20_interactions I 
LEFT JOIN FLM_SALES S on S.REP = I.EMAIL_ADDRESS
WHERE LEAD_CAMPAIGN_CODE = :P3_CODE AND (:P1_VP = S.VP OR :P1_VP = '<All>') AND (:P1_DIR = S.DIR OR :P1_DIR = '<All>') AND (:P1_FLM = S.FLM OR :P1_FLM = '<All>') AND (:P1_REP = S.REP OR :P1_REP = '<All>')
UNION
SELECT (
	(SELECT 
	count(distinct lead_ID)
	FROM catalincostin.fy20_leads lead
    LEFT JOIN FLM_SALES S on S.REP = lead.TERRITORY_OWNER_E_MAIL
    WHERE lead.CAMPAIGN_SOURCE_CODE = :P3_CODE AND RETIRE_REASON NOT LIKE 'Z-ADMIN: Admin Only%' 
    AND (:P1_VP = S.VP OR :P1_VP = '<All>') AND (:P1_DIR = S.DIR OR :P1_DIR = '<All>') AND (:P1_FLM = S.FLM OR :P1_FLM = '<All>') AND (:P1_REP = S.REP OR :P1_REP = '<All>'))
		-
	(SELECT 
	count(distinct REGISTRY_ID)
	FROM catalincostin.fy20_interactions  I 
    LEFT JOIN FLM_SALES S on S.REP = I.EMAIL_ADDRESS
    WHERE LEAD_CAMPAIGN_CODE = :P3_CODE AND (:P1_VP = S.VP OR :P1_VP = '<All>') AND (:P1_DIR = S.DIR OR :P1_DIR = '<All>') AND (:P1_FLM = S.FLM OR :P1_FLM = '<All>') AND (:P1_REP = S.REP OR :P1_REP = '<All>'))
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
LEFT JOIN FLM_SALES S on S.REP = lead.TERRITORY_OWNER_E_MAIL
WHERE lead.CAMPAIGN_SOURCE_CODE = :P3_CODE AND RETIRE_REASON NOT LIKE 'Z-ADMIN: Admin Only%' 
AND (:P1_VP = S.VP OR :P1_VP = '<All>') AND (:P1_DIR = S.DIR OR :P1_DIR = '<All>') AND (:P1_FLM = S.FLM OR :P1_FLM = '<All>') AND (:P1_REP = S.REP OR :P1_REP = '<All>')
GROUP BY RETIRE_REASON 
ORDER BY Value DESC 


