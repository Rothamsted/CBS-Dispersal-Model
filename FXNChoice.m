function choice=FXNChoice(opt,totY,distance,trade)
global FIELDS FGROUP COST CSSamount Response InfoLocal InfoTrade Contrary Stubborn
% Economic grower choice model
% Growers compare harvest with that of others using the clean seed system or not
% Look at regional average, their farmers group and trading partners
% Switch to behaviour they see to be most profitable
% Dependent on responsiveness to compared loss, "Response," and irrationality, "Irrational"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% "Use" refers to those using the clean seed system, "Non" to those that do not
% The alternative strategy is whichever of Use or Non the grower is not doing
optT=opt/CSSamount;
% Considering the entire landscape
UseDistrict=sum(totY.*opt)*min(sum(opt),1/sum(opt)); 
NonDistrict=sum(totY.*(1-opt))*min(sum((1-opt)),1/sum(1-(opt)));
% Run through each field and who influences that particular grower
for i=1:FIELDS
    Local=[];k=1;
    Trade=[];l=1;
    % Considering the local farmers group
    Fg=randi(FGROUP);                       	% choose size of farmers group
    sdc=sort(distance(i,:));                	% sort neighbours into their distance away
    for j=1:FIELDS
        if sum(distance(i,j)==sdc(2:Fg+1))>0  	% select the closest neighbours
        Local(k)=j;k=k+1;
        end
    end
    UseLocal=sum(totY(Local).*opt(Local))*min(sum(opt(Local)),1/sum(opt(Local)));
    NonLocal=sum(totY(Local).*(1-opt(Local)))*min(sum((1-opt(Local))),1/sum(1-(opt(Local))));
    % Considering trading partners
    for j=1:FIELDS
        if trade(i,j)>0&&i~=j               	% select trading partners
            Trade(l)=j;l=l+1;
        end
    end
    UseTrade=sum(totY(Trade).*opt(Trade))*min(sum(opt(Trade)),1/sum(opt(Trade)));
    NonTrade=sum(totY(Trade).*(1-opt(Trade)))*min(sum((1-opt(Trade))),1/sum(1-(opt(Trade))));    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Comparing the reward for the grower and the alternative, at all scales
    RewardField=((1-opt(i))*totY(i)+opt(i)*(totY(i)-COST));
    RewardDistrict=opt(i)*NonDistrict+(1-opt(i))*UseDistrict*(1-COST);
    RewardLocal=opt(i)*NonLocal+(1-opt(i))*UseLocal*(1-COST);
    RewardTrade=opt(i)*NonTrade+(1-opt(i))*UseTrade*(1-COST);
    % Does the grower change strategy?
    r=rand;
    if r<=InfoLocal
           prob=1-exp(-Response*(RewardLocal-RewardField-Stubborn));
    elseif r<=(InfoTrade+InfoLocal);
           prob=1-exp(-Response*(RewardTrade-RewardField-Stubborn));
    else
           prob=1-exp(-Response*(RewardDistrict-RewardField-Stubborn));
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % If no growers use the alternative, or the probability is very low, there is still a chance that the grower is irrational
    if rand<max(prob,Contrary)
        optT(i)=1-opt(i);    
    end
end
choice=optT;