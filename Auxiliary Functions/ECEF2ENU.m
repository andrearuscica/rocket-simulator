function [e_hat, n_hat, u_hat] = ECEF2ENU(r_ecef)
    % r_ecef = [x; y; z] in meters (ECEF)
    x = r_ecef(1); y = r_ecef(2); z = r_ecef(3);
    r = norm(r_ecef);
    if r < eps, error('r_ecef too small'); end

    % geographic latitude & longitude from ECEF (approx spherical Earth)
    lat = asin(z / r);            % geocentric latitude (spherical Earth). If you need geodetic, use more complex conversion.
    lon = atan2(y, x);

    % Up (radial outward)
    u_hat = [cos(lat)*cos(lon); cos(lat)*sin(lon); sin(lat)];

    % East
    e_hat = [-sin(lon); cos(lon); 0];

    % North
    n_hat = cross(u_hat, e_hat);  % ensures orthonormal right-handed triad
    n_hat = n_hat / norm(n_hat);

    % Re-normalize to guard numerical error
    e_hat = e_hat / norm(e_hat);
    u_hat = u_hat / norm(u_hat);
end