function [xnot,cuttings1,cuttings2,variety]=FXNReplant(opt,totC1,totC2,trade,variety)
global  FIELDS PLANTS cleanliness
% Identify infection levels in each field at replanting (dependent on
% whether a grower is a CSS user or trade cuttings with neighbours, which
% includes the possibility of replanting from their own field)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Lnot1=zeros(1,FIELDS);Rnot1=zeros(1,FIELDS);Cnot1=zeros(1,FIELDS);
Lnot2=zeros(1,FIELDS);Rnot2=zeros(1,FIELDS);Cnot2=zeros(1,FIELDS);
Vnot=zeros(1,FIELDS);Ynot=zeros(1,FIELDS);
cuttings1=(1-opt).*(trade*totC1')';
cuttings2=(1-opt).*(trade*totC2')'+opt*cleanliness;
variety=(1-opt).*(trade*variety')'+opt;
Snot1=(1-variety).*(1-cuttings1);
Inot1=(1-variety).*1-Snot1;
Snot2=variety.*(1-cuttings2);
Inot2=variety.*1-Snot2;
xnot=[PLANTS*Snot1 PLANTS*Lnot1 PLANTS*Inot1 Rnot1 Cnot1 PLANTS*Snot2 PLANTS*Lnot2 PLANTS*Inot2 Rnot2 Cnot2 Vnot Ynot];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
