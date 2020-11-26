start :- pytaj, !, stworz_dynamiczne, !, analiza, !.
       
/*  --------------------     PYTAJ     -------------------------------- */
       
pytaj :-  pytaj_o_plec, pytaj_o_wiek, pytaj_o_rodzaj_skory, pytaj_o_krem_przeciwsloneczny, pytaj_o_ilosc_kremow, pytaj_o_problemy_skorne.
         
         
pytaj_o_plec :- format('Podaj swoja plec.'), read(ODP_PLEC), asserta(plec(ODP_PLEC)).
kobieta :- plec(kobieta).
mezczyna :- plec(mezczyzna).


pytaj_o_wiek :- format('W jakim jestes wieku?'), read(ODP_WIKE), asserta(wiek(ODP_WIKE)).
nastolatek :- (wiek(N) , N < 20, N > 10).
mlody_dorosly :- (wiek(N) , N < 30, N > 19).
dorosly :- (wiek(N) , N < 50, N > 20).
dojrzaly :- (wiek(N) , N > 49).


pytaj_o_rodzaj_skory :- format('Jaki masz rodzaj skory? '), read(ODP_SKORA), asserta(skora(ODP_SKORA)).       
normalna_skora :- skora(normalna).
mieszana_skora :- skora(mieszana).
sucha_skora :- skora(sucha).
tlusta_skora :- skora(tlusta).


pytaj_o_krem_przeciwsloneczny :- format('Czy uzywasz kremu przeciwsłonecznego?'), read(ODP_KREM_SPF), asserta(krem_przeciwsloneczny(ODP_KREM_SPF)), 
                                 pytaj_o_wysokosc_filtru(ODP_KREM_SPF).       
                                
pytaj_o_wysokosc_filtru(nie) :- true.
pytaj_o_wysokosc_filtru(tak) :- format('Jak wysoki filtr stosujesz? Podaj faktor.'), read(ODP_FILTR), asserta(faktor(ODP_FILTR)).


pytaj_o_ilosc_kremow :- format('Ilu kremow uzwalas?'), read(ILOSC_KREMOW), pytaj_o_kremy(ILOSC_KREMOW).
pytaj_o_kremy(0) :- true.
pytaj_o_kremy(1) :- pytaj_o_krem.
pytaj_o_kremy(N) :- pytaj_o_krem, N1 is N-1, pytaj_o_kremy(N1).
pytaj_o_krem :- format('podaj nazwe kremu?'), read(NAZWA_KREMU), format('dzialal?'), read(CZY_DZIALAL), asserta(uzywany_krem(NAZWA_KREMU, CZY_DZIALAL)).


pytaj_o_problemy_skorne :- format('Czy masz jakies probemy skorne, ktore chcesz wyelminowac'), read(ODP_PROBLEMY), asserta(problemy(ODP_PROBLEMY)), 
                           dopytaj_o_problemy_skorne(ODP_PROBLEMY). 
                                                  
dopytaj_o_problemy_skorne(nie) :- true.
dopytaj_o_problemy_skorne(tak) :- pytaj_o_tradzik_jesli_natolatek_badz_mlody_dorosly. 

pytaj_o_tradzik_jesli_natolatek_badz_mlody_dorosly :- nastolatek, pytaj_o_tradzik.
pytaj_o_tradzik_jesli_natolatek_badz_mlody_dorosly :- mlody_dorosly, pytaj_o_tradzik.
pytaj_o_tradzik_jesli_natolatek_badz_mlody_dorosly :- true. 


pytaj_o_tradzik :- format('Czy zmagasz sie z tradzikiem?'), read(ODP_TRADZIK), asserta(tradzik(ODP_TRADZIK)), dopytaj_o_tradzik(ODP_TRADZIK).

dopytaj_o_tradzik(nie) :- true.
dopytaj_o_tradzik(tak) :- znajdz_podloze_tradziku, pytaj_o_substancje_do_walki_z_tradzikiem.

znajdz_podloze_tradziku :- pytaj_o_alergie, pytaj_o_problemy_hormonalne.

pytaj_o_alergie :- format('Czy masz stwierdzone  alergie?'), read(ODP_ALERGIE), asserta(stwierdzone_alergie(ODP_ALERGIE)), 
                   dopytaj_o_alergie(ODP_ALERGIE).
                   
