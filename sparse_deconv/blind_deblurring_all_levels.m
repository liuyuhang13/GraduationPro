function [x, k] = blind_deblurring_all_levels(y, sizek)
% Input:
%   y: blurred image, range from [0, 1]
%   sizek: [mk, nk],size of kernel
% Output:
%   x: deblurred image, range from [0, 1]
%   k: estimated kernel
%% 输入参数预处理
addpath('lib/ksvdbox13');
addpath('lib/ompbox10');
addpath('lib/TreeCANN_code_20121022')
addpath('lib/TreeCANN_code_20121022/matlab_tools/ann_wrapper')
addpath('lib/TreeCANN_code_20121022/C_code')

if(exist('sizek', 'var'))
    mk = sizek(1);
    nk = sizek(2);
else
    mk = 51;
    nk = 51;
end

if(size(y, 3) == 3); y = rgb2gray(y); end   %如果是rgb图则转到灰度图处理
%% 参数定义
par.sinc = {@(x) sinc(x).*sinc(x/30).*(abs(x)<30), 30*2};% 定义了一种插值方法
par.lambda_sparse = 0.15;  % coefficient of image sparse prior
par.lambda_non_local = 0.15;  % coefficient of image non local prior
par.lambda_gradient = 0.001;  % coefficient of image gradient prior
par.lambda_k = 1.5e-3;  % coefficient of kernel prior
par.scale = 0.75;   % downsample rate
par.outer_iter_n = 14;
par.inner_iter_n = 1;
par.patch_size = 5;
par.imshow = false;

par.Msigma = [2, 1];
par.Msigma_step	= 0.81;
par.support	= 4;
par.Morients = pi*linspace(0, 1, 9);%45°间隔标定8个方向
par.Morients(end) =	[];
par.minL = 13;
par.rmap_prctile = 75;
par.M_prctiles = linspace(98.5, 91.5, par.outer_iter_n);
par.rmap = compute_rmap(y, 0.5, 11);

%这里是做了九层金字塔，降采样因子3/4
[yp, mkp, nkp, scales] = build_pyramid(y, mk, nk, par.sinc, 1/par.scale);
x = imresize(yp{scales}, par.scale, par.sinc);% 这里par.sinc参数是干嘛的，sinc也没参数怎么调用那个x
k = [0,0,0;0,1,0;0,0,0];%初始估计的模糊核 3*3的一个冲击
par.KSVD_D = train_dictionary(x, par.patch_size);
% 打印KSVD_D
% D_demo = zeros(50,50);
% r = 1:5:50;
% c = 1:5:50;
% temp=0;
% for j = 1: 5
%     for i = 1: 5
%         temp = temp+1;
%         D_demo(r-1+i,c-1+j) = reshape(par.KSVD_D(temp,:),10,10);
%     end
% end

%%
for scale = scales: -1: 1
    x = imresize(x, size(yp{scale}), par.sinc);
    k = imresize(k, [mkp{scale}, nkp{scale}], par.sinc);
    par.cur_scale = scale;
    [x, k] = blind_deblurring_single_level(yp{scale}, x, k, par);
end
