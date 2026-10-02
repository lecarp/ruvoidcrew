/**
 * # Outpost Ship Hangar Defines & Constants
 *
 * System for persistent ship storage, retrieval, and inventory preservation.
 */

#define HANGAR_SAVES_ROOT "data/player_saves/"
#define HANGAR_MAX_SLOTS 5

#define HANGAR_STATUS_STORED "stored"
#define HANGAR_STATUS_DEPLOYED "deployed"

#define HANGAR_ACTION_STORE "store"
#define HANGAR_ACTION_DEPLOY "deploy"
#define HANGAR_ACTION_SELECT "select"
#define HANGAR_ACTION_CARGO "cargo"

/**
 * Returns the standardized directory path for a player's ship hangar saves.
 * Standard format: data/player_saves/[first_letter]/[ckey]/ships/
 */
/proc/get_player_hangar_dir(ckey)
	if(!ckey)
		return null
	var/clean_ckey = ckey(ckey)
	if(!clean_ckey)
		return null
	var/first_letter = copytext(clean_ckey, 1, 2)
	return "[HANGAR_SAVES_ROOT][first_letter]/[clean_ckey]/ships/"

