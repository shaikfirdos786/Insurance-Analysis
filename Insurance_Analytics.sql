-- STEP 1 : CREATE DATABASE
CREATE DATABASE insurance_db;
USE insurance_db;
commit;

-- STEP 2: Customer Information
CREATE TABLE Customer_Info (
    Customer_ID VARCHAR(30) PRIMARY KEY COMMENT 'Unique customer identifier',
    Name VARCHAR(50) NOT NULL COMMENT 'Full name of the customer',
    Gender ENUM('Male', 'Female', 'Other') COMMENT 'Gender of the customer',
    Age INT COMMENT 'Age of the customer',
    Occupation VARCHAR(100) COMMENT 'Customer occupation or profession',
    Marital_Status VARCHAR(50) COMMENT 'Marital status of the customer',
    Address VARCHAR(100) COMMENT 'Residential address of the customer'
);


-- STEP 2: Policy_Data 
CREATE TABLE Policy_Data (
	Policy_ID VARCHAR(30) PRIMARY KEY,
    Policy_Type VARCHAR(50) NOT NULL,
    Coverage_Amount DECIMAL(12,2) NOT NULL,
    Premium_Amount DECIMAL(12,2) NOT NULL,
    Policy_Start_Date DATE,
    Policy_End_Date DATE,
    Payment_Frequency VARCHAR(50),
    Status VARCHAR(50),
    Customer_ID VARCHAR(30) NOT NULL
);
    
-- STEP 3: Claims
CREATE TABLE Claims (
    Claim_ID VARCHAR(30) PRIMARY KEY COMMENT 'Unique claim identifier',
    Date_Of_Claim DATE COMMENT 'Date when the claim was filed',
    Claim_Amount DECIMAL(12,2) COMMENT 'Total claim amount requested',
    Claim_Status VARCHAR(30) COMMENT 'Status of the claim (e.g., Pending, Approved, Rejected)',
    Policy_ID VARCHAR(30) COMMENT 'Associated policy under which the claim is made',
    FOREIGN KEY (Policy_ID) REFERENCES Policy_Data(Policy_ID)
);


-- STEP 4: Payments
CREATE TABLE Payments (
    Payment_ID VARCHAR(30) PRIMARY KEY COMMENT 'Unique payment identifier',
    Date_Of_Payment DATE COMMENT 'Date when the payment was made',
    Amount_Paid DECIMAL(12,2) COMMENT 'Amount paid by the policyholder',
    Payment_Method VARCHAR(30) COMMENT 'Mode of payment (e.g., Cash, Credit, Online)',
    Payment_Status VARCHAR(30) COMMENT 'Current payment status (e.g., Successful, Failed, Pending)',
    Policy_ID VARCHAR(30) COMMENT 'Policy linked to this payment',
    FOREIGN KEY (Policy_ID) REFERENCES Policy_Data(Policy_ID)
);

-- STEP 5: Individual_Budget (Account Executive Master)
CREATE TABLE Individual_Budget (
    Account_Exe_ID INT PRIMARY KEY COMMENT 'Unique ID of the Account Executive',
    Account_Executive VARCHAR(50) NOT NULL COMMENT 'Name of the Account Executive',
    New_Role VARCHAR(50) COMMENT 'Role or designation of the Account Executive',
    New_Budget DECIMAL(12,2) COMMENT 'Budget allocated for new business',
    Renewal_Budget DECIMAL(12,2) COMMENT 'Budget allocated for policy renewals',
    Cross_Sell_Budget DECIMAL(12,2) COMMENT 'Budget allocated for cross-sell opportunities',
    Branch VARCHAR(50) COMMENT 'Branch name associated with the Account Executive'
);

SET GLOBAL max_allowed_packet = 268435456;  -- 256 MB
SET GLOBAL net_read_timeout = 600;
SET GLOBAL net_write_timeout = 600;
SET GLOBAL wait_timeout = 600;



