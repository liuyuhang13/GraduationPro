function [Q, R] = grams(A)

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

