-- Roles, permissions, logins, users
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
