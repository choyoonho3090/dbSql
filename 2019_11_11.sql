--SMITH, WARD �� ���ϴ� �μ��� ������ ��ȸ
SELECT *
FROM emp
WHERE deptno IN (10, 20);

SELECT *
FROM emp
WHERE deptno = 10
   OR deptno = 20;
   

SELECT *
FROM emp
WHERE deptno IN (SELECT deptno FROM emp WHERE ename IN ('SMITH', 'WARD'));

SELECT *
FROM emp
WHERE deptno IN (SELECT deptno FROM emp WHERE ename IN (:name1, :name2));

-- ANY : set�߿� �����ϴ°� �ϳ��� ������ ������(ũ���)
-- SMITH, WARD �λ���� �޿� �߿��� ���� �޿��� �޴� ���� ���� ��ȸ
SELECT ENAME,sal 
FROM emp 
WHERE ename IN ('SMITH','WARD');

--SMITH�� WARD���� �޿��� ���� ���� ��ȸ
--SMITH���ٵ� �޿��� ���� WARD���ٵ� �޿��� ���� ���(AND)
SELECT *
FROM emp
WHERE sal > ANY(SELECT sal  --800 OR 1250 ���� ���� �޿�
                FROM emp 
                WHERE ename IN ('SMITH','WARD')); --SMITH�� WARD ���� ���� �޿�

--NOT IN

--�������� ��������
--1.�������� ����� ��ȸ
--  . MGR�÷��� ���� ������ ����
SELECT DISTINCT MGR
FROM emp;

--� ������ ������ ������ �ϴ� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE EMPNO IN (7839,7782,7698,7902,7566,7788);

SELECT *
FROM emp
WHERE EMPNO IN (SELECT MGR  --7839,7782,7698,7902,7566,7788
                FROM emp)
ORDER BY EMPNO;

--������ ������ ���� �ʴ� �� ��� ���� ��ȸ
--�� NOT IN������ ���� SET�� NULL�� ���Ե� ��� ���������� �������� �ʴ´�.
--NULLó�� �Լ��� WHERE���� ���� NULL���� ó���� ���� ���
SELECT *
FROM emp     --7839,7782,7698,7902,7566,7788�� ���Ե��� �ʴ� ��� ��ȸ
WHERE EMPNO NOT IN (SELECT MGR 
                    FROM emp
                    WHERE MGR IS NOT NULL);


--pair wise
--��� 7499, 7782�� ������ ������, �μ���ȣ ��ȸ
--7698 30
--7839 10
--(7698, 30), (7839, 10), (7698, 10), (7839, 30)
SELECT mgr, deptno
FROM emp
WHERE empno IN (7499, 7782);

--���� �߿� �����ڿ� �μ���ȣ�� (7698, 30) �̰ų�, (7839, 10)�� ���
--mgr, deptno �÷��� [����]�� ���� ��Ű�� ���� ���� ��ȸ
--(7698, 30), (7839, 10), (7698, 10), (7839, 30)
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));
--(7698, 30), (7839, 10)
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
               FROM emp
               WHERE empno IN (7499, 7782))
AND deptno IN (SELECT deptno
               FROM emp
               WHERE empno IN (7499, 7782));


--SCALAR SUBQUERY : SELECT ���� �����ϴ� ���� ����(��, ���� �ϳ��� ��, �ϳ��� ���)
--������ �Ҽ� �μ����� JOIN�� ������� �ʰ� ��ȸ
SELECT dname
FROM dept
WHERE deptno = 20;

SELECT empno, ename, deptno, (SELECT dname
                              FROM dept
                              WHERE deptno = emp.deptno) dname
FROM emp;


--sub4 ������ ����
SELECT *
FROM DEPT;

INSERT INTO dept VALUES (99, 'ddit','daejeon');

SELECT * 
FROM emp 
ORDER BY DEPTNO;

SELECT *
FROM DEPT
WHERE DEPTNO NOT IN (SELECT DEPTNO 
                     FROM emp);


--sub5 
SELECT * FROM CYCLE;
SELECT * FROM PRODUCT;

SELECT PID
FROM CYCLE
WHERE CID = 1;

SELECT *
FROM PRODUCT
WHERE PID NOT IN (SELECT PID
              FROM CYCLE
              WHERE CID = 1);


--sub6
SELECT *    --100,200
FROM CYCLE
WHERE CID = 2;

