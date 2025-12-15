-- Спочатку заповнюємо довідники (незалежні таблиці)
INSERT INTO Marka_Avto (Nazva_Marky) VALUES ('Toyota'), ('BMW'), ('Audi'), ('Mercedes'), ('Honda');

INSERT INTO Kliyent (Prizvyshche, Imya, Telefon) VALUES 
('Petrenko', 'Ivan', '0501112233'),
('Shevchenko', 'Olena', '0679998877'),
('Bondar', 'Vasyl', '0635554433'),
('Kovalenko', 'Dmytro', '0934445566'),
('Melnyk', 'Iryna', '0971234567');

INSERT INTO Postachalnyk (Nazva_Firmy, Adresa, Telefon) VALUES 
('AutoParts UA', 'Kyiv, Peremohy 5', '0441234567'),
('German Details', 'Berlin, Main St 1', '+49123456');

INSERT INTO Posluga (Nazva_Poslugy, Vartist_Roboty, Tryvalist) VALUES 
('Oil Change', 500.00, 30),
('Tire Replacement', 800.00, 60),
('Engine Repair', 5000.00, 300),
('Brake Inspection', 300.00, 40),
('Battery Replacement', 200.00, 20);

INSERT INTO Mayster (Prizvyshche, Imya, Spetsializatsiya, Rozryad) VALUES 
('Koval', 'Petro', 'Engine', 5),
('Tkach', 'Andriy', 'Chassis', 4),
('Rudenko', 'Oleg', 'Electrician', 3);

-- Тепер таблиці, що залежать від попередніх
INSERT INTO Detal (Nazva_Detali, Vartist_Detali, Kilkist_Na_Skladi, ID_Postachalnyka) VALUES 
('Oil Filter', 200.00, 50, 1),
('Motor Oil 5W30', 1500.00, 20, 1),
('Brake Pads', 1200.00, 15, 2),
('Car Battery', 2500.00, 10, 2),
('Spark Plug', 150.00, 100, 1);

INSERT INTO Avtomobil (Model, Derzh_Nomer, Rik_Vypusku, ID_Kliyenta, ID_Marky) VALUES 
('Camry', 'AA1234AA', 2018, 1, 1), -- Petrenko, Toyota
('X5', 'BC5678BC', 2020, 2, 2), -- Shevchenko, BMW
('Civic', 'KA9999KA', 2015, 3, 5); -- Bondar, Honda

-- Створення замовлень
INSERT INTO Zamovlennya (Data_Zamovlennya, Status, Zagalna_Suma, ID_Avto) VALUES 
('2025-12-01', 'Completed', 2200.00, 1),
('2025-12-05', 'In Progress', 0.00, 2),
('2025-12-10', 'New', 0.00, 3);

-- Деталізація (наповнення зв'язків M:N)
-- Замовлення 1: Заміна масла + Фільтр + Масло
INSERT INTO Zamovleni_Poslugy (ID_Zamovlennya, ID_Poslugy, Kilkist, Faktychna_Cina) VALUES (1, 1, 1, 500.00);
INSERT INTO Vykorystani_Detali (ID_Zamovlennya, ID_Detali, Kilkist) VALUES (1, 1, 1), (1, 2, 1);
INSERT INTO Vykonavtsi (ID_Zamovlennya, ID_Maystra, Vidpracovani_Godyny) VALUES (1, 1, 2);

-- Замовлення 2: Діагностика гальм
INSERT INTO Zamovleni_Poslugy (ID_Zamovlennya, ID_Poslugy, Kilkist, Faktychna_Cina) VALUES (2, 4, 1, 300.00);
INSERT INTO Vykonavtsi (ID_Zamovlennya, ID_Maystra, Vidpracovani_Godyny) VALUES (2, 2, 1);


DECLARE @i INT;
SET @i = 1;

WHILE @i <= 1000
BEGIN
    -- Додаємо 1000 клієнтів "Bot_1", "Bot_2" ...
    INSERT INTO Kliyent (Prizvyshche, Imya, Telefon)
    VALUES ('Client_' + CAST(@i AS VARCHAR), 'Bot', '000-00-00');

    -- Додаємо 1000 замовлень для цих клієнтів
    -- (Для спрощення прив'язуємо до першого авто в базі)
    INSERT INTO Zamovlennya (Data_Zamovlennya, Status, Zagalna_Suma, ID_Avto)
    VALUES (GETDATE(), 'Generated', 100.00, 1);

    SET @i = @i + 1;
    SELECT * FROM Kliyent;
END;
GO