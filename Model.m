% CF McQuaid 10/03/2016
% Definitive model: grower voluntary uptake of a clean seed system (CSS) for cassava brown streak disease (CBSD)
% Each field has a set of ODEs: susceptible, latent, infected plants (2 varieties with their own resistance/tolerance, variety 1 in the landscape variety 2 sold through css) and infected vectors (vector population is constant)
% Dispersal of pathogen between fields by grower trade or whitefly migration
tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET UP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RUNS=1;     SEASONS=10;                                                    %%% Number of runs of the system                %%% Number of seasons                                                      
% Trade vs whitefly, set to 1 for on or 0 for off
WHITEFLY=1; TRADING=1;  SECONDARY=1;                                       %%% Whitefly migration                           %%% Trade between fields                    %%% Trade from users of clean seed only (superseded by LOYALTY below)-change code in FXNTrade to either (a) maintain trade levels as growers look to find a certified user or (b) reduce trade levels as growers give up & replant from their own stores                                        
% Harvesting and replanting continuously, set to 1 for on or 0 for off
CONTHARV=1; CONTPLANT=0;                                                   %%% Continuous harvesting                        %%% Continuous planting                                                          
% Initialising the landscape, set to 1 for on or 0 for off
LOYAL=0;    MAP=1;      CLUSTER=0;                                         %%% Set loyalty of growers across the landscape  %%% Use a predefined map of field locations %%% Cluster fields together into farmers groups 
% Implementing the CSS, set to 1 for on or 0 for off
CHOICE=0;   SUBSIDY=0;  LIMIT=SEASONS+1;                                   %%% Individual choice by growers on CSS-use      %%% Growers receive subsidized material or not (Note: proportion="CSSusers")                  %%% Time limit on the subsidy (input the number of years here)
FIX=0;      LOCAL=0;    EXPAND=0;                                          %%% (Note: these require SUBSIDY=1) Fix the users who obtain subsidized material %%% CSS distributed locally or dispersed across the landscape %%% Expanding CSS from a group of initial users outwards (Note: this requires FIX=0, LOCAL=1)
% Load remaining parameters
FXNParams(CONTPLANT,CONTHARV,WHITEFLY,SUBSIDY);
global  FIELDS DAYS PLANTS CSSusers CSSamount
% Initiate storage matrics
STORElocation=zeros(2,FIELDS,RUNS);STOREloyal=zeros(FIELDS,RUNS);STOREopt=zeros(FIELDS,SEASONS,RUNS);STOREpopulation=zeros(4*FIELDS,SEASONS+1,RUNS);STOREinfection=zeros(SEASONS+1,RUNS,2);STOREsource=zeros(FIELDS,RUNS); %%% Store location of fields %%% grower loyalties %%% grower compliance with CSS %%% plant and vector populations continuously through time %%% average infection and proportion of fields infected %%% source of infection (whitefly or trade)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BEGIN RUNS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for r=1:RUNS
    % Varying parameters
    users=1:CSSusers;user1=randi([1,FIELDS],1);                                         %%% CSS to initial source fields then outwards from there
    [location,distance,kernal]=FXNLandscape(MAP,CLUSTER);                               %%% Field setup 
    loyal=LOYAL*ones(FIELDS,1);                                                         %%% Loyalty of growers to traders, set to 1 for loyal or 0 for disloyal
    source=zeros(FIELDS,1);                                                             %%% Saving source of infection, -1 for whitefly, 1 for trade or 0 for none
    optX=FXNCss(0,LOCAL,EXPAND,distance,[],[],[],user1,users);opt=SUBSIDY*optX;         %%% Initial compliance
    tradeX=FXNTrade(distance,SECONDARY*opt/CSSamount+(1-SECONDARY)*ones(1,FIELDS));     %%% A fixed trading network
    [xnot,cuttings1,cuttings2,variety]=FXNInitial(tradeX,optX);                         %%% Initial infection conditions
    totC1=(xnot(FIELDS+1:2*FIELDS)+xnot(2*FIELDS+1:3*FIELDS))/PLANTS;totC2=(xnot(6*FIELDS+1:7*FIELDS)+xnot(7*FIELDS+1:8*FIELDS))/PLANTS;
    [~,~,~,ainf,finf,~,~]=FXNSeason(xnot,source,cuttings1,cuttings2);
    STOREpopulation(:,1,r)=[zeros(FIELDS,1);xnot(2*FIELDS+1:3*FIELDS)';xnot(7*FIELDS+1:8*FIELDS)';variety'];STOREinfection(1,r,1)=ainf;STOREinfection(1,r,2)=finf;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
% FOR EACH INDIVIDUAL RUN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    for h=1:SEASONS
        tspan=[0 DAYS];
        % Solve the ODE
        [T,X]=ode45(@(t,x) FXNDisease(t,x,kernal,cuttings1,cuttings2,variety),tspan,xnot);
        % Calculate seasons results
        [totY,totC1,totC2,ainf,finf,Ssource,variety]=FXNSeason(X,source,cuttings1,cuttings2);
        % Update and store seasons results
        source=source+Ssource;        
        users=users+CSSusers;users=mod(users,FIELDS);users(users==0)=FIELDS;
        STOREopt(:,h,r)=opt;STOREpopulation(:,h+1,r)=[totY,totC1,totC2,variety];STOREinfection(h+1,r,1)=ainf;STOREinfection(h+1,r,2)=finf;
        % Setting trade for next season
        trade=FXNTrade(distance,SECONDARY*opt/CSSamount+(1-SECONDARY)*ones(1,FIELDS));  %%% Create a network
        trade=repmat(loyal,1,FIELDS).*tradeX+(1-repmat(loyal,1,FIELDS)).*trade;         %%% Fix loyal growers
        trade=TRADING*trade+(1-TRADING)*eye(FIELDS);trade=sparse(trade);                %%% Switch trade on or off 
        % Select CSS users for next season
        optS=FXNCss(0,LOCAL,EXPAND,distance,opt,trade,totY,user1,users);                %%% Identifying subsidized users
        conS=SUBSIDY*LIMIT/(h+1)>=1;                                                    %%% Whether subsidy is continued or not
        optC=FXNCss(CHOICE,LOCAL,EXPAND,distance,opt,trade,totY,user1,users);           %%% Whether users choose to use CSS or not
        opt=FIX*optX*conS+CSSamount*ceil(((1-FIX)*conS*optS+CHOICE*optC)/2);            %%% Fix CSS or not                                  
        % Replant fields
        [xnot,cuttings1,cuttings2,variety]=FXNReplant(opt,totC1,totC2,trade,variety);
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% STORE RUN RESULTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     STORElocation(1,:,r)=location(1,:);STORElocation(2,:,r)=location(2,:);STOREloyal(:,r)=loyal;STOREsource(:,r)=source; 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STORE ALL RESULTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FXNStore(STOREopt,STOREpopulation,STOREinfection,SEASONS);
toc