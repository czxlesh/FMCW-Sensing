fs = 100e3;
B = 1e9;
T = 1.28e-3;
c = 3e8;

s=serial('com7');
set(s,'BaudRate',921600,'StopBits',1,'Parity','none','DataBits',8,'OutputBufferSize',1024);
fopen(s);


for k = 1:50    %50seconds
%     display([k]);
    flag = 0;
    pre=fread(s,1,'uint8');
    if flag == 0
        while pre~=238
            pre=fread(s,1,'uint8');
        end
        pre=fread(s,11,'uint8');
        if pre==[238,238,238,238,238,238,238,238,238,238,238]
            flag = 1;
            pre = fread(s,128,'uint16');
            pre = fread(s,11,'uint8');
            pre = fread(s,128,'uint16');
        end
    end
    
    
    is = [];
    qs = [];
    itemp = [];
    qtemp = [];
    for j=1:128    %128 chirps
        pre = fread(s,12,'uint8');
        itemp = fread(s,128,'uint16');
        is = [is;itemp'];
        
        pre = fread(s,11,'uint8');
        qtemp = fread(s,128,'uint16');
        qs = [qs;qtemp'];
    end
    signal=complex(is,qs);

    y=abs(fftshift(fft(signal')));
    sum_amp=sum(y');
    sum_amp=sum_amp(end/2+1:end);
    freq=(64:128-1)*fs/128-fs/2;
    plot(freq/1000,samp);

    drawnow;
    [maxv,maxl]=findpeaks(sum_amp);
    [maxvv,idx]=max(maxv);
    fr=freq(maxl(idx));
    dis=fr/B*T*c/2;
    display([dis*100]);
end

fclose(s);
