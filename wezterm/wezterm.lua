local wezterm = require("wezterm")
local act = wezterm.action

local config = {
    font_size = 14,
    font = wezterm.font("JetBrainsMonoNL Nerd Font", {weight = "Regular"}),
    color_scheme = "Catppuccin Mocha", 
    -- color_scheme = "Batman", 
    -- color_scheme = 'carbonfox',
    initial_cols = 110,
    initial_rows = 30,

    use_fancy_tab_bar = false,
    -- hide_tab_bar_if_only_one_tab = true,
    window_decorations = "RESIZE",
    -- show_new_tab_button_in_tab_bar = false,
    window_background_opacity = 0.9,
    macos_window_background_blur = 70,
    text_background_opacity = 0.9,
    adjust_window_size_when_changing_font_size = false,

    window_close_confirmation = 'NeverPrompt',

    window_padding = {
        left = 20,
        right = 20,
        top = 20,
        bottom = 5,
    },

    mouse_bindings = { -- Paste on right-click
    {
        event = {
            Down = {
                streak = 1,
                button = 'Right'
            }
        },
        mods = 'NONE',
        action = wezterm.action {
            PasteFrom = 'Clipboard'
        }
    }, -- Change the default click behavior so that it only selects
    -- text and doesn't open hyperlinks
    {
        event = {
            Up = {
                streak = 1,
                button = 'Left'
            }
        },
        mods = 'NONE',
        action = wezterm.action {
            CompleteSelection = 'PrimarySelection'
        }
    }, -- CTRL-Click open hyperlinks
    {
        event = {
            Up = {
                streak = 1,
                button = 'Left'
            }
        },
        mods = 'CMD',
        action = 'OpenLinkAtMouseCursor'
    }},

    leader = { key="q", mods="CTRL", timeout_milliseconds=1000 },
    keys = {
        { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
        { key = "q", mods = "LEADER", action = act.CloseCurrentTab{ confirm = true } },
        { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
        { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
        { key = "w", mods = "LEADER", action = act.ShowTabNavigator },

        { key = "v", mods = "LEADER", action = act.SplitHorizontal{ domain = "CurrentPaneDomain" } },
        { key = "s", mods = "LEADER", action = act.SplitVertical{ domain = "CurrentPaneDomain" } },
        { key = "x", mods = "LEADER", action = act.CloseCurrentPane{ confirm = true } },
        { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

        { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
        { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
        { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
        { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
        { key = "H", mods = "LEADER", action = act.AdjustPaneSize{"Left", 10} },
        { key = "L", mods = "LEADER", action = act.AdjustPaneSize{"Right", 10} },
        { key = "K", mods = "LEADER", action = act.AdjustPaneSize{"Up", 5} },
        { key = "J", mods = "LEADER", action = act.AdjustPaneSize{"Down", 5} },

        -- { key = "x", mods = "CTRL|SHIFT", action = act.ActivateCopyMode },
        { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },

        { key = "Enter", mods = "ALT", action = 'DisableDefaultAssignment' },
  },
}

return config


