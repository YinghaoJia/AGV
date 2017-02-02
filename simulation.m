%%
%
clear
close
clc
%initialization
%environment setting

T=60*60*2;%����Ϊ��λ���Ȱ����ʱ��Ϊ2h����������7200����λ
M=20;%AGV����
O=1000;%��������

Node=zeros(20,20,T);%·���ṹ��ÿһ����ĵ�������+ʱ���ӣ���ʼ��Ϊ0�����������ּ�¼С����λ��
AGV=round(rand(M,2)*size(Node,1));%ÿ��AGV�ĵ�ǰλ�ã��仯��˳����ȷ��

AGV_state=repmat(AGV(:,1:2),[1,1,T]);%��ʾAGV��ȫʱ��λ�ã�δ������0��ʾ����һ��������ʾAGV��ţ��ڶ���������ʾ����ά�ȵ�λ�ã�������������ʾʱ���
AGV_state(:,:,2:end)=0;
Order_list=round(rand(O,4)*size(Node,1));%������O�Ķ������ĸ����ֱַ���������յ�
Order_list(:,5)=zeros(O,1);%����״̬��0��ʾ��δ�ӵ���1��ʾ�Ѿ��ӵ�

%parameter setting
t=1;
flag=1;


%%
%simulation
while(flag)
    temp1=find(sum(AGV_state(:,:,t),2)==0);
    %�Ҳ������г�������ʱ���ƶ�һ��
    if isempty(temp1)
        t=t+1;
        %��������˳���ƶ��������֮ǰ�Ѿ��жϹ��Ƿ��ӵ���ˣ����µ�ǰλ��
        AGV=AGV_state(:,:,t);    
        if t>T
            break
        else 
            %���ӻ�����
            figure(1)
            visualize(AGV,AGV_state)           
            continue
        end
    end
    
    %���䶩��
    temp2=find(Order_list(:,5)==1);
    if isempty(temp2)
        break
    end
    
    Order_now=Order_list(temp2(1),:);
    AGV_now=AGV(temp1(1),:);
    
    %����·�ߣ�������AGV_state��
    AGV_state=route_plan(AGV_now,Order_now,AGV_state);
     
end 


%analyze
t