local speed_level = 1

-- 是否默认启用全局播放速度
local global_speed = false

-- 通过 favoriteSpeed() 切换的收藏速度
local favorite_speed = 2.5
local previous_speed = nil

function stepFwd()
    mp.command("add speed 0.25")
    speed_level = mp.get_property("speed")
    mp.osd_message(string.format("播放速度: %.2f", speed_level), 0.5)
end

function stepBack()
    mp.command("add speed -0.25")
    speed_level = mp.get_property("speed")
    mp.osd_message(string.format("播放速度: %.2f", speed_level), 0.5)
end

function speedReset()
    mp.command("set speed 1")
    speed_level = 1
    mp.osd_message("重置播放速度")
end

function on_file_loaded()
    if global_speed then
        mp.set_property("speed", speed_level)
    else
        mp.set_property("speed", 1)
    end
end

function favoriteSpeed()
    local current_speed = mp.get_property_number("speed")
    if math.abs(current_speed - favorite_speed) < 0.001 then
        local restore_speed = previous_speed or 1
        mp.command("set speed " .. restore_speed)
        speed_level = restore_speed
        mp.osd_message(string.format("播放速度: %.2f", restore_speed), 0.5)
    else
        previous_speed = current_speed
        mp.command("set speed " .. favorite_speed)
        speed_level = favorite_speed
        mp.osd_message(string.format("播放速度: %.2f (收藏)", favorite_speed), 0.5)
    end
end

function toggle_global_speed()
    global_speed = not global_speed
    if global_speed then
        mp.osd_message("全局播放速度: 开")
    else
        mp.osd_message("全局播放速度: 关")
    end
end

mp.add_forced_key_binding(".", "stepFwd", stepFwd)
mp.add_forced_key_binding(",", "stepBack", stepBack)
mp.add_forced_key_binding("/", "speedReset", speedReset)
mp.add_forced_key_binding("g", "toggle_global_speed", toggle_global_speed)
mp.add_forced_key_binding("f", "favoriteSpeed", favoriteSpeed)

mp.register_event("file-loaded", on_file_loaded)
