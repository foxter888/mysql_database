use ps_devcamp_university_schema;










-- 100 STUDENTS

DELIMITER $$
DROP PROCEDURE IF EXISTS students_data$$
CREATE PROCEDURE students_data()
BEGIN
	DECLARE i INT default 1;
    WHILE i <= 100 DO
		INSERT INTO students (student_name)
        VALUES (CONCAT("Student", i));
        SET i = i + 1;
	END WHILE;
END$$;
DELIMITER ;
CALL students_data();
DROP PROCEDURE students_data;



-- professors data 
-- 10 PROFESSORS

DELIMITER $$
DROP PROCEDURE IF EXISTS professors_data$$
CREATE PROCEDURE professors_data()
BEGIN
	DECLARE y INT default 1;
    WHILE y <= 10 DO
		INSERT INTO professors (professors_name)
		VALUES (CONCAT("Professor", y));
		SET y = y + 1;
	END WHILE;
END$$
DELIMITER ;
CALL professors_data();
DROP PROCEDURE professors_data;


-- courses data
-- 20 COURSES
--  to get this to work i commented out the drop procedure if exists, didn't have my schema, didn't use cmd /

DELIMITER $$
-- DROP PROCEDURE IF EXISTS course_data$$
CREATE PROCEDURE course_data()
BEGIN
	DECLARE i INT default 1;
    WHILE i <= 20 DO
		INSERT INTO courses (course_name, course_professor_id)
        VALUES (
			CONCAT("Course", i),
            
			CEILING(RAND() * (SELECT COUNT(*) FROM professors))
        );
        SET i = i + 1;
	END WHILE;
END$$;
DELIMITER ;
CALL course_data();
DROP PROCEDURE course_data;

-- RUN THIS AFTER TO MAKE SURE THAT EACH PROFESSOR IS TEACHING A COURSE:
SELECT *
FROM courses
ORDER BY course_professor_id ASC;

-- INSERT INTO courses (course_name, course_professor_id)
-- VALUES("Course21", 7);


-- grades data RAN THIS 5 TIMES TO GET 500 GRADES!
DELIMITER $$
DROP PROCEDURE IF EXISTS grades_data$$
CREATE PROCEDURE grades_data()
BEGIN
	DECLARE i INT default 1;
	DECLARE foo INT default 1;
    WHILE i <= 100
		DO
			INSERT INTO grades (grade_value, grade_course_id, grade_student_id)
			VALUES (
				RAND()*100,
				CEILING(RAND() * (SELECT COUNT(*) FROM courses)),
				i
			);
		SET i = i + 1;
	END WHILE;
END$$;
DELIMITER ;
CALL grades_data();
DROP PROCEDURE grades_data;




-- in here is the proffesors average grade for each student
SELECT professors_name AS "Prof", AVG(grade_value) AS "Grade Value"
FROM courses
JOIN professors
ON courses.course_id = professor_id
JOIN grades
ON courses.course_id = grade_course_id
GROUP BY professors_name; 

-- students with max grade 
SELECT student_name AS "STD", MAX(grade_value) AS "Grade Value"
FROM students
JOIN grades
ON student_id = grade_student_id
GROUP BY student_name; 


-- group of studentd by the course they are enrolled in
SELECT student_name  , course_name 
FROM grades
JOIN courses
ON grades.grade_course_id = course_id
JOIN students
ON grades.grade_student_id  = student_id  
GROUP BY student_name; 


--  create a summary report of courses sorted by the most challenging to the easiest course
SELECT course_name , AVG(grade_value)
FROM courses
JOIN grades
ON courses.course_id = grades.grade_course_id
GROUP BY course_name;


-- xxx finding which proffesor has the same classes in comon 
SELECT student_name, course_name  , professors_name , COUNT(*)
FROM grades
JOIN students
ON grades.grade_student_id = student_id
JOIN courses
ON courses.course_id = grades.grade_course_id
JOIN professors
ON courses.course_id = professor_id
GROUP BY student_name;



-- top grades of each student 
SELECT  student_name ,MAX(grade_value)
FROM grades
JOIN students
ON grades.grade_student_id = student_id
GROUP BY student_name;  