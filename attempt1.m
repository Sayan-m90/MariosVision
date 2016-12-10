                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              


se = strel('disk',7);
I1 = imresize((im2bw((imread('221.jpg')))),0.5);
I2 = imresize((im2bw((imread('430.jpg')))),0.5);
s = regionprops(I2,'centroid');
centroids = cat(1, s.Centroid);
imshow(I2)
hold on
plot(centroids(1,1),centroids(1,2), 'b*')
hold off

I1 = imopen(I1,se);
I2 = imopen(I2,se);
area1 = sum(I1(:));        area2 = sum(I2(:));
perim1 = bwperim(I1,8);     perim2 = bwperim(I2,8);
perim1 = sum(perim1(:));    perim2 = sum(perim2(:));
circ1 = inv((perim1.^2)/(4*3.14*area1));
circ2 = inv((perim2.^2)/(4*3.14*area2));
Nvals1 = similitudeMoments(I1);
Nvals2 = similitudeMoments(I2);