function D_ksvd = Dictionary_train(X, patch_size)

P = extract_patches(X, patch_size, 1);%抽图像块，间隔1像素，大小5*5,结果排成列向量，所以共33×33=1089列
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

%[D_ksvd, ~] = grams(D_ksvd);


function [Q, R] = grams(A)
% grams  Gram-Schmidt orthogonalization of the columns of A.
% The columns of A are assumed to be linearly independent.
%
% Q = grams(A) returns an m by n matrix Q whose columns are 
% an orthonormal basis for the column space of A.
%
% [Q, R] = grams(A) returns a matrix Q with orthonormal columns
% and an invertible upper triangular matrix R so that A = Q*R.
%
% Warning: For a more stable algorithm, use [Q, R] = qr(A, 0) .

[m, n] = size(A);
Asave = A;
for j = 1:n
  for k = 1:j-1
    mult = (A(:, j)'*A(:, k)) / (A(:, k)'*A(:, k));
    A(:, j) = A(:, j) - mult*A(:, k);
  end
end
for j = 1:n
  if norm(A(:, j)) < sqrt(eps)
    error('Columns of A are linearly dependent.')
  end
  Q(:, j) = A(:, j) / norm(A(:, j));
end
R = Q'*Asave;
