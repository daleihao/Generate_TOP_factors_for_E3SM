# Matlab codes to generate TOP factors for E3SM
## 1. The 1km TOP data was generated based on MERIT DEM, which is stored in ```/global/cfs/cdirs/e3sm/daleihao/TOP_data``` in ```perlmutter```.
## 2. The matlab code:
  ### a. ```upscale_top_factors.m```: Upscale TOP factors from 1km to 0.5/1.0 degree
  ### b. ```convert_mat2nc.m```: Convert TOP factor fileS from .mat format to .nc format.
  ### c. ```add_top_factors_to_surfacedata.m```: Add TOP factors into the existing surface data.

# References
## 1. Hao, D., Bisht, G., Gu, Y., Lee, W.-L., Liou, K.-N., and Leung, L. R.: A parameterization of sub-grid topographical effects on solar radiation in the E3SM Land Model (version 1.0): implementation and evaluation over the Tibetan Plateau, Geosci. Model Dev., 14, 6273–6289, https://doi.org/10.5194/gmd-14-6273-2021, 2021.
## 2. Li, L., Bisht, G., Hao, D., and Leung, L. R.: Global 1 km land surface parameters for kilometer-scale Earth system modeling, Earth Syst. Sci. Data, 16, 2007–2032, https://doi.org/10.5194/essd-16-2007-2024, 2024.
