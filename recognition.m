mirwaitbar(0);  %wyrzuca progress bar
file = miraudio('Folder', 'Normal', 'Trim', 'Label', 1:2); %normalizacja pliku, trim przycinq
%file = miraudio('Folder', 'Normal', 'Trim', 'Center');
%na koncu i pocztku puste fragment
fcc = mirmfcc(file);
chroma = mirchromagram(file);
frames = mirframe(file);
fr_spectrum = mirspectrum(frames, 'Min', 1);
spectrum = mirspectrum(file, 'Min', 1);
f = mirpeaks(mircepstrum(fr_spectrum, 'Freq', 'Min', 0.0025), 'Total', 1);
%
zerocross = mirzerocross(file);      
rms = mirrms(file); %globalna energia sygnalu
q25 = mirrolloff(spectrum, 'Threshold', 0.25); %czestotiwosc - 25% powinno sie znalezc ponizej
%czestotliwosci
q25_f = mirmean(mirrolloff(fr_spectrum, 'Threshold', 0.25));
q75 = mirrolloff(spectrum, 'Threshold', 0.75);
q75_f = mirmean(mirrolloff(fr_spectrum, 'Threshold', 0.75));
pitch = mirpitch(spectrum, 'Mono');
pitch_fr = mirpitch(fr_spectrum, 'Mono');
%qr = mirgetdata(q75) - mirgetdata(q25);
lowenergy = mirlowenergy(file); %ile % synalu ma mniejsza energie niz srednia
centroid = mircentroid(spectrum); %wylicza spectra centroid, first moment
spread = mirspread(spectrum); %2nd moment
skewness = mirskewness(spectrum); %3rd moment
kurtosis = mirkurtosis(spectrum); %4th moment
flatness = mirflatness(spectrum); %sr geom/sr aryt
mirexport('results.arff', f, fcc, chroma, zerocross, rms, q25, q25_f, q75, q75_f, pitch, pitch_fr, lowenergy, centroid, spread, skewness, kurtosis, flatness);
