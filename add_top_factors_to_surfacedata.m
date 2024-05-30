clc;
clear all;
close all;

%% read top data
topfilename = "top_factor_0_25degree_globe.nc";
SINSL_SINAS = ncread(topfilename, 'SINSL_SINAS');
SINSL_COSAS = ncread(topfilename, 'SINSL_COSAS');
SKY_VIEW = ncread(topfilename, 'SKY_VIEW');
TERRAIN_CONFIG = ncread(topfilename, 'TERRAIN_CONFIG');
STDEV_ELEV = ncread(topfilename, 'STDEV_ELEV');

%% set default values
SINSL_SINAS(isnan(SINSL_SINAS)) = 0;
SINSL_COSAS(isnan(SINSL_COSAS)) = 0;
SKY_VIEW( isnan(SKY_VIEW)) = 1;
TERRAIN_CONFIG(isnan(TERRAIN_CONFIG)) = 0;
STDEV_ELEV(isnan(STDEV_ELEV)) = 0;

%% copy existing surface data
filename = ['surfdata_0.25x0.25_simyr1850_c240125_TOP.nc'];
info = ncinfo(filename);
ncid = netcdf.open(filename,'WRITE');

%% get dimensions
dimid_lon = netcdf.inqDimID(ncid,'lsmlon');
dimid_lat = netcdf.inqDimID(ncid,'lsmlat');

netcdf.reDef(ncid);
varname = "SINSL_COSAS";
varid_1 = netcdf.defVar(ncid,varname, 'NC_DOUBLE', [  dimid_lon  dimid_lat ]);
netcdf.putAtt(ncid,varid_1,'long_name','sin(slope) * cos(aspect)');
netcdf.putAtt(ncid,varid_1,'units','unitless');

varname = "SINSL_SINAS";
varid_2 = netcdf.defVar(ncid,varname, 'NC_DOUBLE', [  dimid_lon  dimid_lat  ]);
netcdf.putAtt(ncid,varid_2,'long_name','sin(slope) * sin(aspect)');
netcdf.putAtt(ncid,varid_2,'units','unitless');


varname = "SKY_VIEW";
varid_3 = netcdf.defVar(ncid,varname, 'NC_DOUBLE', [  dimid_lon  dimid_lat  ]);
netcdf.putAtt(ncid,varid_3,'long_name','sky view factor');
netcdf.putAtt(ncid,varid_3,'units','unitless');

varname = "STDEV_ELEV";
varid_4 = netcdf.defVar(ncid,varname, 'NC_DOUBLE', [  dimid_lon  dimid_lat  ]);
netcdf.putAtt(ncid,varid_4,'long_name','standard deviation of elevation');
netcdf.putAtt(ncid,varid_4,'units','m');

varname = "TERRAIN_CONFIG";
varid_5 = netcdf.defVar(ncid,varname, 'NC_DOUBLE', [  dimid_lon  dimid_lat  ]);
netcdf.putAtt(ncid,varid_5,'long_name','terrain configuration factor');
netcdf.putAtt(ncid,varid_5,'units','unitless');

netcdf.endDef(ncid);

%% put variables into .nc files
netcdf.putVar(ncid,varid_1,SINSL_COSAS);
netcdf.putVar(ncid,varid_2,SINSL_SINAS);
netcdf.putVar(ncid,varid_3,SKY_VIEW);
netcdf.putVar(ncid,varid_4,STDEV_ELEV);
netcdf.putVar(ncid,varid_5,TERRAIN_CONFIG);

netcdf.close(ncid);
