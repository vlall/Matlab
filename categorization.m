function [CAT] = newold(sub)

CAT.curDir = cd; 

% Categoization script Draft
global rootDir
rootDir = pwd;
fprintf ('Script active\n' );


disp('runLocalizer, v1.0')
pause(.7)
disp('  Version 1.0')
disp('  June. 2, 2014')
pause(.4)
disp('Script Written by Vishal Lall')
pause(3)

%% Control Panel
fprintf('Looking for stimuli...\n');
if exist('sceneStim.mat')
    load masks.mat;
    load sceneStim.mat;
    fprintf('Stimuli loaded!\n');
else
    disp('Please run makeStims first.');
    return;
end;

%KeyBoard Variabls
KbName('UnifyKeyNames');
%%%%%targetKey = KbName('b');
escapeKey = KbName('q');
triggerKey = KbName('t');
butOne = KbName('1!');
butTwo = KbName('2@');
butThree = KbName('9(');
butFour = KbName('0)');

%View Variables
screens = Screen('Screens');
screenNumber = min(screens);
screenWidth = 412.75;
viewingDistance = 920.75;
visualAngle = 8;

%Answer Variables
correct=0;
incorrect=0;

% Matrix for experiment, randomly generated by doing: 
% foo(:,1)=1:256;
% foo(:,2)=[1:64 1:64 1:64 1:64];
% foo(:,3)=mod(randperm(256),4)+1;
% foo(:,4)=randperm(256);
% foo(1:64,3)=1;
% foo(65:128,3)=2;
% foo(129:192,3)=3;
% foo(193:256,3)=4;
% sortrows(foo,4)
design = [...
   164    36     3     1;
   141    13     3     2;
   110    46     2     3;
    72     8     2     4;
   126    62     2     5;
   197     5     4     6;
   198     6     4     7;
   150    22     3     8;
   192    64     3     9;
   168    40     3    10;
    30    30     1    11;
   127    63     2    12;
    85    21     2    13;
    24    24     1    14;
    36    36     1    15;
    51    51     1    16;
   174    46     3    17;
   106    42     2    18;
   178    50     3    19;
    62    62     1    20;
     3     3     1    21;
   134     6     3    22;
    69     5     2    23;
   237    45     4    24;
   229    37     4    25;
    95    31     2    26;
     6     6     1    27;
   172    44     3    28;
   215    23     4    29;
   248    56     4    30;
    12    12     1    31;
   113    49     2    32;
   153    25     3    33;
   177    49     3    34;
   185    57     3    35;
   169    41     3    36;
   188    60     3    37;
    89    25     2    38;
   152    24     3    39;
    29    29     1    40;
    13    13     1    41;
   251    59     4    42;
    70     6     2    43;
   158    30     3    44;
   242    50     4    45;
    44    44     1    46;
    47    47     1    47;
    84    20     2    48;
   235    43     4    49;
    94    30     2    50;
    66     2     2    51;
    37    37     1    52;
    98    34     2    53;
    90    26     2    54;
    32    32     1    55;
   109    45     2    56;
    23    23     1    57;
   161    33     3    58;
     4     4     1    59;
   148    20     3    60;
   204    12     4    61;
    58    58     1    62;
   112    48     2    63;
   146    18     3    64;
    16    16     1    65;
   123    59     2    66;
   166    38     3    67;
    55    55     1    68;
   214    22     4    69;
   247    55     4    70;
   218    26     4    71;
   128    64     2    72;
    68     4     2    73;
   191    63     3    74;
    59    59     1    75;
   241    49     4    76;
   163    35     3    77;
   160    32     3    78;
    40    40     1    79;
    22    22     1    80;
    60    60     1    81;
   221    29     4    82;
   232    40     4    83;
   179    51     3    84;
   186    58     3    85;
    56    56     1    86;
   149    21     3    87;
   209    17     4    88;
   100    36     2    89;
   252    60     4    90;
    21    21     1    91;
    80    16     2    92;
   129     1     3    93;
    14    14     1    94;
   187    59     3    95;
   143    15     3    96;
   132     4     3    97;
   213    21     4    98;
   222    30     4    99;
   202    10     4   100;
    78    14     2   101;
   115    51     2   102;
   194     2     4   103;
    27    27     1   104;
    26    26     1   105;
    65     1     2   106;
   131     3     3   107;
   249    57     4   108;
   182    54     3   109;
    77    13     2   110;
    73     9     2   111;
   219    27     4   112;
   233    41     4   113;
   165    37     3   114;
    61    61     1   115;
    20    20     1   116;
   216    24     4   117;
   155    27     3   118;
   239    47     4   119;
    15    15     1   120;
   154    26     3   121;
    71     7     2   122;
   212    20     4   123;
    46    46     1   124;
   111    47     2   125;
    96    32     2   126;
   211    19     4   127;
   175    47     3   128;
    53    53     1   129;
    79    15     2   130;
    33    33     1   131;
   173    45     3   132;
   147    19     3   133;
    39    39     1   134;
    35    35     1   135;
   120    56     2   136;
   230    38     4   137;
   142    14     3   138;
     8     8     1   139;
    11    11     1   140;
   207    15     4   141;
   114    50     2   142;
    93    29     2   143;
   203    11     4   144;
    87    23     2   145;
   135     7     3   146;
   183    55     3   147;
   223    31     4   148;
    82    18     2   149;
   170    42     3   150;
   250    58     4   151;
    19    19     1   152;
   156    28     3   153;
   103    39     2   154;
    75    11     2   155;
    64    64     1   156;
   196     4     4   157;
   255    63     4   158;
    45    45     1   159;
   200     8     4   160;
    50    50     1   161;
   253    61     4   162;
   206    14     4   163;
   104    40     2   164;
   189    61     3   165;
   125    61     2   166;
   208    16     4   167;
    86    22     2   168;
    18    18     1   169;
   157    29     3   170;
   231    39     4   171;
    48    48     1   172;
   108    44     2   173;
   193     1     4   174;
     9     9     1   175;
   238    46     4   176;
   199     7     4   177;
   145    17     3   178;
    43    43     1   179;
   124    60     2   180;
   130     2     3   181;
   254    62     4   182;
   220    28     4   183;
   243    51     4   184;
   176    48     3   185;
    99    35     2   186;
   236    44     4   187;
   122    58     2   188;
    57    57     1   189;
    97    33     2   190;
   181    53     3   191;
   144    16     3   192;
   195     3     4   193;
   256    64     4   194;
   244    52     4   195;
   136     8     3   196;
   245    53     4   197;
    28    28     1   198;
    10    10     1   199;
    74    10     2   200;
   151    23     3   201;
   133     5     3   202;
   227    35     4   203;
   138    10     3   204;
   107    43     2   205;
   139    11     3   206;
   184    56     3   207;
     5     5     1   208;
   205    13     4   209;
    34    34     1   210;
   121    57     2   211;
    63    63     1   212;
    88    24     2   213;
   171    43     3   214;
    38    38     1   215;
    67     3     2   216;
    52    52     1   217;
    49    49     1   218;
    81    17     2   219;
   225    33     4   220;
   119    55     2   221;
   101    37     2   222;
    41    41     1   223;
   246    54     4   224;
   102    38     2   225;
   217    25     4   226;
   162    34     3   227;
    91    27     2   228;
   224    32     4   229;
   201     9     4   230;
   118    54     2   231;
   210    18     4   232;
   226    34     4   233;
   105    41     2   234;
    83    19     2   235;
   159    31     3   236;
   228    36     4   237;
   180    52     3   238;
    92    28     2   239;
   190    62     3   240;
   240    48     4   241;
   140    12     3   242;
   137     9     3   243;
    76    12     2   244;
    17    17     1   245;
    42    42     1   246;
    25    25     1   247;
   117    53     2   248;
     2     2     1   249;
   234    42     4   250;
   167    39     3   251;
     1     1     1   252;
     7     7     1   253;
    54    54     1   254;
   116    52     2   255;
    31    31     1   256; 
    ];

