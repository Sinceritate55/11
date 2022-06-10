script_name("VK Notifications")
script_authors("Aniki")
script_version("1.2.3")
script_version_number(6)

--deps
local effil = require 'effil'
local encoding = require 'encoding'
local imgui = require 'imgui'
local inicfg = require 'inicfg'
local sampev = require 'lib.samp.events'
encoding.default = 'CP1251'
u8 = encoding.UTF8





function update()
    local raw = 'https://raw.githubusercontent.com/Sinceritate55/11/main/update.json'
    local dlstatus = require('moonloader').download_status
    local requests = require('requests')
    local f = {}
    function f:getLastVersion()
        local response = requests.get(raw)
        if response.status_code == 200 then
            return decodeJson(response.text)['last']
        else
            return 'UNKNOWN'
        end
    end
    function f:download()
        local response = requests.get(raw)
        if response.status_code == 200 then
            downloadUrlToFile(decodeJson(response.text)['url'], thisScript().path, function (id, status, p1, p2)
                print('Скачиваю '..decodeJson(response.text)['url']..' в '..thisScript().path)
                if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                    sampAddChatMessage('Скрипт обновлен, перезагрузка...', -1)
                    thisScript():reload()
                end
            end)
        else
            sampAddChatMessage('Ошибка, невозможно установить обновление, код: '..response.status_code, -1)
        end
    end
    return f
end










local ID_check = (0)
local Name_check = (0)
local nickis = 0


-- imgui style
local global_scale = imgui.ImFloat(1.2)
local resx, resy = getScreenResolution()
local perem = 0
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
	colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
	colors[clr.WindowBg]               = ImVec4(0.00, 0.00, 0.03, 0.85)
	colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
	colors[clr.PopupBg]                = ImVec4(0.00, 0.00, 0.03, 0.85)
	colors[clr.ComboBg]                = colors[clr.PopupBg]
	colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.FrameBg]                = ImVec4(0.16, 0.29, 0.48, 0.5)
	colors[clr.FrameBgHovered]         = ImVec4(0.26, 0.59, 0.98, 0.40)
	colors[clr.FrameBgActive]          = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.TitleBg]                = ImVec4(0.1, 0.25, 0.45, 1.00)
	colors[clr.TitleBgActive]          = ImVec4(0.2, 0.5, 0.9, 1.00)
	colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.MenuBarBg]              = ImVec4(0.1, 0.15, 0.3, 1.00)
	colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.06, 0.8)
	colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.37, 0.51, 1.00)
	colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.47, 0.61, 1.00)
	colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.57, 0.71, 1.00)
	colors[clr.CheckMark]              = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.SliderGrab]             = ImVec4(0.24, 0.52, 0.88, 1.00)
	colors[clr.SliderGrabActive]       = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.Button]                 = ImVec4(0.26, 0.59, 0.98, 0.40)
	colors[clr.ButtonHovered]          = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ButtonActive]           = ImVec4(0.06, 0.53, 0.98, 1.00)
	colors[clr.Header]                 = ImVec4(0.26, 0.59, 0.98, 0.31)
	colors[clr.HeaderHovered]          = ImVec4(0.26, 0.59, 0.98, 0.80)
	colors[clr.HeaderActive]           = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.Separator]              = colors[clr.Border]
	colors[clr.SeparatorHovered]       = ImVec4(0.26, 0.59, 0.98, 0.78)
	colors[clr.SeparatorActive]        = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ResizeGrip]             = ImVec4(0.26, 0.59, 0.98, 0.25)
	colors[clr.ResizeGripHovered]      = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.ResizeGripActive]       = ImVec4(0.26, 0.59, 0.98, 0.95)
	colors[clr.CloseButton]            = ImVec4(0.9, 0.5, 0.0, 0.8)
	colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.TextSelectedBg]         = ImVec4(0.26, 0.59, 0.98, 0.35)
	colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end
apply_custom_style()

--font obv
local loaded = false
local glyph_ranges = nil
local function load_font()
	if loaded then return end
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
	loaded = true
