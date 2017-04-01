function [P, r, c] = extract_Patches(im, p, s)
%extract_Pathces ����ͼ����С����ȡ���������ͼ��im�г�ȡͼ���
%   im: ����ͼ��
%   p:  Patch size
%   s:  step.Every s pixels pick out one batch,for both row and column.
%   P:  ���ͼ���
%   r:  �з����������
%   c:  �з����������
[h, w] = size(im);
[r, c] = get_Patch_grid(h, w, p, s);
P = zeros(p*p, length(r)*length(c));

k = 0;
for j = 1: p
    for i = 1: p
        k = k+1;
        blk = im(r-1+i,c-1+j);
        P(k, :) = blk(:)';
    end
end


function [r, c] = get_Patch_grid(h, w, p, s)
% h: height of image used for patch extraction
% w: width of image used for patch extraction
% p: patch size
% s: grid step

N = h - p + 1;
M = w - p + 1;
r = 1: s: N;
% r = [r, r(end)+1:N];%��һ����Ҫ���Ŀǰû��������ʲô�á���
c = 1: s: M;
% c = [c, c(end)+1:M];

