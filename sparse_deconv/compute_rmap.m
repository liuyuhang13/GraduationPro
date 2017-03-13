function rmap = compute_rmap(img, preblur_sigma, w)

if (preblur_sigma>0)
    h1 = fspecial('gaussian', round(preblur_sigma*6), preblur_sigma);
    img = imfilter(img, h1, 'same', 'replicate');
end

h2 = ones(w, w);
[gx gy] = gradient(img);
gx_sum = imfilter(gx, h2, 'same', 'replicate');
gy_sum = imfilter(gy, h2, 'same', 'replicate');
top = gx_sum.^2 + gy_sum.^2;
bot = imfilter(gx.^2+gy.^2, h2, 'same', 'replicate') + 0.1;
rmap = top./bot;
end
