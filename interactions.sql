/*
///////
Interactions Outcome 
//////
*/
SELECT 
COUNT(DISTINCT ACTIVITY_NUMBER) as Value, 
Outcome
FROM(SELECT 
ACTIVITY_NUMBER,
CASE
    WHEN OUTCOME_CODE IN ('Positive (customer interested)','Positive (meeting scheduled)','Positive (SE Trial)','Positive (Trial Offered)') THEN 'Positive'
    WHEN OUTCOME_CODE = 'Negative (customer not interested)' THEN 'Negative'
    WHEN OUTCOME_CODE = 'Neutral (customer undecided)' THEN 'Neutral'
    ELSE'Pending' 
END AS Outcome
FROM catalincostin.fy20_interactions I 
LEFT JOIN FLM_SALES S on S.REP = I.EMAIL_ADDRESS
WHERE LEAD_CAMPAIGN_CODE = :P3_CODE AND (:P1_VP = S.VP OR :P1_VP = '<All>') AND (:P1_DIR = S.DIR OR :P1_DIR = '<All>') AND (:P1_FLM = S.FLM OR :P1_FLM = '<All>') AND (:P1_REP = S.REP OR :P1_REP = '<All>')) 
GROUP BY Outcome ORDER BY CASE Outcome
WHEN 'Negative' THEN 1
WHEN 'Neutral' THEN 2
WHEN 'Pending' THEN 3
WHEN 'Positive' THEN 4 END




/*
///////
Interactions Type 
//////
*/
SELECT
COUNT(DISTINCT ACTIVITY_NUMBER) as Value,
Category,
CASE Category 
    WHEN 'Outreach - Other' THEN 1
    WHEN 'Outreach - Phone' THEN 2
    WHEN 'Outreach - Email' THEN 3
    WHEN 'Outreach - Social' THEN 4
    WHEN 'Conversation - Phone' THEN 5
    WHEN 'Conversation - Email' THEN 6
    WHEN 'Conversation - Social' THEN 7
    WHEN 'Conversation - Other' THEN 8
    WHEN 'Meeting' THEN 9
    WHEN 'Demo' THEN 10 
END AS OrderCatergory
FROM(
    SELECT 
ACTIVITY_NUMBER, 
CASE
    WHEN GROUP_CAT = 'Demo' AND Category = 'Phone' THEN 'Demo - Phone'
    WHEN GROUP_CAT = 'Demo' AND Category = 'Email' THEN 'Demo - Email'
    WHEN GROUP_CAT = 'Demo' AND Category = 'Social' THEN 'Demo - Social'
    WHEN GROUP_CAT = 'Demo' AND Category = 'Meeting' THEN 'Demo - Meeting'
    WHEN GROUP_CAT = 'Demo' AND Category = 'Demo' THEN 'Demo'
    WHEN GROUP_CAT = 'Demo' AND Category = 'Other' THEN 'Demo - Other'

    WHEN GROUP_CAT = 'Meeting' AND Category = 'Phone' THEN 'Meeting - Phone'
    WHEN GROUP_CAT = 'Meeting' AND Category = 'Email' THEN 'Meeting - Email'
    WHEN GROUP_CAT = 'Meeting' AND Category = 'Social' THEN 'Meeting - Social'
    WHEN GROUP_CAT = 'Meeting' AND Category = 'Meeting' THEN 'Meeting'
    WHEN GROUP_CAT = 'Meeting' AND Category = 'Demo' THEN 'Meeting - Demo'
    WHEN GROUP_CAT = 'Meeting' AND Category = 'Other' THEN 'Meeting - Other'
    
    WHEN GROUP_CAT = 'Outreach' AND Category = 'Phone' THEN 'Outreach - Phone'
    WHEN GROUP_CAT = 'Outreach' AND Category = 'Email' THEN 'Outreach - Email'
    WHEN GROUP_CAT = 'Outreach' AND Category = 'Social' THEN 'Outreach - Social'
    WHEN GROUP_CAT = 'Outreach' AND Category = 'Outreach' THEN 'Outreach - Outreach'
    WHEN GROUP_CAT = 'Outreach' AND Category = 'Demo' THEN 'Outreach - Demo'
    WHEN GROUP_CAT = 'Outreach' AND Category = 'Other' THEN 'Outreach - Other'

    WHEN GROUP_CAT = 'Conversation' AND Category = 'Phone' THEN 'Conversation - Phone'
    WHEN GROUP_CAT = 'Conversation' AND Category = 'Email' THEN 'Conversation - Email'
    WHEN GROUP_CAT = 'Conversation' AND Category = 'Social' THEN 'Conversation - Social'
    WHEN GROUP_CAT = 'Conversation' AND Category = 'Conversation' THEN 'Conversation - Conversation'
    WHEN GROUP_CAT = 'Conversation' AND Category = 'Demo' THEN 'Conversation - Demo'
    WHEN GROUP_CAT = 'Conversation' AND Category = 'Other' THEN 'Conversation - Other'
END AS Category

FROM(SELECT 
ACTIVITY_NUMBER,
CASE
    WHEN ACTIVITY_TYPE IN ('Demo','Demo - In Person') THEN 'Demo'
    WHEN ACTIVITY_TYPE IN ('Intro Meeting','Intro Meeting - In Person','Meeting','Meeting - In Person','Discovery','Discovery - In Person','Events, Workshops') THEN 'Meeting' 
    WHEN ACTIVITY_TYPE NOT IN ('Intro Meeting','Intro Meeting - In Person','Meeting','Meeting - In Person','Discovery','Discovery - In Person','Events, Workshops','Demo','Demo - In Person') AND OUTCOME_CODE NOT IN 
    ('Positive (customer interested)','Positive (meeting scheduled)','Positive (SE Trial)','Positive (Trial Offered)','Negative (customer not interested)','Neutral (customer undecided)') THEN 'Outreach'
    WHEN ACTIVITY_TYPE NOT IN ('Intro Meeting','Intro Meeting - In Person','Meeting','Meeting - In Person','Discovery','Discovery - In Person','Events, Workshops','Demo','Demo - In Person') AND OUTCOME_CODE IN 
    ('Positive (customer interested)','Positive (meeting scheduled)','Positive (SE Trial)','Positive (Trial Offered)','Negative (customer not interested)','Neutral (customer undecided)') THEN 'Conversation'
    WHEN ACTIVITY_TYPE NOT IN ('Intro Meeting','Intro Meeting - In Person','Meeting','Meeting - In Person','Discovery','Discovery - In Person','Events, Workshops','Demo','Demo - In Person') AND OUTCOME_CODE IS NULL THEN 'Outreach'
    ELSE 'error' 
END as GROUP_CAT,
CASE
    WHEN ACTIVITY_TYPE IN ('Phone Call - Inbound','Phone Call - Outbound','Manual Call - Outbound') THEN 'Phone'
    WHEN ACTIVITY_TYPE IN ('Email - Inbound','Email - Outbound','Email - Outlook','Eloqua Engage') THEN 'Email'
    WHEN ACTIVITY_TYPE IN ('Social Media','Sales Chat') THEN 'Social'
    WHEN ACTIVITY_TYPE IN ('Intro Meeting','Intro Meeting - In Person','Meeting','Meeting - In Person','Discovery','Discovery - In Person','Events, Workshops') THEN 'Meeting' 
    WHEN ACTIVITY_TYPE IN ('Demo','Demo - In Person') THEN 'Demo'
    Else 'Other' 
FROM catalincostin.fy20_interactions I 
LEFT JOIN FLM_SALES S on S.REP = I.EMAIL_ADDRESS
WHERE LEAD_CAMPAIGN_CODE = :P3_CODE AND (:P1_VP = S.VP OR :P1_VP = '<All>') AND (:P1_DIR = S.DIR OR :P1_DIR = '<All>') AND (:P1_FLM = S.FLM OR :P1_FLM = '<All>') AND (:P1_REP = S.REP OR :P1_REP = '<All>')))
GROUP BY Category
ORDER BY OrderCatergory




