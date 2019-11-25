--member 테이블을 이용하여 member2 테이블을 생성
--member2 테이블에서
--김은대 회원(mem_id = 'a001')의 직업(mem_id)을 '군인'으로 변경후 
--commit 하고 조회
CREATE TABLE member2 AS
(SELECT *
FROM member);

UPDATE member2 SET mem_id = '군인' WHERE mem_id = 'a001';
COMMIT;

SELECT *
FROM MEMBER2
WHERE mem_id = '군인';



--제품별 제품 구매 수량(BUY_QTY) 합계, 제품 구입 금액(BUY_COST) 합계
SELECT BUY_PROD, SUM(BUY_QTY), SUM(BUY_COST)
FROM buyprod
GROUP BY BUY_PROD;
--제품코드, 제품명, 수량합계, 금액합계
SELECT a.BUY_PROD, b.prod_name, SUM(BUY_QTY), SUM(BUY_COST) 
FROM buyprod a, prod b
WHERE a.buy_prod = b.prod_id
GROUP BY a.BUY_PROD, b.prod_name;
--VW_PROD_BUY(VIEW 생성)
CREATE OR REPLACE VIEW VW_PROD_BUY AS
SELECT a.BUY_PROD, b.prod_name, SUM(BUY_QTY) sum_qty , SUM(BUY_COST) sum_cost 
FROM buyprod a, prod b
WHERE a.buy_prod = b.prod_id
GROUP BY a.BUY_PROD, b.prod_name;

SELECT *
FROM USER_VIEWS;



--실습ano0 (분석함수/window함수)
--사원의 부서별 급여(sal)별 순위 구하기
--emp테이블 사용

--부서별 랭킹
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
--부서별 랭킹(부분 함수)
SELECT ename, sal, deptno,
        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rn
FROM emp;

