function [coefficient_A,coefficient_B,dis]=CRT(A,B,kernel_option,C,DD,nT)
% This function computes the nearest distance between 
A       =    A./ repmat(sqrt(sum(A.*A)),[size(A,1) 1]); % unit norm 2
B       =    B./ repmat(sqrt(sum(B.*B)),[size(B,1) 1]); % unit norm 2
% affine hulls of sample sets of A and B.
m=size(A,2);
n=size(B,2);
Q=zeros(m+n,m+n);
%keyboard
Q(1:m,1:m)=construct_kernel_matrix(A,A,kernel_option);
temp=construct_kernel_matrix(A,B,kernel_option);
Q(1:m,m+1:m+n)=-temp;
Q(m+1:m+n,1:m)=Q(1:m,m+1:m+n)';
Q(m+1:m+n,m+1:m+n)=DD;
Aeq=zeros(2,m+n);
Aeq(1,1:m)=1;
Aeq(2,m+1:m+n)=1;
beq=[1 1]';
LB=0;
UB=C*ones(m+n,1);

opts = optimset('Algorithm','interior-point-convex','Display','off');
[alpha,fval,exitflag]=quadprog(2*Q,[],[],[],Aeq,beq,LB,UB,[],opts);
coefficient_A=alpha(1:m);
coefficient_B=alpha(m+1:m+n);
dis=0;