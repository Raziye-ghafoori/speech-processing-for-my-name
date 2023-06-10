import time
import sounddevice as SD
from scipy.io import wavfile

def rec_voice(who,where,name,duratio=3,freq=12000):
    print('Please speak now, I\'m listening... ')
    samples=SD.rec(frames=int(duratio*freq),samplerate=freq,channels=1)
    SD.wait()
    print('Your time is up... ')
    wavfile.write(filename=f'{where}/{who}{name}.wav',data=samples,rate=freq)
    time.sleep(3)


# for i in range(10):
#     print(i,': ')
#     rec_voice("my voice",'my',i+1)

# print("now other................")

# for i in range(10):
#    print(i,': ')
#    rec_voice("other voice",'other',i+1)

print("test.....")
rec_voice("new voice",'new',1)