
% Extract states
x  = yout(:,1);
y  = yout(:,2);
z  = yout(:,3);
vx = yout(:,4);
vy = yout(:,5);
vz = yout(:,6);
mass = yout(:,end);
% Time
t = tout(:);

% Derived quantities
Re = 6378e3; % Earth radius [m]
h = sqrt(x.^2 + y.^2 + z.^2) - Re;      % altitude [m]
v = sqrt(vx.^2 + vy.^2 + vz.^2);        % speed [m/s]
burnout = find(diff(mass) > -0.01, 1, "first");


%%
figure('Color','w');
hold on; grid on; axis equal;

% Earth sphere
plotSphere(Re/1e3);  % light blue Earth

% Trajectory
plot3(x/1e3, y/1e3, z/1e3, ...
    'LineWidth', 2, 'Color', [0.2 0.2 0.8]);

% Burnout point
plot3(x(burnout)/1e3, y(burnout)/1e3, z(burnout)/1e3, ...
    'ro', 'MarkerSize', 8, 'LineWidth', 2);

% Launch point
plot3(x(1)/1e3, y(1)/1e3, z(1)/1e3, ...
    'x', 'MarkerSize', 8, 'LineWidth', 2);

% Titles and labels (LaTeX)
title('\textbf{3D Trajectory}','Interpreter','latex','FontSize',14);
xlabel('$x~[\mathrm{km}]$','Interpreter','latex','FontSize',12);
ylabel('$y~[\mathrm{km}]$','Interpreter','latex','FontSize',12);
zlabel('$z~[\mathrm{km}]$','Interpreter','latex','FontSize',12);

% Axes appearance
set(gca, 'FontName','Helvetica', 'FontSize',12, ...
    'Box','on', 'TickLabelInterpreter','latex');

% Legend (LaTeX-safe)
legend({'Earth','Trajectory','Burnout'}, ...
    'Interpreter','latex','Location','best');



%% ---------------- ALTITUDE vs TIME ----------------
figure('Color','w');
plot(t, h/1e3, 'LineWidth', 2, 'Color', [0.1 0.6 0.1]);
grid on;
xlabel('$t~[\mathrm{s}]$','Interpreter','latex','FontSize',14);
ylabel('$h~[\mathrm{km}]$','Interpreter','latex','FontSize',14);
title('$\textbf{Altitude Profile}$','Interpreter','latex','FontSize',16);
set(gca,'FontName','Helvetica','FontSize',12,'Box','on','TickLabelInterpreter','latex');

%% ---------------- SPEED vs TIME ----------------
figure('Color','w');
plot(t, v*3.6, 'LineWidth', 2, 'Color', [0 0.45 0.74]); hold on;
yline(9e3*3.6, '--r', '$9~\mathrm{km/s}$','Interpreter','latex','LineWidth',1.5);
grid on;
xlabel('$t~[\mathrm{s}]$','Interpreter','latex','FontSize',14);
ylabel('$v~[\mathrm{km/h}]$','Interpreter','latex','FontSize',14);
title('$\textbf{Velocity Profile}$','Interpreter','latex','FontSize',16);
set(gca,'FontName','Helvetica','FontSize',12,'Box','on','TickLabelInterpreter','latex');

%% ---------------- MASS vs TIME ----------------
figure('Color','w');
plot(t, mass, 'LineWidth', 2, 'Color', [0.85 0.33 0.1]);
grid on;
xlabel('$t~[\mathrm{s}]$','Interpreter','latex','FontSize',14);
ylabel('$m~[\mathrm{kg}]$','Interpreter','latex','FontSize',14);
title('$\textbf{Mass Evolution}$','Interpreter','latex','FontSize',16);
set(gca,'FontName','Helvetica','FontSize',12,'Box','on','TickLabelInterpreter','latex');
