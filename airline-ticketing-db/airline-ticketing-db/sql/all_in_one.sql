
---CREATE THE DATABASE---

-- Create the Database
CREATE DATABASE AirlineTicketingDB;
GO

-- Switch to the context of the new database
USE AirlineTicketingDB;
GO




---CREATE TABLES---


-- Create Passanger table
CREATE TABLE Passenger (
    PassengerID INT PRIMARY KEY IDENTITY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL CHECK (
        Email LIKE '%@%.%' AND 
        Email NOT LIKE '% %' -- This is to detect whitespace
    ),
    DateOfBirth DATE NOT NULL CHECK (DateOfBirth < GETDATE()),
    EmergencyContactNumber NVARCHAR(20) CHECK (
        LEN(EmergencyContactNumber) >= 8 AND 
        EmergencyContactNumber NOT LIKE '%[^0-9+().-]%' -- Allows +, (, ), -, .
    )
);


-- Create Flight table
CREATE TABLE Flight (
    FlightID INT PRIMARY KEY IDENTITY,
    FlightNumber NVARCHAR(10) NOT NULL,
    OriginAirport NVARCHAR(50) NOT NULL,
    DestinationAirport NVARCHAR(50) NOT NULL,
    DepartureTime DATETIME NOT NULL,
    ArrivalTime DATETIME NOT NULL
);



-- Create Employee table
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE CHECK (
        Email LIKE '%@%.%' AND 
        Email NOT LIKE '% %' -- This is to detect whitespace
    ),
    Username NVARCHAR(50) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    Role NVARCHAR(30) NOT NULL CHECK (
        Role IN ('TicketingStaff', 'TicketingSupervisor')
    )
);


-- Create Seat table
CREATE TABLE Seat (
    SeatID INT PRIMARY KEY IDENTITY,
    SeatNumber NVARCHAR(10) NOT NULL UNIQUE,
    SeatClass NVARCHAR(30) NOT NULL CHECK (
        SeatClass IN ('Economy', 'Business', 'First')
    )
);


-- Create Fare table
CREATE TABLE Fare (
    FareID INT PRIMARY KEY IDENTITY,
    FareClass NVARCHAR(30) NOT NULL CHECK (
        FareClass IN ('Economy', 'Business', 'First')
    ),
    BasePrice DECIMAL(6,2) NOT NULL CHECK (BasePrice >= 0),
    SeatSelectionFee DECIMAL(6,2) NOT NULL CHECK (SeatSelectionFee >= 0),
    ExcessBaggageFeeKg DECIMAL(6,2) NOT NULL CHECK (ExcessBaggageFeeKg >= 0),
    MealUpgradeFee DECIMAL(6,2) NOT NULL CHECK (MealUpgradeFee >= 0),
    BaggagePieceFee DECIMAL(6,2) NOT NULL CHECK (BaggagePieceFee >= 0),
    FlightID INT NOT NULL FOREIGN KEY REFERENCES Flight(FlightID)
);


-- Create FlightSeat table
CREATE TABLE FlightSeat (
    FlightSeatID INT PRIMARY KEY IDENTITY,
    Status NVARCHAR(30) NOT NULL CHECK (
        Status IN ('Available', 'Reserved')
    ),
    FlightID INT NOT NULL FOREIGN KEY REFERENCES Flight(FlightID),
    SeatID INT NOT NULL FOREIGN KEY REFERENCES Seat(SeatID),
	-- FK to be added later via ALTER TABLE to avoid circular reference error with the Reservation table which has not yet been created
    ReservationID INT NULL, 
	-- Enforces unique SeatID-ReservationID combinations preventing the same seat reserved more than once in the same flight
    CONSTRAINT UQ_FlightSeat_FlightID_SeatID UNIQUE (FlightID, SeatID)
);


-- Create Reservation table
CREATE TABLE Reservation (
    ReservationID INT PRIMARY KEY IDENTITY,
    BookingDate DATE NOT NULL,
    Status NVARCHAR(30) NOT NULL CHECK (
        Status IN ('Pending', 'Confirmed', 'Cancelled')
    ),
    PNR NVARCHAR(10) NOT NULL UNIQUE,
    MealUpgradeChoice BIT NOT NULL DEFAULT 0,
    MealPreference NVARCHAR(30) NOT NULL CHECK (
        MealPreference IN ('Vegetarian', 'Non-Vegetarian')
    ),
    PassengerID INT NOT NULL FOREIGN KEY REFERENCES Passenger(PassengerID),
    FlightID INT NOT NULL FOREIGN KEY REFERENCES Flight(FlightID),
    FareID INT NOT NULL FOREIGN KEY REFERENCES Fare(FareID),
    FlightSeatID INT NULL FOREIGN KEY REFERENCES FlightSeat(FlightSeatID)
);


