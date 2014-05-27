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
 

  
