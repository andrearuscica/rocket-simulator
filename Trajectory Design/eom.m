function eom = eom(sol, setup, rocket_data)

t = sol.time;
x = sol.state(:,1);
y = sol.state(:,2);
z = sol.state(:,3);
vx = sol.state(:,4);
vy = sol.state(:,5);
vz = sol.state(:,6);
m = sol.state(:,7);

u = sol.control;
throttle = u(:,1);
pitch = u(:,2);
yaw = u(:,3);
roll = u(:,4);

thrust_mag = rocket_data.thrust_mag;
Isp = rocket_data.Isp;

thrust_vec = throttle * thrust_mag * [ ...
    cos(pitch)*cos(yaw);
    cos(pitch)*sin(yaw);
    sin(pitch)
];

acc_vec = thrust_vec ./ m; 
ax = acc_vec(:,1);
ay = acc_vec(:,2);
az = acc_vec(:,3);

dm = -throttle .* thrust_mag ./ (9.81*Isp);

eom = [vx vy vz ax ay az dm]';
