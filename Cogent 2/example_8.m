%% ICN Matlab course 24/11/16
% Script to demo image and string presentation using Cogent 2000. This
% script randomises the presentation order of eight different images and
% loops to present them one after another as part of a trial structure. It
% also uses a nested loop to play a different sound file before each image that is
% contingent on which image is being presented. Logs keypresses, works out
% reaction time and saves this info to new variables (results struct). 
% Works out accuracy (a conjunction of stimulus type and response) and uses
% this in another nested loop to decide which feedback tone to play. A high
% tone for correct, a low tone for incorrect and a warning if they don't
% repond at all.

clc; %clear workspace
clear; %clear variables
rand('state',sum(100*clock));% set random number generator

%% Initialise experiment variables
%first we are going to go through and set up all the important parameters
%for the experiment. We will save everything in a structure called 'p'
%which stands for parameters.

%% Timing information (in ms)
p.timetowait=1000; 
%% Trial information
p.ntrials=8;
%% Stimulus Information
p.stim={'c1.bmp';'c2.bmp';'c3.bmp'; 'c4.bmp'; 'h1.bmp';'h2.bmp';'h3.bmp'; 'h4.bmp'}; 
p.stimtype=[0 0 0 0 1 1 1 1]; % make a vector representing whether it's a Tory or a Baddie 0=Tory, 1=Baddie
p.loc=[1 0 1 0 1 0 1 0]; %vector representing whether the image should be presented high=1 or low=-1;
p.h_loc=[0 100]; % the x and y positions of the high images
p.l_loc=[0 -100]; % the x and y positions of the low images;

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
% Configure display (this is set to grey background and white text)
config_display(0, 1, [0.6 0.6 0.6], [1 1 1], 'Helvetica', 30, 10, 0);
% configure sound, use defaults
config_sound;
% configure the keyboard, use defaults
config_keyboard; 
%% Start Cogent %%
start_cogent;

%% Main Loop
for trial = 1:p.ntrials; % and 8 trials 
    
    % -- Clear all buffers at start of trial --
    clearpict(1); % Clear buffer 1 (for fixation cross)
    clearpict(2); % Clear buffer 2 (for image presentation)                                                              
      
    
    % --  Prepare all stimuli in buffers --
    preparestring('+',1) % Prepare buffer 1 (fixation cross)
    
    % Prepare buffer 2 (image), location contingent on what image it is
    if p.randstim{trial,4}==1;
    loadpict(p.randstim{trial},2, p.h_loc(1), p.h_loc(2));
    elseif p.randstim{trial,4}==0;
    loadpict(p.randstim{trial},2, p.l_loc(1), p.l_loc(2));
    end
    
    %prepare text in buffer 3
    preparestring('Baddie or Tory?',3);
    %prepare high pitched tone in buffer 5
    preparepuretone(660,1000,5); %high tone - correct
    %prepare low pitched tone in buffer 6
    preparepuretone(330,1000,6);% low tone - incorrect
    %prepare response warning in buffer 7
    preparestring('Please respond!',7);
    
    
    % -- Run trial --
    
    % Present fixation cross
    drawpict(1);
    % Wait
    wait(p.timetowait);
    
    % Present text
    drawpict(3);
    % Wait
    wait(p.timetowait);
    
    
    %clear key presses
    clearkeys; 
    % Present image
    stimonset = drawpict(2);
    % Present image
    wait(p.timetowait);
    
    % Read keypresses
    readkeys; 
    %output arguments key=what key ID was pressed, t=when was it pressed, n=how many times 
    [key, t, n]=getkeydown; 
    %Work out reaction times
    if n==0; %if they didn't press anything
        response=nan; %mark their response as nan 
        rt=nan; %mark their reaction time as nan
    else %otherwise
        response=key(1); %their response is whatever key they pressed.
        rt=t(1)-stimonset; %and their reaction time is the time they pressed the button-the time the stimulus apprered
    end
    
    % record times and responses in struct called results
    results.image(trial,1)=p.randstim(trial,2); %whether it was tory or baddie (1,0)
    results.resp(trial,1)=response; % which key they pressed
    results.rt(trial,1)=rt; % reaction time
    results.loc(trial, 1)=p.randstim{trial,4}; % whether it was presnted high or low (1,0)
    
    
   % -- feedback and log accuracy
   % if they pressed 'b' and it was a baddie OR pressed 't' and it was a Tory (ie. they were correct!)
   if response==2 &&  p.randstim{trial,2}==1 || response==20 &&  p.randstim{trial,2}==0;
       %log accuracy in new field in results structure
       results.acc(trial,1)=1;
       %play feedback
       playsound(5);
       % if they pressed 'b' and it was a Tory OR pressed 't' and it was a Baddie (ie. they were incorrect!)
   else if response==2 &&  p.randstim{trial,2}==0 || response==20 &&  p.randstim{trial,2}==1;
           %log accuracy in results structure
           results.acc(trial,1)=0;
           %play feedback
           playsound(6);
       else
           %log accuracy in results structure
           results.acc(trial,1)=nan;
           %show warning
           drawpict(7);
       end
   end
    % Wait
    wait(p.timetowait);
    
    % Present blank
    drawpict(4);
    % Wait
    wait(p.timetowait); 
            
end
%% stop cogent
stop_cogent;


