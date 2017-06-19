function [ filtered ] = filtrace( y, Fs, BW )
% funkce vr?t? filtrovany zvuk bez 50hz slozky
% na vstupu je vektor zvuku y a vzorkovavi frekvence Fs
global d;
d = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',50-BW/2,'HalfPowerFrequency2',50+BW/2, ...
               'DesignMethod','butter','SampleRate',Fs);


% Vytvorime si filtr pomoci funkce designfilr. Filtr typu pasmova zadrz,
% mezni frekvence1 = 49, mezni frekvence2 = 51
% vyuzijeme Butterworhovy aproximace

filtered = filtfilt(d,y); % k filtraci pouzijeme funkci filtfilt, vylepseni funkce filter
%filtered = filter(d,y);
end



