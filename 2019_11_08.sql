--조인복습
--조인 왜 ??
--RDBMS의 특성상 데이터 중복을 최대 배제한 설계를 한다.
--EMP 테이블에는 직원의 정보가 존재, 해당 직원의 소속 부서정보는
--부서번호만 갖고 있고, 부서번호를 통해 dept 테이블과 조인을 통해
--해당 부서의 정보를 가져올 수 있다.

--직원 번호, 직원이름, 직원의 소속 부서번호, 부서이름
--emp, dept
SELECT emp.empno, emp.ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--부서번호,부서명,해당부서의 인원수
--count(col) : col 값이 존재하면 1, null : 0
--             행수가 궁금한 것이면 *
SELECT a.deptno, dname, count(empno)cnt
FROM dept a, emp b
WHERE a.deptno = b.deptno
ORDER BY a.deptno, dname;

--TOTAL ROW : 14
SELECT count(*),count(empno), count(mgr), count(comm) 
FROM emp;


--OUTER JOIN : 조인에 실패도 기준이 되는 테이블의 데이터는 조회결과가
--                나오도록 하는 조인 형태
--LEFT OUTER JOIN : JOIN KEYWORD 왼쪽에 위치한 테이블이 조회 기준이 
--                  되도록 하는 조인 형태
--RIGHT OUTER JOIN : JOIN KEYWORD 오른쪽에 위치한 테이블이 조회 기준이
--                   되도록 하는 조인 형태
--FULL OUTER JOIN : LEFT OUTER JOIN + RIGHT OUTER JOIN - 중복제거                     
--직원 정보와, 해당 직원의 관리자 정보 outer join
--직원 번호, 직원이름, 관리자 번호, 관리자 이름
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b on(a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a JOIN emp b on(a.mgr = b.empno);

--oracle outer join (left, right만 존재 fullouter는 지원하지 않음)
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

--oracle outer 문법에서는 outer 테이블이 되는 모든 컬럼에 (+)를 붙여줘야
--outer joing이 정상적으로 동작한다.
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


--subquery : main쿼리에 속하는 부분 쿼리
--사용되는 위치 : 
-- SELECT - scalar subquery (하나의 행과, 하나의 컬럼만 조회되는 쿼리이어야 한다.)
-- FROM - inline view
-- WHERE - subquery

-- SCALAR subquery
SELECT empno, ename, SYSDATE now --현재날짜
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

