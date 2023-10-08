
library(ncdf4)

ncin <- nc_open("/Users/gaellemuller-greven/Dropbox/data_science/projects/nasa_space_apps_2023/shared_data/EMIT_L2B_MIN_001_20230924T160243_2326710_052.nc")
#print(ncin)

lon <- ncvar_get(ncin,"location/lon")
lat <- ncvar_get(ncin,"location/lat")
glt_x <- ncvar_get(ncin,"location/glt_x")
glt_y <- ncvar_get(ncin,"location/glt_y")
elev <- ncvar_get(ncin,"location/elev")
minid_grp1 <- ncvar_get(ncin,"group_1_mineral_id")
minid_grp2 <- ncvar_get(ncin,"group_2_mineral_id")
minbd_grp1 <- ncvar_get(ncin,"group_1_band_depth")
minbd_grp2 <- ncvar_get(ncin,"group_2_band_depth")
min_index <- ncvar_get(ncin,"mineral_metadata/index")
min_name <- ncvar_get(ncin,"mineral_metadata/name")
min_group <- ncvar_get(ncin,"mineral_metadata/group")

lon_df <- melt(lon)
lat_df <- melt(lat)
glt_x_df <- melt(glt_x)
glt_y_df <- melt(glt_y)
elev_df <- melt(elev)
minid_grp1_df <- melt(minid_grp1)
minid_grp2_df <- melt(minid_grp2)
minbd_grp1_df <- melt(minbd_grp1)
minbd_grp2_df <- melt(minbd_grp2)

names(minid_grp1_df)[3] <- "min_id_grp1"
names(minid_grp2_df)[3] <- "min_id_grp2" 
names(minbd_grp1_df)[3] <- "min_bd_grp1"
names(minbd_grp2_df)[3] <- "min_bd_grp2"
names(lon_df)[3] <- "lon"
names(lat_df)[3] <- "lat"
names(elev_df)[3] <- "elev"

min_combined <- join_all(list(lon_df, lat_df, elev_df, minid_grp1_df, minid_grp2_df, minbd_grp1_df, minbd_grp2_df), by = c('Var1', 'Var2'), type = 'left')

names(min_combined)[1] <- "x_coord"
names(min_combined)[2] <- "y_coord"

min_combined$min_id_grp1 <- factor(min_combined$min_id_grp1)
min_combined$min_id_grp2 <- factor(min_combined$min_id_grp2)

min_combined_grp1 <- min_combined %>% dplyr::select(-min_id_grp2, -min_bd_grp2)
min_combined_grp2 <- min_combined %>% dplyr::select(-min_id_grp1, -min_bd_grp1)



min_meta_class <- read.csv("/Users/gaellemuller-greven/Dropbox/data_science/projects/nasa_space_apps_2023/shared_data/emit_mineral_metadata_briefest.csv", head = TRUE)
min_meta_class <- min_meta_class %>% dplyr::select(min_index, mineral_group, contains_lithium) %>% dplyr::filter(min_index < 295)
min_meta_class$min_index <- factor(min_meta_class$min_index)
min_name_df <- as.data.frame(min_name)
min_index_df <- as.data.frame(min_index)
min_group_df <- as.data.frame(min_group)
min_meta <- merge(min_index, min_name, by = 0, all = TRUE)
min_meta <- subset(min_meta, select = -Row.names)
min_meta <- merge(min_meta, min_group, by = 0, all = TRUE)
min_meta <- subset(min_meta, select = -Row.names)
names(min_meta)[1] <- "min_index"
names(min_meta)[2] <- "min_name"
names(min_meta)[3] <- "min_group"
min_meta <- min_meta %>% arrange(min_index)
min_meta$min_index <- factor(min_meta$min_index)
min_metadata <- merge(min_meta_class, min_meta, by = "min_index")


min_combined_grp1_meta <- left_join(min_combined_grp1, min_metadata, by = join_by(min_id_grp1 == min_index))
min_combined_grp2_meta <- left_join(min_combined_grp2, min_metadata, by = join_by(min_id_grp2 == min_index))


min_combined_grp1_meta_summary <- min_combined_grp1_meta %>% dplyr::group_by(min_id_grp1) %>% dplyr::summarise(min_bd_total = sum(min_bd_grp1), mineral_group = first(mineral_group), contains_li = first(contains_lithium))
min_combined_grp2_meta_summary <- min_combined_grp2_meta %>% dplyr::group_by(min_id_grp2) %>% dplyr::summarise(min_bd_total = sum(min_bd_grp2), mineral_group = first(mineral_group), contains_li = first(contains_lithium))




# plot mineral ID for each group

min_combined_grp1_num <- min_combined_grp1
min_combined_grp2_num <- min_combined_grp2
min_combined_grp1_num$min_id_grp1 <- as.numeric(as.character(min_combined_grp1_num$min_id_grp1))
min_combined_grp2_num$min_id_grp2 <- as.numeric(as.character(min_combined_grp2_num$min_id_grp2))

#min_combined_num %>% ggplot(aes(x = x_coord, y = y_coord, color = min_id_grp1)) + geom_point() + scale_color_gradient(low = "yellow", high = "darkgreen") + labs(x = "Downtrack", y = "Crosstrack", color = "Mineral ID\n(Group 1)")

#min_combined_num %>% ggplot(aes(x = x_coord, y = y_coord, color = min_id_grp2)) + geom_point() + scale_color_gradient(low = "yellow", high = "darkgreen") + labs(x = "Downtrack", y = "Crosstrack", color = "Mineral ID\n(Group 2)")

