
% Load a bitmap on to a sprite and amend it using cg commands
% sprite 1 : draw David Camerons daft face
% sprite 2: draw an egg (or eggs) 

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

%% DRAW THE IMAGE - maintain image size
% cgloadbmp(1,'c.bmp')  %load 'c1.bmp' into sprite 1
% cgsetsprite(0);        %select sprite 0   (for drawing on to)
% cgdrawsprite(1,0,0)    %draw sprite 1 off screen (on sprite 0)
% cgflip(0,0,0)          %present it
% wait(4000)             %wait 4 seconds

% %% DRAW THE IMAGE - scale to size of screen
% cgloadbmp(1,'c.bmp',640,480);  %load 'c1.bmp' into sprite 1, scale to fit screen
% cgsetsprite(0);                 %select sprite 0  
% cgdrawsprite(1,0,0)             %draw sprite 1 off screen (on sprite 0)
% cgflip(0,0,0)                   %present it
% wait(4000);                     %wait 4 seconds

%% DRAW A SECOND IMAGE AND LAYER ON TOP
% cgloadbmp(1,'c.bmp',640,480);  %load 'c1.bmp' into sprite 1, stretch to fit screen
% cgloadbmp(2,'redegg.bmp');      %load 'redegg.bmp' into sprite 2 
% cgsetsprite(0);                 %select sprite 0  
% cgdrawsprite(1,0,0)             %draw sprite 1 off screen (on sprite 0)
% cgdrawsprite(2,0,0)             %draw sprite 2 off screen (also on sprite 0)
% cgflip(0,0,0)                   %present it
% wait(4000);                     %wait 4 seconds 

% %% DRAW BOTH IMAGES AND MAKE THE RED PARTS OF IMAGE 2 TRANSPARENT
% cgloadbmp(1,'c.bmp',640,480);
% cgloadbmp(2,'redegg.bmp');
% cgsetsprite(0);                
% cgtrncol (2,'r') %make the red parts of sprite 2 transparent
% cgdrawsprite(1,0,0);
% %cgdrawsprite(2,0,0);
% cgrotatesprite(2,0,0,90); % draw and rotate sprite 2 off screen (on sprite 0)
% cgflip(0,0,0);
% wait(4000);

% %% Draw 20 of sprite 2 and position randomly on top of sprite 1
x = rand(1,20)*640 - 320;   %an array of 20 random values from -320 to 320
y = rand(1,20)*480 - 240;   %an array of 20 random values from -240 to 240
cgloadbmp(1,'c.bmp',640,480);
cgloadbmp(2,'redegg.bmp',100,100); % scale to be 100*100
cgsetsprite(0);                 
cgtrncol (2,'r')
cgdrawsprite(1,0,0)
 for i=1:20;          %loop to draw sprite 2, 20 times (according to x and y)
 cgdrawsprite(2,x(i),y(i))
 end
cgflip(0,0,0);
wait(4000);


% -- STOP COGENT----
stop_cogent;
%----------