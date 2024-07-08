function robot_task = findLastTask(type_robot,ABS_event_path)

  for i=numel(ABS_event_path):-1:1
    if strcmp(ABS_event_path{i}(1),type_robot)
       robot_task = ABS_event_path{i};
       robot_task(4)='f';
       break;
    end
  end
end
    