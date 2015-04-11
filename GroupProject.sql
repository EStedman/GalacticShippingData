--https://github.com/ShinigamiRogue/GalacticShippingData.git
/* Hopefully we'll be able to just copy - paste this into an .sql file on the EOS machines, or something. I mean, I don't see why we can't.
ALSO! I did not finish all of it! Constraints and foreign keys still needed!
*/

SPOOL galatic_shipping.out
SET ECHO ON
/*
CIS 353 - Database Design Project
Chief Financial Officer Curt Brink
Chief Executive Officer Lucy Holland
Chief Operations Officer Eldon Hoolsema
Chief Business Officer Evan Stedman
*/
-- Dropping tables
DROP TABLE Ship CASCADE CONSTRAINTS;
DROP TABLE Planet CASCADE CONSTRAINTS;
DROP TABLE Port CASCADE CONSTRAINTS;
DROP TABLE Captain CASCADE CONSTRAINTS;
DROP TABLE Division CASCADE CONSTRAINTS;
DROP TABLE Division_Fleet CASCADE CONSTRAINTS;
DROP TABLE Cargo CASCADE CONSTRAINTS;
DROP TABLE Cargo_Certification CASCADE CONSTRAINTS;
DROP TABLE Capt_Certification CASCADE CONSTRAINTS;
DROP TABLE Job CASCADE CONSTRAINTS;
--
CREATE TABLE Ship
(	
shipID		INTEGER	NOT NULL,
	sname		CHAR(30)	NOT NULL,
ship_class	CHAR(15)	NOT NULL,	
cargo_cap	INTEGER	NOT NULL,
	home_port	CHAR(20)	NOT NULL,
	divID		INTEGER	NOT NULL,
	date_added_fleet	INTEGER	NOT NULL,

CONSTRAINT SHIPIC6 CHECK (ship_class IN ('Frigate', 'Tanker', 'Passenger', 'Container')),
CONSTRAINT SHIPKEY PRIMARY KEY(shipID)
);
--
--
--
--
CREATE TABLE MAKEMODEL
(
	make		CHAR(20)	NOT NULL,
	model		CHAR(20)	NOT NULL,
	shipID		INTEGER	NOT NULL,
	year		INTEGER	NOT NULL,

CONSTRAINT MANDMKEY PRIMARY KEY(make, model, shipID),
CONSTRAINT MANDMIC1 FOREIGN KEY (shipID) REFERENCES SHIP(shipID),
CONSTRAINT SHIPIC4 CHECK(model IN ('Titan','Stryder','Atlas','Halkyone','Alfbern','Zaikyd','Hydra','Gordon','Prospekt')),
CONSTRAINT SHIPIC5 CHECK(make IN ('HMI Industries','Black Mesa Engineering','The Bushwhacka Group'))
);
--
CREATE TABLE PLANET
(
	planetID	CHAR(20) 	NOT NULL,
	pSize		CHAR(6)	NOT NULL,
	population 	INTEGER,

	CONSTRAINT PLANETKEY PRIMARY KEY(planetID),
	CONSTRAINT PLANETIC1 CHECK (pSize IN('small','medium','large')),
	CONSTRAINT PLANETIC2 CHECK (population > 0)
);
--
CREATE TABLE PORT
(
	portID 		INTEGER	NOT NULL,
	pname		CHAR(20),
	planetID	CHAR(20)	NOT NULL,
	num_of_docks INTEGER	NOT NULL,

	CONSTRAINT PORTKEY PRIMARY KEY(portID),
	CONSTRAINT PORTIC1 UNIQUE (planetID)
);
--
CREATE TABLE CAPTAIN
(
	captID		INTEGER	NOT NULL,
	capt_name	CHAR(20)	NOT NULL,
	bday		DATE,
home_planet	CHAR(20),
divID		CHAR(12)	NOT NULL,

	CONSTRAINT CAPTKEY PRIMARY KEY(captID),
CONSTRAINT CAPTIC1 UNIQUE (home_planet),
CONSTRAINT CAPTIC2 UNIQUE (divID),
CONSTRAINT CAPTIC3 FOREIGN KEY (home_planet) REFERENCES Planet(planetID)
);
--
CREATE TABLE DIVISION
(
	divID		INTEGER	NOT NULL,
	div_name	CHAR(12)	NOT NULL,
	manager	INTEGER	NOT NULL,

	CONSTRAINT DIVISIONKEY PRIMARY KEY(divID),
	CONSTRAINT DIVISIONIC1 FOREIGN KEY (manager) REFERENCES Captain(captID)
);
--
CREATE TABLE CARGO
(
	cargoID	INTEGER	NOT NULL,
ctype		CHAR(20)	NOT NULL,
	rarity		CHAR(10)	NOT NULL,

	CONSTRAINT CARGOKEY PRIMARY KEY(cargoID),
CONSTRAINT CARGOIC1 CHECK (ctype IN ('liquids','goods','passengers','foodstuffs','minerals','other')),
CONSTRAINT CARGOIC2 CHECK (rarity IN ('very common','common','unusual','rare','very rare'))
);
--
-- Different classes of ships can carry a some cargos but no others
-- I.E. Frigates can carry minerals, passengers, and goods but not liquids or foodstuffs
--
CREATE TABLE CARGO_CERTIFICATION
(
	shipType	CHAR(20)	NOT NULL,
	cargoType	CHAR(20)	NOT NULL,

CONSTRAINT CARGOCERTIC1 PRIMARY KEY (shipType, cargoType),
CONSTRAINT CARGOCERTIC2 FOREIGN KEY(shipType) REFERENCES SHIP(ship_class),
CONSTRAINT CARGOCERTIC3 FOREIGN KEY(cargoType) REFERENCES CARGO(ctype)
);
--
CREATE TABLE CAPT_CERTIFICATION
(
	captID		INTEGER	NOT NULL,
	class_cert	CHAR(12)	NOT NULL,

CONSTRAINT CAPTCERTIC1 PRIMARY KEY (captID, class_cert),
CONSTRAINT CAPTCERTIC2 FOREIGN KEY(captID) REFERENCES CAPTAIN(captID),
CONSTRAINT CAPTCERTIC3 CHECK (class_cert IN ('Frigate','Passenger','Tanker','Container'))
);
--
CREATE TABLE JOB
(
	date_sent	DATE		NOT NULL,
	shipID		INTEGER	NOT NULL,
	captID		INTEGER	NOT NULL,
	cargo_type	CHAR(20)	NOT NULL,
	cargo_name	CHAR(20)	NOT NULL,
source		INTEGER	NOT NULL,
destination	INTEGER	NOT NULL,
	tonnage	INTEGER	NOT NULL,
	date_arrived	DATE,
	status		CHAR(8),
	price		INTEGER	NOT NULL,

	CONSTRAINT JOBIC1 PRIMARY KEY(date_sent, shipID, captID, cargo_type, source, destination),
	CONSTRAINT JOBIC2 FOREIGN KEY (shipID) REFERENCES Ship(shipID),
	CONSTRAINT JOBIC3 FOREIGN KEY (captID) REFERENCES Captain(captID),
	CONSTRAINT JOBIC4 FOREIGN KEY (source) REFERENCES Port(portID),
	CONSTRAINT JOBIC5 FOREIGN KEY (destination) REFERENCES Port(portID),
	CONSTRAINT JOBIC6 CHECK (NOT(source = destination))
);
SET FEEDBACK OFF
--
-- Ships
--
INSERT INTO Ship VALUES (86753090,'Enterprise','Frigate','HMI Industries','Titan', 2135,100000, /*need PORT DIVISION ID and DATE ADDED TO FLEET*/);
--
INSERT INTO Ship VALUES (21121337,'Starman','Container','HMI Industries','Stryder',2112,125000, /*need PORT DIVISION ID and DATE*/);
--
INSERT INTO Ship VALUES (76194038,'Aurora Borealis','Frigate','Black Mesa Engineering','Gordon',2101, 75000,  /*PORT DIV ID DATE); 
--
INSERT INTO Ship VALUES (13377331,'Mesa','Container','Black Mesa Engineering','Prospekt',2098,98000, --need port/date);
--
INSERT INTO Ship VALUES (83057201,'North Star','Passenger','HMI Industries','Atlas',2109,25000,/*PORT DIV ID DATE);
--
INSERT INTO Ship VALUES (87654321,'Black Wolf','Frigate','The Bushwhacka Group','Halkyone',2087,95000,/*PORT DIV ID DATE);
--
INSERT INTO Ship VALUES (56789438,'Iron Crucible','Tanker','The Bushwhacka Group','Alfbern',2089,96000,/*PORT DIV ID DATE);
--
INSERT INTO Ship VALUES (89974982,'Tycho Resolute','Tanker','The Bushwhacka Group','Zaikyd',2087,100000,/*PORT DIV ID DATE);
--
INSERT INTO Ship VALUES (23453412,'Leviathan','Container','HMI Industries','Titan',2128,135000/*PORT DIV ID DATE);
--
INSERT INTO Ship VALUES (79145425,'Starbaru','Passenger','Black Mesa Engineering','Hydra',2120,25000,/*PORT DIV ID DATE);
--
INSERT INTO Ship VALUES (38548990,'Solar Wind','Passenger','HMI Industries','Titan',2119,30000,/*PORT DIV ID DATE);
--
INSERT INTO Ship VALUES (31264578,'Hyperion H','Tanker'','The Bushwhacka Group','Halkyone',2107,75000,/*PORT DIV ID DATE);
--
----Planets
--
INSERT INTO Planet VALUES('name', 'size', 'population');
--
----Ports
--
INSERT INTO Port VALUES();
--
----Captains
--
INSERT INTO Captain VALUES();
--
----Divisions
--
INSERT INTO Division VALUES();
--
----Cargo
--
INSERT INTO Cargo VALUES();
--
----Cargo Certifications
--
INSERT INTO Cargo_Certification VALUES();
--
----Captain Certifications
--
INSERT INTO Capt_Certification VALUES();
--
----Jobs
--
INSERT INTO Job VALUES();
SET FEEDBACK ON
COMMIT

-- Stuff!

COMMIT


SPOOL OFF

/*

*/
