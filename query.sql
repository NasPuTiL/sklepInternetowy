CREATE VIEW dbo.workers_view as
select
u.numer_umowy  , u.tresc_umowy , u.rodzaj_umowy , u.data_rozpoczêcia , u.data_zakonczenia , aneks.numer_aneksu , aneks.data_wejscia_w_zycie , aneks.opis_zmiany_stanowiska , 
pr.id_pracownika , pr.imie , pr.nazwisko , pr.p³ec , pr.adres , pr.data_rozpoczêcia_pracy , skl.nip_firmy as "NIP Sklepu" , skl.adres as "Adres sklepu" 
FROM umowa u 
left join aneks_do_umowy aneks on aneks.umowa_numer_umowy = u.numer_umowy 
left join sklep skl on u.sklep_nip_firmy = skl.nip_firmy 
left join pracownik pr on u.pracownik_id_pracownika = pr.id_pracownika ;


CREATE VIEW dbo.purchase_List as
select k.numer_klienta, k.nazwa_klienta , pf.klient_numer_klienta , pf.numer_paragonu_faktury, pf.dane_sklepu , pf.suma_do_zaplaty , pf.pracownik_id_pracownika , pf.data_sprzedazy ,
st.ilosc_towaru , tw.id_towaru , tw.nazwa , tw.cena , tw.lokalizacja_w_magazynie 
from klient k 
left join paragon_faktura pf on k.numer_klienta = pf.klient_numer_klienta 
left join szczegoly_transakcji st on pf.numer_paragonu_faktury = st.numer_paragonu_faktury 
left join towar tw on st.towar_id_towaru = tw.id_towaru 
where pf.numer_paragonu_faktury is not null;


select
count(*), u.rodzaj_umowy 
FROM umowa u 
left join aneks_do_umowy aneks on aneks.umowa_numer_umowy = u.numer_umowy 
left join sklep skl on u.sklep_nip_firmy = skl.nip_firmy 
left join pracownik pr on u.pracownik_id_pracownika = pr.id_pracownika 
group by u.rodzaj_umowy ORDER BY COUNT(*) DESC;

select kategoria as "nazwa Kategorii", AVG(cena) as "Cena œrednia dla danej kategorii", (SELECT AVG(cena) from towar t ) as "Cena œrednia dla wszystkich towarów" 
from towar t2  
group by kategoria HAVING (AVG(cena ) > (SELECT AVG(cena) from towar t ));

select kategoria as "nazwa Kategorii", AVG(cena) as "Cena œrednia dla danej kategorii", (SELECT AVG(cena) from towar t ) as "Cena œrednia dla wszystkich towarów" 
from towar t2  
group by kategoria HAVING (AVG(cena ) < (SELECT AVG(cena) from towar t ));



              




              