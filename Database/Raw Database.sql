create database medpack;
use medpack;




create table pacjent(
	idPacjenta int not null auto_increment ,
	imie varchar(64),
	nazwisko varchar(64),
	pesel int(11),
	telefon varchar(12),
	eMail varchar(64),
	adres varchar(64),
	plec varchar(32),
	primary key(idPacjenta),
	unique key(pesel),
	unique key(email),
	unique key(telefon)
)engine = InnoDB;

create table raportyPielegniarskie(
	idRaportyPielegniarskie int auto_increment,
	primary key(idRaportyPielegniarskie),
	idPacjenta int,
	idPielegniarki int,
	data date,
	zawartosc text,
	index(idPacjenta),
	foreign key(idPacjenta) references pacjent(idPacjenta)
)engine = InnoDB;



create table kontaPacjentow(
	idKontaPacjentow int auto_increment,
	primary key(idKontaPacjentow),
	login varchar(32),
	haslo varchar(32),
	idPacjenta int not null,
	
	index(idPacjenta),
	unique key(login),

	foreign key(idPacjenta) references pacjent(idPacjenta)
)engine = InnoDB;



create table danePracownikow(
	idDanePracownikow int auto_increment,
	primary key(idDanePracownikow),
	imie varchar(64),
	nazwisko varchar(64),
	specjalizacja varchar(32),
	pesel int(11),
	unique key(pesel)
)engine = InnoDB;



create table kontaPracownikow(
	idKontaPracownikow int auto_increment,
	primary key(idKontaPracownikow),
	login varchar(32),
	haslo varchar(32),
	uprawnienia varchar(32),
	idDanePracownikow int not null,
	index(idDanePracownikow),
	unique key(login),
	foreign key(idDanePracownikow) references danePracownikow(idDanePracownikow)
)engine = InnoDB;

 create table przyjecia(
	idPrzyjecia int auto_increment not null,
	primary key(idPrzyjecia),
	wywiad text,
	badanieFizykalne text,
	HistoriaChorobWRodzinie text,
	idLekarza int not null,
	idPacjenta int not null,
	data date,

	index(idLekarza),
	index(idPacjenta),
	
	foreign key(idLekarza) references danePracownikow(idDanePracownikow),
	foreign key(idPacjenta) references pacjent(idPacjenta)
	
)engine = InnoDB;





create table recepty(
	idRecepty int auto_increment,
	primary key(idRecepty),
	idLekarza int,
	idPacjenta int,
	data date,
	leki text,
	numerRecepty int,

	index(idLekarza),
	index(idPacjenta),
	unique key(numerRecepty),
	foreign key(idLekarza) references danePracownikow(idDanePracownikow),
	foreign key(idPacjenta) references pacjent(idPacjenta)
	
)engine = InnoDB;

create table skierowania(
	idSkierowania int auto_increment,
	primary key(idSkierowania),
	idLekarza int,
	idPacjenta int,
	data date,
	numer int,
	typSpecjalisty text,
	rozpoznanie text,
	
	index(idLekarza),
	index(idPacjenta),
	
	foreign key(idLekarza) references danePracownikow(idDanePracownikow),
	foreign key(idPacjenta) references pacjent(idPacjenta)
)engine = InnoDB;

create table zwolnienia(
	idZwolnienia int auto_increment,
	primary key(idZwolnienia),
	idLekarza int,
	idPacjenta int,
	dataWystawienie date,
	okres date,
	numerZwolnienia int,
	powodZwolnienia text,

	index(idLekarza),
	index(idPacjenta),
	unique key(numerZwolnienia),
	foreign key(idLekarza) references danePracownikow(idDanePracownikow),
	foreign key(idPacjenta) references pacjent(idPacjenta)
)engine = InnoDB;

create table zabiegi(
	idZabiegi int auto_increment not null,
	primary key(idZabiegi),
	idLekarza int not null,
	idPacjenta int not null,
	data date,
	typZabiegu text,
	index(idZabiegi),
	index(idLekarza),
	index(idPacjenta),
	
	foreign key(idLekarza) references danePracownikow(idDanePracownikow),
	foreign key(idPacjenta) references pacjent(idPacjenta)

) engine = InnoDB;





create table przebiegLeczenia(
	idprzebiegLeczenia int auto_increment not null,
	primary key(idprzebiegLeczenia),
	
	leki text,
	
	idZwolnienia int not null,
	idRecepty int not null,
	idSkierowania int not null,
	idZabieg int not null,

	index(idSkierowania),
	index(idZabieg),
	index(idZwolnienia),
	index(idRecepty),
	
	foreign key(idSkierowania) references skierowania(idSkierowania),
	foreign key(idZabieg) references zabiegi(idZabiegi),
	foreign key(idZwolnienia) references zwolnienia(idZwolnienia),
	foreign key(idRecepty) references recepty(idRecepty)

)engine = InnoDB;

create table HistoriaLeczeniaPacjenta(
	idHistoriaLeczeniaPacjenta int auto_increment not null,
	dataWpisu date,

	idLekarza int not null,
	idPacjenta int not null,
	idPrzyjecia int not null,
	idPrzebiegLeczenia int not null,

	index(idHistoriaLeczeniaPacjenta),
	index(idLekarza),
	index(idPacjenta),
	index(idPrzyjecia),
	index(idPrzebiegLeczenia),
	
	primary key(idHistoriaLeczeniaPacjenta),
	
	foreign key(idLekarza) references danePracownikow(idDanePracownikow),
	foreign key(idPacjenta) references pacjent(idPacjenta),
	foreign key(idPrzyjecia) references przyjecia(idPrzyjecia),
	foreign key(idPrzebiegLeczenia) references przebiegLeczenia(idPrzebiegLeczenia)
)engine = InnoDB;

create table wizyta(
	idWizyta int auto_increment not null,	
	data date,
	godzina datetime,
	czasWizyty time,
	
	idLekarza int,
	idPacjenta int not null,
	idHistoriaLeczeniaPacjenta int not null,
	idRaportyPielegniarki int not null,
	
	primary key(idWizyta),
	
	index(idPacjenta),
	index(idHistoriaLeczeniaPacjenta),	
	index(idRaportyPielegniarki),
	
	foreign key(idPacjenta) references pacjent(idPacjenta),
	foreign key(idHistoriaLeczeniaPacjenta) references HistoriaLeczeniaPacjenta(idHistoriaLeczeniaPacjenta),
	foreign key(idRaportyPielegniarki) references raportyPielegniarskie(idRaportyPielegniarskie)

)engine = InnoDB;