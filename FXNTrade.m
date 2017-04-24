function trade=FXNTrade(distance,allowed)
global  FIELDS PROBTRADE MAXTRADES
% Identify trade between growers (one grower per field). We do not identify
% which growers use a CSS here
% 1) Possiblity of grower replanting using their own collected planting
% material (probability given by "1-PROBTRADE")
% 2) Possibility of grower obtaining planting material from other fields
% (dependent on the distance to other fields and the number of other
% growers that they trade with "MAXTRADE")
% 3) If clean seed system users only are allowed to trade, all others
% obtain material from their own fields (dependent on variable "allowed")
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set probability of trade with other fields with 50%<5km, 25%>5<10km, 25%>10km
probT=discretize(distance,[0,5000,10000,1000000],[0.5,0.25,0.25]);
probT=probT.*repmat(allowed,FIELDS,1);                                     % growers trade with allowed users only
probT(eye(FIELDS)==1)=0;                                                   % no trade with themselves
probt=zeros(FIELDS,FIELDS);values=[0,0.25,0.25,0.5];
for i=1:FIELDS
    [instances,bins]=histc(probT(i,:),values);                             % count the number of occurences of each value & their locations
    vi=values./instances;                                                  
    probt(i,:)=vi(bins);                                                   % probability is now eg 50% that trade is <5km
end
% % Alternative without a loop
% values=[0,0.2,0.3,0.5];
% [instances,bins]=histc(probT,values,2);                                  % count the number of occurences of each value & their locations
% vi=repmat(values,[FIELDS,1])./instances;                                                                                                    
% probt=reshape(vi(sub2ind([FIELDS,4],reshape(repmat((1:FIELDS)',1,FIELDS)',[],1),reshape(bins',[],1))),[FIELDS,FIELDS])'; % probability is now eg 50% that trade is <5km
probT=probt./sum(probt,2);                                                 % probability as a proportion of the total for that row
x=cumsum([zeros(FIELDS,1) probT./repmat(sum(probT,2),1,FIELDS)],2);
x(:,end)=1e3*eps+x(:,end);
trade=double(diag(rand(1,FIELDS)<(1-PROBTRADE)));                          % growers that do not trade
traders=randi([1,MAXTRADES],1,FIELDS);traders=traders-traders.*sum(trade); % growers that trade, pick number of trades
for i=1:FIELDS
    [~,a]=histc(rand(traders(i),1),x(i,:));                                % choose fields to trade with from probability density fxn
    trade(i,a)=rand(1,traders(i));                                         % random amount of trade with fields, if it is allowed
end
trade=sparse(trade./repmat(sum(trade,2),1,FIELDS));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%