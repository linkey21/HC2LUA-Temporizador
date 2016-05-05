--[[ temporizador
	Dispositivo virtual
	selectButton.lua
	por Manuel Pascual
------------------------------------------------------------------------------]]

--[[----- CONFIGURACION DE USUARIO -------------------------------------------]]
--[[----- FIN CONFIGURACION DE USUARIO ---------------------------------------]]

--[[----- NO CAMBIAR EL CODIGO A PARTIR DE AQUI ------------------------------]]

--[[----- CONFIGURACION AVANZADA ---------------------------------------------]]
local _selfId = fibaro:getSelfId()  -- ID de este dispositivo virtual
--[[----- FIN CONFIGURACION AVANZADA -----------------------------------------]]

-- obtener conexión con el controlador
if not HC2 then
  HC2 = Net.FHttp("127.0.0.1", 11111)
end

-- obtener sensores interruptores
response ,status, errorCode = HC2:GET("/api/devices?roomID="..
 fibaro:getRoomID(_selfId))
local devices = json.decode(response)
local binarySwitches = {}
for key, value in pairs(devices) do
  for actionsKey, actionsValue in pairs(value['actions']) do
    if actionsKey == 'turnOn' then
      local binarySwitch = {id = value.id, name = value.name}
      table.insert(binarySwitches, binarySwitch)
      break
    end
  end
end

-- averiguar dispositivo seleccioando actualmete
local selectedId = 1
local label = fibaro:get(_selfId,"ui.deviceLabel.value")
for key, value in pairs(binarySwitches) do
  if value.id..'-'..value.name == label then selectedId = key end
end
-- seleccionar el siguiente dispositivo
if selectedId < #binarySwitches then
  selectedId = selectedId + 1
elseif #binarySwitches == 0 then
  selectedId = 0
else
  selectedId = 1
end

-- anotar las etiquetas
if selectedId ~= 0 then
  fibaro:call(_selfId,"setProperty","ui.deviceLabel.value",
  binarySwitches[selectedId].id..'-'..binarySwitches[selectedId].name)
else
  fibaro:call(_selfId,"setProperty","ui.deviceLabel.value", '-')
end
