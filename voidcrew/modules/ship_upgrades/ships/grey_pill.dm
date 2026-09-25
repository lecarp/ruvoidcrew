
/datum/ship_theme/grey_pill_standard
	id = "standard"
	name = "Standard"
	for_ship = /datum/map_template/shuttle/voidcrew/grey_pill
	template_suffix = "grey_pill"
	is_default = TRUE
	upgrade_slot_ids = list("bridge", "special", "engineering", "special_2")

/datum/ship_upgrade_module/grey_pill_bridge_basic
	id = "bridge_basic"
	name = "Rock Bottom"
	slot = "bridge"
	for_ship = /datum/map_template/shuttle/voidcrew/grey_pill
	for_theme = list("standard")
	map_file = "grey_pill/rock_bottom.dmm"
	is_default = TRUE
	desc = "Bare minimum"

/datum/ship_upgrade_module/grey_pill_special_basic
	id = "special_basic"
	name = "(Nothing) Special"
	slot = "special"
	for_ship = /datum/map_template/shuttle/voidcrew/grey_pill
	for_theme = list("standard")
	map_file = "grey_pill/nothing_special.dmm"
	is_default = TRUE
	desc = "its just a wall"

/datum/ship_upgrade_module/grey_pill_basic_gear
	part_cost = list(PART_CLASS_COMBAT = 1, PART_CLASS_SCIENCE = 1)
	id = "basic_gear"
	name = "Basic Gear"
	slot = "bridge"
	for_ship = /datum/map_template/shuttle/voidcrew/grey_pill
	for_theme = list("standard")
	map_file = "grey_pill/basic_gear.dmm"
	is_default = FALSE
	desc = "Chargers, 2 retro lasguns and minimal medical gear\n"

/datum/ship_upgrade_module/grey_pill_orm_instead_of_wall
	part_cost = list(PART_CLASS_MISC = 2)
	id = "orm_instead_of_wall"
	name = "ORM"
	slot = "special"
	for_ship = /datum/map_template/shuttle/voidcrew/grey_pill
	for_theme = list("standard")
	map_file = "grey_pill/orm.dmm"
	is_default = FALSE
	desc = "Ore redemption machine in place of a wall\n\nStill gives points even without silo"

/datum/ship_upgrade_module/grey_pill_better_weapons
	part_cost = list(PART_CLASS_COMBAT = 2, PART_CLASS_SCIENCE = 1)
	id = "better_weapons"
	name = "Better Weapons"
	slot = "bridge"
	for_ship = /datum/map_template/shuttle/voidcrew/grey_pill
	for_theme = list("standard")
	map_file = "grey_pill/better_weapons.dmm"
	is_default = FALSE
	desc = "Keeps basic medical supply, gets you 3 eguns and one stunbatong\n"

/datum/ship_upgrade_module/grey_pill_better_medical_supply
	part_cost = list(PART_CLASS_COMBAT = 1, PART_CLASS_SCIENCE = 2)
	id = "better_medical_supply"
	name = "Better medical supply"
	slot = "bridge"
	for_ship = /datum/map_template/shuttle/voidcrew/grey_pill
	for_theme = list("standard")
	map_file = "grey_pill/better_medical_supply.dmm"
	is_default = FALSE
	desc = "Surgery kit and all types of medkits that you can commonly find"

/datum/ship_upgrade_module/grey_pill_premium
	part_cost = list(PART_CLASS_COMBAT = 2, PART_CLASS_SCIENCE = 2, PART_CLASS_TRADE = 3)
	id = "premium"
	name = "Premium"
	slot = "bridge"
	for_ship = /datum/map_template/shuttle/voidcrew/grey_pill
	for_theme = list("standard")
	map_file = "grey_pill/premium.dmm"
	is_default = FALSE
	desc = "Better medical supply combined with better weapons, plus a bonus in form of a better medbot and one silver pick"

/datum/ship_upgrade_module/grey_pill_silo
	part_cost = list(PART_CLASS_SCIENCE = 1, PART_CLASS_MISC = 2)
	id = "silo"
	name = "Silo"
	slot = "special"
	for_ship = /datum/map_template/shuttle/voidcrew/grey_pill
	for_theme = list("standard")
	map_file = "grey_pill/silo.dmm"
	is_default = FALSE
	desc = "Ehhh sure"

/datum/ship_upgrade_module/grey_pill_engineering_basic
	id = "engineering_basic"
	name = "Baseline Engineering"
	slot = "engineering"
	for_ship = /datum/map_template/shuttle/voidcrew/grey_pill
	for_theme = list("standard")
	map_file = "grey_pill/baseline_engineering.dmm"
	is_default = TRUE
	desc = "You realy should mine for uranium\n\nI recomend making generator run at 90kw while SMES giving 80kw (add more for depending on apc consumption)"

/datum/ship_upgrade_module/grey_pill_special_2_basic
	id = "special_2_basic"
	name = "EVA suit holder"
	slot = "special_2"
	for_ship = /datum/map_template/shuttle/voidcrew/grey_pill
	for_theme = list("standard")
	map_file = "grey_pill/eva_suit_holder.dmm"
	is_default = TRUE
	desc = "Suit storage with voidsuit (EVA suit)\n\nThats it"

/datum/ship_upgrade_module/grey_pill_mining_closet
	part_cost = list(PART_CLASS_MISC = 2)
	id = "mining_closet"
	name = "Mining closet"
	slot = "special_2"
	for_ship = /datum/map_template/shuttle/voidcrew/grey_pill
	for_theme = list("standard")
	map_file = "grey_pill/mining_closet.dmm"
	is_default = FALSE
	desc = "Replaces suit storage with full mining closet, duh\n\nBetter to get silo with this one since you alredy gonna go for mining tech anyway for vendor"

/datum/ship_upgrade_module/grey_pill_mining_vendor
	part_cost = list(PART_CLASS_TRADE = 2)
	id = "mining_vendor"
	name = "Mining Vendor"
	slot = "special_2"
	for_ship = /datum/map_template/shuttle/voidcrew/grey_pill
	for_theme = list("standard")
	map_file = "grey_pill/mining_vendor.dmm"
	is_default = FALSE
	desc = "Mining vendor unstead of suit storage\n\nI recomend getting ORM with this one"

/datum/ship_upgrade_module/grey_pill_build_your_own_teg
	part_cost = list(PART_CLASS_TRADE = 2, PART_CLASS_MISC = 4)
	id = "build_your_own_teg"
	name = "\"Build Your Own Teg\""
	slot = "engineering"
	for_ship = /datum/map_template/shuttle/voidcrew/grey_pill
	for_theme = list("standard")
	map_file = "grey_pill/build_your_own_teg.dmm"
	is_default = FALSE
	desc = "TEG but its now a lego set\n\nI recomend turning APC off while making it, otherwise you wont be able to turn of thermomachines, pumps and teg control panel\n\nOh and this hull is NOT moving without a teg so get to work"
