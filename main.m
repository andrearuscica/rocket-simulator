clc; clear
initialState = [0;0];
endTime = 500;
Thrust = 250;
thrustProfile = @(time) abs(sin(time))*Thrust;
timeON = linspace(1,200,1e4);
Force = thrustProfile(0.05*timeON);
Force(end) = 0;
T = timeseries(Force(:), timeON(:));
Tdata = T.data;
Ttime = T.time;

figure;
plot(T)

options = odeset('Events', @(t,state) eventfcn(t,state));
[tout, yout] = ode45(@(t, state) eom(t, state, Tdata, Ttime), linspace(1,500), initialState, options);
figure;
plot(tout,yout(:,1))
figure;
plot(tout, yout(:,2))
%%
plot(tout, xout)
function EOM = eom(t, state, Tdata, Ttime, m)
arguments
    t double
    state double
    Tdata double
    Ttime double
    m double = 10;
end
    Tprofile = interp1(Ttime,Tdata, t,'nearest','extrap');
    vel = state(2);
    acc = Tprofile / m - 9.81;
    EOM = [vel; acc];
end

function [value, isterminal, direction] = eventfcn(t, state)
    value = state(1);
    isterminal = 1;
    direction = -1;
end