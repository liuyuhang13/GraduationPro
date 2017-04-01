function D_ksvd = dictionary_Train(X, patch_size)
%Dictionary_Train ���ݸ���ͼ�񣬺�ͼ����С�������ֵ�ѵ��
%   X:����ͼ��
%   patch_size:ͼ����С
%   D_ksvd:����ֵ�

P = extract_Patches(X, patch_size, 1);%��ͼ��飬���1����
if size(P, 2) > 2000%ͼ�����Ŀ����2000���������ȡǰ2000��
    r = randperm(size(P, 2));
    P = P(:, r(1: 2000));
end
params.data = P;
params.Tdata = 4;
params.dictsize = min(4*patch_size^2, size(P, 2));
params.iternum = 20;
params.memusage = 'high';
[D_ksvd, ~, ~]=ksvd(params, '');