start :- set_stream(current_output, tty(true)), pytaj, !, stworz_dynamiczne, !, analiza, !.
       
/*  --------------------     PYTAJ     -------------------------------- */
       
pytaj :-  pytaj_o_plec, pytaj_o_wiek, pytaj_o_rodzaj_skory, pytaj_o_krem_przeciwsloneczny, pytaj_o_ilosc_kremow,
          pytaj_o_problemy_skorne, pytaj_o_diete.

         
pytaj_o_plec :- format('Jaką masz płeć?[kobieta;meżczyzna]'), read(ODP_PLEC), asserta(plec(ODP_PLEC)).
kobieta :- plec(kobieta).
mezczyna :- plec(mezczyzna).


pytaj_o_wiek :- format('W jakim jesteś wieku?[NUM]'), read(ODP_WIKE), asserta(wiek(ODP_WIKE)).
nastolatek :- (wiek(N) , N < 20, N > 10).
mlody_dorosly :- (wiek(N) , N < 30, N > 19).
dorosly :- (wiek(N) , N < 50, N > 20).
dojrzaly :- (wiek(N) , N > 49).


pytaj_o_rodzaj_skory :- format('Jaki masz rodzaj skóry?[normalna;mieszana;sucha;tlusta]'), read(ODP_SKORA), asserta(skora(ODP_SKORA)).
normalna_skora :- skora(normalna).
mieszana_skora :- skora(mieszana).
sucha_skora :- skora(sucha).
tlusta_skora :- skora(tlusta).


pytaj_o_krem_przeciwsloneczny :- format('Czy używasz kremu przeciwsłonecznego?[tak;nie]'), read(ODP_KREM_SPF), asserta(krem_przeciwsloneczny(ODP_KREM_SPF)),
                                 pytaj_o_wysokosc_filtru(ODP_KREM_SPF).       
                                
pytaj_o_wysokosc_filtru(nie) :- true.
pytaj_o_wysokosc_filtru(tak) :- format('Jak wysoki filtr stosujesz? Podaj faktor.[NUM]'), read(ODP_FILTR), asserta(faktor(ODP_FILTR)).


pytaj_o_ilosc_kremow :- format('Ilu kremów używałaś/eś?[LISTING_WTIH_NUM]'), read(ILOSC_KREMOW), pytaj_o_kremy(ILOSC_KREMOW).
pytaj_o_kremy(0) :- true.
pytaj_o_kremy(1) :- pytaj_o_krem.
pytaj_o_kremy(N) :- pytaj_o_krem, N1 is N-1, pytaj_o_kremy(N1).
pytaj_o_krem :- format('Jak nazywał się krem?'), read(NAZWA_KREMU), format('Czy działał?'), read(CZY_DZIALAL), asserta(uzywany_krem(NAZWA_KREMU, CZY_DZIALAL)).


pytaj_o_problemy_skorne :- format('Czy masz jakieś problemy skórne, które chcesz wyelminować?[tak;nie]'), read(ODP_PROBLEMY), asserta(problemy(ODP_PROBLEMY)),
                           dopytaj_o_problemy_skorne(ODP_PROBLEMY). 
                                                  
dopytaj_o_problemy_skorne(nie) :- true.
dopytaj_o_problemy_skorne(tak) :- pytaj_o_rumien, pytaj_o_tradzik_jesli_natolatek_badz_mlody_dorosly.

pytaj_o_rumien :- format('Czy Twoja skóra łatwo się czerwieni pod wypłwem temperatury/alkoholu?[tak;nie]'),
                  read(ODP_CZERWONA_SKORA), asserta(czerwona_skora(ODP_CZERWONA_SKORA)),
                  dopytaj_o_rumien(ODP_CZERWONA_SKORA).

dopytaj_o_rumien(nie) :- true.
dopytaj_o_rumien(tak) :- format('Czy masz trwale rozszerzone naczynia krwionośne na twarzy?[tak;nie]'), read(ODP_NACZYNKA),
                         asserta(naczynka(ODP_NACZYNKA)), dopytaj_o_leczenie_rumienia(ODP_NACZYNKA).

dopytaj_o_leczenie_rumienia(nie) :- true.
dopytaj_o_leczenie_rumienia(tak) :- pytaj_o_serum_z_witamina_c, pytaj_o_laserowe_usuwanie_rumienia.