end

function imgui.BeforeDrawFrame()
	load_font()
end

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

function loop_async_http_request(url, args, reject)
	local runner = requestRunner()
	if not reject then reject = function() end end
	lua_thread.create(function()
		while true do
			while not key do wait(0) end
			url = server .. '?act=a_check&key=' .. key .. '&ts=' .. ts .. '&wait=25' --меняем url каждый новый запрос потокa, так как server/key/ts могут изменяться
			threadHandle(runner, url, args, longpollResolve, reject)
		end
	end)
end

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
	},
	dialogs = {
		enable = true,
		accept = '!d',
		decline = '!dc'
	},
	other = {
		pos = true,
		dc = true,
		chatcolor = false,
		debug = false,
		tocmd = '!to',
		spawn = true,
		status = '!status'
	},
	status = {
		nick = true,
		server = true,
		hp = true,
		armor = true,
		pos = true,
		online = true,
		money = true
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
local dostup = (0)
local diaEnable = imgui.ImBool(ini.dialogs.enable)
local diaAccept = imgui.ImBuffer(u8(ini.dialogs.accept), 64)
local diaDecline = imgui.ImBuffer(u8(ini.dialogs.decline), 64)


local afkkick = (0)
local timing = (0)

local otherPos = imgui.ImBool(ini.other.pos)
local otherDc = imgui.ImBool(ini.other.dc)
local otherSpawn = imgui.ImBool(ini.other.spawn)

local chatColor = imgui.ImBool(ini.other.chatcolor)
local debugMode = imgui.ImBool(ini.other.debug)

local toCmd = imgui.ImBuffer(u8(ini.other.tocmd), 64)
local status = imgui.ImBuffer(u8(ini.other.status), 64)

local statusNick = imgui.ImBool(ini.status.nick)
local statusServer = imgui.ImBool(ini.status.server)
local statusHp = imgui.ImBool(ini.status.hp)
local statusArmor = imgui.ImBool(ini.status.armor)
local statusPos = imgui.ImBool(ini.status.pos)
local statusOnline = imgui.ImBool(ini.status.online)
local statusMoney = imgui.ImBool(ini.status.money)

local curDialog, curStyle

local function closeDialog()
	sampSetDialogClientside(true)
	sampCloseCurrentDialogWithButton(1)
	sampSetDialogClientside(false)
end





function longpollResolve(result)
	if result then
		if debugMode.v then
			print(result)
		end
		if result:sub(1,1) ~= '{' then
			vkerr = 'Ошибка!\nПричина: Нет соединения с VK!'
			return
		end
		local t = decodeJson(result)
		if t.failed then
			if t.failed == 1 then
				ts = t.ts
			else
				key = nil
				longpollGetKey()
			end
			return
		end
		if t.ts then
			ts = t.ts
		end
		if recvBuf.v and t.updates then
			for k, v in ipairs(t.updates) do
				if v.type == 'message_new' then
					dostup = tonumber(v.object.message.from_id)
					if v.object.message.payload then
						local pl = decodeJson(v.object.message.payload)
						if pl.button then
							if pl.button == 'help' then
								sendHelp()
							elseif pl.button == 'status' then
								sendStatus()
							end
						end
						return
					end
					if v.object.message.text then
						local text = v.object.message.text .. ' ' --костыль на случай если одна команда является подстрокой другой (!d и !dc как пример)
						if text:match('^' .. toCmd.v .. '%s-%d+%s') then
							if accId == tonumber(text:match('^' .. toCmd.v .. '%s-(%d+)%s')) then
								text = text:gsub(text:match('^' .. toCmd.v .. '%s-%d+%s*'), '')
							else
								return
							end
						end
						if text:match('^' .. status.v) then
							sendStatus()
						elseif text:match('^' .. diaAccept.v .. ' ') then
							text = text:sub(1, text:len() - 1)
							local style = sampGetCurrentDialogType()
							print('111')
							if style == 2 or style > 3 then
								sampSendDialogResponse(sampGetCurrentDialogId(), 1, tonumber(u8:decode(text:match('^' .. diaAccept.v .. ' (%d*)'))) - 1, -1)
							elseif style == 1 or style == 3 then
								sampSendDialogResponse(sampGetCurrentDialogId(), 1, -1, u8:decode(text:match('^' .. diaAccept.v .. ' (.*)')))
							else
								sampSendDialogResponse(sampGetCurrentDialogId(), 1, -1, -1)
							end
							closeDialog()
						elseif text:match('^' .. diaDecline.v .. ' ') then
							print('111')
							sampSendDialogResponse(sampGetCurrentDialogId(), 0, -1, -1)
							closeDialog()
						else
							text = text:sub(1, text:len() - 1)
							print(text)
							if (text:match('/checkoff (.*)') or text:match('/orgmembers') or text:match('/pubgtop') ) then
								sampProcessChatInput(u8:decode(text))
								timing = (1)
							end
							if text:match('/afkkick') then
								timing = (1)
								sampProcessChatInput(u8:decode(text))
								wait(500)
								print(afkkick)
								vk_request(afkkick)
								timing = (1)
							end
							if text:match('/id (.*)') then
							timing = (1)
							sampProcessChatInput(u8:decode(text))
							wait(500)
							vk_request(nickis)
							end
						end
					end
				end
			end
		end
	end
end


function longpollGetKey()
	async_http_request('https://api.vk.com/method/groups.getLongPollServer?group_id=' .. ini.main.group .. '&access_token=' .. ini.main.token .. '&v=5.131', '', function (result)
		if result then 
			if debugMode.v then
				print(result)
			end
			if not result:sub(1,1) == '{' then
				vkerr = 'Ошибка!\nПричина: Нет соединения с VK!'
				return
			end
			local t = decodeJson(result)
			if t.error then
				vkerr = 'Ошибка!\nКод: ' .. t.error.error_code .. ' Причина: ' .. t.error.error_msg
				return
			end
			server = t.response.server
			ts = t.response.ts
			key = t.response.key
			vkerr = nil
		end
	end)
end

math.randomseed(os.time())


function vk_request(msg)
	msg = msg:gsub('{......}', '')
	msg = msg
	msg = u8(msg)
	msg = url_encode(msg)
	print(dostup)
	if sendBuf.v and ini.main.id ~= '' then
		local rnd = math.random(-2147483648, 2147483647)
		async_http_request('https://api.vk.com/method/messages.send', 'peer_id=' .. dostup .. '&random_id=' .. rnd .. '&message=' .. msg .. '&access_token=' .. ini.main.token .. '&v=5.131',
		function (result)
			if debugMode.v then
				print(result)
			end
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
	accId = getId()
	sampRegisterChatCommand('vk', vk)
	longpollGetKey()
	while not key do wait(1) end
	loop_async_http_request(server .. '?act=a_check&key=' .. key .. '&ts=' .. ts .. '&wait=25', '')
	wait(-1)
end

function getMyName()
	local ok, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if ok then
		return sampGetPlayerNickname(id)
	else
		return 'Unknown'
	end
end

function getId()
	local ip, port = sampGetCurrentServerAddress()
	local nick = getMyName()
	for k, v in ipairs(accs) do
		if v.nick == nick and v.ip == ip and v.port == port then
			return k
		end
	end
	accs[#accs + 1] = {}
	accs[#accs].nick = nick
	accs[#accs].ip = ip
	accs[#accs].port = port
	inicfg.save(accs, 'vkaccs.ini')
	return #accs
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

function saveJson()
	local text = encodeJson(filters)
	local f = io.open('moonloader/config/vkfilters.json', 'w')
	f:write(text)
	f:close()
end

if not doesFileExist('moonloader/config/vkfilters.json') then
	saveJson()
else
	local f = io.open('moonloader/config/vkfilters.json', 'r')
	local text = f:read('*a')
	filters = decodeJson(text)
	f:close()
	initializeInputs()
end



function imgui.OnDrawFrame()
	if vkw then
		imgui.SetNextWindowPos(imgui.ImVec2(resx/2, resy/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) 
		imgui.SetNextWindowSize(imgui.ImVec2(500*global_scale.v, 300*global_scale.v))
		imgui.Begin(u8"VK Notifications by Aniki", nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.MenuBar)
		imgui.BeginMenuBar()
		if imgui.MenuItem(u8'Настройки') then
			winState = 1 
		end
		if imgui.MenuItem(u8'Фильтры (Чат)') then
			winState = 2 
		end
		if imgui.MenuItem(u8'События') then
			winState = 3 
		end
		if imgui.MenuItem(u8'Статус') then
			winState = 4 
		end
		if imgui.MenuItem(u8'Прочее') then
			winState = 5 
		end
		if imgui.MenuItem(u8'О скрипте') then
			winState = 6 
		end
		imgui.EndMenuBar()
		if winState == 1 then
			mainWindow()
		end
		if winState == 2 then
			filtersWindow()
		end
		if winState == 3 then
			eventsWindow()
		end
		if winState == 4 then
			statusWindow()
		end
		if winState == 5 then
			accWindow()
		end
		if winState == 6 then
			aboutWindow()
		end
		imgui.End()
	end
end

function mainWindow()
	if vkerr then
		imgui.Text(u8'Состояние приёма: ' .. u8(vkerr))
		if imgui.Button('Reconnect', imgui.ImVec2(100*global_scale.v, 20*global_scale.v)) then
			longpollGetKey()
		end
	else
		imgui.Text(u8'Состояние приёма: Активно!')
	end
	imgui.Checkbox(u8'Отправлять сообщения из VK в чат', recvBuf)
	if vkerrsend then
		imgui.Text(u8'Состояние отправки: ' .. u8(vkerrsend))
	else
		imgui.Text(u8'Состояние отправки: Активно!')
	end
	imgui.Checkbox(u8'Отправлять уведомления в VK', sendBuf)
	if sendBuf.v and imgui.Button(u8'Тестовое сообщение', imgui.ImVec2(150*global_scale.v, 20*global_scale.v)) then
		vk_request('Test')
	end
	imgui.PushItemWidth(200)
	imgui.InputText('User ID', idBuf)
	imgui.Hint('Обязательно число, можно посмотреть в настройках аккаунта VK при изменении ссылки на страницу')
	imgui.InputText('Group ID', groupBuf)
	imgui.Hint('Обязательно число, можно посмотреть в управлении сообществом - ссылка на страницу')
	imgui.InputText('Group token', tokenBuf, imgui.InputTextFlags.Password)
	imgui.Hint('Управление сообществом - Работа с API - Ключи доступа.\nНеобходимые права доступа: управление сообществом, сообщения сообщества')
	imgui.Combo(u8'Текущий профиль', profileBuf, makeStringForCombo(filters))
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

function filtersWindow()
	if imgui.Button(u8'Новый профиль', imgui.ImVec2(150*global_scale.v, 20*global_scale.v)) then
		table.insert(filters, {})
		local profile = filters[#filters]
		profile.name = 'Новый профиль'
		profile.filters = {}
		initializeInputs()
	end
	imgui.SameLine()
	if imgui.Button(u8'Сохранить все', imgui.ImVec2(150*global_scale.v, 20*global_scale.v)) then
		for key, val in ipairs(filters) do
			val.name = u8:decode(inputsTable[key].name.v)
			for k, v in ipairs(val.filters) do
				v.name = u8:decode(inputsTable[key][k].name.v)
				v.color = u8:decode(inputsTable[key][k].color.v)
				v.pattern = u8:decode(inputsTable[key][k].pattern.v)
				v.state = inputsTable[key][k].state.v
			end
		end
		saveJson()
		printStringNow('SAVED', 2000)
	end
	imgui.SameLine()
	if imgui.Button(u8'Восстановить', imgui.ImVec2(150*global_scale.v, 20*global_scale.v)) then
		local f = io.open('moonloader/config/vkfilters.json', 'r')
		local text = f:read('*a')
		filters = decodeJson(text)
		f:close()
		initializeInputs()
	end
	for k, v in ipairs(inputsTable) do
		if imgui.CollapsingHeader(u8(k .. '. ' .. filters[k].name .. '##' .. k)) then
			imgui.InputText(u8'Название профиля##' .. k, v.name)
			if imgui.Button(u8'Новый фильтр##' .. k, imgui.ImVec2(150*global_scale.v, 20*global_scale.v)) then
				local profile = filters[k]
				table.insert(profile.filters, {})
				local filter = profile.filters[#profile.filters]
				filter.name = 'Новый фильтр'
				filter.color = ''
				filter.pattern = ''
				filter.state = 0
				initializeInputs()
			end
			imgui.SameLine()
			if imgui.Button(u8'Удалить профиль##' .. k, imgui.ImVec2(150*global_scale.v, 20*global_scale.v)) then
				table.remove(filters, k)
				initializeInputs()
				break
			else
				imgui.Indent(20*global_scale.v)
				for key, val in ipairs(v) do
					if imgui.CollapsingHeader(u8(key .. '. ' .. filters[k].filters[key].name .. '##' .. k .. key)) then
						imgui.InputText(u8'Название фильтра##' .. k .. key, val.name)
						imgui.InputText(u8'Цвет строки##' .. k .. key, val.color)
						imgui.InputText(u8'Паттерн строки##' .. k .. key, val.pattern)
						imgui.Combo(u8'Режим работы##' .. k .. key, val.state, stateCombo)
						if imgui.Button(u8'Удалить фильтр##' .. k .. key, imgui.ImVec2(150*global_scale.v, 20*global_scale.v)) then
							table.remove(filters[k].filters, key)
							initializeInputs()
							break
						end
					end
				end
				imgui.Unindent(20*global_scale.v)
			end
		end
	end
end


function eventsWindow()
	imgui.PushItemWidth(150*global_scale.v)
	imgui.Checkbox(u8'Отправлять уведомления о диалогах', diaEnable)
	imgui.InputText(u8'Команда ответа на диалог (enter)', diaAccept)
	imgui.Hint('В зависимости от стиля диалога может использоваться по-разному\n' .. diaAccept.v .. ' [номер строки] в случае с диалогом с выбором строки (list)\n' .. diaAccept.v .. ' [ввод] в случае диалога со вводом строки (input)')
	imgui.InputText(u8'Команда отклонения диалога (esc)', diaDecline)
	imgui.PopItemWidth()
	imgui.Checkbox(u8'Отправлять уведомления об изменении позиции сервером', otherPos)
	imgui.Checkbox(u8'Отправлять уведомления о потере соединения/кике', otherDc)
	imgui.Checkbox(u8'Отправлять уведомления при спавне персонажа', otherSpawn)
	imgui.Hint('Отправляется также при смерти')
	imgui.SetCursorPosX(175*global_scale.v)
	if imgui.Button('Save', imgui.ImVec2(150*global_scale.v, 20*global_scale.v)) then
		ini.dialogs.enable = diaEnable.v
		ini.dialogs.accept = u8:decode(diaAccept.v)
		ini.dialogs.decline = u8:decode(diaDecline.v)
		ini.other.pos = otherPos.v
		ini.other.dc = otherDc.v
		ini.other.spawn = otherSpawn.v
		inicfg.save(ini, 'vkcnsettings.ini')
		printStringNow('SAVED!', 2000)
	end
end

function accWindow()
	imgui.Text(u8'ID данного аккаунта: ' .. accId)
	imgui.Hint('Каждому аккаунту выдается уникальный ID при заходе на сервер\nСкрипт хранит только ник и IP сервера в файле vkaccs.ini в moonloader/config\nДля сброса ID можно просто удалить этот файл')
	imgui.PushItemWidth(130*global_scale.v)
	imgui.InputText(u8'Команда для обращения к определенному аккаунту', toCmd)
	imgui.Hint('Использование: ' .. toCmd.v .. ' [id аккаунта] [текст/команда для аккаунта].\nБез данной команды сообщение отправится на все активные аккаунты')
	imgui.PopItemWidth()
	imgui.Checkbox(u8'Добавлять в конце строки чата ее цвет в числовом формате', chatColor)
	imgui.Hint('Полученные числа можно использовать в фильтрах')
	imgui.Checkbox(u8'Активировать режим дебага', debugMode)
	imgui.Hint('Будет добавлять результаты запросов в лог moonloader, использовать в случае проблем с получением/отправкой сообщений')
	imgui.SetCursorPosX(175*global_scale.v)
	if imgui.Button('Save', imgui.ImVec2(150*global_scale.v, 20*global_scale.v)) then
		ini.other.chatcolor = chatColor.v
		ini.other.debug = debugMode.v
		ini.other.tocmd = u8:decode(toCmd.v)
		ini.other.status = u8:decode(status.v)
		inicfg.save(ini, 'vkcnsettings.ini')
		printStringNow('SAVED!', 2000)
	end
end

function statusWindow()
	imgui.PushItemWidth(130*global_scale.v)
	imgui.InputText(u8'Команда запроса статуса аккаунта', status)
	imgui.PopItemWidth()
	imgui.Text(u8'Выберите пункты для отображения в статусе:')
	imgui.Checkbox(u8'Ник', statusNick)
	imgui.Checkbox(u8'Название сервера', statusServer)
	imgui.Checkbox(u8'Онлайн на сервере', statusOnline)
	imgui.Checkbox(u8'HP', statusHp)
	imgui.Checkbox(u8'Armor', statusArmor)
	imgui.Checkbox(u8'Деньги на руках', statusMoney)
	imgui.Checkbox(u8'Позиция', statusPos)
	imgui.SetCursorPosX(175*global_scale.v)
	if imgui.Button('Save', imgui.ImVec2(150*global_scale.v, 20*global_scale.v)) then
		ini.other.status = u8:decode(status.v)
		ini.status.nick = statusNick.v
		ini.status.server = statusServer.v
		ini.status.online = statusOnline.v
		ini.status.armor = statusArmor.v
		ini.status.hp = statusHp.v
		ini.status.pos = statusPos.v
		ini.status.money = statusMoney.v
		inicfg.save(ini, 'vkcnsettings.ini')
		printStringNow('SAVED!', 2000)
	end
end

function aboutWindow()
	imgui.Text(u8'Автор скрипта: Aniki')
	imgui.Text(u8'Cпециально для blast.hk')
	if imgui.Button(u8'Тема на BlastHack', imgui.ImVec2(150*global_scale.v, 20*global_scale.v)) then
		os.execute('explorer https://blast.hk/threads/33250/')
	end
end

--SAMPEV

function sampev.onServerMessage(col, msg)
	for k, v in ipairs(filters) do
		for key, val in ipairs(v.filters) do
			if (val.color == '' or col == tonumber(val.color)) and (val.pattern == '' or msg:match(val.pattern)) then
				if val.state > 0 then
					if val.state == 1 then
						vk_request(msg)
					end
					break
				end
			end
		end
	end
	if chatColor.v then
		return {col, msg .. ' COL: ' .. col}
	end
	if (msg:find("%[Ошибка%] {FFFFFF}Игрок '(.+)' не в сети!") or msg:find("%[(%d+)%] (.+) %| Уровень: (.+) %| UID: (.+) %|%s*[АФК: %d+ сек %|]* packetloss: (%d+.%d+) %((.+)%)") or msg:find("%[Ошибка%] {FFFFFF}Игрок '(.+)' не найден!")) then
		if msg:find("%[Ошибка%] {FFFFFF}Игрок '(.+)' не в сети!") then
			ID_check = msg:match("%[Ошибка%] {FFFFFF}Игрок 'ID: (%d+)' не в сети!")
			nickis = ('Ошибка! Игрок не найден')
		elseif msg:find("%[(%d+)%] (.+) %| Уровень: (%d+) %| UID: (.+) %|%s*[АФК: %d+ сек %|]* packetloss: (%d+.%d+) %((.+)%)") then
			ID_check, Name_check = msg:match("%[(%d+)%] (.+) %| Уровень: (%d+) %| UID: (.+) %|%s*[АФК: %d+ сек %|]* packetloss: (%d+.%d+) %((.+)%)")
			nickis = ("[".. ID_check .."] ".. Name_check .. "")
		elseif msg:find("%[Ошибка%] {FFFFFF}Игрок '(.+)' не найден!") then
			nickis = ('Ошибка! Игрок не найден')
		end 
	end
	-- if msg:find("%[A%] Clyde_Redwood[(.+)] передал (.+) доната игроку (.+)[(%d+)]") then
		-- print(msg)
    -- end
	if msg:find("Не найдено игроков в AFK") then
		afkkick = "Не найдено игроков в AFK!"
    end
	if msg:find("Вы успешно кикнули (%d+) игроков") then
		local colvo = 0
		colvo = string.match(msg,"Вы успешно кикнули (%d+) игроков")
		afkkick = ("Вы успешно кикнули ".. colvo .." игроков")
    end
end
local massiv = {}
local dlya_testa = 0
function sampev.onShowDialog(id, style, title, b1, b2, text)
	if ini.dialogs.enable then
		if style == 2 or style == 4 then
			print('ono1')
			text = text .. '\n'
			local new = ''
			local count = 1
			for line in text:gmatch('.-\n') do
				if line:find(tostring(count)) then
					new = new .. line
				else
					new = new .. '[' .. count .. '] ' .. line
				end
				count = count + 1
			end
			text = new
		end
		if id == (25220)then
			text = text .. '\n'
			local new = ''
			local count = 1
			for line in text:gmatch('.-\n') do
				if count ~= 5 then
					if line:find(tostring(count)) then
						new = new .. line
					else
						new = new .. '[' .. count .. '] ' .. line
					end
					dlya_testa = new:match('(%a+)')
					print(new)
					count = count + 1
				end
			end
			text = new
		end
		if style == 5 then
			print('ono')
			text = text .. '\n'
			local new = ''
			local count = 1
			for line in text:gmatch('.-\n') do
				if count > 1 then
					if line:find(tostring(count - 1)) then
						new = new .. line
					else
						new = new .. '[' .. count - 1 .. '] ' .. line
					end
				else
					new = new
				end
				count = count + 1
			end
			text = new
		end
		if timing == (1) then
			perem = false
		else
			perem = true
		end
		print(id)
		if id == (25221) and timing == (1) then
			sampSendDialogResponse(id, 1, _, _)
		end
		if id == (25220) and timing == (1) then
			timing = 0
			vk_request(text)
		end
		if id == (0) and timing == (1) then
			timing = 0
			vk_request(text)
		end
	end
end




--internal

function vkKeyboard() --создает конкретную клавиатуру для бота VK, как сделать для более общих случаев пока не задумывался
	local keyboard = {}
	keyboard.one_time = false
	keyboard.buttons = {}
	keyboard.buttons[1] = {}
	local row = keyboard.buttons[1]
	row[1] = {}
	row[1].action = {}
	row[1].color = 'positive'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": "status"}'
	row[1].action.label = 'Статус'
	row[2] = {}
	row[2].action = {}
	row[2].color = 'primary'
	row[2].action.type = 'text'
	row[2].action.payload = '{"button": "help"}'
	row[2].action.label = 'Помощь'
	return encodeJson(keyboard)
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













--





















function onScriptTerminate(s, quit)
	if s == thisScript() and vkw and not quit then
		lockPlayerControl(false)
		showCursor(false, false)
	end
end
