clear;close all;

t = clock;
image_name = '80_7_blurred';
image_format = '.png';
y = im2double(imread(sprintf('images/%s%s', image_name, image_format)));
[x, k] = blind_deblurring_all_levels(y, [51, 51]);
imwrite(x, sprintf('images/deblur/%s_SRSS%s', image_name, image_format));
imwrite(k/max(k(:)), sprintf('images/kernel/%s_kernel%s', image_name, image_format));
fprintf('deblur takes %d seconds\n', etime(clock, t))

%%Use EPLL as non-blind deconvolution method.Very slow.
%t = clock;
%x = EPLL_deconv(y, k);
%imwrite(x, sprintf('images/deblur/%s_EPLL%s', image_name, image_format));
%fprintf('deblur takes %d seconds\n', etime(clock, t))
