-- mysql root계정에서 데이터베이스 생성
create database mysql_study default character set utf8;

-- 해당 데이터베이스를 사용할 사용자 추가 (mysql은 localhost와 다른 호스트를 구분하기 때문에 로컬용과 외부용을 각각 생성)
create user 'mysql_study'@'localhost' identified by 'rootroot'; -- 로컬에서 접속
create user 'mysql_study'@'%' identified by 'rootroot'; -- 외부에서 접속

-- 권한 부여
grant all privileges on mysql_study.* to 'mysql_study'@'localhost' identified by 'rootroot';
grant all privileges on mysql_study.* to 'mysql_study'@'%' identified by 'rootroot';


-- 부서 테이블 생성
create table department (
	deptno int(11) not null,
	deptname char(10),
	floor int(11) default 0,
	primary key (deptno)
);

-- 사원 테이블 생성
create table employee (
	empno int(11) not null,
	empname varchar(20) not null,
	title varchar(10) default '사원',
	manager int(11),
	salary int(11),
	dno int(11) default 1
);

-- 제약조건 추가
alter table employee add constraint primary key(empno);
alter table employee add constraint fk_employee_manager foreign key(manager) references employee(empno);
alter table employee add constraint fk_employee_dno foreign key(dno) references department(deptno)
on delete no action 
on update cascade;

-- 제약조건 확인
select * from information_schema.table_constraints;
desc information_schema.table_constraints;

-- 테이블 정보 보기
desc employee;

-- 데이블 속성 변경
alter table employee rename to emp;   -- 테이블 이름 변경 --
alter table emp rename to employee;

alter table employee add column phone char(13);  -- 컬럼 추가 --
alter table employee drop column phone;          -- 컬럼 삭제 --
alter table employee add column phone char(13) first;

alter table employee change column empname name char(30);		
alter table employee modify column title char(10);		
alter table employee change column name empname varchar(20);	-- 컬럼 명, 타입 변경 --


-- 데이터 삽입
insert into department values
(1, '영업', 8),
(2, '기획', 10),
(3, '개발', 9),
(4, '총무', 7);

-- 삽입순서 중요 (외래키 관계)
insert into employee values
(4377, '이성래', '사장', null, 5000000, 2),
(3426, '박영권', '과장', 4377, 3000000, 1),
(3011, '이수민', '부장', 4377, 4000000, 3),
(1003, '조민희', '과장', 4377, 3000000, 2),
(3427, '최종철', '사원', 3011, 1500000, 3),
(1365, '김상원', '사원', 3426, 1500000, 1),
(2106, '김창섭', '대리', 1003, 2500000, 2);

-- CRUD
insert into department(deptno, deptname) values (5, '연구');

delete from department where deptno = 5;

update employee set dno=3, salary=salary*1.05 where empno=2106;

-- case
select empname, title,
	case
		when salary >= 4000000 then '3시퇴근'
		when salary >= 3000000 then '5시퇴근'
		when salary >= 2000000 then '7시퇴근'
		else '야근'
	end as '퇴근시간', salary
from employee;

select distinct title from employee;  -- distinct
select all title from employee;  -- all


-- 조민희가 속힌 부서명을 검색하시오. "중첩질의"
select deptname
from department
where deptno = (select dno from employee where empname='조민희');


-- 부서별 급여 평균
select dno, avg(salary) '급여평균'
from employee
group by dno;


-- 부서별 급여평균이 300만 이상인 부서의 평균과 부서번호를 출력하시오. / having절은  group by절과 함께 사용해야 한다.
select dno as 부서, avg(salary)  '급여평균'
from employee
group by dno
having avg(salary)>=3000000
order by dno desc;


-- join
create table test_A(
	idx int(1),
	ch char(1)
);

insert into test_A values (1,'a'), (2,'b');
	
	
create table test_B(
	idx int(1),
	txt char(1)
);

insert into test_B values (1,'가'),(2,'나'),(3,'다');


select test_A.idx, ch, test_B.idx, txt
from test_A, test_B;

select a.ch, a.idx, b.idx, b.txt
from test_A a, test_B b;


