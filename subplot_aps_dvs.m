function fig = subplot_aps_dvs(aps_frames,dvs_frames)
%%Plot aps frame and dvs frame together based on their timestamps.
%%The timestamp of dvs_frames should always be included in the duration of
%%aps_frames

%% First locate the nearest aps_frame to the first dvs frame
start_time = dvs_frames{1}.timestamp;
i = 1;
while (start_time > aps_frames{i}.Header.Stamp.Sec*10^3 + aps_frames{i}.Header.Stamp.Nsec*10^-6)
    i = i+1;
end
aps_index = i;

%% Plot two frames on one figure

while (i <= length(dvs_frames))
    current_aps_time = aps_frames{aps_index}.Header.Stamp.Sec*10^3 + aps_frames{aps_index}.Header.Stamp.Nsec*10^-6;
    if (current_aps_time >= dvs_frames{i}.timestamp)
        hold on 
        fig = gcf;
        subplot(1,2,1);
        imshow(aps_frames{aps_index}.readImage);
        title(sprintf('APS frame Timestamp: %fms',current_aps_time - start_time));

        subplot(1,2,2);
        imshow(dvs_frames{i}.frame);
        title(sprintf('DVS frame Timestamp: %fms',dvs_frames{i}.timestamp - start_time));
        i = i+1;
        drawnow
    else
        aps_index = aps_index + 1;
    end
end