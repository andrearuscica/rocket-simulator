function plotSphere(radius)
%PLOTSPHERE Plots a 3D sphere of a given radius centered at the origin.
%
%   plotSphere(radius)
%
%   Inputs:
%       radius  - Sphere radius [scalar, positive]
%
%   Example:
%       plotSphere(6371)   % Earth-like sphere (km)

    arguments
        radius (1,1) double {mustBePositive}
    end

    % Generate sphere coordinates (unit sphere by default)
    [x, y, z] = sphere(100);  % 100 determines surface resolution

    % Scale by radius
    x = radius * x;
    y = radius * y;
    z = radius * z;

    earthTex = imread('landOcean.jpg');
    earthTex = flipud(earthTex);
    % Plot sphere
    hold on
    surf(x, y, z, ...
        'CData', earthTex, ...
        'FaceColor', 'texturemap', ...
        'EdgeColor', 'none');

    %axis equal
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    title(sprintf('3D Sphere of Radius %.2f', radius))
    grid on
    camlight headlight
    lighting gouraud
    view(3)
end
