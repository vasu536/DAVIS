clc;
close all;
clear;

%% path and name of the file we want to open

str1 = "/home/vasu536/WorkSpace/Logfiles/bag_files/DAVIS240c/"; %location/directory
str2 = "2018-9-26-sample1.bag"; % name of the bag file

%%

bagfile = rosbag(str1 + str2); %loading the bag file

dvs_image_raw = select(bagfile, 'Topic', '/dvs/image_raw'); % raw dvs images

dvs_image_raw = readMessages(dvs_image_raw);

%%
% total_dvs_images = length(dvs_image_raw);
% 
% ts_start_sec = dvs_image_raw{1}.Header.Stamp.Sec;
% ts_start_nsec = dvs_image_raw{1}.Header.Stamp.Nsec;
% 
% ts_start = ts_start_sec + ts_start_nsec*10e-9;
% 
% ts_end_sec = dvs_image_raw{end}.Header.Stamp.Sec;
% ts_end_nsec = dvs_image_raw{end}.Header.Stamp.Nsec;
% 
% ts_end = ts_end_sec + ts_end_nsec*10e-9;
% 
% freq_dvs_image_raw = floor(total_dvs_images/(ts_end-ts_start));
%%

dvs_events = select(bagfile, 'Topic', '/dvs/events');
dvs_events = readMessages(dvs_events);

%dvs_event_1 = dvs_events{1};
%%
% event1 = dvs_events{1,1}.Events(1,1);
% event2 = dvs_events{1,1}.Events(2,1);
% 
% s1 = event1.Ts.Sec;
% ns1 = event1.Ts.Nsec;
% 
% s2 = event2.Ts.Sec;
% ns2 = event2.Ts.Nsec;
% 
% ts1 = s1 + ns1*10e-9;
% ts2 = s2 + ns2*10e-9;
% 
% freq_dvs = floor(1/(ts2-ts1));

%%

% freq_dvs_array = zeros(length(dvs_events)*length(dvs_events{1,1}.Events), 1);
% x = 1;
% for i = 1:length(dvs_events)
%     for j = 1:length(dvs_events{i,1}.Events)-1
%         
%         temp_ev1 = dvs_events{i,1}.Events(j,1);
%         temp_ev2 = dvs_events{i,1}.Events(j+1,1);
%         
%         temp_s1 = temp_ev1.Ts.Sec;
%         temp_ns1 = temp_ev1.Ts.Nsec;
%         temp_s2 = temp_ev2.Ts.Sec;
%         temp_ns2 = temp_ev2.Ts.Nsec;
%         
%         temp_ts1 = temp_s1 + temp_ns1*10e-9;
%         temp_ts2 = temp_s2 + temp_ns2*10e-9;
%         
%         freq_dvs_temp = floor(1/(temp_ts2-temp_ts1));
%         if freq_dvs_temp == Inf
%             freq_dvs_temp = 10000;
%         end
%         freq_dvs_array(x,1) = freq_dvs_temp;
%         x = x+1;     
%     end
% end
% 
% figure;
% plot(freq_dvs_array);

%%
dvs_events_full = {};
x = 1;

for i = 1:length(dvs_events)
    for j = 1:length(dvs_events{i,1}.Events)
        
        dvs_events_full{x}.MessageType  = dvs_events{i,1}.Events(j,1).MessageType;
        dvs_events_full{x}.X = dvs_events{i,1}.Events(j,1).X;
        dvs_events_full{x}.Y = dvs_events{i,1}.Events(j,1).Y;
        dvs_events_full{x}.Ts = dvs_events{i,1}.Events(j,1).Ts;
        dvs_events_full{x}.Polarity = dvs_events{i,1}.Events(j,1).Polarity;
        
        x = x+1;
    end
end
        

%%

aps_frame = dvs_image_raw;
dvs_frame = dvs_events_full;

dvs_event = zeros(180,240);
dvs_event_images = {};

aps_counter = 1;
dvs_counter = 1;

aps_ts_offset = aps_frame{aps_counter}.Header.Stamp.Sec + 10^-9*(aps_frame{aps_counter}.Header.Stamp.Nsec);

aps_current_ts = aps_ts_offset;

dvs_ts_offset = dvs_frame{dvs_counter}.Ts.Sec + 10^-9*(dvs_frame{dvs_counter}.Ts.Nsec);

dvs_current_ts = dvs_ts_offset;

%%
for i = 1: 30

aps_img = aps_frame{aps_counter}.readImage;

aps_next_ts = aps_frame{aps_counter+1}.Header.Stamp.Sec + 10^-9*(aps_frame{aps_counter+1}.Header.Stamp.Nsec);

ts_counter = 1;

dvs_event(:,:) = 128;

if (dvs_frame{dvs_counter}.Polarity == 1)
    aps_img(dvs_frame{dvs_counter}.Y + 1, dvs_frame{dvs_counter}.X + 1) = 255;
    dvs_event(dvs_frame{dvs_counter}.Y + 1, dvs_frame{dvs_counter}.X + 1) = 255;
else
    aps_img(dvs_frame{dvs_counter}.Y + 1, dvs_frame{dvs_counter}.X + 1) = 0;
    dvs_event(dvs_frame{dvs_counter}.Y + 1, dvs_frame{dvs_counter}.X + 1) = 0;
end

dvs_event_images{dvs_counter}.dvs_image = dvs_event;

%imshow(aps_img);

dvs_next_ts = dvs_frame{dvs_counter + ts_counter}.Ts.Sec + 10^-9*(dvs_frame{dvs_counter + ts_counter}.Ts.Nsec);

loop_counter = 0;

while ((dvs_next_ts - aps_next_ts) <= 0)
    
    dvs_event(:,:) = 128;
    
    if (dvs_frame{dvs_counter + ts_counter}.Polarity == 1)
        aps_img(dvs_frame{dvs_counter + ts_counter}.Y + 1, dvs_frame{dvs_counter + ts_counter}.X + 1) = 255;
        dvs_event(dvs_frame{dvs_counter + ts_counter}.Y + 1, dvs_frame{dvs_counter + ts_counter}.X + 1) = 255;
    else
        aps_img(dvs_frame{dvs_counter + ts_counter}.Y + 1, dvs_frame{dvs_counter + ts_counter}.X + 1) = 0;
        dvs_event(dvs_frame{dvs_counter + ts_counter}.Y + 1, dvs_frame{dvs_counter + ts_counter}.X + 1) = 0;
    end
    
    dvs_event_images{dvs_counter + ts_counter}.dvs_image = dvs_event;
    
    if (dvs_current_ts ~= dvs_next_ts)
        imshow(aps_img);
    end
    
    ts_counter = ts_counter + 1;
    
    dvs_current_ts = dvs_next_ts;
    dvs_next_ts = dvs_frame{dvs_counter + ts_counter}.Ts.Sec + 10^-9*(dvs_frame{dvs_counter + ts_counter}.Ts.Nsec);
    
    loop_counter = loop_counter + 1;
    
    if (loop_counter > 5000)
        break;
    end
    
end

%figure(1);

%imshow(aps_img);


aps_counter = aps_counter + 1;
dvs_counter = dvs_counter + ts_counter;

aps_current_ts = aps_next_ts;
dvs_current_ts = dvs_next_ts;

end



