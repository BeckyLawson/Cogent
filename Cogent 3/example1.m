
% Generate a sprite & present at several locations
% sprite 1 : draw an eye using a mixture of filled ellipses
% sprite 2: draw sprite 1 four times in different locations.

% Display sprite 1, wait for 4 seconds
% Display a blank screen for 4 seconds
% Display sprite 2 for 4 seconds

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

% Make sprite 1
cgmakesprite(1,160,80,[0,0,0]); % make a sprite that's 160x80 pixels in size, colour green (0,1,0)
cgsetsprite(1);% set the sprite to write into it
%==============
%%Start drawing
%=============
cgpencol(1,1,1) %change the pen colour to white
cgellipse(0,0,150,70,'f') % draw a filled ellipse, centred on the screen with width 150x70pix
cgpencol(0,0,1) %change the pen colour to blue
cgellipse(0,0,70,70,'f') %draw filled circle with diameter 70 pix
cgpencol(0,0,0) %change the pen colour to black
cgellipse(0,0,20,20,'f') %draw a filled circle with diameter 20 pix
cgpencol(1,0,0) %change the pen colour to red
cgpenwid(10) %and the pen width to 10 pix
cgellipse(0,0,150,70) % and draw a hollow ellipse with same dimensions as the first ellipse;


cgsetsprite(0); %select the offscreen area (sprite #0)
%Then draw sprite 1 into the offscreen area 
cgdrawsprite(1,0,0);
cgflip; % display the sprite
wait(4000); % wait 4 seconds

%==================
% Blank screen for 4 seconds
cgflip (0,0,0); % display the blank offscreen area
wait(4000); % wait 4 seconds
%==================


% make sprite 2, the same size as the screen
cgmakesprite(2,640,480);
% set the sprite to write into it
cgsetsprite(2);

%==============
%%Start drawing
%==============

% %draw sprite 1 in 4 different locations in sprite 2
% cgdrawsprite(spriteno, xpos, ypos, width, height)
cgdrawsprite(1,-160,120); % top right
cgdrawsprite(1,160,120); % top left
cgdrawsprite(1,-160,-120); % bottom right
cgdrawsprite(1,160,-120); % bottom left


%%select the offscreen area (sprite #0)
cgsetsprite(0);
%draw sprite 2 in the off screen area
%cgdrawsprite(2,0,0,640,480); 
cgrotatesprite(2,0,0,20); %option to rotate the sprite

cgflip; % display the sprite
wait(4000); % wait 4 seconds

%================
% STOP COGENT
stop_cogent;