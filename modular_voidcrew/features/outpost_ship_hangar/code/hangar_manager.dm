/**
 * # Outpost Ship Hangar Manager
 *
 * Core logic for serializing, persisting, and retrieving player ships
 * across rounds with physical item preservation.
 */

/obj/structure/closet/on_object_saved()
	. = ..()
	var/list/serialized_items = list()
	for(var/obj/item/item in contents)
		var/meta = generate_tgm_metadata(item)
		serialized_items += "[item.type][meta]"
	if(length(serialized_items))
		var/items_text = serialized_items.Join(",\n")
		return . ? "[.],\n[items_text]" : items_text

/obj/item/storage/on_object_saved()
	. = ..()
	var/list/serialized_items = list()
	for(var/obj/item/item in contents)
		var/meta = generate_tgm_metadata(item)
		serialized_items += "[item.type][meta]"
	if(length(serialized_items))
		var/items_text = serialized_items.Join(",\n")
		return . ? "[.],\n[items_text]" : items_text

/**
 * Loads the manifest.json for a player's hangar fleet.
 */
/proc/get_player_hangar_manifest(ckey)
	if(!ckey)
		return list("ships" = list())
	var/dir_path = get_player_hangar_dir(ckey)
	var/manifest_path = "[dir_path]manifest.json"
	if(!fexists(manifest_path))
		return list("ships" = list())

	var/json_raw = rustg_file_read(manifest_path)
	if(!json_raw)
		return list("ships" = list())

	var/list/data = json_decode(json_raw)
	if(!islist(data) || !islist(data["ships"]))
		return list("ships" = list())
	return data

/**
 * Saves the manifest.json for a player's hangar fleet.
 */
/proc/save_player_hangar_manifest(ckey, list/manifest_data)
	if(!ckey || !islist(manifest_data))
		return FALSE
	var/dir_path = get_player_hangar_dir(ckey)
	var/manifest_path = "[dir_path]manifest.json"
	var/json_str = json_encode(manifest_data)
	rustg_file_write(json_str, manifest_path)
	return TRUE

/**
 * Counts physical objects on board the ship (on floor and in containers).
 */
/proc/hangar_count_ship_items(obj/structure/overmap/ship/ship)
	if(!ship?.shuttle)
		return 0
	var/count = 0
	for(var/turf/ship_turf in ship.shuttle.return_turfs())
		for(var/obj/thing in ship_turf)
			if(istype(thing, /obj/item))
				count++
			if(istype(thing, /obj/structure/closet) || istype(thing, /obj/item/storage))
				for(var/obj/item/inside in thing.contents)
					count++
	return count

/**
 * Safely evacuates any living carbons (players/crew) from the ship before storage.
 */
/proc/hangar_evacuate_ship_crew(obj/structure/overmap/ship/ship, turf/target_turf)
	if(!ship?.shuttle || !target_turf)
		return
	for(var/turf/ship_turf in ship.shuttle.return_turfs())
		for(var/mob/living/carbon/crewmember in ship_turf)
			crewmember.forceMove(target_turf)
			to_chat(crewmember, span_warning("Судно [ship.name] перемещено в ангар. Вы эвакуированы на платформу причала."))

/**
 * Stores a docked ship into the player's persistent hangar.
 */
