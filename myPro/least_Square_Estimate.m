function [ k ] = least_Square_Estimate( patch_Q,r_idx,c_idx,I_L,is_found,KERNEL_RADIUS,PATCH_SIZE)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
I_L_LS = padarray(I_L,[KERNEL_RADIUS,KERNEL_RADIUS],'replicate');
 r_idx = r_idx + KERNEL_RADIUS;
 c_idx = c_idx + KERNEL_RADIUS;
%  figure;
%  imshow(I_L_LS);
 q_LS=[];r_LS=[];
 tic;
 for x = 1:10
     if(is_found(x))
        q_LS = [q_LS;patch_Q(:,x)];
        for c = 0:2:2*PATCH_SIZE-1
            for r = 0:2:2*PATCH_SIZE-1
                r_start = r_idx(x)+r-KERNEL_RADIUS;
                r_end = r_idx(x)+r+KERNEL_RADIUS;
                c_start = c_idx(x)+c-KERNEL_RADIUS;
                c_end = c_idx(x)+c+KERNEL_RADIUS;
                temp = I_L_LS(r_start:r_end,c_start:c_end);
                r_LS = [r_LS;temp(:)'];
            end
        end   
     end
 end
 cond(r_LS)
 %Ly是核y方向偏导数表示
 Ly = zeros(72,81);
 y = 0;
 for x = 1:72
     y=y+1;
     Ly(x,y) = -1;
     Ly(x,y+1) = 1;
    if(mod(x,8)==0) y = y+1;end
 end
 %Lx是x方向偏导数表示
 Lx = zeros(72,81);
 for x = 1:72
     Lx(x,x) = -1;
     Lx(x,x+9) = 1;
 end
 
%  k = (r_LS'*r_LS)\r_LS'*q_LS;
 k = (r_LS'*r_LS+20*Lx'*Lx+20*Ly'*Ly)\r_LS'*q_LS;

 toc;
% figure( 'Name','建立方程的25个图像块','NumberTitle','off');
%  for x = 1:25;
%      subplot(5,5,x);
%      imshow(reshape(r_LS(x,:),9,9));
%  end

end

