%% ICN Matlab course 24/11/16
% Script to demo image and string presentation using Cogent 2000. This
% script randomises the presentation order of eight different images and
% loops to present them one after another as part of a trial structure. It
% also uses a nested loop if loop to prepare the stimuli in different 
% locations, contingent on a variable called p.stimloc.

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
p.ntrials=8;
%% Stimulus Information
p.stim={'c1.bmp';'c2.bmp';'c3.bmp'; 'c4.bmp'; 'h1.bmp';'h2.bmp';'h3.bmp'; 'h4.bmp'}; 
p.stimtype=[0 0 0 0 1 1 1 1]; % make a vector representing whether it's a Tory or a Baddie 0=Tory, 1=Baddie
p.loc=[1 1 0 0 1 1 0 0]; %vector representing whether the image should be presented high=1 or low=-1;
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
config_display(0, 1, [0.6 0.6 0.6], [1 1 1], 'Helvetica', 30, 6, 0);
%% Start Cogent %%
start_cogent;

%% Main Loop
for trial = 1:p.ntrials; % and 8 trials 
    
    % Clear all buffers at start of trial
    clearpict(1); % Clear buffer 1 (for fixation cross)
    clearpict(2); % Clear buffer 2 (for image presentation)                                                              
      
    
    % Prepare all stimuli in buffers
    preparestring('+',1) % Prepare buffer 1 (fixation cross
    
    % Prepare buffer 2 (image), location contingent on whether there's a 1
    % or a 0 in the 4th column of p.randstim. 1=up, 0=down.
    % e.g. If the 4th column is a 1 we load whatever image is listed in the 2nd column of
    % p.randstim (in buffer 2) and we put it in p.h_loc.
    if p.randstim{trial,4}==1;
    loadpict(p.randstim{trial},2, p.h_loc(1), p.h_loc(2));
    elseif p.randstim{trial,4}==0;
    loadpict(p.randstim{trial},2, p.l_loc(1), p.l_loc(2));
    end
    
    % -- Run trial --
    
    % Present fixation cross
    drawpict(1);
    % Wait
    wait(p.timetowait);
    
    % Present image
    drawpict(2); 
    % Wait
    wait(p.timetowait); 
    
    % Present blank
    drawpict(3); 
    % Wait
    wait(p.timetowait); 
    
end
%% stop cogent
stop_cogent;


