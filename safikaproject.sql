use project;
create table employee;
insert into employee(empid,ename,gender,salary,city) 
values(5,'Safika Parween','Female',252000,'Miami');

create table employeeDetails;
insert into employeeDetails(empid,projects,empposition,doj)
values(5,'P2','Engineer','2022-01-30');

select * from employee;
select * from employeeDetails;
--1.(a)--
select*from employee
where salary between 200000 and 300000;

--(b)--
select ename from employee 
where city=(select city from employee group by city  having count(city)>1);

--(c)--
select*from employee
where city is null;

--2.(a)--
select empid,ename,salary,sum(salary) over(order by empid) as cumulative_salary 
from employee;

--(b)--
select gender,count(*)
from employee group by gender;

--(c)--
select* from employee 
where empid<=(select count(*)/2 from employee);

--3.--
select salary,
concat(substring(str(salary),1,len(str(salary))-2),'xx')as maskedno
from employee;

--4.--
--Odd rows--
select*from
      (select*,ROW_NUMBER()over(order by empid)as rownumber
	   from employee) as emp 
where emp.rownumber%2=1;
--even rows--
select*from
       (select*,ROW_NUMBER()over(order by empid)as rownumber
	    from employee) as emp
where emp.rownumber%2=0;

--5.--
 select empid,ename,salary from
(select empid,ename, salary,ROW_NUMBER() over (order by salary) as rownumber from employee) as temp where rownumber=3;


--6.(a)--
select empid,ename,gender,salary,city,
count(*) as duplicate_count
from employee 
group by empid,ename,gender,salary,city 
having count(*)>1;


create view cc2 as select empid,row_number() over(partition by empid order by empid)as t from employee;

delete from cc2
where t >1;
select * from cc2;

--(b)--
select projects,STRING_AGG(ename, ',') as employees from employeeDetails ed inner join employee on employee.empid=ed.empid group by ed.projects;

 --7.--
select projects,max(salary) as projectsale 
from employee
inner join employeeDetails 
on employee.empid=employeeDetails.empid
group by projects
order by projectsale desc;

--8.--
with cc as(
select datepart(year, doj) as joinyear 
from employee 
inner join employeeDetails
on employee.empid=employeeDetails.empid )
select joinyear,count(*) as totalemp from cc group by joinyear;
 

--9.--
select ename,salary,
case when salary>60000 then 'high'
     when salary>=55000 and salary<=60000 then 'medium' 
	 else 'low'
end as salarystatus 
from employee;
