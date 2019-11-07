-- ����
-- WHERE
-- ������
-- �� : =, !=, <>, >=, >, <=, <
-- BETWEEN start AND end
-- IN (set)
-- LIKE 'S%' ( % : �ټ��� ���ڿ��� ��Ī, _ : ��Ȯ�� �ѱ��� ��Ī)
-- IS NULL (!= NULL �� �߸��� ǥ�� ���)
-- AND, OR, NOT

-- emp ���̺��� �Ի����ڰ� 1981�� 6�� 1�Ϻ��� 1986�� 12�� 31�� ���̿� �ִ� �������� ��ȸ
-- BETWEEN AND
SELECT *
FROM emp
WHERE hiredate BETWEEN TO_DATE('1981/06/01', 'YYYY/MM/DD')
    AND TO_DATE('1986/12/31', 'YYYY/MM/DD');
-- >=, <=
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD')
    AND hiredate <= TO_DATE('1986/12/31', 'YYYY/MM/DD');

--emp ���̺��� ������(mgr)�� �ִ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- emp ���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϴ� ȸ�� ���� ��ȸ
SELECT *
FROM emp
WHERE job = 'SALESMAN'
    OR empno = 78
    OR empno >= 780 AND empno < 790
    OR empno >= 7800 AND empno < 7900;

-- emp ���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϸ鼭 �Ի����ڰ� 1981�� 6�� 1�� ������ ���� ���� ��ȸ
SELECT *
FROM emp
WHERE job = 'SALESMAN'
    OR (empno LIKE ('78%') AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD'));

-- order by �÷��� | ��Ī | �÷��ε��� [ASC | DESC]
-- order by ������ WHERE�� ������ ���
-- WHERE ���� ���� ��� FROM�� ������ ���
-- ename �������� �������� ����
SELECT *
FROM emp
ORDER BY ename;

-- ename �������� �������� ����
SELECT *
FROM emp
ORDER BY ename DESC;

-- job�� �������� ������������ ����, ���� job�� ������ ���(empno)���� �ø����� ����
SELECT *
FROM emp
ORDER BY job DESC, empno ASC;

-- ��Ī���� �����ϱ�
SELECT empno as "�����ȣ", ename as "����̸�", sal, sal*12 as "����"
FROM emp
ORDER BY '����';

-- SELECT�� �÷� ���� �ε����� ����
SELECT empno as "�����ȣ", ename as "����̸�", sal, sal*12 as "����"
FROM emp
ORDER BY 1;

-- dept���̺��� ��� ������ �μ��̸����� �������� ���ķ� ��ȸ
SELECT *
FROM dept
ORDER BY dname ASC;
    
-- dept���̺��� ��� ������ �μ���ġ�� �������� ���ķ� ��ȸ
SELECT *
FROM dept
ORDER BY loc DESC;

-- emp ���̺��� ��(comm) ������ �ִ� ����� ��ȸ�ϰ�, ��(comm)�� ���� �޴� ����� ���� ��ȸ�ǵ��� �ϰ�, �󿩰� ���� ��� ������� �������� �����ϼ���
SELECT *
FROM emp
WHERE comm IS NOT NULL
ORDER BY comm DESC, empno ASC;

-- emp ���̺��� �����ڰ� �ִ� ����鸸 ��ȸ�ϰ�, ����(job) ������ �������� �����ϰ�, ������ ���� ��� ����� ū ����� ���� ��ȸ
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job ASC, empno DESC;

-- emp ���̺��� 10�� �μ�(deptno) Ȥ�� 30�� �μ��� ���ϴ� ����� �޿�(sal)�� 1500�� �Ѵ� ����鸸 ��ȸ�ϰ� �̸����� �������� ����
SELECT *
FROM emp
WHERE deptno IN (10, 30) AND sal > 1500
ORDER BY ename DESC;

SELECT ROWNUM, empno, ename
FROM emp
WHERE rownum BETWEEN 1 AND 10;

-- emp���̺��� ���(empno), �̸�(ename)�� �޿� �������� �������� �����ϰ� ���ĵ� ��������� ROWNUM
SELECT ROWNUM, empno, ename, sal
FROM emp
ORDER BY sal;

SELECT ROWNUM, a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a;

-- emp ���̺��� ROWNUM ���� 1 ~ 10�� ���� ��ȸ (���ľ��� ����)
SELECT ROWNUM as RN, a.*
FROM
    (SELECT empno, ename, sal
    FROM emp
    ORDER BY sal ) a
WHERE ROWNUM BETWEEN 1 AND 10;

-- ROWNUM ���� 11 ~ 20�� ���� ��ȸ
SELECT *
FROM
(SELECT ROWNUM as RN, a.*
FROM
    (SELECT empno, ename
    FROM emp
    ORDER BY sal) a)
WHERE RN BETWEEN 11 AND 20;

-- FUNCTIOM
-- DUAL ���̺� ��ȸ
SELECT 'HELLO WORLD' as msg
FROM DUAL;

SELECT 'HELLO WORLD'
FROM emp;

-- ���ڿ� ��ҹ��� ���� �Լ�
-- LOWER, UPPER, INITCAP
SELECT LOWER ('hello, World'), UPPER ('Hello, World'), INITCAP ('Hello, World')
FROM emp
WHERE job = 'SALESMAN';

-- FUNCTION�� WHERE�������� ��밡��
SELECT *
FROM emp
WHERE LOWER(ename) = 'smith';

-- ������ SQL ĥ������
--1. �º��� �������� ���ƶ�
--�º�(TABLE�� �÷�) �� �����ϰ� �Ǹ� INDEX�� ���������� ������� ����
--Funcrion Based Index -> FBI

--CONCAT : ���ڿ� ���� - �ΰ��� ���ڿ��� �����ϴ� �Լ�
--SUBSTR : ���ڿ��� �κ� ���ڿ� (java : String.substring)
--LENGTH : ���ڿ��� ����
--INSTR : ���ڿ��� Ư�� ���ڿ��� �����ϴ� ù��° �ε���
--LPAD : ���ڿ��� Ư�� ���ڿ��� ����(���ʺ���)
SELECT CONCAT(CONCAT('HELLO', ', WOR'), 'LD') CONCAT,
        SUBSTR('HELLO, WORLD', 0, 5) substr,
        SUBSTR('HELLO, WORLD', 1, 5) substr1,
        LENGTH('HELLO, WORLD') length,
        INSTR('HELLO, WORLD', 'O') instr,
        -- INSTR(���ڿ�, ã�� ���ڿ�, ���ڿ��� Ư�� ��ġ ���� ǥ��)
        INSTR('HELLO, WORLD', 'O', 6) instr1,
        -- LPAD(���ڿ�, ��ü ���ڿ�����, ���ڿ��� ��ü���ڿ����̿� ��ġ�� ���Ұ�� �߰��� ����) ���ʺ���
        LPAD('HELLO, WORLD', 15, '*') lpad,
        LPAD('HELLO, WORLD', 15) lpad, -- �߰��� ���ڿ��� ���� ������ �������� ���Ե� (' ') �� ����
        -- RPAD(���ڿ�, ��ü ���ڿ�����, ���ڿ��� ��ü���ڿ����̿� ��ġ�� ���Ұ�� �߰��� ����) �����ʺ���
        RPAD('HELLO, WORLD', 15, '*') rpad
FROM dual;


dd
