function Nv = similitudeMoments_slow(boxIm)

[row,col] = size(boxIm);
boxIm = double(boxIm);
m00 = sum(boxIm(:));
j = 1:col;
ma10 = bsxfun(@times,boxIm,j);
m10 = sum(ma10(:));
i = (1:row)';
ma01 = bsxfun(@times,boxIm,i);
m01 = sum(ma01(:));
x = m10/m00;
y = m01/m00;

Nv = [0.0 0.0 0.0 0.0 0.0 0.0 0.0];
jx0 = (j - x).^0;
jx1 = (j - x).^1;
jx2 = (j - x).^2;
jx3 = (j - x).^3;
iy0 = (i - y).^0;
iy1 = (i - y).^1;
iy2 = (i - y).^2;
iy3 = (i - y).^3;
nv = bsxfun(@times,boxIm,jx0); nv = bsxfun(@times,nv,iy2); Nv(1) = sum(nv(:));
nv = bsxfun(@times,boxIm,jx0); nv = bsxfun(@times,nv,iy3); Nv(2) = sum(nv(:));
nv = bsxfun(@times,boxIm,jx1); nv = bsxfun(@times,nv,iy1); Nv(3) = sum(nv(:));
nv = bsxfun(@times,boxIm,jx1); nv = bsxfun(@times,nv,iy2); Nv(4) = sum(nv(:));
nv = bsxfun(@times,boxIm,jx2); nv = bsxfun(@times,nv,iy0); Nv(5) = sum(nv(:));
nv = bsxfun(@times,boxIm,jx2); nv = bsxfun(@times,nv,iy1); Nv(6) = sum(nv(:));
nv = bsxfun(@times,boxIm,jx3); nv = bsxfun(@times,nv,iy0); Nv(7) = sum(nv(:));
% for i=1:row
%     for j=1:col
%         Nvals(1) = Nvals(1) + (((j-x)^0)*((i-y)^2)*boxIm(i,j));
%         Nvals(2) = Nvals(2) + (((j-x)^0)*((i-y)^3)*boxIm(i,j));
%         Nvals(3) = Nvals(3) + (((j-x)^1)*((i-y)^1)*boxIm(i,j));
%         Nvals(4) = Nvals(4) + (((j-x)^1)*((i-y)^2)*boxIm(i,j));
%         Nvals(5) = Nvals(5) + (((j-x)^2)*((i-y)^0)*boxIm(i,j));
%         Nvals(6) = Nvals(6) + (((j-x)^2)*((i-y)^1)*boxIm(i,j));
%         Nvals(7) = Nvals(7) + (((j-x)^3)*((i-y)^0)*boxIm(i,j));
%         
%     end
% end
m00 = double(m00);
Nv(1) = Nv(1)/(m00^double(1+((0+2)/2)));
Nv(2) = Nv(2)/(m00^double(1+((0+3)/2)));
Nv(3) = Nv(3)/(m00^double(1+((1+1)/2)));
Nv(4) = Nv(4)/(m00^double(1+((1+2)/2)));
Nv(5) = Nv(5)/(m00^double(1+((2+0)/2)));
Nv(6) = Nv(6)/(m00^double(1+((2+1)/2)));
Nv(7) = Nv(7)/(m00^double(1+((3+0)/2)));


end