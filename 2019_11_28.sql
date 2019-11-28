--���� �ǽ�PRO_3 (PL/SQL)
CREATE OR REPLACE PROCEDURE UPDATEdept_test(a IN dept.deptno%TYPE, b IN dept.dname%TYPE, c IN dept.loc%TYPE)
IS

BEGIN
    UPDATE dept_test
    SET deptno = a, dname = b, loc = c 
    WHERE deptno = a;
    COMMIT;
      
    dbms_output.put_line('deptno,dname,loc = ' || a || ',' || b || ',' || c);
END;
/
exec UPDATEdept_test(99, 'ddit_m', 'daejeon');

SELECT *
FROM DEPT_test;



--ROWTYPE : ���̺��� �� ���� �����͸� ���� �� �ִ� ���� Ÿ��

DECLARE
    dept_row dept%ROWTYPE;
BEGIN
    SELECT *
    INTO dept_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line(dept_row.deptno || ',' || 
                         dept_row.dname || ',' || 
                         dept_row.loc);
END;
/
set SERVEROUTPUT on;


--���պ��� : record
DECLARE
    --UserVo userVo;
    TYPE dept_row IS RECORD(
        deptno NUMBER(2),
        dname dept.dname%TYPE);
        
    v_dname dept.dname%TYPE;
    v_row dept_row;
BEGIN
    SELECT deptno, dname
    INTO v_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line(v_row.deptno || ',' || v_row.dname);
END;
/



--tabletype
DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    --java = Ÿ�� ������;
    --Pl/sql = ������ Ÿ��;
    v_dept dept_tab;
    bi BINARY_INTEGER;
BEGIN
    SELECT *
    BULK COLLECT INTO v_dept
    FROM dept;
    
    FOR i IN 1..v_dept.count LOOP
        dbms_output.put_line(v_dept(i).dname);
    END LOOP;    
    
--    dbms_output.put_line(v_dept(1).dname);
--    dbms_output.put_line(v_dept(2).dname);
--    dbms_output.put_line(v_dept(3).dname);
--    dbms_output.put_line(v_dept(4).dname);
END;
/




--IF
--ELSE IF --> ELSIF
--END IF;  �� ������
DECLARE
    ind BINARY_INTEGER;
BEGIN
    ind := 2;
    
    IF ind = 1 THEN dbms_output.put_line(ind);
    ELSIF ind = 2 THEN dbms_output.put_line('ELSIF' || ' ' || ind);
    ELSE dbms_output.put_line('ELSE');
    END IF;    
END;
/


--FOR LOOP :
--FOR �ε��� ���� IN ���۰�..���ᰪ LOOP
--END LOOP
DECLARE
BEGIN
    FOR i IN 0..5 LOOP
        dbms_output.put_line('i : ' || i);
    END LOOP;
END;
/



--LOOP : ��� ���� �Ǵ� ������ LOOP �ȿ��� ����
--java : while(true)

DECLARE 
    i NUMBER;
BEGIN
    i := 0;
    
    LOOP
        dbms_output.put_line(i);
        i := i+1;
        --loop ��� ���࿩�� �Ǵ�
        EXIT WHEN i >= 5;
    END LOOP;    
END;    
/



--PRO_3 (PL/SQL)
--���� ��� : 5��
SELECT *
FROM DT;
/
DECLARE
    TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
    dta dt_tab;
    i NUMBER;
    s NUMBER;
BEGIN
    SELECT *
    BULK COLLECT INTO dta
    FROM DT;
    
    s := 0;
    
    FOR i IN 2..dta.count LOOP
     s := s + (dta(i-1).dt - dta(i).dt);       
    END LOOP;    
    dbms_output.put_line('sum : ' || s);
    dbms_output.put_line('AVG : ' || s/(dta.count-1));
END;    
/


--LEAD, LAG �������� ����, ���� �����͸� ������ �� �ִ�.
SELECT DT,
       LEAD(DT) OVER (ORDER BY DT DESC) lead_DT,
       DT - LEAD(DT) OVER (ORDER BY DT DESC) lead_DT
FROM DT
ORDER BY DT DESC;



--�м��Լ��� ������� ���ϴ� ȯ�濡��...
SELECT AVG(a.dt - b.dt)
FROM
    (SELECT ROWNUM rn, dt
    FROM
        (SELECT *
        FROM DT
        ORDER BY DT DESC)) a
        ,
    (SELECT ROWNUM-1 rn1, dt
    FROM
        (SELECT *
        FROM DT
        ORDER BY DT DESC)) b
WHERE a.rn = b.rn1(+);   
    


--HALL OF HONOR
SELECT (MAX(dt) - MIN(dt)) / (COUNT(*)-1) avg 
FROM DT;

DECLARE
    --Ŀ�� ����
    CURSOR dept_cursor IS
        SELECT deptno, dname FROM dept;
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    --Ŀ�� ����
    OPEN dept_cursor;
    LOOP
        FETCH dept_cursor INTO v_deptno, v_dname;
        DBMS_OUTPUT.PUT_LINE(v_deptno || ',' || v_dname);
        EXIT WHEN dept_cursor%NOTFOUND; --���̻� ���� �����Ͱ� ���� �� ����
    END LOOP;
END;
/



--FOR LOOP CURSOR ����
DECLARE 
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
    v_deptno dept.deptno%TYPE;
    v_name dept.dname%TYPE;
BEGIN
    FOR rec IN dept_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(rec.deptno || ','|| rec.dname);
    END LOOP;
END;
/



--�Ķ���Ͱ� �ִ� ����� Ŀ��
DECLARE 
    CURSOR emp_cursor(p_job emp.job%TYPE) IS
        SELECT empno, ename, job
        FROM emp
        WHERE job = p_job;
    v_empno emp.empno%TYPE;
    v_ename emp.ename%TYPE;
    v_job emp.job%TYPE;
BEGIN
    FOR emp IN emp_cursor('SALESMAN') LOOP
        DBMS_OUTPUT.PUT_LINE(emp.empno || ',' || emp.ename || ',' || emp.job);
    END LOOP;
END;
/