dopytaj_o_alergie(tak) :- true.
dopytaj_o_alergie(nie) :- format('Czy odczuwasz czasem bol brzucha po posilku?'), read(ODP_PROBLEMY_GASTRYCZNE), 
                          asserta(mozliwe_problemy_gastryczne(ODP_PROBLEMY_GASTRYCZNE)).


pytaj_o_problemy_hormonalne :- format('Czy masz stwierdzone problemy hormonalne?'), read(ODP_HORMONY), asserta(problemy_hormonalne(ODP_HORMONY)),
                               dopytaj_o_hormony(ODP_HORMONY).
                               
dopytaj_o_hormony(tak) :- true.                      
dopytaj_o_hormony(nie) :- format('Czy masz hustawki nastroju albo nadmierne owlosienie?'), read(ODP_MOZLIWE_PR_HORMONALNE), 
                          asserta(mozliwe_problemy_hormonalne(ODP_MOZLIWE_PR_HORMONALNE)).

pytaj_o_substancje_do_walki_z_tradzikiem :- format('Czy uzywales nadlenku benzoilu?'), read(ODP_SUB1), asserta(nadlenek_benzoilu(ODP_SUB1)),
                                            format('Czy uzywales kwasu salicylowego?'), read(ODP_SUB2), asserta(kwas_salicylowy(ODP_SUB2)),
                                            format('Czy uzywales retonodiow?'), read(ODP_SUB4), asserta(retinoidy(ODP_SUB4)),
                                            format('Czy uzywales antybiotyk doustnych?'), read(ODP_SUB3), asserta(antybiotyki_doustne(ODP_SUB3)).


/*  --------------------     ANALIZA     -------------------------------- */
analiza :-  odpowiedz(X),
            format('~w', X),
            nl,
            fail.

/* zrezygnuj z substancji zapachowej jeśli krem ganier i dove się nie sprawdziły albo krem garnier nie sprawdził się, a dove był nie używany 
   albo dove się nie sprawdził a garnier był nie używany*/
zrezygnuj_z_substancji_zapachowych :- uzywany_krem(garnier, nie), not(uzywany_krem(dove, tak)), not(uzywany_krem(dove, nie)), !.
zrezygnuj_z_substancji_zapachowych :- uzywany_krem(dove, nie), not(uzywany_krem(garnier, tak)), not(uzywany_krem(garnier, nie)), !.
zrezygnuj_z_substancji_zapachowych :- uzywany_krem(dove, nie), uzywany_krem(garnier, nie).



/* poleć substancję z ceramidami, jeśli nieprawda, że krem physiogel i cera się sprawdziły
   albo krem cerave się sprawdził, a physiogel nie był używany
   albo krem physiogel się sprawdził, a cerve nie był używany
   albo oba kremy nie były używane. */
polecana_substancja(ceramidy, tak) :- uzywany_krem(physiogel, tak), uzywany_krem(cerave, tak), !.
polecana_substancja(ceramidy, tak) :- uzywany_krem(cerave, tak), not(uzywany_krem(physiogel, nie)), not(uzywany_krem(physiogel, tak)), !.
polecana_substancja(ceramidy, tak) :- uzywany_krem(physiogel, tak), not(uzywany_krem(cerave, nie)), not(uzywany_krem(cerave, tak)), !.
polecana_substancja(ceramidy, tak) :- not(uzywany_krem(physiogel, nie)), not(uzywany_krem(physiogel, tak)), 
                                      not(uzywany_krem(cerave, nie)), not(uzywany_krem(cerave, tak)).

/* proponuj retinol dla dojrzalych, badż dorosłych w celach odmłądzających */
polecana_substancja(retinol, tak) :- dorosly, !.
polecana_substancja(retinol, tak) :- dojrzaly.

/* poleć substacje do walki z trądzikiem. */
polecana_substancja(retinoidy, tak) :- retinoidy(nie).
polecana_substancja(nadlenek_benzoilu, tak) :- nadlenek_benzoilu(nie).
polecana_substancja(antybiotyki_doustne, tak) :- antybiotyki_doustne(nie).
polecana_substancja(kwas_salicylowy, tak) :- kwas_salicylowy(nie).

