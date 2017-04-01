function [R_idx, C_idx] = nearest_Neighbour_Field(A, B, p)
%nearest_Neighbour_Field ��������ͼ��A����Ŀ��ͼ��B����ͼ����NNs,�������Ͻ�����
%   A:Դͼ��
%   B:Ŀ��ͼ��
%   p:ͼ����С
%   R_idx:NNs������
%   C_idx:NNs������
    [mA, nA] = size(A);
    [mB, nB] = size(B);
    A_color = zeros([mA, nA, 3], 'uint8');
    B_color = zeros([mB, nB, 3], 'uint8');
    for i = 1: 3
        A_color(:, :, i) = uint8(A*255);
        B_color(:, :, i) = uint8(B*255);
    end
%    [~, C_idx, R_idx] = run_TreeCANN(A_color, B_color, p, 1, 1, 100, 15, 0, 9, 5);
    [~, C_idx, R_idx] = run_TreeCANN(A_color, B_color, p, 2, 1, 100, 9, 2, 5, 3);
    
    %A,B, [patch_w=8], [A_grid = 2], [B_grid = 2], [num_of_train_patches = 100], [num_PCA_dims=patch_w/2+3], [eps=3], [num_of_ann_matches=4], [A_win=2*A_grid+1]
%     C_idx = C_idx(:);
%     R_idx = R_idx(:);
% 
