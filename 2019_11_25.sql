--member ���̺��� �̿��Ͽ� member2 ���̺��� ����
--member2 ���̺���
--������ ȸ��(mem_id = 'a001')�� ����(mem_id)�� '����'���� ������ 
--commit �ϰ� ��ȸ
CREATE TABLE member2 AS
(SELECT *
FROM member);

UPDATE member2 SET mem_id = '����' WHERE mem_id = 'a001';
COMMIT;

SELECT *
FROM MEMBER2
WHERE mem_id = '����';



--��ǰ�� ��ǰ ���� ����(BUY_QTY) �հ�, ��ǰ ���� �ݾ�(BUY_COST) �հ�
SELECT BUY_PROD, SUM(BUY_QTY), SUM(BUY_COST)
FROM buyprod
GROUP BY BUY_PROD;
--��ǰ�ڵ�, ��ǰ��, �����հ�, �ݾ��հ�
SELECT a.BUY_PROD, b.prod_name, SUM(BUY_QTY), SUM(BUY_COST) 
FROM buyprod a, prod b
WHERE a.buy_prod = b.prod_id
GROUP BY a.BUY_PROD, b.prod_name;
--VW_PROD_BUY(VIEW ����)
CREATE OR REPLACE VIEW VW_PROD_BUY AS
SELECT a.BUY_PROD, b.prod_name, SUM(BUY_QTY) sum_qty , SUM(BUY_COST) sum_cost 
FROM buyprod a, prod b
WHERE a.buy_prod = b.prod_id
GROUP BY a.BUY_PROD, b.prod_name;

SELECT *
FROM USER_VIEWS;



--�ǽ�ano0 (�м��Լ�/window�Լ�)
--����� �μ��� �޿�(sal)�� ���� ���ϱ�
--emp���̺� ���

--�μ��� ��ŷ
SELECT a.ename, a.sal, a.deptno, b.rn
FROM
    (SELECT a.ename, a.sal, a.deptno, ROWNUM j_rn
     FROM
    (SELECT ename, sal, deptno
     FROM emp
     ORDER BY deptno, sal DESC) a ) a
     , 
    (SELECT b.rn, ROWNUM j_rn
    FROM 
    (SELECT a.deptno, b.rn 
     FROM
        (SELECT deptno, COUNT(*) cnt --3, 5, 6
         FROM emp
         GROUP BY deptno )a
         ,
        (SELECT ROWNUM rn --1~14
         FROM emp) b
WHERE  a.cnt >= b.rn
ORDER BY a.deptno, b.rn ) b ) b
WHERE a.j_rn = b.j_rn;
--�μ��� ��ŷ(�κ� �Լ�)
SELECT ename, sal, deptno,
        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rn
FROM emp;