/*
///////
Interactions Persona
//////
*/
SELECT 
COUNT(DISTINCT ACTIVITY_NUMBER) as Value, 
Persona
FROM(SELECT 
ACTIVITY_NUMBER,
CASE 
    WHEN 
        LOWER(CONTACT_JOB_TITLE) LIKE '%finance%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%cfo%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%controller%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%chief executive%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%accounting%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%payroll%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%finance - chief accounting officer%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%finance - controller%' THEN 'Finance' 
    WHEN
        LOWER(CONTACT_JOB_TITLE) LIKE '%hr - chro / head of hr%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%hr - head of hr systems%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%hr - head of recruiting%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%hr - head of talent management%' THEN 'HR'
    WHEN
        LOWER(CONTACT_JOB_TITLE) LIKE '%it%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%network%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%information%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%web%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%development%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%intelligence%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%software%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%database%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%tech%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%cio%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%erp%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%systems%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%leiter%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%sql%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%dba%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%head of it%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%ecommerce%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%(it)%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%admin%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%base de datos%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%jde%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%epm%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%hcm%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%data%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%it - chief security officer%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%it - cio%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%it - head of erp applications%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%it - head of hr systems%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%it - head of sales systems%' THEN 'IT'
    WHEN
        LOWER(CONTACT_JOB_TITLE) LIKE '%ceo%' THEN 'CEO'
    WHEN
        LOWER(CONTACT_JOB_TITLE) LIKE '%marketing%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%mktng%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%cmo%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%mktg - cmo / head of marketing%' THEN 'Marketing'
    WHEN
        LOWER(CONTACT_JOB_TITLE) LIKE '%procurement%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%purchasing%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%buyer%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%procurement - chief procurement officer%' THEN 'Procurement'
    WHEN
        LOWER(CONTACT_JOB_TITLE) LIKE '%sales%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%social%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%service%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%sales - head of commerce%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%sales - head of sales operations%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%sales - svp / head of sales%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%service - svp / head of service%' OR
        LOWER(CONTACT_JOB_TITLE) LIKE '%social - svp/vp/dir digital%' THEN 'Sales'
    ELSE 'Unspecified' END AS Persona
FROM catalincostin.fy20_interactions I 
LEFT JOIN FLM_SALES S on S.REP = I.EMAIL_ADDRESS
WHERE LEAD_CAMPAIGN_CODE = :P3_CODE AND (:P1_VP = S.VP OR :P1_VP = '<All>') AND (:P1_DIR = S.DIR OR :P1_DIR = '<All>') AND (:P1_FLM = S.FLM OR :P1_FLM = '<All>') AND (:P1_REP = S.REP OR :P1_REP = '<All>')) 
GROUP BY Persona