pytaj_o_serum_z_witamina_c :- format('Czy używałaś/eś serum z witaminą C?[tak;nie]'), read(ODP_SERUM_C),
                              asserta(serum_C(ODP_SERUM_C)).

pytaj_o_laserowe_usuwanie_rumienia :- format('Czy próbowałaś/eś laserowych zabiegów usuwania rumienia?[tak;nie]'),
                                      read(ODP_LASER), asserta(laser_rumien(ODP_LASER)).


pytaj_o_tradzik_jesli_natolatek_badz_mlody_dorosly :- nastolatek, pytaj_o_tradzik.
pytaj_o_tradzik_jesli_natolatek_badz_mlody_dorosly :- mlody_dorosly, pytaj_o_tradzik.
pytaj_o_tradzik_jesli_natolatek_badz_mlody_dorosly :- true. 


pytaj_o_tradzik :- format('Czy zmagasz sie z trądzikiem?[tak;nie]'), read(ODP_TRADZIK), asserta(tradzik(ODP_TRADZIK)), dopytaj_o_tradzik(ODP_TRADZIK).

dopytaj_o_tradzik(nie) :- true.
dopytaj_o_tradzik(tak) :- znajdz_podloze_tradziku, pytaj_o_substancje_do_walki_z_tradzikiem.

znajdz_podloze_tradziku :- pytaj_o_alergie, pytaj_o_problemy_hormonalne.

pytaj_o_alergie :- format('Czy masz stwierdzone alergie pokarmowe?[tak;nie]'), read(ODP_ALERGIE), asserta(stwierdzone_alergie(ODP_ALERGIE)),
                   dopytaj_o_alergie(ODP_ALERGIE).
                   
dopytaj_o_alergie(tak) :- true.
dopytaj_o_alergie(nie) :- format('Czy odczuwasz czasem ból brzucha po posilku?[tak;nie]'), read(ODP_PROBLEMY_GASTRYCZNE),
                          asserta(mozliwe_problemy_gastryczne(ODP_PROBLEMY_GASTRYCZNE)).


pytaj_o_problemy_hormonalne :- format('Czy masz stwierdzone problemy hormonalne?[tak;nie]'), read(ODP_HORMONY), asserta(problemy_hormonalne(ODP_HORMONY)),
                               dopytaj_o_hormony(ODP_HORMONY).
                               
dopytaj_o_hormony(tak) :- true.                      
dopytaj_o_hormony(nie) :- format('Czy masz huśtawki nastroju albo nadmierne owłosienie?[tak;nie]'), read(ODP_MOZLIWE_PR_HORMONALNE),
                          asserta(mozliwe_problemy_hormonalne(ODP_MOZLIWE_PR_HORMONALNE)).

pytaj_o_substancje_do_walki_z_tradzikiem :- pytaj_o_nadlenek_benzoilu, pytaj_o_kwas_salicylowy,
                                            pytaj_o_retinoidy, pytaj_o_antybiotyki_doustne.

pytaj_o_nadlenek_benzoilu :- format('Czy używalaś/eś nadlenku benzoilu?[tak;nie;nie_wiem]'),
                             read(ODP_SUB1), asserta(nadlenek_benzoilu(ODP_SUB1)), dopytaj_o_nadlenek_benzoilu(ODP_SUB1).

dopytaj_o_nadlenek_benzoilu(tak) :- true.
dopytaj_o_nadlenek_benzoilu(nie) :- true.
dopytaj_o_nadlenek_benzoilu(nie_wiem) :- format('Czy używalaś/eś chociaż jednego z tych preparatów: neutrogena rapid clear, stubborn acne spot, epiduo?[tak;nie]'),
                                         read(ODP_NADLETNEK_BENZOILU_PREPARATY),
                                         asserta(nadlenek_benzoilu_preparaty(ODP_NADLETNEK_BENZOILU_PREPARATY)).


pytaj_o_kwas_salicylowy :- format('Czy używalaś/eś kwasu salicylowego?[tak;nie]'),
                           read(ODP_SUB2), asserta(kwas_salicylowy(ODP_SUB2)).

pytaj_o_retinoidy :- format('Czy używalaś/eś retonodiow?[tak;nie;nie_wiem]'),
                     read(ODP_SUB4), asserta(retinoidy(ODP_SUB4)), dopytaj_o_retinoidy(ODP_SUB4).