-- Add ReservastionID FK Constraint to FlightSeat Table
-- Completes circular refrence after Reservation Table is created
ALTER TABLE FlightSeat
ADD CONSTRAINT FK_FlightSeat_Reservation
FOREIGN KEY (ReservationID) REFERENCES Reservation(ReservationID);


-- Create Ticket table
CREATE TABLE Ticket (
    TicketID INT PRIMARY KEY IDENTITY,
    IssueDate DATE NOT NULL,
    EboardingNumber NVARCHAR(30) NOT NULL,
    ReservationID INT NOT NULL UNIQUE FOREIGN KEY REFERENCES Reservation(ReservationID),
    EmployeeID INT NOT NULL FOREIGN KEY REFERENCES Employee(EmployeeID)
);


-- Create Baggage table
CREATE TABLE Baggage (
    BaggageID INT PRIMARY KEY IDENTITY,
    Weight DECIMAL(5,2) NOT NULL CHECK (Weight >= 0),
    Status NVARCHAR(30) NOT NULL CHECK (
        Status IN ('Checked-In', 'Loaded', 'Missing')
    ),
    Cost DECIMAL(6,2) NOT NULL CHECK (Cost >= 0),
    ReservationID INT NOT NULL FOREIGN KEY REFERENCES Reservation(ReservationID)
);


--- INSERT DATA---

-- Insert Data in Passenger table
BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO Passenger (FirstName, LastName, Email, DateOfBirth, EmergencyContactNumber)
    VALUES 
        ('Aisha', 'Khan', 'aisha.khan@mail.com', '1980-05-22', '+44-7700-900111'),
        ('Carlos', 'Ramírez', 'c.ramirez@yahoo.com', '1992-11-10', '+34-600-123456'),
        ('Zhang', 'Wei', 'zhang.wei@GmAil.com', '2001-03-15', NULL),
        ('Liam', 'O''Connor', 'liam.oconnor@mail.nhs.com', '1983-07-09', '+353-850-112233'),
        ('Fatima', 'Al-Mansouri', 'fatima.m@un.org', '1998-12-01', NULL),
        ('Emily', 'Nguyen', 'emily.nguyen@msn.com', '2004-09-27', '+1-310-555-7890'),
        ('Rajesh', 'Kumar', 'rajesh.kumar@hotmail.com', '1990-02-18', NULL),
        ('Sophia', 'Müller', 's.muller@worldbank-HHRR.com', '1995-06-30', '+49-151-23456789'),
        ('James', 'Anderson', 'james.a@123.com', '2002-04-14', NULL),
        ('Hassan', 'Youssef', 'h.youssef@this.is.a.very.long.domain.with.many.subdomains.test', '1970-08-03', '+20-101-2223334');

    COMMIT TRANSACTION;
    PRINT 'Passenger data was inserted successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'An error has occurred:';
    PRINT ERROR_MESSAGE();
	-- Resets the identity counter so if the transaction fails the next insert starts at the begining
    DBCC CHECKIDENT ('Passenger', RESEED, 0);
END CATCH;

-- Insert Data into Flight table
BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO Flight (FlightNumber, OriginAirport, DestinationAirport, DepartureTime, ArrivalTime)
    VALUES 
    ('BA123', 'London', 'Brasilia', '2025-04-18 10:30', '2025-04-18 13:00'),
    ('AF456', 'Paris', 'Osaka', '2025-04-19 14:00', '2025-04-20 08:30'),
    ('DL789', 'New York', 'Denver', '2025-04-20 09:15', '2025-04-20 12:30'),
    ('EK202', 'Dubai', 'Sydney', '2025-04-21 22:00', '2025-04-22 16:00'),
    ('LH330', 'Frankfurt', 'Johannesburg', '2025-04-22 13:45', '2025-04-22 22:05'),
    ('AI101', 'Delhi', 'London', '2025-04-23 02:00', '2025-04-23 06:30'),
    ('CX999', 'Hong Kong', 'San Francisco', '2025-04-24 23:45', '2025-04-24 20:10'),
    ('QF302', 'Melbourne', 'Singapore', '2025-04-25 07:00', '2025-04-25 13:00'),
    ('KL888', 'Amsterdam', 'Toronto', '2025-04-26 15:30', '2025-04-26 18:00'),
    ('AZ321', 'Rome', 'Cairo', '2025-04-27 11:20', '2025-04-27 15:10');

    COMMIT TRANSACTION;
    PRINT 'Flight data was inserted successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'An error has occurred:';
    PRINT ERROR_MESSAGE();
	DBCC CHECKIDENT ('Flight', RESEED, 0);
