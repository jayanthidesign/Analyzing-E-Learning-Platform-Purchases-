CREATE DATABASE E_learning;
USE E_learning;

CREATE TABLE learners (learner_id INT Primary Key ,
 full_name VARCHAR(50), 
 country VARCHAR(50));
 
CREATE TABLE courses (course_id INT Primary Key,
course_name VARCHAR(50) NOT NULL,
category VARCHAR(50),
unit_price DECIMAL(10,2));

CREATE TABLE purchases ( purchase_id INT Primary Key,
learner_id INT ,
course_id INT ,
Quantity INT,
purchase_date DATE ,
FOREIGN KEY (learner_id) REFERENCES learners(learner_id),
FOREIGN KEY (course_id) REFERENCES courses(course_id));

INSERT INTO learners (learner_id, full_name, Country) VALUES
(101, 'Sarah Antony', 'Russia'),
(102, 'Vineetha rao', 'India'),
(103, 'Yuki Tanaka', 'Japan'),
(104, 'Anura Sunil', 'Italy'),
(105, 'Sana Ahmed', 'Saudi Arabia');

INSERT INTO courses (course_id, course_name, category, unit_price) VALUES
(501, 'Generative AI for Leaders', 'AI and Machine Learning', 400.00),
(502, 'Machine Learning Specialization', 'AI and Machine Learning',570.00),
(503, 'Agentic AI Systems', 'AI and Machine Learning', 960.00),
(504, 'Advanced Python for Data Science', 'Data Science', 199.00),
(505, 'Cybersecurity Ethical Hacking', 'Cybersecurity', 360.00);

INSERT INTO purchases (purchase_id, learner_id, course_id, Quantity, purchase_date) VALUES
(1, 101, 502, 1, '2026-01-25'),
(2, 102, 501, 2, '2026-01-18'),
(3, 103, 503, 3, '2026-01-01'),
(4, 104, 505, 5, '2026-01-12'),
(5, 105, 501, 1, '2026-01-29'),
(6, 101, 504, 1, '2026-01-17');

--  Use aliases for column names 

SELECT course_name AS course_title
FROM courses;

-- 	Format currency values to 2 decimal places

SELECT purchase_id, 
ROUND(quantity * (SELECT unit_price FROM courses WHERE courses.course_id = purchases.course_id),2) 
AS total_amount
FROM purchases;

-- Sort results appropriately

SELECT course_name, unit_price FROM courses ORDER BY unit_price DESC;

-- Use SQL INNER JOIN, LEFT JOIN, and RIGHT JOIN 
-- To Combine learner, course, and purchase data.

SELECT l.learner_id, l.full_name, l.country, c.course_id, c.course_name, c.category, c.unit_price, p.purchase_id, p.quantity, p.purchase_date
FROM purchases p 
JOIN learners l ON p.learner_id = l.learner_id
JOIN courses c ON p.course_id = c.course_id;


-- 	Display each learner’s purchase details (course name, category, quantity, total amount, and purchase date)

SELECT l.full_name, c.course_name, c.category, p.quantity, 
    ROUND(c.unit_price * p.quantity, 2) AS total_amount, p.purchase_date
FROM learners l
JOIN purchases p ON l.learner_id = p.learner_id
JOIN courses c ON p.course_id = c.course_id
ORDER BY l.full_name;


-- Analytical Queries

-- Display each learner’s total spending (quantity × unit_price) along with their country.

SELECT l.full_name, 
    COALESCE(SUM(p.quantity * c.unit_price), 0) AS total_spending, l.country
FROM learners l
LEFT JOIN purchases p ON l.learner_id = p.learner_id
LEFT JOIN courses c ON p.course_id = c.course_id
GROUP BY l.full_name, l.country;

-- Find the top 3 most purchased courses based on total quantity sold.

SELECT c.course_name, SUM(p.quantity) AS total_quantity_sold
FROM courses c
JOIN purchases p ON c.course_id = p.course_id
GROUP BY c.course_name
ORDER BY total_quantity_sold DESC
LIMIT 3;

-- Show each course category’s total revenue and the number of unique learners who purchased from that category.


SELECT c.category, SUM(c.unit_price * p.Quantity) AS total_revenue, COUNT(DISTINCT l.learner_id) AS unique_learners 
FROM courses c
JOIN purchases p ON c.course_id = p.course_id
JOIN learners l ON p.learner_id = l.learner_id
GROUP BY c.category
ORDER BY total_revenue DESC;

-- List all learners who have purchased courses from more than one category.

SELECT l.learner_id, l.full_name, COUNT(DISTINCT c.category) AS category_count 
FROM learners l 
JOIN purchases p ON l.learner_id = p.learner_id
JOIN courses c ON  p.course_id = c.course_id
GROUP BY l.learner_id, l.full_name
HAVING COUNT(DISTINCT c.category) > 1;


--  Identify courses that have not been purchased at all.

SELECT course_id, course_name, category, unit_price
FROM courses 
WHERE course_id NOT IN (select course_id from courses) ;


-- Find the learner who has spent the highest total amount across all purchases.

SELECT l.full_name, SUM(c.unit_price * p.quantity) AS highest_total_amount
 FROM learners l
 JOIN purchases p ON l.learner_id = p.learner_id
 JOIN courses c ON p.course_id = c.course_id
 GROUP BY l.full_name
 ORDER BY highest_total_amount DESC
 LIMIT 1;
 
 
-- Calculate the average amount spent per purchase for learners from each country.

SELECT l.country, ROUND(AVG(c.unit_price * p.quantity),2) AS average_amount
 FROM learners l
 JOIN purchases p ON l.learner_id = p.learner_id
 JOIN courses c ON p.course_id = c.course_id
 GROUP BY l.country;
 
 







