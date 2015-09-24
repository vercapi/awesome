--[[
                               
     Copland Awesome WM config 
     github.com/copycat-killer 
                               
--]] 

-- {{{ Required libraries
local gears     = require("gears")
local awful     = require("awful")
awful.rules     = require("awful.rules")
require("awful.autofocus")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local drop      = require("scratchdrop")
local lain      = require("lain")
local eminent   = require("eminent")
local vicious   = require("vicious")
local ice       = require("ice")
local dbus      = require("lua-dbus")
local separator  = require("ice.widgets.separator")
local util      = require("ice.util")

-- }}}

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

do
    local in_error = false
    awesome.connect_signal("debug::error",
                           function (err)
                              if in_error then return end
                              in_error = true
                              
                              naughty.notify({ preset = naughty.config.presets.critical,
                                               title = "Oops, an error happened!",
                                               text = err })
                              in_error = false
                           end
                           )
end
-- }}}

-- {{{ Autostart applications
function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
     findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

run_once("compton --config ~/.config/compton.cfg")
-- }}}

-- {{{ Variable definitions
-- localization
os.setlocale(os.getenv("LANG"))

-- beautiful init
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/nitro/theme.lua")

-- common
modkey     = "Mod4"
altkey     = "Mod1"
terminal   = "xterm"
editor     = "emacs"
editor_cmd = editor

-- user defined
browser    = "chromium"
gui_editor = "emacs"
graphics   = "insckape"

local layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.fair,
    awful.layout.suit.tile,
    lain.layout.uselessfair.horizontal,
    lain.layout.uselesstile,
    lain.layout.uselessfair,
    lain.layout.termfair,
    lain.layout.centerfair,
    lain.layout.uselesspiral.dwindle
}
-- }}}

