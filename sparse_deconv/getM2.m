function  M=getM2(s,Mfilters,opts)
% s is the sharp image (has noise and possible rings)

% do multi direction oriental energy compute
% merge result for a final mask...

[h w]=size(s);
omasks=zeros(h, w,numel(Mfilters));
for i=1:numel(Mfilters)
    tmp=imfilter(s,Mfilters{i},'same','replicate');
    tmp=tmp.^2; %===> magnitude!!!

    currth=prctile(tmp(:),opts.sharp_prcthreshold);
    currm=tmp>currth;
    currm = bwmorph(currm,'thin',Inf);
    omasks(:,:,i)=currm;
end
M=sum(omasks,3);
M=M>0;

CC = bwconncomp(M,8);
for ii=1:CC.NumObjects
    currsum=sum(M(CC.PixelIdxList{ii}));
    if currsum<opts.currminL
        M(CC.PixelIdxList{ii}) = 0;
    end
end

M = imdilate(M, strel('disk',1));

end
