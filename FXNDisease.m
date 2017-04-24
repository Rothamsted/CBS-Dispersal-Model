function dx=FXNDisease(~,x,kernal,cuttings1,cuttings2,variety)
global FIELDS plantrate harvrate rograte1 rograte2 pinfrate1 pinfrate2 prograte1 prograte2 revrate1 revrate2 select1 select2 yield1 yield2 use1 use2 WHITE vinfrate1 vinfrate2 vextinfrate mortrate lossrate migrate SOURCER
% ODE for the spread of disease through a field
% dS1=p(1-c)-hS-bSV                                                         susceptible plants variety1 S1
% dL1=pc+bSV-(h+g)L                                                         latently infected plants variety1 L1
% dI1=gL-(h+r)I                                                             infectious plants variety1 I1
% dR1=h(S+L+I)                                                              harvested/removed plants variety1 R1
% dC1=h(1-q)L+hI                                                            total infected cuttings variety1 C1

% dS2=p(1-c)-hSr-bSrVr                                                      susceptible resistant plants variety2 S2
% dL2=pc+bSrVr-(h+g)Lr                                                      latently infected resistant plants variety2 L2
% dI2=gL-(h+r)Ir                                                            infectious resistant plants variety2 I2
% dR2=h(Sr+Lr+Ir)                                                           harvested/removed resistant plants variety2 R2
% dC2=h(1-q)Lr+hIr                                                          total infected resistant cuttings variety2 C2r

% dV=vI(W-V)-(l+n)V+m(sumV-V)                                               infectious vectors V (constant total vector population WHITE)
% dY=h(S+L+uI)                                                              total yield Y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=FIELDS;cuttings1=cuttings1';cuttings2=cuttings2';                                
S1=x(1:N);L1=x(N+1:2*N);I1=x(2*N+1:3*N);
S2=x(5*N+1:6*N);L2=x(6*N+1:7*N);I2=x(7*N+1:8*N);
V=x(10*N+1:11*N);

dispersalV=V'*kernal;                                                           % Dispersal of whitefly
% Non-resistant variety
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dS1=(1-variety').*plantrate.*(1-cuttings1)-harvrate*S1-pinfrate1*S1.*V;         % Susceptible plants
dL1=(1-variety').*plantrate.*cuttings1+pinfrate1*S1.*V-(harvrate+prograte1)*L1; % Latently infected plants
dI1=prograte1*L1-(harvrate+rograte1)*I1;                                        % Infectious plants
dR1=harvrate*(S1+L1+(1-select1)*I1);                                            % Total plants harvested & kept (removed)
dC1=harvrate*(1-revrate1)*L1+harvrate*(1-select1)*I1;                           % Infected cuttings
% Resistant variety
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dS2=variety'.*plantrate.*(1-cuttings2)-harvrate*S2-pinfrate2*S2.*V;             % Resistant plants
dL2=variety'.*plantrate.*cuttings2+pinfrate2*S2.*V-(harvrate+prograte2)*L2;     % Latently infected plants
dI2=prograte2*L2-(harvrate+rograte2)*I2;                                        % Infectious plants
dR2=harvrate*(S2+L2+(1-select2)*I2);                                            % Total plants harvested & kept (removed)
dC2=harvrate*(1-revrate2)*L2+harvrate*(1-select2)*I2;                           % Infected cuttings
% Other aspects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dV=vextinfrate*(WHITE-V)+vinfrate1*I1.*(WHITE-V)+vinfrate2*I2.*(WHITE-V)-(lossrate+mortrate)*V+migrate*(dispersalV'-V); % Infectious vectors
dV=(vinfrate1*I1+vinfrate2*I2+vinfrate1*SOURCER).*(WHITE-V)-(lossrate+mortrate)*V+migrate*(vextinfrate+dispersalV'-V); % Infectious vectors
dY=harvrate*(yield1*(S1+L1+use1*I1)+yield2*(S2+L2+use2*I2));                    % Yield
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dx=[dS1; dL1; dI1; dR1; dC1; dS2; dL2; dI2; dR2; dC2; dV; dY];