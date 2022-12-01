[y_1, Fs] = audioread('AudioTest.wav');
y = y_1(:,1);
%Fsorignal = Fsorignal/6;
Fs = Fs/44;
y = resample(y,1,44);
sound_duration = length(y)/Fs;
t = 0:1/Fs:sound_duration;
t = t(1:end-1);
InsignalLength = length(t);
%%
%%soundsc(y,Fs);
%%
subplot(4,2,1);
plot(t,y);
xlabel('Time');
ylabel('Audio Signal');
title('Original signal');
p1 = (sum(y(2:end).*y(1:end-1).*(1/length(y))))/(sum(y(1:end-1).*y(1:end-1).*(1/length(y))))
p2 = (sum(y(3:end).*y(1:end-2).*(1/length(y))))/(sum(y(1:end-2).*y(1:end-2).*(1/length(y))))
actf =autocorr(y)
%%p1 = 
%%
%%LPc model of two paramters 
L = zeros(1,InsignalLength);
coff1 = p1*(1-p2)/(1-p1^2);
coff2 = (p2-p1^2)/(1-p1^2)
L(1) = coff2*y(1);
L(2) = coff1*y(2);
for i = 3:InsignalLength
    L(i) = coff1*y(i-1) + coff2*y(i-2);
    %L(i) = 2*y(i-1)  - y(i-2);
end
subplot(4,2,2);
plot(t,L);
title('lpc signal second order')
subplot(4,2,3);
plot(t,(L-transpose(y)).^2);
title('lpc error second order')
soundsc(L,Fs);
%%
%%making the lpc model
%%first calculating the a
alphaVar = 0.53;
%%p1 = (sum(y(2:end).*y(1:end-1).*(1/length(y))))/(sum(y(1:end).*y(1:end).*(1/length(y))));
%%p2 = (sum(y(3:end).*y(1:end-2).*(1/length(y))))/(sum(y(1:end).*y(1:end).*(1/length(y))));
%%p3 = (sum(y(4:end).*y(1:end-3).*(1/length(y))))/(sum(y(1:end).*y(1:end).*(1/length(y))));
a = gamma(alphaVar + 1)*((p1 - alphaVar*p2)/(1 - 2*alphaVar*p1 + alphaVar^2));

FPSignal = (a/gamma(1+alphaVar)).*((cat(1,y(2:end),zeros(1,1))) - alphaVar.*y(1:end));
%%FPSignal = FPSignal1.*(y(999)/FPSignal1(1000));
subplot(4,2,4);
plot(t,FPSignal);
xlabel('Time');
ylabel('Audio Signal');
title('Using an FPC')
subplot(4,2,5);
plot(t,(FPSignal-y).^2);
title('FPC error')

%subplot(4,2,6);
%plot(t,FPSignal-transpose(L));
%%soundsc(FPSignal,Fs);
%% first order lpc
L1 = zeros(1,InsignalLength);
%L1(2) = y(1);
for i = 2:InsignalLength
    L1(i) = y(i-1);
end
subplot(4,2,6);
plot(t,L1);
title('lpc signal first order')
subplot(4,2,7);
plot(t,(L1-transpose(y)).^2);
title('lpc error first order')
%%soundsc(L1,Fs);
%subplot(4,2,6);
%plot(t,L1-L);
sum((L1-transpose(y)).^2-((L-transpose(y)).^2))*1/(length(L))
