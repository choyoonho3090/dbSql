SELECT *
FROM USER_VIEWS;

SELECT *
FROM ALL_VIEWS
WHERE OWNER = 'PC12';

SELECT *
FROM PC12.V_EMP_DEPT;

--sem 계정에서 조회권한을 받은 V_EMP_DEPT view를 계정에서 조회하기
--위해서는 계정명.view이름 형식으로 기술을 해야한다.
--매번 계정명을 기술하기 귀찮으므로 Synonym을 통해 다른 별칭을 생성

CREATE SYNONYM V_EMP_DEPT FOR PC12.V_EMP_DEPT;

--PC12.V_EMP_DEPT => V_EMP_DEPT
SELECT *
FROM V_EMP_DEPT;

SELECT *
FROM PC12.V_EMP_DEPT;

--synonym 삭제
DROP SYNONYM v_EMP_DEPT;

--hr 계정 비밀번호 : java
--hr 계정 비밀번호 변경 : hr
ALTER USER hr IDENTIFIED BY hr;
ALTER USER PC12 IDENTIFIED BY java; --본인 계정이 아니라 에러!!


--dictionary
--접두어 : USER : 사용자 소유 객체
--        ALL : 사용자가 사용가능한 객체
--        DBA : 관리자 관점의 전체 객체 (일반 사용자는 사용 불가)
--        VS : 시스템과 관련된 view (일반 사용자는 사용 불가)

SELECT *
FROM USER_TABLES;

SELECT *
FROM DBA_TABLES
WHERE OWNER IN ('PC12','HR');


--오라클에서 동일한 SQL이란?
--문자가 하나라도 틀리면 안됨
--다음 sql들은 같은결과를 만들어 낼지 몰라도 DBMS에서는
--서로 다른 SQL로 인식된다
SELECT /*bind_test*/ * FROM emp;
Select /*bind_test*/ * FROM emp;
select /*bind_test*/ * FROM emp;
SELECT /*bind_test*/ * FROM emp WHERE empno=: empno;

--SYSTEM계정
SELECT *
FROM V$SQL
WHERE SQL_TEXT LIKE '%bind_test%';

