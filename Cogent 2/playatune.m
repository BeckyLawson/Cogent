function playatune

% Example of using preparetone, playsound & waitsound
% to make a familiar tune:
% - create 8 possible tones, 2 with half the duration of the others
% - play all sound to make sure created correctly
% - wait until button press to play the tune
% - present 4 different sequences of tones, each contianing 6-7 tones
% - after the 3rd sequence loop the final note until button pressed

% speed of rhythm (beats per second)
bps = 2;

% each tone's frequency (pitch)
tfreq = [ 392 440 493.98 523.25 587.33 659.25 698.46 783.99];

% beat length for each tone (all 1 beat, except tone 1&7)
tbeat  = ones( size(tfreq) );
tbeat(1, [1 7]) = 0.5;

% tone sequences
tseq{1} = [ 1 1 2 1 4 3];
tseq{2} = [ 1 1 2 1 5 4];
tseq{3} = [ 1 1 8 6 4 3 2];
tseq{4} = [ 7 7 6 4 5 4];

% durations to wait
int_tone = 20;
int_seq  = 100;

% CONFIG
config_sound;
config_keyboard;
config_display(0, 1, [0 0 0], [1 1 1], 'Helvetica', 30, 10, 0);

% start cogent
start_cogent;

% prepare to write instruction on the screen
% instruction on screen to press button
% make sounds
preparestring('...loading...',1)
drawpict(1);
% loop round each of the tones
for t = 1:length(tfreq);
    
    % make tone of specific frequency & duration
    % preparepuretone(frequenccy, duration, buffer)
    preparepuretone( tfreq(t), (tbeat(t) * (1000/bps) ),t); 
    
    % play sound to check working & wait until sound finished
    playsound(t);
    waitsound(t);
end;


preparestring('press to play tune',2)
drawpict(2);
waitkeydown(Inf);

preparestring('HAPPY BIRTHDAY!',3, 0 ,50);
loadpict('cake.bmp',3);
drawpict(3);
 
% PRESENT STIMULI
for s = 1:length(tseq);
    
    for t = 1:length(tseq{s});
        
        % short pause before tones (20ms)
        wait(int_tone);
        
        % play tone & wait until ends
        playsound(tseq{s}(t));
        waitsound(tseq{s}(t));
    end;
    
    % for session 3 looop the final tone until button pressed
    if s == 3;
        %loop tone
        loopsound(tseq{s}(t));
        
        % wait forever (inf) until any button pressed
        waitkeydown(inf);
        
        % stop tone
        stopsound(tseq{s}(t));
    end;
    
    wait(int_seq);
    
end;


stop_cogent