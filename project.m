clear;
close all;

headInit = false;
pose = 'stand';

cam = webcam(1);
% cam.WhiteBalance = 6500;
% cam.ExposureMode = 'manual';
% cam.Exposure = -5;
walkImg = double(snapshot(cam));
[rows, cols, depth] = size(walkImg);
scale = 320/rows;

jumpModel = load('jumpSVM.mat','SVMModel');
shootModel = load('shootSVM.mat','SVMModel');
shootStaticModel = load('shootStaticSVM.mat','SVMModel');
crouchStaticModel = load('crouchStaticSVM.mat','SVMModel');
shoot2Jump1Model = load('shoot2Jump1SVM.mat','SVMModel');
sizeHist = 10;
centYHist = zeros(1,sizeHist);
tf = 5; % MHI length
% T = 10; %% Chosen Threshold

framenum = 1;
% while(true)
%     img = snapshot(cam);
%     grayImg = rgb2gray(img);
%     imagesc(grayImg);
% end
[a22,b22,c22] = size(snapshot(cam));
BWW = zeros(a22,b22,500);
Colll = zeros(a22,b22,3,500);
Walkk = zeros(a22,b22,3,500);

i = 1;
% count = 0;
frames = 150;
buffer = 50;
% frameRate = 5;
% currAxes = axes;
backgroundImg = zeros(rows, cols, 3, frames - buffer);
BW = zeros(rows, cols);
% MHI = zeros(320,cols*scale);
MHI = zeros(rows,cols);
BW(1,1) = 255;
% R = zeros(rows, cols, frames - buffer);
G = zeros(rows, cols, frames - buffer);
B = zeros(rows, cols, frames - buffer);

while(i<500)
    inputImg = double(snapshot(cam));
    walkImg = rgb2ntsc(inputImg);
    
    if( i>buffer && i <= frames)
        backgroundImg(:,:,:,i - buffer) = walkImg;
        
        G(:,:,i - buffer) = walkImg(:,:,2);
        B(:,:,i - buffer) = walkImg(:,:,3);
    end
    
    if( i == frames)
        meanImg =  sum(backgroundImg(:,:,2:3,:), 4)/(frames - buffer);
        kG = var(G, 1, 3);
        kB = var(B, 1, 3);
    end
    
    if( i > frames)
        diffImg = walkImg(:,:,2:3) - meanImg;
        diffImg = ((diffImg(:,:,1).^2)./kG) + ((diffImg(:,:,2).^2)./kB);
        BW = diffImg > 6;
        BW = medfilt2(BW, [5 5]);
                se = strel('disk',3);
%         BW = bwmorph(BW, 'dilate');
                BW = imdilate(BW, se);
        [L, num] = bwlabel(BW, 8);
        
        hist = histcounts(L, 1:num+1);
        [M, I] = max(hist);
        
        if (hist(I) > 1000)
            BW = (L==I);
            flag = true;
        else
            BW = zeros(rows, cols);
            BW(1,1) = 255;
            flag = false;
        end
        
        BWW(:,:,i) = BW;
        Colll(:,:,:,i) = inputImg;
        Walkk(:,:,:,i) = walkImg;
        %         BW = imresize(BW,scale);
%         pose = 'stand';
%         %     figure(1),imshow(BW);
%         %         [Row,Col] = size(BW);
%         %         half = BW(1:Row/2,:);
%         %
%         %         BW = imresize(BW,scale);
%         diff = abs(BW-prev) > 0;
%         %         diff = medfilt2(diff);
%         
%         MHI(diff) = max(MHI(:))+1;
%         minVal = min(MHI(:));
%         temp = MHI(MHI~=minVal);
%         MHI(MHI<max(MHI(:))-tf) = min(temp(:));
%         
%         display2 = mat2gray(MHI);
%         %
%         %         if sum(BW(:)) > 0
%         %             left = BW(:,1:floor(cols/12));
%         %             right = BW(:,floor(11*cols/12):cols);
%         %             % Dynamic jumping
%         %             if sum(left(:)) ==0 && sum(right(:))==0
%         
%         if(flag)
%             Nvals = similitudeMoments(BW);
%             
%             
%             %
%             
%             if (predict(shootStaticModel.SVMModel,Nvals) == 1)
%                 pose = 'SHOOT';
%             else
%                 [Xr, Xc] = ind2sub(size(BW),find(BW==1));
%                 Y = ([Xc, Xr]);
%                 %                     m = mean(Y);
%                 %                     Y = Y - ones(size(Y,1),1)*m;
%                 
%                 K = cov(Y,1);
%                 [~,V] = eig(K);
%                 c = 9; % stddev 3
%                 
%                 
%                 HalfLen1 = sqrt(c*V(1,1));
%                 HalfLen2 = sqrt(c*V(2,2));
%                 a = max(HalfLen1,HalfLen2);
%                 b = min(HalfLen1,HalfLen2);
%                 
%                 s = regionprops(BW,'centroid');
%                 centroids = s.Centroid;
%                 centYHist = [centYHist(2:end) centroids(2)];
%                 %                     [pks,loc] = findpeaks(centYHist);
%                 area = sum(BW(:));
%                 perim = bwperim(BW,8);
%                 perim = sum(perim(:));
%                 circ = 4*3.14*area/perim.^2;
%                 areaRatio = area / (rows*cols);
%                 
%                 if (predict(crouchStaticModel.SVMModel,Nvals) == 1 || (circ < 0.08 && b/a > 0.4)) && areaRatio > 0.01 % circ sayan 0.06
%                     pose = 'CROUCH';
%                 else
%                     
%                     momentsMEI = similitudeMoments(display2>0);
%                     momentsMHI = similitudeMoments(display2);
%                     pred = predict(shoot2Jump1Model.SVMModel,[momentsMEI momentsMHI]);
%                     if pred == 1 || (centYHist(end)-min(centYHist(floor(sizeHist/2):end)) > 20) && (centYHist(1)-min(centYHist(floor(sizeHist/2):end)) > 20) && centYHist(end)-min(centYHist) < 50
%                         pose = 'JUMP';
%                     end
%                 end
%             end
%             
%             %             end
%             
%             %         end
%             disp(pose);
%             fid = fopen('nums1.txt','w');
%             if strcmp(pose,'JUMP')
%                 poseId = '0';
%             elseif strcmp(pose,'CROUCH')
%                 poseId = '1';
%             elseif strcmp(pose,'SHOOT')
%                 poseId = '2';
%             else
%                 poseId = '3';
%             end
%             fprintf(fid,poseId);
%             fclose(fid);
%         else
%             fid = fopen('nums1.txt','w');
%             poseId = '6';
%             fprintf(fid,poseId);
%             fclose(fid);
%         end
    end
    
    prev = BW;
    
    
    imagesc(BW);
    
    axis('image');
    colormap('gray');
    title(sprintf('%.0f', i));
    i = i +1;
end
% 
% fid = fopen('nums1.txt','w');
% poseId = '6';
% fprintf(fid,poseId);
% fclose(fid);