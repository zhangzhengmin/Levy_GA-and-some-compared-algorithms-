%
% Project Title: CS in MATLAB
%
% Developer: ZZM in HUST
%
% Contact Info:hust_zzm@hust.edu.cn
%

function final_pop=initial(job_quantity,job,job_info)
      len=length(job{1});
    for j=1:job_quantity-1
        len=len+length(job{j+1});
        Pop=zeros(1,len);
        j_pos=sort(randperm(len,length(job{j+1})));
        Pop(j_pos)=job{j+1};
        if j==1
            Pop(Pop==0)=job{j};
        else
            Pop(Pop==0)=final_pop;
        end
        final_pop=Pop;
        j=j+1;
    end
    %machine allocation
    for m=1:len
        final_pop(len+m)=job_info{m,3}(randperm(length(job_info{m,3}),1));
    end