-- 동등조인(equi join), 자연조인
select a.ch, a.idx, b.idx, b.txt
from test_A a, test_B b
where a.idx=b.idx;


-- DB에서는 대소문자 구분 안함. / equi join=inner join
select a.ch, a.idx, b.idx, b.txt
from test_a a inner join test_b b on a.idx=b.idx;


-- join
select *
from employee as e, department as d
where e.dno = d.deptno;

select *
from employee e 
inner join department d 
on e.dno=d.deptno;


-- 연산자 조건
select empname, salary
from employee
where title='과장' and dno=1;


select empname, salary
from employee
where title='과장' and dno<>1;


select empname, title, salary
from employee
where salary>=3000000 and salary<=4000000;  -- where salary between 3000000 and 4000000;


select * from employee
where dno = 1 or dno = 3; -- where dno in (1,3);


select empname, salary, salary*1.1 as newsalary
from employee
where title='과장';


select *
from employee
where manager is null;


select salary, title, empname
from employee
where dno = 3
order by salary;


-- 부서번호별 오름차순, 급여별 내림차순으로 검색
select *
from employee e inner join department d on e.dno = d.deptno
order by dno asc, salary desc;


-- 집단함수
select avg(salary) as '평균 급여', max(salary) as '최대 급여'
from employee;


create table sungjuk(
	stdno int,
	stdname varchar(10),
	kor int,
	eng int,
	math int
);

insert into sungjuk values (1, '홍길동', 90, 90, 90), (2,'이순신',89, 67, 89), (3, '도깨비', 79, 89, 60);


-- 모든 학생의 번호, 성명, 국어, 영어, 수학, 총점, 평균을 검색하시오.
select stdno, stdname, kor, eng, math,
	   kor+eng+math as '총점', 
	   (kor+eng+math)/3 as '평균'    -- 집단함수는 단일값을 반환하기에 sum()사용하면 안됨.
from sungjuk;

select sum(kor), sum(eng), sum(math)
from sungjuk;

select count(*)
from sungjuk;

select count(kor)
from sungjuk;

select count(distinct stdname)
from sungjuk;


-- 그룹화
select dno, avg(salary) as avgsal, max(salary) as maxsal
from employee
group by dno
having avg(salary)>=3000000;	-- group by / having 


-- UNION 집합연산, 속성의 수와 타입이 같아야 한다. MySQL에서는 union/union all(합집합) 만을 지원.
-- full outer join을 union으로 구할 수 있다.
(select dno
from employee
where empname='김창섭')
union all
(select deptno
from department
where deptname='개발')


-- self join
select e.empname as 사원, m.empname as 직속상사
from employee as e, employee as m
where e.manager=m.empno;


-- * 서브쿼리 *
-- 1) where절 서브쿼리 (중첩 서브쿼리)
-- 2) from절 서브쿼리 (인라인 뷰)
-- 3) select절 서브쿼리 (스칼라 서브쿼리 - 단일값 리턴 : 집단함수)


-- 중첩 서브쿼리 (nested query) 
select empname, title
from employee
where title = (select title from employee where empname='박영권');


-- 박영권이 소속된 부서의 모든 사원명, 부서명, 사원번호를 검색하시오.
select empno, deptname, empname
from employee e join department d on e.dno=d.deptno  
where dno = (select dno from employee where empname='박영권');


-- in, any, all / 중접질의 결과로 한 개의 어트리뷰트로 이루어진 다수의 투플이 반환될 경우, 외부 where절에서 연산자 사용
select empno, deptname, empname
from employee e join department d on e.dno=d.deptno  
where dno in (
		select dno
		from employee
		where empname='박영권' or empname='조민희'
);


-- IN을 사용한 질의 (p.76)
select empname
from employee
where dno in(select deptno from department where deptname='영업' or deptname='개발');

			
select empname
from employee e, department d
where e.dno=d.deptno and (d.deptname='영업' or d.deptname='개발');

select empname
from employee e inner join department d on e.dno=d.deptno
where d.deptname='영업' or d.deptname='개발';


select empname
from employee e inner join department d on e.dno=d.deptno
where dno in (select deptno from department where deptname='영업' or d.deptname='개발'); 


