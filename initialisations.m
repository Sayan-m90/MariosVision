Back=imread('scene2.png');
Cl1 = imread('cloud1.png');
Cl2 = imread('cloud2.png');
%M1 =  imread('mountains.png');
Q1 = imread('question.jpg');
Q2 = imread('question2.jpg');
P1 = imread('pipe.png');
MS = imread('marioStand.png');
MJ = imread('mario-jump.jpg');
MC = imread('marioCrouch.png');
MG = imread('marioShoot.png');
OV = imread('over.png');
TL = imread('turtle.png');
EX = imread('Explosion.png');
END = imread('over.png');
[h,w] = size(Cl1);
%[y,f]=audioread('mario-theme.mp3');
[y,f]=audioread('mario-theme.mp3');
player = audioplayer(y,f);
[y1,f1]=audioread('mario-jump.mp3');
playerj = audioplayer(y1,f1);
[y2,f2]=audioread('mario-exp.mp3');
playerexp = audioplayer(y2,f2);
[y3,f3]=audioread('mario-crouch.mp3');
playercrouch = audioplayer(y3,f3);
[y4,f4]=audioread('mario-end.mp3');
playerend = audioplayer(y4,f4);