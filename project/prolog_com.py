import os
import subprocess
import threading
import sys
import time
from queue import Queue
from shareble_message_storage import ShareableCharacterStorage


SWI_PROLOG_PATH = 'C:\\Program Files\\swipl\\bin\\swipl.exe'
PROLOG_FILE_NAME = 'pp.pl'
MY_PATH = os.path.dirname(os.path.realpath(__file__))
PROLOG_FILE_PATH = MY_PATH + '\\' +PROLOG_FILE_NAME


USE_UNIVERSAL_ENDLINES = True



class IllegalStateException(RuntimeError):
    pass


def output_reader(proc,sms):
    while True:
        c= proc.stdout.read(1)
        # print('got data in pipe {}'.format(c))
        sms.add_data(c)


def error_reader(proc,sms):
    while True:
        c = proc.stderr.read(1)
        sms.add_data(c)


def input_sender(proc,queue):
    while True:
        input_data = queue.get()
        if input_data =='':
            continue
        if input_data[-1] != '.':
            input_data = input_data + '.'
        proc.stdin.write((input_data + '\n') if USE_UNIVERSAL_ENDLINES else (input_data + '\n').encode(sys.stdout.encoding))
        proc.stdin.flush()
        print('send: ' + input_data)


class PrologMessenger():
    def __init__(self,single_message_time_window = 1,min_time_since_last_message = 0.1,verbose = False):
        self._send_queue = Queue()
        self._sms = ShareableCharacterStorage(single_message_time_window=single_message_time_window,min_time_since_last_message=min_time_since_last_message)
        self._fReady = False
        self._verbose = verbose
        pass


    def set_up(self):
        self._proc = subprocess.Popen([SWI_PROLOG_PATH, PROLOG_FILE_PATH], bufsize=0, stdin=subprocess.PIPE,
                                stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding="utf-8",
                                universal_newlines=USE_UNIVERSAL_ENDLINES)


        to = threading.Thread(target=output_reader, args=(self._proc, self._sms))
        to.start()
        te = threading.Thread(target=error_reader, args=(self._proc, self._sms))
        te.start()
        ti = threading.Thread(target=input_sender, args=(self._proc,self._send_queue))
        ti.start()
        time.sleep(0.2)
        self._fReady = True
        if self._verbose:
            print('PrologMessenger object ready')

    def send(self,message,timeout=2):
        if not self._fReady:
            raise IllegalStateException('Connection not ready')
        print("message to send: ", message)
        if message == 'nie wiem':
            message = 'nie_wiem'
        self._send_queue.put(message, timeout=timeout)
        if self._verbose:
            print('Sending')
            print('```')
            print(message)
            print('```')

    def recieve(self,timeout=2):
        if not self._fReady:
            raise IllegalStateException('Connection not ready')
        time0 = time.time()
        while time.time()  - time0 < timeout:
            if self._sms.f_new_data():
                data =self._sms.read_data()
                if self._verbose:
                    print('Recieved')
                    print('```')
                    print(data)
                    print('```')
                return data
            else:
                time.sleep(0.01)
        raise TimeoutError('timedout on read')






























