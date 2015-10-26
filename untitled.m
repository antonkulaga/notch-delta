%% Reset
clear
clc
clf

%% Plot 1 - S,Dtrans

sp1 = subplot(2,2,1);

D0 = 200;                %free cis-Delta
S0 = 0;                  %intracellular domain of Notch

tf = 60;                 %t final
dt = 0.001;              %step
tfs = tf/dt - 1;         %tf ajusted for step

betaN = 1;               %production rate of Notch
betaD = 0;               %production rate of Delta
gamma = 0.1;             %combined degradation and dilution rate
gammaS = 0.1;            %rate of decay of S
kc = 0.2;                %strenght of cis-inhibition
kt = 2;                  %strenght of transactivation
Ntrans = 0;              %Notch in neighboring cell

for Dtrans = [0.063 0.084 0.11 0.15 0.20 0.26 0.35 0.46 0.62 0.82 1.1 1.4]
    
    N0 = betaN./(gamma + D0./kc + Dtrans./kt);                            %free Notch
    
    y = elow(N0,D0,S0,tf,dt,betaN,betaD,gamma,gammaS,kc,kt,Ntrans,Dtrans);
    S = y(3,:);
    x = y(4,:);
    pS = plot(x,S);               %plot S
    hold on
end
hold off

title('')
legend('0.063 ug.ml^-^1','0.084 ug.ml^-^1','0.11 ug.ml^-^1','0.15 ug.ml^-^1',...
    '0.20 ug.ml^-^1','0.26 ug.ml^-^1','0.35 ug.ml^-^1','0.46 ug.ml^-^1',...
    '0.62 ug.ml^-^1','0.82 ug.ml^-^1','1.1 ug.ml^-^1','1.4 ug.ml^-^1'...
    ,'Location','northwest')
xlabel('Time (h)')
ylabel('Reporter (10^4 a.u.)')

pN.LineWidth = 2;
pD.LineWidth = 2;
pS.LineWidth = 2;

%% Plot 2 - S,Dtrans,t

sp2 = subplot(1,2,2);

D0 = 200;                %free cis-Delta
S0 = 0;                  %intracellular domain of Notch

tf = 60;                 %t final
dt = 0.001;              %step
tfs = tf/dt - 1;         %tf ajusted for step

betaN = 1;               %production rate of Notch
betaD = 0;               %production rate of Delta
gamma = 0.1;             %combined degradation and dilution rate
gammaS = 0.1;            %rate of decay of S
kc = 0.2;                %strenght of cis-inhibition
kt = 2;                  %strenght of transactivation
Ntrans = 0;              %Notch in neighboring cell


for Dtrans = [0.063 0.084 0.11 0.15 0.20 0.26 0.35 0.46 0.62 0.82 1.1 1.4] %trans-Delta = concentration of neighboring Delta = Dplate
    
    N0 = betaN./(gamma + D0./kc + Dtrans./kt);                            %free Notch
    
    y = elow(N0,D0,S0,tf,dt,betaN,betaD,gamma,gammaS,kc,kt,Ntrans,Dtrans); %run Euler aproximation
    S = y(3,:);
    x = y(4,:);
    
    treshold = 0.25;                                                       %determination of treshold point S(treshold)
    k = size(S,2);                                                         
    while S(k) > treshold && k > 0
        k = k-1;
    end
    
    scatter3(ones(1,size(S,2)-k).*Dtrans,x(1,k+1:size(S,2)),...            %plot S part above treshold in green
        S(1,k+1:size(S,2)),0.1,'.','green');
    hold on
    scatter3(ones(1,k).*Dtrans,x(1,1:k),S(1,1:k),0.1,'.','black');         %plot S part under treshold in black
    hold on

end
hold off


title('Notch response to both {\itcis-} and {\ittrans-}Delta')
xlabel('Dplate (ug.ml^-^1)')
ylabel('Time (h)')
ylim([0 tf])
zlabel('Reporter (10^4 a.u.)')

%% Plot 3 - receiver/sender

sp3 = subplot(2,2,3);

tf = 6;                 %t final
dt = 0.001;              %step
tfs = tf/dt - 1;         %tf ajusted for step

betaN1 = 1;               %production rate of Notch cell 1
betaD1 = 0;               %production rate of Delta cell 1
betaN2 = 0;               %production rate of Notch cell 2
betaD2 = 0.75;               %production rate of Delta cell 2
gamma = 0.1;             %combined degradation and dilution rate
gammaS = 0.1;            %rate of decay of S
kc = 0.2;                %strenght of cis-inhibition
kt = 2;                  %strenght of transactivation
Ntrans = 0;              %Notch in neighboring cell

D = 0;                %free cis-Delta
S = 0;                  %intracellular domain of Notch
N = 0;               %free Notch

N1 = [N zeros(1,tfs)];   %preallocating space
D1 = [D zeros(1,tfs)];   %preallocating space

N2 = [N zeros(1,tfs)];   %preallocating space
D2 = [D zeros(1,tfs)];   %preallocating space

for k = 1:tfs
    y = elowSS(N1(k),D1(k),S,dt,betaN1,betaD1,gamma,gammaS,kc,kt,N2(k),D2(k));
    N1(k+1) = y(1);
    D1(k+1) = y(2);
    y = elowSS(N2(k),D2(k),S,dt,betaN2,betaD2,gamma,gammaS,kc,kt,N1(k),D1(k));
    N2(k+1) = y(1);
    D2(k+1) = y(2);
end

x = 0:dt:tf-dt;                %x axis scale


plot(x,N1)
hold on
plot(x,D1)
plot(x,N2)
plot(x,D2)
