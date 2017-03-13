function [P, r, c] = extract_patches(im, p, s)
% p: batch size
% s: step.Every s pixels pick out one batch,for both row and column.

[h, w] = size(im);
[r, c] = get_patch_grid(h, w, p, s);
P = zeros(p*p, length(r)*length(c));

k = 0;
for j = 1: p
    for i = 1: p
        k = k+1;
        blk = im(r-1+i,c-1+j);
        P(k, :) = blk(:)';
    end
end


function [r, c] = get_patch_grid(h, w, p, s)
% h: height of image used for patch extraction
% w: width of image used for patch extraction
% p: patch size
% s: grid step

N = h - p + 1;
M = w - p + 1;
r = 1: s: N;
r = [r, r(end)+1:N];%这一步是要干嘛？目前没看出来有什么用。。
c = 1: s: M;
c = [c, c(end)+1:M];
