-- Constraints (e.g., booking date not in the past)
ALTER TABLE Reservation WITH NOCHECK
ADD CONSTRAINT CHK_Reservation_BookingDate
CHECK (BookingDate >= CAST(GETDATE() AS DATE));
