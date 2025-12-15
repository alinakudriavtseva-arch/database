-- Створення бази даних
-- CREATE DATABASE AvtoServiceDB;
-- GO
-- USE AvtoServiceDB;
-- GO

-- 1. Таблиця КЛІЄНТ
CREATE TABLE Kliyent (
    ID_Kliyenta INT PRIMARY KEY IDENTITY(1,1),
    Prizvyshche NVARCHAR(50) NOT NULL,
    Imya NVARCHAR(50) NOT NULL,
    Telefon VARCHAR(15) NULL
);

-- 2. Таблиця МАРКА_АВТО
CREATE TABLE Marka_Avto (
    ID_Marky INT PRIMARY KEY IDENTITY(1,1),
    Nazva_Marky NVARCHAR(50) NOT NULL UNIQUE
);

-- 3. Таблиця ПОСТАЧАЛЬНИК
CREATE TABLE Postachalnyk (
    ID_Postachalnyka INT PRIMARY KEY IDENTITY(1,1),
    Nazva_Firmy NVARCHAR(100) NOT NULL,
    Adresa NVARCHAR(200) NULL,
    Telefon VARCHAR(15) NULL
);

-- 4. Таблиця ПОСЛУГА
CREATE TABLE Posluga (
    ID_Poslugy INT PRIMARY KEY IDENTITY(1,1),
    Nazva_Poslugy NVARCHAR(100) NOT NULL,
    Vartist_Roboty MONEY NOT NULL CHECK (Vartist_Roboty >= 0),
    Tryvalist INT NULL -- у хвилинах
);

-- 5. Таблиця МАЙСТЕР
CREATE TABLE Mayster (
    ID_Maystra INT PRIMARY KEY IDENTITY(1,1),
    Prizvyshche NVARCHAR(50) NOT NULL,
    Imya NVARCHAR(50) NOT NULL,
    Spetsializatsiya NVARCHAR(50) NULL,
    Rozryad INT NULL
);

-- 6. Таблиця АВТОМОБІЛЬ (Залежить від Клієнта і Марки)
CREATE TABLE Avtomobil (
    ID_Avto INT PRIMARY KEY IDENTITY(1,1),
    Model NVARCHAR(50) NULL,
    Derzh_Nomer VARCHAR(20) NOT NULL UNIQUE,
    Rik_Vypusku INT NULL CHECK (Rik_Vypusku > 1900),
    ID_Kliyenta INT NOT NULL,
    ID_Marky INT NOT NULL,
    FOREIGN KEY (ID_Kliyenta) REFERENCES Kliyent(ID_Kliyenta),
    FOREIGN KEY (ID_Marky) REFERENCES Marka_Avto(ID_Marky)
);

-- 7. Таблиця ДЕТАЛЬ (Залежить від Постачальника і самої себе - аналог)
CREATE TABLE Detal (
    ID_Detali INT PRIMARY KEY IDENTITY(1,1),
    Nazva_Detali NVARCHAR(100) NOT NULL,
    Vartist_Detali MONEY NOT NULL CHECK (Vartist_Detali >= 0),
    Kilkist_Na_Skladi INT NOT NULL DEFAULT 0,
    ID_Postachalnyka INT NOT NULL,
    ID_Analoga INT NULL,
    FOREIGN KEY (ID_Postachalnyka) REFERENCES Postachalnyk(ID_Postachalnyka),
    FOREIGN KEY (ID_Analoga) REFERENCES Detal(ID_Detali) -- Рекурсивний зв'язок
);

-- 8. Таблиця ЗАМОВЛЕННЯ (Залежить від Авто)
CREATE TABLE Zamovlennya (
    ID_Zamovlennya INT PRIMARY KEY IDENTITY(1,1),
    Data_Zamovlennya DATE NOT NULL DEFAULT GETDATE(),
    Status NVARCHAR(20) NOT NULL,
    Zagalna_Suma MONEY NULL,
    ID_Avto INT NOT NULL,
    FOREIGN KEY (ID_Avto) REFERENCES Avtomobil(ID_Avto)
);

-- 9. Таблиця ЗАМОВЛЕНІ_ПОСЛУГИ (Зв'язок M:N)
CREATE TABLE Zamovleni_Poslugy (
    ID_Zamovlennya INT NOT NULL,
    ID_Poslugy INT NOT NULL,
    Kilkist INT NOT NULL DEFAULT 1,
    Faktychna_Cina MONEY NOT NULL,
    PRIMARY KEY (ID_Zamovlennya, ID_Poslugy),
    FOREIGN KEY (ID_Zamovlennya) REFERENCES Zamovlennya(ID_Zamovlennya) ON DELETE CASCADE,
    FOREIGN KEY (ID_Poslugy) REFERENCES Posluga(ID_Poslugy)
);

-- 10. Таблиця ВИКОРИСТАНІ_ДЕТАЛІ (Зв'язок M:N)
CREATE TABLE Vykorystani_Detali (
    ID_Zamovlennya INT NOT NULL,
    ID_Detali INT NOT NULL,
    Kilkist INT NOT NULL DEFAULT 1,
    PRIMARY KEY (ID_Zamovlennya, ID_Detali),
    FOREIGN KEY (ID_Zamovlennya) REFERENCES Zamovlennya(ID_Zamovlennya) ON DELETE CASCADE,
    FOREIGN KEY (ID_Detali) REFERENCES Detal(ID_Detali)
);

-- 11. Таблиця ВИКОНАВЦІ (Зв'язок M:N)
CREATE TABLE Vykonavtsi (
    ID_Zamovlennya INT NOT NULL,
    ID_Maystra INT NOT NULL,
    Vidpracovani_Godyny INT NULL,
    PRIMARY KEY (ID_Zamovlennya, ID_Maystra),
    FOREIGN KEY (ID_Zamovlennya) REFERENCES Zamovlennya(ID_Zamovlennya) ON DELETE CASCADE,
    FOREIGN KEY (ID_Maystra) REFERENCES Mayster(ID_Maystra)
);