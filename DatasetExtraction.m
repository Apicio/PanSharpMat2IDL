clc; clear all; close all;
import matlab.io.hdf4.*

path1 = '../Dataset/EO1A1750842002090110PY_B01_L1T.TIF'; % PAN
pan = GEOTIFF_READ(path1);
path2 = '../Dataset/EO1A1750842002090110PY_B02_L1T.TIF'; % UV
ms1p = GEOTIFF_READ(path2);
path3 = '../Dataset/EO1A1750842002090110PY_B03_L1T.TIF'; % BLU
ms1 = GEOTIFF_READ(path3);
path4 = '../Dataset/EO1A1750842002090110PY_B04_L1T.TIF'; % VERDE
ms2 = GEOTIFF_READ(path4);
path5 = '../Dataset/EO1A1750842002090110PY_B05_L1T.TIF'; % ROSSO
ms3 = GEOTIFF_READ(path5);
% path6 = '../Dataset/EO1A1750842002090110PY_B06_L1T.TIF';
% ms4 = GEOTIFF_READ(path6);

% [A, R] = geotiffread(path1);
% figure
% mapshow(A, R);
% axis image off

%% Creazione HDF4 - Usa SD API. 
% Struttura:
%        ___________
%       |   HDF4    | ---[Global Attr (mancano)]
%       |___________|
%       /   | ...  \
%    SDS1 SDS2     SDSn
%
sdID = sd.start('dataset.hdf','create');
%PAN_SDS1
ds_name = 'PAN_x_coords';
ds_type = 'double';
ds_dims = size(pan.x);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,pan.x);
sd.endAccess(sdsID);

%PAN_SDS2
ds_name = 'PAN_y_coords';
ds_type = 'double';
ds_dims = size(pan.y);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,pan.y);
  sd.endAccess(sdsID);

%PAN_SDS3
ds_name = 'PAN_raw_data';
ds_type = 'int16';
pan.z=flipud(pan.z); %Flippiamo, il movimento del satellite è ascendente.
pan.z= pan.z'; %Trasposto, ricordiamo che IDL e colonna x riga
ds_dims = size(pan.z);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,pan.z);
  sd.endAccess(sdsID);

%PAN_SDS4
%pan.info in array
toWrite = [pan.info.samples; pan.info.lines; pan.info.imsize; pan.info.bands];
ds_name = 'PAN_infos';
ds_type = 'double';
ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,toWrite);
  sd.endAccess(sdsID);

%PAN_SDS5
%pan.info.map_info in array
toWrite = [pan.info.map_info.dx; pan.info.map_info.dy; pan.info.map_info.mapx; pan.info.map_info.mapy];
ds_name = 'PAN_map_infos';
ds_type = 'double';
ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,toWrite);
  sd.endAccess(sdsID);


%% UV_SDS1
ds_name = 'UV_x_coords';
ds_type = 'double';
ds_dims = size(ms1p.x);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,ms1p.x);
  sd.endAccess(sdsID);

%UV_SDS2
ds_name = 'UV_y_coords';
ds_type = 'double';
ds_dims = size(ms1p.y);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,ms1p.y);
  sd.endAccess(sdsID);

%UV_SDS3
ds_name = 'UV_raw_data';
ds_type = 'int16';
ms1p.z=flipud(ms1p.z); %Flippiamo, il movimento del satellite è ascendente.
ms1p.z= ms1p.z'; %Trasposto, ricordiamo che IDL e colonna x riga
ds_dims = size(ms1p.z);

sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,ms1p.z);
sd.endAccess(sdsID);

%UV_SDS4
%pan.info in array
toWrite = [ms1p.info.samples; ms1p.info.lines; ms1p.info.imsize; ms1p.info.bands];
ds_name = 'UV_infos';
ds_type = 'double';
ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,toWrite);
  sd.endAccess(sdsID);

%UV_SDS5
%pan.info.map_info in array
toWrite = [ms1p.info.map_info.dx; ms1p.info.map_info.dy; ms1p.info.map_info.mapx; ms1p.info.map_info.mapy];
ds_name = 'UV_map_infos';
ds_type = 'double';
ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,toWrite);
  sd.endAccess(sdsID);

%% BLUE_SDS1
ds_name = 'BLUE_x_coords';
ds_type = 'double';
ds_dims = size(ms1.x);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,ms1.x);
  sd.endAccess(sdsID);

