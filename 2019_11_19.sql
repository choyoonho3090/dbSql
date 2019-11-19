--버거킹, 맥도날드, KFC 개수
SELECT SIDO, SIGUNGU, COUNT(*)cnt
FROM fastfood
WHERE GB IN ('버거킹', '맥도날드','KFC')
GROUP BY SIDO,SIGUNGU;

--롯데리아 개수
SELECT SIDO, SIGUNGU, COUNT(*)cnt
FROM fastfood
WHERE GB = '롯데리아'
GROUP BY SIDO,SIGUNGU;

--(버거킹+맥도날드+KFC)/롯데리아
SELECT a.sido, a.sigungu, a.cnt kmb, b.cnt lotte, round(a.cnt/b.cnt,2) point
FROM 
    (SELECT SIDO, SIGUNGU, COUNT(*)cnt
    FROM fastfood
    WHERE GB IN ('버거킹', '맥도날드','KFC')
    GROUP BY SIDO,SIGUNGU) a,           --조인
    (SELECT SIDO, SIGUNGU, COUNT(*)cnt
    FROM fastfood
    WHERE GB = '롯데리아'
    GROUP BY SIDO,SIGUNGU)b
WHERE a.sido = b.sido
  AND a.SIGUNGU = b.SIGUNGU
ORDER BY point DESC;

--연말정산 납입액
SELECT SIDO, SIGUNGU, ROUND(SAL/PEOPLE,2) POINT
FROM TAX
ORDER BY POINT DESC;

SELECT SIDO, SIGUNGU, SAL, ROUND(SAL/PEOPLE,2) POINT
FROM TAX
ORDER BY SAL DESC;


--버거지수 시도,시군구  :  연말정산 시도 시군구
--시도, 시군구, 버거지수, 시도, 시군구, 연말정산 납입액
SELECT a.*, b.*
FROM 
    (SELECT a.*, ROWNUM RN 
     FROM
        (SELECT a.sido, a.sigungu, a.cnt kmb, b.cnt l,
               round(a.cnt/b.cnt, 2) point
        FROM 
            --140건
            (SELECT SIDO, SIGUNGU, COUNT(*) cnt
            FROM fastfood
            WHERE gb IN ('KFC', '버거킹', '맥도날드')
            GROUP BY SIDO, SIGUNGU) a,
            
            --188건
            (SELECT SIDO, SIGUNGU, COUNT(*) cnt
            FROM fastfood
            WHERE gb IN ('롯데리아')
            GROUP BY SIDO, SIGUNGU) b
            WHERE a.sido = b.sido
            AND a.sigungu = b.sigungu
        ORDER BY point DESC )a ) a,
    
    (SELECT b.*, rownum rn
    FROM 
    (SELECT sido, sigungu
    FROM TAX
    ORDER BY sal DESC) b ) b
WHERE b.rn = a.rn(+)
ORDER BY b.rn;


--emp_test 테이블 제거
DROP TABLE emp_TEST;




