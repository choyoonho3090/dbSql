--�������� Ȱ��ȭ/ ��Ȱ��ȭ
--� ���������� Ȱ��ȭ(��Ȱ��ȭ) ��ų ���??

--emp fk���� (dept���̺��� deptno�÷� ����)
-- FK_EMP_DEPT ��Ȱ��ȭ
ALTER TABLE emp DISABLE CONSTRAINT FK_EMP_DEPT;

--�������ǿ� ����Ǵ� �����Ͱ� ��� ���� ���� ������?
INSERT INTO emp (empno, ename, deptno)
VALUES (9999, 'brown', 80);

SELECT *
FROM EMP;

-- FK_EMP_DEPT Ȱ��ȭ
ALTER TABLE emp ENABLE CONSTRAINT FK_EMP_DEPT;
--�������ǿ� ����Ǵ� ������(�Ҽ� �μ���ȣ�� 80���� ������)��
--�����Ͽ� �������� Ȱ��ȭ �Ұ�
DELETE emp
WHERE empno = 9999;

ALTER TABLE emp ENABLE CONSTRAINT FK_EMP_DEPT;
COMMIT;

--���� ������ �����ϴ� ���̺� ��� view : USER_TABLES
--���� ������ �����ϴ� �������� view : USER_CONSTRAINTS
--���� ������ �����ϴ� ���������� �÷� view : USER_CONS_COLUMNS
SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'CYCLE';

--FK_EMP_DEPT
SELECT *
FROM USER_CONS_COLUMNS
WHERE CONSTRAINT_NAME = 'PK_CYCLE';

--���̺� ������ �������� ��ȸ(VIEW ����)
--���̺� ��/ �������� ��/ �÷��� / �÷� ������
SELECT a.table_name, a.CONSTRAINT_name, b.column_name, b.position
FROM USER_CONSTRAINTS a, USER_CONS_COLUMNS b
WHERE a.CONSTRAINT_name = b.CONSTRAINT_name
  AND a.CONSTRAINT_type = 'P' --PRIAMRRY KEY�� ��ȸ
ORDER BY a.table_name, b.position;


--emp ���̺�� 8���� �÷� �ּ��ޱ�
--EMPNO ENAME JOB MGR HIREDATE SAL COMM DEPTNO

--���̺� �ּ� VIEW : USER_TAB_COMMENTS

SELECT *
FROM user_tab_comments
WHERE table_name = 'EMP';

--emp ���̺� �ּ�
COMMENT ON TABLE emp IS '���';

--emp ���̺��� �÷� �ּ�
SELECT *
FROM user_col_comments;

--EMPNO ENAME JOB MGR HIREDATE SAL COMM DEPTNO
COMMENT ON COLUMN emp.empno IS '�����ȣ';
COMMENT ON COLUMN emp.ename IS '�̸�';
COMMENT ON COLUMN emp.job IS '������';
COMMENT ON COLUMN emp.mgr IS '������ ���';
COMMENT ON COLUMN emp.hiredate IS '�Ի�����';
COMMENT ON COLUMN emp.sal IS '�޿�';
COMMENT ON COLUMN emp.comm IS '��';
COMMENT ON COLUMN emp.deptno IS '�ҼӺμ���ȣ';

SELECT *
FROM USER_COL_COMMENTS
WHERE table_name = 'EMP';


--DDL(Table - comments �ǽ� comment1)
SELECT a.TABLE_NAME, a.TABLE_TYPE, a.COMMENTS TAB_COMMENTS,
       b.COLUMN_NAME, b.COMMENTS COL_COMMENTS
FROM USER_TAB_COMMENTS a, USER_COL_COMMENTS b
WHERE a.TABLE_NAME IN ('CYCLE','CUSTOMER','PRODUCT','DAILY')
  AND a.TABLE_NAME = b.TABLE_NAME;


--VIEW ���� (emp���̺��� sal, comm�ΰ� �÷��� �����Ѵ�.)
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM EMP;

--INLINE VIEW 
SELECT *
FROM (SELECT empno, ename, job, mgr, hiredate, deptno
        FROM emp);
        
--VIEW (�� �ζ��κ�� �����ϴ�.)
SELECT *
FROM v_emp;

--���ε� ���� ����� VIEW�� ���� : v_emp_dept
--emp, dept : �μ���, �����ȣ, �����, ������, �Ի�����
CREATE OR REPLACE VIEW v_emp_dept AS 
SELECT a.dname, b.empno, b.ename, b.job, b.hiredate
FROM dept a, emp b
WHERE a.deptno = b.deptno;

SELECT *
FROM v_emp_dept;

--VIEW ����
DROP VIEW v_emp;


--VIEW�� �����ϴ� ���̺��� �����͸� �����ϸ� VIEW���� ������ ����
--dept 30 - SALES
SELECT *
FROM dept;

--dept���̺��� SLAES --> MARKET SALES
--dept���̺��� �ڷᰪ�� �ٲٸ� VIEW�� �ڷᰪ�� �ٲ��.
UPDATE dept SET dname = 'MARKET SALES'
WHERE deptno = 30;
ROLLBACK;


--HR �������� v_emp_dept view ��ȸ������ �ش�.
GRANT SELECT ON v_emp_dept TO hr;


--SEQUENCE ���� (�Խñ� ��ȣ �ο��� ������)
CREATE SEQUENCE seq_post 
INCREMENT BY 1
START WITH 1;

--�Խñ�
SELECT seq_post.nextval, seq_post.currval
FROM dual;
--�Խñ� ÷������
SELECT seq_post.currval
FROM dual;

--������ ����
--������ : �ߺ����� �ʴ� ���� ���� �������ִ� ��ü
--1, 2, 3....
desc emp_test;
DROP TABLE emp_test;
CREATE TABLE emp_test (
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(15)
);
CREATE SEQUENCE seq_emp_test;
INSERT INTO emp_test VALUES (seq_emp_test.nextval,  'brown');

SELECT seq_emp_test.nextval
FROM dual;
ROLLBACK;

--INDEX
--rowid : ���̺� ���� ������ �ּ�, �ش� �ּҸ� �˸�
--        ������ ���̺� �����ϴ� ���� �����ϴ�.
SELECT product.*, ROWID
FROM product
WHERE ROWID = 'AAAFK3AAFAAAAFMAAA';

--table : pid, pnm
--pk_product : pid
SELECT pid
FROM product
WHERE ROWID = 'AAAFK3AAFAAAAFMAAC';


--�����ȹ�� ���� �ε��� ��뿩�� Ȯ��
--emp ���̺� empno �÷��� �������� �ε����� ���� ��
ALTER TABLE emp DROP CONSTRAINT pk_emp;

EXPLAIN PLAN FOR 
SELECT *
FROM emp
WHERE empno = 7369;

--�ε����� ���� ������ empno = 7369�� �����͸� ã�� ����
--emp ���̺��� ��ü�� ã�ƺ����Ѵ� => TABLE FULL SCAN

SELECT *
FROM TABLE(DBMS_xplan.display);

