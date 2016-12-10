%cam = webcam(1);
i = 1;
while(true)
    str = sprintf('DebaSnap/%d.png',i);
    i = i +1;
    I = snapshot(cam);
    imwrite(I,str);
end