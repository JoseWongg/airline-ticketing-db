-- Schema: database + tables + FKs
CREATE DATABASE AirlineTicketingDB;
GO

-- Switch to the context of the new database
USE AirlineTicketingDB;
GO
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
