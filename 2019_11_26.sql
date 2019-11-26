SELECT ename, sal, deptno,
        RANK() over (PARTITION BY deptno ORDER BY sal) rank,
        DENSE_RANK() over (PARTITION BY deptno ORDER BY sal) d_rank,
        ROW_NUMBER() over (PARTITION BY deptno ORDER BY sal) rown
FROM EMP;


--ana1 
--사원의 전체 급여 순위를 rank, dense_rank, row_number를 이용하여 구하세요.
--단, 급여가 동일한 것은 사번이 빠른 사람이 높은 순위가 되도록 작성하세요.
SELECT empno, ename,sal,deptno,
       RANK() OVER (ORDER BY sal DESC, empno) rank,
       DENSE_RANK() OVER (ORDER BY sal DESC ,empno) d_rank,
       ROW_NUMBER() OVER (ORDER BY sal DESC, empno) rown
FROM emp;


--no_ana2
--부서별 인원수
SELECT ename, empno, a.deptno, cnt
FROM
    (SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno) a
    ,
    (SELECT ename, empno, deptno
    FROM EMP) b
WHERE a.deptno = b.deptno
ORDER BY deptno;



--분석함수를 통한 부서별 직원 수
SELECT ename, empno, deptno, 
       COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;


--부서별 사원의 급여 합계
--SUM 분석함수
SELECT ename, empno, deptno, sal,
       SUM(sal) OVER (PARTITION BY deptno) sum_sal
FROM emp;


--ana2
SELECT empno, ename, sal, deptno, 
       ROUND(AVG(sal) OVER (PARTITION BY deptno), 2) cnt
FROM emp;       
       

--ana3
SELECT empno, ename, sal, deptno,
       MAX(sal) OVER (PARTITION BY deptno) min_sal
FROM emp;


--ana4
SELECT empno, ename, sal, deptno, 
       MIN(sal) OVER (PARTITION BY deptno) min_sal
FROM emp;



--부서별 사원번호가 가장 빠른사람
--부서별 사원번호가 가장 느린사람
--Windowing 재확인
SELECT empno, ename, deptno,
       FIRST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) f_emp, 
       LAST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) l_emp
FROM emp;


--LAG  (이전행)
--현재행
--LEAD (다음행)
--급여가 높은순으로 정렬 했을 때 자기보다 한단계 급여가 낮은 사람의 급여,
--                          자기보다 한단계 급여가 높은 사람의 급여
SELECT empno, ename, sal, 
       LAG(sal) OVER (ORDER BY sal) lag_sal,
       LEAD(sal) OVER (ORDER BY sal) lead_sal
FROM emp;



--ana5
SELECT empno, ename, hiredate, sal,
       LAG(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp;



--ana6
SELECT empno, ename, hiredate, job, sal,
       LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp;       



--no_ana3
SELECT e1.empno, ename, e1.sal, SUM(e2.sal) c_sum
FROM (SELECT e.*, ROWNUM rn
        FROM (SELECT empno, ename, sal
               FROM emp
               ORDER BY sal)e ) e1, 
      (SELECT e.*, ROWNUM rn
               FROM (SELECT empno, sal
                      FROM emp
                      ORDER BY sal) e) e2
WHERE e1.rn >= e2.rn
GROUP BY e1.empno, ename, e1.sal
ORDER BY sal, empno;



--WINOWING
--UNBOUNDED PRECEDING : 현재 행을 기준으로 선행하는 모든 행
--CURRENT ROW : 현재 행
--UNBOUNDED FOLLOWING : 현재 행을 기준으로 후행하는 모든 행
--N(정수) PRECEDING : 현재 행을 기준으로 선행하는 N개의 행
--N(정수) FOLLOWING : 현재 행을 기준으로 후행하는 N개의 행
SELECT empno, ename, sal,
       SUM(sal) OVER (ORDER BY sal, empno 
       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal,
       
       SUM(sal) OVER (ORDER BY sal, empno 
       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2,
       
       SUM(sal) OVER (ORDER BY sal, empno 
       ROWS BETWEEN 1  PRECEDING AND 1 FOLLOWING) sum_sal3
FROM emp;       


--ana7
SELECT empno, ename, deptno, sal, 
       SUM(sal) OVER (PARTITION BY deptno 
                      ORDER BY sal, empno     
                      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;



--ROWS
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (ORDER BY sal 
                      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum,              
       SUM(sal) OVER (ORDER BY sal 
                      ROWS UNBOUNDED PRECEDING) row_sum2
FROM emp;

--RANGE
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (ORDER BY sal 
                      RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum,              
       SUM(sal) OVER (ORDER BY sal 
                      RANGE UNBOUNDED PRECEDING) row_sum2
FROM emp;
