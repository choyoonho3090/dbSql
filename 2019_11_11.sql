--SMITH, WARD 가 속하는 부서의 직원들 조회
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

-- ANY : set중에 만족하는게 하나라도 있으면 참으로(크기비교)
-- SMITH, WARD 두사람의 급여 중에서 적은 급여를 받는 직원 정보 조회
SELECT ENAME,sal 
FROM emp 
WHERE ename IN ('SMITH','WARD');

--SMITH와 WARD보다 급여가 높은 직원 조회
--SMITH보다도 급여가 높고 WARD보다도 급여가 높은 사람(AND)
SELECT *
FROM emp
WHERE sal > ANY(SELECT sal  --800 OR 1250 보다 적은 급여
                FROM emp 
                WHERE ename IN ('SMITH','WARD')); --SMITH나 WARD 보다 적은 급여

--NOT IN

--관리자의 직원정보
--1.관리자인 사람만 조회
--  . MGR컬럼에 값이 나오는 직원
SELECT DISTINCT MGR
FROM emp;

--어떤 직원의 관리자 역할을 하는 직원 정보 조회
SELECT *
FROM emp
WHERE EMPNO IN (7839,7782,7698,7902,7566,7788);

SELECT *
FROM emp
WHERE EMPNO IN (SELECT MGR  --7839,7782,7698,7902,7566,7788
                FROM emp)
ORDER BY EMPNO;

--관리자 역할을 하지 않는 평 사원 정보 조회
--단 NOT IN연산자 사용시 SET에 NULL이 포함될 경우 정상적으로 동작하지 않는다.
--NULL처리 함수나 WHERE절을 통해 NULL값을 처리한 이후 사용
SELECT *
FROM emp     --7839,7782,7698,7902,7566,7788이 포함되지 않는 사원 조회
WHERE EMPNO NOT IN (SELECT MGR 
                    FROM emp
                    WHERE MGR IS NOT NULL);


--pair wise
--사번 7499, 7782인 직원의 관리자, 부서번호 조회
--7698 30
--7839 10
--(7698, 30), (7839, 10), (7698, 10), (7839, 30)
SELECT mgr, deptno
FROM emp
WHERE empno IN (7499, 7782);

--직원 중에 관리자와 부서번호가 (7698, 30) 이거나, (7839, 10)인 사람
--mgr, deptno 컬럼을 [동시]에 만족 시키는 직원 정보 조회
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


--SCALAR SUBQUERY : SELECT 절에 등장하는 서브 쿼리(단, 값이 하나의 행, 하나의 행렬)
--직원의 소속 부서명을 JOIN을 사용하지 않고 조회
SELECT dname
FROM dept
WHERE deptno = 20;

SELECT empno, ename, deptno, (SELECT dname
                              FROM dept
                              WHERE deptno = emp.deptno) dname
FROM emp;


--sub4 데이터 생성
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
              WHERE CID = 2); --2번 고객이 먹는 제품
  

--EXISTS MAIN쿼리의 컬럼을 사용해서 SUBQUERY에 만족하는 조건이 있는지 체크
--만족하는 값이 하나라도 존재하면 더이상 진행하지 않고 멈추기 때문에 성능면에서 유리

--MGR가 존재하는 직원 조회
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'X'
              FROM emp
              WHERE empno = a.mgr);
              
--MGR가 존재하지 않는 직원 조회              
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


--부서에 소속된 직원이 있는 부서 정보 조회
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


--집합연산
--UNTION : 합집합, 중복을 제거
--         DBMS에서는 중복을 제거하기위해 데이터를 정렬
--         (대량의 데이터에 대해 정렬시 부하)
--사번이 7566 또는 7698인 사원 조회(사번,이름 조회)
--UNION ALL : UNION과 같은 개념
--            중복을 제거하지 않고, 위아래 집합을 결합 => 중복가능
--            위아래 집합에 중복되는 데이터가 없다는 것을 확신하면
--            UNION 연산자보다 성능면에서 유리
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)

UNION

SELECT empno, ename
FROM emp
--WHERE empno = 7369 OR empno = 7499;
WHERE empno IN (7566, 7698);


--UNION ALL : 중복 허용
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698)

UNION ALL

SELECT empno, ename
FROM emp
--WHERE empno = 7369 OR empno = 7499;
WHERE empno IN (7566, 7698);


--INTERSECT(교집합 : 위 아래 집합간 공통 데이터)
SELECT empno, ename
FROM emp
--WHERE empno = 7369 OR empno = 7499;
WHERE empno IN (7566, 7698, 7499);


--MINUS(차집합 : 위 집합에서 아래 집합을 제거)
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


