function [x, k] = blind_deblurring_all_levels(y, sizek)
% Input:
%   y: blurred image, range from [0, 1]
%   sizek: [mk, nk],size of kernel
% Output:
%   x: deblurred image, range from [0, 1]
%   k: estimated kernel

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

if(size(y, 3) == 3); y = rgb2gray(y); end
%% 参数定义
par.sinc = {@(x) sinc(x).*sinc(x/30).*(abs(x)<30), 30*2};% 这个sinc函数定义的插值方法是什么意思
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
k = [0,0,0;0,1,0;0,0,0];%这个k是干嘛的。。估计的模糊核？初始是个冲击
par.KSVD_D = train_dictionary(x, par.patch_size);
%%
for scale = scales: -1: 1
    x = imresize(x, size(yp{scale}), par.sinc);
    k = imresize(k, [mkp{scale}, nkp{scale}], par.sinc);
    par.cur_scale = scale;
    [x, k] = blind_deblurring_single_level(yp{scale}, x, k, par);
end
