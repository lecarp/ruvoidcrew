/**
 * # Outpost Ship Hangar Console
 *
 * Terminal machine located in outpost berths and the concourse lobby.
 * Interacts with players to store and deploy persistent ships using TGUI.
 */

/obj/machinery/computer/outpost_ship_hangar
	name = "hangar terminal"
	desc = "A heavy tactical console wired into the outpost docking array. Used to store ships into hangar reserves and retrieve them."
	icon = 'icons/obj/machines/computer.dmi'
	icon_state = "computer"
	icon_keyboard = "generic_key"
	icon_screen = null
	density = TRUE
	use_power = NO_POWER_USE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

	/// The host outpost (trader outpost or player outpost)
	var/obj/structure/overmap/outpost
	/// The berth datum this console is attached to (null if concourse)
	var/datum/outpost_berth/berth
	/// Whether this console is in the main concourse lobby (floor 0)
	var/is_concourse = FALSE
	/// Currently selected ship ID for preview display
	var/selected_ship_id = ""

/obj/machinery/computer/outpost_ship_hangar/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/machinery/computer/outpost_ship_hangar/update_overlays()
	. = ..()
	if(icon_keyboard)
		. += icon_keyboard
	if(!(machine_stat & (NOPOWER|BROKEN)))
		. += mutable_appearance('modular_voidcrew/features/outpost_ship_hangar/icons/hangar_console.dmi', "hangar")
		. += emissive_appearance('modular_voidcrew/features/outpost_ship_hangar/icons/hangar_console.dmi', "hangar", src)

/obj/machinery/computer/outpost_ship_hangar/wrench_act_secondary(mob/living/user, obj/item/tool)
	balloon_alert(user, "bolted to the outpost deck!")
	return ITEM_INTERACT_BLOCKING

/obj/machinery/computer/outpost_ship_hangar/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OutpostShipHangar", name)
		ui.open()

/obj/machinery/computer/outpost_ship_hangar/ui_data(mob/user)
	var/list/data = list()
	data["is_concourse"] = is_concourse
	data["berth_number"] = berth ? berth.berth_number : 0

	var/obj/structure/overmap/ship/docked_ship = berth?.ship
	data["has_ship"] = !isnull(docked_ship)

	if(docked_ship)
		var/cap_str = "Не назначен"
		if(docked_ship.claimed_captain)
			var/cap_name = docked_ship.claimed_captain.name
			var/cap_key = docked_ship.claimed_captain.key || docked_ship.claimed_captain.ckey
			cap_str = "[cap_name] ([cap_key])"
		var/integrity = 100
		if(docked_ship.hull_integrity)
			integrity = round(docked_ship.hull_integrity * 100)
		data["berth_ship"] = list(
			"name" = docked_ship.name,
			"captain" = cap_str,
			"integrity" = integrity,
			"items_count" = hangar_count_ship_items(docked_ship)
		)
		data["is_captain"] = docked_ship.is_ship_captain(user)
	else
		data["berth_ship"] = null
		data["is_captain"] = FALSE

	var/user_ckey = user.ckey
	var/list/manifest = get_player_hangar_manifest(user_ckey)
	var/list/ships = manifest["ships"] || list()
	data["ships"] = ships
	data["slots_used"] = length(ships)
	data["max_slots"] = HANGAR_MAX_SLOTS

	if(!selected_ship_id && length(ships))
		selected_ship_id = ships[1]["id"]

	var/list/selected_data = null
	for(var/list/ship_entry in ships)
		if(ship_entry["id"] == selected_ship_id)
			selected_data = ship_entry
			break

	data["selected_ship_id"] = selected_ship_id
	data["selected_ship"] = selected_data

	return data

/obj/machinery/computer/outpost_ship_hangar/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/living/user = usr
	if(!istype(user))
		return

	switch(action)
		if(HANGAR_ACTION_SELECT)
			selected_ship_id = params["id"]
			return TRUE

		if(HANGAR_ACTION_STORE)
			if(is_concourse)
				balloon_alert(user, "перемещение судна доступно только на причале!")
				return TRUE
			if(!berth?.ship)
				balloon_alert(user, "на причале нет корабля!")
				return TRUE

			var/list/result = hangar_store_ship(berth.ship, user, src)
			if(result["success"])
				balloon_alert(user, "корабль успешно перемещен в ангар")
				selected_ship_id = result["ship_id"]
			else
				balloon_alert(user, result["error"])
			return TRUE

		if(HANGAR_ACTION_DEPLOY)
			var/target_id = params["id"] || selected_ship_id
			if(!target_id)
				balloon_alert(user, "выберите корабль!")
				return TRUE

			var/list/result = hangar_retrieve_ship(user.ckey, target_id, outpost, user, berth)
			if(result["success"])
				balloon_alert(user, "корабль выгружен на причал [result["berth_number"]]!")
			else
				balloon_alert(user, result["error"])
			return TRUE

		if(HANGAR_ACTION_CARGO)
			if(berth?.ship)
				var/items = hangar_count_ship_items(berth.ship)
				to_chat(user, span_notice("Опись трюма: на борту зафиксировано [items] сохранённых объектов."))
			else
				to_chat(user, span_notice("Опись трюма: причал свободен."))
			return TRUE
