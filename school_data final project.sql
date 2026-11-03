use school_data;

-- Guestion 1.Total enrolment for term 1
SELECT COUNT(DISTINCT student_id) AS total_enrolment
FROM enrolments
WHERE term_id = 'T1';

--- Students enrolled by 30 April 2026
SELECT COUNT(DISTINCT student_id) AS enrolled_by_april
FROM enrolments
WHERE enrolment_date <= '2026-04-30';

-- Total Student Enrolment (Term 1, 2026)
SELECT *
FROM enrolments
LIMIT 10;

-- Guestion 2. How many students are enrolled in each class
SELECT c.class_name, COUNT(DISTINCT e.student_id) AS total_students
FROM enrolments e
JOIN classes c
ON e.class_id = c.class_id
WHERE e.term_id = 'T1'
GROUP BY c.class_id, c.class_name
ORDER BY c.class_name;

-- Student Enrolment by Class (Term 1, 2026)
SELECT
    ROUND(
        SUM(CASE
            WHEN attendance_status = 'Present' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
2
) AS attendance_rate_percent
FROM attendance;

-- Guestion 3 – Overall Attendance Rate.
SELECT ROUND(
        SUM(CASE
            WHEN attendance_status = 'Present' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
2
) AS attendance_rate_percent
FROM attendance;

-- Guestion 4 – Which classes have the lowest attendance rate?
SELECT c.class_name, ROUND(
        SUM(CASE
            WHEN a.attendance_status = 'Present' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
2
) AS attendance_rate_percent
FROM attendance a
JOIN classes c
ON a.class_id = c.class_id
GROUP BY c.class_id, c.class_name
ORDER BY attendance_rate_percent ASC;

-- Guestion 5: How does attendance change from month to month?
SELECT DATE_FORMAT(attendance_date, '%Y-%m') AS attendance_month,
    ROUND(
        SUM(CASE
            WHEN attendance_status = 'Present' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
2
) AS attendance_rate_percent
FROM attendance
GROUP BY DATE_FORMAT(attendance_date, '%Y-%m')
ORDER BY attendance_month;

-- Guestion 6: How many students transferred or withdrew from school?
SELECT movement_type, COUNT(DISTINCT student_id) AS total_students
FROM student_movements
GROUP BY movement_type
ORDER BY total_students DESC;

-- Guestion 7: How does attendance compare between school terms?
SELECT term_id, ROUND(
        SUM(CASE
            WHEN attendance_status = 'Present' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
2
) AS attendance_rate_percent
FROM attendance
GROUP BY term_id
ORDER BY term_id;

-- Guestion 8: What data quality issues exist in the school dataset?
-- missing student information
SELECT *
FROM students
WHERE student_id IS NULL
   OR student_id = ''
   OR gender IS NULL
   OR gender = '';
   
   -- Check for duplicate student IDs
   SELECT student_id, COUNT(*) AS number_of_records
FROM students
GROUP BY student_id
HAVING COUNT(*) > 1;

-- Check for missing attendance information
SELECT *
FROM attendance
WHERE student_id IS NULL
   OR attendance_date IS NULL
   OR attendance_status IS NULL
   OR attendance_status = '';
   
-- Check missing attendance information
SELECT *
FROM attendance
WHERE student_id IS NULL
   OR attendance_date IS NULL
   OR attendance_status IS NULL
   OR attendance_status = '';



