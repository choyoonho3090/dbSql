-- ��� �Ķ���Ͱ� �־����� �� �ش����� �ϼ��� ���ϴ� ����
-- 201911 --> 30 / 201912 --> 31

-- �Ѵ� ������ �������� ���� = �ϼ�
-- ��������¥ ������ --> DD �� ����
SELECT :yyyymm param, TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD') dt
FROM dual;

explain plan for
SELECT *
FROM emp
WHERE empno = 7369 + '69';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT empno, ename, sal, TO_CHAR(sal, '$999,999.99') sal_fmt
FROM emp;

--function null
--nvl(coll, coll�� null�� ��� ��ü�� ��)
SELECT empno, ename, sal, comm, nvl(comm, 0) nvl_comm,
       sal + comm,
       sal + nvl(comm, 0),
       nvl(sal + comm, 0)
FROM emp;

--NVL2(coll, coll�� null�� �ƴҰ�� ǥ���Ǵ� ��, coll null�� ��� ǥ�� �Ǵ� ��
SELECT empno, ename, sal, comm, NVL2(comm, 0, comm) + sal
FROM emp;

--NULLIF(expr1, expr2)
--expr1 == expr2 ������ null
--else : expr1
SELECT empno, ename, sal, comm, NULLIF(sal, 1250)
FROM emp;

--COALESCE(expr1, expr2, expr3...)
--�Լ� ������ null�� �ƴ� ù��° ����
SELECT empno, ename, sal, comm, coalesce(comm, sal)
FROM emp;

-- emp���̺��� ������ ������ ���� ��ȸ
SELECT empno, ename, mgr,
       nvl(mgr, 9999) mgr_n,
       nvl2(mgr, mgr, 9999) mgr_n,
       coalesce(mgr, 9999) mgr_n
FROM emp;

SELECT userid, usernm, reg_dt, nvl(reg_dt, sysdate) reg_dt
FROM users;

--case when
SELECT empno, ename, job, sal,
    CASE
      WHEN job = 'SALESMAN' THEN sal * 1.05 
      WHEN job = 'MANAGER' THEN sal * 1.10
      WHEN job = 'PRESIDENT' THEN sal * 1.20
      else sal
    END case_sal
FROM emp;

--decode(col, search1, return1, search2, return2 ..... default)
SELECT empno, ename, job, sal,
    DECODE(job, 'SALESMAN', sal*1.05,
                'MANAGER', sal*1.10,
                'PRESIDENT', sal*1.20,
                            sal) decode_sal
FROM emp;

--emp ���̺��� �̿��Ͽ� deptno�� ���� �μ������� ���� �ؼ� ������ ���� ��ȸ
--CASE ~ END ���
SELECT empno, ename,
    CASE
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
        WHEN deptno = 40 THEN 'OPERATIONS'
                        else 'DDIT'
    END dname
FROM emp;
--DECODE ���
SELECT empno, ename,
    DECODE(deptno, 10, 'ACCOUNTING',
                   20, 'RESEARCH',
                   30, 'SALES',
                   40, 'OPERATIONS',
                   'DDIT') dname
FROM emp;

--emp ���̺��� �̿��Ͽ� hiredate�� ���� ���� �ǰ����� ���� ��������� ��ȸ
SELECT empno, ename, hiredate,
    CASE
--        WHEN MOD(TO_CHAR(hiredate, 'YYYY'), 2) = MOD(TO_CHAR(SYSDATE, 'YYYY'),2) THEN '�ǰ����� �����'
        WHEN MOD(TO_CHAR(sysdate, 'YYYY') - TO_CHAR(hiredate, 'YYYY'),2) = 0 THEN '�ǰ����� �����'
        else '�ǰ����� ������'
    END contact_to_doctor
FROM emp;

--�� �ؼ��� ¦���ΰ�? Ȧ���ΰ�?
--1. ���� �⵵ ���ϱ� (DATE --> TO_CHAR(DATE, FORMAT))
--2. ���� �⵵�� ¦������ ���
-- ����� 2�� ������ �������� �׻� 2���� �۴�
-- 2�� ������� �������� 0,1
-- MOD(���, ������)

SELECT MOD(TO_CHAR(SYSDATE, 'YYYY'),2)
FROM dual;

-- users ���̺��� �̿��Ͽ� reg_dt�� ���� ���� �ǰ����� ���� ��������� ��ȸ
SELECT userid, usernm, alias, reg_dt,
    CASE
        WHEN MOD(TO_CHAR(reg_dt, 'YY') - TO_CHAR(SYSDATE, 'YY'),2) = 0 THEN '�ǰ����� �����'
        else '�ǰ����� ������'
    END contact_to_doctor
FROM users;

--�׷��Լ� (AVG, MAX, MIN, SUM, COUNT)
--�׷��Լ��� NULL���� ����󿡼� �����Ѵ�
--SUM(comm), COUNT(*), COUNT(mgr)
--������ ���� ���� �޿��� �޴»���� �޿�
--������ ���� ���� �޿��� �޴»���� �޿�
--������ �޿� ��� (�Ҽ��� �Ѥ��ڸ� ������ ������ --> �Ҽ��� 3°�ڸ����� �ݿø�)
--������ �޿� ��ü��
--������ ��
SELECT MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal, COUNT(*) emp_cnt, COUNT(sal) sal_cnt, COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp;

--�μ��� ���� ���� �޿��� �޴»���� �޿�
--GROUP BY ���� ������� ���� �÷��� SELECT ���� ����� ��� ���� !!
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal, COUNT(*) emp_cnt, COUNT(sal) sal_cnt, COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp
GROUP BY deptno;

--�μ��� �ִ� �޿�
SELECT deptno, MAX(sal)
FROM emp
GROUP BY deptno
HAVING MAX(sal) > 3000;

--emp���̺��� �̿��Ͽ� ������ ���Ͻÿ�
SELECT MAX(sal)max_sal, MIN(sal)min_sal, ROUND(AVG(sal),2)avg_sal, SUM(sal)sum_sal, COUNT(sal)count_sal, COUNT(mgr)count_mgr, COUNT(*)count_all
FROM emp;

--emp���̺��� �̿��Ͽ� ������ ���Ͻÿ�
SELECT deptno, MAX(sal)max_sal, MIN(sal)min_sal, ROUND(AVG(sal),2)avg_sal, SUM(sal)sum_sal, COUNT(sal)count_sal, COUNT(mgr)count_mgr, COUNT(*)count_all
FROM emp
GROUP BY deptno;

--������ �ۼ��� �������� deptno ��� �μ����� �������� ����
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




-- UPDATE ���
--UPDATE users SET reg_dt = null
--WHERE userid = 'moon';
--
--commit;