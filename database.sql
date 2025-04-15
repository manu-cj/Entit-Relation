DROP TABLE IF EXISTS Paiements, Réservations, Voyages, Hébergements, Transports, Clients, Contacts;

CREATE TABLE IF NOT EXISTS Contacts (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    phone_number VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Clients (
    id INT PRIMARY KEY,
    lastname VARCHAR(255),
    firstname VARCHAR(255),
    numero_de_compte VARCHAR(255) UNIQUE
);

CREATE TABLE IF NOT EXISTS Hébergements (
    id INT PRIMARY KEY,
    category VARCHAR(255),
    city VARCHAR(255),
    country VARCHAR(255),
    contact_fk INT,
    FOREIGN KEY (contact_fk) REFERENCES Contacts(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Transports (
    id INT PRIMARY KEY,
    type VARCHAR(255),
    company VARCHAR(255),
    nom VARCHAR(255),
    nbr_places INT
);

CREATE TABLE IF NOT EXISTS Voyages (
    id INT PRIMARY KEY,
    destination VARCHAR(255),
    nbr_places INT,
    host_fk INT,
    transport_fk INT,
    FOREIGN KEY (host_fk) REFERENCES Hébergements(id) ON DELETE CASCADE,
    FOREIGN KEY (transport_fk) REFERENCES Transports(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Réservations (
    id INT PRIMARY KEY,
    status VARCHAR(255),
    date DATE,
    voyage_fk INT,
    montant FLOAT,
    client_fk INT,
    FOREIGN KEY (voyage_fk) REFERENCES Voyages(id) ON DELETE CASCADE,
    FOREIGN KEY (client_fk) REFERENCES Clients(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Paiements (
    id INT PRIMARY KEY,
    paiement_mode VARCHAR(255),
    reservation_fk INT,
    numero_de_compte_fk VARCHAR(255),
    FOREIGN KEY (reservation_fk) REFERENCES Réservations(id) ON DELETE CASCADE,
    FOREIGN KEY (numero_de_compte_fk) REFERENCES Clients(numero_de_compte) ON DELETE CASCADE
);


-- Insérer les clients
INSERT INTO Clients (id, lastname, firstname, numero_de_compte) VALUES
(1, 'Cj', 'Manu', '123456789'),
(2, 'Cranston', 'Bryan', '987654321'),
(3, 'Smith', 'John', '111222333'),
(4, 'Doe', 'Jane', '444555666'),
(5, 'Brown', 'Charlie', '777888999'),
(6, 'Taylor', 'Chris', '000111222');

-- Insérer les contacts
INSERT INTO Contacts (id, name, phone_number) VALUES
(1, 'Jésus Christ', '123-456-7890'),
(2, 'Tony Stark', '987-654-3210'),
(3, 'Bruce Wayne', '111-222-3333'),
(4, 'Clark Kent', '444-555-6666'),
(5, 'Diana Prince', '777-888-9999'),
(6, 'Peter Parker', '000-111-2222');

-- Insérer les hébergements
INSERT INTO Hébergements (id, category, city, country, contact_fk) VALUES
(1, 'Hotel', 'Paris', 'France', 1),
(2, 'Hotel', 'Berlin', 'Germany', 2),
(3, 'Hostel', 'Rome', 'Italy', 3),
(4, 'Resort', 'Madrid', 'Spain', 4),
(5, 'Apartment', 'Lisbon', 'Portugal', 5),
(6, 'Villa', 'Athens', 'Greece', 6);

-- Insérer les transports
INSERT INTO Transports (id, type, company, nom, nbr_places) VALUES
(1, 'Bus', 'Travel', 'Incomfort Bus', 50),
(2, 'Plane', 'AirDrop', 'Jet', 180),
(3, 'Train', 'Railway Express', 'Express Train', 300),
(4, 'Boat', 'SeaTravel', 'Luxury Cruise', 100),
(5, 'Car', 'DriveNow', 'Sedan', 4),
(6, 'Helicopter', 'SkyHigh', 'Chopper', 6);

-- Insérer les voyages
INSERT INTO Voyages (id, destination, nbr_places, host_fk, transport_fk) VALUES
(1, 'Paris', 20, 1, 1),
(2, 'Berlin', 15, 2, 2),
(3, 'Rome', 10, 3, 3),
(4, 'Madrid', 25, 4, 4),
(5, 'Lisbon', 30, 5, 5),
(6, 'Athens', 12, 6, 6);

-- Insérer les réservations
INSERT INTO Réservations (id, status, date, voyage_fk, montant, client_fk) VALUES
(1, 'Confirmed', '2025-05-01', 1, 500.00, 1),
(2, 'Pending', '2025-05-05', 2, 300.00, 2),
(3, 'Cancelled', '2025-06-10', 3, 400.00, 3),
(4, 'Confirmed', '2025-07-15', 4, 600.00, 4),
(5, 'Pending', '2025-08-20', 5, 700.00, 5),
(6, 'Confirmed', '2025-09-25', 6, 800.00, 6);

-- Insérer les paiements
INSERT INTO Paiements (id, paiement_mode, reservation_fk, numero_de_compte_fk) VALUES
(1, 'Credit Card', 1, '123456789'),
(2, 'PayPal', 2, '987654321'),
(3, 'Bank Transfer', 3, '111222333'),
(4, 'Cash', 4, '444555666'),
(5, 'Debit Card', 5, '777888999'),
(6, 'Crypto', 6, '000111222');


-- Récupérer la liste des voyages avec leurs détails (prix, hébergement, transport).
SELECT v.destination, v.nbr_places,
       h.category AS hebergement,
       t.type AS transport,
       r.montant AS montant_reservation
FROM Voyages v
JOIN Hébergements h ON v.host_fk = h.id
JOIN Transports t ON v.transport_fk = t.id
JOIN Réservations r ON v.id = r.voyage_fk;

-- Afficher les réservations d’un client avec le statut du paiement.
SELECT c.lastname, c.firstname,
       r.status AS reservation_status,
       p.paiement_mode AS paiement_status
FROM Clients c
JOIN Réservations r ON c.id = r.client_fk
JOIN Paiements p ON r.id = p.reservation_fk
WHERE c.numero_de_compte = '123456789';

-- Lister les moyens de transport disponibles pour une destination donnée.
SELECT v.destination, t.type AS transport
FROM Voyages v
JOIN Transports t ON v.transport_fk = t.id
WHERE v.destination = 'Paris';

-- Consulter les informations d’une entreprise et ses services associés.
SELECT t.company,
       t.type AS transport_type,
       h.category AS hebergement_category
FROM Transports t
LEFT JOIN Voyages v ON t.id = v.transport_fk
LEFT JOIN Hébergements h ON v.host_fk = h.id
WHERE t.company = 'Travel';

-- Modifier les informations d’un client (nom, prénom, etc.).
UPDATE Clients
SET lastname = 'Morris', firstname = 'son'
WHERE id = 3;

-- Mettre à jour le statut d’une réservation (confirmée, annulée, en attente).
UPDATE Réservations SET status = 'Confirmed' WHERE id = 2;
UPDATE Réservations SET status = 'Pending' WHERE id = 3;
UPDATE Réservations SET status = 'Cancelled' WHERE id = 4;

-- Changer les détails d’un voyage (prix, nombre de places disponibles).
UPDATE Voyages SET nbr_places = 25, destination = 'Budapest' WHERE id = 1;
UPDATE Réservations SET montant = 550.00 WHERE voyage_fk = 1;

-- Supprimer une réservation (avec gestion des contraintes de suppression en cascade si nécessaire).
DELETE FROM Réservations WHERE client_fk = 5;
DELETE FROM Clients WHERE id = 5;

-- Effacer un mode de paiement non utilisé.
DELETE FROM Paiements WHERE reservation_fk IS NULL;

-- Retirer un transport qui n’est plus disponible.
DELETE FROM Transports WHERE id = 5 AND NOT EXISTS (
    SELECT 1 FROM Voyages WHERE transport_fk = 5
);


/*
Exercice 1 : Afficher toutes les sociétés qui proposent des avions (Plane)
📌 Objectif : Trouver les entreprises (company) qui ont au moins un transport de type Avion.
*/
SELECT DISTINCT company FROM Transports WHERE type = 'Plane';
/*
Exercice 2 : Lister les transports avec leur société
📌 Objectif : Afficher tous les transports (transport), en affichant le nom de la société correspondante.
*/
SELECT company FROM Transports;
/*
 Exercice 3 : Trouver les transports ayant plus de 200 places
📌 Objectif : Afficher tous les transports qui ont plus de 200 places (TotalSeats).
*/
SELECT * FROM Transports WHERE nbr_places > 200;
/*
Exercice 4 : Afficher les hébergements et leur type de contact principal
📌 Objectif : Associer les hébergements (hebergement) avec le type de contact principal
*/
SELECT h.category AS hebergement, c.name AS contact
FROM Hébergements h
JOIN Contacts c ON h.contact_fk = c.id;
/* 
Exercice 5 : Trouver les contacts des hébergements en Italie
📌 Objectif : Afficher les contacts (contact) associés à un hébergement situé en Italie).
*/
SELECT c.name AS contact
FROM Hébergements h
JOIN Contacts c ON h.contact_fk = c.id
WHERE h.country = 'Italy';
/* 
Exercice 6 : Créer un voyage en Belgique (3 jours à Plopsaland) avec un nombre limité de 50 places.
📌 Objectif : Créer un voyage en Belgique, Trouver le moyen de transport, l'herbergement et le contact.
*/
INSERT INTO Voyages (id, destination, nbr_places, host_fk, transport_fk)
VALUES (7, 'Belgium', 50, 1, 1);
INSERT INTO Hébergements (id, category, city, country, contact_fk)
VALUES (7, 'Hotel', 'Plopsaland', 'Belgium', 1);
INSERT INTO Transports (id, type, company, nom, nbr_places)
VALUES (7, 'Bus', 'Travel', 'Incomfort Bus', 50);
/* 
Exercice 7 : Ajouter un client à ce voyage
📌 Objectif : Ajouter plusieurs clients, payment ....
*/
INSERT INTO Clients (id, lastname, firstname, numero_de_compte)
VALUES (7, 'Db', 'Maria', '123736189'),
(8, 'Db', 'Mongo', '487664371');
INSERT INTO Réservations (id, status, date, voyage_fk, montant, client_fk)
VALUES (7, 'Confirmed', '2025-10-01', 7, 500.00, 7),
(8, 'Pending', '2025-10-05', 7, 300.00, 8);
INSERT INTO Paiements (id, paiement_mode, reservation_fk, numero_de_compte_fk)
VALUES (7, 'Credit Card', 7, '123736189'),
(8, 'PayPal', 8, '487664371');
/*
