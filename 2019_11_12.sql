--sub9
SELECT *
FROM product
WHERE NOT EXISTS (SELECT 'X' 
              FROM cycle
              WHERE cid = 1
                AND pid = product.pid);

--1번고객이 애음하는 제품
SELECT pid
FROM cycle
WHERE cid = 1;


SELECT *
FROM DEPT;

DELETE DEPT WHERE DEPTNO = 99;

COMMIT;

INSERT INTO DEPT
VALUES (99, 'DDIT', 'daejeon');

INSERT INTO customer
VALUES (99, 'ddit');

SELECT *
FROM customer;

INSERT INTO emp (empno, ename, job)
VALUES ('brown',null);

SELECT *
FROM emp;

rollback;

SELECT *
FROM USER_TAB_COLUMNS
WHERE table_name = 'EMP';

desc emp;

INSERT INTO emp
VALUES (9999, 'brown','ranger', null, sysdate, 2500, null, 40);

SELECT *
FROM emp;

COMMIT;

--SELECT 결과(여러건)를 INSERT
INSERT INTO (empno,empNO)
SELECT deptno, dname
FROM DEPT;

--UPDATE
--UPDATE 테이블 SET 컬럼-값, 컬럼=값...
--WHERER condition
SELECT *
FROM DEPT;

DESC DEPT;
UPDATE dept SET dname ='대덕IT', loc ='ym'
WHERE deptno = 99;


--DELETE 테이블명
--WHERE condition
--사원번호가 9999인 직원을 emp 테이블에서 삭제
DELETE emp 
WHERE empno = 9999;

--부서테이블을 이용해서 emp 테이블에 입력한 5건의 데이터를 삭제
--10, 20, 30, 40, 99 --> empno < 100, empno BETWEEN 10 AND 99
DELETE emp 
WHERE empno < 100;

SELECT *
FROM emp
WHERE empno < 100;

DELETE emp
WHERE empno IN (SELECT deptno FROM dept);

DELETE emp WHERE empno = 9999;
COMMIT;

SELECT *
FROM EMP;

--LV1 --> LV3
SET TRANSACTION
isolation LEVEL SERIALIZABLE;

SELECT *
FROM DEPT;


--DDL : AUTO COMMIT, rollback이 안 된다.
--CREATE
CREATE TABLE  ranger_new(
ranger_no NUMBER,   --숫자타입
ranger_name VARCHAR2(50), --문자 : [VARCHAR2], CHAR
reg_dt DATE DEFAULT sysdate --DEFAULT : SYSDATE
);

DESC ranger_new;

INSERT INTO ranger_new (ranger_no, ranger_name)
VALUES(1000, 'brown');

SELECT *
FROM ranger_new;
COMMIT;


--날짜 타입에서 특정 필드가져오기
--ex : sysdate에서 년도만 가져오기
SELECT TO_CHAR(sysdate, 'YYYY')
FROM daul;

SELECT ranger_no, ranger_name, reg_dt, 
        TO_CHAR(reg_dt, 'MM'),
        EXTRACT (MONTH FROM reg_dt)A,
        EXTRACT (YEAR FROM reg_dt)B,
        EXTRACT (DAY FROM reg_dt)C
FROM ranger_new;


--제약조건
--DEPT 모방해서 DEPT_TEST 생성
DESC DEPT;
CREATE TABLE dept_test(
    deptno number(2) primary key,   --deptno 컬럼을 식별자로 지정
    dname varchar(14),              --식별자로 지정이 되면 값이 중복이 
    loc varchar2(13)                --될수 없으며, null일 수도 없다.
);

--primary key제약 조건 확인
--1.deptno컬럼에 null이 들어갈 수 없다
--2.deptno컬럼에 중복된 값이 들어갈 수 없다
--NULL값X
INSERT INTO dept_test(deptno,dname,loc)
VALUES (null,'ddit','daejeon');
--중복된 값X
INSERT INTO dept_tset VALUES (1, 'ddit','daejeon');
INSERT INTO dept_tset VALUES (1, 'ddit2','daejeon');

ROLLBACK;

--사용자 지정 제약조건명을 부여한 PRIMARY KEY
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_DEPT_TEST PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);


--TABLE CONSTRAINT
DROP TABLE DEPT_TEST;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno, dname)
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');

SELECT * FROM dept_test;

ROLLBACK;


--NOT NULL
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (2, NULL, 'daejeon');

SELECT *
FROM dept_test;


--UNIQUE
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) UNIQUE,
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (2, 'ddit', 'daejeon');

SELECT *
FROM dept_test;
ROLLBACK;
