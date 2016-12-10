clear;
%close all;

directory = 'sample2/';
 filenames = dir(strcat(directory,'*.jpg'));

BW = double(imread(strcat(directory,filenames(1).name)));
scale = 320 / size(BW,1);

N = size(filenames);
T = 10;
headInit = false;
pose = 'stand';
% v = VideoReader('vid1.mp4');
% noOfFrames = v.NumberOfFrames;

% vid = videoinput('USB Camera', 1);
% % vid.SelectedSourceName = 'USB Camera');
% src = getselectedsource(vid);
% % get(src);
% start(vid)
% vidobj = videoinput('USB Camera', 1);
% cam = webcam(1);
% walkImg = double(snapshot(cam));
% [rows, cols, depth] = size(walkImg);
% scale = 320/rows;
% while(true)
%     img = snapshot(cam);
%     grayImg = rgb2gray(img);
%     imagesc(grayImg);
% end


% i = 1;
% count = 0;
% frames = 100;
% frameRate = 5;
% % currAxes = axes;
% backgroundImg = zeros(rows, cols, 3, frames);
% BW = zeros(rows, cols);
% BW(1,1) = 255;
% R = zeros(rows, cols, frames);
% G = zeros(rows, cols, frames);
% B = zeros(rows, cols, frames);
% 
% while(true)
%     walkImg = double(snapshot(cam));
%     if( i <= frames)
%         backgroundImg(:,:,:,i) = walkImg(:,:,:);
%         
%         R(:,:,i) = walkImg(:,:,1);
%         G(:,:,i) = walkImg(:,:,2);
%         B(:,:,i) = walkImg(:,:,3);
%         
%         count = count + 1;
%     end
%     
%     if( i == frames)
%         meanImg =  sum(backgroundImg, 4)/frames;
%         kR = var(R, 1, 3);
%         kG = var(G, 1, 3);
%         kB = var(B, 1, 3);
%     end
%     
%     if( i > frames)
%         diffImg = walkImg - meanImg;
%         diffImg = ((diffImg(:,:,1).^2)./kR) + ((diffImg(:,:,2).^2)./kG) + ((diffImg(:,:,3).^2)./kB);
%         BW = diffImg > 6;
%         BW = medfilt2(BW, [7 7]);
%         BW = bwmorph(BW, 'dilate');
%         
%         
%         
%         [L, num] = bwlabel(BW, 8);
%         
%         hist = histcounts(L, 1:num+1);
%         [M, I] = max(hist);
%         
%         BW = (L==I);
%     end
%     
%     %     grayImg = rgb2gray(walkImg);
%     %     imagesc(uint8(grayImg));
%     imagesc(BW);
%     
%     axis('image');
%     colormap('gray');
%     title(sprintf('%.0f', i));
%         imwrite(BW, [sprintf('Output/%d', i) '.jpg']);
%         imwrite(uint8(walkImg), [sprintf('Input/%d', i) '.jpg']);
%     % %     axis('imag');
%     
%     %     pause(0.1/frameRate);
%     
%     i = i + 1;
% end
for i = 1:N
    %     I = im2bw(imread(strcat(directory,filenames(i).name)));
    %     len = size(filenames(i).name,2);
    %     name = filenames(i).name;
    %     while len<7
    %         name = strcat('0',name);
    %         len = len+1;
    %     end
    %     name = strcat('sample2\',name);
    %     imwrite(I,name);
    %     inputI = imresize(imread(strcat(directoryIn,filenamesIn(n).name)),scale);
    %     figure(3),imshow(inputI);
        BW = im2bw(imresize(imread(strcat(directory,filenames(i).name)),scale));
        %hold on;
        figure(2),imshow(BW);
        i
    if i > 150
        BW = bwmorph(BW,'dilate');BW = bwmorph(BW,'erode');
        pose = 'stand';
            
        [Row,Col] = size(BW);
        half = BW(1:Row/2,:);
        
        if sum(half(:)) > 0
            left = BW(:,1:floor(Col/8));
            right = BW(:,floor(7*Col/8):Col);
            % Dynamic jumping
            if sum(left(:)) ==0 && sum(right(:))==0
                
                [Xr, Xc] = ind2sub(size(BW),find(BW==1));
                Y = ([Xc, Xr]);
                m = mean(Y);
                Y = Y - ones(size(Y,1),1)*m;
                
                K = cov(Y);
                [U,V] = eig(K);
                Col = 9; % stddev 3
                
                
                HalfLen1 = sqrt(Col*V(1,1));
                HalfLen2 = sqrt(Col*V(2,2));
                a = max(HalfLen1,HalfLen2);
                b = min(HalfLen1,HalfLen2);
                
                w = a/4;
                Im = BW';
                [ii,jj] = find( imcomplement(Im) == 0, 1 ); % position of head
                if ~headInit
                    headW = w;
                    headRow = jj-5;
                    headCol = ii-floor(w/2);
                    headInit = true;
                else
                    if(jj-5 < headRow - headW/2)
                        pose = 'JUMP';
                    end
                end
                
                if ~strcmp(pose,'JUMP')
                    
                    if b/a > 0.5
                        pose = 'CROUCH';
                    else
                        Nvals = similitudeMomentsDeb(BW);
                        if abs(Nvals(7)) > 0.005 && abs(Nvals(6)) > 0.004
                            pose = 'SHOOT';
                        end
                        
                    end
                end
                
            end
            
        end
%         disp(pose);
        fid = fopen('nums1.txt','w');
        if strcmp(pose,'JUMP')
            poseId = '0';
        elseif strcmp(pose,'CROUCH')
            poseId = '1';
        elseif strcmp(pose,'SHOOT')
            poseId = '2';
        elseif strcmp(pose,'stand')
            poseId = '3';
        else
            poseId = '-1';
        end
        fprintf(fid,poseId);
        fclose(fid);
    else
        fid = fopen('nums1.txt','w');
        poseId = '6';
        fprintf(fid,poseId);
        fclose(fid);
    end
    drawnow;
    %pause(0.0001);
end

fid = fopen('nums1.txt','w');
poseId = '6';
fprintf(fid,poseId);
fclose(fid);