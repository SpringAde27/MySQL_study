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


