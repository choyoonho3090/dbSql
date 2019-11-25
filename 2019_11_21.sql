--��ü ������ �޿���� (2073.21)
SELECT ROUND(AVG(sal),2)sal
FROM emp;

--�μ��� ������ �޿� ��� 10 XXXX, 20 YYYY, 30 ZZZZ
SELECT *
FROM
    (SELECT deptno, ROUND(AVG(sal),2)d_avsal
    FROM emp
    GROUP BY deptno)
WHERE d_avsal > (SELECT ROUND(AVG(sal),2)sal
                FROM emp);
                
--���� ���� WITH���� �����Ͽ�
--������ �����ϰ� ǥ���Ѵ�.
WITH dept_avg_sal AS ( 
    SELECT deptno, ROUND(AVG(sal),2)d_avgsal
    FROM emp
    GROUP BY deptno
)
SELECT *
FROM dept_avg_sal
WHERE d_avgsal > (SELECT ROUND(AVG(sal),2)
                  FROM emp);
    
    
--�޷� �����
--STEP1. �ش� ����� ���� �����
--CONNECT BY LEVEL
-- iw = ���� ����
-- w = ���� ����
--201911
--DATE + ���� = ���� ���ϱ� ���� 
SELECT a.iw,
       MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue,
       MAX(DECODE(d, 4, dt)) wen, MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri, 
       MAX(DECODE(d, 7, dt)) sat
FROM
    (SELECT TO_date(:YYYYMM, 'YYYY/MM') + (LEVEL - 1) dt,
           TO_CHAR(TO_date(:YYYYMM, 'YYYY/MM') + (LEVEL), 'iw') iw,
           TO_CHAR(TO_date(:YYYYMM, 'YYYY/MM') + (LEVEL - 1), 'd') d
    FROM dual 
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD')) a
GROUP BY a.iw
ORDER BY a.iw;


--calendear2
SELECT a.iw,
       MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon, MAX(DECODE(d, 3, dt)) tue,
       MAX(DECODE(d, 4, dt)) wen, MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri, 
       MAX(DECODE(d, 7, dt)) sat
FROM
    (SELECT TO_date(:YYYYMM, 'YYYY/MM') + (LEVEL - 1) dt,
           TO_CHAR(TO_date(:YYYYMM, 'YYYY/MM') + (LEVEL), 'iw') iw,
           TO_CHAR(TO_date(:YYYYMM, 'YYYY/MM') + (LEVEL - 1), 'd') d
    FROM dual 
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD')) a
GROUP BY a.iw
ORDER BY a.iw;


--calendar1
--�޷¸���� ���� ������.sql�� �Ϻ� ���� �����͸� �̿��Ͽ�
--1~6���� ���� ���� �����͸� ������ ���� ���ϼ���.
SELECT (SELECT SUM(SALES) FROM sales WHERE TO_CHAR(DT, 'MM') = 01) jan,
       (SELECT SUM(SALES) FROM sales WHERE TO_CHAR(DT, 'MM') = 02) feb,
       NVL((SELECT SUM(SALES) FROM sales WHERE TO_CHAR(DT, 'MM') = 03), 0 ) mar,
       (SELECT SUM(SALES) FROM sales WHERE TO_CHAR(DT, 'MM') = 04) apr,
       (SELECT SUM(SALES) FROM sales WHERE TO_CHAR(DT, 'MM') = 05) may,
       (SELECT SUM(SALES) FROM sales WHERE TO_CHAR(DT, 'MM') = 06) jun
FROM dual;



--��������
--START WITH : ������ ���� �κ��� ����
--CONNECT BY : ������ ���� ������ ����

--����� �������� (���� �ֻ��� ������������ ��� ������ Ž��

--h1
SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL-1)*4, ' ') || dept_h.deptnm
FROM dept_h
START WITH deptcd = 'dept0' --START WITH p_deptcd IS NULL;
CONNECT BY PRIOR deptcd = p_deptcd; --PRIOR : ���� ���� ������
 

