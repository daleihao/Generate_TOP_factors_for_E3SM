clc;
clear all;
close all;


%% create variables at 1km resolution
svfs = nan(18000,36000);
tcfs = nan(18000,36000);
svf_ns = nan(18000,36000);
tcf_ns = nan(18000,36000);
sinsl_cosas = nan(18000,36000);
sinsl_sinas = nan(18000,36000);
slopes = nan(18000,36000);
aspects = nan(18000,36000);
elevations = nan(18000,36000);

count = 0;
%% read values from files
for tile_row = 1:18
    for tile_col = 1:36

        if(~exist(['top_factors_extend/' 'TOP_' num2str(tile_row) '_' num2str(tile_col) '.mat']))
            continue;
        end
        load(['top_factors_extend/' 'TOP_' num2str(tile_row) '_' num2str(tile_col) '.mat']);
        count = count + 1;

        row_start = ((tile_row-1)*1000+1);
        row_end = (tile_row*1000);
        col_start = ((tile_col-1)*1000+1);
        col_end = (tile_col*1000);

        i_start = 201;
        j_start = 201;

        if(tile_row == 1)
            i_start = 1;
        end

        if(tile_col == 1)
            j_start = 1;
        end

        svf_tmp = svf(i_start:(i_start+999),j_start:(j_start+999));
        slope_tmp = slope(i_start:(i_start+999),j_start:(j_start+999));
        slope_tmp = slope_tmp*pi/180;
        aspect_tmp =  aspect(i_start:(i_start+999),j_start:(j_start+999));
        aspect_tmp = (90 - aspect_tmp)*pi/180;

        svf_tmp(svf_tmp>1 | svf_tmp<0) = 1;

        elevations(row_start:row_end, col_start:col_end) = elevation(i_start:(i_start+999),j_start:(j_start+999));
        slopes(row_start:row_end, col_start:col_end) = slope(i_start:(i_start+999),j_start:(j_start+999));
        aspects(row_start:row_end, col_start:col_end) = aspect(i_start:(i_start+999),j_start:(j_start+999));

        sinsl_cosas(row_start:row_end, col_start:col_end) = sin(slope_tmp).*cos(aspect_tmp)./cos(slope_tmp);
        sinsl_sinas(row_start:row_end, col_start:col_end) = sin(slope_tmp).*sin(aspect_tmp)./cos(slope_tmp);
        svf_ns(row_start:row_end, col_start:col_end) = svf_tmp./cos(slope_tmp);
        tcf_ns(row_start:row_end, col_start:col_end) = ((1+cos(slope_tmp))/2-svf_tmp)./cos(slope_tmp);
        svfs(row_start:row_end, col_start:col_end) = svf_tmp;
        tcfs(row_start:row_end, col_start:col_end) = ((1+cos(slope_tmp))/2-svf_tmp);

        disp(count);
    end
end


%% filter nan values
filters = elevations<0 | isnan(elevations);
sinsl_cosas(filters) = nan;
sinsl_sinas(filters) = nan;
svf_ns(filters) = nan;
tcf_ns(filters) = nan;
stddevs(filters) = nan;
elevations(filters) = nan;
slopes(filters) = nan;
aspects(filters) = nan;

%% upscale to low resolution
low_res = 0.25; % 0.5
rows = 180/low_res;
cols = 360/low_res;

sinsl_cosas_low = nan(rows, cols);
sinsl_sinas_low = nan(rows, cols);
svf_ns_low = nan(rows, cols);
tcf_ns_low = nan(rows, cols);
stddevs_low = nan(rows, cols);
elev_low = nan(rows, cols);

row_start = 0;
col_start = 0;

res = low_res/0.01; % represent how many 1km grids within a low resolution grid.

for i = 1:rows
    for j = 1:cols

        row_tmp = (row_start+(i-1)*res+1):(row_start+i*res);
        col_tmp = (col_start+(j-1)*res+1):(col_start+j*res);

        tmp = sinsl_cosas(row_tmp, col_tmp);
        sinsl_cosas_low(i,j) = nanmean(tmp(:));

        tmp = sinsl_sinas(row_tmp, col_tmp);
        sinsl_sinas_low(i,j) = nanmean(tmp(:));

        tmp = svf_ns(row_tmp, col_tmp);
        svf_ns_low(i,j) = nanmean(tmp(:));

        tmp = tcf_ns(row_tmp, col_tmp);
        tcf_ns_low(i,j) = nanmean(tmp(:));

        tmp = elevations(row_tmp, col_tmp);
        stddevs_low(i,j) = nanstd(tmp(:), 1);
        elev_low(i,j) = nanmean(tmp(:));
    end
end

SINSL_SINAS = sinsl_sinas_low;
SINSL_COSAS = sinsl_cosas_low;
SKY_VIEW = svf_ns_low;
TERRAIN_CONFIG = tcf_ns_low;
STDEV_ELEV = stddevs_low;

%% save as .mat file
save(['top_factor_0_' res '_degree.mat'], 'SINSL_SINAS','SINSL_COSAS','SKY_VIEW','TERRAIN_CONFIG','STDEV_ELEV');
