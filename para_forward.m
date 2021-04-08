clear
close all

load('phantom.mat');
image = p;
clear p
sizeVol = size(image);
% w_max = sizeVol(1)*sqrt(2)/2;    % T=1/2W, the maximum of frequency
% T = 1/(2*w_max);        % interval between neighboring ray
T = 1;
N = sizeVol(1);

max_theta = 360;
n_theta = 512;
theta = linspace(0, max_theta, n_theta);

% projection:  Xcos(theta) + Ysin(theta) = (n-1/2)*T~ (n+1/2)*T (n = -N/2 ~ N/2-1)
lb = T*(-(N+1)/2 : 1 : (N-3)/2);
ub = T*(-(N-1)/2 : 1 : (N-1)/2);
rng = (0:N-1)-(N-1)/2;
[x, y] = meshgrid(rng, rng);
x = x(:);
y = y(:);
image = image(:);
pt = zeros(n_theta, N);
for i = 1: length(theta)
    t = theta(i);
    l = x*cosd(t) + y*sind(t);
    for j = 1: length(lb)
        line = (l>lb(j)).*(l<ub(j));
        line = logical(line);
        pt(i, j) = sum(image(line));
    end
end
save('sinograph.mat', 'pt');
imshow(pt, []);