--multiple insert를 위한 테스트 테이블 생성
--empno, ename 두개의 컬럼을 갖는 emp_test, emp_test2 테이블을
--emp 테이블로 부터 생성한다 (CTAS_
--데이터는 복제하지 않는다.

CREATE TABLE emp_test AS;
CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp
WHERE 1 = 2;



--INSERT ALL
--하나의 INSERT SQL 문장으로 여러 테이블에 데이터를 입력
INSERT ALL
    INTO emp_test
    INTO emp_test2
SELECT 1, 'brown' FROM dual UNION ALL
SELECT 2, 'sally' FROM dual;
--INSERT 데이터 확인
SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

--INSERT ALL 컬럼 정의
ROLLBACK;
INSERT ALL
    INTO emp_test (empno) VALUES (empno)
    INTO emp_test2 VALUES (empno, ename)
SELECT 1 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;
ROLLBACK;

--multiple insert (conditional insert)
SELECT * FROM emp_test2;


--INSERT FIRST
--조건에 만족하는 첫번째 INSERT 구문만 실행
ROLLBACK;
INSERT FIRST
    when empno > 10 then
        INTO emp_test (empno) VALUES (empno)
    when empno > 5 then   
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual;

SELECT * FROM emp_test;
SELECT * FROM emp_test2;



--MERGE : 조건에 만족하는 데이터가 있으면 UPDATE
--        조건에 만족하는 데이터가 없으면 INSERT
--empno가 7369인 데이터를 emp 테이블로 부터 복사(insert)
INSERT INTO emp_test 
SELECT empno, ename
FROM emp
WHERE EMPNO = 7369;

SELECT *
FROM emp_TEST;

ALTER TABLE emp_test MODIFY (ename VARCHAR2(20));
--emp테이블에 존재하는 데이터는 emp_test테이블의 empno와 같은 값을 갖는 데이터가 있을 경우
-- emp_test.ename = ename || '_merge' 값으로 update
-- 데이터가 없을 경우에는 emp_test테이블에 insert
MERGE INTO emp_test
USING (SELECT empno, enmae
        FROM emp
        WHERE emp.empno IN (7369, 7499))emp
 ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN 
    UPDATE SET ename = emp.ename || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES ( emp.empno, emp.ename);

SELECT *
FROM emp_test;


--다른 테이블을 통하지 않고 테이블 자체의 데이터 존재 유무로
--merge 하는 경우
ROLLBACK;

-- empno = 1, ename = 'brown'
-- empno가 같은 값이 있으면 ename을 'brown'으로 업데이트
-- empno가 같은 값이 없으면 신규 insert
MERGE INTO emp_test
USING dual
 ON ( emp_test.empno = 1)
WHEN MATCHED THEN
    UPDATE set ename = 'brown'
WHEN NOT MATCHED THEN
    INSERT VALUES (1, 'brown');

SELECT 'X'
FROM emp_test
WHERE empno = 1;

UPDATE emp_test set ename = 'brown' || '_merge'
WHERE empno = 1;

INSERT INTO emp_test VALUES (1, 'brown');

SELECT *
FROM emp_test;
ROLLBACK;



--실습 GROUP_AD1
SELECT  DEPTNO,SUM(SAL)sal
FROM EMP
GROUP BY DEPTNO

UNION ALL  --위 아래 두 쿼리를 합침 조인X

SELECT NULL, SUM(SAL)sal
FROM emp;
--위 쿼리를 ROLLUP형태로 변경
SELECT DEPTNO, SUM(SAL)sal
FROM emp
GROUP BY ROLLUP(DEPTNO);



--rollup
--group by의 서브 그룹을 생성
--GROUP BY ROLLUP( {col, } )
--컬럼을 오른쪽에서부터 제거해가면서 나온 서브그룹을
--GROUP BY 하여 UNION 한 것과 동일
--ex : GROUP BY ROLLUP (job, deptno)
--     GROUP BY job, deptno
--     UNION
--     GROUP BY job
--     UNION
--     GROUP BY => 총계 (모든 행에 대해 그룹함수 적용)
SELECT job, deptno, SUM(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);



--GROUPING SETS (col1, col2...)
--GROUPING SETS의 나열된 항목이 하나의 서브그룹으로 GROUP BY 절에 이용된다.

--GROUP BY col1
--UNION ALL
--GROUP BY col2

--emp 테이블을 이용하여 부서별 급여합과, 담당업무(job)별 급여합을 구하시오.

--부서번호, job, 급여합계
SELECT deptno, NULL job, SUM(sal)sal
FROM emp
GROUP BY deptno

UNION ALL

SELECT NULL deptno, job, SUM(sal)sal
FROM emp
GROUP BY job;

--GROUPING SETS
SELECT deptno, job, SUM(sal)
FROM emp
GROUP BY GROUPING SETS(deptno, job, (deptno, job));
