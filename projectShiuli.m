clear;
close all;

directory = 'sample2/';
filenames = dir(strcat(directory,'*.jpg'));

I = im2bw(imread(strcat(directory,filenames(1).name)));
scale = 320 / size(I,1);
I = imresize(I,scale);
[Rows,Cols] = size(I);
%% Motion history imagery
T = 10; %% Chosen Threshold
prev = I;
framenum = 1;
MHI = zeros(Rows,Cols);
jumpModel = load('jumpSVM.mat','SVMModel');
shootModel = load('shootSVM.mat','SVMModel');
shootStaticModel = load('shootStaticSVM.mat','SVMModel');
crouchStaticModel = load('crouchStaticSVM.mat','SVMModel');
shoot2Jump1Model = load('shoot2Jump1SVM.mat','SVMModel');
N = size(filenames);
T = 0;
headInit = false;
pose = 'stand';
sizeHist = 10;
centYHist = zeros(1,sizeHist);
[R,C] = size(I);
tf = 5; % MHI length
for n=100:N
    % for n = 667-197:692-197
    %                     I = im2bw(imread(strcat(directory,filenames(n).name)));
    %                     len = size(filenames(n).name,2);
    %                     name = filenames(n).name;
    %                     while len<8
    %                         name = strcat('0',name);
    %                         len = len+1;
    %                     end
    %                     name = strcat('sampleFin\',name);
    %                     imwrite(I,name);
    %     %             inputI = imresize(imread(strcat(directoryIn,filenamesIn(n).name)),scale);
    %     %             figure(3),imshow(inputI);
    %             continue;
    
    
    I = im2bw(imresize((imread(strcat(directory,filenames(n).name))),scale));
    pose = 'stand';
    figure(1),imshow(I);
    %     tic;
    half = I(1:R/2,:);
    
    diff = abs(I-prev) > T;
    diff = medfilt2(diff);
    
    MHI(diff) = max(MHI(:))+1;
    minVal = min(MHI(:));
    MHI(MHI<max(MHI(:))-tf) = min(min(MHI(MHI~=minVal)));
    
    display2 = mat2gray(MHI);
    %     figure(3), imshow(display2);
    
    if any(half(:))
        left = I(:,1:floor(C/10));
        right = I(:,floor(9*C/10):C);
        if ~any(left(:)) && ~any(right(:))
            
            [Xr, Xc] = ind2sub(size(I),find(I==1));
            Y = ([Xc, Xr]);
            m = mean(Y);
            Y = Y - ones(size(Y,1),1)*m;
            
            K = cov(Y);
            [U,V] = eig(K);
            c = 9; % stddev 3
            
            
            HalfLen1 = sqrt(c*V(1,1));
            HalfLen2 = sqrt(c*V(2,2));
            a = max(HalfLen1,HalfLen2);
            b = min(HalfLen1,HalfLen2);
            
            % Jump
            momentsMEI = similitudeMomentsDeb(display2>0);
            momentsMHI = similitudeMomentsDeb(display2);
            Nvals = similitudeMomentsDeb(I);
            pred = predict(shoot2Jump1Model.SVMModel,[momentsMEI momentsMHI]);
            s = regionprops(I,'centroid');
            centroids = s.Centroid;
            centYHist1 = [centYHist(2:end) centroids(2)];
            %             disp(centYHist1 - centYHist);
            % figure(5), plot(smooth(centYHist1)); axis([140,250,0,20]);
            centYHist = centYHist1;
            [pks,loc] = findpeaks(centYHist);
            %disp(centYHist(end)-min(centYHist));
%                         centroids = cat(1, s.Centroid);
                        area = sum(I(:));
                        perim = bwperim(I,8);
                        perim = sum(perim(:));
                        circ = 4*3.14*area/perim.^2;
                        areaRatio = area / (R*C);
%                         b/a
%                         circ
            
            if predict(shootStaticModel.SVMModel,Nvals) == 1
                pose = 'SHOOT';
            elseif (predict(crouchStaticModel.SVMModel,Nvals) == 1 || (circ < 0.08 && b/a > 0.4)) && areaRatio > 0.01 % circ sayan 0.06
                pose = 'CROUCH';
            elseif pred == 1 || (centYHist(end)-min(centYHist(floor(sizeHist/2):end)) > 20) && (centYHist(1)-min(centYHist(floor(sizeHist/2):end)) > 20) && centYHist(end)-min(centYHist) < 50
                pose = 'JUMP';
            end            
        end
    end
    prev = I;
    disp(pose);
    fid = fopen('pose.txt','w');
    if strcmp(pose,'JUMP')
        poseId = '0';
    elseif strcmp(pose,'CROUCH')
        poseId = '1';
    elseif strcmp(pose,'SHOOT')
        poseId = '2';
    else
        poseId = '3';
    end
    fprintf(fid,poseId);
    fclose(fid);
    
    %     toc;
end