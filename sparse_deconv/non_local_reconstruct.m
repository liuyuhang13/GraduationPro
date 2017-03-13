function x_out = non_local_reconstruct(x, x_scale, par)
% Input:
%   x: image to be reconstructed
%   x_scale: scaled version of x
%   par: other parameters
% Output:
%   x_out: reconstructed image

p = par.patch_size;
x = padarray(x, [p-1, p-1], 'replicate');
[R_idx, C_idx] = nearest_neighbour_field(x, x_scale, p);
[h, w] = size(x);
h_s = size(x_scale, 1);
idx = R_idx + (C_idx-1)*h_s;
x_out = zeros(h, w);
for j = 1: p
    for i = 1: p
        offset = i-1 + (j-1)*h_s;
        x_out(i:h-p+i, j:w-p+j) = x_out(i:h-p+i, j:w-p+j) + reshape(x_scale(idx + offset), h-p+1, w-p+1);
    end
end
x_out = x_out(p:h-p+1, p:w-p+1) / (p*p);

function [R_idx, C_idx] = nearest_neighbour_field(A, B, p)
    [mA, nA] = size(A);
    [mB, nB] = size(B);
    A_color = zeros([mA, nA, 3], 'uint8');
    B_color = zeros([mB, nB, 3], 'uint8');
    for i = 1: 3
        A_color(:, :, i) = uint8(A*255);
        B_color(:, :, i) = uint8(B*255);
    end
%    [~, C_idx, R_idx] = run_TreeCANN(A_color, B_color, p, 1, 1, 100, 15, 0, 9, 5);
    [~, C_idx, R_idx] = run_TreeCANN(A_color, B_color, p, 1, 1, 100, 9, 2, 5, 3);
    C_idx = C_idx(1: end-p+1, 1: end-p+1);
    R_idx = R_idx(1: end-p+1, 1: end-p+1);
    C_idx = C_idx(:);
    R_idx = R_idx(:);
