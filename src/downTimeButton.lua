--[[ temporizador
	Dispositivo virtual
	downTimeButton.lua
	por Manuel Pascual
------------------------------------------------------------------------------]]

--[[----- CONFIGURACION DE USUARIO -------------------------------------------]]
interval = 5 -- min.
maxTime = 1 -- h.
--[[----- FIN CONFIGURACION DE USUARIO ---------------------------------------]]

--[[----- NO CAMBIAR EL CODIGO A PARTIR DE AQUI ------------------------------]]

--[[----- CONFIGURACION AVANZADA ---------------------------------------------]]
local _selfId = fibaro:getSelfId()  -- ID de este dispositivo virtual
--[[----- FIN CONFIGURACION AVANZADA -----------------------------------------]]

-- recuperar el tiempo desde la etiqueta
local label = fibaro:get(_selfId,"ui.timeLabel.value")
local staleTimeoOut
if label and label ~= '' then
	local hour = tonumber(string.sub(label, 1, 2))
	local minute = tonumber(string.sub(label, 4, 5))
	local second = tonumber(string.sub(label, 7, 8))
	staleTimeoOut = (hour * 60 * 60) + (minute * 60)
else
	staleTimeoOut = 0
end

--[[ disminuir el tiempo
if staleTimeoOut >= interval * 60 then
  -- disminuir intervalo
  staleTimeoOut = staleTimeoOut - interval * 60
else
  -- situar el tiempo máximo
  staleTimeoOut = maxTime * 60 * 60
end
--]]

--[[ aumentar el tiempo --]]
if staleTimeoOut  < maxTime * 60 * 60 then
  -- aumentar el tiempo
  staleTimeoOut = staleTimeoOut + interval * 60
else
  -- situar el tiempo mínimo
  staleTimeoOut = 0
end

-- formatear el tiempo
local formatTime = os.date("*t", os.time())
formatTime.hour = 0; formatTime.sec = 0; formatTime.min = 0
formatTime = os.time(formatTime)
formatTime = formatTime + staleTimeoOut
formatTime = os.date('%H:%M:%S', formatTime)
-- actualizar etiqueta de propiedades
fibaro:call(_selfId, "setProperty", "ui.timeLabel.value", formatTime)
