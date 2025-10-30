-- PROJECT MINERVA: PATIENT RISK ANALYSIS DATA SETUP
CREATE DATABASE patientrisk;

USE  patientrisk;


DROP TABLE IF EXISTS visits;
DROP TABLE IF EXISTS patients;


CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    age INT,
    gender VARCHAR(10),
    region VARCHAR(50)
);


CREATE TABLE visits (
    visit_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    diagnosis_code VARCHAR(10), 
    admission_date DATE NOT NULL,
    readmission_flag VARCHAR(1) NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);


INSERT INTO patients (patient_id, patient_name, age, gender, region) VALUES
(1001, 'Ada Lovelace', 72, 'F', 'North'), 
(1002, 'Charles Babbage', 45, 'M', 'South'),
(1003, 'Grace Hopper', 68, 'F', 'East'), 
(1004, 'Alan Turing', 35, 'M', 'West'),
(1005, 'Katherine Johnson', 78, 'F', 'North'), 
(1006, 'John von Neumann', 55, 'M', 'East'),
(1007, 'Hedy Lamarr', 81, 'F', 'West'), 
(1008, 'Max Planck', 30, 'M', 'South'),
(1009, 'Marie Curie', 60, 'F', 'North'),
(1010, 'Nikola Tesla', 75, 'M', 'East'); 


INSERT INTO visits (patient_id, diagnosis_code, admission_date, readmission_flag) VALUES
(1001, 'C123', '2025-05-01', 'Y'), 
(1003, 'R456', '2025-05-10', 'Y'), 
(1005, 'S789', '2025-05-20', 'N'),
(1007, 'C123', '2025-06-01', 'Y'),
(1010, 'R456', '2025-06-15', 'N'),
(1002, 'S789', '2025-07-01', 'N'),
(1004, 'T101', '2025-07-10', 'N'),
(1006, 'R456', '2025-07-20', 'N'),
(1008, 'C123', '2025-08-01', 'N'),
(1009, 'T101', '2025-08-10', 'N'),
(1001, 'C123', '2025-09-01', 'Y'), 
(1003, 'R456', '2025-09-10', 'N');


-- Task 1: Calculate the Readmission Rate for all patients over 65 years old
SELECT
    COUNT(DISTINCT p.patient_id) AS total_elderly_patients,
    COUNT(v.visit_id) AS total_elderly_visits,
    COUNT(CASE WHEN v.readmission_flag = 'Y' THEN 1 END) AS readmitted_elderly_visits,
    ROUND(
        COUNT(CASE WHEN v.readmission_flag = 'Y' THEN 1 END) * 100.0 / COUNT(v.visit_id),
        2
    ) AS elderly_readmission_rate
FROM patients AS p
INNER JOIN visits AS v
    ON p.patient_id = v.patient_id
WHERE p.age >= 65;


-- Task 2: High-Volume Regional Hotspots
SELECT 
    p.region AS region,
    COUNT(v.visit_id) AS total_visits
FROM patients AS p
INNER JOIN visits AS v
    ON p.patient_id = v.patient_id
GROUP BY p.region
ORDER BY total_visits DESC;


-- Task 3: Identify the Highest-Risk Demographic (Elderly in North and East)
SELECT
    COUNT(v.visit_id) AS total_elderly_visits,
    COUNT(CASE WHEN v.readmission_flag = 'Y' THEN 1 END) AS readmitted_elderly_visits,
    ROUND(
        COUNT(CASE WHEN v.readmission_flag = 'Y' THEN 1 END) * 100.0 / COUNT(v.visit_id),
        2
    ) AS elderly_readmission_rate
FROM patients AS p
INNER JOIN visits AS v
    ON p.patient_id = v.patient_id
WHERE p.age >= 65
  AND p.region IN ('North', 'East');
