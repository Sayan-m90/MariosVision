imagesc(Back);
%pause(20);
hold on;
play(player);
AnimMC = imagesc(MC);
ypos = get(AnimMC, 'YData');    ypos = ypos + 503;
xpos = get(AnimMC, 'YData');    xpos = xpos + 100;
xinit = xpos;
AnimCl1 = imagesc(Cl1); ycl1 = ypos - 250;  xcl1 = xpos + 1800;
AnimCl2 = imagesc(Cl2); ycl2 = ypos - 390;  xcl2 = xpos + 1500;
%[xxx,yyy,~] = size(M1);
%M1 = imresize(M1,2);
%AnimM1 =  imagesc(M1); ym1 = ypos ;  xm1 = xpos + 1000;
AnimQ1 = imagesc(Q1);   %yq1 = ypos - 110;    xq1 = xpos + 1290; 
AnimQ2 = imagesc(Q2);   %yq1 = ypos - 110;    xq1 = xpos + 1290; 
  yq1 = ypos - 100;    xq1 = xpos + 1290; 
AnimP1 = imagesc(P1);   xp1 = xpos + 1720;
AnimMS = imagesc(MS);
AnimMJ = imagesc(MJ);
AnimMG = imagesc(MG);
AnimEX = imagesc(EX); xex = xpos + 500;
AnimTL = imagesc(TL); xtl = xpos + 500;
t1 = clock;
i = -20;