uzywana_substancja(retinoidy, tak) :- retinoidy(tak).
uzywana_substancja(nadlenek_benzoilu, tak) :- nadlenek_benzoilu(tak).
uzywana_substancja(kwas_salicylowy, tak) :- kwas_salicylowy(nie).
uzywana_substancja(antybiotyki_doustne, tak) :- antybiotyki_doustne(nie).



odpowiedz('Wybierz krem nawilzajacy z ceramidami.') :- polecana_substancja(ceramidy, tak).
odpowiedz('Sprobuj kremu z retinolem w profilaktyce antystarzeniowej.') :- polecana_substancja(retinol, tak).
odpowiedz('Udaj sie do endokrynologu w celu zbadania poziomu hormonow.') :- mozliwe_problemy_hormonalne(tak).

odpowiedz('Udaj sie do dietetyka, gdyz problemy z ukladem pokarmowym moga stanowic Twoje podloze tradziku.') :- mozliwe_problemy_gastryczne(tak).
odpowiedz('Mozesz wyprobowac retinoidy do walki z tradzikiem.') :- polecana_substancja(retinoidy, tak).
odpowiedz('Mozesz wyprobowac nadlenek benzoilu do walki z tradzikiem.') :- polecana_substancja(nadlenek_benzoilu, tak).
odpowiedz('Mozesz wyprobowac kwas salicylowy do walki z tradzikiem.') :- polecana_substancja(kwas_salicylowy, tak).
odpowiedz('Mozesz wyprobowac antybiotyki doustne do walki z tradzikiem.') :- polecana_substancja(antybiotyki_doustne, tak).
odpowiedz('Skontaktuj sie z dermatologiem w sprawie tradziku. Twoj przypadek jest skomplikowany.') :- uzywana_substancja(retinoidy, tak), 
                                                                                                      uzywana_substancja(kwas_salicylowy, tak),
                                                                                                      uzywana_substancja(nadlenek_benzoilu, tak),
                                                                                                      uzywana_substancja(antybiotyki_doustne, tak),
                                                                                                      stwierdzone_alergie(nie), 
                                                                                                      problemy_hormonalne(nie), 
                                                                                                      mozliwe_problemy_hormonalne(nie), 
                                                                                                      mozliwe_problemy_gastryczne(nie).                                                                

odpowiedz('Zrezygnuj z substancji zapachowym w kremach. Moga Cie uczulac') :- zrezygnuj_z_substancji_zapachowych.
odpowiedz('Nie zapominaj o kremie przeciwslonecznym, jesli chcesz zachowac jak nadluzej mlosy wyglad.') :- krem_przeciwsloneczny(nie).
odpowiedz('Dobrze, ze uzywasz kremu przeciwslonecznego z wysokim filtrem!') :- krem_przeciwsloneczny(tak), (faktor(N) , N > 49).
odpowiedz('Nie zapomnij o kremie z wysokim filtrem w okresie letnim!') :- krem_przeciwsloneczny(tak), (faktor(N) , N < 50).



usun_fakty :- retractall(plec(_)), retractall(wiek(_)), retractall(skora(_)), retractall(krem_przeciwsloneczny(_)), retractall(uzywany_krem(_,_)),
             retractall(faktor(_)), retractall(tradzik(_)), retractall(problemy(_)), retractall(nadlenek_benzoilu(_)),
             retractall(kwas_salicylowy(_)), retractall(antybiotyki_doustne(_)), retractall(stwierdzone_alergie(_)), retractall(problemy_hormonalne(_)), retractall(retinoidy(_)),
             retractall(mozliwe_problemy_hormonalne(_)), retractall(mozliwe_problemy_gastryczne(_)).

stworz_dynamiczne :- assertz(plec(xx)), assertz(skora(xx)), assertz(krem_przeciwsloneczny(xx)), 
                     assertz(uzywany_krem(xx,xx)),
                assertz(tradzik(xx)), assertz(problemy(xx)), assertz(nadlenek_benzoilu(xx)),
             assertz(kwas_salicylowy(xx)), assertz(antybiotyki_doustne(xx)), assertz(stwierdzone_alergie(xx)), assertz(problemy_hormonalne(xx)),
             assertz(mozliwe_problemy_hormonalne(xx)), assertz(mozliwe_problemy_gastryczne(xx)), assertz(retinoidy(xx)).
