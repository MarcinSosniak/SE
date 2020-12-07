from  prolog_com import PrologMessenger
import sys
import os
import signal
from tkinter import *
import time
import datetime
import sys


pm = PrologMessenger(single_message_time_window=0.5,min_time_since_last_message=0.05,verbose = True)
pm.set_up()

anonymous_objects = []

question_answered =False

def clear(window):
    l = window.grid_slaves()
    for slave in l:
        slave.destroy()



class Serums_window:
    def __init__(self,window):
        self._window = window
        self._objects = 0
        self._draw_buttons()
        self._entries_and_variables = []
        self._alive = True
        anonymous_objects.append(self)

    def _draw_buttons(self):
        add_new_line_button = Button(master=self._window,text='dodaj nowy krem',command = lambda : self._add_new_option())
        confirm = Button(master=self._window, text='potwierdź', command=lambda: self._confirm())
        label = Label(master=self._window,text='   Dodaj kremy   ')
        add_new_line_button.grid(row = 0, column =0)
        label.grid(row=0, column=1, columnspan=4)
        confirm.grid(row = 0, column =5)

    def _add_new_option(self):
        label1 = Label(master=self._window,text='Jakiego kremu używałaś/eś?')
        entry = Entry(master=self._window)
        label2 =  Label(master=self._window,text='Czy działał?')
        yes_no_list = ['tak','nie']
        variable = StringVar(self._window)
        variable.set(yes_no_list[1])
        option = OptionMenu(self._window,variable,*yes_no_list)
        label1.grid(row = self._objects +1 , column = 0,columnspan =2)
        entry.grid(row = self._objects +1 , column = 2,columnspan=2)
        label2.grid(row = self._objects +1 , column = 4)
        option.grid(row = self._objects +1 , column = 5)
        self._objects +=1
        self._entries_and_variables.append((entry,variable))
        self._window.update_idletasks()
        self._window.update()

    def block(self):
        while self._alive:
            time.sleep(0.01)

    def _confirm(self):
        #chack if all fields are done
        for entry,variable in self._entries_and_variables:
            if entry.get() == '':
                return
        pm.send(str(self._objects))
        for entry,variable in self._entries_and_variables:
            pm.recieve()
            pm.send(entry.get())
            pm.recieve()
            pm.send(variable.get())
        clear(self._window)
        self._alive=False
        global question_answered
        question_answered = True









def read_normal_reading_row(window,variable):
    response= variable.get()
    print('read variable: {}'.format(response))
    print('clearing')
    clear(window)
    pm.send(response)
    global question_answered
    question_answered = True

def create_normal_reading_row(window, question, answerlist):
    t = Label(text= question, master=window)
    variable = StringVar(window)
    variable.set(answerlist[0])
    options = OptionMenu(window,variable,*answerlist)
    button = Button(window, text='potwierdź',command = lambda :read_normal_reading_row(window,variable))
    t.grid(row= 0, column  = 0,columnspan=2)
    options.grid(row= 0, column = 2)
    button.grid(row= 0, column = 3)
    pass




def read_num_reading_row(window,text_field_val):
    ival = None
    try:
        ival = int(text_field_val)
    except ValueError:
        return
    print('read variable num: {}'.format(ival))
    print('clearing')
    clear(window)
    pm.send(text_field_val)
    global question_answered
    question_answered = True
    pass

def create_num_reading_row(window,question):
    t = Label(text= question, master=window)
    entry = Entry(master = window)
    button = Button(window, text='potwierdź',command = lambda :read_num_reading_row(window,entry.get()))
    t.grid(row= 0, column  = 0,columnspan=2)
    entry.grid(row= 0, column = 2,columnspan=2)
    button.grid(row= 0, column = 4)





def create_serums_reading(window,question):
    sw = Serums_window(window)



def create_reading_row(window,str_in):
    str_in = str_in.replace('nie_wiem', 'nie wiem')
    answers_list_or_type_begin = str_in.find('[')
    question = str_in[:answers_list_or_type_begin]
    answers_list_or_type = str_in[answers_list_or_type_begin+1:-1]

    if ';' in answers_list_or_type:
        return create_normal_reading_row(window,question,answers_list_or_type.split(';'))
    elif answers_list_or_type == 'NUM':
        return create_num_reading_row(window, question)
    elif answers_list_or_type == 'LISTING_WTIH_NUM':
        return create_serums_reading(window, question)




def if_end_response(message):
    if '?' in message:
        return False
    else:
        return True


def show_answer(window,message):
    message = '\n'.join(message.split('\n')[:-3])
    print(message)
    clear(window)
    t = Text(window, height=len(message.split('\n')), width=120)
    t.grid(row=0,column = 0)
    t.insert(END,message)






def main_loop(window):
    while True:
        global question_answered
        question_answered=False
        message = pm.recieve()
        if if_end_response(message):
            show_answer(window,message)
            return
        create_reading_row(window,message)
        window.update_idletasks()
        window.update()
        while not question_answered:
            window.update_idletasks()
            window.update()


def main():
    window = Tk()
    window.resizable(True, True)
    window.title('Ekspert dermatolog')
    pm.send('start')
    pm.recieve()
    time.sleep(0.1)
    main_loop(window)
    window.mainloop()



if __name__ == '__main__':
    main()
    pass