-- {{{ Tags
tags = {
    names = { "x01", "x02", "x03", "x04", "x05" },
    layout = { layouts[1], layouts[2], layouts[3], layouts[4], layouts[5] }
}
for s = 1, screen.count() do
   tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Wibox
markup = lain.util.markup
blue   = beautiful.fg_focus

-- Separators
spr = wibox.widget.textbox(' ')
small_spr = wibox.widget.textbox('<span font="Tamsyn 4"> </span>')
bar_spr = wibox.widget.textbox('<span font="Tamsyn 3"> </span>' .. markup(beautiful.fg_focus, "|") .. '<span font="Tamsyn 3"> </span>')

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

    -- Create a taglist widget with backrounds
    tag_bg = wibox.widget.background(awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons), beautiful.dark_bg)
    mytaglist[s] = tag_bg

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 44 })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(bar_spr)
    left_layout:add(mylayoutbox[s])
    left_layout:add(wibox.widget.background(
                       separator(util.createColor(beautiful.light_bg),
                                 util.createColor(beautiful.red),
                                 util.createColor(beautiful.blue)),
                       beautiful.dark_bg))
    left_layout:add(mytaglist[s])
    -- TODO: this needs to change based on what folows (unfocused window, run box, ...)
    left_layout:add(wibox.widget.background(
                       separator(util.createColor(beautiful.dark_bg),
                                 util.createColor(beautiful.red),
                                 util.createColor(beautiful.blue)),
                       beautiful.dark_bg))
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then
       right_layout:add(separator(util.createColor(beautiful.dark_bg),
                                  util.createColor(beautiful.yellow),
                                  util.createColor(beautiful.dark_bg)))
       systray = wibox.layout.margin(wibox.widget.systray(), 0, 10)
       systray:set_top(4)
       systray:set_bottom(20)
       right_layout:add(systray)
    end
    
    -- Battery view
    bat_view = ice.view.batteryView.create('/org/freedesktop/UPower/devices/battery_BAT1')
    bat_base = ice.view.baseView.create(right_layout, bat_view, 10)
    bat_base:set_use_separator(false)
    bat_base:init()
    
    -- New Network
    net_view = ice.view.networkView.create()
    net_view:setIface("wlp6s0")
    netBase = ice.view.baseView.create(right_layout, net_view, 2)
    netBase:setBgColor("#002b36")
    netBase:setFgColor("#b58900")
    netBase:setNextColor(beautiful.bg_normal)
    netBase:setIcon(beautiful.net_wireless)
    netBase:init()

    memory_view = ice.view.memoryView.create()
    memoryBase = ice.view.baseView.create(right_layout, memory_view, 120)
    memoryBase:setBgColor(beautiful.bg_normal)
    memoryBase:setFgColor("#2aa198")
    memoryBase:setNextColor("#002b36")
    memoryBase:setIcon(beautiful.memory)
    memoryBase:init()
    
    cpu_view = ice.view.cpuView.create("#002b36", "#268bd2")
    cpuBase = ice.view.baseView.create(right_layout, cpu_view, 1)
    cpuBase:setBgColor("#002b36")
    cpuBase:setFgColor("#268bd2")
    cpuBase:setNextColor(beautiful.bg_normal)
    cpuBase:setIcon(beautiful.cpu)
    cpuBase:init()
    
    disk_view = ice.view.diskView.create()
    disk_view:setCurrentDisk("/home")
    diskBase = ice.view.baseView.create(right_layout, disk_view, 120)
    diskBase:setBgColor(beautiful.bg_normal)
    diskBase:setFgColor(beautiful.fg_normal)
    diskBase:setNextColor("#002b36")
    diskBase:setIcon(beautiful.disk)
    diskBase:init()
    
    ice.view.clockView.create(right_layout)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    -- Take a screenshot
    -- https://github.com/copycat-killer/dots/blob/master/bin/screenshot
    -- awful.key({ altkey }, "p", function() os.execute("screenshot") end),

    -- Tag browsing
    awful.key({ modkey }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey }, "Escape", awful.tag.history.restore),

    -- Non-empty tag browsing
    -- awful.key({ altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end),
    -- awful.key({ altkey }, "Right", function () lain.util.tag_view_nonempty(1) end),

    -- Default client focus
    -- awful.key({ altkey }, "k",
    --     function ()
    --         awful.client.focus.byidx( 1)
    --         if client.focus then client.focus:raise() end
    --     end),
    -- awful.key({ altkey }, "j",
    --     function ()
    --         awful.client.focus.byidx(-1)
    --         if client.focus then client.focus:raise() end
    --     end),

    -- By direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end),

    -- Show Menu
    -- awful.key({ modkey }, "w",
    --     function ()
    --         mymainmenu:show({ keygrabber = true })
    --     end),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
        mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
    end),

    -- On the fly useless gaps change
    -- awful.key({ altkey, "Control" }, "+", function () lain.util.useless_gaps_resize(1) end),
    -- awful.key({ altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end),

    -- Rename tag
    -- awful.key({ altkey, "Shift"   }, "r", function () lain.util.rename_tag(mypromptbox) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),

    -- Currently not using these, not sure what they do
    -- awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    -- awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),

    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),
    -- awful.key({ altkey, "Shift"   }, "l",      function () awful.tag.incmwfact( 0.05)     end),
    -- awful.key({ altkey, "Shift"   }, "h",      function () awful.tag.incmwfact(-0.05)     end),

    -- Currentl I use only one master window, so I don't use these
    awful.key({ modkey, "Shift"   }, "l",      function () awful.tag.incmwfact(-1)       end),
    awful.key({ modkey, "Shift"   }, "h",      function () awful.tag.incmwfact( 1)       end),

    -- Currently using only the standard layout so I don't need these
    --awful.key({ modkey, "Control" }, "l",      function () awful.tag.incncol(-1)          end),
    --awful.key({ modkey, "Control" }, "h",      function () awful.tag.incncol( 1)          end),

    awful.key({ modkey,           }, "space",  function () awful.layout.inc(layouts,  1)  end),
    awful.key({ modkey, "Shift"   }, "space",  function () awful.layout.inc(layouts, -1)  end),
    awful.key({ modkey, "Control" }, "n",      awful.client.restore),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r",      awesome.restart),
    awful.key({ modkey, "Shift"   }, "q",      awesome.quit),

    -- Dropdown terminal
    awful.key({ modkey,	          }, "z",      function () drop(terminal) end),

    -- Widgets popups
    -- awful.key({ altkey,           }, "c",      function () lain.widgets.calendar:show(7) end),
    -- awful.key({ modkey,           }, "d",      function () fshomeupd.show(7) end),
