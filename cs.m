%
% Project Title: CS in MATLAB
%
% Developer: ZZM in HUST
%
% Contact Info:hust_zzm@hust.edu.cn
%

clc;
clear;
close all;

%% Problem Definition--------------------------------------------
% Problem parameters introduction and formation
[num, txt, job_info]=xlsread('..\Data\job_info 12.xls');% the information of jobs£¡£¡£¡£¡£¡
job_number=cell2mat(job_info(:,1));
machine_number=12;%please put in the machine number£¡£¡£¡£¡£¡
for i=1:length(job_number)
    job_info{i,3}=str2num(job_info{i,3});
end
job_quantity=max(job_number);%total number of jobs
job_position=find(~isnan(job_number));
job_position=[job_position;length(job_number)+1]';
for i=1:job_quantity
    job{i}=cell2mat(job_info(job_position(i):job_position(i+1)-1,2))';
end
job_time=cell2mat(job_info(:,4))';

% CS Parameters
MaxIt = 2000;        % Maximum Number of Iterations
nPop = 10;           % Population Size
Pa=0.25;               % Every bad individual has Pa chance of being replaced
searching_times=5;   %Levy flight times


%% Initialization -------------------------------------------------
% Routing Allocation
population=zeros(nPop,length(job_number)*2);

for i=1:nPop
    final_pop=initial(job_quantity,job,job_info);
    population(i,:)=final_pop;
    i=i+1;
end
% Objective Function
result=zeros(nPop,1);
for i=1:nPop
    x=population(i,:);
    result(i,1)=processingtime(x,job_position,machine_number,job_time);
    %complete time for each individual
end

tstart=tic;

%% CS Main Loop---------------------------------------------
for it=1:MaxIt
    %Select The Best
    [best_result,best_index]= min(result);
    best=population(best_index,:);
    
    %Select The Others
    other=population;
    other(best_index,:)=[];
    other_result=result;
    other_result(best_index,:)=[];
    
    %Levy Flight
    for i=1: nPop-1
        x=other(i,:);
        other(i,:)=levy_flight(x,searching_times,job_number,job_info,job_position,machine_number,job_time,best_result);
        x=other(i,:);
        other_result(i,:)=processingtime(x,job_position,machine_number,job_time);
        %complete time for each individual
    end
    
    [other_result,loc]=sort(other_result);
    bad_result=other_result(nPop*0.8+1:end,1);
    good_result=other_result(1:nPop*0.8,1);
    bad_individual=other(loc(nPop*0.8+1:end,1),:);
    good_individual=other(loc(1:nPop*0.8,1),:);
    
    % Select Phase
    for i=1:nPop*0.2
        if rand(1)<Pa
            final_pop=initial(job_quantity,job,job_info);
            bad_individual(i,:)=final_pop;
        else
        end
        i=i+1;
    end
    
    %New population
    population=[best;good_individual;bad_individual];
    result=[best_result;good_result;bad_result];
    
    % Select
    [best_result,best_index]= min(result);
    
    % Store Record for Current Iteration
    Best(it) = best_result;
    Mean(it)=sum(result(:,1))/nPop;
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Result= ' num2str(Best(it))]);
    disp(['Iteration ' num2str(it) ': Mean='  num2str(Mean(it))]);
    tused = toc(tstart);
    if tused > 60
        break;
    end
end


%% Results----------------------------------------------

figure(1);
plot(Best, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Result');
grid on;

figure(2);
plot(Mean, 'LineWidth', 2);
%semilogy(Best, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Mean Result');
grid on;

gant(best,job_number,machine_number,best_result,job_position,job_time);