backgroundcolor = 128;  
screenid = max(Screen('Screens'));

%Timing Variables
fixTime = 2.0;
imageTime = .128;
maskTime = .5;


res = Screen('Resolution', screenNumber);
resWidth = res.width;

PPD = tand(.5).*2.*viewingDistance.*(resWidth./screenWidth);
visualAngle = PPD*visualAngle;
stimSize = visualAngle;
numStimSets = size(STIMS,2);
imgsPerSet = size(STIMS{1},2);
numStimSets2 = size(STIMS2,2);
imgsPerSet2 = size(STIMS2{1},2);

%% PTB Setup
Screen('Preference', 'SkipSyncTests', 2);
[w rect xMid yMid] = startPTB(screenNumber, 1, [128 128 128]);
HideCursor;
%% Create Stimuli & Preallocate
center = [xMid-(stimSize/2) yMid-(stimSize/2) xMid+(stimSize/2) yMid+(stimSize/2)];
for set = 1:numStimSets
    for img = 1:imgsPerSet
        %Making the cell array
        tex{set}{img} = Screen('MakeTexture', w, STIMS{set}{img});
    end;
end;

for set = 1:numStimSets2
    for img = 1:imgsPerSet2
        %Making the cell array
        tex{set}{img} = Screen('MakeTexture', w, STIMS2{set}{img});
    end;
