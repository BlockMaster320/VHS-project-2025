#macro LOG_LEVEL LogLevel.Debug

function debug(_msg){
	if (LOG_LEVEL <= LogLevel.Debug) {
		show_debug_message("🪲	" + string(_msg));
	}
}

/**
 * @function	debugIf(_condition, _msg)
 * @desc Logs _msg if _condition is equal to true.
 *
 * @param {Bool} _condition - True if _msg is supposed to be logged.
 * @param {String} _msg - Message to be logged.
 */
function debugIf(_condition, _msg){
	if (_condition && LOG_LEVEL <= LogLevel.Debug) {
		show_debug_message("🪲	" + string(_msg));
	}
}

function info(_msg){
	if (LOG_LEVEL <= LogLevel.Info) {
		show_debug_message("ℹ️	" + string(_msg));
	}
}

function warning(_msg){
	if (LOG_LEVEL <= LogLevel.Warning) {
		show_debug_message("⚠️	" + string(_msg));
	}
}

function error(_msg){
	if (LOG_LEVEL <= LogLevel.Error) {
		show_debug_message("❎️	" + string(_msg));
	}
}

function fatalError(_msg){
	if (LOG_LEVEL <= LogLevel.FatalError) {
		show_debug_message("☠️	" + string(_msg));
	}
}

enum LogLevel {
	Debug = 0,
	Info = 1,
	Warning = 2,
	Error = 3,
	FatalError = 4,
	Silent = 5
}

/*❌⚡✅❎⚠️☑️✖️⛔‼️ℹ️✔️✖⬜❗❓☠✔️*/
// 🐛
// 🪲
