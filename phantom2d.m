e=[
    1.0000    0.6900    0.9200         0         0         0
   -0.8000    0.6624    0.8740         0   -0.0184         0
   -0.2000    0.1100    0.3100    0.2200         0   10.0000
   -0.2000    0.1600    0.2100   -0.2200         0  -10.0000
    0.1000    0.2100    0.2500         0    0.3500         0
    0.1000    0.0460    0.0460         0    0.1000         0
    0.1000    0.0460    0.0460         0   -0.1000         0
    0.1000    0.0460    0.0230   -0.0800   -0.6050         0
    0.1000    0.0230    0.0230         0   -0.6060         0
    0.1000    0.0230    0.0460    0.0600   -0.6050         0];
p = gen_phantom(e, 128);
function image = gen_phantom(ellipse, n)
    %     Column 1:  A      the additive intensity value of the ellipsoid
    %     Column 2:  a      the length of the x semi-axis of the ellipsoid 
    %     Column 3:  b      the length of the y semi-axis of the ellipsoid
    %     Column 4:  x0     the x-coordinate of the center of the ellipsoid
    %     Column 5:  y0     the y-coordinate of the center of the ellipsoid
    %     Column 6:  theta  angle between x-semi-axis and x
    sizeVol = size(ellipse);
    assert(sizeVol(2)==6);
    image = zeros(n, n);
    for i = 1: sizeVol(1)
        e = ellipse(i, :);
        rng =  ( (0:n-1)-(n-1)/2 ) / ((n-1)/2); 
        A = e(1);
        a = e(2);
        b = e(3);
        x0 = e(4);
        y0 = e(5);
        theta = e(6);
        [x, y] = meshgrid(rng, rng);
        x = x(:);
        y = y(:);
        x1 = cos(theta)*(x-x0) - sin(theta)*(y-y0);
        y1 = sin(theta)*(x-x0) + cos(theta)*(y-y0);
        p = (x1.^2/(a^2) + y1.^2/(b^2)) < 1;
        p = reshape(p, n, n);
        image = image + A*p;
    end
end


       