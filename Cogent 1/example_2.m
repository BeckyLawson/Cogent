% Basic Cogent 2000 script present the same trial multiple times 
% using a loop 

% Rebecca Lawson
% 11/11/16

clc; %clear workspace
clear; %clear variables
%% Initialise experiment variables
%% Stimulus Information
p.stim='c1.bmp';
%% Timing information (in ms)
p.timetowait=2000; 
%% Trial infromation
p.ntrials=6;

%% Configure devices
% Configure display (this is set to grey background and white text)
config_display(0, 1, [0.6 0.6 0.6], [1 1 1], 'Helvetica', 30, 6);

%% Start Cogent
start_cogent;

%% Run Experiment
for trial=1:p.ntrials;
    
%load premade stimulus files 
preparestring('+',1); % Prepare buffer 1 (fixation cross)    
loadpict(p.stim,2);% Prepare buffer 2 (image)   
    
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


