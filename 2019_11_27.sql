SELECT *
FROM NO_emp;

--1. leaf node ã��
SELECT LPAD(' ',(LEVEL-1)*4,' ') || org_cd, s_emp
FROM
    (SELECT org_cd, parent_org_cd, SUM(s_emp) s_emp
    FROM
    (SELECT org_cd, parent_org_cd,
           SUM(no_emp/org_cnt) OVER (PARTITION BY GR 
                             ORDER BY rn
                             ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) s_emp
    FROM
    (SELECT a.*, ROWNUM rn, a.lv + ROWNUM gr,
            COUNT(org_cd) OVER (PARTITION BY org_cd) org_cnt
    FROM
        (SELECT org_cd, parent_org_cd, NO_EMP, LEVEL LV, CONNECT_BY_ISLEAF leaf
        FROM no_emp
        START WITH PARENT_ORG_CD IS NULL
        CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD) a
    START WITH leaf = 1
    CONNECT BY PRIOR parent_org_cd = org_cd))
    GROUP BY org_cd, parent_org_cd)
START WITH parent_org_cd IS NULL
 CONNECT BY PRIOR org_cd = parent_org_cd;




--PL/SQL
--�Ҵ翬�� :=
--System.out.println("") --> dbms_out.put_line("");
-- Log4j
--set serveroutput on; --��±���� Ȱ��ȭ

--PL/SQL
--declare : ����, ��� ����
--begin : ���� ����
--exception : ����ó��
DESC dept;

set serveroutput on;
DECLARE
    --���� ����
    deptno NUMBER(2);
    dname VARCHAR2(14);
BEGIN   
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;
    
    --SELECT ���� ����� ������ �� �Ҵ� �ߴ��� Ȯ��
    dbms_output.put_line('dname :' || dname || '(' || deptno || ')' );
END;
/


DECLARE
    --�������� ����(���̺� �÷�Ÿ���� ����ǵ� PL/SQL ������ ������ �ʿ䰡 ����)
    deptno dept.deptno%TYPE;
    dname dept.dname%TYPE;
BEGIN   
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;
    
    --SELECT ���� ����� ������ �� �Ҵ� �ߴ��� Ȯ��
    dbms_output.put_line('dname :' || dname || '(' || deptno || ')' );
END;
/

--10���μ��� �μ��̸��� LOC������ ȭ������ϴ� ���ν���
--���ν����� : printdept
-- CREATE OR REPLACE VIEW
CREATE OR REPLACE PROCEDURE printdept
IS
    --���� ����
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line('dname, loc = ' || dname || ',' || LOC);
END;    
/


exec printdept;


CREATE OR REPLACE PROCEDURE printdept_p(p_deptno IN dept.deptno%TYPE)
IS
    --���� ����
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = p_deptno;
    
    dbms_output.put_line('dname, loc = ' || dname || ',' || LOC);
END;    
/

exec printdept_p(30);



--���� �ǽ�PRO_1 (PL/SQL)
--procedure : printmap
--�Է� : �����ȣ
--��� : �����ȣ, �μ��̸�
CREATE OR REPLACE PROCEDURE printemp(a IN emp.empno%TYPE)
IS
    b emp.ename%TYPE;
    c dept.dname%TYPE;
BEGIN
    SELECT ename, dname
    INTO b, c
    FROM emp, dept
    WHERE emp.deptno = dept.deptno
      AND empno = a;
      
    dbms_output.put_line('ename, dname = ' || b || ',' || c);
END;    
/
exec printemp(7654);



--���� �ǽ�PRO_2 (PL/SQL)
CREATE OR REPLACE PROCEDURE registdept_test(a IN dept_test.deptno%TYPE, b IN dept_test.dname%TYPE, c IN dept_test.loc%TYPE)
IS

BEGIN
    INSERT INTO dept_test
    VALUES (a, b, c); 
    commit;
      
    dbms_output.put_line('deptno,dname,loc = ' || a || ',' || b || ',' || c);
END;
/
exec registdept_test('99','ddit','daejeon');

SELECT *
FROM dept_test;

DELETE dept_test
WHERE deptno = 99;

