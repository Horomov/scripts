script_name("VK Logs")
script_authors("delphi")
script_version("1")
script_version_number(4)

--deps
local effil = require 'effil'
local encoding = require 'encoding'
local imgui = require 'imgui'
local inicfg = require 'inicfg'
local lkey, key             = pcall(require, 'vkeys')
local sampev = require 'lib.samp.events'
encoding.default = 'CP1251'
u8 = encoding.UTF8

-- imgui style
local global_scale = imgui.ImFloat(1.2)
local resx, resy = getScreenResolution()

local useInvite = false
local useUnInvite = false
local useGiverank = false
local confirmSend = false

local findGiverank = false
local findInvite = false
local findUnInvite = false




function apply_custom_style()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4

	style.WindowRounding = 4.0
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.ChildWindowRounding = 2.0
	style.FrameRounding = 2.0
	style.ItemSpacing = imgui.ImVec2(8.0*global_scale.v, 4.0*global_scale.v)
	style.ScrollbarSize = 15.0*global_scale.v
	style.ScrollbarRounding = 0
	style.GrabMinSize = 8.0*global_scale.v
	style.GrabRounding = 1.0
	style.WindowPadding = imgui.ImVec2(8.0*global_scale.v, 8.0*global_scale.v)
	style.AntiAliasedLines = true
	style.AntiAliasedShapes = true
	style.FramePadding = imgui.ImVec2(4.0*global_scale.v, 3.0*global_scale.v)
	style.DisplayWindowPadding = imgui.ImVec2(22.0*global_scale.v, 22.0*global_scale.v)
	style.DisplaySafeAreaPadding = imgui.ImVec2(4.0*global_scale.v, 4.0*global_scale.v)
	colors[clr.FrameBg]                = ImVec4(0.48, 0.16, 0.16, 0.54)
	colors[clr.FrameBgHovered]         = ImVec4(0.98, 0.26, 0.26, 0.40)
	colors[clr.FrameBgActive]          = ImVec4(0.98, 0.26, 0.26, 0.67)
	colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
	colors[clr.TitleBgActive]          = ImVec4(0.48, 0.16, 0.16, 1.00)
	colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.CheckMark]              = ImVec4(0.98, 0.26, 0.26, 1.00)
	colors[clr.SliderGrab]             = ImVec4(0.88, 0.26, 0.24, 1.00)
	colors[clr.SliderGrabActive]       = ImVec4(0.98, 0.26, 0.26, 1.00)
	colors[clr.Button]                 = ImVec4(0.98, 0.26, 0.26, 0.40)
	colors[clr.ButtonHovered]          = ImVec4(0.98, 0.26, 0.26, 1.00)
	colors[clr.ButtonActive]           = ImVec4(0.98, 0.06, 0.06, 1.00)
	colors[clr.Header]                 = ImVec4(0.98, 0.26, 0.26, 0.31)
	colors[clr.HeaderHovered]          = ImVec4(0.98, 0.26, 0.26, 0.80)
	colors[clr.HeaderActive]           = ImVec4(0.98, 0.26, 0.26, 1.00)
	colors[clr.Separator]              = colors[clr.Border]
	colors[clr.SeparatorHovered]       = ImVec4(0.75, 0.10, 0.10, 0.78)
	colors[clr.SeparatorActive]        = ImVec4(0.75, 0.10, 0.10, 1.00)
	colors[clr.ResizeGrip]             = ImVec4(0.98, 0.26, 0.26, 0.25)
	colors[clr.ResizeGripHovered]      = ImVec4(0.98, 0.26, 0.26, 0.67)
	colors[clr.ResizeGripActive]       = ImVec4(0.98, 0.26, 0.26, 0.95)
	colors[clr.TextSelectedBg]         = ImVec4(0.98, 0.26, 0.26, 0.35)
	colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
	colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
	colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
	colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.ComboBg]                = colors[clr.PopupBg]
	colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
	colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
	colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
	colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
	colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
	colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
	colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end
apply_custom_style()

