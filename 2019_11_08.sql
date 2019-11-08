--���κ���
--���� �� ??
--RDBMS�� Ư���� ������ �ߺ��� �ִ� ������ ���踦 �Ѵ�.
--EMP ���̺��� ������ ������ ����, �ش� ������ �Ҽ� �μ�������
--�μ���ȣ�� ���� �ְ�, �μ���ȣ�� ���� dept ���̺�� ������ ����
--�ش� �μ��� ������ ������ �� �ִ�.

--���� ��ȣ, �����̸�, ������ �Ҽ� �μ���ȣ, �μ��̸�
--emp, dept
SELECT emp.empno, emp.ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--�μ���ȣ,�μ���,�ش�μ��� �ο���
--count(col) : col ���� �����ϸ� 1, null : 0
--             ����� �ñ��� ���̸� *
SELECT a.deptno, dname, count(empno)cnt
FROM dept a, emp b
WHERE a.deptno = b.deptno
ORDER BY a.deptno, dname;

--TOTAL ROW : 14
SELECT count(*),count(empno), count(mgr), count(comm) 
FROM emp;


--OUTER JOIN : ���ο� ���е� ������ �Ǵ� ���̺��� �����ʹ� ��ȸ�����
--                �������� �ϴ� ���� ����
--LEFT OUTER JOIN : JOIN KEYWORD ���ʿ� ��ġ�� ���̺��� ��ȸ ������ 
--                  �ǵ��� �ϴ� ���� ����
--RIGHT OUTER JOIN : JOIN KEYWORD �����ʿ� ��ġ�� ���̺��� ��ȸ ������
--                   �ǵ��� �ϴ� ���� ����
--FULL OUTER JOIN : LEFT OUTER JOIN + RIGHT OUTER JOIN - �ߺ�����                     
--���� ������, �ش� ������ ������ ���� outer join
--���� ��ȣ, �����̸�, ������ ��ȣ, ������ �̸�
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b on(a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a JOIN emp b on(a.mgr = b.empno);

--oracle outer join (left, right�� ���� fullouter�� �������� ����)
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+);

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno;


-- ANSI LEFT OUTER
SELECT a.empno, a.ename, a.mgr, a.ename
FROM emp a LEFT OUTER JOIN emp b on (a.mgr = b.empno)
WHERE b.deptno = 10;

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+)
  AND b.deptno = 10;

--oracle outer ���������� outer ���̺��� �Ǵ� ��� �÷��� (+)�� �ٿ����
--outer joing�� ���������� �����Ѵ�.
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+)
  AND b.deptno(+) = 10;
  
  
--ANSI RIGTH OUTER
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a right outer join emp b on (a.mgr = b.empno);


--outerjoin1
SELECT  buyprod.buy_date, buyprod.buy_prod, prod.prod_id, prod.prod_name, buy_qty
FROM prod, buyprod
WHERE prod.prod_id = buyprod.buy_prod(+)
  AND buyprod.buy_date(+) = TO_date('2005/01/25', 'yyyy/mm/dd');

select *
from prod;

select *
from buyprod;

--outerjoin2,3
SELECT  To_DATE('05/01/25','YY/MM/DD')buy_date, buyprod.buy_prod, prod.prod_id, prod.prod_name, nvl(buy_qty, 0)buy_qty
FROM prod, buyprod
WHERE prod.prod_id = buyprod.buy_prod(+)
  AND buyprod.buy_date(+) = TO_date('2005/01/25', 'yyyy/mm/dd');

--outerjoin4
SELECT P.PID, PNM, '1'cid, nvl(day, 0)day, nvl(cnt, 0)cnt
FROM product p left outer join cycle c on(c.pid = p.pid AND cid =1);

SELECT b.pid, b.pnm, nvl(null, 1)cid, nvl(day,0)day, nvl(cnt,0)cnt
FROM cycle a, product b
WHERE a.pid(+) = b.pid 
  AND a.cid(+) = 1;

--outerjoin5
SELECT a.pid, a.cid, c.cnm, a.day, a.cnt
FROM
    (SELECT b.pid, b.pnm, nvl(null, 1)cid, nvl(day,0)day, nvl(cnt,0)cnt
    FROM cycle a, product b
    WHERE a.pid(+) = b.pid 
      AND a.cid(+) = 1)a , customer c
WHERE a.cid = c.cid;      
    
select *
from cycle;
select *
from product;
select *
from customer;

--crossjoin1
SELECT cid, cnm, pid, pnm
FROM customer cross join product;

select *
from customer;
select *
from product;


--subquery : main������ ���ϴ� �κ� ����
--���Ǵ� ��ġ : 
-- SELECT - scalar subquery (�ϳ��� ���, �ϳ��� �÷��� ��ȸ�Ǵ� �����̾�� �Ѵ�.)
-- FROM - inline view
-- WHERE - subquery

-- SCALAR subquery
SELECT empno, ename, SYSDATE now --���糯¥
FROM emp;

SELECT empno, ename, (SELECT SYSDATE FROM dual) now
FROM emp;

SELECT deptno  --20
FROM emp 
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE DEPTNO = (SELECT deptno  --20
               FROM emp 
               WHERE ename = 'SMITH');

--sub1 
SELECT ROUND(AVG(SAL), 2) 
FROM emp;

SELECT COUNT(SAL)
FROM emp
WHERE SAL >(SELECT AVG(SAL) FROM emp);

--sub2
SELECT *
FROM emp
WHERE SAL >(SELECT AVG(SAL) FROM emp);

--sub3
SELECT deptno 
FROM emp 
WHERE ename = 'SMITH' OR ename ='WARD';

SELECT *
FROM emp
WHERE deptno in (SELECT deptno FROM emp WHERE ename = 'SMITH' OR ename ='WARD');

