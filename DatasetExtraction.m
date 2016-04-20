clc; clear all; close all;
path1 = '../Dataset/EO1A1750842002090110PY_B01_L1T.TIF';
pan = GEOTIFF_READ(path1);
path2 = '../Dataset/EO1A1750842002090110PY_B02_L1T.TIF';
ms1p = GEOTIFF_READ(path2);
path3 = '../Dataset/EO1A1750842002090110PY_B03_L1T.TIF';
ms1 = GEOTIFF_READ(path3);
path4 = '../Dataset/EO1A1750842002090110PY_B04_L1T.TIF';
ms2 = GEOTIFF_READ(path4);
path5 = '../Dataset/EO1A1750842002090110PY_B05_L1T.TIF';
ms3 = GEOTIFF_READ(path5);
path6 = '../Dataset/EO1A1750842002090110PY_B06_L1T.TIF';
ms4 = GEOTIFF_READ(path6);


[A, R] = geotiffread(path6);
figure
mapshow(A, R);
axis image off


% sdID = sd.start('dataset.hdf','create');
% ds_name = 'PAN';
% ds_type = 'double';




figure
imshow(flipud(pan.z), 'xdata', pan.x, 'ydata', pan.y);
figure
imshow(flipud(ms1p.z), 'xdata', ms1p.x, 'ydata', ms1p.y);