END CATCH;

-- Insert Data into Employee table
BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO Employee (Name, Email, Username, PasswordHash, Role)
    VALUES 
    ('Ana María López', 'ana.lopez@emirates-HHRR.com', 'ana_lopez', '2a1c9edfea4f7b6a5d9c57a18e3291bc4f94de973f89bc801e4ab12e2a6fa5b3', 'TicketingStaff'),
    ('David Smith', 'david.smith@emirates.bookings.com', 'dsmith', 'pw_456', 'TicketingSupervisor'),
    ('Mei Ling', 'mei.ling@EmiRateS.com', 'mei_ling88', 'pw_mei_ling', 'TicketingStaff'),
    ('Ahmed El-Sayed', 'ahmed.sayed@emirates.ticketing.complaints.com', 'ahmed_s', 'ahmed_pass', 'TicketingStaff'),
    ('Emma Johansson', 'emma.j@emirates.com', 'emma_j', 'emma_pw', 'TicketingSupervisor'),
    ('Carlos Mendes', 'c.mendes@emirates.com', 'cmendes77', 'carlos_pw', 'TicketingStaff'),
    ('Nobuo Tanaka', 'n.tanaka@emirated.com', 'nobuo_t', 'tanaka_pw', 'TicketingStaff'),
    ('Fatima Zahra', 'fatima.z@emirates.com', 'fzahra', 'fzahra_pw', 'TicketingSupervisor'),
    ('John O''Reilly', 'john.oreilly@emirates.com', 'john_o', 'john_pw123', 'TicketingStaff'),
    ('Sara Ibrahim', 'sara.ibrahim@emirates.com', 'sara_ibrahim', 'sara_pw', 'TicketingStaff');

    COMMIT TRANSACTION;
    PRINT 'Employee data was inserted successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'An error has occurred:';
    PRINT ERROR_MESSAGE();
	DBCC CHECKIDENT ('Employee', RESEED, 0);
END CATCH;

-- Insert Data into Seat table
BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO Seat (SeatNumber, SeatClass)
    VALUES 
    ('E1', 'Economy'), ('E2', 'Economy'), ('E3', 'Economy'), ('E4', 'Economy'), ('E5', 'Economy'),
    ('E6', 'Economy'), ('E7', 'Economy'), ('E8', 'Economy'), ('E9', 'Economy'), ('E10', 'Economy'),
    ('B1', 'Business'), ('B2', 'Business'), ('B3', 'Business'), ('B4', 'Business'), ('B5', 'Business'),
    ('F1', 'First'), ('F2', 'First'), ('F3', 'First'), ('F4', 'First'), ('F5', 'First');

    COMMIT TRANSACTION;
    PRINT 'Seat data was inserted successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'An error has occurred:';
    PRINT ERROR_MESSAGE();
    DBCC CHECKIDENT ('Seat', RESEED, 0);
END CATCH;

