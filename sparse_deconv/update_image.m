function x = update_image(y, k, x, par)
%Inputs:
%    y: blurred image
%    k: estimated kernel
%    x: initial estimated latent image
%    par: other parameters
%Outputs:
%    x: recovered image

y = edgetaper(y, k);
x_scale = imresize(x, par.scale, par.sinc);
for iter = 1: par.inner_iter_n
   z_non_local = non_local_reconstruct(x, x_scale, par);
   z_sparse = sparse_reconstruct(x, par);
   x = latent_estimate(y, k, z_non_local, z_sparse, par.lambda_non_local, ...
                      par.lambda_sparse, par.lambda_gradient);
%     z_sparse = sparse_reconstruct(x, par);
%     x = latent_estimate(y, k, 0, z_sparse, 0, par.lambda_sparse, ...
%                         par.lambda_gradient);
%     z_non_local = non_local_reconstruct(x, x_scale, par);
%     x = latent_estimate(y, k, z_non_local, 0, par.lambda_non_local, 0, ...
%                         par.lambda_gradient);
    if(par.imshow)
        figure(1);suptitle(sprintf('iteration %d', iter));
        subplot(2,2,1);imshow(y);title('blur image y')
        subplot(2,2,2);imshow(z_non_local);title('update z non local');
        subplot(2,2,3);imshow(z_sparse);title('update z sparse');
        subplot(2,2,4);imshow(x);title('update x')
    end
end
x(x>1) = 1;
x(x<0) = 0;


function x = latent_estimate(y, k, z_non_local, z_sparse, ...
                            lambda_non_local, lambda_sparse, lambda_gradient)
Fk = psf2otf(k, size(y));
Fpx = psf2otf([1,-1], size(y));
Fpy = psf2otf([1;-1], size(y));
Fp_norm = abs(Fpx).^2 + abs(Fpy).^2;
nomin = Fp_norm.*conj(Fk).*fft2(y) + lambda_non_local*fft2(z_non_local) + ...
        lambda_sparse*fft2(z_sparse);
deno = Fp_norm.*abs(Fk).^2 + lambda_non_local + lambda_sparse + ...
        lambda_gradient*Fp_norm;
x = real(ifft2(nomin ./ deno));