SELECT *    
FROM CYCLE
WHERE CID = 1   --100,400
  AND PID IN (SELECT PID    
              FROM CYCLE
              WHERE CID = 2); --2�� ���� �Դ� ��ǰ
  

--EXISTS MAIN������ �÷��� ����ؼ� SUBQUERY�� �����ϴ� ������ �ִ��� üũ
--�����ϴ� ���� �ϳ��� �����ϸ� ���̻� �������� �ʰ� ���߱� ������ ���ɸ鿡�� ����

--MGR�� �����ϴ� ���� ��ȸ
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'X'
              FROM emp
              WHERE empno = a.mgr);
              
--MGR�� �������� �ʴ� ���� ��ȸ              
SELECT *
FROM emp a
WHERE NOT EXISTS (SELECT 'X'
              FROM emp
              WHERE empno = a.mgr);


--sub7
SELECT * FROM cycle;
SELECT * FROM product;
SELECT * FROM CUSTOMER;
--ORACLE
SELECT 1, CNM, b.PID, pnm, day, cnt       
FROM CYCLE a, PRODUCT b, CUSTOMER c 
WHERE a.CID = 1
  AND b.PID IN (SELECT PID    
              FROM CYCLE
              WHERE CID = 2)
  AND a.pid = b.pid
  AND a.cid = c.cid
ORDER BY DAY DESC;
--ANSI
SELECT 1, CNM, b.pid, pnm, day, cnt
FROM CYCLE a JOIN PRODUCT b ON (a.PID = b.PID) 
             JOIN CUSTOMER C ON (a.CID = c.CID)
WHERE a.CID = 1
  AND b.PID IN (SELECT PID    
              FROM CYCLE
              WHERE CID = 2)
ORDER BY DAY DESC;


--sub8
SELECT *
FROM emp
WHERE MGR IS NULL; 

SELECT *
FROM emp a
WHERE EXISTS (SELECT 'X'
                  FROM emp b
                  WHERE b.empno = a.mgr);


--sub9
SELECT * FROM CYCLE;
SELECT * FROM PRODUCT;

SELECT *
FROM PRODUCT 
WHERE EXISTS (SELECT 1
              FROM CYCLE 
              WHERE PRODUCT.PID = CYCLE.PID
                AND PID IN (200,300));


--�μ��� �Ҽӵ� ������ �ִ� �μ� ���� ��ȸ
SELECT *
FROM DEPT
WHERE DEPTNO IN (10,20,30);

SELECT *
FROM DEPT
WHERE EXISTS (SELECT 1
              FROM EMP   
              WHERE DEPT.DEPTNO = EMP.DEPTNO);

SELECT *
FROM emp
WHERE EXISTS (SELECT 1
             FROM DEPT
             WHERE DEPT.DEPTNO = EMP.DEPTNO);


--���տ���
--UNTION : ������, �ߺ��� ����
--         DBMS������ �ߺ��� �����ϱ����� �����͸� ����
--         (�뷮�� �����Ϳ� ���� ���Ľ� ����)
--����� 7566 �Ǵ� 7698�� ��� ��ȸ(���,�̸� ��ȸ)
--UNION ALL : UNION�� ���� ����
--            �ߺ��� �������� �ʰ�, ���Ʒ� ������ ���� => �ߺ�����
--            ���Ʒ� ���տ� �ߺ��Ǵ� �����Ͱ� ���ٴ� ���� Ȯ���ϸ�
--            UNION �����ں��� ���ɸ鿡�� ����
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)

UNION

SELECT empno, ename
FROM emp
--WHERE empno = 7369 OR empno = 7499;
WHERE empno IN (7566, 7698);


--UNION ALL : �ߺ� ���
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)

UNION ALL

SELECT empno, ename
FROM emp
--WHERE empno = 7369 OR empno = 7499;
WHERE empno IN (7566, 7698);


--INTERSECT(������ : �� �Ʒ� ���հ� ���� ������)
SELECT empno, ename
FROM emp
--WHERE empno = 7369 OR empno = 7499;
WHERE empno IN (7566, 7698, 7499);


--MINUS(������ : �� ���տ��� �Ʒ� ������ ����)
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)

MINUS

SELECT empno, ename
FROM emp
--WHERE empno = 7369 OR empno = 7499;
WHERE empno IN (7566, 7698, 7499);


SELECT 1 n, 'x' m
FROM DUAL
UNION
SELECT 2, 'Y'
FROM DUAL
ORDER BY m DESC;


