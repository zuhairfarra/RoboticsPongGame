function pong_basic
%Modified the pong code by David Buckingham
%https://www.mathworks.com/matlabcentral/fileexchange/31177-dave-s-matlab-pong

%%%%%% main part of the code %%%
global game_over

close all
initData  %first function, initialize the data variables
initFigure %second function, initialize the figure
while ~game_over %runs till game_over = 1
    moveBall; %third function, compute ball movement including collision detection
    movePaddle; %fourth function, compute paddle position based on user input. 
    refreshPlot; %fifth function, refresh plot based on moveBall and movePaddle
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function initData %first function, initialize the data variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global PADDLE_WIDTH BALL_SIZE 
global BALL_INIT_VX BALL_INIT_VY DT DELAY
global PADDLE_VX PADDLE_SPEED PADDLE_VY
global game_over level flag
global chimp_x chimp_y counter
global chimp_x_min chimp_x_max chimp_y_min chimp_y_max

level = 0;
game_over = 0;
WALL_X_MIN = 0;
WALL_X_MAX = 100;
WALL_Y_MIN = 0;
WALL_Y_MAX = 100;
PADDLE_WIDTH = 20;
BALL_SIZE = 10;
BALL_INIT_VX = 4;
BALL_INIT_VY = -2;
PADDLE_VX = 0;
PADDLE_VY = 0;
PADDLE_SPEED = 10; 
DT = 0.1; 
DELAY = 0.001;
flag = 0;
chimp_x = [50 60];
chimp_y = [50 60];
chimp_x_min = chimp_x(1)-10;
chimp_y_min = chimp_y(1)-10;
chimp_x_max = chimp_x(1)+10;
chimp_y_max = chimp_y(1)+10;
counter = 0.1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function initFigure %second function, initialize the figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_WIDTH BALL_SIZE 
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global BALL_INIT_VX BALL_INIT_VY
global ball_x ball_y ball_vx ball_vy 
global paddle_x_left paddle_x_right paddle_y
global ball_anim paddle_anim
global level I

fig = figure; %initialize the figure
set(fig, 'Resize', 'off'); %do not allow figure to resize
set(fig,'KeyPressFcn',@keyDown); %setkey presses for later
ball_x = 0.5*(WALL_X_MIN+WALL_X_MAX); 
ball_y = WALL_Y_MAX;
ball_vx = BALL_INIT_VX; 
ball_vy = BALL_INIT_VY;
paddle_x_left = 0;
paddle_x_right = PADDLE_WIDTH;
paddle_y = 10;
axis([WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX]); %set the size of the board.
axis manual;
hold on;
title(['press keys <left/right> to move the paddle; level = ',num2str(level)],'Fontsize',14);
set(gca, 'color', 'w', 'YTick', [], 'XTick', []); %remove x and y label

%%%%%%% set the ball and paddle %%%%%%
ball_anim = plot(ball_x,ball_y,'o','Markersize',BALL_SIZE,'Markerfacecolor','r','Markeredgecolor','r'); %create ball
paddle_anim = line('Xdata',[paddle_x_left paddle_x_right],'Ydata',[paddle_y paddle_y],'Color','g','Linewidth',5); %paddle

I = imread('daChimp.jpg');

