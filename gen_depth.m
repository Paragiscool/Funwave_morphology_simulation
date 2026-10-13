clc; clear; close all;

% ============================================
% DOMAIN PARAMETERS
% ============================================
Mglob = 1000;        % number of grid points in X
Nglob = 500;        % number of grid points in Y
DX = 1.0;           % grid spacing in X (m)
DY = 1.0;           % grid spacing in Y (m)

Lx = Mglob * DX;    % domain length in X
Ly = Nglob * DY;    % domain width in Y

% ============================================
% CHANNEL / BATHYMETRY PARAMETERS
% ============================================
depth_center = 10.0;     % maximum depth at center (m)
depth_edge   = 2.0;      % minimum depth at edges (m)

% Coordinates
x = (0:Mglob-1) * DX;
y = (0:Nglob-1) * DY;

[X, Y] = meshgrid(x, y);

% ============================================
% PARABOLIC CROSS-CHANNEL PROFILE
% ============================================
y_center = Ly / 2;

% Derive parabola coefficient:
% depth(y) = a*(y - y_center)^2 + depth_center
a = (depth_edge - depth_center) / (y_center^2);

% 1D depth profile across Y
depth_profile = a * (y - y_center).^2 + depth_center;

% 2D bathymetry (same along X direction)
DEP = repmat(depth_profile(:), 1, Mglob);

% Ensure no depth < minimum
DEP = max(DEP, depth_edge);

% ============================================
% 3D SURFACE PLOT (flipped visually: Y reversed, depth plotted downward)
% ============================================
figure;
% Plot depth as negative so depth increases downward on the z-axis (visual realism)
hSurf = surf(X, Y, -DEP, 'EdgeColor', 'none'); 
shading interp;
colorbar;
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Depth (m) (positive downwards)');
title('Parabolic Channel Bathymetry (visual flipped)');
% Reverse the Y axis so the plot is flipped upside-down (only visual)
set(gca, 'YDir', 'reverse');
% Optional: set a colormap that looks good for bathymetry
colormap(parula);
view(45, 35);

% ============================================
% 2D CONTOUR PLOT (flipped vertically for realism)
% ============================================
figure;
% Use contourf with original positive depth values, then reverse Y to flip image
contourf(X, Y, DEP, 30, 'LineStyle', 'none');
colorbar;
xlabel('X (m)');
ylabel('Y (m)');
title('Bathymetry Contour (visual flipped)');
% Flip Y axis for the plot only
set(gca, 'YDir', 'reverse');
set(gca, 'YTickMode', 'auto');

% ============================================
% SAVE FUNWAVE DEPTH FILE (dep_00000)
% (left unchanged — file contains depth as positive numbers, not flipped)
% ============================================
fid = fopen('dep_00000', 'w');
if fid == -1
    error('Could not open file dep_00000 for writing. Check permissions and working folder.');
end
for j = 1:Nglob
    fprintf(fid, '%12.6f', DEP(j, :));
    fprintf(fid, '\n');
end
fclose(fid);

disp(' ');
disp('==============================================');
disp('   ✅ Depth file "dep_00000" generated.');
disp('   Domain size: ');
fprintf('      Mglob = %d , Nglob = %d\n', Mglob, Nglob);
disp('==============================================');
