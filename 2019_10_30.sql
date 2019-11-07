-- SELECT : ��ȸ�� �÷� ���
--        - ��ü �÷� ��ȸ : *
--        - �Ϻ� �÷� : �ش� �÷��� ���� (,����)
-- FROM : ��ȸ�� ���̺� ���
-- ������ �����ٿ� ����� �ۼ��ص� ��� ����
-- �� keyword�� �ٿ��� �ۼ�

-- ��� �÷��� ��ȸ
SELECT * FROM prod;

-- Ư�� �÷��� ��ȸ
SELECT prod_id, prod_name FROM prod;

--1�� lprod ���̺��� ��� �÷���ȸ
SELECT * FROM lprod;

--2�� buyer ���̺��� buyer_id, buyer_name ��ȸ
SELECT buyer_id, buyer_name FROM buyer;

--3�� cart ���̺��� ��� �÷���ȸ
SELECT * FROM cart;

--4�� member ���̺��� mem_id, mem_pass, mem_name �÷� ��ȸ
SELECT mem_id, mem_pass, mem_name FROM member;

-- ������ / ��¥����(date Ÿ�� + ���� : ���ڸ� ���Ѵ�)
-- null�� ������ ������ ����� �׻� null �̴�

SELECT userid, usernm, reg_dt,
    reg_dt + 5 reg_dt_after5,
    reg_dt - 5 as reg_dt_before5
FROM users;

-- 1�� prod���̺��� prod_id, prod_name �� �÷� ��ȸ prod_id -> id, prod_name -> name ���� �÷��� ����
SELECT prod_id as id, prod_name as name FROM prod;

-- 2�� lprod���̺��� lprod_gu, lprod_nm �� �÷��� ��ȸ lprod_gu -> gu, lprod_nm -> nm ���� �÷��� ����
SELECT lprod_gu as gu, lprod_nm as nm FROM lprod;

-- 3�� buyer ���̺��� buyer_id, buyer_name �� �÷��� ��ȸ buyer_id -> ���̾���̵�, buyer_name -> �̸� ���� �÷��� ����
SELECT buyer_id as "���̾���̵�", buyer_name as "�̸�" FROM buyer;


-- ���ڿ� ����
-- java + --> sql ||
-- CONCAT(str, str) �Լ�
-- users ���̺��� userid, usernm
SELECT userid, usernm, userid || usernm as id, CONCAT(userid, usernm) as id FROM users;

-- ���ڿ� ��� (�÷��� ��� �����Ͱ� �ƴ϶� �����ڰ� ���� �Է��� ���ڿ�)
SELECT '����� ���̵� : ' ||  userid as "����� ���̵�", CONCAT('����� ���̵� : ', userid) as "����� ���̵�" FROM users;

--�ǽ� sel_con1
SELECT * FROM user_tables;

SELECT table_name, 'SELECT * FROM ' || table_name || ';' as "QUERY" FROM user_tables;

--desc table
-- ���̺� ���ǵ� �÷��� �˰� ���� ��
-- 1. desc
-- 2. select * ....

desc emp;

SELECT * FROM emp;

-- WHERE��, ���� ������
SELECT * FROM users
WHERE userid = 'brown';

--usernm�� ������ �����͸� ��ȸ�ϴ� ������ �ۼ�
SELECT * FROM users
WHERE usernm = '����';