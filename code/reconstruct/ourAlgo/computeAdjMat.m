function Am  = computeAdjMat(T)

n = size(T,2);
m = size(T,1);

Am = zeros(n,n);
startt = time;
for i = 1:m-1
	timeSlice1 = T(i, :);
	timeSlice2 = T(i+1,:);

	for j = 1:n
		if(timeSlice1(j)==1)
			for k = 1:n
				if(timeSlice2(k)==1 && j !=k)
					Am(j,k) = Am(j,k) + 1;	
				endif
			endfor
		endif
	endfor  
endfor
time - startt