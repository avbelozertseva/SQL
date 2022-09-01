/*
 * база данных ассортимента магазина строительных и отделочных материалов.
 */

DROP DATABASE IF EXISTS stroysam;
CREATE DATABASE stroysam;
USE stroysam;

DROP TABLE IF EXISTS store; 
CREATE TABLE store (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(50),
    adress VARCHAR (100),
    date_open DATETIME)
   	COMMENT 'Таблица с информацией о  магазинах';  

DROP TABLE IF EXISTS department; 
CREATE TABLE department (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(50))
   	COMMENT 'Таблица с отделами в магазинах';
	
   
DROP TABLE IF EXISTS sub_department; 
CREATE TABLE sub_department (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(50),
    id_department BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_department) REFERENCES department(id))
   	COMMENT 'Таблица с подотделами в отделе';
   
   
DROP TABLE IF EXISTS products_type; 
CREATE TABLE products_type (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(50),
    id_sub_department BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_sub_department) REFERENCES sub_department(id))
    COMMENT 'Таблица с типами товара внутри подотдела';  


DROP TABLE IF EXISTS providers; 
CREATE TABLE providers (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(50),
    provider_number BIGINT UNSIGNED NOT NULL,
	id_department BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_department) REFERENCES department(id))
   	COMMENT 'Таблица с данными о поставщике';   
   

DROP TABLE IF EXISTS contract_info; 
CREATE TABLE contract_info (
	providers_id BIGINT UNSIGNED NOT NULL UNIQUE, 
	phone BIGINT UNSIGNED UNIQUE	COMMENT 'контактный телефон',
	email VARCHAR(120) UNIQUE		COMMENT 'электронная почта',			
	adress VARCHAR(120)				COMMENT	'адрес',
	INN INT UNIQUE					COMMENT	'ИНН',
	contact_name VARCHAR(120)		COMMENT	'контактное лицо',
	franko BIGINT					COMMENT	'минимальная сумма заказа',
	dayofdel INT					COMMENT	'срок поставки',
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
			
	FOREIGN KEY (providers_id) REFERENCES providers(id))
	
	COMMENT 'условия договора';

   
DROP TABLE IF EXISTS products; 
CREATE TABLE products (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	name CHAR(50),
	is_active BIT DEFAULT 1,
	id_products_type BIGINT UNSIGNED NOT NULL,
	id_provider BIGINT UNSIGNED NOT NULL,
	
	FOREIGN KEY (id_provider) REFERENCES providers(id),
    FOREIGN KEY (id_products_type) REFERENCES products_type(id))
   
    COMMENT 'информация о принадлежности и активности к заказу товара';
   
   
DROP TABLE IF EXISTS store_product; 
CREATE TABLE store_product (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    products_id BIGINT UNSIGNED NOT NULL,
    store_id BIGINT UNSIGNED NOT NULL,
    
    FOREIGN KEY (products_id) REFERENCES products(id),
    FOREIGN KEY (store_id) REFERENCES store(id))
    
   	COMMENT 'Таблица с привязкой товар/магазин для хранения информации о товарах(поступления, продажи, цены) индивидуально в каждом магазине магазине'; 
   
DROP TABLE IF EXISTS price; 
CREATE TABLE price (
	store_product_id BIGINT UNSIGNED NOT NULL UNIQUE, 
	priceDPAC FLOAT UNSIGNED NULL					COMMENT 'закупочная цена', 							
	price_from_CO FLOAT UNSIGNED NOT NULL			COMMENT 'цена, рекомендованная отделом закупок',				
	price_from_MAG FLOAT UNSIGNED NOT NULL			COMMENT 'цена по результатам мониторинга конкурентов',				
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP	COMMENT 'дата последнего изменения цены',	
		
	FOREIGN KEY (store_product_id) REFERENCES store_product(id))

	COMMENT 'информация о цене товара';
	
	
DROP TABLE IF EXISTS sold_products; 
CREATE TABLE sold_products (
	store_product_id BIGINT UNSIGNED NOT NULL UNIQUE, 
	balance BIGINT					COMMENT 'остаток на текущий момент, может быть пустым',									
	date_first_delivery DATETIME	COMMENT 'дата первой поставки',						
	date_last_delivery DATETIME		COMMENT 'дата последней поставки',						
	date_last_sale DATETIME			COMMENT 'дата последней продажи',							
	sold BIGINT						COMMENT 'продано за месяц',										
	ordered BIGINT					COMMENT 'заказано поставщику',										
	
	FOREIGN KEY (store_product_id) REFERENCES store_product(id))

	COMMENT 'информация о наличии и продажах товара';

