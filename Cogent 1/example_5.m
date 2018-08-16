%% ICN Matlab course 16/11/16
% Script to demo image and string presentation using Cogent 2000. This
% script randomises the presentation order of six different images and
% loops to present them one after another as part of a trial structure. It
% also uses a nested loop to play a different sound file before each image that is
% contingent on which image is being presented.

clc; %clear workspace
clear; %clear variables
rand('state',sum(100*clock));% set random number generator

%% Initialise experiment variables
%first we are going to go through and set up all the important parameters
%for the experiment. We will save everything in a structure called 'p'
%which stands for parameters.

%% Timing information (in ms)
p.timetowait=1000; 
%% Trial infromation
p.ntrials=6;
%% Stimulus Information
p.stim={'c1.bmp';'c2.bmp';'c3.bmp';'h1.bmp';'h2.bmp';'h3.bmp'}; 
p.stimtype=[0 0 0 1 1 1]; % make a vector representing whether it's a Tory or a Baddie 0=Tory, 1=Baddie

% This loop creates a new variable called p.stim_list. It puts all our stimulus information for all the 
% trials we have in our experiment into one place. Later we will sort by the random number in the third 
% column to randomise the presentation order (p.randstim) - we will then call p.randstim (contingent on 
% trial#) to loop through the presentation of the different stimuli.
for loop=1:length(p.stim); %for 1:6
    p.stim_list(loop,1)=p.stim(loop); % in col 1 mark the file name
    p.stim_list{loop,2}=p.stimtype(loop); %in col 2 mark whether it's a Tory or a Baddie.
    p.stim_list{loop,3}=rand(1,1); % in col 3 put in a random number for sorting
end
%sort by the third column (a random number). i.e. randomise the order of presentation
p.randstim=sortrows(p.stim_list,3); 

%% Configure Devices %%
% Configure display (this is set to grey background and white text)
config_display(0, 1, [0.6 0.6 0.6], [1 1 1], 'Helvetica', 30, 6, 0);
config_sound;
%% Start Cogent %%
start_cogent;

%% Main Loop
for trial = 1:p.ntrials; % and 6 trials 
    
    % Clear all buffers at start of trial
    clearpict(1); % Clear buffer 1 (for fixation cross)
    clearpict(2); % Clear buffer 2 (for image presentation)                                                              
      
    
    % Prepare all stimuli in buffers
    preparestring('+',1) % Prepare buffer 1 (fixation cross
    loadpict(p.randstim{trial},2); % Prepare buffer 2 (image)      
    loadsound('boo.wav',4); % Prepare buffer 4 ("boo" sound)
    loadsound('sabre.wav',5);% Prepare buffer 5 ("light sabre" sound)
    
    % Run trial
    drawpict(1); % Present fixation cross
    wait(p.timetowait);% Wait
    
    if p.randstim{trial,2}==0; % if the image is a Tory
    playsound(4); % play the "boo" sounds
    else % otherwise
    playsound (5); % play the "light sabre" sound
    end % end
    wait(p.timetowait); % Wait

    drawpict(2); % Present image
    wait(p.timetowait); % Wait
    
    drawpict(3); % Present blank
    wait(p.timetowait); % Wait
    
         
end
%% stop cogent
stop_cogent;