# plot mineral abundance by mineral ID

#min_combined_grp1_meta_summary %>% ggplot(aes(x = min_id_grp1, y = min_bd_total, fill = mineral_group)) + geom_bar(stat = "identity") + theme_classic() + labs(x = "Mineral ID (Group 1)", y = "Relative Mineral Abundance (Sum of Band Depth)", fill = "Mineral Group") + scale_x_discrete(guide = guide_axis(n.dodge = 2)) + theme(plot.title = element_text(size = 16), legend.key.size = unit(1,"line"), axis.text.y = element_text(size = 12, family = "sans"), axis.text.x = element_text(size = 12, family = "sans"), axis.title.y = element_text(size = 14, family = "sans"), axis.title.x = element_text(size = 14, family = "sans"), legend.title = element_text(size = 14, family = "sans"), legend.text = element_text(size = 11, family = "sans"), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), strip.text.x = element_text(size = 14))

#min_combined_grp2_meta_summary %>% ggplot(aes(x = min_id_grp2, y = min_bd_total, fill = mineral_group)) + geom_bar(stat = "identity") + theme_classic() + labs(x = "Mineral ID (Group 2)", y = "Relative Mineral Abundance (Sum of Band Depth)", fill = "Mineral Group") + scale_x_discrete(guide = guide_axis(n.dodge = 3)) + theme(plot.title = element_text(size = 16), legend.key.size = unit(1,"line"), axis.text.y = element_text(size = 12, family = "sans"), axis.text.x = element_text(size = 8, family = "sans"), axis.title.y = element_text(size = 14, family = "sans"), axis.title.x = element_text(size = 14, family = "sans"), legend.title = element_text(size = 14, family = "sans"), legend.text = element_text(size = 11, family = "sans"), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), strip.text.x = element_text(size = 14))

# plot by mineral abundance by mineral class

#min_combined_grp1_meta_summary %>% ggplot(aes(x = mineral_group, y = min_bd_total, fill = mineral_group)) + geom_bar(stat = "identity") + theme_classic() + labs(x = "Mineral Group (Group 1)", y = "Relative Mineral Abundance (Sum of Band Depth)", fill = "Mineral Group") + scale_x_discrete(guide = guide_axis(n.dodge = 2)) + theme(plot.title = element_text(size = 16), legend.key.size = unit(1,"line"), axis.text.y = element_text(size = 12, family = "sans"), axis.text.x = element_text(size = 12, family = "sans"), axis.title.y = element_text(size = 14, family = "sans"), axis.title.x = element_text(size = 14, family = "sans"), legend.title = element_text(size = 14, family = "sans"), legend.text = element_text(size = 11, family = "sans"), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), strip.text.x = element_text(size = 14))

#min_combined_grp2_meta_summary %>% ggplot(aes(x = mineral_group, y = min_bd_total, fill = mineral_group)) + geom_bar(stat = "identity") + theme_classic() + labs(x = "Mineral Group (Group 2)", y = "Relative Mineral Abundance (Sum of Band Depth)", fill = "Mineral Group") + scale_x_discrete(guide = guide_axis(n.dodge = 2)) + theme(plot.title = element_text(size = 16), legend.key.size = unit(1,"line"), axis.text.y = element_text(size = 12, family = "sans"), axis.text.x = element_text(size = 12, family = "sans"), axis.title.y = element_text(size = 14, family = "sans"), axis.title.x = element_text(size = 14, family = "sans"), legend.title = element_text(size = 14, family = "sans"), legend.text = element_text(size = 11, family = "sans"), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), strip.text.x = element_text(size = 14))

# plot mineral abundance by lithium-containing minerals

#min_combined_grp1_meta_summary %>% ggplot(aes(x = mineral_group, y = min_bd_total, fill = contains_li)) + geom_bar(stat = "identity") + theme_classic() + labs(x = "Mineral Group (Group 1)", y = "Relative Mineral Abundance (Sum of Band Depth)", fill = "Lithium-Containing\nMineral") + scale_x_discrete(guide = guide_axis(n.dodge = 2)) + theme(plot.title = element_text(size = 16), legend.key.size = unit(1,"line"), axis.text.y = element_text(size = 12, family = "sans"), axis.text.x = element_text(size = 12, family = "sans"), axis.title.y = element_text(size = 14, family = "sans"), axis.title.x = element_text(size = 14, family = "sans"), legend.title = element_text(size = 14, family = "sans"), legend.text = element_text(size = 11, family = "sans"), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), strip.text.x = element_text(size = 14))

#min_combined_grp2_meta_summary %>% ggplot(aes(x = mineral_group, y = min_bd_total, fill = contains_li)) + geom_bar(stat = "identity") + theme_classic() + labs(x = "Mineral Group (Group 2)", y = "Relative Mineral Abundance (Sum of Band Depth)", fill = "Lithium-Containing\nMineral") + scale_x_discrete(guide = guide_axis(n.dodge = 2)) + theme(plot.title = element_text(size = 16), legend.key.size = unit(1,"line"), axis.text.y = element_text(size = 12, family = "sans"), axis.text.x = element_text(size = 12, family = "sans"), axis.title.y = element_text(size = 14, family = "sans"), axis.title.x = element_text(size = 14, family = "sans"), legend.title = element_text(size = 14, family = "sans"), legend.text = element_text(size = 11, family = "sans"), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), strip.text.x = element_text(size = 14))
