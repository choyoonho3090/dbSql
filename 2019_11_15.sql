--emp ���̺� empno�÷��� �������� PRIMARY KEY�� ����
--PRIMARY KEY = UNIQUE + NOT NULL
--UNIQUE ==> �ش� �÷����� UNIQUE INDEX�� �ڵ����� ����

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE emp DROP CONSTRAINT b;

EXPLAIN PLAN FOR
SELECT *
FROM emp 
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_xplan.display);


--empno �÷����� �ε����� �����ϴ� ��Ȳ����
--�ٸ� �÷� ������ �����͸� ��ȸ�ϴ� ���
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);


--�ε��� ���� �÷��� SELECT ���� ����� ���
--���̺� ������ �ʿ� ����.
EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);


--�÷��� �ߺ��� ������ non-unique �ε��� ������
--unique index���� �����ȹ ��
--PRIMARY KEY �������� ����(unique �ε��� ����)
ALTER TABLE emp DROP CONSTRAINT pk_emp;  --�������� ����
CREATE INDEX /*UNIQUE*/ IDX_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 4208888661
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)


--emp ���̺� job �÷����� �ι�° �ε��� ����
--job �÷��� �ٸ� �ο��� job �÷��� �ߺ��� ������ �÷��̴�.
CREATE INDEX idx_emp_02 ON emp (job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     3 |   111 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     3 |   111 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')



EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%')
   2 - access("JOB"='MANAGER')


--emp ���̺� job, ename �÷��� �������� non-unique �ε��� ����
CREATE INDEX idx_emp_03 ON emp (job,ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 2549950125
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')


--emp ���̺� ename, job �÷����� non-unique �ε��� ����
CREATE INDEX IDX_EMP_04 ON emp (ename,job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE '%C';

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 4060516099
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX SKIP SCAN           | IDX_EMP_04 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')
       filter("JOB"='MANAGER' AND "ENAME" LIKE '%C' AND "ENAME" IS NOT NULL)
 


--HINT�� ����� �����ȹ ����
EXPLAIN PLAN FOR
SELECT /*+ INDEX( emp idx_emp_03 ) */ *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE '%C';

SELECT *
FROM TABLE(dbms_xplan.display);


--idx1
CREATE TABLE DEPT_TEST AS
SELECT *
FROM DEPT
WHERE 1 = 1; 
--deptno�÷��� �������� unique �ε��� ����
CREATE UNIQUE INDEX c ON DEPT_TEST(deptno);
--dname�÷��� �������� non-unique �ε��� ����
CREATE INDEX d ON DEPT_TEST(dname);
--deptno, dname �÷��� �������� non-unique �ε��� ����
CREATE INDEX e ON DEPT_TEST(deptno, dname);


--idx2
--�ǽ� idx1 ���� ������ �ε����� �����ϴ� DDL���� �ۼ��ϼ���.
DROP INDEX c;
DROP INDEX d;
DROP INDEX e;


--idx3
CREATE INDEX e ON emp(deptno);
CREATE INDEX f ON emp(ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE EMPNO = 7298;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE ENAME = 'SCOTT';

EXPLAIN PLAN FOR
SELECT *
FROM EMP
WHERE SAL BETWEEN 500 AND 7000
  AND DEPTNO = 20;

EXPLAIN PLAN FOR
SELECT *
FROM EMP, DEPT
WHERE EMP.deptno = DEPT.DEPTNO
  AND EMP.DEPTNO = 10
  AND EMP.EMPNO LIKE '78%';

EXPLAIN PLAN FOR
SELECT B.*
FROM EMP A, EMP B
WHERE A.MGR = B.EMPNO
  AND A.DEPTNO = 30;

SELECT *
FROM TABLE(dbms_xplan.display);

