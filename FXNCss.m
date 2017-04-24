function opt=FXNCss(CHOICE,LOCAL,EXPAND,distance,opt,trade,totY,user1,users)
global  FIELDS CSSusers CSSgroup CSSamount
% Deciding which fields use external clean seed
% Non-users replant through either trade with neighbours or from their own field
% Set opt for each field so that 1=CSS user, 0=non-user
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if CHOICE==1                                       
    opt=FXNChoice(opt,totY,distance,trade);                                     % Growers choose whether or not to use CSS
elseif CSSusers~=0
    opt=zeros(1,FIELDS);  
    if LOCAL==0&&EXPAND==0                                                      % RANDOMLY distributed                              
        c=randperm(FIELDS,CSSusers);opt(c)=CSSamount;                           % CSS-compliant growers, initial strategies: comply=1, non=0    
    elseif LOCAL==1&&EXPAND==0                                                  % CLUSTERED into various localities
        c=randi([1,FIELDS],[1,CSSusers/CSSgroup]);                              % initial CSS-compliant growers
        distance(:,c)=0;                                                        % ruling in the initial users
        [~,sdcIndex]=sort(distance(c,:),2);                                     % sort neighbours into their distance away
        sdcIndex=unique(reshape(sdcIndex,1,FIELDS*CSSusers/CSSgroup),'stable'); % identifying the groups and removing repetitions
        opt(sdcIndex(:,1:CSSusers))=CSSamount;                                  % these neighbours become users too
    else                                                                        % EXPANDING outwards
        [~,sdcIndex]=sort(distance(user1,:));                                   % sort neighbours into their distance away from the first user
        opt(sdcIndex(users))=CSSamount;                                         % these neighbours become users too
    end
else
    opt=zeros(1,FIELDS);
end