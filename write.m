% fileID = fopen('nums1.txt','w');
% fprintf(fileID,'%d',5);
%     fclose(fileID);
%     
    [a,b,c,d] = size(Colll);
for i=1:151
    str = sprintf('Fold/col%d.jpg',i);
    imwrite(uint8(Colll(:,:,:,i)),str);
    %str = sprintf('Fold/ntsc%d.jpg',i);
    %imwrite(Walkk(:,:,:,i),str);
    %str = sprintf('Fold/bw%d.jpg',i);
    %imwrite(BWW(:,:,i),str);
end