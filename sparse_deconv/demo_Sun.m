clear;close all;
addpath('lib/evaluation_code_Sun')

for img = 1: 80
    for ker = 1: 8
        t = clock;
        y = im2double(imread(sprintf('images/Sun_data/%d_%d_blurred.png', img, ker)));
        [x, k] = blind_deblurring_all_levels(y, [51, 51]);
        imwrite(k/max(k(:)), sprintf('images/Sun_data/kernel/%d_%d.png', img, ker));
        imwrite(x, sprintf('images/Sun_data/deblur/%d_%d.png', img, ker));
        fprintf('deblur image %d_%d takes %6.4f seconds\n', img, ker, etime(clock, t));
    end
end

for img = 1: 80
    for ker = 1: 8
        t = clock;
        y = im2double(imread(sprintf('images/Sun_data/%d_%d_blurred.png', img, ker)));
        k = im2double(imread(sprintf('./images/Sun_data/kernel/%d_%d.png', img, ker)));
        k = k/sum(k(:));
        k = cut_kernel(k);
        x = EPLL_deconv(y, k);
        imwrite(x, sprintf('images/Sun_data/deblur/EPLL_%d_%d.png', img, ker));
        fprintf('deblur image %d_%d takes %6.4f seconds\n', img, ker, etime(clock, t));
    end
end

ssde_our = zeros(80, 8);
for img = 1: 80
    gt = im2double(imread(sprintf('images/Sun_data/groundtruth/img%d_groundtruth_img.png', img)));
    for ker = 1: 8
        EPLL_x = im2double(imread(sprintf('images/Sun_data/deblur/EPLL_%d_%d.png', img, ker)));
        [imgcrop, gtcrop, ~, ~]=psnr_ssim_img(gt, EPLL_x, 0);
        ssde_our(img, ker) = sum((imgcrop(:)-gt(:)).^2);
        imwrite(imgcrop, sprintf('images/Sun_data/deblur/EPLL_crop_%d_%d.png', img, ker));
    end
end
save('images/Sun_data/ssde_our.mat', 'ssde_our');

load('images/Sun_data/ssde_our.mat')
load('images/Sun_data/ssde_gtk.mat')
load('images/Sun_data/all_results_sun.mat')
load('images/Sun_data/ssde_Perrone2015.mat')
n_alg = 8;
alg_result(:, :, 1) = ssde_our;
alg_result(:, :, 2) = ssde_Cho;
alg_result(:, :, 3) = ssde_ChoEtAl;
alg_result(:, :, 4) = ssde_Krishnan;
alg_result(:, :, 5) = ssde_Levin;
alg_result(:, :, 6) = ssde_Sun;
alg_result(:, :, 7) = ssde_Xu;
alg_result(:, :, 8) = ssde_Michaeli;
%alg_result(:, :, 9) = ssde_Lai;
%alg_result(:, :, 9) = ssde_Perrone2015;

thrv=linspace(1,25,49);
errLr = zeros(80, 8, n_alg);
cerrL = zeros(n_alg, length(thrv));
for j=1:n_alg
    errLr(:,:,j)=alg_result(:,:,j)./ssde_gtk;
    for i=1:length(thrv)
        tmp = errLr(:,:,j);
        tmp = tmp(alg_result(:,:,j)~=-1);
        cerrL(j,i)=mean(tmp<=thrv(i));
    end
end

cols{1}='ro-';
cols{2}='bx-';
cols{3}='r*-';
cols{4}='g>-';
cols{5}='kv-';
cols{6}='c<-';
cols{7}='mp-';
cols{8}='bh-';
%cols{9}='gs-';
figure, hold on
for j=1:j
    plot(thrv, cerrL(j,:),cols{j}, 'LineWidth', 1)
end
le{1}='本文算法';
le{2}='Cho和Lee';
le{3}='Cho等';
le{4}='Krishnan等';
le{5}='Levin等';
le{6}='Sun等';
le{7}='Xu和Jia';
le{8}='Michaeli和Irani';
%le{9}='LaiEtAl';
f=legend(le,'Location','SouthEast');
ylabel('成功率')
xlabel('ER(Error ratio)')
saveas(gcf, './images/Sun_data/result_compare_Sun.eps', 'psc2');
