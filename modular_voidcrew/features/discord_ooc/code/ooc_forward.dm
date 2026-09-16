// VOIDCREW modular feature: discord_ooc
// Форвардинг игрового OOC в Discord через webhook.

/// Отправляет OOC-сообщение в настроенный Discord-webhook.
///
/// Параметры:
/// - raw_msg    — текст сообщения, как его ввёл игрок
/// - sender_key — ckey отправителя (client.key), для отображения в Discord
/proc/forward_ooc_to_discord(raw_msg, sender_key)
	var/ooc_webhook = CONFIG_GET(string/ooc_webhook_url)
	if(!ooc_webhook)
		message_admins("DISCORD_OOC ОШИБКА: В конфиге не найден ooc_webhook_url!")
		return

	var/clean_msg = copytext_char(raw_msg, 1, 1900)
	var/list/payload = list(
		"username" = "[sender_key] (OOC)",
		"content" = clean_msg,
		"allowed_mentions" = list("parse" = list())
	)

	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(_send_ooc_webhook_async), ooc_webhook, payload)

/proc/_send_ooc_webhook_async(webhook_url, list/payload)
	var/datum/http_request/request = new()
	request.prepare(
		RUSTG_HTTP_METHOD_POST,
		webhook_url,
		json_encode(payload),
		list("Content-Type" = "application/json"),
		""
	)
	request.begin_async()
	UNTIL(request.is_complete())
	var/datum/http_response/response = request.into_response()

	if(response.errored || response.status_code >= 400)
		message_admins("DISCORD_OOC ОШИБКА: код [response.status_code] | ответ: [response.body] | ошибка: [response.error]")
	else
		message_admins("DISCORD_OOC: Успешно доставлено в Discord! (код [response.status_code])")
