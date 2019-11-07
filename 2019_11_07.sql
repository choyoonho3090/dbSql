SELECT empno, ename
FROM emp;
SELECT ename, deptno
FROM emp
GROUP BY ename, deptno;
-- emp ���̺��� �μ���ȣ(deptno)�� ����
-- emp ���̺��� �μ����� ��ȸ�ϱ� ���ؼ���
-- dept ���̺�� ������ ���� �μ��� ��ȸ

-- ���� ����
-- ANSI : ���̺� join ���̺�2 on(���� ���� (���̺�.�÷� = ���̺�2.�÷�));
--        emp JOIN dept ON (emp.deptno = dept.deptno)
-- ORACLE : FROM ���̺�, ���̺�2 WHERE ���̺�.�÷� = ���̺�2.�÷�
--          FROM emp, dept WHERE emp.detpno = dept.deptno

-- �����ȣ, �����, �μ���ȣ, �μ���
SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e JOIN dept d ON (e.deptno = d.deptno);

SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- emp, dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ (�޿� 2500 �ʰ�)
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND sal > 2500
ORDER BY deptno;

-- ANSI(JOIN ON) ���
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e JOIN dept d ON (e.deptno = d.deptno AND sal > 2500)
ORDER BY deptno;

-- emp,dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ ( �޿� 2500�ʰ�, ����� 7600 �ʰ� )
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND sal > 2500 AND empno > 7600
ORDER BY deptno;

-- ANSI (JOIN ON) ���
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e JOIN dept d ON (e.deptno = d.deptno)
AND sal > 2500 AND empno > 7600
ORDER BY deptno;

-- emp,dept ���̺��� �̿��Ͽ� ������ ���� ��ȸ ( �޿� 2500�ʰ�, ����� 7600 �ʰ� �ϰ� �μ����� RESEARCH�� �μ�)
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND sal > 2500 AND empno > 7600 AND dname = 'RESEARCH'
ORDER BY deptno;

-- ANSI (JOIN ON) ���
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e JOIN dept d ON (e.deptno = d.deptno)
AND sal > 2500 AND empno > 7600 AND dname = 'RESEARCH'
ORDER BY deptno;

-- erd ���̾�׷��� �����Ͽ� prod ���̺�� lprod ���̺��� ���� �Ͽ� ������ ���� ��ȸ
SELECT * FROM lprod;
SELECT * FROM prod;

SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM lprod, prod
WHERE lprod_gu = prod_lgu
ORDER BY prod_id;

-- ANSI (JOIN ON) ���
SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM lprod JOIN prod ON (lprod_gu = prod_lgu)
ORDER BY prod_id;

-- erd ���̾�׷��� �����Ͽ� buyer,prod ���̺��� �����Ͽ� buyer�� ����ϴ� ��ǰ ������ ��ȸ
SELECT * FROM buyer;
SELECT * FROM prod;

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer, prod
WHERE buyer_id = prod_buyer
ORDER BY prod_id;

-- ANSI (JOIN ON) ���
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer JOIN prod ON (buyer_id = prod_buyer)
ORDER BY prod_id;

-- erd ���̾�׷��� �����Ͽ� member, cart, prod ���̺��� �����Ͽ� ȸ���� ��ٱ��Ͽ� ���� ��ǰ���� ��ȸ
SELECT * FROM member;
SELECT * FROM cart;
SELECT * FROM prod;

SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
WHERE cart_member = mem_id AND prod_id = cart_prod;

-- ANSI (JOIN ON) ���
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member JOIN cart ON (cart_member = mem_id) JOIN prod ON (prod_id = cart_prod);

-- erd ���̾�׷��� �����Ͽ� customer, cycle ���̺��� �����Ͽ� ���� ���� ��ǰ, ��������, ������ ��ȸ
-- (������ brown,sally �� ��ȸ)
SELECT * FROM customer;
SELECT * FROM cycle;

SELECT c.cid, c.cnm, cy.pid, cy.day, cy.cnt
FROM customer c, cycle cy
WHERE c.cid = cy.cid
AND c.cnm IN ('brown','sally');

-- erd ���̾�׷��� �����Ͽ� customer,cycle,product ���̺��� �����Ͽ� ���� ������ǰ, ��������, ����, ��ǰ���� ��ȸ
-- (������ brown,sally �� ��ȸ)
SELECT * FROM customer;
SELECT * FROM cycle;
SELECT * FROM product;

SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid AND cycle.pid = product.pid
AND customer.cnm IN ('brown','sally');

-- erd ���̾�׷��� �����Ͽ� customer,cycle,product ���̺��� �����Ͽ� �������ϰ� ������� ���� ���� ��ǰ��, ������ �հ�, ��ǰ�� ��ȸ
SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, SUM(cycle.cnt)cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid AND cycle.pid = product.pid
GROUP BY cycle.cnt, product.pnm, customer.cid, customer.cnm, cycle.pid;

-- erd ���̾�׷��� �����Ͽ� cyclem product ���̺��� �̿��Ͽ� ��ǰ��, ������ �հ�, ��ǰ���� ��ȸ
SELECT * FROM cycle;
SELECT * FROM product;

SELECT cycle.pid, product.pnm, SUM(cycle.cnt) cnt
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY cycle.pid, product.pnm
ORDER BY pid;

