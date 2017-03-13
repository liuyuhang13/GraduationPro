clear all;close all;
addpath('lib/non_blind_deconv/Levin2011');

for ker = 1: 8
    for img = 1: 4
        t = clock;
        load(sprintf('./images/levin_data/im%02d_ker%02d.mat', img, ker));
        [x, k] = blind_deblurring_all_levels(y, [51, 51]);
        imwrite(k/max(k(:)), sprintf('./images/levin_data/result/ker%02d_img%02d.png', ker, img))
        fprintf('deblur image %02d_%02d takes %f seconds\n', img, ker, etime(clock, t));
    end
end

ssde = zeros(4, 8);
for ker = 1: 8
    for img = 1: 4
        load(sprintf('./images/levin_data/im%02d_ker%02d.mat', img, ker));
        k = im2double(imread(sprintf('./images/levin_data/result/ker%02d_img%02d.png', ker, img)));
        k = rot90(k/sum(k(:)), 2);
        k = cut_kernel(k);
        x_nl = deconvSps(y, k, 0.0068, 70);
        ssde(img, ker) = comp_upto_shift(x_nl, x);
   end
end
save('images/levin_data/result/NL_result.mat', 'ssde');

load('images/levin_data/result/NL_result.mat')
load('images/levin_data/result/8alg_result_from_levin_2011.mat')
load('images/levin_data/result/jia_result.mat')
load('images/levin_data/result/Perrone_result.mat')
load('images/levin_data/result/Perrone2015_results.mat')

groundtruth = errL(:, :, 8);
alg_result(:, :, 1) = ssde;
alg_result(:, :, 2) = ssde_jia;
alg_result(:, :, 3) = ssde_TV;
alg_result(:, :, 4:6) = errL(:, :, [4, 6, 7]);
alg_result(:, :, 7) = ssdes;

n_alg = 7;
thrv=linspace(1,5,30);
errLr = zeros(4, 8, n_alg);
cerrL = zeros(n_alg, length(thrv));
for j=1:n_alg
    errLr(:,:,j)=alg_result(:,:,j)./groundtruth;
    for i=1:length(thrv)
        cerrL(j,i)=sum(sum( errLr(:,:,j)<=thrv(i)))/32;
    end
end

iptsetpref('ImshowBorder','tight');
cols{1}='ro-';
cols{2}='bx-';
cols{3}='r*-';
cols{4}='g>-';
cols{5}='kv-';
cols{6}='c<-';
cols{7}='mp-';
le{1}='本文算法';
le{2}='Xu和Jia';
le{3}='Perrone和Favaro';
le{4}='Levin等';
le{5}='Fergus等';
le{6}='Cho和Lee';
le{7}='Perrone等';

figure, hold on
for j=1:j
    plot(min(thrv,5), cerrL(j,:),cols{j}, 'LineWidth', 1)
end
f=legend(le,'Location','SouthEast');
ylabel('成功率')
xlabel('ER(Error ratio)')
ylim([0,1.03])
saveas(gcf, './images/levin_data/result/result_compare_levin.eps', 'psc2');

ker32 = [];
for ker = 1: 8
    load(sprintf('./images/levin_data/im01_ker%02d.mat', ker));
    f = rot90(f, 2);
    [mk, nk] = size(f);
    f = padarray(f, [(51-mk)/2, (51-nk)/2], 0, 'both');
    tmp = f/max(f(:));
    for img = 1: 4
        k = im2double(imread(sprintf('./images/levin_data/result/ker%02d_img%02d.png', ker, img)));
        k = cut_kernel(k);
        [mk, nk] = size(k);
        k = padarray(k, [(51-mk)/2, (51-nk)/2], 0, 'both');
        tmp = [tmp;k];
    end
    ker32 = [ker32, tmp];
end
imwrite(ker32, './images/levin_data/result/ker32.png');