%BLUE_SDS2
ds_name = 'BLUE_y_coords';
ds_type = 'double';
ds_dims = size(ms1.y);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,ms1.y);
  sd.endAccess(sdsID);

%BLUE_SDS3
ds_name = 'BLUE_raw_data';
ds_type = 'int16';
ms1.z=flipud(ms1.z); %Flippiamo, il movimento del satellite è ascendente.
ms1.z= ms1.z'; %Trasposto, ricordiamo che IDL e colonna x riga
ds_dims = size(ms1.z);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,ms1.z);
  sd.endAccess(sdsID);

%BLUE_SDS4
%BLUE.info in array
toWrite = [ms1.info.samples; ms1.info.lines; ms1.info.imsize; ms1.info.bands];
ds_name = 'BLUE_infos';
ds_type = 'double';
ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,toWrite);
  sd.endAccess(sdsID);

%BLUE_SDS5
%BLUE.info.map_info in array
toWrite = [ms1.info.map_info.dx; ms1.info.map_info.dy; ms1.info.map_info.mapx; ms1.info.map_info.mapy];
s_name = 'BLUE_map_infos';
ds_type = 'double';
ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,toWrite);
  sd.endAccess(sdsID);

%% GREEN_SDS1
ds_name = 'GREEN_x_coords';
ds_type = 'double';
ds_dims = size(ms2.x);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,ms2.x);
  sd.endAccess(sdsID);

%GREEN_SDS2
ds_name = 'GREEN_y_coords';
ds_type = 'double';
ds_dims = size(ms2.y);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,ms2.y);
  sd.endAccess(sdsID);

%GREEN_SDS3
ds_name = 'GREEN_raw_data';
ds_type = 'int16';
ms2.z=flipud(ms2.z); %Flippiamo, il movimento del satellite è ascendente.
ms2.z= ms2.z'; %Trasposto, ricordiamo che IDL e colonna x riga
ds_dims = size(ms2.z);

sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,ms2.z);
  sd.endAccess(sdsID);

%GREEN_SDS4
%GREEN.info in array
toWrite = [ms2.info.samples; ms2.info.lines; ms2.info.imsize; ms2.info.bands];
ds_name = 'GREEN_infos';
ds_type = 'double';
ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,toWrite);
  sd.endAccess(sdsID);

%GREEN_SDS5
%GREEN.info.map_info in array
toWrite = [ms2.info.map_info.dx; ms2.info.map_info.dy; ms2.info.map_info.mapx; ms2.info.map_info.mapy];
ds_name = 'GREEN_map_infos';
ds_type = 'double';
ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,toWrite);
  sd.endAccess(sdsID);

%% RED_SDS1
ds_name = 'RED_x_coords';
ds_type = 'double';
ds_dims = size(ms3.x);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,ms3.x);
  sd.endAccess(sdsID);

%RED_SDS2
ds_name = 'RED_y_coords';
ds_type = 'double';
ds_dims = size(ms3.y);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,ms3.y);
  sd.endAccess(sdsID);

%RED_SDS3
ds_name = 'RED_raw_data';
ds_type = 'int16';
ms3.z=flipud(ms3.z); %Flippiamo, il movimento del satellite è ascendente.
ms3.z= ms3.z'; %Trasposto, ricordiamo che IDL e colonna x riga
ds_dims = size(ms3.z);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,ms3.z);
  sd.endAccess(sdsID);

%RED_SDS4
%RED.info in array
toWrite = [ms3.info.samples; ms3.info.lines; ms3.info.imsize; ms3.info.bands];
ds_name = 'RED_infos';
ds_type = 'double';
ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,toWrite);
  sd.endAccess(sdsID);

%RED_SDS5
%RED.info.map_info in array
toWrite = [ms3.info.map_info.dx; ms3.info.map_info.dy; ms3.info.map_info.mapx; ms3.info.map_info.mapy];
ds_name = 'RED_map_infos';
ds_type = 'double';
ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,toWrite);
  sd.endAccess(sdsID);


%Chiudere lo SD
sd.close(sdID);

% figure
% imshow(flipud(pan.z), 'xdata', pan.x, 'ydata', pan.y);
% figure
% imshow(flipud(ms1p.z), 'xdata', ms1p.x, 'ydata', ms1p.y);
