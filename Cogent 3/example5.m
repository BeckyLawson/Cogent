% Example 3: using sounds in cogent
% Written by Rebecca Lawson

% Generate at 1000Hz pitch tone with 1s duration using 3 methods
% buffer1: perparepuretone function
% buffer2: generate sinewave array in MATLAB & use preparesound function
% buffer3: load a .wav file 
%
% Play each tone 2 times, waiting unitl the end of the preceeding tone 
% plus a gap of 200ms before playing the next. Display on the screen
% the sound buffer number whilst the according tones are played
% After a 2s gap move onto the other tone verions.
%=====================================
% VARIABLES
% screen & sound setup
p.screen.mode  = 0;       % 0 = window, 1 = full screen, 2 = 2nd screen
p.screen.res   = 1;       % window, 640 x 480, blackbackground
p.screen.col   = [0 0 0]; % black screen background
p.setup.nchannels  = 1;   % 1= mono, 2 = stereo sound
p.setup.nbits   = 16;     % sounds bits (8 or 16)
p.setup.sampfreq = 11025; % sound smapling frequency (samples per sencond)
p.setup.nbuffer = 3;      % number of sound buffers
% tone details
p.tone.freq     = 1000;   % pitch for tone
p.tone.dur      = 1000;   % duration of tone (ms)
p.tone.amp      = 1;      % amplitude of tone (effects volume)
p.soundrep      = 2;      % number of times play tone
p.iti           = 200;    % time between each tone of same type
p.ibi           = 2000;   % time delay between each sequence of tones

%====================================================================
% CONFIG COGENT
config_display(p.screen.mode,p.screen.res,p.screen.col )
config_sound(p.setup.nchannels, p.setup.nbits, p.setup.sampfreq, p.setup.nbuffer)

%================
% START COGENT
start_cogent	          % start cogent

%===========
% make a cogent pure tone
buffer = 1;
preparepuretone(p.tone.freq, p.tone.dur, buffer);
%===========
% make a puretone using matlab & load into buffer 2 
buffer = 2;
%The equations to generate a sinvave when amplitude, frequency and duration
%are known.
array = [1:(p.setup.sampfreq*p.tone.dur/1000)]'/p.setup.sampfreq;
array = p.tone.amp * sin(2* pi * p.tone.freq * array);
preparesound(array,buffer);
%===========
% load a preexisting .wav file & load into buffer 3 
buffer=3;
loadsound('signal.wav',buffer)


%==================
% directly write onto next screen buffer
cgsetsprite(0);

% WARNING: COGENT has a timing issue for the very 1st tone played
% so it is best at the beginning of your script to play any sound
% once, to ensure any tone in your script occur when you want them to!!

% play a test tone & write test tone on screen
cgpencol([1 1 0]);          % set pen colour to yellow
cgtext('TEST TONE',0,0);    % write into next screen buufer #0
cgflip(p.screen.col);     % display words
buffer = 1;                 % choose one of the sound buffers
playsound(buffer);          % play sound in buffer
waitsound(buffer);          % wait until sound finished
cgflip(p.screen.col);     % display blank screen
wait(p.ibi);              % wait before startin main presentation 

%=====================
% PRESENT STIMULI
%====================

% Loop round each of the tone types
for buffer = 1:p.setup.nbuffer
    
    % display the tone number
    cgpencol([1 0 0]);
    cgtext(num2str(buffer),0,0);
    cgflip(p.screen.col);
    
    % Play same tone 3x in a row, with short gap between each
    for s = 1:p.soundrep;

        % play sound in selected buffer
        playsound(buffer);
        
        % wait until soudn finished
        waitsound(buffer);
        
        % wait a further gap
        wait(p.iti);
    end;
    
    % display blank screen & wait between different tone types
    cgflip(p.screen.col);
    wait(p.ibi);  
      
end;
%================
% STOP COGENT
stop_cogent	          % stop cogent





