% TMS-based script
fprintf ( 1, '\n' );
fprintf ('Script active\n' );

backgroundcolor = 128;  
screenid = max(Screen('Screens'));

% Open fullscreen onscreen window on that screen. Background color is
% gray, double buffering is enabled. Return a 'win'dowhandle and a
% rectangle 'winRect' which defines the size of the window:
[win, winRect] = Screen('OpenWindow', screenid, backgroundcolor);
Screen(win,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);


Screen('TextSize',win, 35);
Screen('TextStyle', win, 1);
DrawFormattedText(win, 'Press Space to Start Scene Categorization', 'center', 'center', 0);
Screen('Flip', win);
%% response collection

while 1
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyIsDown
        DrawFormattedText(win, 'Beginning', 'center', 'center', 0);
        Screen('Flip', win);
        break;
    end
end 

if button1
    if choice == image
        %write to text file "Answer #x is correct
    else
        %write to text file *Answer #x is incorrect
    screenImage + 1 = image; 
    
elseif button2
elseif button3
elseif button4




%Documentations Stuff

% this is short bit of matlab + ptb code to show an image on screen
% Note: you have to supply your own image 'example.jpg' in the same directory

clear all;

try
    commandwindow;
    myimgfile='example.jpg';
    nr=max(Screen('Screens'));
    [w, screenRect]=Screen('OpenWindow',nr, 0,[],32,2); % open screen
    ima=imread(myimgfile, 'jpg');
    
    Screen('PutImage', w, ima); % put image on screen
    Screen('Flip',w); % now visible on screen
    while KbCheck; end % clear keyboard queue
    while ~KbCheck; end % wait for a key press
    Screen('CloseAll'); % close screen
catch
    %this "catch" section executes in case of an error in the "try" section
    %above.  Importantly, it closes the onscreen window if its open.
    Screen('CloseAll');
    rethrow(lasterror);
end %try..catch..
