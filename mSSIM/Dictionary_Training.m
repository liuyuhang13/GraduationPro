function KSVD_D=Dictionary_Training(par)


% Set the parameters
b           =   7;
ws          =   3;
delta       =   4.4;
psf         =   fspecial('gauss', 7, 1.5);
%psf = par.psf;

if (size(par.LR,3)==3)
    LR= rgb2ycbcr(uint8(par.LR));
    LR=LR(:,:,1);
end
LR=par.LR;
X    =   Get_patches( LR, b, psf );



N    =   size(X, 2);
P    =   randperm(N)';
X    =   X(:, P);
X=double(X);
clear P;

params.preserveDCAtom=1;
params.data=X;
params.errorFlag=0;
params.K=49;
params.numIteration=10;
params.L=15;
%params.errorGoal=0.1;
params.InitializationMethod='DataElements';
%params.InitializationMethod='GivenMatrix';
% params.displayProgress=1;
%params.initialDictionary=D;
%params.memusage='high';
[KSVD_D,output]=KSVD(X,params);

