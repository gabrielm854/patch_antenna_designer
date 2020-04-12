% Desired User Parameters
h_sub = input("Substrate thickness (mm): ")/1000
epsilon_r = input("Substrate's dielectric constant: ")
freq = input("Desired resonant frequency (GHz): ")*10^9
freq_l = input("Lowest frequency in sweep (GHz): ")*10^9
freq_h = input("Highest frequency in sweep (GHz): ")*10^9
sim_points = input("Desired number of simulation points: ")

% Constants
epsilon_0 = 8.854*10^(-12)
mu_0 = 4*3.14159265*10^(-7)
c = 1/sqrt(epsilon_0*mu_0)
lambda = c/freq

% Sweep
if rem(sim_points,2) == 0
    sim_points = sim_points + 1
end
freq_jump = (freq_h - freq_l)/sim_points

% Calculate initial parameters
patch_w = ((c/(2*freq))*sqrt(2/(epsilon_r+1)))
if (patch_w/h_sub) < 1
    epsilon_eff = ((epsilon_r + 1)/2) + ((epsilon_r - 1)/2)*(1+12*(h_sub/patch_w))^(-0.5) + 0.04*(1-(patch_w/h_sub))^2
else
    epsilon_eff = ((epsilon_r + 1)/2) + ((epsilon_r - 1)/2)*(1+12*(h_sub/patch_w))^(-0.5)
end

L_eff = (c)/(2*freq*sqrt(epsilon_eff))
deltaL = 0.412*h_sub*(((epsilon_eff + 0.3)*((patch_w/h_sub) + 0.264))/((epsilon_eff - 0.258)*((patch_w/h_sub) + 0.8)))
patch_l = (L_eff - deltaL)

% Create patch model
patch = patchMicrostrip
patch.Length = patch_l
patch.Width = patch_w
patch.Height = h_sub
patch.Substrate = dielectric('Name', 'Substrate','EpsilonR',epsilon_r,'LossTangent',0,'Thickness',h_sub)
patch.GroundPlaneLength = patch_l + lambda/2
patch.GroundPlaneWidth = patch_w + lambda/2
patch.PatchCenterOffset = [0 0]
x_offset = 0
y_offset = -patch_l/2
patch.FeedOffset = [x_offset y_offset]
figure('Name','Initial Antenna Model')
show(patch)
s_params = sparameters(patch,freq_l:freq_jump:freq_h,50)
figure('Name','Initial Antenna S_1_1 Response')
smithplot(s_params)
figure('Name','Initial Antenna Radiation Pattern')
patternElevation(patch,freq)
title(sprintf('Directivity @ %.2f GHz',freq*1e-9))