%% Snake Localizer

function [FOSS] = runLocalizer2(sub, cbl, acq)
%% Start me up
clc
FOSS.curDir = cd;
if isempty(sub); FOSS.subID = input('\nPlease Enter Your Participant Code #: ', 's'); else FOSS.subID = sub; end;
if isempty(cbl); FOSS.run =  input('\nPlease Enter The Run #: ', 's'); else  FOSS.run = cbl; end;
if isempty(acq); FOSS.acq =  input('\nPlease Enter The Aquisition #: ', 's'); else  FOSS.acq = acq; end;
PATH = fullfile(FOSS.curDir, sprintf('FOSS_S%d_R%d_A%d.mat', FOSS.subID, FOSS.run, FOSS.acq));
save(PATH);
if ~exist(PATH);
    [Path, File] = uigetfile('*.mat', 'Select .MAT with RS');
    PATH = fullfile(Path, File);
end
load(PATH);

pause(.8)
disp('Scene Localizer, v2.0')
pause(.7)
disp('  Version 2.10')
disp('  Nov. 20, 2013')
pause(.4)
disp('Script Written by Sam Weiller & Freddy Kamps')
pause(3)
clc

%% Control Panel
fprintf('Looking for stimuli...\n')
if exist('localizerStimuli.mat')
    load localizerStimuli.mat
    fprintf('Stimuli loaded!\n');
else
    disp('Please run makeStims first.');
    return;
end;

%stimSize = 400;
numStimSets = size(STIMS,2);
imgsPerSet = size(STIMS{1},2);
numBlocks = 21;
secsPerBlock = 16;
numConditions = 5;
numberOfVolumes = numBlocks.*secsPerBlock;
imagesPerBlock = 20;
numberOfTargets = 2;
fixationTime = 15.98;
stimPresentTime = .3;
whiteSpaceTime = .5;
KbName('UnifyKeyNames');
targetKey = KbName('b');
escapeKey = KbName('p');
triggerKey = KbName('t');
screens = Screen('Screens');
screenNumber = min(screens);
screenWidth = 412.75;
viewingDistance = 920.75;
visualAngle = 8;

designs = [...
    0 1 2 3 4 0 3 1 4 2 0 2 4 1 3 0 4 3 2 1 0;
    0 2 1 4 3 0 1 2 4 3 0 3 4 2 1 0 3 4 1 2 0;
    0 3 4 2 1 0 2 3 1 4 0 4 1 3 2 0 1 2 4 3 0;
    0 4 1 3 2 0 4 2 3 1 0 1 3 2 4 0 2 3 1 4 0;
    ];

for i = 1:11
    ANSMAT{i} = zeros(20,5);
end;

UserAns = 0;
touch = 0;

%% Parameters
%  Use this section to hard-code parameters for a given localizer. If
%  running a one-time test, consider using Easy Mode by changing the
%  variable 'easyMode' above to 1.

% numTargets = 5;
% numBlocks = numStimSets;
% randperm(numBlocks);
% for blocks = 1:numBlocks % Define the Target Trials
%     for sets = 1:numStimSets
%         targets{blocks}{sets} = randperm(imgsPerSet-1, numTargets)+1;
%     end;
% end;

% condition = randperm(numStimSets);
% reverse = fliplr(condition);
condition = designs(cbl, :);

% for run = 1:numBlocks
%     for set = 1:numStimSets
%         protocol.run(run).set(set).images = randperm(imgsPerSet);
%     end;
% end;

% Quick Calculate Visual Angle
%
%    PPD = quickCalculateVisualAngle(screenNumber, screenWidth, viewingDistance)
%
%    This function calculates visual angle based on screen width and viewing
%    distance and produces the pixels per degree for your given situation.
%
%    Your screen number is zero if you are only using one monitor.
%    Screen width and viewing distance must be entered in millimeters.
res = Screen('Resolution', screenNumber);
resWidth = res.width;

PPD = tand(.5).*2.*viewingDistance.*(resWidth./screenWidth);
visualAngle = PPD*visualAngle;
stimSize = visualAngle;

%% PTB Setup
Screen('Preference', 'SkipSyncTests', 2);
[w rect xMid yMid] = startPTB(screenNumber, 1, [128 128 128]);
HideCursor;
%% Create Stimuli & Preallocate
for set = 1:numStimSets
    for img = 1:imgsPerSet
        %Making the cell array
        tex{set}{img} = Screen('MakeTexture', w, STIMS{set}{img});
    end;
end;

