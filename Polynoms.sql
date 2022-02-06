USE Polynom
GO

/*1) ������������ ���������, ��� �� ������ �����, ������� ���� ������. ��������� ������ ����������� ��������. ������ ����������� �������� ����������� ���� � ������ 2*/
/*2)������, ������� ���������� �������, ���������� � ���� ������ � ���������� ������ �������������� �������� (� ����� ������ 2)*/
DECLARE @param int
SET @param = 3

SELECT CAST(Coeff as nvarchar(10)) + '*x^' + CAST(Pow as nvarchar(10)) AS Polynom
FROM Polynom
WHERE Coeff != 0 AND P_id = @param
ORDER BY Pow desc


/*3)����� ����������� ���������� ���������*/
SELECT DISTINCT P_id AS Incorrect_polynom
FROM Polynom
WHERE Coeff = 0

/*4)������ � �����������, ������� ���������� �������, ���������� �� �������������� �����*/
DECLARE @id int, @num int
SET @id = 2
SET @num = 5

SELECT CAST(Coeff * @num as nvarchar(10)) + '*x^' + CAST(Pow as nvarchar(10)) AS Polynom
FROM Polynom
WHERE Coeff != 0 AND P_id = @id
ORDER BY Pow desc

/*5)������ � �����������, ������� ��������� � �������� ��������� ������������� �������� � ���� ������ � ����������� ����� n, �������� �� ��������� ������� ��������� ������� n*/
DECLARE @P_id int, @n int
SET @P_id = 2
SET @n = 3

SELECT '��' as Result 
WHERE (SELECT MAX(Pow) FROM Polynom WHERE P_id = @P_id AND Coeff != 0) = @n 
UNION
SELECT '���' as Result 
WHERE (SELECT MAX(Pow) FROM Polynom WHERE P_id = @P_id AND Coeff != 0) != @n

/*��� �� � ��� ��� ������� � ������������� IF:
IF (SELECT MAX(Pow) FROM Polynom WHERE P_id = @P_id AND Coeff != 0) = @n
SELECT 'Yes' AS Result
ELSE
SELECT 'No' AS Result*/

/*6)����� ���� �������, �������� �����������*/
DECLARE @P_id1 int, @P_id2 int
SET @P_id1 = 2
SET @P_id2 = 4

SELECT CAST(SUM(Coeff) as nvarchar(5)) + '*x^' + CAST(Pow as nvarchar(10)) as 'SUM of polynoms' 
FROM Polynom
WHERE (P_id = @P_id1 OR P_id = @P_id2)
GROUP BY Pow
HAVING SUM(Coeff) != 0
ORDER BY Pow desc

/*7)��������� ���� �������, �������� ����������*/
DECLARE @P_id3 int, @P_id4 int
SET @P_id3 = 6
SET @P_id4 = 7

SELECT CAST(SUM(P1.Coeff*P2.Coeff) as nvarchar(10)) + '*x^' + CAST((P1.Pow + P2.Pow) as nvarchar(10)) as 'Product of polynoms'
FROM Polynom AS P1, Polynom AS P2
WHERE P1.P_id = @P_id3 AND P2.P_id = @P_id4
GROUP BY P1.Pow + P2.Pow 
HAVING SUM(P1.Coeff*P2.Coeff) != 0
ORDER BY (P1.Pow + P2.Pow) desc

/*8)�������� �������� ��� �������� �*/
DECLARE @P_id5 int, @x float
SET @P_id5 = 3
SET @x = 3.14

SELECT SUM(Coeff*POWER(@x, Pow)) AS 'f(x) = '
FROM Polynom
WHERE P_id = @P_id5

/*9)�������� �� ������� ������ ���������*/
DECLARE @P_id6 int, @a float, @b float, @c float
SET @P_id6 = 7

SELECT @a = Coeff
FROM Polynom
WHERE P_id = @P_id6 AND Pow = 2

SELECT @b = Coeff
FROM Polynom
WHERE P_id = @P_id6 AND Pow = 1

SELECT @c = Coeff
FROM Polynom
WHERE P_id = @P_id6 AND Pow = 0

