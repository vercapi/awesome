
---------------------------
-- Nitro solarized theme --
---------------------------

theme                                           = {}

theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/nitro"
theme.wallpaper                                 = "/home/vercapi/backgrounds/theme_ntp_background.png"

-- theme base color config
theme.dark_bg                                   = "#002b36"
theme.light_bg                                  = "#eee8d5"
theme.red                                       = "#cb4b16"
theme.green                                     = "#2aa198"
theme.blue                                      = "#268bd2"
theme.yellow                                    = "#b58900"
theme.inactive_fg                               = "#657b83"
theme.font                                      = "SquareFont 14"

-- basic config
theme.fg_normal                                 = theme.red
theme.fg_focus                                  = theme.blue
theme.bg_normal                                 = theme.light_bg
theme.bg_focus                                  = theme.dark_bg
theme.fg_urgent                                 = theme.red
theme.bg_urgent                                 = theme.dark_bg
theme.border_width                              = 1
theme.border_normal                             = "#000000"
theme.border_focus                              = "#000000"

-- taglist colors
theme.taglist_fg_focus                          = theme.blue
theme.taglist_bg_focus                          = theme.dark_bg

theme.titlebar_bg_normal                        = "#eee8d5"
theme.titlebar_bg_focus                         = "#eee8d5"
theme.menu_height                               = "15"
theme.menu_width                                = "150"

theme.tasklist_sticky                           = ""
theme.tasklist_ontop                            = ""
theme.tasklist_floating                         = ""
theme.tasklist_maximized_horizontal             = ""
theme.tasklist_maximized_vertical               = ""
theme.tasklist_disable_icon                     = true
theme.tasklist_bg_normal                        = theme.dark_bg
theme.tasklist_bg_focus                         = "#003d4f"
theme.tasklist_fg_normal                        = theme.inactive_fg

theme.awesome_icon                              = theme.dir .."/icons/awesome.png"
theme.menu_submenu_icon                         = theme.dir .."/icons/submenu.png"
theme.taglist_squares_sel                       = theme.dir .. "/icons/square_unsel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.widget_bg                                 = theme.dir .. "/icons/widget_bg.png"
theme.vol                                       = theme.dir .. "/icons/vol.png"
theme.vol_low                                   = theme.dir .. "/icons/vol_low.png"
theme.vol_no                                    = theme.dir .. "/icons/vol_no.png"
theme.vol_mute                                  = theme.dir .. "/icons/vol_mute.png"
theme.disk                                      = theme.dir .. "/icons/disk.svg"
theme.ac                                        = theme.dir .. "/icons/ac.png"
theme.bat_empty                                 = theme.dir .. "/icons/bat_empty.svg"
theme.bat_low                                   = theme.dir .. "/icons/bat_low.svg"
theme.bat_half                                  = theme.dir .. "/icons/bat_half.svg"
theme.bat_full                                  = theme.dir .. "/icons/bat_full.svg"
theme.bat_power                                 = theme.dir .. "/icons/bat_power.svg"
theme.play                                      = theme.dir .. "/icons/play.png"
theme.pause                                     = theme.dir .. "/icons/pause.png"
theme.memory                                    = theme.dir .. "/icons/memory.svg"
theme.cpu                                       = theme.dir .. "/icons/cpu.svg"
theme.net_wired                                 = theme.dir .. "/icons/wired.svg"
theme.netupdown                                 = theme.dir .. "/icons/netupdown.svg"
theme.net_wireless                              = theme.dir .. "/icons/net.svg"
theme.net_wireless_min                          = theme.dir .. "/icons/net_min.svg"
theme.net_wireless_mid                          = theme.dir .. "/icons/net_mid.svg"
theme.net_wireless_max                          = theme.dir .. "/icons/net_max.svg"

theme.clock                                     = theme.dir .. "/icons/clock.svg"

theme.warning                                   = theme.dir .. "/icons/warning.svg"
theme.error                                     = theme.dir .. "/icons/error.svg"

theme.layout_tile                               = theme.dir .. "/icons/tile.png"
theme.layout_tileleft                           = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom                         = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop                            = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv                              = theme.dir .. "/icons/fairv.png"
theme.layout_fairh                              = theme.dir .. "/icons/fairh.png"
theme.layout_spiral                             = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle                            = theme.dir .. "/icons/dwindle.png"
theme.layout_max                                = theme.dir .. "/icons/max.png"
theme.layout_fullscreen                         = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier                          = theme.dir .. "/icons/magnifier.png"
theme.layout_floating                           = theme.dir .. "/icons/floating.png"

theme.titlebar_close_button_focus               = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.dir .. "/icons/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active        = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active       = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active     = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active    = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"

-- lain related
theme.useless_gap_width                         = 10
theme.layout_centerfair                         = theme.dir .. "/icons/centerfair.png"
theme.layout_termfair                           = theme.dir .. "/icons/termfair.png"
theme.layout_centerwork                         = theme.dir .. "/icons/centerwork.png"
theme.layout_uselessfair                        = theme.dir .. "/icons/fairv.png"
theme.layout_uselessfairh                       = theme.dir .. "/icons/fairh.png"
theme.layout_uselessdwindle                     = theme.dir .. "/icons/dwindle.png"
theme.layout_uselesstile                        = theme.dir .. "/icons/tile.png"
theme.layout_uselesstiletop                     = theme.dir .. "/icons/tiletop.png"
theme.layout_uselesstileleft                    = theme.dir .. "/icons/tileleft.png"
theme.layout_uselesstilebottom                  = theme.dir .. "/icons/tilebottom.png"
theme.layout_uselesspiral                       = theme.dir .. "/icons/spiral.png"

return theme
