-- �׷��Լ�
-- multi row function : �������� ���� �Է����� �ϳ��� ��� ���� ����
-- SUM, MAX, MIN, AVG, COUNT
-- GROUP BY col | express
-- SELECT ������ GROUP BY ���� ����� COL, EXPRESS ǥ�� ����

-- ������ ���� ���� �޿� ��ȸ
-- 14�� ���� �Է����� �� �ϳ��� ����� ����
SELECT MAX(sal) max_sal
FROM emp;

-- �μ��� ���� ���� �޿� ��ȸ
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

SELECT
    CASE
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
        else 'DDIT'
    END dname, MAX(sal)max_sal, MIN(sal)min_sal, ROUND(AVG(sal),2)avg_sal, SUM(sal)sum_sal, COUNT(sal)count_sal, COUNT(mgr)count_mgr, COUNT(*)count_all
FROM emp
GROUP BY
    CASE
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
        else 'DDIT'
    END
ORDER BY max_sal DESC;

SELECT
    DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 'DDIT') dname,
    MAX(sal)max_sal, MIN(sal)min_sal, ROUND(AVG(sal),2)avg_sal, SUM(sal)sum_sal,
    COUNT(sal)count_sal, COUNT(mgr)count_mgr, COUNT(*)count_all
FROM emp
GROUP BY DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 'DDIT')
ORDER BY dname;

-- emp ���̺��� �̿��Ͽ� ������ �Ի� ������� ����� ������ �Ի��ߴ��� ��ȸ
SELECT TO_CHAR(hiredate, 'yyyymm') hire_yyyymm,COUNT(hiredate)cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyymm');

-- emp���̺��� �̿��Ͽ� ������ �Ի� �⺰�� ����� ������ �Ի��ߴ��� ��ȸ
SELECT TO_CHAR(hiredate, 'yyyy') hire_yyyy, COUNT(hiredate)cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyy')
ORDER BY TO_CHAR(hiredate, 'yyyy');

-- ȸ�翡 �����ϴ� �μ��� ������ ����� ��ȸ
SELECT COUNT(deptno) cnt
FROM dept;

-- JOIN
-- emp ���̺��� dname �÷��� ����
desc emp;

-- emp ���̺� �μ��̸��� �����Ҽ� �ִ� dname �÷� �߰�
ALTER TABLE emp ADD (dname VARCHAR2(14));

SELECT *
FROM emp;

UPDATE emp SET dname = 'ACCOUNTING' WHERE DEPTNO = 10;
UPDATE emp SET dname = 'RESEARCH' WHERE DEPTNO = 20;
UPDATE emp SET dname = 'SALES' WHERE DEPTNO = 30;
COMMIT;

SELECT dname, MAX(sal)max_sal
FROM emp
GROUP BY dname;

ALTER TABLE emp DROP COLUMN DNAME;
COMMIT;

-- ansi natural join : ���̺��� �÷����� ���� �÷��� �������� JOIN
SELECT deptno, ename, dname
FROM emp NATURAL JOIN dept;

-- ORACLE join
SELECT emp.empno, emp.ename, emp.deptno, dept.dname, dept.loc
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- ANSI JOING WITH USING
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept USING (deptno);

-- FROM ���� ���� ��� ���̺� ����
-- WHERE ���� �������� ���
-- ������ ����ϴ� ���� ���൵ �������
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.job = 'SALESMAN'; --job�� SALES�� ����� ������� ��ȸ

SELECT emp.empno, emp.ename, dept.dname
FROM dept, emp
WHERE emp.job = 'SALESMAN'
AND emp.deptno = dept.deptno; 

-- JOIN with ON (�����ڰ� ���� �÷��� on���� ���� ���)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

-- SELF join : ���� ���̺��� ����
-- emp���̺��� mgr ������ �����ϱ� ���ؼ� emp ���̺�� ������ �ؾ��Ѵ�.
-- a : ���� ����, b : ������
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno)
WHERE a.empno between 7369 AND 7698;

--oracle
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno
AND a.empno between 7369 AND 7698;

SELECT *
FROM salgrade;

-- emp ���̺��� salgrade ���̺�� �����Ͽ� sal ����� ��ȸ
SELECT e.empno, e.ename, e.sal, s.*
FROM emp e, salgrade s
WHERE e.sal between s.losal AND s.hisal;

--���� ��ȸ�� ������ join on ���� ����
SELECT e.empno, e.ename, e.sal, s.*
FROM emp e JOIN salgrade s ON (e.sal between s.losal AND s.hisal);

-- non equi joing
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr != b.empno
AND a.empno = 7369;

-- emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ
SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORDER BY deptno;

SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.empno = 7369;

-- emp,dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ (�μ���ȣ�� 10, 30�� �����͸� ��ȸ
SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.deptno IN (10,30);

-- emp,dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ
SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORdER BY deptno;