SELECT '��' AS Result
FROM Polynom
WHERE ((ABS(@b) = 2 * SQRT(ABS(@a)) * SQRT(ABS(@c)) AND @a > 0 AND @c > 0) OR
(ABS(@b) = 2 * SQRT(ABS(@a)) * SQRT(ABS(@c)) AND @a < 0 AND @c < 0)) AND P_id = @P_id6 AND Coeff != 0
HAVING MAX(Pow) = 2
UNION
SELECT '���' AS Result
WHERE (ABS(@b) != 2 * SQRT(ABS(@a)) * SQRT(ABS(@c))) 
OR (@a > 0 AND @c < 0) OR (@a < 0 AND @c > 0)
UNION
SELECT '���' AS Result
FROM Polynom
WHERE P_id = @P_id6 AND Coeff != 0
HAVING MAX(Pow) != 2

/*10) ���������� �������������, ������������� � ������� �������������*/
DECLARE @P_id7 int, @negative int, @positive int, @all int
SET @P_id7 = 4


SELECT @negative = COUNT(Coeff)
FROM Polynom
WHERE P_id = @P_id7 and Coeff < 0

SELECT @positive = COUNT(Coeff)
FROM Polynom
WHERE P_id = @P_id7 and Coeff > 0

SELECT @all = MAX(Pow) + 1
FROM Polynom
WHERE P_id = @P_id7 AND Coeff != 0

SELECT @positive as '>0', @negative as '<0', @all - @positive - @negative as '=0'

/*11) ������� � ������ �������������� ��� ���*/
DECLARE @P_id8 int, @count int
SET @P_id8 = 4

SELECT @count = COUNT(Pow)
FROM Polynom
WHERE P_id = @P_id8 AND Coeff = ROUND(Coeff, 0)

SELECT '��' AS Result
FROM Polynom
WHERE P_id = @P_id8
HAVING COUNT(Pow) = @count
UNION
SELECT '���' AS Result
FROM Polynom
WHERE P_id = @P_id8
HAVING COUNT(Pow) != @count

/*12)���� ������� ������ �������, ������� �������� �*/
DECLARE @P_id9 int
SET @P_id9 = 7

IF (SELECT MAX(Pow) FROM Polynom
	WHERE P_id = @P_id9 AND Coeff != 0) = 1
	IF (SELECT MIN(Pow) FROM Polynom
		WHERE P_id = @P_id9) = 1
		SELECT 0 as Result;
	ELSE
		SELECT -P1.Coeff/P2.Coeff as Result FROM Polynom as P1, Polynom as P2
		WHERE P1.P_id = @P_id9 AND P2.P_id = @P_id9 AND P1.Pow = 0 AND P2.Pow = 1;
ELSE
	SELECT '�� �������� ��������� 1-�� �������' as Result;
	
/*13)���� ������� ������ �������, ������� ��� �����*/
DECLARE @P_id10 int, @Coeff2 float, @Coeff1 float, @Coeff0 float 
SET @P_id10 = 6


IF (SELECT Coeff FROM Polynom WHERE P_id = @P_id10 AND Pow = 2) != 0	
	SET @Coeff2 = (SELECT Coeff FROM Polynom WHERE P_id = @P_id10 AND Pow = 2);
ELSE 
	SET @Coeff2 = 0;

IF (SELECT Coeff FROM Polynom WHERE P_id = @P_id10 AND Pow = 1) != 0	
	SET @Coeff1 = (SELECT Coeff FROM Polynom WHERE P_id = @P_id10 AND Pow = 1);
ELSE 
	SET @Coeff1 = 0;
	
IF (SELECT Coeff FROM Polynom WHERE P_id = @P_id10 AND Pow = 0) != 0	
	SET @Coeff0 = (SELECT Coeff FROM Polynom WHERE P_id = @P_id10 AND Pow = 0);
ELSE 
	SET @Coeff0 = 0;

IF (SELECT MAX(Pow) FROM Polynom
	WHERE P_id = @P_id10 AND Coeff != 0) = 2 
	IF @Coeff1*@Coeff1 - 4*@Coeff2*@Coeff0 >= 0
		SELECT (-@Coeff1-SQRT(@Coeff1*@Coeff1 - 4*@Coeff2*@Coeff0))/(2*@Coeff2) as Root1, 
		(-@Coeff1+SQRT(@Coeff1*@Coeff1 - 4*@Coeff2*@Coeff0))/(2*@Coeff2) as Root2;
	ELSE
		SELECT '������� �� ����� �������������� ������' as Result;
