function [xnot,cuttings1,cuttings2,variety]=FXNInitial(tradeX,optX)
global FIELDS PLANTS SOURCEP INITINF CSSamount revrate1 revrate2 select1 select2 cleanliness 
% 1) Set up the initial conditions, randomly identifying the level of
% infection in each field (dependent on the maximum infection source in
% the plants, "SOURCEP," and in the whitefly, "SOURCEW," or infection in
% the clean seed, "cleanliness," if a grower is a CSS user)
% 2) Also calculate the proportion of infected cuttings a grower has to
% plant with for the first season
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Snot1=ones(1,FIELDS);Lnot1=0*Snot1;Inot1=Lnot1;Rnot1=Lnot1;Cnot1=Lnot1;
Snot2=0*Snot1;Lnot2=0*Snot1;Inot2=Lnot1;Rnot2=Lnot1;Cnot2=Lnot1;
Vnot=Lnot1;Ynot=Lnot1;
% Selecting initially infected fields
c=randperm(FIELDS,INITINF*FIELDS);
Snot1(c(1:INITINF*FIELDS))=1-SOURCEP;         % susceptible plants
Lnot1(c(1:INITINF*FIELDS))=0;                 % latently infected plants
Inot1(c(1:INITINF*FIELDS))=SOURCEP;           % infectious plants
Vnot(c(1:INITINF*FIELDS))=0;                  % infectious vectors
% Infection in fields using a clean seed system
Snot1(optX==CSSamount)=(1-CSSamount)*Snot1(optX==CSSamount);
Lnot1(optX==CSSamount)=0;
Inot1(optX==CSSamount)=(1-CSSamount)*Inot1(optX==CSSamount);
Snot2(optX==CSSamount)=CSSamount*(1-cleanliness);
Lnot2(optX==CSSamount)=0;
Inot2(optX==CSSamount)=CSSamount*cleanliness;
Vnot(optX==CSSamount)=0;
% Initial populations:
% 1)susceptible plants variety1 2)latent plants variety1 3)infectious plants variety1 4)total plants variety1 harvested 5)total infected cuttings variety1
% 6)susceptible plants variety2 7)latent plants variety2 8)infectious plants variety2 9)total plants harvested variety2 10)total infected cuttings variety2
% 11)infected vectors 12)total yield 
xnot=[PLANTS*Snot1 PLANTS*Lnot1 PLANTS*Inot1 Rnot1 Cnot1 PLANTS*Snot2 PLANTS*Lnot2 PLANTS*Inot2 Rnot2 Cnot2 Vnot Ynot];
% Initial proportion of resistant cuttings
variety=(Snot2+Lnot2+Inot2)./(Snot1+Lnot1+Inot1+Snot2+Lnot2+Inot2);
% Initial proportion of infected cuttings
totC1=max(0,((1-revrate1)*Lnot1+(1-select1)*Inot1)./(Snot1+Lnot1+(1-select1)*Inot1));
totC2=max(0,((1-revrate2)*Lnot2+(1-select2)*Inot2)./(Snot2+Lnot2+(1-select2)*Inot2));
cuttings1=(1-optX).*(tradeX*totC1')';
cuttings2=(1-optX).*(tradeX*totC2')'+optX*cleanliness;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



