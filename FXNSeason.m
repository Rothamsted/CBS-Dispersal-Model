function [totY,totC1,totC2,ainf,finf,Ssource,variety]=FXNSeason(X,source,cuttings1,cuttings2)
global  FIELDS MAXYIELD revrate1 revrate2 select1 select2 yield1 yield2 use1 use2
% Idenify results from each season, including the total yield, total number
% of infected cuttings of each variety, average infection, number of ifelds
% infected, source of infection and average amount of variety 2 in the
% landscape
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Identifying the last timestep
final=size(X,1);
% Identifying results from this season
S1=X(:,1:FIELDS);L1=X(:,FIELDS+1:2*FIELDS);I1=X(:,2*FIELDS+1:3*FIELDS);R1=X(:,3*FIELDS+1:4*FIELDS);C1=X(:,4*FIELDS+1:5*FIELDS);
S2=X(:,5*FIELDS+1:6*FIELDS);L2=X(:,6*FIELDS+1:7*FIELDS);I2=X(:,7*FIELDS+1:8*FIELDS);R2=X(:,8*FIELDS+1:9*FIELDS);C2=X(:,9*FIELDS+1:10*FIELDS);
Y=X(:,11*FIELDS+1:12*FIELDS);
% Calculate final totals
totR1=(R1(final,:)+S1(final,:)+L1(final,:)+(1-select1)*I1(final,:));                    % total plants of variety 1 harvested (removed)
totR2=(R2(final,:)+S2(final,:)+L2(final,:)+(1-select2)*I2(final,:));                    % total plants of variety 2 harvested (removed)
totY=(Y(final,:)+yield1*(S1(final,:)+L1(final,:)+use1*I1(final,:))+yield2*(S2(final,:)+L2(final,:)+use2*I2(final,:)))./(yield1*MAXYIELD);       % total yield (compared to a disease-free field variety 1)
totC1=max(0,(C1(final,:)+(1-revrate1)*L1(final,:)+(1-select1)*I1(final,:))./totR1);      % total percentage of infected cuttings of variety 1
totC2=max(0,(C2(final,:)+(1-revrate2)*L2(final,:)+(1-select2)*I2(final,:))./totR2);      % total percentage of infected cuttings of variety 2          
variety=totR2./(totR1+totR2);                                               % total proportion of removed plants that are variety 2
ainf=sum((1-variety).*totC1+variety.*totC2)/(FIELDS);                       % average proportion of infection in fields
finf=sum(((1-variety).*totC1+variety.*totC2)>0.0001)/FIELDS;                % proportion of fields that are infected
Ssource=(1-abs(source)).*(ceil((1-variety').*totC1'+variety'.*totC2'-0.0001).*(2*ceil((1-variety').*cuttings1'+variety'.*cuttings2'-0.0001)-1));% source of new infections in this season, such that Ssource = -1 if infection due to whitefly, Ssource = +1 if due to trade, Ssource = 0 if no infection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%