-- Insert Data into Fare table
-- All fares follow the same additional services fee structure specified in the scenario
BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO Fare (FareClass, BasePrice, SeatSelectionFee, 
	ExcessBaggageFeeKg, MealUpgradeFee, BaggagePieceFee, FlightID)
    VALUES 
    -- Fares for FlightID 1
    ('Economy', 150.00, 30.00, 100.00, 20.00, 100.00, 1),
    ('Business', 400.00, 30.00, 100.00, 20.00, 100.00, 1),
    ('First', 800.00, 30.00, 100.00, 20.00, 100.00, 1),

    -- Fares for FlightID 2
    ('Economy', 160.00, 30.00, 100.00, 20.00, 100.00, 2),
    ('Business', 420.00, 30.00, 100.00, 20.00, 100.00, 2),
    ('First', 850.00, 30.00, 100.00, 20.00, 100.00, 2),

    -- Fares for FlightID 3
    ('Economy', 140.00, 30.00, 100.00, 20.00, 100.00, 3),
    ('Business', 410.00, 30.00, 100.00, 20.00, 100.00, 3),
    ('First', 780.00, 30.00, 100.00, 20.00, 100.00, 3),

    -- Fares for FlightID 4
    ('Economy', 200.00, 30.00, 100.00, 20.00, 100.00, 4),
    ('Business', 500.00, 30.00, 100.00, 20.00, 100.00, 4),
    ('First', 900.00, 30.00, 100.00, 20.00, 100.00, 4),

    -- Fares for FlightID 5
    ('Economy', 175.00, 30.00, 100.00, 20.00, 100.00, 5),
    ('Business', 450.00, 30.00, 100.00, 20.00, 100.00, 5),
    ('First', 870.00, 30.00, 100.00, 20.00, 100.00, 5),

    -- Fares for FlightID 6
    ('Economy', 180.00, 30.00, 100.00, 20.00, 100.00, 6),
    ('Business', 470.00, 30.00, 100.00, 20.00, 100.00, 6),
    ('First', 890.00, 30.00, 100.00, 20.00, 100.00, 6),

    -- Fares for FlightID 7
    ('Economy', 190.00, 30.00, 100.00, 20.00, 100.00, 7),
    ('Business', 490.00, 30.00, 100.00, 20.00, 100.00, 7),
    ('First', 920.00, 30.00, 100.00, 20.00, 100.00, 7),

    -- Fares for FlightID 8
    ('Economy', 170.00, 30.00, 100.00, 20.00, 100.00, 8),
    ('Business', 440.00, 30.00, 100.00, 20.00, 100.00, 8),
    ('First', 860.00, 30.00, 100.00, 20.00, 100.00, 8),

    -- Fares for FlightID 9
    ('Economy', 165.00, 30.00, 100.00, 20.00, 100.00, 9),
    ('Business', 430.00, 30.00, 100.00, 20.00, 100.00, 9),
    ('First', 840.00, 30.00, 100.00, 20.00, 100.00, 9),

    -- Fares for FlightID 10
    ('Economy', 155.00, 30.00, 100.00, 20.00, 100.00, 10),
    ('Business', 410.00, 30.00, 100.00, 20.00, 100.00, 10),
    ('First', 820.00, 30.00, 100.00, 20.00, 100.00, 10);

    COMMIT TRANSACTION;
    PRINT 'Fare data was inserted successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'An error has occurred:';
    PRINT ERROR_MESSAGE();
    DBCC CHECKIDENT ('Fare', RESEED, 0);
END CATCH;

-- Insert Data into FlightSeat table (15 seats accross 3 flights)
-- ReservationID FK not included
-- ReservationID FK will be updated after populating the Reservation table
-- due to circular reference
BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO FlightSeat (Status, FlightID, SeatID)
    VALUES 
    -- Flight 1
    ('Available', 1, 1),
    ('Available', 1, 2),
    ('Available', 1, 3),
    ('Available', 1, 4),
    ('Available', 1, 5),

    -- Flight 2
    ('Available', 2, 6),
    ('Available', 2, 7),
    ('Available', 2, 8),
    ('Available', 2, 9),
    ('Available', 2, 10),

    -- Flight 3
    ('Available', 3, 11),
    ('Available', 3, 12),
    ('Available', 3, 13),
    ('Available', 3, 14),
    ('Available', 3, 15);

    COMMIT TRANSACTION;
    PRINT 'FlightSeat data inserted successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error inserting FlightSeat data:';
    PRINT ERROR_MESSAGE();
    DBCC CHECKIDENT ('FlightSeat', RESEED, 0);
END CATCH;

-- Insert data into Reservation table 
BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO Reservation (
        BookingDate, Status, PNR, MealUpgradeChoice, MealPreference,
        PassengerID, FlightID, FareID, FlightSeatID
    )
    VALUES 
    ('2025-04-19', 'Confirmed', 'PNR001', 1, 'Vegetarian', 1, 1, 1, 1),
    ('2025-04-19', 'Pending',   'PNR002', 0, 'Non-Vegetarian', 2, 1, 1, 2),
    ('2025-04-20', 'Confirmed', 'PNR003', 1, 'Vegetarian', 3, 2, 2, 6),
    ('2025-04-21', 'Confirmed', 'PNR004', 0, 'Vegetarian', 4, 2, 2, 7),
    ('2025-04-21', 'Pending',   'PNR005', 1, 'Non-Vegetarian', 5, 2, 2, 8),
    ('2025-04-22', 'Confirmed', 'PNR006', 0, 'Vegetarian', 6, 3, 3, 11),
    ('2025-04-23', 'Confirmed', 'PNR007', 1, 'Non-Vegetarian', 7, 3, 3, 12),
    ('2025-04-23', 'Pending',   'PNR008', 1, 'Vegetarian', 8, 3, 3, 13),
    ('2025-04-24', 'Confirmed', 'PNR009', 0, 'Non-Vegetarian', 9, 1, 1, 3),
    ('2025-04-25', 'Confirmed', 'PNR010', 1, 'Vegetarian', 10, 1, 1, 4);

    COMMIT TRANSACTION;
    PRINT 'Reservation data inserted successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error inserting Reservation data:';
    PRINT ERROR_MESSAGE();
    DBCC CHECKIDENT ('Reservation', RESEED, 0);
