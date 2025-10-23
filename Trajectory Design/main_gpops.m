Re = 6378e3; 
target_sma = Re+200e3;
target_ecc = 0;
target_inc = 0;
% what are the control variables I want to use? 
% Throttle, pitch, yaw, roll? 

% what to minimize? mass, dV?

% shall I divide the ascent in multiple phases?
m = 2000;
initial_state = [0 0 0 0 0 0 m]';
during_state_min = [0 0 0 0 0 0 0]';
during_state_max = [1e8 1e8 1e8 1e6 1e6 1e6 m]';
limits.state.min(:,1) = initial_state;
limits.state.max(:,1) = initial_state;

limits.state.min(:,2) = during_state_min;
limits.state.min(:,3) = during_state_min;
limits.state.max(:,2) = during_state_max;
limits.state.max(:,3) = during_state_max;

limits.control.min = [0 0 0 0]';
limits.control.max = [1 pi pi pi]';

limits.parameter.min = [];
limits.parameter.max = [];

limits.path.min = 0;
limits.path.max = 0;
   
limits.event.min = [target_sma-10e3, target_ecc-1e-3, target_inc-1e-3]';
limits.event.max = [target_sma+10e3, target_ecc+1e-3, target_inc+1e-3]';


