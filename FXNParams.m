function FXNParams(CONTPLANT,CONTHARV,WHITEFLY,SUBSIDY)
% Making parameters global
global LENGTH FIELDS NBOUR FGROUP DAYS SIZE PLANTS SOURCEP SOURCER SOURCEW INITINF
global plantrate harvrate rograte1 rograte2 pinfrate1 pinfrate2 prograte1 prograte2 revrate1 revrate2 select1 select2 yield1 yield2 use1 use2 cleanliness
global WHITE vinfrate1 vinfrate2 vextinfrate mortrate lossrate migrate dispersal 
global PROBTRADE MAXTRADES CSSusers CSSgroup CSSamount
global MAXYIELD COST Response InfoLocal InfoTrade InfoDistrict Contrary Stubborn 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Landscape information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LENGTH=60000;                       % total length of the landscape (m)
FIELDS=1000;                        % number of fields - 6000 in Nakasongola, 40000 in Northern, 5000 in Eastern
NBOUR=2000;                         % diameter of circle containing a farmers group (m)
FGROUP=[15 30];                     % farmer group size min and max (fields)
DAYS=300;                           % length of each season in days (1 time unit)
% Field information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SIZE=20000*ones(FIELDS,1);%5000+rand(FIELDS,1)*145000;    % attractive area of field (m^2), proxy for area and vector affinity for cassava
PLANTS=0.5;                         % plant density
SOURCEP=1;                          % maximum infection in a field
SOURCER=0;                          % size of reservoir host population
SOURCEW=0;                          % maximum infection in vectors
INITINF=0.7;                        % initial infection levels in the system as a proportion of fields
% Plant parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plantrate=CONTPLANT*0.0015;         % planting rate (day^-1)
harvrate=CONTHARV*0.003;            % harvesting rate (day^-1)
rograte1=0;                         % roguing rate variety1(day^-1)
rograte2=0;                         % roguing rate variety2 (day^-1)
pinfrate1=0.007;                    % infection rate of variety1 (vector->plant)
pinfrate2=0.007;                    % infection rate of variety2 (vector->plant)
prograte1=0.035;                    % progression rate of disease in variety1
prograte2=0.035;                    % progression rate of disease in variety2
revrate1=0;                         % reversion rate of latently infected variety1
revrate2=0;                         % reversion rate of latently infected variety2
select1=0;                          % likelihood of successfully selecting out infectious cuttings variety 1
select2=0;                          % likelihood of successfully selecting out infectious cuttings variety 2
yield1=1;                           % yield from a plant variety 1
yield2=1;                           % yield from a plant variety 2
use1=0.3;                           % usable proportion of infectious cuttings variety1
use2=0.3;                           % usable proportion of infectious cuttings variety2
cleanliness=0;                      % infection rate in clean seed
% Vector parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
WHITE=rand(FIELDS,1)*500;           % vector density per plant
vinfrate1=0.007;                    % infection rate of whitefly for variety1 (plant->vector)
vinfrate2=0.007;                    % infection rate of whitefly for variety2 (plant->vector)
vextinfrate=0.00;                   % external infection rate (->vector)
mortrate=0.12;                      % vector mortality rate (day^-1)
lossrate=1;                         % vector loss of disease rate (day^-1)
migrate=WHITEFLY*0.16;              % vector migration rate
dispersal=0.007;                    % dispersal parameter (m^-1)
% Trade information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PROBTRADE=0.5;                      % probability of trading versus replanting from your own field
MAXTRADES=3;                        % maximum number of fields a grower trades with
CSSusers=0.1*FIELDS*SUBSIDY;        % number of growers subsidized with free clean seed
CSSgroup=0.5*CSSusers;              % proportional size of each community of users that is subsidized, if clustered
CSSamount=0.25;                     % max proportion of a field that a grower may obtain from a clean seed system
% Decision information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MAXYIELD=PLANTS+CONTPLANT*DAYS*plantrate;     % maximum potential number of plants harvested
COST=0.25*CSSamount;                % cost of using CSS per field
Response=1.6;                       % responsiveness of growers to loss
InfoLocal=0.4;                      % influence of information from farmers group/neighbours
InfoTrade=0.4;                      % influence of information from trading partners and friends
InfoDistrict=1-InfoLocal-InfoTrade; % influence of information from across the region (eg radio)
Contrary=0.0001;                    % fraction of growers who would try a new strategy even if no others use it
Stubborn=0;                         % tendency of growers to conform. -ve means copy peers, +ve means remain stubborn to current strategy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
