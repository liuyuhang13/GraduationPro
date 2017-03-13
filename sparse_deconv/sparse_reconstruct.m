function x_out = sparse_reconstruct(x, par)
% Input:
%   x: image to be reconstructed
%   par: other parameters
% Output:
%   x_out: reconstructed image

patch_size = par.patch_size;
D = par.KSVD_D;
[P, r, c] = extract_patches(x, patch_size, 1);
N = length(r);
M = length(c);

%% sparse reconstruction from Pan ZongXu.
%tau = 0.001;
%P = D*soft(D'*P, tau);
%% sparse reconstruction from ChangZhenChun
T = 4;
P = D*omp(D'*P, D'*D, T);

x_out = zeros(size(x));
cnt = zeros(size(x));
k = 0;
for j = 1: patch_size
    for i = 1: patch_size
        k = k+1;
        x_out(r-1+i,c-1+j) = x_out(r-1+i,c-1+j) + reshape(P(k, :)', [N M]);
        cnt(r-1+i,c-1+j) = cnt(r-1+i,c-1+j) + 1;
    end
end
x_out = x_out./(cnt+eps);


function y = soft(x,tau)
y = sign(x).*max(abs(x)-tau,0);
