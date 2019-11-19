--����ŷ, �Ƶ�����, KFC ����
SELECT SIDO, SIGUNGU, COUNT(*)cnt
FROM fastfood
WHERE GB IN ('����ŷ', '�Ƶ�����','KFC')
GROUP BY SIDO,SIGUNGU;

--�Ե����� ����
SELECT SIDO, SIGUNGU, COUNT(*)cnt
FROM fastfood
WHERE GB = '�Ե�����'
GROUP BY SIDO,SIGUNGU;

--(����ŷ+�Ƶ�����+KFC)/�Ե�����
SELECT a.sido, a.sigungu, a.cnt kmb, b.cnt lotte, round(a.cnt/b.cnt,2) point
FROM 
    (SELECT SIDO, SIGUNGU, COUNT(*)cnt
    FROM fastfood
    WHERE GB IN ('����ŷ', '�Ƶ�����','KFC')
    GROUP BY SIDO,SIGUNGU) a,           --����
    (SELECT SIDO, SIGUNGU, COUNT(*)cnt
    FROM fastfood
    WHERE GB = '�Ե�����'
    GROUP BY SIDO,SIGUNGU)b
WHERE a.sido = b.sido
  AND a.SIGUNGU = b.SIGUNGU
ORDER BY point DESC;

--�������� ���Ծ�
SELECT SIDO, SIGUNGU, ROUND(SAL/PEOPLE,2) POINT
FROM TAX
ORDER BY POINT DESC;

SELECT SIDO, SIGUNGU, SAL, ROUND(SAL/PEOPLE,2) POINT
FROM TAX
ORDER BY SAL DESC;


--�������� �õ�,�ñ���  :  �������� �õ� �ñ���
--�õ�, �ñ���, ��������, �õ�, �ñ���, �������� ���Ծ�
SELECT a.*, b.*
FROM 
    (SELECT a.*, ROWNUM RN 
     FROM
        (SELECT a.sido, a.sigungu, a.cnt kmb, b.cnt l,
               round(a.cnt/b.cnt, 2) point
        FROM 
            --140��
            (SELECT SIDO, SIGUNGU, COUNT(*) cnt
            FROM fastfood
            WHERE gb IN ('KFC', '����ŷ', '�Ƶ�����')
            GROUP BY SIDO, SIGUNGU) a,
            
            --188��
            (SELECT SIDO, SIGUNGU, COUNT(*) cnt
            FROM fastfood
            WHERE gb IN ('�Ե�����')
            GROUP BY SIDO, SIGUNGU) b
            WHERE a.sido = b.sido
            AND a.sigungu = b.sigungu
        ORDER BY point DESC )a ) a,
    
    (SELECT b.*, rownum rn
    FROM 
    (SELECT sido, sigungu
    FROM TAX
    ORDER BY sal DESC) b ) b
WHERE b.rn = a.rn(+)
ORDER BY b.rn;


--emp_test ���̺� ����
DROP TABLE emp_TEST;




