function K=construct_kernel_matrix(X,Y,kernel_option);
% This function constructs the kernel matrix by using selected
% kernel function type and its parameters.
%
% Inputs 
% X - dxM data matrix whose columns are samples in d-dimensional space
% Y - dxN data matrix whose columns are samples in d-dimensional space
% kernel_option - a struct type including kernel function parameters
%   kernel_option -  Choices are:
%        kernel_option.type = 'linear','polynomial','gaussian', and 'chi_square'
%        kernel_option.par = polynomial function degress such as '2','3' or
%        width of the exponential, q, i.e., exp(-DD/q).
% Outputs
% K - MxN kernel matrix
% 
% Written by Hakan cevikalp, 9/3/2007.
   
[d,N]=size(Y);
[d,M]=size(X);
if strcmpi(kernel_option.type,'linear'),
    K=slmetric_pw(X, Y,'dotprod');
elseif strcmpi(kernel_option.type,'polynomial')
    K=X'*Y;
    K=K.^kernel_option.par;
elseif strcmpi(kernel_option.type,'gaussian')
    K=sqrDist(X,Y)';
    K=exp(-K/(2*kernel_option.par^2));
elseif strcmpi(kernel_option.type,'chi_square');
    K=slmetric_pw(X, Y,'intersect');
end