-- EXISTS를 사용한 질의
select empname
from employee e
where exists (
		select *
		from department d
		where e.dno=d.deptno
		and (deptname='영업' or deptname='개발')
 );
 

-- 상관 중첩 질의 (부질의에서 외부질의의 애트리뷰트 사용 : 상관 부질의)
select empname, dno, salary
from employee e
where salary >
		(select avg(salary)
		from employee
		where dno=e.dno);
		
show tables;


-- 순위 구하기
create table rank_tbl(name char(10), score integer);

insert into rank_tbl values
('a',90), ('b',100), ('c',80), ('d',100), ('e', 60), ('f',95);

select name, score,
	(select count(*)+1
	from rank_tbl t2
	where t2.score > t1.score) as rank 
from rank_tbl t1
order by rank;


-- 급여를 많이 받는 사원 순으로 순위를 검색하라.
select empname, salary, (select count(*)+1 from employee sub_e where sub_e.salary>e.salary) as rank 
from employee e
order by rank;


-- view
create view vw_emp_dept as
select empno, empname, title, manager, salary, deptname
from employee e join department d on e.dno = d.deptno
where deptname = '영업'
order by salary;

select * from vw_emp_dept;

create view vw_empinfo as
select empname, title, manager, deptname
from employee e join department d on e.dno = d.deptno;

select * from vw_empinfo;


-- 3번 부서의 사원번호, 이름, 직책의 뷰 정의 / 한 릴레이션 위에서 뷰를 정의
create view vw_deptno_3 as
select empno, empname, title from employee where dno=3;

select * from vw_deptno_3;


-- 기획부에 근무하는 사원의 이름, 직책, 급여로 이루어진 뷰 정의
create view vw_emp_plan as
select empname, title, salary
from employee e, department d
where e.dno = d.deptno and d.deptname = '기획';

select * from vw_emp_plan;

drop view vw_emp_plan;

select * from employee;
select * from department;

-- 뷰 갱신
insert into employee values 
(1234, '박지선', '사원', 2106 ,2500000, 2);


-- 뷰 갱신 / with check option; 데이터 무결성 보장
create view vw_emp_dno (empno, empname, title, dno) as
select empno, empname, title, dno
from employee
where dno=2
with check option;

select * from vw_emp_dno;
drop view vw_emp_dno;


-- 뷰를 통해 추가 또는 수정시, 뷰를 정의하는 select문의 where절 기준에 맞지 않으면 실행거부.
update vw_emp_dno
set dno=3
where empno=4377;

insert into vw_emp_dno values (5555, '홍길동', '사원', 2);


-- 뷰의 장점 / 뷰는 DB구조가 바뀌어도 기존의 질의(응용P)를 다시 작성할 필요성을 줄이는데 사용될 수 있다.
create table emp1(
	empno integer not null,
	empname varchar(20),
	salary integer,
	primary key(empno)
);

insert into emp1(select empno, empname, salary from employee);
select * from emp1;


create table emp2(
	empno integer not null,
	title varchar(10),
	manager integer,
	dno integer,
	foreign key(empno) references emp1(empno),
	foreign key(manager) references emp1(empno)
);

insert into emp2(select empno, title, manager, dno from employee);

select * from emp2;

drop table employee;

create view employee as
select emp1.empno, emp1.empname, emp2.title, emp2.manager, emp1.salary, emp2.dno
from emp1 join emp2 on emp1.empno = emp2.empno;

select * from employee;

drop view employee;


-- 집단함수를 포함한 뷰에 대한 갱신이 이루어 지지 않는다.
create view emp_avgsal as
select dno, avg(salary)
from employee
group by dno
having dno is not null;

select * from emp_avgsal;


-- 집단함수를 포함한 뷰에 대한 갱신이 이루어 지지 않는다.
update avgsal set avg(salary)=4000000
where dno=3;

insert into emp_avgsal values (3, 3200000);


-- Commit / Rollback
select * from employee;

set autocommit = 0;

update employee
set title = '대리'
where empno = 1234;

rollback;

commit;


