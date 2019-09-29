path = 'C:\';
filename = ['.txt'];
file = fopen([path, filename]);

Nr = 128;
Nd = 64;

for k = 1:1
    is = [];qs = [];
    itemp = [];qtemp = [];
    for j = 1:Nd
        pre=fscanf(file,'%s',[1 12])
        for i = 1:Nr
            low8=fscanf(file,'%s',[1 1]);
            high8=fscanf(file,'%s',[1 1]);
            itemp(i)=hex2dec([high8, low8]);
        end
        is = [is;itemp];
        
        pre=fscanf(file,'%s',[1 11])
        for i=1:Nr
            low8=fscanf(file,'%s',[1 1]);
            high8=fscanf(file,'%s',[1 1]);
            qtemp(i)=hex2dec([high8, low8]);
        end
        qs = [qs;qtemp];
    end
    signal=complex(is, qs);
    
    %fft2
    Y=fft(abs(signal'), Nr);
    Y=fft(Y', Nd);
    Y=fftshift(Y);
    yy=abs(Y);
    yy(Nd/2+1,Nr/2)=0;yy(Nd/2+1,Nr/2+1)=0;yy(Nd/2+1,Nr/2+2)=0;
    yy = 10*log10(yy); 
    figure;surf(yy);title(k);
end
