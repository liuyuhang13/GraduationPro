function k = cut_kernel(k)
% Cut extra kernel so that cutted kernel is compact and centered.
[mk, nk] = size(k);
margin = 3;
Sc = sum(k > 0);
L = max(find(Sc, 1) - margin, 1);
R = min(find(Sc, 1, 'last') + margin, nk);
Sr = sum(k > 0, 2);
T = max(find(Sr, 1) - margin, 1);
B = min(find(Sr, 1, 'last') + margin, mk);
k = k(T: B, L: R);

[mk, nk] = size(k);
centroid = regionprops(ones(size(k)), k, 'WeightedCentroid');
centroid = centroid.WeightedCentroid;
c_x = round(centroid(1));
c_y = round(centroid(2));
if(c_x > nk-c_x)
    k = padarray(k, [0,2*c_x-nk], 0, 'post');
else
    k = padarray(k, [0,nk-2*c_x], 0, 'pre');
end
if(c_y > mk-c_y)
    k = padarray(k, [2*c_y-mk,0], 0, 'post');
else
    k = padarray(k, [mk-2*c_y,0], 0, 'pre');
end
if mod(size(k,1), 2) == 0
    k = padarray(k, [1,0], 0, 'pre');
end
if mod(size(k,2), 2) == 0
    k = padarray(k, [0,1], 0, 'pre');
end