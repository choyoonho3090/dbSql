--전체 직원의 급여평균 (2073.21)
SELECT ROUND(AVG(sal),2)sal
FROM emp;

--부서별 직원의 급여 평균 10 XXXX, 20 YYYY, 30 ZZZZ
SELECT *
FROM
    (SELECT deptno, ROUND(AVG(sal),2)d_avsal
    FROM emp
    GROUP BY deptno)
WHERE d_avsal > (SELECT ROUND(AVG(sal),2)sal
                FROM emp);
                
--쿼리 블럭을 WITH절에 선언하여
--쿼리를 간단하게 표현한다.
WITH dept_avg_sal AS ( 
    SELECT deptno, ROUND(AVG(sal),2)d_avgsal
    FROM emp
    GROUP BY deptno
)
SELECT *
FROM dept_avg_sal
WHERE d_avgsal > (SELECT ROUND(AVG(sal),2)
                  FROM emp);
    
    
--달력 만들기
--STEP1. 해당 년월의 일자 만들기
--CONNECT BY LEVEL
-- iw = 년의 주차
-- w = 월의 주차
--201911
--DATE + 정수 = 일자 더하기 연산 
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
--달력만들기 복습 데이터.sql의 일별 실적 데이터를 이용하여
--1~6월의 월별 실적 데이터를 다음과 같이 구하세요.
SELECT (SELECT SUM(SALES) FROM sales WHERE TO_CHAR(DT, 'MM') = 01) jan,
       (SELECT SUM(SALES) FROM sales WHERE TO_CHAR(DT, 'MM') = 02) feb,
       NVL((SELECT SUM(SALES) FROM sales WHERE TO_CHAR(DT, 'MM') = 03), 0 ) mar,
       (SELECT SUM(SALES) FROM sales WHERE TO_CHAR(DT, 'MM') = 04) apr,
       (SELECT SUM(SALES) FROM sales WHERE TO_CHAR(DT, 'MM') = 05) may,
       (SELECT SUM(SALES) FROM sales WHERE TO_CHAR(DT, 'MM') = 06) jun
FROM dual;



--계층쿼리
--START WITH : 계층의 시작 부분을 정의
--CONNECT BY : 계층간 연결 조건을 정의

--하향식 계층쿼리 (가장 최상위 조직에서부터 모든 조직을 탐색

--h1
SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL-1)*4, ' ') || dept_h.deptnm
FROM dept_h
START WITH deptcd = 'dept0' --START WITH p_deptcd IS NULL;
CONNECT BY PRIOR deptcd = p_deptcd; --PRIOR : 현재 읽은 데이터
 

