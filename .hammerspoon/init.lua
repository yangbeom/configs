function applicationWatcher(appName, event, application)
    if application:bundleID() == "com.github.wez.wezterm" then -- WezTerm 일경우 esc 누를 때 영문으로 변경
        if event == hs.application.watcher.activated then
            --창이 활성화 일때 esc 누르면 change_input_english 수행
            hs.hotkey.bind({}, "escape", change_input_english)
        end
        if event == hs.application.watcher.deactivated then
            --창이 비활성화 일때 기본 esc로 변경
            hs.hotkey.disableAll({}, "escape")
        end
    end
end
local appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()

function change_input_english ()
    local input_english = "com.apple.keylayout.ABC"
    if (hs.keycodes.currentSourceID() ~= input_english) then
        hs.keycodes.currentSourceID(input_english)
    end

    hs.hotkey.disableAll({}, "escape") -- esc 키 맵핑 취소
    hs.eventtap.keyStroke({}, "escape") -- esc 버튼 클릭
    hs.eventtap.keyStroke({}, "right") -- right 버튼 클릭
    hs.hotkey.bind({}, "escape", change_input_english) -- esc 재설정
end

