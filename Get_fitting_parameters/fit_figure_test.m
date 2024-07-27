clear; close all; clc;
% 数据加载并测试输出数据
data = load('train_mnist.txt');
firstRow = data(1, :);
output = [];
pulse_interval = 10;
for i = 1:length(firstRow)
    if firstRow(1,i) ~= 0
        output = [output,(i-1)*pulse_interval];     
    end
end
output
% 设置变量,变量详见函数说明
start_time =-1;
end_time = 10000;
t_step = 0.2;
start_value = 0;
stimulate_time_array = output;
% 有开始时间刺激版本
% [t_array,result_array] = move_add(start_time,end_time,t_step,start_value,stimulate_time_array);
% plot(t_array,result_array(1,:));

% 没有开始时间刺激版本
[t_array,result_array] = move_add(start_time,end_time,t_step,start_value,stimulate_time_array);
plot(t_array,result_array(1,:));
% [t_array,result_array] = move_add(start_time,end_time,t_step,start_value,stimulate_time_array);
% plot(t_array,result_array(1,:));
function [t_array,result_array] = move_add(start_time,end_time,t_step,start_value,stimulate_time_array)
 %{ 
    move_add:根据给定信息完成叠加函数的计算
    传入参数:
    start_time:开始第一个刺激的时间
    end_time:想观察的总时间长度
    t_step:时间步长,越大计算结果点越远
    start_value:图中纵坐标的起始值
    stimulate_pos_array:进行刺激的时间值,在对应的时间点施加刺激
    返回参数:
    t_array:时间序列,从0开始,经过n个t_step后到达end_time
    result_array:结果序列,每个时间点的函数叠加结果
 %}

% 需要保证时间步对于1来说是整数
if mod(1,t_step) ~= 0
    error('输入的时间步必须能够被1整除,例如0.1,0.2,0.05等,像0.15等不可以');
end

% 初始化t_array,表示对应位置元素的时间,长度为end_time/t_step+1,从0开始到end_time结束
t_array = 0:t_step:end_time;

% 初始化result_array,表示的那个值,长度为和t_array相同,每个元素的初始值为start_value
result_array = start_value * ones(1,length(t_array));

% 如果start_time为-1,则不考虑开始时间的刺激,而是只考虑刺激序列的内容
if start_time ~= -1
    % 根据start_time赋值第一个刺激,该刺激作用范围为(start_time,end_time)
    result_array(1,start_time/t_step+1:end_time/t_step+1) = result_array(1,start_time/t_step+1:end_time/t_step+1) ...
                                                            + My_function(t_step,end_time-start_time);
end

% 赋值刺激序列的剩余内容,每个刺激的作用范围为(stimulate_time_array(i),end_time)
for i = 1:length(stimulate_time_array)
    result_array(1,stimulate_time_array(i)/t_step+1:end_time/t_step+1) = result_array(1,stimulate_time_array(i)/t_step+1:end_time/t_step+1) ... 
                                                                     + My_function(t_step,end_time-stimulate_time_array(i));
end
end



function result_array = My_function(t_step,time_length)
    %{
    My_function:定义自己的计算函数功能,内置函数,只在move_add.m中可见
    传入参数:
    t_step:时间步长,越大计算结果点越远
    time_length:计算函数涉及到的时间范围
    返回结果:
    result_array:结果数组,根据时间步长和时间长度计算出每个时间点的对应函数结果
    %}

% 初始化t_array,表示对应位置元素的时间,长度为time_length/t_step+1,从0开始到time_length结束
t_array = 0:t_step:time_length;
% 初始化result_array长度与t_array相同,,全0即可,后续赋值
result_array = zeros(1,length(t_array));

% load("first_fit.mat","p")
% load("second_fit.mat","p2")

load("./result/up.mat","p")
load("./result/down.mat","p2")
% 遍历每个时间点,根据时间点的值进行函数计算
% 在这里修改函数即可
for i = 1:length(t_array)
    if t_array(i)<=1
        result_array(1,i) = polyval(p,t_array(i));
    % elseif t_array(i)>1
    %     result_array(1,i) = (p2(1)*exp(-p2(2)*(t_array(i)-1)) + p2(3) +...
    %                          p2(4)*exp(-p2(5)*(t_array(i)-1)) + p2(6) +...
    %                          p2(7)*exp(-p2(8)*(t_array(i)-1)) + p2(9)) * result_array(1,5);
    else
        result_array(1,i) = (p2(1)*exp(-p2(2)*(t_array(i)-1)) + p2(3) +...
                             p2(4)*exp(-p2(5)*(t_array(i)-1)) + p2(6) +...
                             p2(7)*exp(-p2(8)*(t_array(i)-1)) + p2(9)) * result_array(1,5);
    end
end

end