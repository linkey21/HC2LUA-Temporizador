--[[ temporizador
	Dispositivo virtual
	mainLoop.lua
	por Manuel Pascual
------------------------------------------------------------------------------]]

--[[----- CONFIGURACION DE USUARIO -------------------------------------------]]
local iconON = 28
local iconOFF = 27
--[[----- FIN CONFIGURACION DE USUARIO ---------------------------------------]]

--[[----- NO CAMBIAR EL CODIGO A PARTIR DE AQUI ------------------------------]]

--[[----- CONFIGURACION AVANZADA ---------------------------------------------]]
local _selfId = fibaro:getSelfId()  -- ID de este dispositivo virtual
--[[----- FIN CONFIGURACION AVANZADA -----------------------------------------]]

--[[function getStaleTimeoOut()

recuperar el tiempo desde la etiqueta
--]]
function getStaleTimeoOut()
	local label = fibaro:get(_selfId,"ui.timeLabel.value")
	local staleTimeoOut
	if label and label ~= '' then
		local hour = tonumber(string.sub(label, 1, 2))
		local minute = tonumber(string.sub(label, 4, 5))
		local second = tonumber(string.sub(label, 7, 8))
		return (hour * 60 * 60) + (minute * 60) + second
	end
	return 0
end

--[[function gerStatus()
]]
function getStatus()
	-- recuperar el estado actual
	return fibaro:get(_selfId,"ui.statusLabel.value")
end

--[[function setStaleTimeoOut()]]
function setStaleTimeoOut(staleTimeoOut)
	if staleTimeoOut < 0 then staleTimeoOut = 0 end
	fibaro:debug('temporizador OK '..staleTimeoOut)
	-- formatear el tiempo
	local formatTime = os.date("*t", os.time())
	formatTime.hour = 0; formatTime.sec = 0; formatTime.min = 0
	formatTime = os.time(formatTime)
	formatTime = formatTime + staleTimeoOut
	formatTime = os.date('%H:%M:%S', formatTime)
	-- actualizar etiqueta de propiedades
	fibaro:call(_selfId, "setProperty", "ui.timeLabel.value", formatTime)
	fibaro:log(formatTime)
	return true
end

-- bucle principal
while true do
	-- actualizar icono
	fibaro:call(_selfId, 'setProperty', "currentIcon", iconOFF)
	-- mientras el estado actual sea running
	while getStatus() == 'running' do
		-- actualizar icono
	  fibaro:call(_selfId, 'setProperty', "currentIcon", iconON)
		-- obtener el tiempo restante
		local staleTimeoOut = os.time() + getStaleTimeoOut()
		-- si se ha agotado el tiempo
		if staleTimeoOut <= os.time() then
			-- se termina el bucle actualizando el estado
			fibaro:call(_selfId, "setProperty", "ui.statusLabel.value", 'stopped')
			-- obtener id del dispositivo
			local label = fibaro:get(_selfId,"ui.deviceLabel.value")
			local p2 = string.find(label, '-')
			-- apagar el dispositivo
			fibaro:call(tonumber(string.sub(label, 1, p2 - 1)), 'turnOff')
			-- actualizar icono
			fibaro:call(_selfId, 'setProperty', "currentIcon", iconOFF)
		end
		fibaro:sleep(1000)
		-- actualizar etiqueta de tiempo
		 setStaleTimeoOut(staleTimeoOut - os.time())
	end
	-- watchdog
	fibaro:debug('temporizador OK')
	fibaro:sleep(1000)
end