%%%%%%%% set the walls %%%%%%%
line('Xdata',[WALL_X_MIN WALL_X_MIN],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','k','Linewidth',3); %left wall
line('Xdata',[WALL_X_MIN WALL_X_MAX],'Ydata',[WALL_Y_MAX WALL_Y_MAX],'Color','k','Linewidth',3); %top wall
line('Xdata',[WALL_X_MAX WALL_X_MAX],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','k','Linewidth',3); %right wall


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function moveBall %third function, compute ball movement including collision detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ball_x ball_y ball_vx ball_vy  DT ex ey
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global paddle_x_left paddle_x_right paddle_y
global game_over flag
global chimp_x_min chimp_x_max chimp_y_min chimp_y_max
global counter

ball_x = ball_x + ball_vx*DT;
ball_y = ball_y + ball_vy*DT;

if ex < 1.1
    ex = -1-counter;
    ey = -1-counter;
end

if ((ball_x < WALL_X_MIN || ball_x > WALL_X_MAX) && abs(ball_vx) < 30)
    disp('Ball collision detected');
    ball_vx = ball_vx*ex;
    counter = counter + 0.1;
    
elseif ((ball_y > WALL_Y_MAX || (ball_y < paddle_y && paddle_x_left<ball_x && ball_x<paddle_x_right)) && abs(ball_vy) < 30)
    disp('Ball collision detected');
    ball_vy = ball_vy*ey;
    counter = counter + 0.1;
    
else
    disp(['Ball Position is ',num2str(ball_x)]);
end

ball_vx
ball_vy

if (flag == 0)
    if (ball_x > 40 && ball_x < 60 && ball_y > 40 && ball_y < 60)
        ball_vx = -1.1*ball_vx;
        ball_vy = -1.1*ball_vy;
        flag = 1;
    end
end

%%%%%%%% Basic pong edit #1: %%%%%%%%%%%%
% Write code to move the ball here. You code will include logic to get the ball to 
% detect the left, right, and top wall and the paddle and subsequently to change its
% movement based on which wall/paddle the ball hits.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (ball_y < WALL_Y_MIN)
     GameOver = imread('GameOver.png');
     hold on;
     image([-45 10]+70, [45 10]+50, GameOver);
     pause(1);
     game_over = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function movePaddle %fourth function, compute paddle position based on user input. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_VX PADDLE_VY
global PADDLE_WIDTH DT
global paddle_x_left paddle_x_right paddle_y
global WALL_X_MIN WALL_X_MAX

PADDLE_VX = 0;
PADDLE_VY = 0;

if (paddle_x_left == WALL_X_MIN || paddle_x_right == WALL_X_MAX)
    PADDLE_VX = 0;
    disp('Paddle collision detected');
end

if (paddle_y < 5 || paddle_y > 50)
    PADDLE_VY = 0;
end

%%%%%%%% Basic pong edit #2: %%%%%%%%%%%%
% Write code to move the paddle here. Your code will include logic to get
% the paddle to detect the left and right wall and to avoid it from
% penetrating either walls. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function refreshPlot %fifth function, refresh plot based on moveBall and movePaddle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ball_x ball_y
global ball_anim paddle_anim
global paddle_x_left paddle_x_right paddle_y
global DELAY flag I J chimp_x chimp_y

if (flag == 0)
    hold on
    J = image([10 -10]+chimp_x(1), [10 -10]+chimp_y(1), I);
% elseif (flag == 1)
%     hold off
%     J = image([10 -10]+chimp_x(2),[10 -10]+chimp_y(2),I);
%     hold on
end

set(ball_anim, 'XData', ball_x, 'YData', ball_y);
set(paddle_anim, 'Xdata',[paddle_x_left paddle_x_right], 'YData', [paddle_y paddle_y]);
drawnow;
pause(DELAY);   


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function keyDown(src,event) %called from initFigure to take key press to move the paddle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_VX PADDLE_SPEED PADDLE_VY
global PADDLE_WIDTH DT
global paddle_x_left paddle_x_right paddle_y

switch event.Key
  case 'rightarrow'
    PADDLE_VX = 1.75*PADDLE_SPEED;
  case 'leftarrow'
    PADDLE_VX = -1.75*PADDLE_SPEED;
  case 'uparrow'
    PADDLE_VY = 1.75*PADDLE_SPEED;
  case 'downarrow'
    PADDLE_VY = -1.75*PADDLE_SPEED;
  otherwise
    PADDLE_VX = 0;
    PADDLE_VY = 0;   
end

paddle_x_left = paddle_x_left + PADDLE_VX*DT;
paddle_x_right = paddle_x_left + PADDLE_WIDTH;
paddle_y = paddle_y + PADDLE_VY*DT;