END CATCH;

-- Updating ReservationID FK in FlightSeat junction table after creating the reservations
BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE FlightSeat SET ReservationID = 1 WHERE FlightSeatID = 1;
    UPDATE FlightSeat SET ReservationID = 2 WHERE FlightSeatID = 2;
    UPDATE FlightSeat SET ReservationID = 3 WHERE FlightSeatID = 6;
    UPDATE FlightSeat SET ReservationID = 4 WHERE FlightSeatID = 7;
    UPDATE FlightSeat SET ReservationID = 5 WHERE FlightSeatID = 8;
    UPDATE FlightSeat SET ReservationID = 6 WHERE FlightSeatID = 11;
    UPDATE FlightSeat SET ReservationID = 7 WHERE FlightSeatID = 12;
    UPDATE FlightSeat SET ReservationID = 8 WHERE FlightSeatID = 13;
    UPDATE FlightSeat SET ReservationID = 9 WHERE FlightSeatID = 3;
    UPDATE FlightSeat SET ReservationID = 10 WHERE FlightSeatID = 4;

    COMMIT TRANSACTION;
    PRINT 'FlightSeat records successfully updated with ReservationID.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error updating FlightSeat ReservationID:';
    PRINT ERROR_MESSAGE();
END CATCH;

-- Insert data into Ticket table
BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO Ticket (IssueDate, EboardingNumber, ReservationID, EmployeeID)
    VALUES
    ('2025-04-15', 'EBD12345601', 1, 1),
    ('2025-04-15', 'EBD12345602', 2, 2),
    ('2025-04-16', 'EBD12345603', 3, 3),
    ('2025-04-16', 'EBD12345604', 4, 4),
    ('2025-04-17', 'EBD12345605', 5, 5),
    ('2025-04-17', 'EBD12345606', 6, 6),
    ('2025-04-18', 'EBD12345607', 7, 7),
    ('2025-04-18', 'EBD12345608', 8, 8),
    ('2025-04-19', 'EBD12345609', 9, 9),
    ('2025-04-19', 'EBD12345610', 10, 10);

    COMMIT TRANSACTION;
    PRINT 'Ticket data was inserted successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'An error has occurred:';
    PRINT ERROR_MESSAGE();
    DBCC CHECKIDENT ('Ticket', RESEED, 0);
END CATCH;

-- Insert Data into Baggage table
BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO Baggage (Weight, Status, Cost, ReservationID)
    VALUES
    (18.5, 'Checked-In', 100.00, 1),
    (22.0, 'Loaded', 300.00, 2),
    (20.0, 'Checked-In', 100.00, 3),
    (25.5, 'Checked-In', 650.00, 4),
    (19.8, 'Checked-In', 100.00, 5),
    (21.0, 'Missing', 200.00, 6),
    (23.3, 'Checked-In', 430.00, 7),
    (20.0, 'Loaded', 100.00, 8),
    (26.7, 'Checked-In', 770.00, 9),
    (17.2, 'Checked-In', 100.00, 10);

    COMMIT TRANSACTION;
    PRINT 'Baggage data was inserted successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'An error has occurred:';
    PRINT ERROR_MESSAGE();
    DBCC CHECKIDENT ('Baggage', RESEED, 0);
END CATCH;

--- IMPLEMENT DATABASE SECURITY ---

-- Create Roles
CREATE ROLE TicketingStaff;
CREATE ROLE TicketingSupervisor;

-- Grant Permissions to Roles
GRANT SELECT, INSERT ON Ticket TO TicketingStaff;
GRANT SELECT ON Flight TO TicketingStaff;
GRANT SELECT ON Reservation TO TicketingStaff;
GRANT SELECT ON Passenger TO TicketingStaff;
GRANT SELECT ON Fare TO TicketingStaff;
GRANT SELECT ON Baggage TO TicketingStaff;

