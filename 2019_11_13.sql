--unique table level constraint
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR(14),
    loc VARCHAR(13),
    
    --CONSTRAINT �������� �� CONSTRAINT TYPE [(�÷�....)]
    CONSTRAINT uk_dept_test_dname_loc UNIQUE (dname, loc)
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
--ù��° ������ ���� dname, loc���� �ߺ� �ǹǷ� �ι�° ������ ������� ���Ѵ�.
INSERT INTO dept_test VALUES (2, 'ddit', 'daejeon');

SELECT *
FROM dept_test;

--foreign key(��������)
DROP TABLE dept_test;
CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR(14),
    loc VARCHAR(13)
);

INSERT INTO dept_test VALUES(1, 'ddit', 'daejeon');
COMMIT;

--emp_test (empno, ename, deptno)
DESC emp;
CREATE TABLE emp_test (
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR(10),
    deptno NUMBER(2) REFERENCES dept_test(deptno)
);
--dept_test ���̺� 1�� �μ���ȣ�� �����ϰ�
--fk ������ dept_test.deptno�÷��� �����ϵ��� �����Ͽ�
--1�� �̿��� �μ���ȣ�� emp_test ���̺� �Է� �� �� ����.

--emp_test fk �׽�Ʈ insert
INSERT INTO emp_test VALUES (9999, 'brown', 1);

--2�� �μ��� dept_test���̺� �������� �ʴ� ������ �̱� ������
--fk���࿡ ���� INSERT�� ���������� �������� �ʴ´�.
INSERT INTO emp VALUES (9999, 'sally', 2);

--���Ἲ ���࿡�� �߻��� �� �ؾ� �ұ�??
--�Է��Ϸ��� �ϴ� ���� �´°ǰ�??(2���� �³�? 1�� �Ƴ�?)
-- .�θ����̺� ���� �� �Է¾ȵƴ��� Ȯ��(dept_test Ȯ��)

--fk ���� table level constraint
DROP TABLE emp_test;
CREATE TABLE emp_test (
    empno NUMBER(2) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY
    (deptno) REFERENCES dept_test(deptno)
);

--FK������ �����Ϸ��� �����Ϸ��� �÷��� �ε����� �����Ǿ��־���Ѵ�.
DROP TABLE emp_test;
DROP TABLE dept_test;

CREATE TABLE  dept_test(
    deptno NUMBER(2), --PRIMARY KEY --> UNIQUE ����X --> �ε�������X
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(1),
    --dept_test.deptnoĿ���� �ε����� ���� ������ ����������
    --fk ������ ������ �� ����.
    deptno NUMBER(2) REFERENCES dept_test(deptno)
);

DROP TABLE dept_test;

CREATE TABLE  dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);
DROP TABLE emp_test;
CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(10),
    --dept_test.deptnoĿ���� �ε����� ���� ������ ����������
    --fk ������ ������ �� ����.
    deptno NUMBER(2) REFERENCES dept_test(deptno)
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO emp_test VALUES (9999, 'brown', 1);
COMMIT;

SELECT *
FROM emp_test;

SELECT *
FROM dept_test;

--dept_test���̺��� deptno ���� �����ϴ� �����Ͱ� ���� ���
--������ �Ұ����ϴ�
--�� �ڽ� ���̺��� �����ϴ� �����Ͱ� ����� �θ� ���̺��� �����͸�
--���� �����ϴ�
--emp_test.deptno�÷��� dept_test.deptno�÷��� �����ϱ� ������
--emp_test.deptno�÷��� ���� �����ؾ� dept_test.deptno�÷��� ������ �� �ִ�. 
DELETE emp_test WHERE empno = 9999;
DELETE dept_test WHERE deptno = 1;

--FK ���� �ɼ�
--default : ������ �Է�/������ ���������� ó������� fk ������ ����
--          ���� �ʴ´�.
--ON DELETE CASCADE : �θ� ������ ������ �����ϴ� �ڽ� ���̺� ���� ����
--ON DELETE NULL : �θ� ������ ������ �����ϴ� �ڽ� ���̺� �� NULL ����
DROP TABLE emp_test;
CREATE TABLE emp_test (
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY
    (deptno) REFERENCES dept_test(deptno) ON DELETE CASCADE
);
INSERT INTO emp_test VALUES (9999, 'brown', 1);
INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');

--FK���� default �ɼǽÿ��� �θ� ���̺��� �����͸� �����ϱ� ���� �ڽ� ���̺���
--�����ϴ� �����Ͱ� ����� ���������� ������ ��������
--ON DELETE CASCADE�� ��� �θ� ���̺� ������ �����ϴ� �ڽ� ���̺��� �����͸� 
--���� �����Ѵ�.
--1.���� ������ ���������� ���� �Ǵ���?
--2.�ڽ� ���̺� �����Ͱ� ���� �Ǿ�����?
DELETE dept_test
WHERE deptno =1;

SELECT *
FROM emp_test;



--fk���� ON DELETE NULL
DROP TABLE emp_test;
CREATE TABLE emp_test (
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY
    (deptno) REFERENCES dept_test(deptno) ON DELETE SET NULL
);
INSERT INTO emp_test VALUES (9999, 'brown', 1);
INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
COMMIT;

--FK���� default �ɼǽÿ��� �θ� ���̺��� �����͸� �����ϱ� ���� �ڽ� ���̺���
--�����ϴ� �����Ͱ� ����� ���������� ������ ��������
--ON DELETE CASCADE�� ��� �θ� ���̺� ������ �����ϴ� �ڽ� ���̺��� ��������
--���� �÷��� NULL�� �����Ѵ�.
--���� �����Ѵ�.
--1.���� ������ ���������� ���� �Ǵ���?
--2.�ڽ� ���̺� �����Ͱ� ���� �Ǿ�����?
DELETE dept_test
WHERE deptno = 1;

