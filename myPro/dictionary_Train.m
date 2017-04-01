function D_ksvd = dictionary_Train(X, patch_size)
%Dictionary_Train 根据给定图像，和图像块大小，进行字典训练
%   X:输入图像
%   patch_size:图像块大小
%   D_ksvd:输出字典

P = extract_Patches(X, patch_size, 1);%抽图像块，间隔1像素
if size(P, 2) > 2000%图像块数目大于2000，随机排列取前2000个
    r = randperm(size(P, 2));
    P = P(:, r(1: 2000));
end
params.data = P;
params.Tdata = 4;
params.dictsize = min(4*patch_size^2, size(P, 2));
params.iternum = 20;
params.memusage = 'high';
[D_ksvd, ~, ~]=ksvd(params, '');