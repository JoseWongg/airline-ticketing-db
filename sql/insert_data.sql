-- Sample data inserts and junction updates
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