SELECT *
FROM emp_test;


--CHECK ���� : �÷��� ���� ������ ����, Ȥ�� ���� �����Բ� ����
DROP TABLE emp_test;
CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(10),
    sal NUMBER CHECK (sal >= 0)
);
--sal �÷��� CHECK ���� ���ǿ� ���� 0�̰ų�, 0���� ū ���� �Է��� �����ϴ�.
INSERT INTO emp_test(sal) VALUES (1);
DELETE emp_test WHERE SAL = 1;


DROP TABLE emp_test;
CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(10),
    --emp_gb : 01 -������, 02 -����
    emp_gb VARCHAR2(2) CHECK (emp_gb IN (01,02))
);

INSERT INTO emp_test(emp_gb) VALUES (01); 
INSERT INTO emp_test(emp_gb) VALUES (03); 
DELETE emp_test WHERE emp_gb = 01;

SELECT *
FROM emp_test;


--SELECT ����� �̿��� TABLE ����
--CREATE TABLE ���̺�� AS 
--SELECT ����
--> CTAS

DROP TABLE emp_test;
DROP TABLE dept_test;

--CUSTOMER ���̺��� ����Ͽ� CUSTOMER_TEST���̺�� ����
--CUSTOMER ���̺��� �����͵� ���� ����
CREATE TABLE CUSTOMER_test AS
SELECT *
FROM CUSTOMER;

SELECT *
FROM CUSTOMER_test;

CREATE TABLE test AS
SELECT SYSDATE dt
FROM DUAL;

SELECT *
FROM test;

DROP TABLE TEST;


--�����ʹ� �������� �ʰ� Ư�� ���̺��� �÷� ���ĸ� �����ü� ������?
DROP TABLE customer_test;
CREATE TABLE customer_test AS
SELECT *
FROM customer
WHERE 1 != 1;

SELECT *
FROM customer_test;

CREATE TABLE CUSTOMER_191113 AS
SELECT *
FROM CUSTOMER;

--���̺� ����
--���ο� �÷� �߰�
DROP TABLE emp_test;
CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(10)
);

--�ű� �÷� �߰�
ALTER TABLE emp_test ADD (deptno NUMBER(2));

DESC emp_test;


--���� �÷� ����
ALTER TABLE emp_test MODIFY (ename VARCHAR2(200));

--���� �÷� ����(���̺� �����Ͱ� ���� ��Ȳ)
ALTER TABLE emp_test MODIFY (ename NUMBER);

--�����Ͱ� �ִ� ��Ȳ���� �÷� ���� : �������̴�.
INSERT INTO emp_test VALUES(9999, 1000, 10);
COMMIT;
SELECT *
FROM emp_test;
--������ Ÿ���� �����ϱ� ���ؼ��� �÷� ���� ��� �־�� �Ѵ�.
ALTER TABLE emp_test MODIFY (ename VARCHAR2(10));

--DEFAULT ����
DESC emp_test;
ALTER TABLE emp_test MODIFY (deptno DEFAULT 10);

--�÷��� ����
ALTER TABLE emp_test RENAME COLUMN DEPTNO TO DNO;
DESC emp_test;

--�÷� ����(DROP)
ALTER TABLE emp_test DROP COLUMN DNO;
DESC emp_test;

--���̺� ���� : ���� ���� �߰�
--PRIMARY KEY
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY(empno);
DESC emp_test;

--�������� ����
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;
DESC emp_test;

--UNIQUE ���� - empno
ALTER TABLE emp_test ADD CONSTRAINT uk_emp_test UNIQUE (empno);
DESC emp_test;

--UNIQUE ���� ���� : uk_emp_test
ALTER TABLE emp_test DROP CONSTRAINT uk_emp_test;

--FOREIGN KEY �߰�
--�ǽ� 
--1.DEPT ���̺��� DEPTNO�÷����� PRIMARY KEY ������ ���̺� ����
--DDL�� ���� ����
ALTER TABLE DEPT ADD CONSTRAINT a PRIMARY KEY(deptno);

--2.EMP ���̺��� EMPNO�÷����� PRIMARY KEY ������ ���̺� ����
--DDL�� ���� ����
ALTER TABLE EMP ADD CONSTRAINT b PRIMARY KEY(empno);

--3.EMP ���̺��� DEPTNO�÷����� dept ���̺��� deptno �÷��� 
--�����ϴ� fk ������ ���̺� ���� DDL�� ���� ����
-- emp => dept(deptno)
ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY (deptno)
REFERENCES dept (deptno);

--emp_test -> dept,deptno fk ���� ����(ALTER TABLE)
DROP TABLE emp_test;
CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2)
);

ALTER TABLE emp_test ADD CONSTRAINT fk FOREIGN KEY (deptno)
REFERENCES dept (deptno);


--CHECK ���� �߰� (ename ���� üũ, ���̰� 3���� �̻�)
ALTER TABLE emp_test ADD CONSTRAINT check_ename_len
CHECK ( LENGTH(ename) > 3);

INSERT INTO emp_test VALUES (9999, 'brown', 10);
INSERT INTO emp_test VALUES (9999, 'br', 10);
ROLLBACK;

--CHECK ���� ����
ALTER TABLE emp_test DROP CONSTRAINT check_ename_len;

--NOT NULL ���� �߰�
ALTER TABLE emp_test MODIFY (ename NOT NULL);

--NOT NULL ���� ����(NULL ���)
ALTER TABLE emp_test MODIFY (ename NULL);

