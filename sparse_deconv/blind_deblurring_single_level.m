function [x, k] = blind_deblurring_single_level(y, x, k, par)
% Input:
%   y: blurred image
%   x: initial image estimation
%   k: initial kernel
%   par: other parameters
% Output:
%   x: deblurred image, range from [0, 1]
%   k: estimated kernel

sizek = size(k);
lambda_k = par.lambda_k * numel(y);

n = numel(par.Morients);
Mfilters = cell(1, n);
Msigmas = par.Msigma*par.Msigma_step^par.cur_scale;
for i=1: n
    Mfilters{i} = oeFilter(Msigmas, par.support, par.Morients(i), 1);
end
par.currminL = max(1, round(par.minL*par.scale^par.cur_scale));
rmap = imresize(par.rmap, size(y));
rmap = rmap >= prctile(rmap(:), 100-par.rmap_prctile);
rmap = imdilate(rmap, strel('disk',3));

for iter = 1: par.outer_iter_n
    par.sharp_prcthreshold = par.M_prctiles(iter);
    M = getM2(x, Mfilters, par);
    par.M = M.*rmap;
%    if(iter==1)    %old mask
%        par.tau = compute_tau(x, sizek);
%    else
%        par.tau = par.tau/1.1;
%    end

    k = update_kernel(x, y, sizek, lambda_k, par);
    x = update_image(y, k, x, par);
    if(par.imshow)
        figure(2);
        suptitle(sprintf('pyramid scale=%d,itertion=%d', par.cur_scale, iter));
        subplot(1,2,1);imshow(k/max(k(:)));title('kernel');
        subplot(1,2,2);imshow(x);title('image');
        figure(3);
        suptitle(sprintf('pyramid scale=%d,itertion=%d', par.cur_scale, iter));
        subplot(1,3,1);imshow(rmap);title('rmap mask');
        subplot(1,3,2);imshow(M);title('Mfilter mask');
        subplot(1,3,3);imshow(M.*(~rmap));title('erased Mfilter mask');pause(0.01)
    end
end