GRANT SELECT, INSERT, UPDATE ON Employee TO TicketingSupervisor;
GRANT SELECT, INSERT ON Ticket TO TicketingSupervisor;
GRANT SELECT ON Flight TO TicketingSupervisor;
GRANT SELECT ON Reservation TO TicketingSupervisor;
GRANT SELECT ON Passenger TO TicketingSupervisor;
GRANT SELECT ON Fare TO TicketingSupervisor;
GRANT SELECT ON Baggage TO TicketingSupervisor;

-- Create SQL Server Login and Users
CREATE LOGIN ana_lopez WITH PASSWORD = 'AnaPass123!';
CREATE LOGIN dsmith WITH PASSWORD = 'DavidPass123!';
CREATE LOGIN mei_ling88 WITH PASSWORD = 'MeiPass123!';
CREATE LOGIN ahmed_s WITH PASSWORD = 'AhmedPass123!';
CREATE LOGIN emma_j WITH PASSWORD = 'EmmaPass123!';
CREATE LOGIN cmendes77 WITH PASSWORD = 'CarlosPass123!';
CREATE LOGIN nobuo_t WITH PASSWORD = 'NobuoPass123!';
CREATE LOGIN fzahra WITH PASSWORD = 'FatimaPass123!';
CREATE LOGIN john_o WITH PASSWORD = 'JohnPass123!';
CREATE LOGIN sara_ibrahim WITH PASSWORD = 'SaraPass123!';

-- Create database-level users
CREATE USER ana_lopez FOR LOGIN ana_lopez;
CREATE USER dsmith FOR LOGIN dsmith;
CREATE USER mei_ling88 FOR LOGIN mei_ling88;
CREATE USER ahmed_s FOR LOGIN ahmed_s;
CREATE USER emma_j FOR LOGIN emma_j;
CREATE USER cmendes77 FOR LOGIN cmendes77;
CREATE USER nobuo_t FOR LOGIN nobuo_t;
CREATE USER fzahra FOR LOGIN fzahra;
CREATE USER john_o FOR LOGIN john_o;
CREATE USER sara_ibrahim FOR LOGIN sara_ibrahim;

-- Add Users to Corresponding Roles
EXEC sp_addrolemember 'TicketingStaff', 'ana_lopez';
EXEC sp_addrolemember 'TicketingStaff', 'mei_ling88';
EXEC sp_addrolemember 'TicketingStaff', 'ahmed_s';
EXEC sp_addrolemember 'TicketingStaff', 'cmendes77';
EXEC sp_addrolemember 'TicketingStaff', 'nobuo_t';
EXEC sp_addrolemember 'TicketingStaff', 'john_o';
EXEC sp_addrolemember 'TicketingStaff', 'sara_ibrahim';
EXEC sp_addrolemember 'TicketingSupervisor', 'dsmith';
EXEC sp_addrolemember 'TicketingSupervisor', 'emma_j';
EXEC sp_addrolemember 'TicketingSupervisor', 'fzahra';

-- Test security (optional)
EXECUTE AS USER = 'ana_lopez';
INSERT INTO Employee (Name, Email, Username, PasswordHash, Role)
VALUES ('Test User', 'test.user@airline.com', 'test_user', '12345', 'TicketingStaff');
REVERT;

-- Reservation Date Constraint
ALTER TABLE Reservation WITH NOCHECK
ADD CONSTRAINT CHK_Reservation_BookingDate
CHECK (BookingDate >= CAST(GETDATE() AS DATE));

-- Passenger Query: Pending reservations
SELECT P.PassengerID, P.FirstName, P.LastName, R.PNR, R.Status
FROM Passenger P
JOIN Reservation R ON P.PassengerID = R.PassengerID
WHERE R.Status = 'Pending';

-- Passenger Query: Older than 40
SELECT PassengerID, FirstName, LastName, DateOfBirth,
       DATEDIFF(YEAR, DateOfBirth, GETDATE()) AS Age
FROM Passenger
WHERE DATEDIFF(YEAR, DateOfBirth, GETDATE()) > 40;

-- Passenger Query: Search by last name
CREATE PROCEDURE SearchPassengersByLastName
    @SearchTerm NVARCHAR(50)
AS
BEGIN
    SELECT P.FirstName, P.LastName, T.TicketID, T.IssueDate, T.EboardingNumber
    FROM Passenger P
    JOIN Reservation R ON P.PassengerID = R.PassengerID
    JOIN Ticket T ON R.ReservationID = T.ReservationID
    WHERE P.LastName LIKE '%' + @SearchTerm + '%'
    ORDER BY T.IssueDate DESC;
END;

