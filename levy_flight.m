%
% Project Title: CS in MATLAB
%
% Developer: ZZM in HUST
%
% Contact Info:hust_zzm@hust.edu.cn
%

function x= levy_flight(x,searching_times,job_number,job_info,job_position,machine_number,job_time,best_result)
job_number=length(job_number);
x_copy=x;
for t=1:searching_times
    levy_factor=ceil(abs(normrnd(1,1)/(normrnd(1,4))^1/1.5));
    if levy_factor>job_number
        levy_factor=job_number;
    end
    x_pop=cell(searching_times,1);
    x_res=zeros(searching_times,1);
    for t=1:searching_times
        cross_pos=randperm(job_number,levy_factor);
        mutation_pos=randperm(job_number,levy_factor);
        %Cross
        for c=cross_pos
            if any(c==job_position)
                a=1;
                b=find(c+1==x(1,1:job_number));
            elseif any(c+1==job_position)
                a=find(c==x(1,1:job_number));
                b=job_number;
            else
                a=find(c-1==x(1,1:job_number));
                b=find(c+1==x(1,1:job_number));
            end
            old_p= find(c==x(1,1:job_number));
            old_m=x(1,old_p+job_number);
            x(1,old_p)=0;
            x(1,old_p+job_number)=0;
            if a==b
                p=randi([a,b],1);
            else
                p=randi([a,b-1],1);
            end
            if p==job_number
                x=[x(1,1:p),c,x(1,job_number+1:job_number+p),old_m];
            else
                x=[x(1,1:p),c,x(1,p+1:job_number),x(1,job_number+1:job_number+p),old_m,x(1,job_number+p+1:2*job_number)];
            end
            x(find(0==x(1,:)))=[];
        end
        %Mutation
        for m=mutation_pos
            x(m+job_number)=job_info{m,3}(randperm(length(job_info{m,3}),1));
        end
        x_pop{t,1}=x;
        x_res(t,1) = processingtime(x,job_position,machine_number,job_time);
    end
    if min(x_res)<best_result || rand(1)<0.2
        [best_result,best_index]=min(x_res);
        x=x_pop{best_index,1};
    else
        x=x_copy;
    end
end