%%
%
clear
close
clc
%initialization
%environment setting

T=60*60*2;%以秒为单位，先按最大时间为2h来看，共计7200个单位
M=20;%AGV数量
O=1000;%订单数量

Node=zeros(20,20,T);%路网结构，每一个点的地理坐标+时间钟，初始化为0，后面用数字记录小车的位置
AGV=round(rand(M,2)*size(Node,1));%每个AGV的当前位置，变化以顺序来确定

AGV_state=repmat(AGV(:,1:2),[1,1,T]);%表示AGV的全时空位置，未更新用0表示。第一个变量表示AGV编号，第二个变量表示两个维度的位置，第三个变量表示时间格
AGV_state(:,:,2:end)=0;
Order_list=round(rand(O,4)*size(Node,1));%生成了O的订单，四个数字分别代表起点和终点
Order_list(:,5)=zeros(O,1);%订单状态，0表示还未接单，1表示已经接单

%parameter setting
t=1;
flag=1;


%%
%simulation
while(flag)
    temp1=find(sum(AGV_state(:,:,t),2)==0);
    %找不到空闲车辆就让时间移动一格
    if isempty(temp1)
        t=t+1;
        %车辆按照顺序移动（在这个之前已经判断过是否会拥堵了）更新当前位置
        AGV=AGV_state(:,:,t);    
        if t>T
            break
        else 
            %可视化函数
            figure(1)
            visualize(AGV,AGV_state)           
            continue
        end
    end
    
    %分配订单
    temp2=find(Order_list(:,5)==1);
    if isempty(temp2)
        break
    end
    
    Order_now=Order_list(temp2(1),:);
    AGV_now=AGV(temp1(1),:);
    
    %更新路线，保存在AGV_state中
    AGV_state=route_plan(AGV_now,Order_now,AGV_state);
     
end 


%analyze
t