--multiple insert�� ���� �׽�Ʈ ���̺� ����
--empno, ename �ΰ��� �÷��� ���� emp_test, emp_test2 ���̺���
--emp ���̺�� ���� �����Ѵ� (CTAS_
--�����ʹ� �������� �ʴ´�.

CREATE TABLE emp_test AS;
CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp
WHERE 1 = 2;



--INSERT ALL
--�ϳ��� INSERT SQL �������� ���� ���̺� �����͸� �Է�
INSERT ALL
    INTO emp_test
    INTO emp_test2
SELECT 1, 'brown' FROM dual UNION ALL
SELECT 2, 'sally' FROM dual;
--INSERT ������ Ȯ��
SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

--INSERT ALL �÷� ����
ROLLBACK;
INSERT ALL
    INTO emp_test (empno) VALUES (empno)
    INTO emp_test2 VALUES (empno, ename)
SELECT 1 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;
ROLLBACK;

--multiple insert (conditional insert)
SELECT * FROM emp_test2;


--INSERT FIRST
--���ǿ� �����ϴ� ù��° INSERT ������ ����
ROLLBACK;
INSERT FIRST
    when empno > 10 then
        INTO emp_test (empno) VALUES (empno)
    when empno > 5 then   
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual;

SELECT * FROM emp_test;
SELECT * FROM emp_test2;



--MERGE : ���ǿ� �����ϴ� �����Ͱ� ������ UPDATE
--        ���ǿ� �����ϴ� �����Ͱ� ������ INSERT
--empno�� 7369�� �����͸� emp ���̺�� ���� ����(insert)
INSERT INTO emp_test 
SELECT empno, ename
FROM emp
WHERE EMPNO = 7369;

SELECT *
FROM emp_TEST;

ALTER TABLE emp_test MODIFY (ename VARCHAR2(20));
--emp���̺� �����ϴ� �����ʹ� emp_test���̺��� empno�� ���� ���� ���� �����Ͱ� ���� ���
-- emp_test.ename = ename || '_merge' ������ update
-- �����Ͱ� ���� ��쿡�� emp_test���̺� insert
MERGE INTO emp_test
USING (SELECT empno, enmae
        FROM emp
        WHERE emp.empno IN (7369, 7499))emp
 ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN 
    UPDATE SET ename = emp.ename || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES ( emp.empno, emp.ename);

SELECT *
FROM emp_test;


--�ٸ� ���̺��� ������ �ʰ� ���̺� ��ü�� ������ ���� ������
--merge �ϴ� ���
ROLLBACK;

-- empno = 1, ename = 'brown'
-- empno�� ���� ���� ������ ename�� 'brown'���� ������Ʈ
-- empno�� ���� ���� ������ �ű� insert
MERGE INTO emp_test
USING dual
 ON ( emp_test.empno = 1)
WHEN MATCHED THEN
    UPDATE set ename = 'brown'
WHEN NOT MATCHED THEN
    INSERT VALUES (1, 'brown');

SELECT 'X'
FROM emp_test
WHERE empno = 1;

UPDATE emp_test set ename = 'brown' || '_merge'
WHERE empno = 1;

INSERT INTO emp_test VALUES (1, 'brown');

SELECT *
FROM emp_test;
ROLLBACK;



--�ǽ� GROUP_AD1
SELECT  DEPTNO,SUM(SAL)sal
FROM EMP
GROUP BY DEPTNO

UNION ALL  --�� �Ʒ� �� ������ ��ħ ����X

SELECT NULL, SUM(SAL)sal
FROM emp;
--�� ������ ROLLUP���·� ����
SELECT DEPTNO, SUM(SAL)sal
FROM emp
GROUP BY ROLLUP(DEPTNO);



--rollup
--group by�� ���� �׷��� ����
--GROUP BY ROLLUP( {col, } )
--�÷��� �����ʿ������� �����ذ��鼭 ���� ����׷���
--GROUP BY �Ͽ� UNION �� �Ͱ� ����
--ex : GROUP BY ROLLUP (job, deptno)
--     GROUP BY job, deptno
--     UNION
--     GROUP BY job
--     UNION
--     GROUP BY => �Ѱ� (��� �࿡ ���� �׷��Լ� ����)
SELECT job, deptno, SUM(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);



--GROUPING SETS (col1, col2...)
--GROUPING SETS�� ������ �׸��� �ϳ��� ����׷����� GROUP BY ���� �̿�ȴ�.

--GROUP BY col1
--UNION ALL
--GROUP BY col2

--emp ���̺��� �̿��Ͽ� �μ��� �޿��հ�, ������(job)�� �޿����� ���Ͻÿ�.

--�μ���ȣ, job, �޿��հ�
SELECT deptno, NULL job, SUM(sal)sal
FROM emp
GROUP BY deptno

UNION ALL

SELECT NULL deptno, job, SUM(sal)sal
FROM emp
GROUP BY job;

--GROUPING SETS
SELECT deptno, job, SUM(sal)
FROM emp
GROUP BY GROUPING SETS(deptno, job, (deptno, job));
