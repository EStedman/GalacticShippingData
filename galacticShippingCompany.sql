SPOOL galactic_shipping_co.out
set echo on
--
--	By: Eldon Hoolsema, Curt Brink, Evan Stedman, and Lucy Holland
--
-- ---------------------------------------------------------------
--
-- Ship Table: contains non techinical information about a ship
-- ID: unique id number, like an employee ssn
-- name: duh
-- age: age of vessel (commented out b/c unsure if we'll use / how to make work since it's a derived value)
-- model: model of the ship - ties it to the M.M.C table which contains technical information
-- capt: man in charge of the vessel
-- homeport: which port the vessel claims as its home (indirectly ties it to a home planet too)
-- division: which part of our company the ship is assigned to
--
create table Ship
(
	s_ID 	integer not null,
	s_name 	varchar not null,
	--s_age	integer not null,
	s_model	varchar not null,
	s_capt	varchar not null,
	s_homeport	varchar not null,
	s_division integer not null,
	
	constraint SHIPKEY primary key(shipID),
	constraint SHIPIC1 foreign key(s_model) references MakeAndModel(model),
	constraint SHIPIC2 foreign key(s_division) references Division(div_ID)
	constraint SHIPIC3 foreign key(s_homeport) references Port(pt_name)
);
--
-- Make and Model Table: more technical information about the different ships (sort of similar to car models)
-- make: manufacturers in galaxy (think Ford)
-- model: different models a manufacture might have (partial key with make) (think Fusion)
-- cargo_cap: amount of cargo capacity (in metric tons) (think 5 people)
-- m_year: year that model was made	(think 2014)
-- m_class: type of ship it is (think Sedan) - one of five major types
-- m_class continued: frigate = armed and armoured transport; tanker = gas and liquid; container = finished goods; bulk = raw materials; passenger = duh	
--
-- this set up allows for more make / model combos than what we might use
create table MakeModelClass
(
	m_make 	varchar not null,
	m_model varchar not null,
	m_cargo_cap	integer not null,
	m_year	integer not null,
	m_class	varchar not null,
	
	constraint MANDMKEY primary key(make, model, cargo_cap, m_class),
	constraint MANDMIC1 check (m_year > 2015 AND m_year <= 2139),
	constraint MANDMIC2 check(m_class IN('Frigate','Tanker','Containter','Bulk','Passenger'))
);
--
-- Port Table: basic information about ports in our galaxy
-- name: duh / forms a partial key with planet so that a planet can have multiple ports
-- planet: which planet the port is on / near (tied to planet table)
-- docks: number of docking stations in this port
--
create table Port
(
	pt_name varchar not null,
	pt_planet varchar not null,
	pt_docks integer not null,
	
	constraint PORTKEY primary key(pt_name, pt_planet),
	constraint PORTIC1 foreign key(pt_planet) references Planet(pl_name),
	constraint PORTIC2 check(pt_docks > 0)
);
--
-- Planet Table: basic information about planets in our galaxy
-- name: duh (again)
-- size: size of our planet from one of three general options
-- pop: population that lives on this planet (possible to have no one living on the planet i.e. automated mining stations)
--
create table Planet
(
	pl_name varchar not null,
	pl_size char(6) not null,
	pl_pop integer not null,
	
	constraint PLANETKEY primary key(pl_name),
	constraint PLANETIC1 check(pl_size IN('small','medium','large')),
	constraint PLANETIC2 check(pl_pop >= 0)
);
--
-- Captain Table: basic information about our captains (should have more captains than ships so a few can manage the divisions)
-- ID: id number for our captains
-- name: duh
-- bday: duuuuuuuuh duh duh duh...DUUUUUUH
-- home: home planet
--
create table Captain
(
	c_ID	integer not null,
	c_name	varchar not null,
	c_bday 	date not null,
	c_home	varchar not null,
	--c_div integer not null, (I don't think we actually need this since the division is made up of ships, not captains)
	
	constraint CAPTKEY primary key(c_ID),
	constraint CAPTIC1 foreign key(c_home) references Planet(pl_name)
);
--
-- Division Table: divisions within our company (possibly split via cargo type, planets, etc.)
-- id: ID of the division
-- name: name of the division
-- manager: a captain not actively operating a ship (or maybe they are - it's possible - this set up allows it)
--
create table Division
(
	div_ID 	integer not null,
	div_name varchar not null,
	div_manager integer not null,
	
	constraint DIVKEY primary key(div_ID),
	constraint DIVIC1 foreign key(manager) references Captain(c_ID)
);
--
-- Cargo Table: cargo types and rarities
-- type: basic categories of cargo (which plays into which ships need to be used)
-- rarity: how rare a cargo is (think gold vs. dirt)
--
create table Cargo
(
	--cg_ID integer not null, (do we need this?)
	cg_type varchar not null, --is this not enough?
	cg_rarity varchar not null,
	
	constraint CARGOKEY primary key(cg_type),
	constraint CARGOIC1 check(cg_type IN('liquid','goods','passenger','foodstuffs','minerals','other')),
	constraint CARGOIC2 check(cg_rarity IN('trivial','common','unusual','rare','exotic'))
);
--
-- Cargo Certification Table: ties together which captains are certified to transport which cargoes
-- PLEASE DOUBLE CHECK THIS MULTIVALUE TABLE - CAN WE GAURENTEE THAT MODEL AND CLASS WILL MATCH FROM M.M.C.?
--
create table Cargo_Cert
(
	cc_model varchar not null, -- do we even need this?
	cc_class varchar not null,
	cc_type varchar not null,
	
	constraint CCKEY primary key(cc_model, cc_class, cc_type),
	constraint CCIC1 foreign key(cc_capt) references MakeModelClass(m_model),
	constraint CCIC2 foreign key(cc_class) references MakeModelClass(m_class),
	constraint CCIC3 foreign key(cc_type) references Cargo(cg_type)
);
--
-- Captain Certification: ties together which captain certified to operate which model/class of ships
-- PLEASE DOUBLE CHECK THIS MULTIVALUE TABLE - CAN WE GAURENTEE THAT MODEL AND CLASS WILL MATCH FROM M.M.C.?
--
create table Capt_Cert
(
	kc_model varchar not null, -- do we even need this?
	kc_class varchar not null,
	kc_capt integer not null,
	
	constraint KCKEY primary key(kc_model, kc_class, kc_capt),
	constraint KCIC1 foreign key(kc_model) references MakeModelClass(m_model),
	constraint KCIC2 foreign key(kc_class) references MakeModelClass(m_class),
	constraint KCIC3 foreign key(kc_capt) references Captain(c_ID)
);
--
-- Job Table: a sizeable list of jobs completed / in progress
-- shipID: which ship is being used (CAN WE ENSURE TECHNICALS FROM M.M.C. WILL "CARRY OVER" FOR CARGO?)
-- captID: which captain that will be used
-- cargo_type: what kind of cargo will be used
-- cargo_name: name of cargo (melted butter)
-- cargo_amount: how much of the cargo is being moved in metric tons
-- source: where it's coming from...
-- destination: ...and where it's going (port wise)
-- date_sent: can be in the future to represent a shipment not yet sent out; STATUS WILL MATCH
-- date_arrived: can be null to indicate a shipment has yet to arrived; STATUS WILL MATCH
-- status: status on a shipment (queued, in transit, or arrived)
-- price: how many dolla dolla bills we we made / will make on this job
--
create table Job
(
	shipID integer not null, -- identifying key
	captID integer not null, -- identifying key
	cargo_type varchar not null, -- identifying key
	cargo_name varchar not null,
	cargo_amount integer not null,
	source varchar not null, -- identifying key
	destination varchar not null, -- identifying key
	date_sent date not null, -- WEAK KEY
	date_arrived date,
	status varchar not null,
	price integer not null,
	
	constraint JOBKEY primary key(date_sent, shipID, captID, source, destination, cargo_type),
	constraint JOBFKEY1 foreign key(shipID) references Ship(s_ID),
	constraint JOBFKEY2 foreign key(captID) references Captain(c_ID),
	constraint JOBFKEY3 foreign key(source) references Port(pt_name),
	constraint JOBFKEY4 foreign key(destination) references Port(pt_name),
	constraint JOBFKEY5 foreign key(cargo_type) references Cargo(cg_type),
	constraint JOBIC1 check(status IN('QUEUED','IN TRANSIT','ARRIVED')),
	constraint JOBIC2 check(NOT(source = destination))
);
--
set feedback off
--
-- ------------------------------------------------------------------------
--
-- Populate MakeModelClass since things references it
insert MakeModelClass();
--
commit
spool off