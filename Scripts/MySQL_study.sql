-- mysql root계정에서 데이터베이스 생성
create database mysql_study default character set utf8;

-- 해당 데이터베이스를 사용할 사용자 추가 (mysql은 localhost와 다른 호스트를 구분하기 때문에 로컬용과 외부용을 각각 생성)
create user 'mysql_study'@'localhost' identified by 'rootroot'; -- 로컬에서 접속
create user 'mysql_study'@'%' identified by 'rootroot'; -- 외부에서 접속

-- 권한 부여
grant all privileges on mysql_study.* to 'mysql_study'@'localhost' identified by 'rootroot';
grant all privileges on mysql_study.* to 'mysql_study'@'%' identified by 'rootroot';


