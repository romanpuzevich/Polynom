USE Polynom
GO

/*1) Использовали структуру, как во втором файле, создали базу данных. Придумали способ отображения полинома. Пример отображения полинома представлен ниже в пункте 2*/
/*2)Запрос, который показывает полином, хранящийся в базе данных с параметром равным идендификатору полинома (в нашем случае 2)*/
DECLARE @param int
SET @param = 3

SELECT CAST(Coeff as nvarchar(10)) + '*x^' + CAST(Pow as nvarchar(10)) AS Polynom
FROM Polynom
WHERE Coeff != 0 AND P_id = @param
ORDER BY Pow desc


/*3)Вывод некорректно хранящихся полиномов*/
SELECT DISTINCT P_id AS Incorrect_polynom
FROM Polynom
WHERE Coeff = 0

/*4)Запрос с параметрами, который возвращает полином, умноженный на действительное число*/
DECLARE @id int, @num int
SET @id = 2
SET @num = 5

SELECT CAST(Coeff * @num as nvarchar(10)) + '*x^' + CAST(Pow as nvarchar(10)) AS Polynom
FROM Polynom
WHERE Coeff != 0 AND P_id = @id
ORDER BY Pow desc

/*5)Запрос с параметрами, который принимает в качестве параметра идентификатор полинома в базе данных и натуральное число n, является ли указанный полином полиномом степени n*/
DECLARE @P_id int, @n int
SET @P_id = 2
SET @n = 3

SELECT 'Да' as Result 
WHERE (SELECT MAX(Pow) FROM Polynom WHERE P_id = @P_id AND Coeff != 0) = @n 
UNION
SELECT 'Нет' as Result 
WHERE (SELECT MAX(Pow) FROM Polynom WHERE P_id = @P_id AND Coeff != 0) != @n

/*Так же у нас был варинат с ипользованием IF:
IF (SELECT MAX(Pow) FROM Polynom WHERE P_id = @P_id AND Coeff != 0) = @n
SELECT 'Yes' AS Result
ELSE
SELECT 'No' AS Result*/

/*6)Сумма двух полинов, заданных параметрами*/
DECLARE @P_id1 int, @P_id2 int
SET @P_id1 = 2
SET @P_id2 = 4

SELECT CAST(SUM(Coeff) as nvarchar(5)) + '*x^' + CAST(Pow as nvarchar(10)) as 'SUM of polynoms' 
FROM Polynom
WHERE (P_id = @P_id1 OR P_id = @P_id2)
GROUP BY Pow
HAVING SUM(Coeff) != 0
ORDER BY Pow desc

/*7)Умножение двух полинов, заданных параметром*/
DECLARE @P_id3 int, @P_id4 int
SET @P_id3 = 6
SET @P_id4 = 7

SELECT CAST(SUM(P1.Coeff*P2.Coeff) as nvarchar(10)) + '*x^' + CAST((P1.Pow + P2.Pow) as nvarchar(10)) as 'Product of polynoms'
FROM Polynom AS P1, Polynom AS P2
WHERE P1.P_id = @P_id3 AND P2.P_id = @P_id4
GROUP BY P1.Pow + P2.Pow 
HAVING SUM(P1.Coeff*P2.Coeff) != 0
ORDER BY (P1.Pow + P2.Pow) desc

/*8)Значение полинома при заданном х*/
DECLARE @P_id5 int, @x float
SET @P_id5 = 3
SET @x = 3.14

SELECT SUM(Coeff*POWER(@x, Pow)) AS 'f(x) = '
FROM Polynom
WHERE P_id = @P_id5

/*9)Является ли полином полным квадратом*/
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

SELECT 'Да' AS Result
FROM Polynom
WHERE ((ABS(@b) = 2 * SQRT(ABS(@a)) * SQRT(ABS(@c)) AND @a > 0 AND @c > 0) OR
(ABS(@b) = 2 * SQRT(ABS(@a)) * SQRT(ABS(@c)) AND @a < 0 AND @c < 0)) AND P_id = @P_id6 AND Coeff != 0
HAVING MAX(Pow) = 2
UNION
SELECT 'Нет' AS Result
WHERE (ABS(@b) != 2 * SQRT(ABS(@a)) * SQRT(ABS(@c))) 
OR (@a > 0 AND @c < 0) OR (@a < 0 AND @c > 0)
UNION
SELECT 'Нет' AS Result
FROM Polynom
WHERE P_id = @P_id6 AND Coeff != 0
HAVING MAX(Pow) != 2

/*10) Количество положительных, отрицательных и нулевых коэффициентов*/
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

/*11) Полином с целыми коэффициентами или нет*/
DECLARE @P_id8 int, @count int
SET @P_id8 = 4

SELECT @count = COUNT(Pow)
FROM Polynom
WHERE P_id = @P_id8 AND Coeff = ROUND(Coeff, 0)

SELECT 'Да' AS Result
FROM Polynom
WHERE P_id = @P_id8
HAVING COUNT(Pow) = @count
UNION
SELECT 'Нет' AS Result
FROM Polynom
WHERE P_id = @P_id8
HAVING COUNT(Pow) != @count

/*12)Если полином первой степени, вывести значение х*/
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
	SELECT 'Не является полиномом 1-ой степени' as Result;
	
/*13)Если полином второй степени, вывести два корня*/
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
		SELECT 'Полином не имеет действительных корней' as Result;
ELSE
	SELECT 'Не является полиномом 2-ой степени' as Result;
	
/*14)Вывести 1, в случае если третий полином является результатом умножения двух других, если же нет, решили вывести 0*/
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

/*15)Выводит 1, в случае если третий полином является результатом деления первого на второй*/	
/*Не придумали идеи гениальнее и проще, чем тоже самое, что в пункте выше (почти)*/
/*Если надо проверить, евляется ли п3 результатом деления п1/п2, то вместо этого можем проверить, евляется ли п2 результатом произведения п3*п1*/
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