dopytaj_o_retinoidy(tak) :- true.
dopytaj_o_retinoidy(nie) :- true.
dopytaj_o_retinoidy(nie_wiem) :- format('Czy używalaś/eś chociaż jednego z tych preparatów: differin gel, epiduo, aknemycin?[tak;nie]'),
                                 read(ODP_RETINOIDY_PREPARATY),
                                 asserta(retinoidy_preparaty(ODP_RETINOIDY_PREPARATY)).


pytaj_o_antybiotyki_doustne :- format('Czy używalaś/eś antybiotyk doustnych?[tak;nie;nie_wiem]'),
                               read(ODP_SUB3), asserta(antybiotyki_doustne(ODP_SUB3)).


/* dieta i witaminy */
pytaj_o_diete :- pytaj_o_weganizm, pytaj_o_cynk, pytaj_o_żelazo.

pytaj_o_weganizm :- format('Czy jesteś na diecie wegańskiej?[tak;nie]'), read(WEGAZNIM), asserta(weganizm(WEGAZNIM)),
                    dopytaj_o_witamine_b12(WEGAZNIM).

dopytaj_o_witamine_b12(nie) :- true.
dopytaj_o_witamine_b12(tak) :- format('Czy suplementujesz witaminę B12?[tak;nie]'), read(WITAMINA_B12), asserta(witamina_b12(WITAMINA_B12)).


pytaj_o_cynk :- format('Czy Twoja dieta obfituje w cynk (źródła to np. wątróbka, jaja, kasza gryczana)?[tak;nie]'),
                read(CYNK), asserta(cynk(CYNK)).

pytaj_o_żelazo :-  format('Czy Twoja dieta obfituje w żelazo (źródła to np. czerwone mięso, natka pietruszki)?[tak;nie]'),
                   read(ZELAZO), asserta(zelazo(ZELAZO)).


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
polecana_substancja(retinoidy, tak) :- retinoidy(nie), !.
polecana_substancja(retinoidy, tak) :- retinoidy(nie_wiem), retinoidy_preparaty(nie).

polecana_substancja(nadlenek_benzoilu, tak) :- nadlenek_benzoilu(nie), !.
polecana_substancja(nadlenek_benzoilu, tak) :- nadlenek_benzoilu(nie_wiem), nadlenek_benzoilu_preparaty(nie).

polecana_substancja(antybiotyki_doustne, tak) :- antybiotyki_doustne(nie).
polecana_substancja(kwas_salicylowy, tak) :- kwas_salicylowy(nie).

uzywana_substancja(retinoidy, tak) :- retinoidy(tak).
uzywana_substancja(nadlenek_benzoilu, tak) :- nadlenek_benzoilu(tak).
uzywana_substancja(kwas_salicylowy, tak) :- kwas_salicylowy(nie).
uzywana_substancja(antybiotyki_doustne, tak) :- antybiotyki_doustne(nie).

/* leczenie rumienia */
polecana_substancja(witamina_c, tak) :- naczynka(tak), serum_C(nie).
polecane_zabiegi_laserowe(tak) :- naczynka(tak), laser_rumien(nie).



odpowiedz('Wybierz krem nawilżający z ceramidami.') :- polecana_substancja(ceramidy, tak).
odpowiedz('Spróbuj kremu z retinolem w profilaktyce antystarzeniowej.') :- polecana_substancja(retinol, tak).
odpowiedz('Udaj się do endokrynologu w celu zbadania równowagi hormonalnej.') :- mozliwe_problemy_hormonalne(tak).

odpowiedz('Udaj się do dietetyka, gdyż problemy z układem pokarmowym mogą stanowić Twoje podłoże trądziku.') :- mozliwe_problemy_gastryczne(tak).
odpowiedz('Możesz wypróbować retinoidy do walki z tradzikiem.') :- polecana_substancja(retinoidy, tak).
odpowiedz('Możesz wypróbować nadlenek benzoilu do walki z tradzikiem.') :- polecana_substancja(nadlenek_benzoilu, tak).
odpowiedz('Możesz wypróbować kwas salicylowy do walki z tradzikiem.') :- polecana_substancja(kwas_salicylowy, tak).
odpowiedz('Możesz wypróbować antybiotyki doustne do walki z tradzikiem.') :- polecana_substancja(antybiotyki_doustne, tak).
odpowiedz('Skontaktuj sie z dermatologiem w sprawie tradziku. Twoj przypadek jest skomplikowany.') :- uzywana_substancja(retinoidy, tak), 
                                                                                                      uzywana_substancja(kwas_salicylowy, tak),
                                                                                                      uzywana_substancja(nadlenek_benzoilu, tak),
                                                                                                      uzywana_substancja(antybiotyki_doustne, tak).

