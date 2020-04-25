create database sys_bazodanowe;
use sys_bazodanowe;


CREATE TABLE aneks_do_umowy (
    numer_aneksu            INTEGER NOT NULL,
    umowa_numer_umowy       INTEGER NOT NULL,
    data_wejscia_w_zycie    DATE,
    opis_zmiany_stanowiska  VARCHAR(100)
);

ALTER TABLE aneks_do_umowy ADD CONSTRAINT aneks_do_umowy_pk PRIMARY KEY ( numer_aneksu );

CREATE TABLE klient (
    numer_klienta  INTEGER NOT NULL,
    nazwa_klienta  VARCHAR(100)
);

ALTER TABLE klient ADD CONSTRAINT klient_pk PRIMARY KEY ( numer_klienta );

CREATE TABLE paragon_faktura (
    numer_paragonu_faktury   INTEGER NOT NULL,
    dane_sklepu              VARCHAR(100),
    suma_do_zaplaty          FLOAT(2),
    pracownik_id_pracownika  INTEGER NOT NULL,
    data_sprzedazy           DATE,
    klient_numer_klienta     INTEGER
);

ALTER TABLE paragon_faktura ADD CONSTRAINT paragon_faktura_pk PRIMARY KEY ( numer_paragonu_faktury );

CREATE TABLE pracownik (
    id_pracownika           INTEGER NOT NULL,
    imie                    VARCHAR(40),
    nazwisko                VARCHAR(40),
    p³ec                    CHAR(1),
    adres                   VARCHAR(100),
    data_rozpoczêcia_pracy  DATE
);

ALTER TABLE pracownik ADD CONSTRAINT pracownik_pk PRIMARY KEY ( id_pracownika );

CREATE TABLE sklep (
    nip_firmy         INTEGER NOT NULL,
    adres             VARCHAR(100),
    dane_wlasciciela  VARCHAR(100),
    opinie_klientow   VARCHAR(200)
);

ALTER TABLE sklep ADD CONSTRAINT sklep_pk PRIMARY KEY ( nip_firmy );

CREATE TABLE szczegoly_transakcji (
    towar_id_towaru         INTEGER NOT NULL,
    ilosc_towaru            INTEGER,
    numer_paragonu_faktury  INTEGER NOT NULL
);

CREATE TABLE towar (
    id_towaru                INTEGER NOT NULL,
    nazwa                    VARCHAR(100),
    opis                     VARCHAR(100),
    kategoria                VARCHAR(40),
    cena                     FLOAT(2),
    lokalizacja_w_magazynie  VARCHAR(100)
);

ALTER TABLE towar ADD CONSTRAINT towar_pk PRIMARY KEY ( id_towaru );

CREATE TABLE umowa (
    numer_umowy              INTEGER NOT NULL,
    tresc_umowy              VARCHAR(50),
    rodzaj_umowy             VARCHAR(50),
    data_rozpoczêcia         DATE,
    data_zakonczenia         DATE,
    pracownik_id_pracownika  INTEGER NOT NULL,
    sklep_nip_firmy          INTEGER NOT NULL
);

ALTER TABLE umowa ADD CONSTRAINT umowa_pk PRIMARY KEY ( numer_umowy );

ALTER TABLE aneks_do_umowy
    ADD CONSTRAINT aneks_do_umowy_umowa_fk FOREIGN KEY ( umowa_numer_umowy )
        REFERENCES umowa ( numer_umowy );

ALTER TABLE paragon_faktura
    ADD CONSTRAINT paragon_faktura_klient_fk FOREIGN KEY ( klient_numer_klienta )
        REFERENCES klient ( numer_klienta );

ALTER TABLE paragon_faktura
    ADD CONSTRAINT paragon_faktura_pracownik_fk FOREIGN KEY ( pracownik_id_pracownika )
        REFERENCES pracownik ( id_pracownika );

ALTER TABLE szczegoly_transakcji
    ADD CONSTRAINT szczegoly_transakcji_fk FOREIGN KEY ( numer_paragonu_faktury )
        REFERENCES paragon_faktura ( numer_paragonu_faktury );

ALTER TABLE szczegoly_transakcji
    ADD CONSTRAINT szczegoly_transakcji_towar_fk FOREIGN KEY ( towar_id_towaru )
        REFERENCES towar ( id_towaru );

ALTER TABLE umowa
    ADD CONSTRAINT umowa_pracownik_fk FOREIGN KEY ( pracownik_id_pracownika )
        REFERENCES pracownik ( id_pracownika );

ALTER TABLE umowa
    ADD CONSTRAINT umowa_sklep_fk FOREIGN KEY ( sklep_nip_firmy )
        REFERENCES sklep ( nip_firmy );


