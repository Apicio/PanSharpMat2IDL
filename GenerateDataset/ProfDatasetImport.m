% Export Prof's Dataset
import matlab.io.hdf4.*

sdID = sd.start('prof.hdf','create');

%PAN_SDS1
ds_name = 'PAN_image'; ds_type = 'double'; toWrite = I_PAN; ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
sd.writeData(sdsID,[0 0],toWrite); %writeData(sdsID,start,data)
sd.endAccess(sdsID);

%MS_IMAGE_LR
ds_name = 'I_MS_LR'; ds_type = 'double'; toWrite = I_MS_LR; ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
sd.writeData(sdsID,[0 0 0],toWrite); %writeData(sdsID,start,data)
sd.endAccess(sdsID);

%MS_IMAGE_LR
ds_name = 'I_MS'; ds_type = 'double'; toWrite = I_MS; ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
sd.writeData(sdsID,[0 0 0],toWrite); %writeData(sdsID,start,data)
sd.endAccess(sdsID);

%DELTA_PAN_MATLAB
ds_name = 'DELTA_PAN_MATLAB'; ds_type = 'double'; toWrite = DELTA_PAN_MATLAB; ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
sd.writeData(sdsID,[0 0 0],toWrite); %writeData(sdsID,start,data)
sd.endAccess(sdsID);

%FUSED_MS_MATLAB
ds_name = 'FUSED_MS_MATLAB'; ds_type = 'double'; toWrite = FUSED_MS_MATLAB; ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
sd.writeData(sdsID,[0 0 0],toWrite); %writeData(sdsID,start,data)
sd.endAccess(sdsID);

%g
ds_name = 'g'; ds_type = 'double'; toWrite = g; ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
sd.writeData(sdsID,[0 0],toWrite); %writeData(sdsID,start,data)
sd.endAccess(sdsID);

%PAN_MTF_MATLAB
ds_name = 'PAN_MTF_MATLAB'; ds_type = 'double'; toWrite = PAN_MTF_MATLAB; ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
sd.writeData(sdsID,[0 0 0],toWrite); %writeData(sdsID,start,data)
sd.endAccess(sdsID);

%PAN_RESIZE_MATLAB
ds_name = 'PAN_RESIZE_MATLAB'; ds_type = 'double'; toWrite = PAN_RESIZE_MATLAB; ds_dims = size(toWrite);
sdsID = sd.create(sdID,ds_name,ds_type,ds_dims);
sd.writeData(sdsID,[0 0 0],toWrite); %writeData(sdsID,start,data)
sd.endAccess(sdsID);

sd.close(sdID);