clc; clear all; close all;
import matlab.io.hdf4.*
paths %% File da creare con i percorsi al dataset
pan = GEOTIFF_READ(path1); % PAN
ms1p = GEOTIFF_READ(path2); % UV
ms1 = GEOTIFF_READ(path3); % BLU
ms2 = GEOTIFF_READ(path4); % VERDE
ms3 = GEOTIFF_READ(path5); % ROSSO
%% Creazione HDF4 - Usa SD API. 
% Proposed Structure:
%        _____________________________________________________________________
%       |                                 HDF4                                |-> Global Attributes 
%       |_____________________________________________________________________|
%       /                  |                    |                |     ...     \
%    SDS_PAN           SDS_PAN_RAW         SDS_PAN_INFO        SDS_UV          SDS_N
%       |                   |                   |                 |              |    
% Geogaphic Coords       Raw Data          Num Samples           ...            ...    
%                                          Num Lines 
%                                          Num Bands
%                                          Spatial Res.
%
sdID = sd.start('dataset.hdf','create');
sd.setAttr(sdID,'ratio',3);
sd.setAttr(sdID,'MTF_NyqMS',[0.28,0.29, 0.29, 0.30]);
sd.setAttr(sdID,'MTF_NyqPAN',0.15);

%PAN_SDS1
ds_name = 'PAN_spatial_coords'; ds_type = 'double'; toWrite = [pan.x,pan.y]; ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
sd.writeData(sdsID,[0 0],toWrite);
sd.endAccess(sdsID);

%PAN_SDS_RAW
ds_name = 'PAN_raw_data';
ds_type = 'int16';
pan.z=flipud(pan.z); %Flippiamo, il movimento del satellite è ascendente.
pan.z= pan.z'; %Trasposto, ricordiamo che IDL e colonna x riga
ds_dims = size(pan.z);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,pan.z);
sd.endAccess(sdsID);

%PAN_SDS_INFO
%pan.info in array
toWrite = [pan.info.samples; pan.info.lines; pan.info.imsize; pan.info.bands;
           pan.info.map_info.dx; pan.info.map_info.dy; pan.info.map_info.mapx; pan.info.map_info.mapy
           ];
ds_name = 'PAN_infos';
ds_type = 'double';
ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,toWrite);
sd.endAccess(sdsID);


%% UV_SDS1
ds_name = 'UV_spatial_coords'; ds_type = 'double'; toWrite =[ms1p.x , ms1p.y]; ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,toWrite);
  sd.endAccess(sdsID);

%UV_SDS3
ds_name = 'UV_raw_data'; ds_type = 'int16';
ms1p.z=flipud(ms1p.z); %Flippiamo, il movimento del satellite è ascendente.
ms1p.z= ms1p.z'; %Trasposto, ricordiamo che IDL e colonna x riga
ds_dims = size(ms1p.z);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,ms1p.z);
sd.endAccess(sdsID);

%UV_SDS4
%pan.info in array
toWrite = [ms1p.info.samples; ms1p.info.lines; ms1p.info.imsize; ms1p.info.bands
           ms1p.info.map_info.dx; ms1p.info.map_info.dy; ms1p.info.map_info.mapx; ms1p.info.map_info.mapy
          ];
ds_name = 'UV_infos';
ds_type = 'double';
ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,toWrite);
 sd.endAccess(sdsID);

%% BLUE_SDS1
ds_name = 'BLUE_spatial_coords'; ds_type = 'double'; toWrite = [ms1.x, ms1.y]; ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,toWrite);
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
toWrite = [ms1.info.samples; ms1.info.lines; ms1.info.imsize; ms1.info.bands;
           ms1.info.map_info.dx; ms1.info.map_info.dy; ms1.info.map_info.mapx; ms1.info.map_info.mapy];
ds_name = 'BLUE_infos';
ds_type = 'double';
ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,toWrite);
  sd.endAccess(sdsID);

%% GREEN_SDS1
ds_name = 'GREEN_spatial_coords'; ds_type = 'double'; toWrite = [ms2.x, ms2.y]; ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,toWrite);
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
toWrite = [ms2.info.samples; ms2.info.lines; ms2.info.imsize; ms2.info.bands;
           ms2.info.map_info.dx; ms2.info.map_info.dy; ms2.info.map_info.mapx; ms2.info.map_info.mapy];
ds_name = 'GREEN_infos';
ds_type = 'double';
ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,toWrite);
sd.endAccess(sdsID);

%% RED_SDS1
ds_name = 'RED_spatial_coords'; ds_type = 'double'; toWrite = [ms3.x , ms3.y]; ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
start = [0 0];
sd.writeData(sdsID,start,toWrite);
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
toWrite = [ms3.info.samples; ms3.info.lines; ms3.info.imsize; ms3.info.bands;
           ms3.info.map_info.dx; ms3.info.map_info.dy; ms3.info.map_info.mapx; ms3.info.map_info.mapy];
ds_name = 'RED_infos';
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
