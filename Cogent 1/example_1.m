% Basic Cogent 2000 code to display one single image
% ICN Matlab Course
% Rebecca Lawson
% 11/11/16

clc; %clear workspace
clear; %clear variables
%% Initialise experiment variables
%% Stimulus Information
% Create a structure 'p' and a field 'stim' that specifies the filename of the
% image to present
p.stim='c1.bmp'; 
% add a filed called 'timetowait' that indicates how long the image should
% be presented for (in ms)
p.timetowait=2000; 

%% Configure devices
% Configure display (this is set to grey background and white text)
config_display(0, 1, [0.6 0.6 0.6], [1 1 1], 'Helvetica', 30, 6);

%% Start Cogent
start_cogent;

%% Run Experiment
%load premade stimulus files 
loadpict(p.stim,1);% Prepare buffer 1 (image) 

% Run trial
drawpict(1); % Present image 
wait(p.timetowait); % Wait

%% Stop Cogent
stop_cogent;


