function [ N ] = similitudeMoments( image )

[rows, cols] =  size(image);
X = 1: cols;
Y = (1: rows)';

m00 = sum(reshape(image, [], 1));

m10 = sum(reshape(bsxfun(@times, bsxfun(@times, image, X.^1), Y.^0), [], 1));
m01 = sum(reshape(bsxfun(@times, bsxfun(@times, image, X.^0), Y.^1), [], 1));

rowMean = m01/m00;
colMean = m10/m00;

% centroid = regionprops(image,'Centroid');
% rowMean = centroid.Centroid(2);     %y mean
% colMean = centroid.Centroid(1);     %x mean

x = X - colMean;
y = Y - rowMean;



u02 =   sum(reshape(bsxfun(@times, bsxfun(@times, image, x.^0), y.^2), [], 1));
n02 =   u02/ (m00.^2);

u03 =   sum(reshape(bsxfun(@times, bsxfun(@times, image, x.^0), y.^3), [], 1));
n03 =   u03/ (m00.^2.5); 

u11 =   sum(reshape(bsxfun(@times, bsxfun(@times, image, x.^1), y.^1), [], 1));
n11 =   u11/ (m00.^2);

u12 =   sum(reshape(bsxfun(@times, bsxfun(@times, image, x.^1), y.^2), [], 1));
n12 =   u12/ (m00.^2.5);

u20 =   sum(reshape(bsxfun(@times, bsxfun(@times, image, x.^2), y.^0), [], 1));
n20 =   u20/ (m00.^2);

u21 =   sum(reshape(bsxfun(@times, bsxfun(@times, image, x.^2), y.^1), [], 1));
n21 =   u21/ (m00.^2.5);

u30 =   sum(reshape(bsxfun(@times, bsxfun(@times, image, x.^3), y.^0), [], 1));
n30 =   u30/ (m00.^2.5);

N = [ n02 n03 n11 n12 n20 n21 n30];

end

