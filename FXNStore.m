function FXNStore(STOREopt,STOREpopulation,STOREinfection,SEASONS)
% Store results from multiple runs in text files
global FIELDS CSSamount
% CSS USE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Number of users of clean seed per season per run %%%%%%%%%%%%%%%%%%%%%%%%
fileCn=fopen('ResCssNumber.txt','w');
fprintf(fileCn,[repmat('%6.4f ',1, SEASONS) '\r\n'],squeeze(sum(STOREopt(:,:,:))/(CSSamount*FIELDS)));
fclose(fileCn);
% Average presence of clean seed within fields per season per run %%%%%%%%%
fileCa=fopen('ResCssAverage.txt','w');
fprintf(fileCa,[repmat('%6.4f ',1, SEASONS) '\r\n'],squeeze(mean(STOREpopulation(3*FIELDS+1:4*FIELDS,2:SEASONS+1,:))));
fclose(fileCa);
% INFECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Total fields infected per season per run %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fileIf=fopen('ResInfectNumber.txt','w');
fprintf(fileIf,[repmat('%6.4f ',1, SEASONS+1) '\r\n'],[STOREinfection(1,:,2);STOREinfection(2:SEASONS+1,:,2)]);
fclose(fileIf);
% Average infection within fields per season per run %%%%%%%%%%%%%%%%%%%%%%
fileIa=fopen('ResInfectAverage.txt','w');
fprintf(fileIa,[repmat('%6.4f ',1, SEASONS+1) '\r\n'],[STOREinfection(1,:,1);STOREinfection(2:SEASONS+1,:,1)]);
fclose(fileIa);
% YIELD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Average yield within fields per season per run %%%%%%%%%%%%%%%%%%%%%%%%%%
fileY=fopen('ResYieldAverage.txt','w');
fprintf(fileY,[repmat('%6.4f ',1, SEASONS) '\r\n'],squeeze(mean(STOREpopulation(1:FIELDS,2:SEASONS+1,:))));
fclose(fileY);