DrawFormattedText(w, 'Waiting for trigger...', 'center', 'center');
Screen('DrawText', w, ['NUMBER OF VOLUMES :: ' num2str(numberOfVolumes)], 10, 15*rect(4)/16, rect(3));
Screen('Flip', w);
trigger(triggerKey);
Screen('Flip', w);
%% Main Loop
absTime = GetSecs;
TIME.s = GetSecs;
TIMER.init = GetSecs;
for blocks = 1:numBlocks
%     beep;
    if condition(blocks) == 0
        tempCov = 5;
        TIMER.block(blocks).start = GetSecs - TIMER.init;
        TIME_MAT(blocks, 1) = tempCov;
        TIME_MAT(blocks, 2) = GetSecs - TIMER.init;
        fixate(w);
        WaitSecs(fixationTime);
        TIMER.block(blocks).end = GetSecs - TIMER.init;
        TIMER.block(blocks).length = TIMER.block(blocks).end - TIMER.block(blocks).start;
        TIME_MAT(blocks, 3) = (GetSecs - TIMER.init) - TIME_MAT(blocks, 2);
        TIME_MAT(blocks, 4) = 1;
    else
        TIME.innerblock(blocks, 1) = GetSecs-TIME.s;
        sanityCheck = GetSecs - absTime;
        disp('Block Start:');
        disp(sanityCheck);
        
        TIMER.block(blocks).start = GetSecs - TIMER.init;
        TIME_MAT(blocks, 1) = condition(blocks);
        TIME_MAT(blocks, 2) = GetSecs - TIMER.init;
        
        TIME.innerblock(blocks, 2) = GetSecs-TIME.s;
        imageMatrix = randsample(imgsPerSet, imagesPerBlock);
        moveon = 0;
        while moveon ~= 1
            targets = randsample(imagesPerBlock-1, numberOfTargets);
            if abs(targets(1) - targets(2)) > 1
            moveon = 1;
            end;
        end;
        moveon = 0;
        
        for ind = 1:size(targets,1)
            imageMatrix(targets(ind)+1) = imageMatrix(targets(ind)); %plants target for 1-back at a random
        end;
        TIME.innerblock(blocks, 3) = GetSecs-TIME.s;
        for trials = 1:imagesPerBlock
            TIME.innerloop(trials, 1) = GetSecs-TIME.s;
            startTrial = GetSecs - absTime;
            startCorrect = GetSecs;
            %Draw cell array
            Screen('DrawTexture', w, tex{condition(blocks)}{imageMatrix(trials)}, [], [xMid-(stimSize/2) yMid-(stimSize/2) xMid+(stimSize/2) yMid+(stimSize/2)]);
            Screen('Flip', w);
            correctionTime = GetSecs - startCorrect;
            TIME.innerloop(trials, 2) = GetSecs-TIME.s;
            tic;
            while toc < stimPresentTime   %checks for keypress during stim presentation
                [touch, secs, keyCode] = KbCheck(-1);
                if touch && ~keyCode(triggerKey)
                    UserAns = find(keyCode);
                    break;
                end;
            end;
            TIME.innerloop(trials, 3) = GetSecs-TIME.s;
            WaitSecs(stimPresentTime - toc);
            TIME.innerloop(trials, 4) = GetSecs-TIME.s;
            tic;
            Screen('Flip', w);
            if touch == 0
                while toc < whiteSpaceTime-correctionTime   %checks for keypress in fixation immediately following stim pres up until next stim pres.
                    [touch, secs, keyCode] = KbCheck(-1);
                    if touch && ~keyCode(triggerKey)
                        UserAns = find(keyCode);
                        break;
                    end;
                end;
            end;
            TIME.innerloop(trials, 5) = GetSecs-TIME.s;
            WaitSecs(whiteSpaceTime-correctionTime - toc);
            TIME.innerloop(trials, 6) = GetSecs-TIME.s;
            
            ANSMAT{blocks}(trials,1) = condition(blocks); %condition number
            ANSMAT{blocks}(trials,2) = imageMatrix(trials); %trial number
            ANSMAT{blocks}(trials,3) = ~isempty(find(targets == (trials-1))); %is it a target
            if UserAns == targetKey
                ANSMAT{blocks}(trials,4) = 1; %did they respond?
            elseif UserAns == escapeKey;
                FOSS.ANSMAT = ANSMAT;
                save(PATH, 'FOSS', 'onsetTimes');
                Screen('CloseAll');
                return;
            else
                ANSMAT{blocks}(trials,4) = 0;
            end;
            if ANSMAT{blocks}(trials,3) == ANSMAT{blocks}(trials,4)
                ANSMAT{blocks}(trials,5) = 1; %correct?
            else
                ANSMAT{blocks}(trials,5) = 0;
            end;
            
            onsetTimes{blocks}(trials,1) = condition(blocks);
            onsetTimes{blocks}(trials,2) = startTrial;
            onsetTimes{blocks}(trials,3) = GetSecs - absTime;
            UserAns = 0;
            TIME.innerloop(trials, 7) = GetSecs-TIME.s;
        end;
        TIME.innerblock(blocks, 4) = GetSecs-TIME.s;
        
        onsetTimes{blocks}(trials,4) = GetSecs;
        FOSS.ANSMAT = ANSMAT;
        TIMER.block(blocks).end = GetSecs - TIMER.init;
        TIMER.block(blocks).length = TIMER.block(blocks).end - TIMER.block(blocks).start;
        TIME_MAT(blocks, 3) = (GetSecs - TIMER.init) - TIME_MAT(blocks, 2);
        TIME_MAT(blocks, 4) = 1;
        save(PATH, 'FOSS', 'TIME', 'TIMER');
        sanityCheck = GetSecs - absTime;
        disp('Block End:');
        disp(sanityCheck);
        TIME.innerblock(blocks, 5) = GetSecs-TIME.s;
    end
