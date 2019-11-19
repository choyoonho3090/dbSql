SELECT *
FROM USER_VIEWS;

SELECT *
FROM ALL_VIEWS
WHERE OWNER = 'PC12';

SELECT *
FROM PC12.V_EMP_DEPT;

--sem �������� ��ȸ������ ���� V_EMP_DEPT view�� �������� ��ȸ�ϱ�
--���ؼ��� ������.view�̸� �������� ����� �ؾ��Ѵ�.
--�Ź� �������� ����ϱ� �������Ƿ� Synonym�� ���� �ٸ� ��Ī�� ����

CREATE SYNONYM V_EMP_DEPT FOR PC12.V_EMP_DEPT;

--PC12.V_EMP_DEPT => V_EMP_DEPT
SELECT *
FROM V_EMP_DEPT;

SELECT *
FROM PC12.V_EMP_DEPT;

--synonym ����
DROP SYNONYM v_EMP_DEPT;

--hr ���� ��й�ȣ : java
--hr ���� ��й�ȣ ���� : hr
ALTER USER hr IDENTIFIED BY hr;
ALTER USER PC12 IDENTIFIED BY java; --���� ������ �ƴ϶� ����!!


--dictionary
--���ξ� : USER : ����� ���� ��ü
--        ALL : ����ڰ� ��밡���� ��ü
--        DBA : ������ ������ ��ü ��ü (�Ϲ� ����ڴ� ��� �Ұ�)
--        VS : �ý��۰� ���õ� view (�Ϲ� ����ڴ� ��� �Ұ�)

SELECT *
FROM USER_TABLES;

SELECT *
FROM DBA_TABLES
WHERE OWNER IN ('PC12','HR');


--����Ŭ���� ������ SQL�̶�?
--���ڰ� �ϳ��� Ʋ���� �ȵ�
--���� sql���� ��������� ����� ���� ���� DBMS������
--���� �ٸ� SQL�� �νĵȴ�
SELECT /*bind_test*/ * FROM emp;
Select /*bind_test*/ * FROM emp;
select /*bind_test*/ * FROM emp;
SELECT /*bind_test*/ * FROM emp WHERE empno=: empno;

--SYSTEM����
SELECT *
FROM V$SQL
WHERE SQL_TEXT LIKE '%bind_test%';

