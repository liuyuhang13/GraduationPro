function [ spco ] = searchSimilarPatches(R,C,img_patches,patch_size,img_size,d )
%searchSimilarPatches ���ݸ���ͼ�������Ͻ����꣬�Լ�ͼ����С�����������Ѱ�ҷ�������ͼ�������Ͻ�������
%   R������ͼ���������
%   C:����ͼ���������
%   img_patches:ͼ��鼯
%   patch_size:ͼ����С
%   img_size:ͼ���С
%   d:�������
%   spco:����ͼ������Ͻ�������ɵľ���[]��û���ҵ�����ͼ���
%        ÿ��Ϊһ������
    spco = [];
    num_of_each_row = floor((img_size - patch_size)/d)+1;   %ÿһ�е�ͼ�����Ŀ
    patch_index = (R-1) * num_of_each_row + (C-1)/d+1;  %����������ͼ��鼯�������ת��
    
    x_temp = size(img_patches);
    
    for x = 1:x_temp(2)
        cor = corrcoef(img_patches(:,x),img_patches(:,patch_index));
        distance = sum((img_patches(:,x)-img_patches(:,patch_index)).^2);
        %�������ǻ��������ļ��裬�����ܹ�ʶ��ĻҶȼ����Ϊ30���ң�ͼ���һ��49�����أ�
        %������Ϊ2/30*1/30*50��0.05Ϊ��˹������ֵ
        if (cor>0.75)&(distance<0.10)&(x~=patch_index)
            spco = [spco;x];
        end
    %     distance(x) = sum((img_patches(:,x)-img_patches(:,3000)).^2);
    end
 
end

