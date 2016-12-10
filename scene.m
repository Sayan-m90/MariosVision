imagesc(Back);
hold on;
AnimCl1 = imagesc(Cl1);
AnimCl2 = imagesc(Cl2);
AnimQ1 = imagesc(Q1);
AnimP1 = imagesc(P1);
AnimMS = imagesc(MS);
AnimMJ = imagesc(MJ);
AnimMC = imagesc(MC);
ypos = get(AnimCl2, 'YData');
t1 = clock;
i = 0;
xposmario = [1,800]+ 1000;
xpos = get(AnimCl1, 'XData');
xpos = xpos + 5000;
%display(xpos);
%pause;
set(AnimMJ,'XData',xposmario,'YData',ypos+2050);    
set(AnimMS,'XData',xposmario,'YData',ypos+2750);
set(AnimMC,'XData',xposmario,'YData',ypos+2750);
set(gcf,'CurrentCharacter','@');
set(AnimMJ,'Visible','off');
set(AnimMC,'Visible','off');
jumpflag = false;   crouchflag = false;
finish = false;
return;
while(~finish)
%xpos = get(AnimCl1, 'XData');
k = get(gcf,'CurrentCharacter');    
if k ~= '@'
    if k=='q'
        finish=true; 
    end
    display('keystroke detected');
    if k == 's'
        tjump = clock;
        jumpflag =true;
        set(gcf,'CurrentCharacter','@');
        set(AnimMS,'Visible','off');
        set(AnimMJ,'Visible','on');
    elseif k == 'c'
        tcrouch = clock;
        crouchflag =true;
        set(gcf,'CurrentCharacter','@');
        set(AnimMS,'Visible','off');
        set(AnimMC,'Visible','on');
    end
end
if jumpflag == true
    tjump2 = clock;
    if etime(tjump2,tjump)>1.2
        jumpflag = false;
        tjump2 = 0;     tjump = 0;
        set(AnimMJ,'Visible','off');
        set(AnimMS,'Visible','on');
    end
elseif crouchflag == true
    tcrouch2 = clock;
    if etime(tcrouch2,tcrouch)>1.2
        crouchflag = false;
        tcrouch2 = 0;     tcrouch = 0;
        set(AnimMC,'Visible','off');
        set(AnimMS,'Visible','on');
    end
end
t2 = clock;
e = etime(t2,t1);
if(e>0.2)
    t1 = clock;
    t2 = clock;
    e = 0;
    i = i - 10;
    xpos = xpos + i; % shift right a bit
end


set(AnimCl2,'XData',xpos+500,'YData',ypos+600);
%pause(.01);
xpospipe(1) = xpos(1)-1200;
xposq(1) = xpos(1)+1200;
set(AnimCl1, 'XData', xpos);

set(AnimP1,'XData',xpospipe,'YData',ypos+2750);
set(AnimQ1,'XData',xposq,'YData',ypos+2000);
drawnow
if ((xposmario(1) > xpospipe(1)-200) && (xposmario(1) < xpospipe(1)+200) && (jumpflag == false))
    display('collided with pipe');
    break;
elseif((xposmario(1) > xposq(1)-250) && (xposmario(1) < xposq(1)+200) && (crouchflag == false))
    display('collided with pipe');
    break;
end
display(xpospipe);
end
set(AnimMC,'Visible','off');
set(AnimMS,'Visible','off');
set(AnimMJ,'Visible','off');
set(AnimP1,'Visible','off');
set(AnimQ1,'Visible','off');
set(AnimCl1,'Visible','off');
set(AnimCl2,'Visible','off');
AnimOV = imagesc(OV);