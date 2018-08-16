% Basic Cogent 2000 script to loop across multiple stimuli and randomise
% presentation order

% ICN Matlab Course
% Rebecca Lawson
% 11/11/16

clc; %clear workspace
clear; %clear variables
%% Initialise experiment variables
%first we are going to go through and set up all the important parameters
%for the experiment. We will save everything in a structure called 'p'
%which stands for parameters.

rand('state',sum(100*clock));% set random number generator
%% Timing information (in ms)
p.timetowait=1000; 
%% Stimulus Information
p.stim={'c1.bmp';'c2.bmp';'c3.bmp';'h1.bmp';'h2.bmp';'h3.bmp'}; 
%% Trial infromation
p.ntrials=6;
p.ord=randperm(p.ntrials);
%% Configure devices
% Configure display (this is set to grey background and white text)
config_display(0, 1, [0.6 0.6 0.6], [1 1 1], 'Helvetica', 30, 6);
%% Start Cogent
start_cogent;

%% Run Experiment
for trial=1:p.ntrials;
    
% Clear all buffers at start of trial
% Since we now want to load different images into these buffers 
% on each trial.
clearpict(1); % Clear buffer 1 (for fixation cross)
clearpict(2); % Clear buffer 2 (for image presentation)                                                              
     
    
%load premade stimulus files
preparestring('+',1); % Prepare buffer 1 (fixation cross)
loadpict(p.stim{p.ord(trial)},2);  % Prepare buffer 2 (image)   
%loadpict(p.stim{trial},2);  % Prepare buffer 2 (image)   
    
% Run trial
drawpict(1); % Present fixation cross
wait(p.timetowait);% Wait

drawpict(2);  % Present image                                                              
wait(p.timetowait);% Wait


drawpict(3);% Present blank
wait(p.timetowait);% Wait
end


%% Stop Cogent
stop_cogent;