-- Listing Passengers Flying Today in Business Class Stored Procedure.
CREATE OR ALTER PROCEDURE usp_GetBusinessClassPassengersFlyingToday
AS
BEGIN
    SELECT P.FirstName, P.LastName, R.MealPreference, F.FareClass, FL.DepartureTime
    FROM Reservation R
    INNER JOIN Passenger P ON R.PassengerID = P.PassengerID
    INNER JOIN Fare F ON R.FareID = F.FareID
    INNER JOIN Flight FL ON R.FlightID = FL.FlightID
    WHERE F.FareClass = 'Business'
      AND CAST(FL.DepartureTime AS DATE) = CAST(GETDATE() AS DATE);
END;

-- Insert new employee Stored Procedure (Restricted to role supervisor)
CREATE OR ALTER PROCEDURE InsertNewEmployee
    @Name NVARCHAR(50),
    @Email NVARCHAR(100),
    @Username NVARCHAR(50),
    @PasswordHash NVARCHAR(255),
    @Role NVARCHAR(30)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO Employee (Name, Email, Username, PasswordHash, Role)
        VALUES (@Name, @Email, @Username, @PasswordHash, @Role);
        COMMIT TRANSACTION;
        SELECT * FROM Employee WHERE Username = @Username;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
    END CATCH
END;

GRANT EXECUTE ON InsertNewEmployee TO TicketingSupervisor;

-- 4d: Update passenger details Stored Procedure (If a reservation exists)
CREATE OR ALTER PROCEDURE UpdatePassengerDetails
    @PassengerID INT,
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Email NVARCHAR(100),
    @DateOfBirth DATE,
    @EmergencyContactNumber NVARCHAR(20)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        IF EXISTS (SELECT 1 FROM Reservation WHERE PassengerID = @PassengerID)
        BEGIN
            UPDATE Passenger
            SET FirstName = @FirstName,
                LastName = @LastName,
                Email = @Email,
                DateOfBirth = @DateOfBirth,
                EmergencyContactNumber = @EmergencyContactNumber
            WHERE PassengerID = @PassengerID;
            COMMIT TRANSACTION;
        END
        ELSE
        BEGIN
            ROLLBACK TRANSACTION;
            PRINT 'No update performed. Passenger has no reservation.';
        END
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
    END CATCH
END;


-- View to Show E-Boarding Numbers.
CREATE OR ALTER VIEW View_EmployeeRevenuePerFlight AS
SELECT
    E.EmployeeID,
    E.Name AS EmployeeName,
    F.FlightID,
    F.FlightNumber,
    T.TicketID,
    T.EboardingNumber,
    Fr.BasePrice AS FareBase,
    ISNULL(SUM(B.Cost), 0) AS BaggageFees,
    CASE WHEN R.MealUpgradeChoice = 1 THEN Fr.MealUpgradeFee ELSE 0 END AS MealUpgradeFee,
    CASE WHEN Fr.SeatSelectionFee > 0 THEN Fr.SeatSelectionFee ELSE 0 END AS SeatSelectionFee,
    Fr.BasePrice + ISNULL(SUM(B.Cost), 0) 
      + CASE WHEN R.MealUpgradeChoice = 1 THEN Fr.MealUpgradeFee ELSE 0 END 
      + Fr.SeatSelectionFee AS TotalRevenue
FROM Ticket T
JOIN Employee E ON T.EmployeeID = E.EmployeeID
JOIN Reservation R ON T.ReservationID = R.ReservationID
JOIN Flight F ON R.FlightID = F.FlightID
JOIN Fare Fr ON R.FareID = Fr.FareID
LEFT JOIN Baggage B ON R.ReservationID = B.ReservationID
GROUP BY
    E.EmployeeID, E.Name, F.FlightID, F.FlightNumber, T.TicketID, T.EboardingNumber,
    Fr.BasePrice, R.MealUpgradeChoice, Fr.MealUpgradeFee, Fr.SeatSelectionFee;


-- Trigger to Update Seat Status when Ticket is Issued.
CREATE OR ALTER TRIGGER trg_UpdateSeatStatus_AfterTicketInsert
ON Ticket
AFTER INSERT
AS
BEGIN
    UPDATE FlightSeat
    SET Status = 'Reserved'
    WHERE FlightSeat.FlightSeatID IN (
        SELECT Reservation.FlightSeatID
        FROM inserted
        INNER JOIN Reservation ON inserted.ReservationID = Reservation.ReservationID
        WHERE Reservation.FlightSeatID IS NOT NULL
    );
END;


