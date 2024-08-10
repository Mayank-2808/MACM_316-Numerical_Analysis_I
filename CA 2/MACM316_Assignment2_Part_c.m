% PART (c)

n = 100;
b = (1:n)';

% Sparse tridiagonal matrix of size nxn
e = ones(n, 1);
A_n = spdiags([e -2*e e], -1:1, n, n);

% Inverse of A_n
x_inv = inv(A_n) * b;

% LU decomposition
[L, U, P] = lu(A_n);
y = inv(L) * b;
x_lu = inv(U) * y;

difference_vector = x_inv - x_lu;