--font obv
local glyph_ranges = nil
local function load_font()
	local font_path = getFolderPath(0x14) .. '\\trebucbd.ttf'
	assert(doesFileExist(font_path), 'WTF: Font "' .. font_path .. '" doesn\'t exist')
	imgui.SwitchContext()
	imgui.GetIO().Fonts:Clear()
	local builder = imgui.ImFontAtlasGlyphRangesBuilder()
	builder:AddRanges(imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
	builder:AddText(u8'‚„…†‡€‰‹‘’“”•–—™›№')
	glyph_ranges = builder:BuildRanges()
	imgui.GetIO().Fonts:AddFontFromFileTTF(font_path, 14.0*1.3, nil, glyph_ranges)
	imgui.RebuildFonts()
end

load_font()

--vk longpoll api globals
local key, server, ts

function threadHandle(runner, url, args, resolve, reject) -- обработка effil потока без блокировок
	local t = runner(url, args)
	local r = t:get(0)
	while not r do
		r = t:get(0)
		wait(0)
	end
	local status = t:status()
	if status == 'completed' then
		local ok, result = r[1], r[2]
		if ok then resolve(result) else reject(result) end
	elseif err then
		reject(err)
	elseif status == 'canceled' then
		reject(status)
	end
	t:cancel(0)
end

function requestRunner() -- создание effil потока с функцией https запроса
	return effil.thread(function(u, a)
		local https = require 'ssl.https'
		local ok, result = pcall(https.request, u, a)
		if ok then
			return {true, result}
		else
			return {false, result}
		end
	end)
end

function async_http_request(url, args, resolve, reject)
	local runner = requestRunner()
	if not reject then reject = function() end end
	lua_thread.create(function()
		threadHandle(runner, url, args, resolve, reject)
	end)
end

local vkerr, vkerrsend -- сообщение с текстом ошибки, nil если все ок


if not doesDirectoryExist('moonloader/config') then
	createDirectory('moonloader/config')
end

local defaults = {
	main = {
		token = '',
		id = '',
		group = '',
		profile = 0,
		recv = true,
		send = true
	}
}

local ini = inicfg.load(defaults, 'vkcnsettings.ini')
local accs = inicfg.load({}, 'vkaccs.ini')
local accId = -1

--buffers
local tokenBuf = imgui.ImBuffer(ini.main.token, 128)
local idBuf = imgui.ImBuffer(tostring(ini.main.id), 128)
local groupBuf = imgui.ImBuffer(tostring(ini.main.group), 128)
local profileBuf = imgui.ImInt(ini.main.profile)
local recvBuf = imgui.ImBool(ini.main.recv)
local sendBuf = imgui.ImBool(ini.main.send)



local curDialog, curStyle

local function closeDialog()
	sampSetDialogClientside(true)
	sampCloseCurrentDialogWithButton(0)
	sampSetDialogClientside(false)
end




function longpollGetKey()
	async_http_request('https://api.vk.com/method/groups.getLongPollServer?group_id=' .. ini.main.group .. '&access_token=' .. ini.main.token .. '&v=5.81', '', function (result)
		if result then
			if not result:sub(1,1) == '{' then
				vkerr = 'Ошибка!\nПричина: Нет соединения с VK!'
				return
			end
			local t = decodeJson(result)
			if t.error then
				vkerr = 'Ошибка!\nКод: ' .. t.error.error_code .. ' Причина: ' .. t.error.error_msg
				print(vkerr)
				return
			end
			server = t.response.server
			ts = t.response.ts
			key = t.response.key
			vkerr = nil
		end
	end)
end

function vk_request(msg)
	local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	msg = msg:gsub('{......}', '')
	msg = '[Игрок ' .. sampGetPlayerNickname(myid) .. ']: \n' .. msg
	msg = u8(msg)
	msg = url_encode(msg)
	if sendBuf.v and ini.main.id ~= '' then
		async_http_request('https://api.vk.com/method/messages.send', '&chat_id=' .. ini.main.id .. '&message=' .. msg .. '&access_token=' .. ini.main.token .. '&v=5.81',
		function (result)
			local t = decodeJson(result)
			if not t then
				print(result)
				return
			end
			if t.error then
				vkerrsend = 'Ошибка!\nКод: ' .. t.error.error_code .. ' Причина: ' .. t.error.error_msg
				return
			end
			vkerrsend = nil
		end)
	end
end

local vkw

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	_, myID = sampGetPlayerIdByCharHandle(PLAYER_PED) 
	userNick = sampGetPlayerNickname(myID)
	sampRegisterChatCommand('vk', vk)
	sampAddChatMessage("[vklogs]:{FFFFFF} Скрипт успешно загружен. ", 0xffa500)

	longpollGetKey()
	while not key do wait(1) end

	if key.VK_ESCAPE then
		if vkw then 
		imgui.ShowCursor = false
		imgui.Process = false
		imgui.LockPlayer = false 
		vkw = false
		end
	end

	while true do
		wait(0)
		if isKeyJustPressed(VK_Y) then
			sampAddChatMessage('2', -1)
		end
		
		if isKeyJustPressed(VK_L) then sampSendChat('/lock') end
		wait(2000)
		if useInvite and not findInvite then
			sampAddChatMessage('clear',-1)
			useInvite = false
		end
		if useUnInvite and not findUnInvite then
			sampAddChatMessage('clear',-1)
			useUnInvite = false
		end
		if useGiverank and not findGiverank then
			sampAddChatMessage('clear',-1)
			useGiverank = false
		end
	end
end

function getMyName()
	local ok, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if ok then
		return sampGetPlayerNickname(id)
	else
		return 'Unknown'
	end
end


--commands

function vk()
	vkw = not vkw
	if vkw then
		imgui.ShowCursor = true
		imgui.LockPlayer = true
		imgui.Process = true
	else
		imgui.ShowCursor = false
		imgui.Process = false
		imgui.LockPlayer = false
	end
end


--imgui shit

local winState = 1

local filters = {}

local inputsTable = {}

local stateCombo = u8'Неактивен\0Отправлять\0Игнорировать\0\0'

function initializeInputs()
	inputsTable = {}
	for key, val in ipairs(filters) do
		inputsTable[key] = {}
		inputsTable[key].name = imgui.ImBuffer(u8(val.name), 64)
		for k, v in ipairs(val.filters) do
			inputsTable[key][k] = {}
			inputsTable[key][k].name = imgui.ImBuffer(u8(v.name), 64)
			inputsTable[key][k].color = imgui.ImBuffer(u8(v.color), 64)
			inputsTable[key][k].pattern = imgui.ImBuffer(u8(v.pattern), 256)
			inputsTable[key][k].state = imgui.ImInt(v.state)
		end
	end
end




function imgui.OnDrawFrame()
	if vkw then
		imgui.SetNextWindowPos(imgui.ImVec2(resx/2, resy/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) 
		imgui.SetNextWindowSize(imgui.ImVec2(500*global_scale.v, 300*global_scale.v))
		imgui.Begin(u8"VK LOGS | LSPD 03", vkw, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
		mainWindow()
		imgui.End()
	end
end

function mainWindow()
	
	if vkerrsend then
		imgui.Text(u8'Состояние отправки: ' .. u8(vkerrsend))
	else
		imgui.Text(u8'Состояние отправки: Активно!')
	end
	imgui.Checkbox(u8'Отправлять уведомления в VK', sendBuf)
	if sendBuf.v and imgui.Button(u8'Отправить тест сообщение', imgui.ImVec2(250*global_scale.v, 20*global_scale.v)) then
		vk_request('Проверка скрипта')
	end
	imgui.PushItemWidth(200)
	imgui.InputText('Chatid ID', idBuf)
	imgui.Hint('ID Беседы. Не изменяй, если не знаешь что это')
	imgui.InputText('Group ID', groupBuf)
	imgui.Hint('Можно посмотреть в управлении сообществом. Не изменяй, если не знаешь что это')
	imgui.PopItemWidth(200)
	imgui.SetCursorPosX(75*global_scale.v)
	if imgui.Button('Save', imgui.ImVec2(50*global_scale.v, 20*global_scale.v)) then
		ini.main.id = idBuf.v
		ini.main.token = tokenBuf.v
		ini.main.group = groupBuf.v
		ini.main.recv = recvBuf.v
		ini.main.profile = profileBuf.v
		ini.main.send = sendBuf.v
		inicfg.save(ini, 'vkcnsettings.ini')
		printStringNow('SAVED!', 2000)
	end
end



--SAMPEV
function sampev.onSendCommand(command)
	if command == '/invite' then
		useInvite = true
	end
	if command == '/uninvite' then
		useUnInvite = true
	end
	if command == '/giverank' then
		useGiverank = true
		sampAddChatMessage('1')
	end
end

function sampev.onServerMessage(col, msg)
	--for k, v in ipairs(filters) do
	--	for key, val in ipairs(v.filters) do
	--		if (val.color == '' or col == tonumber(val.color)) and (val.pattern == '' or msg:match(val.pattern)) then
	--			if val.state > 0 then
	--				if val.state == 1 then
	--					vk_request(msg)
	--				end
	--				break
	--			end
	--		end
	--	end
	--end
	if useGiverank and msg:match('Вы назначили .+%s.+') then
		nick1, rank = msg:match('Вы назначили (.+)%s(.+)')	
		text = userNick..' повысил/понизил '..nick1..' до '..rank
		useGiverank = false
		--vk_request(text)
		confirmSend = true
		findGiverank = true

		sampAddChatMessage(text,-1)
	end
	if useUnInvite and msg:match('Вы выгнали .+ из организации. Причина: .+') then
		nick1, reason = msg:match('Вы выгнали (.+) из организации. Причина: (.+)')	
		text = userNick..' уволил '..nick1..'. Причина: '..reason
		useUnInvite = false
		confirmSend = true
		findUnInvite = true

		--vk_request(text)
		--sampAddChatMessage(text,-1)
	end
	if useInvite and msg:find(userNick) and msg:find('полицейский жетон .+') then
		nick1, nick2 = msg:match('(.+) передал полицейский жетон (.+)')
		sampAddChatMessage(nick1, -1)
		if userNick == nick1 then
			text = userNick..' принял '..nick2
			useInvite = false
			findInvite = true
			confirmSend = true

			--vk_request(text)
			--sampAddChatMessage(text,-1)
		end
		
	end
end

function imgui.Hint(text)
	imgui.SameLine()
	imgui.TextDisabled("(?)")
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.TextUnformatted(u8(text))
		imgui.EndTooltip()
	end
end

function char_to_hex(str)
  return string.format("%%%02X", string.byte(str))
end

function url_encode(str)
  local str = string.gsub(str, "\\", "\\")
  local str = string.gsub(str, "([^%w])", char_to_hex)
  return str
end

function makeStringForCombo(arr)
	local str = ''
	for k, v in ipairs(arr) do
		str = str .. v.name .. '\0'
	end
	return u8(str .. '\0')
end

function onScriptTerminate(s, quit)
	if s == thisScript() and vkw then
		lockPlayerControl(false)
		showCursor(false, false)
	end
end