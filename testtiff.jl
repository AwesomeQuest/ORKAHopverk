using FileIO, OMETIFF, ImageShow, Plots

img = load("IslandsDEMv1.0_2x2m_isn2016_shade_41.tif")

plot(Float32.(img))