--    awful.key({ altkey,           }, "w",      function () yawn.show(7) end),

    -- ALSA volume control
    -- awful.key({ altkey }, "Up",
    --     function ()
    --         awful.util.spawn("amixer -q set " .. volume.channel .. " " .. volume.step .. "+")
    --         volume.notify()
    --     end),
    -- awful.key({ altkey }, "Down",
    --     function ()
    --         awful.util.spawn("amixer -q set " .. volume.channel .. " " .. volume.step .. "-")
    --         volume.notify()
    --     end),
    -- awful.key({ altkey }, "m",
    --     function ()
    --         awful.util.spawn("amixer -q set " .. volume.channel .. " playback toggle")
    --         volume.notify()
    --     end),
    -- awful.key({ altkey, "Control" }, "m",
    --     function ()
    --         awful.util.spawn("amixer -q set " .. volume.channel .. " playback 100%")
    --         volume.notify()
    --     end),

    -- -- MPD control
    -- awful.key({ altkey, "Control" }, "Up",
    --     function ()
    --         awful.util.spawn_with_shell("mpc toggle || ncmpcpp toggle || ncmpc toggle || pms toggle")
    --         mpdwidget.update()
    --     end),
    -- awful.key({ altkey, "Control" }, "Down",
    --     function ()
    --         awful.util.spawn_with_shell("mpc stop || ncmpcpp stop || ncmpc stop || pms stop")
    --         mpdwidget.update()
    --     end),
    -- awful.key({ altkey, "Control" }, "Left",
    --     function ()
    --         awful.util.spawn_with_shell("mpc prev || ncmpcpp prev || ncmpc prev || pms prev")
    --         mpdwidget.update()
    --     end),
    -- awful.key({ altkey, "Control" }, "Right",
    --     function ()
    --         awful.util.spawn_with_shell("mpc next || ncmpcpp next || ncmpc next || pms next")
    --         mpdwidget.update()
    --     end),

    -- Copy to clipboard
    awful.key({ modkey }, "c", function () os.execute("xsel -p -o | xsel -i -b") end),

    -- User programs
    awful.key({ modkey }, "i", function () awful.util.spawn(browser) end),
    awful.key({ modkey }, "e", function () awful.util.spawn(gui_editor) end),
    awful.key({ modkey }, "$", function () awful.util.spawn("xset dpms force off") end),
    
    -- Prompt
    awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
--    awful.key({ altkey, "Shift"   }, "m",      lain.util.magnify_client                         ),
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.toggletag(tag)
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules

function cleanTitleBar(c)
   awful.titlebar.hide(c, "top")
end

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons,
	                   size_hints_honor = false } },
    { rule = { class = "URxvt" },
          properties = { opacity = 0.99 } },

    { rule = { class = "MPlayer" },
          properties = { floating = true } },

    { rule = { class = "Dwb" },
          properties = { tag = tags[1][1] } },

    { rule = { class = "Iron" },
          properties = { tag = tags[1][1] } },

    { rule = { instance = "plugin-container" },
          properties = { tag = tags[1][1] } },

	  { rule = { class = "Gimp" },
     	    properties = { tag = tags[1][3] } },

    { rule = { class = "Gimp", role = "gimp-image-window" },
          properties = { maximized_horizontal = true,
                         maximized_vertical = true } },
    { rule = { class = "Chromium"},
      properties = {maximized = true,
                    border_width = 0,
                    callback = cleanTitleBar }},
      { rule = { class = "Emacs"},
        properties = {maximized = true,
                      border_width = 0,
                      callback = cleanTitleBar}}
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup and not c.size_hints.user_position
       and not c.size_hints.program_position then
        awful.placement.no_overlap(c)
        awful.placement.no_offscreen(c)
    end

    local titlebars_enabled = true
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c,{size=16}):set_widget(layout)
    end
    awful.rules.apply(c)
end)

-- No border for maximized clients
client.connect_signal("focus",
    function(c)
        if c.maximized_horizontal == true and c.maximized_vertical == true then
            c.border_width = 0
            c.border_color = beautiful.border_normal
        else
            c.border_width = beautiful.border_width
            c.border_color = beautiful.border_focus
        end
    end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
        local clients = awful.client.visible(s)
        local layout  = awful.layout.getname(awful.layout.get(s))

        if #clients > 0 then -- Fine grained borders and floaters control
            for _, c in pairs(clients) do -- Floaters always have borders
                if awful.client.floating.get(c) or layout == "floating" then
                    c.border_width = beautiful.border_width

                -- No borders with only one visible client
                elseif #clients == 1 or layout == "max" then
                    clients[1].border_width = 0
                    awful.client.moveresize(0, 0, 2, 2, clients[1])
                else
                    c.border_width = beautiful.border_width
                end
            end
        end
      end)
end
-- }}}
