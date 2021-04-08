clear
close all

load('sinograph.mat');
sinograph = pt;
clear pt
sizeVol = [128, 128];
% w_max = sizeVol(1)*sqrt(2)/2;    % T=1/2W, the maximum of frequency
% T = 1/(2*w_max);        % interval between neighboring ray
T = 1;
N = sizeVol(1);

max_theta = 360;
n_theta = 512;
theta = linspace(0, max_theta, n_theta);

lb = T*(-(N+1)/2 : 1 : (N-3)/2);
ub = T*(-(N-1)/2 : 1 : (N-1)/2);
rng = (0:N-1)-(N-1)/2;
[x, y] = meshgrid(rng, rng);
x = x(:);
y = y(:);
image = zeros(sizeVol);
image = image(:);
w = abs(-N/2: N/2-1);
win = Sinc(N);
% fft -> filter -> ifft -> backprojection
for i = 1: length(theta)
    t = theta(i);
    q = real(ifft(fft(sinograph(i,:)).*w.*win));
    l = x*cosd(t) + y*sind(t);
    for j = 1: length(lb)
        line = (l>lb(j)).*(l<ub(j));
        val = q(j)/sum(line(:));
        if isnan(val)
            continue
        end
        line = logical(line);
        image(line) = image(line) + val;
    end
end
% projection:  Xcos(theta) + Ysin(theta) = (n-1/2)*T~ (n+1/2)*T (n = -N/2 ~ N/2-1)
image = reshape(image, N, N);
imshow(image, []);
save('recon.mat','image');
function win = hamming(N)
    n = 0:(N-1);
    win = 0.54 + (1-0.46)*cos(2*pi*n/N);
end

function win = Sinc(N)
    n = 2*(-N/2: N/2-1)/N;
    win = sin(pi*n)./(pi*n);
    win(isnan(win))=1;
end