-- STEP 6: Brokerage
CREATE TABLE Brokerage (
    Brokerage_ID INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique brokerage record identifier',
    Client_Name VARCHAR(50) COMMENT 'Name of the client',
    Policy_Number VARCHAR(100) COMMENT 'Policy number (can repeat for different transactions)',
    Policy_Status VARCHAR(50) COMMENT 'Current status of the policy',
    Policy_Start_Date DATE COMMENT 'Start date of the policy',
    Policy_End_Date DATE COMMENT 'End date of the policy',
    Product_Group VARCHAR(50) COMMENT 'Category or type of product',
    Account_Exe_ID INT COMMENT 'References Individual_Budget table',
    Account_Executive VARCHAR(50) COMMENT 'Name of the account executive handling the client',
    Solution_Group VARCHAR(100) COMMENT 'Solution group under which the policy falls',
    Income_Class VARCHAR(50) COMMENT 'Class of income (e.g., New, Renewal, Cross Sell)',
    Amount DECIMAL(12,2) COMMENT 'Amount associated with brokerage transaction',
    Branch VARCHAR(50) COMMENT 'Branch associated with the record',
    FOREIGN KEY (Account_Exe_ID) REFERENCES Individual_Budget(Account_Exe_ID)
);


-- STEP 7: Fees
CREATE TABLE Fees (
    Client_Name VARCHAR(50) PRIMARY KEY COMMENT 'Name of the client associated with the fee record',
    Solution_Group VARCHAR(100) COMMENT 'Solution group or service category',
    Account_Exe_ID INT COMMENT 'References Individual_Budget table',
    Account_Executive VARCHAR(50) COMMENT 'Name of the Account Executive handling the client',
    Income_Class VARCHAR(50) COMMENT 'Income classification (e.g., New, Renewal, Cross Sell)',
    Amount DECIMAL(12,2) COMMENT 'Fee amount billed to the client',
    Income_Due_Date DATE COMMENT 'Due date for the income or fee payment',
    Revenue_Transaction_Type VARCHAR(50) COMMENT 'Type of revenue transaction (e.g., Fee, Brokerage, Service)',
    Branch VARCHAR(50) COMMENT 'Branch name associated with this fee record',
    FOREIGN KEY (Account_Exe_ID) REFERENCES Individual_Budget(Account_Exe_ID)
);

-- STEP 8: Invoice
CREATE TABLE Invoice (
    Invoice_Number INT PRIMARY KEY COMMENT 'Unique invoice identifier',
    Invoice_Date DATE COMMENT 'Date when the invoice was generated',
    Revenue_Transaction_Type VARCHAR(50) COMMENT 'Type of revenue transaction (e.g., Brokerage, Fee, Other)',
    Branch VARCHAR(50) COMMENT 'Branch associated with the invoice',
    Solution_Group VARCHAR(100) COMMENT 'Solution group or service category',
    Account_Exe_ID INT COMMENT 'References Individual_Budget table',
    Account_Executive VARCHAR(50) COMMENT 'Name of the Account Executive responsible for the transaction',
    Income_Class VARCHAR(50) COMMENT 'Income classification (New, Renewal, Cross Sell)',
    Client_Name VARCHAR(50) COMMENT 'Name of the client billed in this invoice',
    Policy_Number VARCHAR(100) COMMENT 'Linked policy number for the billed service',
    Amount DECIMAL(12,2) COMMENT 'Invoice amount billed to the client',
    Income_Due_Date DATE COMMENT 'Due date for receiving payment on the invoice',
    FOREIGN KEY (Account_Exe_ID) REFERENCES Individual_Budget(Account_Exe_ID)
);

-- STEP 9: Meeting
CREATE TABLE Meeting (
    Meeting_ID INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique meeting identifier',
    Account_Exe_ID INT COMMENT 'References Individual_Budget table',
    Account_Executive VARCHAR(50) COMMENT 'Name of the Account Executive conducting the meeting',
    Branch VARCHAR(50) COMMENT 'Branch associated with the meeting',
    Meeting_Date DATE NOT NULL COMMENT 'Date when the meeting took place',
    Global_Attendees TEXT COMMENT 'Names of global participants attending the meeting',
    FOREIGN KEY (Account_Exe_ID) REFERENCES Individual_Budget(Account_Exe_ID)
);

