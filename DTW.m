close all
clearvars
clc

%train-----------------------------------------------------------------------------
%%my sound
feathers1=new_dtw('my/my voice1.wav');
feathers2=new_dtw('my/my voice2.wav');
feathers3=new_dtw('my/my voice3.wav');
feathers4=new_dtw('my/my voice4.wav');
feathers5=new_dtw('my/my voice5.wav');
feathers6=new_dtw('my/my voice6.wav');
feathers7=new_dtw('my/my voice7.wav');
feathers8=new_dtw('my/my voice8.wav');
feathers9=new_dtw('my/my voice9.wav');
feathers10=new_dtw('my/my voice10.wav');

my_thershold1_2=dtw(feathers1,feathers2);
my_thershold1_3=dtw(feathers1,feathers3);
my_thershold1_4=dtw(feathers1,feathers4);
my_thershold1_5=dtw(feathers1,feathers5);
my_thershold1_6=dtw(feathers1,feathers6);
my_thershold1_7=dtw(feathers1,feathers7);
my_thershold1_8=dtw(feathers1,feathers8);
my_thershold1_9=dtw(feathers1,feathers9);
my_thershold1_10=dtw(feathers1,feathers10);


thersholds=cat(2,my_thershold1_10,my_thershold1_9);
thersholds=cat(2,my_thershold1_8,thersholds);
thersholds=cat(2,my_thershold1_7,thersholds);
thersholds=cat(2,my_thershold1_6,thersholds);
thersholds=cat(2,my_thershold1_5,thersholds);
thersholds=cat(2,my_thershold1_4,thersholds);
thersholds=cat(2,my_thershold1_3,thersholds);
thersholds=cat(2,my_thershold1_2,thersholds);


thershold_T=mean(thersholds);


% %other sound
feathers1=new_dtw('other/other voice1.wav');
feathers2=new_dtw('other/other voice2.wav');
feathers3=new_dtw('other/other voice3.wav');
feathers4=new_dtw('other/other voice4.wav');
feathers5=new_dtw('other/other voice5.wav');
feathers6=new_dtw('other/other voice6.wav');
feathers7=new_dtw('other/other voice7.wav');
feathers8=new_dtw('other/other voice8.wav');
feathers9=new_dtw('other/other voice9.wav');
feathers10=new_dtw('other/other voice10.wav');

other_thershold1_2=dtw(feathers1,feathers2);
other_thershold3_4=dtw(feathers3,feathers4);
other_thershold5_6=dtw(feathers5,feathers6);
other_thershold7_8=dtw(feathers7,feathers8);
other_thershold9_10=dtw(feathers9,feathers10);


%test-----------------------------------------------------------------
%new sound

new_my_voice=new_dtw('new/new voice1.wav');
Pattern_voice=new_dtw('my/my voice8.wav');
thershold=dtw(Pattern_voice,new_my_voice);

def=thershold_T-thershold;
def=abs(def);
if def<=10
        disp("Raziye ghafoori")
end
if def>10
    disp("I dont no who you are !!!")
end

function feathers=new_dtw(name)
[sound_n,fs] = audioread(name);

%show signal.....
figure
plot(sound_n)
xlabel('Time (seconds)')
title(name)

%remove silent......................
sound=remove_silence(sound_n,0.002);

%framing...............
frames=buffer(sound,100,20);

[m,n]=size(frames);

%hamming................
ham=hamming(m);
rep=repmat(ham,1,n);
frames_w=frames.*rep;

%creat feather energy , zerocrossing , MFCC..............
energy=ones(1,m);
zero=ones(1,m);

for j = 1:size(frames_w,2)
    energy(1,j)=sum(frames_w(:,j).^2);
end
for j=1 : size(frames_w,2)
	zero(1,j) = size(zerocrossrate(frames_w (:,j)),1);
end

MFCC =mfcc(sound,fs);

% Energy
EnergyMean = mean(energy);
EnergyVar = var(energy);
EnergyMAx = max(energy);
EnergyMin = min(energy);
% zerocrossing
zeroMean = mean(zero);
zeroVar = var(zero);
zeroMax = max(zero);
zeroMin = min(zero);
% MFCC
meanmmel = mean(MFCC);
variancemmel = var(MFCC);
maxmmel = max(MFCC);
minmmel = min(MFCC);

%Construction of feature matrix.................
feathers=cat(2,EnergyMin,EnergyMAx);
feathers=cat(2,EnergyVar,feathers);
feathers=cat(2,EnergyMean,feathers);
feathers=cat(2,zeroVar,feathers);
feathers=cat(2,zeroMax,feathers);
feathers=cat(2,zeroMin,feathers);
feathers=cat(2,zeroMean,feathers);
feathers=cat(2,meanmmel,feathers);
feathers=cat(2,variancemmel,feathers);
feathers=cat(2,maxmmel,feathers);
feathers=cat(2,minmmel,feathers);

end



function [output] = remove_silence(input, threshold)
    f_input = abs(fft(input));
    rms_input = sqrt(mean(f_input.^2));
    low_freqs = find(rms_input < threshold);
    f_input(low_freqs) = 0;
    output = real(ifft(f_input));
end
