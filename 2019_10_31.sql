--���̺��� ������ ��ȸ
/*
    SELECT �÷�, | express (���ڿ����) [as] ��Ī
    FROM �����͸� ��ȸ�� ���̺�(VIEW)
    WHERE ���� (condition)
*/
DESC user_tables;

SELECT *
FROM user_tables
WHERE TABLE_NAME != 'CART';

--���� �� ����
--�μ���ȣ�� 30�� ���� ũ�ų� ���� �μ��� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno >= 30;

--�μ���ȣ�� 30������ ���� �μ��� ���� ���� ��ȸ
SELECT *
FROM EMP
WHERE deptno < 30;

--�Ի����ڰ� 1982�� 1�� 1�� ������ ���� ��ȸ
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD');  --�Ʒ��� ���� TO_DATE�� ������ �ʾƵ� ������, ���������� �� �� �ֵ��� ���ִ°� ����.
--WHERE hiredate >= '1982/01/01';

--AND - WHERE ���� ������ �� �ٿ��� �� ����Ѵ�.

--col BETWEEN X AND Y ����
--�÷��� ���� X���� ũ�ų� ����, Y���� �۰ų� ���� ������
--�޿�(sal)�� 1000���� ũ�ų� ����, 2000���� �۰ų� ���� ������

SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

--���� BETWEEN AND �����ڴ� �Ʒ��� <=, >= ���հ� ����.
SELECT *
FROM emp
WHERE sal >= 1000 AND sal <= 2000 AND deptno = 30;

-- emp ���̺��� �Ի� ���ڰ� 1982�� 1�� 1�� ���ĺ��� 1983�� 1�� 1�� ������ ����� ename, hiredate ��ȸ
--      (�� �����ڴ� between�� ����Ѵ�.)

SELECT ename, hiredate
FROM emp
WHERE hiredate
    BETWEEN TO_DATE ('1982/01/01', 'YYYY/MM/DD')
    AND TO_DATE('1983/01/01', 'YYYY/MM/DD');
    
-- emp ���̺��� �Ի� ���ڰ� 1982�� 1�� 1�� ���ĺ��� 1983�� 1�� 1�� ������ ����� ename, hiredate ��ȸ
--      (�� �����ڴ� �񱳿����ڸ� ����Ѵ�.)

SELECT ename, hiredate
FROM emp
WHERE  hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD')
    AND hiredate <= TO_DATE('1983/01/01', 'YYYY/MM/DD');

-- IN������
-- COL IN (values...)
-- �μ���ȣ�� 10 Ȥ�� 20�� ���� ��ȸ

SELECT *
FROM emp
--WHERE deptno IN (10, 20); -- IN ������ ���
-- IN �����ڴ� OR �����ڷ� ǥ���� �� �ִ�.
WHERE deptno = 10
    OR deptno = 20; -- OR ������ ���
   
-- useris ���̺��� userid�� brown, cony, sally�� ������ ��ȸ
--  (IN ������ ���)

SELECT * FROM users;

SELECT userid as "���̵�", usernm as "�̸�", alias as "����"
FROM users
WHERE userid IN ('brown', 'cony', 'sally');

-- COL LIKE 'S%'
-- COL�� ���� �빮�� S�� �����ϴ� ��� ��
-- COL LIKE 'S____'
-- COL�� ���� �빮�� S�� �����ϰ� �̾ 4���� ���ڿ��� �����ϴ� ��

SELECT *
FROM emp
WHERE ename LIKE 'S%';

SELECT *
FROM emp
WHERE ename LIKE 'S____';

-- member ���̺��� ȸ���� ���� [��]���� ����� mem_id, mem_name�� ��ȸ
SELECT * FROM member;

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '��%';

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '��__';

-- member ���̺��� ȸ���� �̸��� ����[��]�� ���� ��� ����� mem_id, mem_name�� ��ȸ
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%��%';

-- NULL ��
-- COL IS NULL
-- EMP ���̺��� MGR ������ ���� ���(NULL) ��ȸ
SELECT *
FROM emp
WHERE MGR IS NULL;
-- WHERE MGR != NULL;   -- NULL �񱳰� �����Ѵ�.

-- �Ҽ� �μ��� 10���� �ƴ�������
SELECT *
FROM emp
WHERE deptno != '10';

SELECT * FROM emp;

-- emp ���̺��� ��(comm)�� �ִ� ȸ���� ������ ��ȸ
SELECT *
FROM emp
WHERE comm IS NOT NULL;

-- AND / OR
-- ������(mgr) ����� 7698�̰� �޿��� 1000 �̻��� ���
SELECT *
FROM emp
WHERE mgr = 7698
    AND sal > 1000;
    
-- emp ���̺��� ������(mgr) ����� 7698 �̰ų� �޿�(asl)�� 1000 �̻��� ���� ��ȸ
SELECT *
FROM emp
WHERE mgr = 7698
    OR sal >= 1000;

-- emp ���̺��� ������(mgr) ����� 7698�� �ƴϰ�, 7839�� �ƴ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839);  -- IN --> OR

-- ���� ������ AND/OR �����ڷ� ��ȯ
SELECT *
FROM emp
WHERE mgr NOT IN (7698)
    AND mgr NOT IN (7839);
    
-- IN, NOT IN �������� NULL ó��
-- emp ���̺��� ������(mgr) ����� 7698, 7839 �Ǵ� null�� �ƴ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839, NULL);
-- IN �����ڿ��� ������� NULL�� ���� ��� �ǵ����� ���� ������ �Ѵ�.

SELECT *
FROM emp
WHERE mgr NOT IN(7698, 7839)
    AND mgr IS NOT NULL;
    
-- emp ���̺��� job�� SALESMAN �̰� �Ի����ڰ� 1981�� 6�� 1�� ������ ���� ��ȸ
SELECT *
FROM emp
WHERE job IN ('SALESMAN')
    AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

-- emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ ���� ��ȸ (IN, NOT IN ������ ��� ����)
SELECT *
FROM emp
WHERE deptno != 10
    AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

-- emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ ���� ��ȸ (NOT IN ������ ���)
SELECT *
FROM emp
WHERE deptno NOT IN 10
    AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');
    
-- emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ���� ��ȸ(�μ��� 10, 20, 30�� �ִٰ� �����ϰ� IN ������ ���)
SELECT *
FROM emp
WHERE deptno IN (20, 30)
    AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

-- emp ���̺��� job�� SALESMAN�̰ų� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ���� ��ȸ
SELECT *
FROM emp
WHERE job = 'SALESMAN'
     OR hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');
   
-- emp ���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϴ� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE job = 'SALESMAN'
    OR empno LIKE '78%';

SELECT *
FROM emp
WHERE job = 'SALESMAN'
    OR empno > 7800 AND empno < 7900;
