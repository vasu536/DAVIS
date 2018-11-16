function dvs_frames = create_dvs_frames(dvs_events, period)
% Period should be in milliseconds
% Initialize dvs frame as a gray image
dvs_frame.timestamp = 0;
dvs_frame.frame = 128*ones(180,240,'uint8');
dvs_frames = {};
current_time = 0;
frame_time = 0;
frame_index = 1;
%%

for i=1:length(dvs_events)
    if (i==1)
        current_time = dvs_events{i}.Ts.Sec*10^3 + dvs_events{i}.Ts.Nsec*10^-6;
        dvs_frame.timestamp = current_time;
        dvs_frame.frame(dvs_events{i}.Y+1,dvs_events{i}.X+1) = 255*dvs_events{i}.Polarity;
        dvs_frames{frame_index} = dvs_frame;
        frame_time = current_time;
    else 
        current_time = dvs_events{i}.Ts.Sec*10^3 + dvs_events{i}.Ts.Nsec*10^-6;
        if (frame_time + period >= current_time)
            dvs_frame.frame(dvs_events{i}.Y+1,dvs_events{i}.X+1) = 255*dvs_events{i}.Polarity;
            dvs_frames{frame_index} = dvs_frame;
        else 
            % Reinitialize the image if it's a new timestamp
            dvs_frame.timestamp = current_time;
            dvs_frame.frame = 128*ones(180,240,'uint8');
            dvs_frame.frame(dvs_events{i}.Y+1,dvs_events{i}.X+1) = 255*dvs_events{i}.Polarity;
            frame_index = frame_index+1;
            dvs_frames{frame_index} = dvs_frame;
        end
        frame_time = dvs_frame.timestamp;
    end
end
