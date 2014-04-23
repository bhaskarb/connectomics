function Am  = computeAdjMatFast(T)

n = size(T,2);
m = size(T,1);

Am = zeros(n,n);
startt = time;
for i = 1:n
	Ti = repmat(T(1:m-1, i), 1, n - 1);
	if (i == 1)
		Tjnoti = T(2:m, 2:n);
	elseif (i == n)
		Tjnoti = T(2:m, 1:n-1);
	else
		Tjnoti = [T(2:m, 1:i-1) T(2:m, i+1:n)];
	endif
	%Trelated = Ti == Tjnoti;
	Trelated = Ti & Tjnoti;
	%sTrelated = sign(Trelated - 0.5);
	%sTnumedge = sum(sTrelated);
	%pTnumedge = sTnumedge > 0;
	%ploc = find(pTnumedge);
	%Tnumedge = zeros(size(sTnumedge));
	%Tnumedge(ploc) = sTnumedge(ploc);
	Tnumedge = sum(Trelated);
	if(i == 1)
		Am(i, :) = [0 Tnumedge];
	elseif(i == n)
		Am(i, :) = [Tnumedge 0];
	else
		Am(i, :) = [Tnumedge(1:i-1) 0 Tnumedge(i:n-1)];
	endif
endfor
time - startt