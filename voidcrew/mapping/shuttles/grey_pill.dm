/datum/map_template/shuttle/voidcrew/grey_pill
	name = "Grey Pill"
	catalog_desc = "Solo / Small crew ship that has many cheap and good upgrades"
	suffix = "grey_pill"
	short_name = "Grey Pill"
	part_requirements = list()
	has_upgrade_slots = TRUE
	upgrade_slot_ids = list("bridge", "special", "engineering", "special_2", "docking_port_side")
	player_hidden = FALSE
	job_slots = list(list(name = "Captain", officer = TRUE, outfit = /datum/outfit/job/captain, category = "Command", slots = 1), list(name = "Fodder", officer = FALSE, outfit = /datum/outfit/job/workshop_grey_pill_job_2, category = "Assistant", slots = 4), list(name = "Engineer", officer = FALSE, outfit = /datum/outfit/job/workshop_grey_pill_job_3, category = "Engineering", slots = 3))
	available_themes = list("standard")

/obj/docking_port/mobile/voidcrew/grey_pill
	name = "Grey Pill"
	area_type = /area/shuttle/voidcrew/grey_pill
	port_direction = 2
	preferred_direction = NORTH

/area/shuttle/voidcrew/grey_pill
	name = "Grey Pill"
	icon_state = "station"
