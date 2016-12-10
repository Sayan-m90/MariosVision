imagesc(Back);
play(player);
%sound(f);
hold on;
AnimMC = imagesc(MC);

ypos = get(AnimMC, 'YData');    ypos = ypos + 503;
xpos = get(AnimMC, 'YData');    xinit = xpos; xpos = xpos + 100;

AnimCl1 = imagesc(Cl1); ycl1 = ypos - 250;  xcl1 = xinit + 1800;
AnimCl2 = imagesc(Cl2); ycl2 = ypos - 480;  xcl2 = xinit + 1500;
AnimQ1 = imagesc(Q1);   yq1 = ypos - 110;    xq1 = xinit + 1221 + (1248/3) + random(1,1164/3);%+ 1290; 
AnimP1 = imagesc(P1);   xp1 = xinit + 1221 + random(1,1164/3);
AnimMS = imagesc(MS);
AnimMJ = imagesc(MJ);
AnimMG = imagesc(MG);
AnimEX = imagesc(EX); xex = xpos + 500;
AnimTL = imagesc(TL); xtl = xinit + 1221 + (1248/3) + (1248/3) + random(1,1164/3);
t1 = clock;
i = -20;

set(AnimMJ,'XData',xpos,'YData',ypos-150);    
set(AnimMS,'XData',xpos,'YData',ypos);
set(AnimMC,'XData',xpos,'YData',ypos);
set(AnimMG,'XData',xpos,'YData',ypos);
set(AnimP1,'XData',xp1,'YData',ypos);
set(AnimQ1,'XData',xq1,'YData',yq1);
set(AnimTL,'XData',xtl,'YDATA',ypos);
set(AnimEX,'XData',xtl,'YDATA',ypos);
set(AnimCl1,'XData',xcl1,'YData',ycl1);
set(AnimCl2,'XData',xcl2,'YData',ycl2);
set(gcf,'CurrentCharacter','@');
set(AnimMJ,'Visible','off');
set(AnimMC,'Visible','off');
set(AnimMG,'Visible','off');
set(AnimEX,'Visible','off');
jumpflag = false;   crouchflag = false;
finish = false;     shootflag = false;  resetTurtle = false; shotTurtle = false;
display(xpos); display(xp1);
%return;
stat = -1;
while(~finish)
    k1 = get(gcf,'CurrentCharacter');  
    fileID = fopen('nums1.txt','r');
    
    k = fscanf(fileID,'%d');
   % if(k~=stat)
      %  k
   % end
    fclose(fileID);
    fileID = fopen('nums1.txt','w');
    fprintf(fileID,'%d',-1);
    fclose(fileID);
    if k ~= '@'
        if k==5
            finish=true; 
        end
        %set(0,'CurrentFigure', handle_main_figure);
        display('keystroke detected');
        if k == 0         %w = jump
            %[y1,f1]=audioread('mario-jump.mp3');
            %playerj = audioplayer(y1,f1);
            play(playerj);
            tjump = clock;
            jumpflag =true;
            set(gcf,'CurrentCharacter','@');
            set(AnimMS,'Visible','off');
            set(AnimMG,'Visible','off');
            set(AnimMC,'Visible','off');
            set(AnimMJ,'Visible','on');
            
        elseif k == 1     %s = crouch
            play(playercrouch);
            tcrouch = clock;
            crouchflag =true;
            set(gcf,'CurrentCharacter','@');
            set(AnimMC,'Visible','on');
            set(AnimMS,'Visible','off');
            set(AnimMG,'Visible','off');
            set(AnimMJ,'Visible','off');
        elseif k == 2     %d = shoot
            
           % playerexp = audioplayer(y2,f2);
            play(playerexp);
            tshoot = clock;
            shootflag =true;
            set(gcf,'CurrentCharacter','@');
            set(AnimEX,'XData',xtl,'YDATA',ypos);
            set(AnimMG,'Visible','on');
            set(AnimMS,'Visible','off');            
            set(AnimMC,'Visible','off');
            set(AnimMJ,'Visible','off');
            
            set(AnimEX,'Visible','on');
            set(AnimTL,'Visible','off');
        end
    end
    if jumpflag == true
    tjump2 = clock;
    if etime(tjump2,tjump)>3
        jumpflag = false;
        tjump2 = 0;     tjump = 0;
        set(AnimMJ,'Visible','off');
        set(AnimMC,'Visible','off');
        set(AnimMG,'Visible','off');
        set(AnimMS,'Visible','on');
        stop( playerj);
        
    end
    elseif crouchflag == true
        tcrouch2 = clock;
        if etime(tcrouch2,tcrouch)>3
            crouchflag = false;
            tcrouch2 = 0;     tcrouch = 0;
            set(AnimMC,'Visible','off');
            set(AnimMG,'Visible','off');
            set(AnimMJ,'Visible','off');
            set(AnimMS,'Visible','on');
            stop(playercrouch);
        end
        elseif shootflag == true
            tshoot2 = clock;
            if etime(tshoot2,tshoot)>2
                shootflag = false;
                tshoot2 = 0;     tshoot = 0;
                set(AnimMG,'Visible','off');
                set(AnimEX,'Visible','off');
                set(AnimMJ,'Visible','off');
                set(AnimMC,'Visible','off');
                set(AnimMS,'Visible','on');
                shotTurtle = true;
                stop(playerexp);
            end
    end
    t2 = clock;
    e = etime(t2,t1);
    if(e>0.2)
        t1 = clock;
        t2 = clock;
        e = 0;
        %i = i - 10;
        xp1 = xp1 + i; 
        xq1 = xq1  + i; xcl2 = xcl2 + 2*i; 
        xcl1 = xcl1 + 3*i; 
        if(shootflag == false && shotTurtle == false) 
            xtl = xtl  + i; 
        end% shift right a bit
        
    end
    set(AnimP1,'XData',xp1,'YData',ypos);
    set(AnimQ1,'XData',xq1,'YData',yq1);
    set(AnimCl1,'XData',xcl1,'YData',ycl1);
    set(AnimCl2,'XData',xcl2,'YData',ycl2);
    set(AnimQ1,'XData',xq1,'YData',yq1);
    set(AnimTL,'XData',xtl,'YData',ypos);
    drawnow;
    if ((xpos(1) > xp1(1)-130) && (xpos(1) < xp1(1)+50) && (jumpflag == false))
        display('collided with pipe');
        %break;
    elseif((xpos(1) > xq1(1)-135) && (xpos(1) < xq1(1)+55) && (crouchflag == false))
        display('collided with question');
        %break;
    end
    if(xcl1(1)<-160)          xcl1 = xinit + 1800;  end
    if(xcl2(1)<-160)          xcl2 = xinit + 1500; end
    if(xq1(1)<-160)           
        xq1 = xinit + 1221 + (1248/3) + random(1,1164/3); 
%         if(abs(xp1(1) - xq1(1))<30)
%             xq1 = xq1 + 30;
%         end
    end
    if(xp1(1)<-160)           
        xp1 = xinit + 1221 + random(1,1164/3);  
%         if(abs(xp1(1) - xq1(1))<30)
%             xp1 = xp1 + 30;
%         end
        display(xp1);
        display(xq1);
        if(shotTurtle == true && shootflag == false)
            shotTurtle = false;
            %r = (1821-951)*rand + 951;
            xtl = xp1 + 1221+ (1248/3) + (1248/3) + random(1,1164/3);
            
            set(AnimTL,'XData',xtl,'YData',ypos);
            set(AnimTL,'Visible','on');
            
        end
    end
    %if(xtl(1)<-160)           display(xp1);  end
   %display(xp1); display(xtl);
end
hold off;
stop( player);