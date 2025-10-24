function event = event(sol)
posECI = sol.state(:,1:3);
velECI = sol.state(:,4:6);

mu = 39860044e14;
[a e i] = RV2COE(posECI, velECI, mu);
event = [a e i];