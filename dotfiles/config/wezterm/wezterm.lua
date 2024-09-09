local wezterm = require("wezterm")

config = wezterm.config_builder()

config = {
	font = wezterm.font("UbuntuMono Nerd Font", { weight = 400 }),
	automatically_reload_config = true,
	font_size = 17.0,
	color_scheme = "Catppuccin Mocha", -- or Macchiato, Frappe, Latte
	enable_tab_bar = false,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",
	default_cursor_style = "BlinkingBar",
	background = {
		{
			source = { Color = "#1E1E2F" },
		},
	},
	window_padding = {
		left = 5,
		right = 5,
		top = 0,
		bottom = 0,
	},
	keys = {
		{
			key = "t",
			mods = "CTRL|SHIFT",
			action = wezterm.action_callback(function(window, pane)
				-- 检查是否有浮动窗口存在的逻辑（伪代码，实际操作系统实现可能需要外部脚本或工具）
				local result = os.execute('wezterm cli list | grep "floating_window"')

				if result then
					-- 如果浮动窗口已经存在，则聚焦它
					wezterm.cli().send_to_pane({
						target_pane_id = result.pane_id,
						action = wezterm.action.BringPaneToFront,
					})
				else
					-- 如果浮动窗口不存在，则创建一个新的
					window:perform_action(
						wezterm.action.SpawnWindow({
							position = "center",
							size = { rows = 20, cols = 60 },
							-- 你可以添加其他窗口配置选项，如透明度、字体大小等
						}),
						pane
					)
				end
			end),
		},
		{
			key = "]",
			mods = "CMD|SHIFT",
			action = "ToggleFullScreen",
		},
	},

	-- 其他浮动窗口设置
	window_background_opacity = 0.9, -- 设置背景透明度
	macos_window_background_blur = 8, -- 设置背景模糊度
}

return config