DROP TABLE IF EXISTS edizm; 
CREATE TABLE edizm (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	name CHAR(50))
	
	COMMENT 'единицы измерения товара';
	

DROP TABLE IF EXISTS about_products; 
CREATE TABLE about_products (
	products_id BIGINT UNSIGNED NOT NULL UNIQUE, 
	about TEXT,
	weight FLOAT	COMMENT 'вес',							
	height FLOAT	COMMENT 'высота',							
	width FLOAT		COMMENT 'ширина',							
	dep FLOAT		COMMENT 'глубина',	
	edizm_id BIGINT UNSIGNED NOT NULL	COMMENT 'единица измерения',
	sale_from INT	COMMENT 'кратность продажи',							
	order_from INT	COMMENT 'кратность заказа поставщику',							 
	 	
	FOREIGN KEY (products_id) REFERENCES products(id),
	FOREIGN KEY (edizm_id) REFERENCES edizm(id))

	COMMENT 'информация о товаре (карточка товара)';


DROP TABLE IF EXISTS media;  
CREATE TABLE media (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,  
	file BLOB,
	products_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (products_id) REFERENCES products(id))
	COMMENT 'фото/видео товара';

INSERT INTO store (name, adress, date_open)
VALUES
	('Магазин 1', 'Адрес 1', '2010-06-01'),
	('Магазин 2', 'Адрес 2', '2011-06-01'),	
	('Магазин 3', 'Адрес 3', '2012-06-01'),
	('Магазин 4', 'Адрес 4', '2013-06-01'),
	('Магазин 5', 'Адрес 5', '2014-06-01'),
	('Магазин 6', 'Адрес 6', '2015-06-01'),
	('Магазин 7', 'Адрес 7', '2016-06-01'),
	('Магазин 8', 'Адрес 8', '2017-06-01'),
	('Магазин 9', 'Адрес 9', '2018-06-01'),
	('Магазин 10', 'Адрес 10', '2019-06-01');
   
INSERT INTO department(name)
VALUES
	('Строительные материалы'),
	('Отделочные материалы'),
	('Плитка'),
	('Напольные покрытия'),
	('Элетротовары'),
	('Сантехника'),
	('Инструменты'),
	('Краски'),
	('Кухни');
	
INSERT INTO sub_department(name, id_department)
VALUES
	('Мойки', 9),
	('Смесители', 9),
	('Бытовая техника', 9),
	('Аксессуары', 9),
	('Столешницы', 9),
	('Фасады', 9),
	('Фурнитура', 9),
	('Каркасы', 9),
	('Ламинат', 4),
	('Линолеум', 4);

INSERT INTO products_type (name, id_sub_department)
VALUES
	('32 класс', 9),
	('33 класс', 9),
	('34 класс', 9),
	('Стиральные машины', 3),
	('Вытяжки', 3),
	('Плиты отдельностоящие', 3),
	('Варочные поверхности', 3),
	('Духовые шкафы', 3),
	('Металлические мойки', 1),
	('Кварцевые мойки', 1),
	('Мраморные мойки', 1);

INSERT INTO providers (name, provider_number, id_department)
VALUES
	('ООО "Деревяшки"', 1234567, 4),
	('ООО "Крона"', 1234568, 4),
	('ИП Иванов И.И.', 1234569, 4),
	('ООО "Металлист"', 1234561, 9),
	('ООО "Камни"', 1234562, 9),
	('Индезит', 1234563, 9),
	('Ханса', 1234564, 9),
	('ИП Сидоров С.С.', 1234565, 9),
	('ООО "Мрамор"', 1234566, 9),
	('ООО "Линолеумище"', 1234555, 4);

INSERT INTO contract_info (providers_id, phone, email, adress, INN, contact_name, franko, dayofdel)
VALUES
	(1, 9789456123, '9789456123@mail.ru', 'г.Город, ул.Улица, дом 1', 999999991, 'Ирина', 10000, 5),
	(2, 9789456122, '9789456122@mail.ru', 'г.Город, ул.Улица, дом 2', 999999992, 'Ирина', 20000, 10),
	(3, 9789456121, '9789456121@mail.ru', 'г.Город, ул.Улица, дом 3', 999999993, 'Ирина', 30000, 8),
	(4, 9789456124, '9789456124@mail.ru', 'г.Город, ул.Улица, дом 4', 999999994, 'Ирина', 40000, 9),
	(5, 9789456125, '9789456125@mail.ru', 'г.Город, ул.Улица, дом 5', 999999995, 'Ирина', 50000, 7),
	(6, 9789456126, '9789456126@mail.ru', 'г.Город, ул.Улица, дом 6', 999999996, 'Ирина', 60000, 18),
	(7, 9789456127, '9789456127@mail.ru', 'г.Город, ул.Улица, дом 7', 999999997, 'Ирина', 70000, 11),
	(8, 9789456128, '9789456128@mail.ru', 'г.Город, ул.Улица, дом 8', 999999998, 'Ирина', 80000, 5),
	(9, 9789456129, '9789456129@mail.ru', 'г.Город, ул.Улица, дом 9', 999999999, 'Ирина', 90000, 4),
	(10, 9789456111, '9789456111@mail.ru', 'г.Город, ул.Улица, дом 10', 999999910, 'Ирина', 100000, 7);

