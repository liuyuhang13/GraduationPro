function x = EPLL_deconv(y, k)
addpath('lib/non_blind_deconv/epllcode')
load('GSModel_8x8_200_2M_noDC_zeromean.mat')
[m, n, dim] = size(y);
if(dim == 1)
    x = EPLL_deconv_gray(y, k, GS);
else
    x = zeros(m, n, dim);
    for i = 1: dim
        x(:, :, i) = EPLL_deconv_gray(y(:, :, i) , k, GS);
    end
end

function x = EPLL_deconv_gray(y, k, GS)
excludeList = [];
prior = @(Z,patchSize,noiseSD,imsize) aprxMAPGMM(Z,patchSize,noiseSD,imsize,GS,excludeList);
LogLFunc = [];
noiseSD = 0.01;
patchSize = 8;
k_size = (size(k) - 1)/2;
y = padarray(y, k_size, 'replicate', 'both');
for a=1:4
    y = edgetaper(y, k);
end
[x,~,~] = EPLLhalfQuadraticSplitDeblur(y,64/noiseSD^2,k,patchSize,50*[1 2 4 8 16 32 64],1,prior,y,LogLFunc);
x = x(k_size(1)+1:end-k_size(1), k_size(2)+1:end-k_size(2));
