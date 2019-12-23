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