/proc/hangar_store_ship(obj/structure/overmap/ship/ship, mob/living/user, obj/machinery/computer/outpost_ship_hangar/console)
	if(!ship || !user || !console)
		return list("success" = FALSE, "error" = "Некорректные параметры операции.")

	if(!ship.is_ship_captain(user))
		return list("success" = FALSE, "error" = "Только капитан судна имеет право поставить его в ангар.")

	if(!ship.shuttle?.get_docked())
		return list("success" = FALSE, "error" = "Корабль должен быть надёжно пристыкован к причалу.")

	var/user_ckey = user.ckey
	var/list/manifest = get_player_hangar_manifest(user_ckey)
	var/list/ships = manifest["ships"]

	// Capacity check (allow if updating an already registered deployed ship)
	var/existing_entry_index = 0
	for(var/i in 1 to length(ships))
		var/list/entry = ships[i]
		if(entry["name"] == ship.name)
			existing_entry_index = i
			break

	if(!existing_entry_index && length(ships) >= HANGAR_MAX_SLOTS)
		return list("success" = FALSE, "error" = "Ангар заполнен! Максимум [HANGAR_MAX_SLOTS] слотов.")

	// Evacuate crew safely to the elevator alcove platform
	var/turf/evac_turf = get_turf(console)
	hangar_evacuate_ship_crew(ship, evac_turf)

	// Bounding coordinates
	var/list/coords = ship.shuttle.return_coords()
	var/min_x = min(coords[1], coords[3])
	var/max_x = max(coords[1], coords[3])
	var/min_y = min(coords[2], coords[4])
	var/max_y = max(coords[2], coords[4])
	var/the_z = ship.shuttle.z

	// Serialize ship turf map via write_map
	var/map_text = write_map(min_x, min_y, the_z, max_x, max_y, the_z, ALL, SAVE_SHUTTLEAREA_ONLY)
	if(!map_text)
		return list("success" = FALSE, "error" = "Ошибка сериализации карты судна.")

	var/ship_id = existing_entry_index ? ships[existing_entry_index]["id"] : "ship_[world.realtime]_[rand(1000, 9999)]"
	var/dir_path = get_player_hangar_dir(user_ckey)
	var/dmm_path = "[dir_path][ship_id].dmm"
	var/tmp_path = "[dmm_path].tmp"
	var/bak_path = "[dmm_path].bak"

	if(fexists(dmm_path))
		fcopy(dmm_path, bak_path)
		fdel(dmm_path)

	rustg_file_write(map_text, tmp_path)
	fcopy(tmp_path, dmm_path)
	fdel(tmp_path)

	var/items_count = hangar_count_ship_items(ship)
	var/ship_mass = 120.0
	var/hull_class = "Неизвестный"
	var/hull_id = "squab_a"

	if(ship.hull_class)
		hull_class = "[ship.hull_class]"
	if(ship.shuttle)
		ship_mass = round(ship.shuttle.width * ship.shuttle.height * 0.12, 0.1)

	var/credits = 0
	if(ship.ship_account)
		credits = ship.ship_account.money

	var/list/ship_data = list(
		"id" = ship_id,
		"name" = ship.name,
		"hull_class" = hull_class,
		"hull_id" = hull_id,
		"mass" = ship_mass,
		"credits" = credits,
		"items_count" = items_count,
		"status" = HANGAR_STATUS_STORED,
		"saved_date" = time2text(world.realtime, "DD-MM-YYYY hh:mm")
	)

	if(existing_entry_index)
		ships[existing_entry_index] = ship_data
	else
		ships += list(ship_data)

	manifest["ships"] = ships
	save_player_hangar_manifest(user_ckey, manifest)

	// Cleanly remove the physical ship and its mobile port
	var/obj/docking_port/stationary/dest_dock = ship.shuttle.get_docked()
	var/datum/outpost_berth/berth = console.berth
	if(berth)
		berth.ship = null

	ship.shuttle.jumpToNullSpace()
	qdel(ship)

	if(berth)
		berth.arrived = FALSE
		if(berth.outpost)
			berth.outpost.refresh_elevator_uis()

	return list("success" = TRUE, "ship_id" = ship_id)

/**
 * Retrieves a ship from the persistent hangar to an allocated outpost berth.
 */
/proc/hangar_retrieve_ship(ckey, ship_id, obj/structure/overmap/outpost, mob/living/user, datum/outpost_berth/existing_berth = null)
	if(!ckey || !ship_id || !outpost || !user)
		return list("success" = FALSE, "error" = "Некорректные параметры для выгрузки судна.")

	var/list/manifest = get_player_hangar_manifest(ckey)
	var/list/ships = manifest["ships"]
	var/list/target_entry = null

	for(var/list/entry in ships)
		if(entry["id"] == ship_id)
			target_entry = entry
			break

	if(!target_entry)
		return list("success" = FALSE, "error" = "Корабль не найден в ангаре.")

	if(target_entry["status"] == HANGAR_STATUS_DEPLOYED)
		return list("success" = FALSE, "error" = "Данный корабль уже развернут на причале!")

	var/dir_path = get_player_hangar_dir(ckey)
	var/dmm_path = "[dir_path][ship_id].dmm"
	if(!fexists(dmm_path))
		return list("success" = FALSE, "error" = "Файл карты судна не найден на диске.")

	// Preload the DMM template
	var/datum/map_template/shuttle/template = new /datum/map_template/shuttle(dmm_path, "[target_entry["name"]]", TRUE)
	if(!template.cached_map)
		return list("success" = FALSE, "error" = "Не удалось загрузить слепок корабля из DMM.")

	// Determine destination berth
	var/datum/outpost_berth/target_berth = existing_berth
	if(!target_berth || target_berth.ship)
		// Instantiate temporary overmap ship to allocate berth safely
		var/obj/structure/overmap/ship/alloc_dummy = new(outpost.loc)
		alloc_dummy.name = target_entry["name"]
		target_berth = outpost.allocate_berth(alloc_dummy)
		if(!target_berth)
			qdel(alloc_dummy)
			return list("success" = FALSE, "error" = "Нет свободных причалов на аванпосте!")

	// Load template straight into target_berth.dock
	var/obj/docking_port/mobile/voidcrew/loaded = SSshuttle.action_load(template, target_berth.dock)
	if(!loaded)
		target_berth.release(force = TRUE)
		return list("success" = FALSE, "error" = "Сбой стыковки шаттла к причалу.")

	// Create and wire overmap ship entity
	var/obj/structure/overmap/ship/new_ship = new(outpost.loc)
	new_ship.name = target_entry["name"]
	new_ship.shuttle = loaded
	loaded.current_ship = new_ship
	target_berth.ship = new_ship
	target_berth.arrived = TRUE

	// Register Captain
	if(new_ship.enlist_crewmember(user))
		new_ship.claimed_captain = user.mind
		grant_captain_management(user, new_ship)
		to_chat(user, span_notice("Вы зарегистрированы как командир судна [new_ship.name]."))

	// Mark status as deployed
	target_entry["status"] = HANGAR_STATUS_DEPLOYED
	save_player_hangar_manifest(ckey, manifest)

	outpost.refresh_elevator_uis()

	return list("success" = TRUE, "berth_number" = target_berth.berth_number, "ship_name" = new_ship.name)