odpowiedz('Zrezygnuj z substancji zapachowym w kremach. Mogą Cie uczulać') :- zrezygnuj_z_substancji_zapachowych.
odpowiedz('Nie zapominaj o kremie przeciwsłonecznym, jeśli chcesz zachować jak nadłużej młody wygląd.') :- krem_przeciwsloneczny(nie).
odpowiedz('Dobrze, że używasz kremu przeciwsłonecznego z wysokim filtrem!') :- krem_przeciwsloneczny(tak), (faktor(N) , N > 49).
odpowiedz('Nie zapomnij o kremie z wysokim filtrem w okresie letnim!') :- krem_przeciwsloneczny(tak), (faktor(N) , N < 50).

odpowiedz('Wypróbuj serum z witaminą C w celu uszczelnienia naczyń krwionośnych.') :- polecana_substancja(witamina_c, tak).
odpowiedz('Jeśli serum z witaminą C nie zadziała wypróbuj zabiegi laserowe w celu redukcji rumienia.') :- polecane_zabiegi_laserowe(tak),
                                                                                                          serum_C(nie).
odpowiedz('Twój rumień wymaga redukcji laserowej.') :- polecane_zabiegi_laserowe(tak), serum_C(tak).

odpowiedz('Skoro jesteś na diecie wegańskiej nie zapominaj o suplementacji witaminy B12.') :- weganizm(tak), witamina_b12(nie).
odpowiedz('W Twojej diecie brakuje żelaza. Dołącz do diety m.in. czerwone mięso, żółtka jaj, natkę pietruszki, sezam.') :- cynk(nie).
odpowiedz('W Twojej diecie brakuje cynku. Dołącz do diety m.in. wątróbkę, kaszę gryczaną, pestki dyni, nasiona słonecznika.') :- zelazo(nie).




usun_fakty :- retractall(plec(_)), retractall(wiek(_)), retractall(skora(_)), retractall(krem_przeciwsloneczny(_)), retractall(uzywany_krem(_,_)),
              retractall(faktor(_)), retractall(tradzik(_)), retractall(problemy(_)), retractall(nadlenek_benzoilu(_)),
              retractall(kwas_salicylowy(_)), retractall(antybiotyki_doustne(_)), retractall(stwierdzone_alergie(_)), retractall(problemy_hormonalne(_)), retractall(retinoidy(_)),
              retractall(mozliwe_problemy_hormonalne(_)), retractall(mozliwe_problemy_gastryczne(_)),
              retractall(serum_C(_)), retractall(laser_rumien(_)), retractall(naczynka(_)),
              retractall(weganizm(_)), retractall(witamina_b12(_)), retractall(cynk(_)), retractall(zelazo(_)),
              retractall(nadlenek_benzoilu_preparaty(_)), retractall(retinoidy_preparaty(_)).

stworz_dynamiczne :- assertz(plec(xx)), assertz(skora(xx)), assertz(krem_przeciwsloneczny(xx)), 
                     assertz(uzywany_krem(xx,xx)),
                     assertz(tradzik(xx)), assertz(problemy(xx)), assertz(nadlenek_benzoilu(xx)),
                     assertz(kwas_salicylowy(xx)), assertz(antybiotyki_doustne(xx)), assertz(stwierdzone_alergie(xx)), assertz(problemy_hormonalne(xx)),
                     assertz(mozliwe_problemy_hormonalne(xx)), assertz(mozliwe_problemy_gastryczne(xx)), assertz(retinoidy(xx)),
                     assertz(serum_C(xx)), assertz(laser_rumien(xx)), assertz(naczynka(xx)),
                     assertz(weganizm(xx)), assertz(witamina_b12(xx)), assertz(cynk(xx)), assertz(zelazo(xx)),
                     assertz(nadlenek_benzoilu_preparaty(xx)), assertz(retinoidy_preparaty(xx)).
