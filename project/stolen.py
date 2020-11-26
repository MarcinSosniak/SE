from pyswip import *

def read():
    x = str(input())
    return x
def pytaj(pytanie):
    print(pytanie," ? (tak/nie)")
    inp = read()
    while inp not in ["tak", "nie"]:
        print("odpowiedz musi być (tak/nie)")
        inp = read()
    pamietaj = Functor("pamietaj",2)
    call(pamietaj(pytanie,inp))
    # PL_cons_functor_v()
    # prolog.query("pamietaj("+ str(X) +"," + inp+")").close()
    # prolog.query("pamietaj(X,"+inp+")").close()


pytaj.arity = 1
if __name__ =="__main__":

    prolog = Prolog()
    registerForeign(pytaj)
    prolog.consult("pp.pl")
    # to też działa :D
    # for result in prolog.query("jest_to_film(X)"):
    #     # r = result["X"]
    #     # print(r)
    #     pass
    X = Variable()

    jest_to_film = Functor("start",0)
    q = Query(jest_to_film())
    # while q.nextSolution():
    #     print("Hello,", X.value)
    # q.closeQuery()