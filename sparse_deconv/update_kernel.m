function k = update_kernel(x, y, sizek, lambda, par)
[nomin, deno] = get_const(x, y, lambda, par);
k = real(otf2psf(nomin./deno, sizek));
k(k<0) = 0;
S = partial_support(k, 2);
S = imdilate(S, strel('disk', 1));
k(~S) = 0;
k = k./sum(k(:));


function [nomin, deno] = get_const(x, y, lambda, par)
[Gxx, Gxy] = imgradientxy(x, 'IntermediateDifference');
%m = (Gxx.^2 + Gxy.^2)>=par.tau;    %old used mask
m = par.M;
Gxx(~m) = 0;
Gxy(~m) = 0;
FGxx = fft2(Gxx);
FGxy = fft2(Gxy);
[Gyx, Gyy] = imgradientxy(y, 'IntermediateDifference');
FGyx = fft2(Gyx);
FGyy = fft2(Gyy);
nomin = conj(FGxx).*FGyx + conj(FGxy).*FGyy;
deno = abs(FGxx).^2 + abs(FGxy).^2 + lambda;


function S = partial_support(k, i)
k_sorted = sort(k(:));
thres = k_sorted(end) / (2*i*sqrt(numel(k)));
diff_k = diff(k_sorted);
j = find(diff_k > thres, 1)+1;
if(isempty(j))
    epsilon_s = 0;
else
    epsilon_s = k_sorted(j);
end
S = k >= epsilon_s;
