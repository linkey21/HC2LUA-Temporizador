--[[ temporizador
	Dispositivo virtual
	startStopButton.lua
	por Manuel Pascual
------------------------------------------------------------------------------]]

--[[----- CONFIGURACION DE USUARIO -------------------------------------------]]
--[[----- FIN CONFIGURACION DE USUARIO ---------------------------------------]]

--[[----- NO CAMBIAR EL CODIGO A PARTIR DE AQUI ------------------------------]]

--[[----- CONFIGURACION AVANZADA ---------------------------------------------]]
local _selfId = fibaro:getSelfId()  -- ID de este dispositivo virtual
--[[----- FIN CONFIGURACION AVANZADA -----------------------------------------]]

-- recuperar el estado actual
local label = fibaro:get(_selfId,"ui.statusLabel.value")
-- obtener id del dispositivo
local idLabel = fibaro:get(_selfId,"ui.deviceLabel.value")
local p2 = string.find(idLabel, '-')
local id = tonumber(string.sub(idLabel, 1, p2 - 1))
-- cambiar el estado
if label == 'running' then
	label = 'stopped'
	-- apagar el dispositivo
	fibaro:call(id, 'turnOff')
else
	label = 'running'
	-- encender el dispositivo
	fibaro:call(id, 'turnOn')
end

-- actualizar etiqueta de propiedades
fibaro:call(_selfId, "setProperty", "ui.statusLabel.value", label)