UPDATE contract_info 
SET contact_name = 'Василий'
WHERE providers_id = 1;
	
INSERT INTO products (name, id_products_type, id_provider)
VALUES
	('ВАР.ПОВ. ЭЛ 4 КОНФ HANSA BHC66706 ЧЕР', 7, 7),
	('ВАР.ПОВ ГАЗ 4КОНФ INDESIT THP641W/IX/I Н', 7, 6),
	('ДУХ ШКАФ ЭЛ 60 INDESIT IFW 5844 JH IX Н', 8, 6),
	('СТИР МАШ ОТД85Х60 INDESIT IWSC5105(CIS)Б', 4, 6),	
	('ДУХ ШКАФ ЭЛ 60 HANSA BOEW68120090 БЕЖ', 8, 7),	
	('МОЙКА КУХ.MAIDSINKS 51Х51 Г17,5  ЛЕН', 9, 4),
	('МОЙКА КУХ.2 ЧАШИ MLN7749S, 77Х49 Г18, ХР', 9, 8),	
	('Мойка кух. КМ 59-48 Белый Г19', 11, 9),
	('МОЙКА КУХ.КРЫЛ. 78Х51 Г20 ,БЕЖ', 10, 5),
	('МОЙКА LM1 51Х51 Г20 АНТРАЦИТ', 10, 5),
	('Ламинат дуб красивый', 1, 1),
	('Ламинат сосна белая', 3, 2);

INSERT INTO edizm (name)
VALUES
	('шт.'), ('кг.'), ('т.'), ('м2'), ('пог.м'), ('уп.');

INSERT INTO about_products
VALUES
	(1, 'Варочная поверхность Hi Light Hansa c 4 конфорками и 4 таймерами для программирования времени готовки имеет удобное управление при помощи сенсорных элементов на фронтальной панели.',	10, 4, 60, 60, 1, 1, 1),
	(2, 'Варочная панель газовая Indesit THP 641 W/IX/I — компактная альтернатива традиционной кухонной плите.', 10, 4, 60, 60, 1, 1, 1),
	(3, 'Духовой шкаф Indesit IFW 5844 JH IX — инновационная модель, экономно потребляющая электроэнергию. ', 30, 60, 60, 60, 1, 1, 1),
	(4, 'Стиральная машина Indesit IWSC 5105 (CIS) — элегантное решение для небольшой ванной.',	50, 60, 80, 40, 1, 1, 1),
	(5, 'Прекрасный духовой шкаф в классическом стиле',	30, 60, 60, 60, 1, 1, 1),
	(6, 'Металлическая круглая мойка из стали А класса',	1, 18, 51, 51, 1, 1, 12),
	(7, 'Вместительная металлическая двухчашная мойка из стали Б класса',	1, 18, 77, 49, 1, 1, 13),
	(8, 'Компактная мраморная мойка белого цвета, прекрасно подойдет к любой кухне.',	4, 19, 59, 48, 1, 1, 1),
	(9, 'Мойка из кварца с крылом бежевого цвета.',	7, 20, 78, 51, 1, 1, 1),
	(10, 'Квадратная мойка черного цвета.',5, 20, 51, 51, 1, 1, 1),
	(11, 'Ламинат в бежевых оттенках',3, 10, 25, 100, 6, 1, 1),
	(12, 'Светлый ламинат',3.5, 10, 25, 100, 6, 1, 1);

INSERT INTO media (products_id)
VALUES 
	(1), (2), (3),(4),(5),(6),(7),(8),(9),(10);

INSERT INTO store_product (products_id, store_id)
VALUES 
	(1, 1),
	(2, 1),
	(3, 1),
	(4, 1),
	(5, 1),
	(6, 1),
	(7, 1),
	(8, 1),
	(9, 1),
	(10, 2),
	(11, 1),
	(12, 2);

