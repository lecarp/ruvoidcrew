// Ship Workshop crew outfits. Edit these through the crew editor.

/datum/outfit/job/workshop_grey_pill_job_2
	parent_type = /datum/outfit/job/assistant
	name = "Grey Pill — Fodder"
	head = /obj/item/clothing/head/beanie/black
	gloves = /obj/item/clothing/gloves/color/black
	l_pocket = /obj/item/knife/combat/survival
	r_pocket = /obj/item/flashlight/seclite

/datum/outfit/job/workshop_grey_pill_job_2/pre_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	. = ..()
	head = /obj/item/clothing/head/beanie/black
	gloves = /obj/item/clothing/gloves/color/black
	l_pocket = /obj/item/knife/combat/survival
	r_pocket = /obj/item/flashlight/seclite

/datum/outfit/job/workshop_grey_pill_job_3
	parent_type = /datum/outfit/job/engineer
	name = "Grey Pill — Engineer"
	r_pocket = /obj/item/flashlight/seclite

/datum/outfit/job/workshop_grey_pill_job_3/pre_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	. = ..()
	r_pocket = /obj/item/flashlight/seclite
