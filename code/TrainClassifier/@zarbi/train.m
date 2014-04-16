function [data, model]=train(model, data)
%[data, model]=train(model, data)
% Simple linear classifier following Golub's method.
% Inputs:
% model     -- A zarbi learning object.
% data      -- A data object.
% Returns:
% model     -- The trained model.
% data      -- A new data structure containing the results.

% Isabelle Guyon -- isabelle@clopinet.com -- May 2005

fprintf('==> Training zarbi... ');
X=data.X;
Y=data.Y;
Posidx=find(Y>0);
Negidx=find(Y<0);
Mu1=mean(X(Posidx,:), 1);
Mu2=mean(X(Negidx,:), 1);
Var1=runvar(X(Posidx,:));
Var2=runvar(X(Negidx,:));
Sigma1=sqrt(Var1);
Sigma2=sqrt(Var2);
fudge=median(Sigma1+Sigma2);
model.W=(Mu1-Mu2)./(fudge+(Sigma1+Sigma2)+eps);
B=(Mu1+Mu2)/2;
% Test the model
data=test(model, data);
fprintf('done\n');

function v=runvar(X)
%v=runvar(X)
% Running average variance.
% Suitable for matrices X with large numbers of lines or columns.
% Returns the variance of the columns. Normalizes by n.

% Isabelle Guyon -- isabelle@clopinet.com -- October 2003

[p,n]=size(X);
mu=mean(X);
v=zeros(1,n);
v=(X(1,:)-mu).^2;
for i=2:p
    x2=(X(i,:)-mu).^2;
    v=((i-1)/i)*v+(1/i)*x2;
end