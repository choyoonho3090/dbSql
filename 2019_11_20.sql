-- GROUPING (cube, rollup ���� ���� �÷�)
-- �ش� �÷��� �Ұ� ��꿡 ���� ��� 1
--                     ������ ���� ��� 0
-- job �÷�
-- case1. GROUPING(job)= 1 AND GROUPING(dpetno)= 1
-- case else
--         job => job

--�ǽ� GROUP_AD2
SELECT CASE 
            WHEN GROUPING(job) = 1 AND
                 GROUPING(deptno) = 1 THEN '�Ѱ�'
            ELSE job
       END job, deptno,
       GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);


--�ǽ� GROUP_AD3
SELECT DEPTNO, job, SUM(SAL)sal
FROM emp
GROUP BY ROLLUP (DEPTNO,JOB);



--CUBE (col, col2...)
--CUBE ���� ������ �÷��� ������ ��� ���տ� ���� ���� �׷����� ����
--CUBE�� ������ �÷��� ���� ���⼺�� ����(rollup���� ����)
--GROUP BY CUBE(job,deptno)
--OO : GROUP BY job, deptno
--OX : GROUP BY job
--XO : GROUP BY deptno
--XX : GROUP BY  --��� �����Ϳ� ���ؼ�

SELECT job, deptno, SUM(SAL)
FROM emp
GROUP BY CUBE(job, deptno);


--SUBQUERY�� ���� ������Ʈ
DROP TABLE EMP_TEST;

--emp���̺��� �����͸� �����ؼ� ��� �÷��� �̿��Ͽ� emp_test���̺�� ����
CREATE TABLE emp_test AS
SELECT *
FROM EMP;

--emp_test ���̺��� dept���̺��� �����ǰ� �ִ� dname �÷��� �߰�
ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT *
FROM emp_test;

--emp_test���̺��� dname �÷��� dept���̺��� dname �÷������� ������Ʈ�ϴ� ���� �ۼ�
UPDATE emp_test SET dname = (SELECT dname
                             FROM dept
                             WHERE dept.deptno = emp_test.deptno);
COMMIT;



--correlated subquery update a1
--dept���̺��� �̿��Ͽ� dept_test ���̺� ����
CREATE TABLE dept_test AS
SELECT *
FROM dept;
--dept_test ���̺� empcnt(number) �÷� �߰�
ALTER TABLE dept_test ADD (empcnt NUMBER);
--subquery�� �̿��Ͽ� dept_test���̺��� empcnt �÷��� �ش� �μ��� ���� update���� �ۼ�
UPDATE dept_test SET EMPCNT = (SELECT COUNT(DEPTNO)
                               FROM emp
                               WHERE dept_test.DEPTNO = emp.DEPTNO
                               );
SELECT *
FROM dept_test;


INSERT INTO DEPT_test VALUES (98,'it','daejeon',0);
INSERT INTO DEPT_test VALUES (99,'it','daejeon',0);
--correlated subquery delete a2
--emp���̺��� �������� ������ ���� �μ� ���� �����ϴ� ������
--���������� �̿��Ͽ� �ۼ��ϼ���.
delete from dept_test where NOT EXISTS (SELECT 'X'
                                    FROM EMP
                                    WHERE emp.DEPTNO = DEPT_test.DEPTNO);
SELECT * 
FROM dept_test;



--correlated subquery delete a3
--EMP���̺��� �̿��Ͽ� EMP_test���̺� ����
CREATE TABLE emp_test AS
SELECT *
FROM EMP;
--EMP_TEST���̺� DNAME�÷� �߰�
ALTER TABLE emp_test ADD (DNAME VARCHAR2(14));
--SUBQUERY�� �̿��� EMP_TEST���̺��� ������ ���� �μ���(SAL)��� �޿����� 
--�޿��� ���� ������ �޿��� �� �޿����� 200�� �߰��ؼ� ������Ʈ �ϴ� ������ �ۼ�
UPDATE emp_test a SET sal = sal + 200
WHERE SAL < (SELECT AVG(SAL)
             FROM EMP);
             
             
--emp,emp_test empno�÷����� ���� ������ ��ȸ
--1. emp.empno, emp.ename, emp.sal, emp_test.sal
SELECT emp.empno, emp.ename, emp.sal, emp_test.sal, emp.DEPTNO
FROM emp , emp_test 
WHERE emp.empno = emp_test.empno;
--2. emp.empno, emp.ename, emp.sal, emp_test.sal �ش���(emp���̺� ����)�� ���� �μ��� �޿����
SELECT emp.empno, emp.ename, emp.sal, emp_test.sal, emp.DEPTNO, 
        (SELECT AVG(SAL)
         FROM EMP
         GROUP BY DEPTNO)AVG
FROM emp , emp_test 
WHERE emp.empno = emp_test.empno;


