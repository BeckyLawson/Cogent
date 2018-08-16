% A function to run a full experiment using Cogent 2000.
% See lecture slides for details
% Rebecca Lawson November 2017
function [p ,results] = experiment(sub)
         % outputs:
         % p - parameters structure with all the predfined experiment
         % details for reference
         % results - a structre containing all the RTs to each image and
         % trial info for analysis
         % inputs:
         % sub - a subject ID (string)

%% Make sure random numbers are random
rand('state',sum(100*clock));% set random number generator

%% Initialise experiment variables
%first we are going to go through and set up all the important parameters
%for the experiment. We will save everything in a structure called 'p'
%which stands for parameters.

p.sub=sub;
%% Timing information (in ms)
p.timetowait=1000; 
%% Trial infromation
p.ntrials=8;
%% Stimulus Information
p.stim={'c1.bmp';'c2.bmp';'c3.bmp';'c4.bmp';'h1.bmp';'h2.bmp';'h3.bmp';'h4.bmp'}; 
p.stimtype=[0 0 0 0 1 1 1 1]; % make a vector representing whether it's a Tory or a Baddie 0=Tory, 1=Baddie
p.loc=[1 0 1 0 1 0 1 0]; %vector representing whether the image should be presented high=1 or low=-1;
p.h_loc=[0 100]; % the x and y positions of the high images
p.l_loc=[0 -100]; % the x and y positions of the low images

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

%% Give the participants some instructions
preparestring('Welcome to the experiment.',1,0,100);
preparestring('Your task is to decide whether each person',1,0,75);
preparestring('is a baddie from Star Wars',1,0,50);
preparestring('or a Tory in British government.',1,0, 25);

preparestring('Please press B for Baddie.',1,0,-25);
preparestring('Please press T for Tory.',1,0, -50);
preparestring('Press SPACE to continue.',1,0,-100);
drawpict(1); %present buffer 1
waitkeydown(Inf, 71); %waits forever until a key is pressed
clearpict(1) %clear buffer 1

preparestring('If you are correct you will hear',1,0,100);
preparestring('a high pitched tone.',1,0,75);
preparestring('If you are wrong you will hear',1,0,50);
preparestring('a low pitched tone.',1,0, 25);

preparestring('Please be as accurate as possible',1,0,-25);
preparestring('and respond to every image.',1,0,-50);
preparestring('Press SPACE to START.',1,0,-100);
drawpict(1); %present buffer 1
waitkeydown(Inf, 71); %waits forever until a key is pressed
clearpict(1) %clear buffer 1

%% Main Loop
for trial = 1:p.ntrials; % 8 trials 
    
    % -- Clear all buffers at start of trial --
    clearpict(1)
    clearpict(2); % Clear buffer 2 (for image presentation)                                                              
      
    
    % --  Prepare all stimuli in buffers --
    % Prepare buffer 1 (fixation cross)
    preparestring('+',1)
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
        response=0; %mark their response as 0 
        rt=nan; %mark their reaction time as 9999
    else %otherwise
        response=key(1); %their response is whatever key they pressed.
        rt=t(1)-stimonset; %and their reaction time is the time they pressed the button-the time the stimulus apprered
    end
    
    % record times and responses in struct called results
    results.image(trial,1)=p.randstim{trial,2}; %whether it was tory or baddie (1,0)
    results.resp(trial,1)=response; % which key they pressed
    results.rt(trial,1)=rt; % reaction time
    results.loc(trial, 1)=p.randstim{trial,4}; % whether it was presnted high or low (1,0)
   
   % -- feedback and log accuracy
   % if they pressed 'b' and it was a baddie OR pressed 't' and it was a Tory (ie. they were correct!)
   if response==2 &&  p.randstim{trial,2}==1 || response==20 &&  p.randstim{trial,2}==0;
       %log accuracy in results structure
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
    
  % Save the p and results structures on every trial
    %filename - subject ID entered input to the function
    save(p.sub, 'p', 'results');  
end
%% stop cogent
stop_cogent;


