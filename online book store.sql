--Создание таблиц базы данных "Интернет магазин книг"
CREATE TABLE author (
    author_id SERIAL PRIMARY KEY,
    name_author VARCHAR(50)
);

INSERT INTO author (author_id, name_author)
VALUES 
(1, 'Булгаков М.А.'),
(2, 'Достоевский Ф.М.'),
(3, 'Есенин С.А.'),
(4, 'Пастернак Б.Л.');

CREATE TABLE genre(
    genre_id SERIAL PRIMARY KEY, 
    name_genre VARCHAR(30)
);

INSERT INTO genre (name_genre)
VALUES 
('Роман'),
('Поэзия'),
('Драма'),
('Фантастика'),
('Детектив'),
('Исторический'),
('Приключения');

CREATE TABLE book (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(50),
    author_id INT NOT NULL,
    genre_id INT,
    price DECIMAL(8,2),
    amount INT,
    FOREIGN KEY (genre_id) REFERENCES genre(genre_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);
INSERT INTO book (book_id, title, author_id, genre_id, price, amount)
VALUES
(1, 'Мастер и Маргарита', 1, 1, 670.99, 3),
(2, 'Белая гвардия', 1, 1, 540.50, 5),
(3, 'Идиот', 2, 1, 460.00, 10),
(4, 'Братья Карамазовы', 2, 1, 799.01, 3),
(5, 'Игрок', 2, 1, 480.50, 10),
(6, 'Стихотворения и поэмы', 3, 2, 650.00, 15),
(7, 'Черный человек', 3, 2, 570.20, 6),
(8, 'Лирика', 4, 2, 518.99, 2);

CREATE TABLE city (
    city_id SERIAL PRIMARY KEY,
    name_city VARCHAR(30),
    days_delivery INT
);

INSERT INTO city (name_city, days_delivery)
VALUES
('Москва', 5),
('Санкт-Петербург', 3),
('Владивосток', 12);


CREATE TABLE client (
    client_id SERIAL PRIMARY KEY,
    name_client VARCHAR(50),
    city_id INT,
    email VARCHAR(30)
);

INSERT INTO client (name_client, city_id, email) VALUES
('Баранов Павел', 3, 'baranov@test'),
('Абрамова Катя', 1, 'abramova@test'),
('Семенонов Иван', 2, 'semenov@test'),
('Яковлева Галина', 1, 'yakovleva@test');


CREATE TABLE buy (
    buy_id SERIAL PRIMARY KEY,
    buy_description VARCHAR(100),
    client_id INT
);

INSERT INTO buy (buy_description, client_id) VALUES
('Доставка только вечером', 1),
('', 3),
('Упаковать каждую книгу по отдельности', 2),
('', 1);


CREATE TABLE buy_book (
    buy_book_id SERIAL PRIMARY KEY,
    buy_id INT,
    book_id INT,
    amount INT
);

INSERT INTO buy_book (buy_id, book_id, amount) VALUES
(1, 1, 1),
(1, 7, 2),
(1, 3, 1),
(2, 8, 2),
(3, 3, 2),
(3, 2, 1),
(3, 1, 1),
(4, 5, 1);


CREATE TABLE step (
    step_id SERIAL PRIMARY KEY,
    name_step VARCHAR(30)
);

INSERT INTO step (name_step) VALUES
('Оплата'),
('Упаковка'),
('Транспортировка'),
('Доставка');


CREATE TABLE buy_step (
    buy_step_id SERIAL PRIMARY KEY,
    buy_id INT,
    step_id INT,
    date_step_beg DATE,
    date_step_end DATE
);

INSERT INTO buy_step (buy_id, step_id, date_step_beg, date_step_end) VALUES
(1, 1, '2020-02-20', '2020-02-20'),
(1, 2, '2020-02-20', '2020-02-21'),
(1, 3, '2020-02-22', '2020-03-07'),
(1, 4, '2020-03-08', '2020-03-08'),
(2, 1, '2020-02-28', '2020-02-28'),
(2, 2, '2020-02-29', '2020-03-01'),
(2, 3, '2020-03-02', NULL),
(2, 4, NULL, NULL),
(3, 1, '2020-03-05', '2020-03-05'),
(3, 2, '2020-03-05', '2020-03-06'),
(3, 3, '2020-03-06', '2020-03-10'),
(3, 4, '2020-03-11', NULL),
(4, 1, '2020-03-20', NULL),
(4, 2, NULL, NULL),
(4, 3, NULL, NULL),
(4, 4, NULL, NULL);

--Задание 1. Вывести все заказы Баранова Павла (id заказа, какие книги, по какой цене и в
SELECT buy.buy_id, book.title, book.price, buy_book.amount
FROM client 
JOIN buy ON client.client_id = buy.client_id
JOIN buy_book ON buy_book.buy_id = buy.buy_id
JOIN book ON buy_book.book_id = book.book_id
WHERE client.name_client = 'Баранов Павел' 
ORDER BY buy.buy_id, book.title;  

--Задание 2. Посчитать, сколько раз была заказана каждая книга, для книги вывести ее автора (нужно посчитать, в каком количестве заказов фигурирует каждая книга).  Вывести фамилию и инициалы автора, название книги, последний столбец назвать Количество. Результат отсортировать сначала  по фамилиям авторов, а потом по названиям книг.
select author.name_author, book.title,count(buy_book.book_id) as Количество
from book
left join buy_book on book.book_id = buy_book.book_id
LEFT JOIN 
    buy ON buy_book.buy_id = buy.buy_id
join author on book.author_id = author.author_id
group by author.name_author, book.title
order by author.name_author, book.title;

--Задание 3.Вывести города, в которых живут клиенты, оформлявшие заказы в интернет-магазине. Указать количество заказов в каждый город, этот столбец назвать Количество. Информацию вывести по убыванию количества заказов, а затем в алфавитном порядке по названию городов.
SELECT 
    name_city, 
    COUNT(buy.buy_id) AS "Количество"
FROM 
    city 
JOIN 
    client ON city.city_id = client.city_id
JOIN 
    buy ON client.client_id = buy.client_id
GROUP BY 
    city.city_id, city.name_city
ORDER BY 
    COUNT(buy.buy_id) DESC,
    city.name_city ASC;

--Задание 4. Вывести номера всех оплаченных заказов и даты, когда они были оплачены.
SELECT 
    bs.buy_id,
    bs.date_step_end
FROM 
    buy_step bs
JOIN 
    step s ON bs.step_id = s.step_id
WHERE 
    s.name_step = 'Оплата'
    AND bs.date_step_end IS NOT NULL
ORDER BY 
    bs.buy_id;

--Задание 5.Вывести информацию о каждом заказе: его номер, кто его сформировал (фамилия пользователя) и его стоимость (сумма произведений количества заказанных книг и их цены), в отсортированном по номеру заказа виде. Последний столбец назвать Стоимость.
select buy.buy_id, client.name_client, sum(buy_book.amount*book.price) as Стоимость
from buy
    JOIN client ON buy.client_id = client.client_id
    JOIN buy_book ON buy.buy_id = buy_book.buy_id
    JOIN book ON buy_book.book_id = book.book_id
group by buy.buy_id, client.name_client
order by buy.buy_id;

--Задание 6.Вывести номера заказов (buy_id) и названия этапов, на которых они в данный момент находятся. Если заказ доставлен –  информацию о нем не выводить. Информацию отсортировать по возрастанию buy_id.
SELECT 
    buy.buy_id,
    step.name_step
FROM 
    buy
    JOIN buy_step ON buy.buy_id = buy_step.buy_id
    JOIN step ON buy_step.step_id = step.step_id
WHERE 
    buy_step.date_step_beg IS NOT NULL 
    AND buy_step.date_step_end IS NULL
ORDER BY 
    buy.buy_id;

--Задание 7.В таблице city для каждого города указано количество дней, за которые заказ может быть доставлен в этот город (рассматривается только этап "Транспортировка"). Для тех заказов, которые прошли этап транспортировки, вывести количество дней за которое заказ реально доставлен в город. А также, если заказ доставлен с опозданием, указать количество дней задержки, в противном случае вывести 0. В результат включить номер заказа (buy_id), а также вычисляемые столбцы Количество_дней и Опоздание. Информацию вывести в отсортированном по номеру заказа виде.
SELECT 
    buy.buy_id,
    (buy_step.date_step_end - buy_step.date_step_beg) AS Количество_дней,
    GREATEST((buy_step.date_step_end - buy_step.date_step_beg) - city.days_delivery, 0) AS Опоздание
FROM 
    buy
JOIN 
    client ON buy.client_id = client.client_id
JOIN 
    city ON client.city_id = city.city_id
JOIN 
    buy_step ON buy.buy_id = buy_step.buy_id
JOIN 
    step ON buy_step.step_id = step.step_id
WHERE 
    step.name_step = 'Транспортировка'
    AND buy_step.date_step_end IS NOT NULL
ORDER BY 
    buy.buy_id;

--Задание 8.Выбрать всех клиентов, которые заказывали книги Достоевского, информацию вывести в отсортированном по алфавиту виде. В решении используйте фамилию автора, а не его id.
select distinct name_client 
from client 
join buy on client.client_id = buy.client_id
join buy_book on buy.buy_id = buy_book.buy_id
join book on book.book_id = buy_book.book_id
join author on book.author_id = author.author_id 
where name_author = 'Достоевский Ф.М.'
order by client.name_client

--Задание 9.Вывести жанр (или жанры), в котором было заказано больше всего экземпляров книг, указать это количество . Последний столбец назвать Количество.
SELECT 
    genre.name_genre,
    SUM(buy_book.amount) AS Количество
FROM 
    genre
JOIN 
    book ON genre.genre_id = book.genre_id
JOIN 
    buy_book ON book.book_id = buy_book.book_id
GROUP BY 
    genre.name_genre
HAVING 
    SUM(buy_book.amount) = (
        SELECT MAX(total_amount)
        FROM (
            SELECT SUM(buy_book.amount) AS total_amount
            FROM buy_book
            JOIN book ON buy_book.book_id = book.book_id
            GROUP BY book.genre_id
        ) AS genre_totals
    );

--Задание 10.  Включить нового человека в таблицу с клиентами. Его имя Попов Илья, его email popov@test, проживает он в Москве.
insert into client (client_id, name_client, city_id, email)
values
(5, 'Попов Илья', 1, 'popov@test');

--Задание 11. Создать новый заказ для Попова Ильи. Его комментарий для заказа: «Связаться со мной по вопросу доставки».
insert into buy (buy_description, client_id )
select  'Связаться со мной по вопросу доставки', client_id
from client
where name_client = 'Попов Илья';

--Задание 12.В таблицу buy_book добавить заказ с номером 5. Этот заказ должен содержать книгу Пастернака «Лирика» в количестве двух экземпляров и книгу Булгакова «Белая гвардия» в одном экземпляре.
INSERT INTO buy_book (buy_id, book_id, amount)
SELECT 5, book_id, 2 
FROM book 
WHERE title = 'Лирика' AND author_id = (SELECT author_id FROM author WHERE name_author = 'Пастернак Б.Л.');

INSERT INTO buy_book (buy_id, book_id, amount)
SELECT 5, book_id, 1 
FROM book 
WHERE title = 'Белая гвардия' AND author_id = (SELECT author_id FROM author WHERE name_author = 'Булгаков М.А.');

--Задание 13.Уменьшить количество тех книг на складе, которые были включены в заказ с номером 5.
UPDATE book
SET amount = amount - (
    SELECT bb.amount 
    FROM buy_book bb 
    WHERE bb.book_id = book.book_id AND bb.buy_id = 5
)
WHERE book_id IN (
    SELECT book_id 
    FROM buy_book 
    WHERE buy_id = 5
);

--Задание 14.Создать счет (таблицу buy_pay) на оплату заказа с номером 5, в который включить название книг, их автора, цену, количество заказанных книг и  стоимость. Последний столбец назвать Стоимость. Информацию в таблицу занести в отсортированном по названиям книг виде.
CREATE TABLE buy_pay AS
SELECT 
    b.title,
    a.name_author,
    b.price ,
    bb.amount,
    (b.price * bb.amount) AS Стоимость
FROM 
    buy_book bb
    JOIN book b ON bb.book_id = b.book_id
    JOIN author a ON b.author_id = a.author_id
WHERE 
    bb.buy_id = 5
ORDER BY 
    b.title;


--Задание 15.Создать общий счет (таблицу buy_pay) на оплату заказа с номером 5. Куда включить номер заказа, количество книг в заказе (название столбца Количество) и его общую стоимость (название столбца Итого).  Для решения используйте ОДИН запрос.
CREATE TABLE buy_pay AS
SELECT 
    5 AS buy_id,
    SUM(buy_book.amount) AS "Количество",
    ROUND(SUM(buy_book.amount * book.price), 2) AS "Итого"
FROM 
    buy_book
    JOIN book ON buy_book.book_id = book.book_id
WHERE 
    buy_book.buy_id = 5;

--Задание 16.В таблицу buy_step для заказа с номером 5 включить все этапы из таблицы step, которые должен пройти этот заказ. В столбцы date_step_beg и date_step_end всех записей занести Null.
INSERT INTO buy_step (buy_id, step_id, date_step_beg, date_step_end)
SELECT 
    5, 
    step.step_id, 
    NULL, 
    NULL
FROM 
    step;

--Задание 17. В таблицу buy_step занести дату 12.04.2020 выставления счета на оплату заказа с номером 5.
update buy_step
set date_step_beg = '2020-04-12'
where buy_id = 5 and step_id = 1;

--Задание 18.Завершить этап «Оплата» для заказа с номером 5, вставив в столбец date_step_end дату 13.04.2020, и начать следующий этап («Упаковка»), задав в столбце date_step_beg для этого этапа ту же дату.

UPDATE buy_step
SET date_step_end = '2020-04-13'
WHERE buy_id = 5
  AND step_id = (
      SELECT step_id
      FROM step
      WHERE name_step = 'Оплата'
      LIMIT 1
  )
  AND date_step_end IS NULL;

UPDATE buy_step
SET date_step_beg = '2020-04-13'
WHERE buy_id = 5
  AND step_id = (
      SELECT step_id
      FROM step
      WHERE name_step = 'Упаковка'
      LIMIT 1
  )
  AND date_step_beg IS NULL;


