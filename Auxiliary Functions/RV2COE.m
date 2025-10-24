function [a, e, inc] = RV2COE(rvec, vvec, mu)
%RV2OR BELS Compute orbital elements from position and velocity vectors.
%   [a, e, inc] = rv2orbels(rvec, vvec, mu)
%   Computes semi-major axis (a), eccentricity (e), and inclination (inc, rad)
%   from position and velocity vectors in an inertial 3D frame.
%
%   Inputs:
%       rvec [3x1] - position vector [km or m]
%       vvec [3x1] - velocity vector [km/s or m/s]
%       mu         - gravitational parameter [km^3/s^2 or m^3/s^2]
%
%   Outputs:
%       a   - semi-major axis
%       e   - eccentricity
%       inc - inclination (radians)

    % Magnitudes
    r = norm(rvec);
    v = norm(vvec);

    % Specific orbital energy
    energy = 0.5*v^2 - mu/r;
    a = -mu / (2*energy);

    % Specific angular momentum vector
    hvec = cross(rvec, vvec);
    h = norm(hvec);

    % Eccentricity vector
    evec = (1/mu)*((v^2 - mu/r)*rvec - dot(rvec, vvec)*vvec);
    e = norm(evec);

    % Inclination
    inc = acos(hvec(3)/h);
end
