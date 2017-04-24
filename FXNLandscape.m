function [location,distance,kernal]=FXNLandscape(MAP,CLUSTER)
global LENGTH FIELDS NBOUR FGROUP SIZE dispersal 
% Locating fields
% Calculating the distance between fields
% Calculating the dispersal kernal for whitefly between fields,
% given their locations and the attractive area of a field (SIZE)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Location of fields %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
location=zeros(2,FIELDS);
if MAP~=0                              % fields located on a predefined MAP
    fileID = fopen('Location_UgandaNakasongola.txt','r');                             % load data
    location=fscanf(fileID,'%f',[FIELDS 2]);location=location';
elseif CLUSTER~=0                      % fields CLUSTERED into farmers groups
    disp('CODE NOT OPTIMAL');c=1;
    while c<FIELDS
        location(1,c)=rand*LENGTH;
        location(2,c)=rand*LENGTH;
        % selecting how many growers are in the farmers group
        if c<=FIELDS-FGROUP(2)*2
            nby=randi(FGROUP,1);
        elseif c>FIELDS-FGROUP(2)       % for the final farmers group
            nby=FIELDS-c;
        elseif c>FIELDS-FGROUP(2)*2     % for the penultimate farmers group
            nby=round((FIELDS-c)/2);
        end
        % locate a number of neighbours nearby
        for i=1:nby
            location(1,c+i)=3*LENGTH;
            location(2,c+i)=3*LENGTH;
            dist=sqrt((location(1,c+i)-location(1,c)).^2+(location(2,c+i)-location(2,c)).^2);
            % ensure that they are close enough
            while dist>NBOUR||location(1,c+i)>LENGTH||location(2,c+i)>LENGTH||location(1,c+i)<0||location(2,c+i)<0;
                location(1,c+i)=location(1,c)-NBOUR+rand*2*NBOUR;
                location(2,c+i)=location(2,c)-NBOUR+rand*2*NBOUR;
                dist=sqrt((location(1,c+i)-location(1,c)).^2+(location(2,c+i)-location(2,c)).^2);
            end
        end
        c=c+1+nby;
    end
else                                    % fields located at RANDOM
    location=rand(2,FIELDS)*LENGTH;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Distance and whitefly dispersal kernal between fields %%%%%%%%%%%%%%%%%%%
distance=pdist2(location',location','euclidean');
kernal=repmat(SIZE,1,FIELDS)*dispersal^2.*exp(-dispersal*distance)/(2*pi());
kernal(eye(FIELDS)==1) =0;               % no dispersal between a field & itself
kernal(kernal<10^-30)=0;sparse(kernal);  % only consider whitefly dispersal over less than 10km
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
