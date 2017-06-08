mirwaitbar(0);  %wyrzuca progress bar
file = miraudio({'male.wav', 'female.wav', 'male2.wav', 'female2.wav'}, 'Normal', 'Trim', 'Center', 'Label', 1:2); %normalizacja pliku, trim przycinq
%file = miraudio('Folder', 'Normal', 'Trim', 'Center');
%na koncu i pocztku puste fragmenty

spectrum = mirspectrum(file, 'Min', 1);
zerocross = mirzerocross(file);      
rms = mirrms(file); %globalna energia sygnalu
q25 = mirrolloff(file, 'Threshold', 0.25); %czestotiwosc - 25% powinno sie znalezc ponizej
%czestotliwosci
q75 = mirrolloff(file, 'Threshold', 0.75);
%qr = mirgetdata(q75) - mirgetdata(q25);
lowenergy = mirlowenergy(file); %ile % synalu ma mniejsza energie niz srednia
centroid = mircentroid(file); %wylicza spectra centroid, first moment
spread = mirspread(file); %2nd moment
skewness = mirskewness(file); %3rd moment
kurtosis = mirkurtosis(file); %4th moment
flatness = mirflatness(file); %sr geom/sr aryt
mirexport('results.arff', zerocross, rms, q25, q75, lowenergy, centroid, spread, skewness, kurtosis, flatness);
