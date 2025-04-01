create database employee;
use employee;
select * from data_science_team;
select * from emp_record_table;
select * from proj_table;

-- TASK 3
select emp_id, first_name, last_name, gender, dept 
	from emp_record_table
	order by dept;
    
-- TASK 4
select emp_id, first_name, last_name, gender, dept, emp_rating,
	caseemployees
		when emp_rating < 2 then 'Less than 2'
        when emp_rating > 4 then 'Greater than 4'
        else 'Between 2 and 4'
	end as Rating_Status
	from emp_record_table;
    
-- TASK 5
select concat(first_name,' ',last_name) as Name from emp_record_table where dept='Finance';

-- TASK 6
select m.first_name, m.Role, e.first_name,
	count(*) over(partition by m.first_name)
    from emp_record_table e join emp_record_table m
    on e.manager_id=m.emp_id;
    
-- TASK 7
select * from emp_record_table where dept='Finance'
UNION
select * from emp_record_table where dept='Healthcare';

-- TASK 8
select emp_id, first_name, last_name, role, dept, emp_rating,
	max(emp_rating) over(partition by dept) MAX_Rating
     from emp_record_table;

-- TASK 9
select role, min(salary) Min_salary, max(salary) Max_salary from emp_record_table
	group by role;

-- TASK 10
select *, rank() over(order by exp desc) from emp_record_table;

-- TASK 11
create view V_Emp_above6k
as
select emp_id, first_name, last_name, salary, country from emp_record_table
where salary > 6000
	order by Country;

select * from V_Emp_above6k;

-- TASK 12
select * from emp_record_table where emp_id in (select emp_id from emp_record_table where exp > 10);

-- TASK 13
/*
Creating stored procedures
select * from emp_record_table where exp > 3;
*/
USE `employee`;
DROP procedure IF EXISTS `Emp_Above3yrsExp`;

USE `employee`;
DROP procedure IF EXISTS `employee`.`Emp_Above3yrsExp`;
;

DELIMITER $$
USE `employee`$$
CREATE PROCEDURE Emp_Above3yrsExp()
BEGIN
	select * from emp_record_table where exp > 3;
END$$

DELIMITER ;
;

call Emp_Above3yrsExp();

-- TASK 14
USE `employee`;
DROP function IF EXISTS `Check_JobProfiles`;

DELIMITER $$
USE `employee`$$
CREATE FUNCTION Check_JobProfiles (eid varchar(5))
RETURNS varchar(100)
deterministic
BEGIN
declare ex int;
declare r varchar(80);
declare vrole varchar(100);
declare flag varchar(100);
select exp, role into ex, vrole from data_science_team where emp_id = eid;
	if ex > 12 and ex < 16 then
		if vrole='Manager' then 
			set flag = 'yes';
		else
			set flag = 'No';
		end if;
        # set r = 'Manager';
	elseif ex > 10 and ex <= 12 then
		if vrole = 'LEAD DATA SCIENTIST' then 
			set flag = 'Yes';
		else
			set flag = 'No';
		end if;
        # set r = 'LEAD DATA SCIENTIST';
	elseif ex > 5 and ex <= 10 then
		if vrole = 'SENIOR DATA SCIENTIST' then
			set flag = 'Yes';
		else
			set flag = 'No';
		end if;
	elseif ex > 2 and ex <=5 then
		if vrole = 'ASSOCIATE DATA SCIENTIST' then
			set flag = 'Yes';
		else
			set flag = 'No';
		end if;
	elseif ex <= 2 then
		if vrole = 'JUNOIR DATA SCIENTIST' then
			set flag = 'YES';
		else
			set flag = 'No';
		end if;
	end if;
RETURN flag;
END$$

DELIMITER ;

select *, Check_JobProfiles (Emp_id) from data_science_team;

-- TASK 15
select * from emp_record_table where first_name='eric';
create index idx_fname on emp_record_table(first_name);

-- TASK 16
select emp_id, first_name, last_name, salary, emp_rating,
	salary * 0.05 * emp_rating as bonus
	from emp_record_table;

-- TASK 17
select continent, country, avg(salary) from emp_record_table
	group by continent, country with rollup;