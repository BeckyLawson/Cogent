% sample script to use Cogent Graphcis to play a movie

clear; clc; %clear anything that might be lying around in the workspace
%====================================================================
%cgloadlib; %load all the cg functions

% CONFIG COGENT
config_display(0, 1, [0 0 0])
%cgopen(1,0,0,0)
% 0 = window, 1 = full screen, 2 = 2nd screen
% 640 x 480
% black screen background
config_sound; %defaults

%================
% START COGENT
start_cogent	        
%================

%% load the movie into sprite 1
cgopenmovie(1,'movie.avi')
%%  play whatever movie is in sprite 1
%  cgplaymovie(1) 

%% %Position and scale the movie
cgalign('r','b') % set alignment mode to right, bottom (e.g. bottom right is now 0,0)
cgplaymovie(1,0,0,320,240); % play the movie in buffer 1 again, but scale the size


cgalign('l','b') % set the alignment mode to left, bottom (e.g. bottom left is now 0,0)
cgplaymovie(1,0,0,-320,240); % and make the width parameter negative to flip the movie

cgalign('r','t') % set the alignent mode to right, top (e.g. top right is now 0,0)
cgplaymovie(1,0,0,320,-240) % flip the movie vertically

cgalign('l','t') % set alignment mode to left top
cgplaymovie(1,0,0,-320,-240) % flip the movie vertically and horizontally

%%
cgshutmovie(1); % free up the memory holding the movie
%%
%================
% STOP COGENT
stop_cogent	        
%================

