function [Bp, MKp, NKp, scales] = build_pyramid(B, Mk, Nk, interp_method, ...
                                                scale_multiplier)
% Build image pyramid.
% Args:
%   B: Blurred image.
%   MK: Kernel's height.
%   NK: Kernel's width.
%   interp_method: interpolation method.²åÖµ·½·¨
%   scale_multiplier: 
% Returns:
%   Bp: A cell containing images on level p.
%   MKp: Height of kernel on level p.
%   NKp: Width of kernel on level p.
%   scales: 

[M, N, ~] = size(B);
smallest_scale = 3;
if(~exist('interp_method', 'var'))
    interp_method = 'bilinear';
end
if(~exist('scale_multiplier', 'var'))
    scale_multiplier = 1.1;
end

scales = 1;
Bp{scales} = B;
MKp{scales} = Mk;
NKp{scales} = Nk;

while(MKp{scales} > smallest_scale && NKp{scales} > smallest_scale)
   scales = scales + 1;
   MKp{scales} = round(MKp{scales - 1} / scale_multiplier);
   NKp{scales} = round(NKp{scales - 1} / scale_multiplier);
   if(mod(MKp{scales} , 2) == 0)
       MKp{scales} = MKp{scales} - 1;
   end
   if(mod(NKp{scales} , 2) == 0)
       NKp{scales} = NKp{scales} - 1;
   end
   if(MKp{scales} == MKp{scales - 1})
       MKp{scales} = MKp{scales} - 2;
   end
   if(NKp{scales} == NKp{scales - 1})
       NKp{scales} = NKp{scales} - 2;
   end
   if(MKp{scales} < smallest_scale)
       MKp{scales} = smallest_scale;
   end
   if(NKp{scales} < smallest_scale)
       NKp{scales} = smallest_scale;
   end

%   factorM = MKp{scales - 1}  / MKp{scales};
%   factorN = NKp{scales - 1}  / NKp{scales};
   factorM = scale_multiplier; 
   factorN = scale_multiplier; 
   M = round(M / factorM);
   N = round(N / factorN);
   if(mod(M, 2) == 0)
       M = M - 1;
   end
   if(mod(N, 2) == 0)
       N = N - 1;
   end
   Bp{scales} = imresize(B, [M, N], 'Method', interp_method);
end