end;
fixate(w);
% WaitSecs(fixationTime);
Screen('Flip', w);
endend = GetSecs;
totalTime = endend - absTime
TIME.e=GetSecs-TIME.s;


%% Logging & Cleanup
FOSS.ANSMAT = ANSMAT;
save(PATH, 'FOSS', 'onsetTimes', 'TIME', 'TIMER', 'TIME_MAT');


% Create Covariate Files
cnt = [1 1 1 1 1];

for i = 1:numBlocks
    
    switch TIME_MAT(i, 1) %condition no
        case 1 % Faces
            COVAR{1}(cnt(1), :) = TIME_MAT(i, 2:4);
            cnt(1) = cnt(1) + 1;
        case 2 % Objects
            COVAR{2}(cnt(2), :) = TIME_MAT(i, 2:4);
            cnt(2) = cnt(2) + 1;
        case 3 % ObjectsScram
            COVAR{3}(cnt(3), :) = TIME_MAT(i, 2:4);
            cnt(3) = cnt(3) + 1;
        case 4 % Places
            COVAR{4}(cnt(4), :) = TIME_MAT(i, 2:4);
            cnt(4) = cnt(4) + 1;
        case 5 % Fixation
            COVAR{5}(cnt(5), :) = TIME_MAT(i, 2:4);
            cnt(5) = cnt(5) + 1;
    end;
end

for j = 1:5
    dlmwrite(sprintf('FOSS_Sub0%d_Run%d_Cov%d.txt', sub, cbl, j), COVAR{j}, 'delimiter', '\t', 'precision', 4);
end;

% for i = 1:7
%     TIME_MAT(FOSS.ANSMAT{i}(1,1)).data(1,:) = [TIMER.block(i).start TIMER.block(i).length 1];
% end
% for i = 8:14
%     TIME_MAT(FOSS.ANSMAT{i}(1,1)).data(2,:) = [TIMER.block(i).start TIMER.block(i).length 1];
% end
% for i = 1:numConditions
%     
%     dlmwrite(sprintf('FOSS_Sub0%d_Run%d_Cov%d.txt', sub, cbl, cov), TIME_MAT(i).data, 'delimiter', '\t', 'precision', 6);
%     
% end


%% Shutdown Procedures
ShowCursor;
Screen('CloseAll');



function [w rect xc yc] = startPTB(screenNumber, oGl, color)

if nargin == 0
    oGl = 0;
    color = [0 0 0];
elseif nargin == 1;
    color = [0 0 0];
end;

[w rect] = Screen('OpenWindow', screenNumber, color);
xc = rect(3)/2;
yc = rect(4)/2;

if oGl == 1
    AssertOpenGL;
    Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, [1 1 1 1]);
end;

function fixate(w)
Screen('TextSize', w, 40);
DrawFormattedText(w, '+', 'center', 'center', [200 200 200]);
Screen('TextSize', w, 25);
Screen('Flip', w);

function flipNwait(w)
Screen('Flip', w);
WaitSecs(.3);
KbCheck(-1);

function trigger(triggerKey)
KbName('UnifyKeyNames');

touch = 0;
go = 0;
while go == 0
    [touch, secs, keyCode] = KbCheck(-1);
    WaitSecs(.0001);
    if touch && keyCode(triggerKey)
        go = 1;
    end;
end;
