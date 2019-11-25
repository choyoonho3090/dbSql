--LPAD('�� �ǵڿ� ���� ��',�ݺ���, '�ݺ��� ��') 

--h_2 �����ý��� ������ ���� �������� ��ȸ (dept0_02)
SELECT LEVEL lv,deptcd,
       LPAD(' ',4*(LEVEL-1),' ') || deptnm deptnm, p_deptcd
FROM dept_h a
START WITH deptcd = 'dept0_02'
CONNECT BY P_deptcd = PRIOR deptcd;


--h_3
--����� ��������
--Ư�� ���κ��� �ڽ��� �θ��带 Ž��(Ʈ�� ��ü Ž���� �ƴϴ�)
--���������� �������� ���� �μ��� ��ȸ
--�������� dept0_00_0
SELECT *
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;


--h_4 : ����� ����
SELECT *
FROM H_SUM;

SELECT LPAD(' ' ,4*(LEVEL-1),' ') || S_ID S_ID, VALUE
FROM H_SUM
START WITH S_ID = '0'
CONNECT BY PRIOR S_ID = PS_ID;


--h_5 
SELECT *
FROM no_emp;

SELECT LPAD(' ',4*(LEVEL-1),' ')|| ORG_CD ORG_CD, no_emp
FROM no_emp
START WITH ORG_CD = 'XXȸ��'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;



--pruning branch (����ġ��)
--������������ WHERE���� START WITH, CONNECT BY���� ���� ����� ���Ŀ� ����ȴ�.

--dept_h ���̺��� �ֻ��� ��� ���� ��������� ��ȸ
SELECT deptcd, LPAD(' ', 4*(LEVEL-0), ' ') || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--���������� �ϼ��� ���� WHERE���� ����ȴ�.
SELECT deptcd, LPAD(' ', 4*(LEVEL-0), ' ') || deptnm deptnm
FROM dept_h
WHERE deptnm != '������ȹ��'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;


SELECT deptcd, LPAD(' ', 4*(LEVEL-0), ' ') || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd
            AND deptnm != '������ȹ��';


--CONNECT_BY_ROOT(col) : col�� �ֻ��� ��� �÷� ��
--SYS_CONNECT_BY_PATH(col, ������) : col�� �������� ������ �����ڷ� ���� ���
--    .LTRIM�� ���� �ֻ��� ��� ������ �����ڸ� ���� �ִ� ���°� �Ϲ���
--CONNECT_BY_ISLEAF : �ش� row�� leaf node���� �Ǻ�( 1 : 0, O : X)
SELECT LPAD(' ',4*(LEVEL-1),' ') || org_cd org_cd,
       CONNECT_BY_ROOT(org_cd) root_org_cd,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-')path_org_cd,
       CONNECT_BY_ISLEAF
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;


--h_6
SELECT *
FROM board_test;

SELECT SEQ, LPAD(' ', 4*(LEVEL-1), ' ') || TITLE TITLE
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR SEQ = PARENT_SEQ;


--h_7
SELECT *
FROM board_test;

SELECT SEQ, LPAD(' ', 4*(LEVEL-1), ' ') || TITLE TITLE
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR SEQ = PARENT_SEQ
ORDER BY SEQ DESC;


--h_8
SELECT SEQ, LPAD(' ', 4*(LEVEL-1), ' ') || TITLE TITLE
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR SEQ = PARENT_SEQ
ORDER SIBLINGS BY SEQ DESC;


--h_9
SELECT SEQ, LPAD(' ', 4*(LEVEL-1), ' ') || TITLE TITLE
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR SEQ = PARENT_SEQ
ORDER SIBLINGS BY CASE 
                    WHEN parent_seq IS NULL THEN seq END DESC, 
                    SEQ;



SELECT ename, sal, ROWNUM rn
FROM
    (SELECT ename, sal
    FROM emp
    ORDER BY sal DESC);