INSERT INTO price (store_product_id, priceDPAC, price_from_CO, price_from_MAG)
VALUES 
	(1, 10000, 20000, 18500),
	(2, 11000, 19000, 16500),
	(3, 20000, 30000, 28500),
	(4, 15000, 26000, 21500),
	(5, 28000, 39000, 39000),
	(6, 1000, 2000, 1850),
	(7, 1600, 2800, 2800),
	(8, 5000, 7000, 6500),
	(9, 6000, 8000, 8000),
	(10, 4500, 5500, 5500),
	(11, 900, 1800, 1800),
	(12, 1100, 2300, 2200);

INSERT INTO sold_products (store_product_id, balance, date_first_delivery, ordered)
VALUES 
	(1, 10, '2020-01-06', 5),
	(2, 20, '2020-02-06', 10),
	(3, 15, '2020-03-06', 5),
	(4, 8, '2020-04-06', 15),
	(5, 18, '2020-05-06', 6),
	(6, 22, '2020-06-06', 36),
	(7, 19, '2020-07-06', 26),
	(8, 20, '2020-08-06', 10),
	(9, 8, '2020-09-06', 20),
	(10, 10, '2020-10-06', 30),
	(11, 10, '2020-11-06', 3),
	(12, 10, '2020-12-06', 54);
	

#сформируем полную таблицу запасов всех магазинов

SELECT 	
	store.name as 'Магазин',
	department.name as 'Отдел',
	products.id as 'Артикул',
	products.name as 'Наименование',
	sub_department.name as 'Подотдел',
	products_type.name as 'Тип',
	sold_products.balance as 'Остаток',
	sold_products.date_first_delivery as 'Дата первой поставки',
	sold_products.date_last_delivery as 'Дата последней поставки',
	sold_products.date_last_sale as 'Дата последней продажи',
	sold_products.sold as 'Продано за 30 дней',
	sold_products.ordered as 'В активных заказах',
	price.priceDPAC as 'Закупочная цена',
	price.price_from_CO as 'Рекомендуемая цена',
	price.price_from_MAG as 'Продажная цена',
	price.updated_at as 'Дата последнего изменения цены',
	providers.provider_number as 'Номер поставщика',
	providers.name as 'Наименование поставщика'			
FROM store 
JOIN store_product ON store_product.store_id = store.id 
JOIN products ON store_product.products_id = products.id
JOIN products_type ON products.id_products_type = products_type.id 
JOIN sub_department ON products_type.id_sub_department = sub_department.id 
JOIN department ON sub_department.id_department = department.id 
JOIN sold_products ON store_product.id = sold_products.store_product_id
JOIN price ON store_product.id = price.store_product_id
JOIN providers ON products.id_provider = providers.id
ORDER BY store.name;

#представление с описанием товара для формирования информации на сайте

CREATE OR REPLACE VIEW prod(num, name, edizm, weight, h, w, d, about) AS
	SELECT 
		p.id,
		p.name,
		e.name,
		ap.weight,
		ap.height,
		ap.width,
		ap.dep,
		ap.about
	FROM products as p 
	JOIN about_products as ap ON p.id = ap.products_id
	JOIN edizm as e ON e.id = ap.edizm_id
	ORDER BY p.id;

SELECT
	num as 'Артикул',
	name as 'Наименование',
	edizm as 'Единица измерения',
	weight as 'Вес',
	h as 'Высота',
	w as 'Ширина',
	d as 'Глубина',
	about as 'Описание'
FROM prod;

# Сформируем представление с количеством SCU каждого типа отдела Кухни

CREATE OR REPLACE VIEW Kitchen (sub_department, products_type, count_products) AS 
	SELECT sd.name, pt.name, count(p.id) as 'количество SCU' 
	FROM products_type as pt
	JOIN products as p ON p.id_products_type = pt.id
	JOIN sub_department as sd ON pt.id_sub_department = sd.id 
	WHERE sd.id_department = (
		SELECT id FROM department 
		WHERE name = 'Кухни')
	GROUP BY p.id_products_type;

SELECT * FROM Kitchen;

# Высчитаем стоимость товарного запаса в Магазине 1 применяя функцию

DELIMITER //

DROP FUNCTION IF EXISTS balanceDPAC//
CREATE FUNCTION balanceDPAC(st INT)
RETURNS BIGINT DETERMINISTIC
BEGIN
	DECLARE zapas BIGINT;
	SELECT SUM(sold_products.balance * price.priceDPAC)
	FROM sold_products  
	JOIN price ON sold_products.store_product_id = price.store_product_id
	JOIN store_product ON store_product.id = sold_products.store_product_id
	WHERE store_id = st
	INTO zapas;
	RETURN zapas;
END//

DELIMITER ;

SELECT balanceDPAC(1);




	