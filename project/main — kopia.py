import os
import subprocess
import threading
import sys
from shareble_message_storage import ShareableCharacterStorage

SWI_PROLOG_PATH = 'C:\\Program Files\\swipl\\bin\\swipl.exe'
PROLOG_FILE_NAME = 'pp.pl'
MY_PATH = os.path.dirname(os.path.realpath(__file__))
PROLOG_FILE_PATH = MY_PATH + '\\' +PROLOG_FILE_NAME


USE_UNIVERSAL_ENDLINES = True

proc = subprocess.Popen([SWI_PROLOG_PATH,PROLOG_FILE_PATH],bufsize=0,stdin=subprocess.PIPE, stdout=subprocess.PIPE,stderr=subprocess.PIPE,universal_newlines=USE_UNIVERSAL_ENDLINES)
# proc = subprocess.Popen(["python",'forever_echo.py'],bufsize=-1,stdin=subprocess.PIPE, stdout=subprocess.PIPE,stderr=subprocess.PIPE, universal_newlines=True,shell =True)
print(SWI_PROLOG_PATH)
print(PROLOG_FILE_PATH)

global_sms = ShareableCharacterStorage(single_message_time_window=0.2,byte_in=not USE_UNIVERSAL_ENDLINES)


def output_reader(proc,sms):
    while True:
        c= proc.stdout.read(1)
        print('got data in pipe')
        sms.add_data(c)


def error_reader(proc,sms):

    while True:
        c = proc.stderr.read(1)
        sms.add_data(c)


def input_sender(proc):
    while True:
        input_data = input()
        proc.stdin.write((input_data + '\n') if USE_UNIVERSAL_ENDLINES else (input_data + '\n').encode(sys.stdout.encoding))
        proc.stdin.flush()
        print('send: ' + input_data)

to = threading.Thread(target=output_reader, args=(proc,global_sms))
to.start()
te = threading.Thread(target=error_reader, args=(proc,global_sms))
te.start()
ti = threading.Thread(target=input_sender, args=(proc,))
ti.start()

try:
    while True:
        if global_sms.f_new_data():
            print('recieved : ' + global_sms.read_data())
except KeyboardInterrupt:
    sys.exit(0)