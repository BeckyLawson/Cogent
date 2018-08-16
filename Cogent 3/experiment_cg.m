% A function to run a full experiment using Cogent Graphics.
% See lecture slides for details
% Rebecca Lawson November 2017
function [p ,results] = experiment(sub)
         % outputs:
         % p - parameters structure with all the predfined experiment
         % details for reference
         % results - a structre containing all the RTs to each image and
         % trial info for analysis
         % inputs:
         % sub - a subject ID (string)

%% Make sure random numbers are random
rand('state',sum(100*clock));% set random number generator

%% Initialise experiment variables
%first we are going to go through and set up all the important parameters
%for the experiment. We will save everything in a structure called 'p'
%which stands for parameters.

p.sub=sub;
%% Timing information (in ms)
p.times.stimduration=800;
p.times.blank1=300;
p.times.blank2=1500;

%% Trial infrormation
p.stimsize(1)=200;
p.stimsize(2)=200;
p.ntrials=8;
%% Stimulus Information
p.stim={'c1.bmp';'c2.bmp';'c3.bmp';'c4.bmp';'h1.bmp';'h2.bmp';'h3.bmp';'h4.bmp'}; 
p.stimtype=[0 0 0 0 1 1 1 1]; % make a vector representing whether it's a Tory or a Baddie 0=Tory, 1=Baddie
p.loc=[1 0 1 0 1 0 1 0]; %vector representing whether the image should be presented high=1 or low=-1;
p.h_loc=[0 100]; % the x and y positions of the high images
p.l_loc=[0 -100]; % the x and y positions of the low images

% This loop creates a new variable called p.stim_list. It puts all our stimulus information for all the 
% trials we have in our experiment into one place. Later we will sort by the random number in the third 
% column to randomise the presentation order (p.randstim) - we will then call p.randstim (contingent on 
% trial#) to loop through the presentation of the different stimuli.
for loop=1:length(p.stim); %for 1:8
    p.stim_list(loop,1)=p.stim(loop); % in col 1 mark the file name
    p.stim_list{loop,2}=p.stimtype(loop); %in col 2 mark whether it's a Tory or a Baddie.
    p.stim_list{loop,3}=rand(1,1); % in col 3 put in a random number for sorting
    p.stim_list{loop,4}=p.loc(loop); %in col 4 mark whether the image should be presented high or low
end
%sort by the third column (a random number). i.e. randomise the order of presentation
p.randstim=sortrows(p.stim_list,3); 

%% Configure Devices %%
% Configure display (this is set to black background and white text)
config_display(0, 1, [0 0 0], [1 1 1], 'Helvetica', 30, 10, 0);
% configure sound, use defaults
config_sound;
% configure the keyboard, use defaults
config_keyboard; 
%% Start Cogent %%
start_cogent;

% Change the pen colour and font
cgpencol(1,1,1) %change the pen colour
cgfont('Arial', 20) %change the font and size
%% Give the participants some instructions
cgtext('Welcome to the experiment.',0,100);
cgtext('Your task is to decide whether each person',0,75);
cgtext('is a baddie from Star Wars',0,50);
cgtext('or a Tory in British government.',0, 25);

cgtext('Please press B for Baddie.',0,-25);
cgtext('Please press T for Tory.',0, -50);
cgtext('Press SPACE to continue.',0,-100);
cgflip(0,0,0); %present sprite 0
waitkeydown(Inf, 71); %waits forever until a key is pressed


cgtext('If you are correct you will hear',0,100);
cgtext('a high pitched tone.',0,75);
cgtext('If you are wrong you will hear',0,50);
cgtext('a low pitched tone.',0, 25);

cgtext('Please be as accurate as possible',0,-25);
cgtext('and respond to every image.',0,-50);
cgtext('Press SPACE to START.',0,-100);
cgflip(0,0,0); %present sprite 0
waitkeydown(Inf, 71); %waits forever until a key is pressed

%COUNT DOWN: 3...2...1...START
cgfont('Arial',80); %change the font and size
cgtext('3',0,0);
cgflip(0,0,0);
wait(1000);
cgtext('2',0,0);
cgflip(0,0,0);
wait(1000);
cgtext('1',0,0);
cgflip(0,0,0);
wait(1000);
cgtext('start');
cgflip(0,0,0);
wait(1000);
cgfont('Arial',40); %change the font and size


%% Main Loop
for trial = 1:p.ntrials; % 8 trials 
    
   cgtext('+',0,0) %prepare the fixation cross off screen
    % note that we don't have to make a sprite to put this in. If you don't
    % make a sprite and set the sprite in advance you are drawing
    % "directly" to the offscreen buffer (sprite #0)
    % Sprite #0 is always displayed on the cgflip command.
    
    %First Block of CG flip and waituntil - blank1
    blank1onset=cgflip(0,0,0); %displays the fixation on a black background
    clearkeys; %clear any key events
    % load the next bitmap in the randomised list
    cgloadbmp(1,p.randstim{trial,1});
    % using this if loop work out where to position the bitmap on screen
    if p.randstim{trial,4}==1;
    cgdrawsprite(1,p.h_loc(1), p.h_loc(2));
    elseif p.randstim{trial,4}==0;
    cgdrawsprite(1, p.l_loc(1), p.l_loc(2));
    end
    cgtext('+',0,0) %prepare the fixation cross
    waituntil(blank1onset*1000+p.times.blank1); % waits for 300ms after blank1onset 
    %Note we scale by 1000 because cgflip returns the time in seconds, but
    %waituntil uses ms (d'oh!)


    %Second Block of CG flip and waituntil - stimulus display
    stimonset=cgflip(0,0,0); %display the stimulus
    cgtext('+',0,0) %prepare the fixation cross
    waituntil(stimonset*1000+p.times.stimduration) %wait for 800ms after stimonset
    
    % Third block of CG flip and waituntil - blank screen for response logging
    blank2onset=cgflip(0,0,0); %display the fixation cross again
    waituntil(blank2onset*1000+p.times.blank2) %wait for 1500ms after blank2onset
    
    % Read keypresses
    readkeys; 
    %output arguments key=what key ID was pressed, t=when was it pressed, n=how many times 
    [key, t, n]=getkeydown; 
    %Work out reaction times
    if n==0; %if they didn't press anything
        response=0; %mark their response as 0 
        rt=nan; %mark their reaction time as 9999
    else %otherwise
        response=key(1); %their response is whatever key they pressed.
        rt=t(1)-stimonset*1000; %and their reaction time is the time they pressed the button-the time the stimulus apprered
    end
    
    % record times and responses in struct called results
    results.image(trial,1)=p.randstim{trial,2}; %whether it was tory or baddie (1,0)
    results.resp(trial,1)=response; % which key they pressed
    results.rt(trial,1)=rt; % reaction time
    results.loc(trial, 1)=p.randstim{trial,4}; % whether it was presnted high or low (1,0)
   
    
    
  % Save the p and results structures on every trial
    %filename - subject ID entered input to the function
    save(p.sub, 'p', 'results');  
end
%% stop cogent
stop_cogent;


