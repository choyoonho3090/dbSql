--sub9
SELECT *
FROM product
WHERE NOT EXISTS (SELECT 'X' 
              FROM cycle
              WHERE cid = 1
                AND pid = product.pid);

--1������ �����ϴ� ��ǰ
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

--SELECT ���(������)�� INSERT
INSERT INTO (empno,empNO)
SELECT deptno, dname
FROM DEPT;

--UPDATE
--UPDATE ���̺� SET �÷�-��, �÷�=��...
--WHERER condition
SELECT *
FROM DEPT;

DESC DEPT;
UPDATE dept SET dname ='���IT', loc ='ym'
WHERE deptno = 99;


--DELETE ���̺��
--WHERE condition
--�����ȣ�� 9999�� ������ emp ���̺��� ����
DELETE emp 
WHERE empno = 9999;

--�μ����̺��� �̿��ؼ� emp ���̺� �Է��� 5���� �����͸� ����
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


--DDL : AUTO COMMIT, rollback�� �� �ȴ�.
--CREATE
CREATE TABLE  ranger_new(
ranger_no NUMBER,   --����Ÿ��
ranger_name VARCHAR2(50), --���� : [VARCHAR2], CHAR
reg_dt DATE DEFAULT sysdate --DEFAULT : SYSDATE
);

DESC ranger_new;

INSERT INTO ranger_new (ranger_no, ranger_name)
VALUES(1000, 'brown');

SELECT *
FROM ranger_new;
COMMIT;


--��¥ Ÿ�Կ��� Ư�� �ʵ尡������
--ex : sysdate���� �⵵�� ��������
SELECT TO_CHAR(sysdate, 'YYYY')
FROM daul;

SELECT ranger_no, ranger_name, reg_dt, 
        TO_CHAR(reg_dt, 'MM'),
        EXTRACT (MONTH FROM reg_dt)A,
        EXTRACT (YEAR FROM reg_dt)B,
        EXTRACT (DAY FROM reg_dt)C
FROM ranger_new;


--��������
--DEPT ����ؼ� DEPT_TEST ����
DESC DEPT;
CREATE TABLE dept_test(
    deptno number(2) primary key,   --deptno �÷��� �ĺ��ڷ� ����
    dname varchar(14),              --�ĺ��ڷ� ������ �Ǹ� ���� �ߺ��� 
    loc varchar2(13)                --�ɼ� ������, null�� ���� ����.
);

--primary key���� ���� Ȯ��
--1.deptno�÷��� null�� �� �� ����
--2.deptno�÷��� �ߺ��� ���� �� �� ����
--NULL��X
INSERT INTO dept_test(deptno,dname,loc)
VALUES (null,'ddit','daejeon');
--�ߺ��� ��X
INSERT INTO dept_tset VALUES (1, 'ddit','daejeon');
INSERT INTO dept_tset VALUES (1, 'ddit2','daejeon');

ROLLBACK;

--����� ���� �������Ǹ��� �ο��� PRIMARY KEY
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