end;

DrawFormattedText(w, 'Waiting for trigger...', 'center', 'center');
trigger(triggerKey);
Screen('Flip', w);


for i = 1:256
    % Fixate for w time
    tic
    fixate(w);
    WaitSecs(fixTime-toc);
    
    % Load image up by index # from design matrix, display it here for 128(stimTime) ms
    imageNum = design(i,2);
    category = design(i,3);
    tic;
    % Load (category, 'image_000' + imageNum + '.jpg');
    Screen('DrawTexture', w, tex{category}{imageNum}, [], [center] );
    Screen('Flip', w);
    WaitSecs(imageTime - toc);
    
    % Load mask up from random number between 1:8 and display it here for
    maskNum = rand(1,8);
    folderNum = 1;
    tic;
    % load (folderNum, 'image_000' + maskNum + '.jpg');
    Screen('DrawTexture', w, tex{folderNum}{maskNum}, [], center);
    Screen('Flip', w);
   	% 500(maskTime) ms.
    WaitSecs(maskTime - toc);
    
    % Display Text: "What Image did you see?" 
    Screen('TextSize',win, 35);
    Screen('TextStyle', win, 1);
    DrawFormattedText(win, 'Please indicate the image category you saw.', 'center', 'center', 0);
    % Allow response to be triggered by KeyIsDown translating to a scene
    % category in the Design Matrix.
    
    touch = 0;
    while ~touch
        [touch, ~, keyCode] = KbCheck(-1);
        if touch && ~keyCode(triggerKey)
            UserAns = find(keyCode);
            break;
        end;
    end;
    if UserAns == butOne
        choice = 1;
    elseif UserAns == butTwo
        choice = 2;
    elseif UserAns == butThree
        choice = 3;
    elseif UserAns == butFour
        choice = 4;
    end;
        
    if choice == category
        save (fprintf('Subject ID: %s\n Trial # %s \n Image Number:%s\n Subject Guess:%s\n Image Category:%s\n Answer is Correct!\n', sub, i, imageNum, choice, category))
        %write to text file "Answer #x is correct
        correct=correct+1;
    else
        save (fprintf('Subject ID: %s\n Trial # %s \n Image Number:%s\n Subject Guess:%s\n Image Category:%s\n Answer is Incorrect!\n', sub, i, imageNum, choice, category))
        incorrect=incorrect+1;

    % Log array to text file, along with answer information.
        save (fprintf('Correct:%d\n Incorrect:%d\n Elapsed Time:%d', correct,incorrect, endTIme));
    end;
    UserAns = 0 
end;    
    % Quit
    
%% Shutdown Procedures
ShowCursor;
Screen('CloseAll');



%% Sam's Functions


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
