clear; close all
% v = VideoReader('vid1.mp4');
% noOfFrames = v.NumberOfFrames;

% vid = videoinput('USB Camera', 1);
% % vid.SelectedSourceName = 'USB Camera');
% src = getselectedsource(vid);
% % get(src);
% start(vid)
% vidobj = videoinput('USB Camera', 1);
cam = webcam(1);
walkImg = double(snapshot(cam));
[rows, cols, depth] = size(walkImg);

directory = 'sample2/';
filenames = dir(strcat(directory,'*.jpg'));
N = size(filename);
% while(true)
%     img = snapshot(cam);
%     grayImg = rgb2gray(img);
%     imagesc(grayImg);
% end


i = 1;
count = 0;
frames = 100;
frameRate = 5;
% currAxes = axes;
backgroundImg = zeros(rows, cols, 3, frames);
BW = zeros(rows, cols);
BW(1,1) = 255;
R = zeros(rows, cols, frames);
G = zeros(rows, cols, frames);
B = zeros(rows, cols, frames);


for iiii = 1:N
    I = im2bw(imread(strcat(directory,filenames(iiii).name)));
    
end

while(true)
    walkImg = double(snapshot(cam));
    
    if( i <= frames)
        backgroundImg(:,:,:,i) = walkImg(:,:,:);
        
        R(:,:,i) = walkImg(:,:,1);
        G(:,:,i) = walkImg(:,:,2);
        B(:,:,i) = walkImg(:,:,3);
        
        count = count + 1;
    end
    
    if( i == frames)
       meanImg =  sum(backgroundImg, 4)/frames;
       kR = var(R, 1, 3);
       kG = var(G, 1, 3);
       kB = var(B, 1, 3);
    end
    
    if( i > frames)
       diffImg = walkImg - meanImg;
       diffImg = ((diffImg(:,:,1).^2)./kR) + ((diffImg(:,:,2).^2)./kG) + ((diffImg(:,:,3).^2)./kB);
       BW = diffImg > 6;
       BW = medfilt2(BW, [7 7]);
       BW = bwmorph(BW, 'dilate');
       
       

        [L, num] = bwlabel(BW, 8);

        hist = histcounts(L, 1:num+1);
        [M, I] = max(hist);

        BW = (L==I);
    end
    
%     grayImg = rgb2gray(walkImg);
%     imagesc(uint8(grayImg));
    imagesc(BW);
    
    axis('image');
    colormap('gray');
    title(sprintf('%.0f', i));
%     imwrite(BW, [sprintf('Output/%d', i) '.jpg']);
%     imwrite(uint8(walkImg), [sprintf('Input/%d', i) '.jpg']);
% %     axis('imag');

%     pause(0.1/frameRate);
    
    i = i + 1;
end