-- User-Defined Function to Count Checked-In Baggage.
CREATE FUNCTION dbo.ufn_CountCheckedInBaggage
(
    @FlightID INT,
    @DepartureDate DATE
)
RETURNS INT
AS
BEGIN
    DECLARE @BaggageCount INT;
    SELECT @BaggageCount = COUNT(*)
    FROM Baggage B
    JOIN Reservation R ON B.ReservationID = R.ReservationID
    JOIN Flight F ON R.FlightID = F.FlightID
    WHERE B.Status = 'Checked-In'
      AND F.FlightID = @FlightID
      AND CAST(F.DepartureTime AS DATE) = @DepartureDate;
    RETURN @BaggageCount;
END;

-- Stored Procedure to Reserve a seat for a reservation
CREATE OR ALTER PROCEDURE ReserveSeatForReservation
    @ReservationID INT,
    @SeatID INT
AS
BEGIN
    DECLARE @FlightID INT;
    DECLARE @FlightSeatID INT;
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
        BEGIN TRANSACTION;
        SELECT @FlightID = FlightID FROM Reservation WHERE ReservationID = @ReservationID;
        SELECT @FlightSeatID = FlightSeatID
        FROM FlightSeat WITH (UPDLOCK, HOLDLOCK)
        WHERE FlightID = @FlightID AND SeatID = @SeatID AND Status = 'Available';
        IF @FlightSeatID IS NULL
        BEGIN
            RAISERROR('The selected seat is either not available or does not exist for this flight.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        UPDATE FlightSeat SET Status = 'Reserved', ReservationID = @ReservationID WHERE FlightSeatID = @FlightSeatID;
        UPDATE Reservation SET FlightSeatID = @FlightSeatID WHERE ReservationID = @ReservationID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
    END CATCH
END;



-- Stored Procedure to Create reservations with optional seat selection
CREATE OR ALTER PROCEDURE CreateReservationWithOptionalSeat
    @PassengerID INT,
    @FlightID INT,
    @FareID INT,
    @MealPreference NVARCHAR(30),
    @MealUpgradeChoice BIT,
    @SeatID INT = NULL
AS
BEGIN
    DECLARE @PNR NVARCHAR(10) = 'PNR' + RIGHT(CAST(DATEPART(SECOND, SYSDATETIME()) AS VARCHAR) + 
        CAST(DATEPART(MILLISECOND, SYSDATETIME()) AS VARCHAR) + CAST(@PassengerID AS VARCHAR), 7);
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
        BEGIN TRANSACTION;
        DECLARE @ReservationID INT;
        INSERT INTO Reservation (BookingDate, Status, PNR, MealUpgradeChoice, MealPreference,
                                 PassengerID, FlightID, FareID, FlightSeatID)
        VALUES (CAST(GETDATE() AS DATE), 'Pending', @PNR, @MealUpgradeChoice, @MealPreference,
                @PassengerID, @FlightID, @FareID, NULL);
        SET @ReservationID = SCOPE_IDENTITY();
        IF @SeatID IS NOT NULL
            EXEC ReserveSeatForReservation @ReservationID, @SeatID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
    END CATCH
END;


-- Stored Procedure to Issue a Ticket.
CREATE PROCEDURE IssueTicket
    @ReservationID INT,
    @EmployeeID INT
AS
BEGIN
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
        BEGIN TRANSACTION;
        IF EXISTS (SELECT 1 FROM Ticket WHERE ReservationID = @ReservationID)
        BEGIN
            RAISERROR('Ticket has already been issued for this reservation.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        DECLARE @EboardingNumber NVARCHAR(30);
        SET @EboardingNumber = 'EBD' + CAST(DATEPART(SECOND, SYSDATETIME()) AS NVARCHAR) + 
                               CAST(DATEPART(MILLISECOND, SYSDATETIME()) AS NVARCHAR) +
                               CAST(@ReservationID AS NVARCHAR);
        UPDATE Reservation SET Status = 'Confirmed' WHERE ReservationID = @ReservationID AND Status != 'Confirmed';
        INSERT INTO Ticket (IssueDate, EboardingNumber, ReservationID, EmployeeID)
        VALUES (CAST(GETDATE() AS DATE), @EboardingNumber, @ReservationID, @EmployeeID);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
    END CATCH
END;

-- DATABASE BACKUP
USE master;
GO
BACKUP DATABASE AirlineTicketingDB
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\AirlineTicketingDB.bak'
WITH FORMAT, NAME = 'Full Backup of AirlineTicketingDB';
