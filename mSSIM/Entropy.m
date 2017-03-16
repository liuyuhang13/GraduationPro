clear;
Test_image_dir='Data\Result\无高分图像最终结果';
image_name='9x_2.1.05.bmp';
im=imread(fullfile(Test_image_dir,image_name));
% im=imread(image_name);
hist=imhist(im);
idx=find(hist);
hist_nz=hist(idx);
pdf=hist_nz/(prod(size(im)));
entropy=sum(-pdf.*log(pdf)/log(2))