-- STEP 10: Opportunity
CREATE TABLE Opportunity (
    Opportunity_ID VARCHAR(50) PRIMARY KEY COMMENT 'Unique identifier for each opportunity',
    Opportunity_Name VARCHAR(100) COMMENT 'Name or title of the opportunity',
    Account_Exe_ID INT COMMENT 'References Individual_Budget table',
    Account_Executive VARCHAR(50) COMMENT 'Name of the Account Executive handling the opportunity',
    Premium_Amount DECIMAL(12,2) COMMENT 'Total premium amount associated with the opportunity',
    Revenue_Amount DECIMAL(12,2) COMMENT 'Expected revenue amount from the opportunity',
    Closing_Date DATE COMMENT 'Expected closing date for the opportunity',
    Stage VARCHAR(100) COMMENT 'Current stage of the opportunity (e.g., Qualify, Propose Solution, Won, Lost)',
    Branch VARCHAR(50) COMMENT 'Branch handling the opportunity',
    Speciality VARCHAR(100) COMMENT 'Specialization or focus area related to the opportunity',
    Product_Group VARCHAR(100) COMMENT 'Product group related to the opportunity',
    Product_Sub_Group VARCHAR(100) COMMENT 'Sub-group of the product for more detailed classification',
    Risk_Details VARCHAR(100) COMMENT 'Risk-related information about the opportunity',
    FOREIGN KEY (Account_Exe_ID) REFERENCES Individual_Budget(Account_Exe_ID)
);

-- -----------------------------------------------------------------  POLICY DASHBOARD --------------------------------------------------------------------

-- 1: Total Policy
SELECT COUNT(DISTINCT Policy_ID) FROM Policy_Data;

-- 2: Total Customers
SELECT COUNT(DISTINCT Customer_ID) FROM Policy_Data;

-- 3: Age Bucket Wise Policy Count
SELECT 
	CASE
		WHEN c.Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN c.Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN c.Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN c.Age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+'
	END AS Age_Bucket,
    COUNT(p.Policy_ID) AS Policy_Count
FROM Policy_Data p 
JOIN Customer_Info c
	ON p.Customer_ID = c.Customer_ID
GROUP BY Age_Bucket
ORDER BY
	CASE 
		WHEN Age_Bucket = '18-25' THEN 1
        WHEN Age_Bucket = '26-35' THEN 2
        WHEN Age_Bucket = '36-45' THEN 3
        WHEN Age_Bucket = '46-60' THEN 4
        ELSE 5
	END;

-- 4: Gender Wise Policy Count
SELECT c.Gender, COUNT(p.Policy_ID) AS Policy_Count
FROM Policy_Data p 
JOIN Customer_Info c 
	ON p.Customer_ID = c.Customer_ID
GROUP BY c.Gender
ORDER BY Policy_Count DESC;

-- 5: Policy Type Wise Policy Count
SELECT Policy_Type, COUNT(Policy_ID) AS Policy_Count
FROM Policy_Data
GROUP BY Policy_Type
ORDER BY Policy_Count DESC;

-- 6: Count of Policy Expire This Year
SELECT COUNT(Policy_ID) AS Expiring_Policy_Count
FROM Policy_Data
WHERE YEAR(Policy_End_Date) = YEAR(CURDATE());

-- 7: Premium Growth Rate
SELECT 
    YEAR(Policy_Start_Date) AS Year,
    SUM(Premium_Amount) AS Total_Premium,
    ROUND(
        (
            (
                SUM(Premium_Amount)
                - LAG(SUM(Premium_Amount)) OVER (ORDER BY YEAR(Policy_Start_Date))
            ) /
            LAG(SUM(Premium_Amount)) OVER (ORDER BY YEAR(Policy_Start_Date))
        ) * 100
    ,2) AS Premium_Growth_Rate_Percentage
FROM Policy_Data
GROUP BY YEAR(Policy_Start_Date)
ORDER BY Year;


-- 8: Claim Status Wise Policy Count
SELECT Claim_Status, COUNT(Policy_ID) AS Policy_Count
FROM Claims
GROUP BY Claim_Status
ORDER BY Policy_Count DESC;


-- 9: Payment Status Wise Policy Count
SELECT Payment_Status, COUNT(Payment_ID) AS Policy_Count
FROM Payments
GROUP BY Payment_Status
ORDER BY Policy_Count DESC;

-- 10: Total Claim Amount
SELECT SUM(Claim_Amount) AS Total_Claim_Amount
FROM Claims
WHERE Claim_Status = 'Approved';