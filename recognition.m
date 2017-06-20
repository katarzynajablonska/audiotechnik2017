mirwaitbar(0);  %toggles off the display by MIRtoolbox of waitbar windows;
                %no progress bar displayed
file = miraudio('Folder', 'Normal', 'Trim', 'Label', 1:1); %loading all the
%files from the current directory which we are in; 'Normal' normalizes with
%respect to RMS energy, 'Trim' trims the pseudo-silence beginning and end 
%off the audio file (trimming the empty "moments" at the beginning and the
%end of the file), 'Label' is classifying/labeling the files - since 
%the first sign in the name of the file says which class set it is,
%therefore 1:1
fcc = mirmfcc(file);    %pectral shape of the sound
chroma = mirchromagram(file);   %distribution of energy along the pitches
frames = mirframe(file);    %we divide the signal into frames: short-term 
%windows that move chronologically along the temporal signal. Therefore
%we can determine how dynamically the fetaures will evolve
fr_spectrum = mirspectrum(frames, 'Min', 1); %decomposition of the signal frames
%along frequencies using a Discrete Fourier Transform
spectrum = mirspectrum(file, 'Min', 1); %decomposition of the whole audio file 
f = mirpeaks(mircepstrum(fr_spectrum, 'Freq', 'Min', 0.0025), 'Total', 1);
%with 'Total' and 1 we select only the highest peak. We detect these peaks
%using cepstrum, which indicates periodicities. 'Min', 0025 specifies the 
%lowest delay taken into consideration, in seconds. In our case it's
%0.0025 s (corresponding to a maximum frequency of 400 Hz - normally when we
%speak, the limit of human voice freqency is approx. 300 Hz, but I took 400,
%you know, just in case).
zerocross = mirzerocross(file);  %the number of times the signal crosses 
%the X-axis (or, in other words, changes sign)   
rms = mirrms(file); %root-mean-square: we take the the root average of 
%the square of the amplitude, which results in global energy of the signal
q25 = mirrolloff(spectrum, 'Threshold', 0.25); %estimation of the amount
%of high frequency in the signal.  We find frequency such that a certain 
%fraction of the total energy is contained below that frequency - in our
%case it's 25%
q25_f = mirmean(mirrolloff(fr_spectrum, 'Threshold', 0.25));%for frames
q75 = mirrolloff(spectrum, 'Threshold', 0.75); %here the threshold is 75%
q75_f = mirmean(mirrolloff(fr_spectrum, 'Threshold', 0.75));%for frames
pitch = mirpitch(spectrum, 'Mono'); %pitches extraction. 'Mono' says
%we only select the best pitch
pitch_fr = mirpitch(fr_spectrum, 'Mono'); %pitches extraction for frames
lowenergy = mirlowenergy(file); %computes the percentage of frames showing  
%a RMS energy that is lower than a given threshold (so, the ratio to the 
%average energy over the frames; we use default value t = 1)
centroid = mircentroid(spectrum); %calculates the centroid (or center of 
%gravity) 
spread = mirspread(spectrum); %returns the standard deviation of the signal
skewness = mirskewness(spectrum); %calculates the skewness of the signal, 
%showing the (lack of) symmetry of the curve.
kurtosis = mirkurtosis(spectrum); %calculates the kurtosis of the signal, 
%indicating whether the curve is peaked or flat relative to a normal distribution
flatness = mirflatness(spectrum); %flatness of the signal. Flatness indicates 
%whether the distribution is smooth or spiky, and results from the simple 
%ratio between the geometric mean and the arithmetic mean
%And finally, we export all the gathered statistical information into 
%'results.arff'
mirexport('results.arff', f, fcc, chroma, zerocross, rms, q25, q25_f, q75, q75_f, pitch, pitch_fr, lowenergy, centroid, spread, skewness, kurtosis, flatness);
%CAUTION! Rememember about changing names for Rolloff_Mean_,
%AverageofRolloff_Mean and Pitch_Mean attributes in lines 46, 47, 49
%in the 'results.arff' file