set(AnimMJ,'XData',xpos,'YData',ypos-150);    
set(AnimMS,'XData',xpos,'YData',ypos);
set(AnimMC,'XData',xpos,'YData',ypos);
set(AnimMG,'XData',xpos,'YData',ypos);
set(AnimP1,'XData',xp1,'YData',ypos);
set(AnimQ1,'XData',xq1,'YData',yq1);
set(AnimQ2,'XData',xq1,'YData',yq1);
set(AnimTL,'XData',xtl,'YDATA',ypos);
set(AnimEX,'XData',xtl,'YDATA',ypos);
set(AnimCl1,'XData',xcl1,'YData',ycl1);
set(AnimCl2,'XData',xcl2,'YData',ycl2);
%set(AnimM1,'XData',xm1,'YData',ym1);
%set(AnimM1, 'position', [xm1,ym1,100,100])
set(gcf,'CurrentCharacter','@');
set(AnimMJ,'Visible','off');
set(AnimMC,'Visible','off');
set(AnimMG,'Visible','off');
set(AnimEX,'Visible','off');
%set(AnimQ1,'Visible','off');
set(AnimQ2,'Visible','off');
%return;
jumpflag = false;   crouchflag = false;
finish = false;     shootflag = false;  resetTurtle = false; shotTurtle = false;
display(xpos); display(xp1);
while(~finish)
    k = get(gcf,'CurrentCharacter');    
    if k ~= '@'
        if k=='q'
            finish=true; 
        end
        display('keystroke detected');
        if k == 'w'         %w = jump
            tjump = clock;
            jumpflag =true;
            play(playerj);
            set(gcf,'CurrentCharacter','@');
            set(AnimMS,'Visible','off');
            set(AnimMC,'Visible','off');
            set(AnimMJ,'Visible','on');
        elseif k == 's'     %s = crouch
            tcrouch = clock;
            crouchflag =true;
            play(playercrouch);
            set(gcf,'CurrentCharacter','@');
            set(AnimMS,'Visible','off');
            set(AnimMJ,'Visible','off');
            set(AnimMC,'Visible','on');
        elseif k == 'd'     %d = shoot
            tshoot = clock;
               play(playerexp);
            shootflag =true;
            set(gcf,'CurrentCharacter','@');
            set(AnimMS,'Visible','off');
            set(AnimMG,'Visible','on');
            set(AnimEX,'XData',xtl,'YDATA',ypos);
            set(AnimEX,'Visible','on');
            set(AnimTL,'Visible','off');
        end
    end
    if jumpflag == true
    tjump2 = clock;

    if etime(tjump2,tjump)>2
        jumpflag = false;
        stop( playerj);
        tjump2 = 0;     tjump = 0;
        set(AnimMJ,'Visible','off');
        set(AnimMS,'Visible','on');
    end
    elseif crouchflag == true
        tcrouch2 = clock;
        if etime(tcrouch2,tcrouch)>3
            crouchflag = false;
            stop(playercrouch);
            tcrouch2 = 0;     tcrouch = 0;
            set(AnimMC,'Visible','off');
            if(jumpflag ~=true )
            set(AnimMS,'Visible','on');
            end
        end
        elseif shootflag == true
            tshoot2 = clock;
            if etime(tshoot2,tshoot)>2
                shootflag = false;
                stop(playerexp);
                tshoot2 = 0;     tshoot = 0;
                set(AnimMG,'Visible','off');
                set(AnimEX,'Visible','off');
                if (jumpflag ~=true)
                set(AnimMS,'Visible','on');
                end
                shotTurtle = true;
            end
    end
    t2 = clock;
    e = etime(t2,t1);
    if(e>0.1)
        t1 = clock;
        t2 = clock;
        e = 0;
        %i = i - 10;
        xp1 = xp1 + i; xq1 = xq1 + i; xcl2 = xcl2 + 2*i; 
        xcl1 = xcl1 + 3*i; 
       % xm1  = xm1+i;
        if(shootflag == false && shotTurtle == false) xtl = xtl + i; end% shift right a bit
        
    end
    set(AnimP1,'XData',xp1,'YData',ypos);
    set(AnimQ1,'XData',xq1,'YData',yq1);
    set(AnimCl1,'XData',xcl1,'YData',ycl1);
    set(AnimCl2,'XData',xcl2,'YData',ycl2);
    %set(AnimM1,'XData',xm1,'YData',ym1);
    set(AnimQ1,'XData',xq1,'YData',yq1);
    set(AnimTL,'XData',xtl,'YData',ypos);
    drawnow;
    if ((xpos(1) > xp1(1)-130) && (xpos(1) < xp1(1)+50) && (jumpflag == false))
        display('collided with pipe');
        %break;
    elseif((xpos(1) > xq1(1)-135) && (xpos(1) < xq1(1)+55) && (crouchflag == false))
        display('collided with question');
        %break;
 elseif((xpos(1) > xtl(1)-135) && (xpos(1) < xtl(1)+55) && (shootflag == false))
        display('collided with turtle');
        %break;

    end
    if(xcl1(1)<-160)          xcl1 = xinit + 1800;  end
    if(xcl2(1)<-160)          xcl2 = xinit + 1500; end
    if(xq1(1)<-160)           
        xq1 = xinit + 1290; 
        if (rand>0.5)
            AnimQ1 = imagesc(Q1);
            set(AnimQ1,'XData',xq1,'YData',yq1);
            set(AnimQ1,'Visible','on');
        %set(AnimQ1,'Visible','on');
        %set(AnimQ2,'Visible','off');
        else
            AnimQ1 = imagesc(Q2);
            set(AnimQ1,'XData',xq1,'YData',yq1);
            set(AnimQ1,'Visible','on');
        %set(AnimQ1,'Visible','off');
        %set(AnimQ2,'Visible','on');
        end

    end
    if(xp1(1)<-160)           
        xp1 = xinit + 1720;  
        %display(xp1);
        %display(xq1);
        
        if(shotTurtle == true && shootflag == false)
            shotTurtle = false;
            %r = (1821-951)*rand + 951;
            xtl = xp1 + 150;
            
            set(AnimTL,'XData',xtl,'YData',ypos);
            set(AnimTL,'Visible','on');
            
        end
    end
    %if(xtl(1)<-160)           display(xp1);  end
   %display(xp1); display(xtl);
end
hold off;
stop( player);
AnimCl1 = imshow(END);
play(playerend);