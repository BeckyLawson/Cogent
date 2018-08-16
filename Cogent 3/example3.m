%generate a stimulus array using Matlab (Red, Green and Blue);
%load that array into Cogent and get Cogent to display it


clear; clc; %clear anything that might be lying around in the workspace
%====================================================================
% CONFIG COGENT
config_display(0, 1, [0 0 0])
% 0 = window, 1 = full screen, 2 = 2nd screen
% 640 x 480
% black screen background

%================
% START COGENT
start_cogent	        
%================

%set up some variables for attributes of our array
spriteno = 1;  % sprite no
w = 10; 	   % image width (px)
h = 10;	       % image height (px)
dispsize = 50;
num=1:w;

%These three arrays (red, green and blue) determine what the stimulus will look like
% arrayR   =  ones(w); 	% set all red guns to 1
% arrayG   = zeros(w) ;	% set all green guns to 0
% arrayB   = zeros(w) ;	% set all blue guns to 0 

arrayR   = rand(w); 		            % randomly assign red
arrayG   = repmat([num']/w , [1,h]) ;	% columns graduated green
arrayB   = eye(w) ;		                % use full blue on diagonal

%This part concatenates the R,G,B arrays into a format that Cogent can read
array	= zeros(h*w, 3) ;	                	    % empty array matrix
array 	= ( [ arrayR(:) arrayG(:) arrayB(:) ] ) ;  	% 3 column format


cgsetsprite(0);                     %select sprite 0 (for drawing on to)
cgloadarray(spriteno,w,h,array);	% load the array into sprite 1
cgdrawsprite(spriteno,0,0,dispsize,dispsize); % draw sprite 1 off screen (on sprite 0), resize
cgflip(0,0,0); % present it
wait(4000);  % wait 4 seconds



%-- STOP COGENT ---
stop_cogent;
% ---------------