% MATLAB script that add the PhysioNet Cardiovascular Signal Toolbox to
% Matlab path, aslo check Matlab version
 
% --- Check Matlab version
if verLessThan('matlab', '9.3.0')
    warning('Matlab:Version', 'Your version of Matlab is too old. R2017b or higher is requested.\n');
    return;
end

fprintf('Adding the PhysioNet-HRV-Tool to Matlab path\n')
try
    ss = ['..' filesep 'PhysioNet-HRV-Tool'];
    addpath(genpath(ss));
    fprintf('PhysioNet-HRV-Tool successfully added to Matlab path\n')
catch 
end