ELSE
	SELECT '�� �������� ��������� 2-�� �������' as Result;
	
/*14)������� 1, � ������ ���� ������ ������� �������� ����������� ��������� ���� ������, ���� �� ���, ������ ������� 0*/
DECLARE @P_id11 int, @P_id12 int, @P_id13 int
SET @P_id11 = 6 
SET @P_id12 = 7 
SET @P_id13 = 8 

SELECT 1 as Result
FROM
(
	SELECT CAST(Coeff as nvarchar(10)) + '*x^' + CAST(Pow as nvarchar(10)) as Polyn
	FROM Polynom
	WHERE P_id = @P_id13   
	EXCEPT
	SELECT CAST(SUM(P1.Coeff*P2.Coeff) as nvarchar(10)) + '*x^' + CAST((P1.Pow + P2.Pow) as nvarchar(10)) as Polyn
	FROM Polynom AS P1, Polynom AS P2
	WHERE P1.P_id = @P_id11 AND P2.P_id = @P_id12
	GROUP BY P1.Pow + P2.Pow 
	HAVING SUM(P1.Coeff*P2.Coeff) != 0
) Difference
HAVING COUNT(Difference.Polyn) = 0

UNION

SELECT 0 as Result
FROM
(
	SELECT CAST(Coeff as nvarchar(10)) + '*x^' + CAST(Pow as nvarchar(10)) as Polyn
	FROM Polynom
	WHERE P_id = @P_id13   
	EXCEPT
	SELECT CAST(SUM(P1.Coeff*P2.Coeff) as nvarchar(10)) + '*x^' + CAST((P1.Pow + P2.Pow) as nvarchar(10)) as Polyn
	FROM Polynom AS P1, Polynom AS P2
	WHERE P1.P_id = @P_id11 AND P2.P_id = @P_id12
	GROUP BY P1.Pow + P2.Pow 
	HAVING SUM(P1.Coeff*P2.Coeff) != 0
) Difference
HAVING COUNT(Difference.Polyn) != 0

/*15)������� 1, � ������ ���� ������ ������� �������� ����������� ������� ������� �� ������*/	
/*�� ��������� ���� ���������� � �����, ��� ���� �����, ��� � ������ ���� (�����)*/
/*���� ���� ���������, �������� �� �3 ����������� ������� �1/�2, �� ������ ����� ����� ���������, �������� �� �2 ����������� ������������ �3*�1*/
SET @P_id11 = 8
SET @P_id12 = 6
SET @P_id13 = 7

SELECT 1 as Result
FROM
(
	SELECT CAST(Coeff as nvarchar(10)) + '*x^' + CAST(Pow as nvarchar(10)) as Polyn
	FROM Polynom
	WHERE P_id = @P_id11   
	EXCEPT
	SELECT CAST(SUM(P1.Coeff*P2.Coeff) as nvarchar(10)) + '*x^' + CAST((P1.Pow + P2.Pow) as nvarchar(10)) as Polyn
	FROM Polynom AS P1, Polynom AS P2
	WHERE P1.P_id = @P_id12 AND P2.P_id = @P_id13
	GROUP BY P1.Pow + P2.Pow 
	HAVING SUM(P1.Coeff*P2.Coeff) != 0
) Difference
HAVING COUNT(Difference.Polyn) = 0

UNION

SELECT 0 as Result
FROM
(
	SELECT CAST(Coeff as nvarchar(10)) + '*x^' + CAST(Pow as nvarchar(10)) as Polyn
	FROM Polynom
	WHERE P_id = @P_id11   
	EXCEPT
	SELECT CAST(SUM(P1.Coeff*P2.Coeff) as nvarchar(10)) + '*x^' + CAST((P1.Pow + P2.Pow) as nvarchar(10)) as Polyn
	FROM Polynom AS P1, Polynom AS P2
	WHERE P1.P_id = @P_id12 AND P2.P_id = @P_id13
	GROUP BY P1.Pow + P2.Pow 
	HAVING SUM(P1.Coeff*P2.Coeff) != 0
) Difference
HAVING COUNT(Difference.Polyn) != 0
