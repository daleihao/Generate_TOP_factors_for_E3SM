clc;
clear all;
close all;

%% lat .mat file
load('top_factor_0_25_degree.mat');

%% flip or transpose the data to match the nc format
SINSL_COSAS = (flipud(SINSL_COSAS))';
SINSL_SINAS = (flipud(SINSL_SINAS))';
SKY_VIEW = (flipud(SKY_VIEW))';
TERRAIN_CONFIG = (flipud(TERRAIN_CONFIG))';
STDEV_ELEV = (flipud(STDEV_ELEV))';

%% set nan as default values
SINSL_SINAS(isnan(SINSL_SINAS)) = 0;
SINSL_COSAS(isnan(SINSL_COSAS)) = 0;
SKY_VIEW( isnan(SKY_VIEW)) = 1;
TERRAIN_CONFIG(isnan(TERRAIN_CONFIG)) = 0;
STDEV_ELEV(isnan(STDEV_ELEV)) = 0;

%% creat .nc file
filename = ['top_factor_0_25degree_globe.nc'];
ncid = netcdf.create(filename,'NETCDF4');

%% define dimension
dimid_lon = netcdf.defDim(ncid,'lsmlon', 1440);
dimid_lat = netcdf.defDim(ncid,'lsmlat', 720);

%% creat lat/lon variables
res = 0.25;
[lon, lat] = meshgrid((-180+res/2):res:(180-res/2), (90-res/2):-res:(-90+res/2));
lat = (flipud(lat))';
lon = (flipud(lon))';

%% define variables
varname = "LATIXY";
varid_lat = netcdf.defVar(ncid,varname, 'NC_FLOAT', [ dimid_lon dimid_lat ]);
netcdf.putAtt(ncid,varid_lat,'long_name','latitude');
netcdf.putAtt(ncid,varid_lat,'units','degrees north');
netcdf.endDef(ncid);

netcdf.reDef(ncid);
varname = "LONGXY";
varid_lon = netcdf.defVar(ncid,varname, 'NC_FLOAT', [  dimid_lon dimid_lat]);
netcdf.putAtt(ncid,varid_lon,'long_name','longitude');
netcdf.putAtt(ncid,varid_lon,'units','degrees east');
netcdf.endDef(ncid);

netcdf.reDef(ncid);
varname = "SINSL_COSAS";
varid_1 = netcdf.defVar(ncid,varname, 'NC_FLOAT', [  dimid_lon  dimid_lat ]);
netcdf.putAtt(ncid,varid_1,'long_name','sin(slope) * cos(aspect)');
netcdf.putAtt(ncid,varid_1,'units','unitless');
netcdf.endDef(ncid);

netcdf.reDef(ncid);
varname = "SINSL_SINAS";
varid_2 = netcdf.defVar(ncid,varname, 'NC_FLOAT', [  dimid_lon  dimid_lat  ]);
netcdf.putAtt(ncid,varid_2,'long_name','sin(slope) * sin(aspect)');
netcdf.putAtt(ncid,varid_2,'units','unitless');
netcdf.endDef(ncid);

netcdf.reDef(ncid);
varname = "SKY_VIEW";
varid_3 = netcdf.defVar(ncid,varname, 'NC_FLOAT', [  dimid_lon  dimid_lat  ]);
netcdf.putAtt(ncid,varid_3,'long_name','sky view factor');
netcdf.putAtt(ncid,varid_3,'units','unitless');
netcdf.endDef(ncid);

netcdf.reDef(ncid);
varname = "STDEV_ELEV";
varid_4 = netcdf.defVar(ncid,varname, 'NC_FLOAT', [  dimid_lon  dimid_lat  ]);
netcdf.putAtt(ncid,varid_4,'long_name','standard deviation of elevation');
netcdf.putAtt(ncid,varid_4,'units','m');
netcdf.endDef(ncid);

netcdf.reDef(ncid);
varname = "TERRAIN_CONFIG";
varid_5 = netcdf.defVar(ncid,varname, 'NC_FLOAT', [  dimid_lon  dimid_lat  ]);
netcdf.putAtt(ncid,varid_5,'long_name','terrain configuration factor');
netcdf.putAtt(ncid,varid_5,'units','unitless');
netcdf.endDef(ncid);

%% put variables into .nc file
netcdf.putVar(ncid,varid_lat,lat);
netcdf.putVar(ncid,varid_lon,lon);
netcdf.putVar(ncid,varid_1,SINSL_COSAS);
netcdf.putVar(ncid,varid_2,SINSL_SINAS);
netcdf.putVar(ncid,varid_3,SKY_VIEW);
netcdf.putVar(ncid,varid_4,STDEV_ELEV);
netcdf.putVar(ncid,varid_5,TERRAIN_CONFIG);

netcdf.close(ncid);
