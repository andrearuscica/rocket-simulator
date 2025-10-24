clc
guess.parameter = [];
guess.control = [];
guess.state = [];

mu = 3.986e14;
m = 6000;
initial_state_guess = [6378e3 0 0 0 0 0 m]'; %on earth surface
% initial guess at constant thrusting at 45° east
T = [70e3; 70e3; 53e3]; %0.1 MN
pitch = deg2rad([90; 45]);
yaw = deg2rad([0;0]);
roll = deg2rad([0;0]);
control_time = [0; 30; 210];

enu_guidance = [0 0 1; 0 0 1; sqrt(3)/3 sqrt(3)/3 0]; % normalize

%control = [T, pitch, yaw, roll, control_time];
control = [T, enu_guidance, control_time];
rocket_data.Isp = 300;
options = odeset('Events', @(t,state) impact(t,state),'RelTol',1e-6,'AbsTol',1e-6);
[tout, yout] = ode45(@(t,state) propagate_guess(t, state, control, rocket_data), [0:24*3600], initial_state_guess, options);

x = yout(:,1); y = yout(:,2); z = yout(:,3);
h = sqrt(x.^2 + y.^2 + z.^2) - 6378e3;
vx = yout(:,4); vy = yout(:,5); vz = yout(:,6);
v = sqrt(vx.^2 + vy.^2 + vz.^2);
mass = yout(:,end);
figure;
plotSphere(6378)
plot3(x/1000,y/1000,z/1000, LineWidth=2)
burnout = find(diff(mass) > -0.01, 1, "first");
plot3(x(burnout) / 1000, y(burnout)/1000, z(burnout)/1000, 'o','LineWidth',2);
figure;
plot(tout,h/1000)
figure;
plot(tout,v*3.6)
yline(9e3 * 3.6)
figure;
plot(tout, mass)


function [xdot, control] = propagate_guess(t, state, control, rocket_data)
    x = state(1);
    y = state(2);
    z = state(3);
    vx = state(4);
    vy = state(5);
    vz = state(6);
    m = state(7);
    
    r_vec = [x y z]';
    v_vec = [vx vy vz]';
    mu = 3.986e14;
    g = -mu .* (r_vec) ./ (norm(r_vec)^3);
    T_program = control(:,1);
    % pitch_program = control(:,2);
    % yaw_program = control(:,3);
    % roll_program = control(:,4);
    control_time = control(:,5);
    enu_guidance = control(:,2:4);
    if m > 200
        T = interp1(control_time, T_program, t, 'nearest', 'extrap');
    else
        T = 0;
    end

    [sma, ecc, i] = RV2COE(r_vec, v_vec, mu);
    if sma >= (6378+200)*1e3
        T = 0;
    end

    if t <= control_time(2)
        enu_guidance_interp = enu_guidance(1,:)';   % maintain 
    else
        t1 = control_time(2);
        t2 = control_time(3);
        v1 = enu_guidance(2,:)';
        v2 = enu_guidance(3,:)';
        f = (t - t1) / (t2 - t1);   % 0→1
        f = min(max(f,0),1);

        % SLERP
        dotp = max(-1,min(1,dot(v1,v2)));
        theta = acos(dotp);
        if abs(theta) < 1e-6
            enu_guidance_interp = v1; % nearly identical
        else
            enu_guidance_interp = (sin((1-f)*theta)/sin(theta))*v1 + ...
                  (sin(f*theta)/sin(theta))*v2;
            enu_guidance_interp = enu_guidance_interp / norm(enu_guidance_interp);
        end
    end
    %enu_guidance_interp = interp1(control_time, enu_guidance, t, 'linear', 'extrap');

    [e_hat, n_hat, u_hat] = ECEF2ENU(r_vec);
    ENU2ECEF_dcm = [e_hat, n_hat, u_hat];
    dir_ECEF = ENU2ECEF_dcm * enu_guidance_interp;
    T_vec = T.*dir_ECEF;
    Tx = T_vec(1);
    Ty = T_vec(2);
    Tz = T_vec(3);

    Isp = rocket_data.Isp;

    ax = Tx./m + g(1);
    ay = Ty./m + g(2);
    az = Tz./m + g(3);
    dm = -T / (Isp*9.81);

    xdot = [vx vy vz ax ay az dm]';
    control = [enu_guidance_interp(1), enu_guidance_interp(2), enu_guidance_interp(3)]';
end

function [value, isterminal, direction] = mass_depleted(t, state)
    value(1) = state(7);
    isterminal(1) = 1;
    direction(1) = -1;

end
function [value, isterminal, direction] = impact(t, state)
    r = sqrt(state(1)^2 + state(2)^2 + state(3)^2);
    value(1) = r-6378e3;
    isterminal(1) = 1;
    direction(1) = -1;
end
function [value, isterminal, direction] = sma_reached(t, state)
    mu = 3.986e14;
    r_vec = state(1:3)';
    v_vec = state(4:6)';
    [sma, ecc, i] = RV2COE(r_vec, v_vec, mu);
    value(1) = sma - (6378+10000000)*1e3;
    isterminal(1) = 1;
    direction(1) = 0;

end