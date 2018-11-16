clc;
close all;
clear;

%% path and name of the file we want to open

str1 = "/home/vasu536/WorkSpace/GIT/DAVIS/bagfiles/"; %location/directory
str2 = "color_object_stationary_background_1.bag"; % name of the bag file

%%

bagfile = rosbag(str1 + str2); %loading the bag file

dvs_image_raw = select(bagfile, 'Topic', '/dvs/image_raw'); % raw dvs images

dvs_image_raw = readMessages(dvs_image_raw);
%%

dvs_events_bag = select(bagfile, 'Topic', '/dvs/events');
dvs_events_arrays = readMessages(dvs_events_bag);

%%
dvs_events_full = {};
x = 1;
disp('Collecting dvs events');
for i = 1:length(dvs_events_arrays)
    for j = 1:length(dvs_events_arrays{i,1}.Events)
        
        dvs_events_full{x}.MessageType  = dvs_events_arrays{i,1}.Events(j,1).MessageType;
        dvs_events_full{x}.X = dvs_events_arrays{i,1}.Events(j,1).X;
        dvs_events_full{x}.Y = dvs_events_arrays{i,1}.Events(j,1).Y;
        dvs_events_full{x}.Ts = dvs_events_arrays{i,1}.Events(j,1).Ts;
        dvs_events_full{x}.Polarity = dvs_events_arrays{i,1}.Events(j,1).Polarity;
        
        x = x+1;
    end
end
        
%%
% timestamp = zeros(7000,1);
% for i=1:length(timestamp)
%     timestamp(i) = dvs_events_full{i}.Ts.Sec*10^9+dvs_events_full{i}.Ts.Nsec;
% end

dvs_frames = create_dvs_frames(dvs_events_full(1:end),5);
F = subplot_aps_dvs(dvs_image_raw,dvs_frames);
% for i=1:length(dvs_frames)
%     imwrite(dvs_frames{i}.frame,sprintf('dvs_frames/frame_%d.png', i));
% end

%%
% 
% writerObj = VideoWriter('myVideo.avi');
% writerObj.FrameRate = 10;
% open(writerObj);
% 
% for i = 1:length(F)
%     frame = F(i);
%      writeVideo(writerObj, frame);
% end
% 
% close(writerObj);
