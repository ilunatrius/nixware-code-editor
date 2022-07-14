VariablesConverter = {}

function split(str, separator)
  local result = {}
  local regex = "([^"..separator.."]+)"

  for splitted in string.gmatch(str, regex) do
    table.insert(result, splitted)
  end
  
  return result
end

function stringify_table(value)
  local result = "["

  for i = 1, #value do
    result = result..tostring(value[i])..","
  end

  result = string.sub(result, 0, -2) -- remove last comma
  result = result.."]"

  return result
end

function convert_variable_to_string(name, value)
  if type(value) == "table" then
    local stringified_table = stringify_table(value)
    local result = name.."="..stringified_table

    return result
  end

  local result = name.."="..tostring(value)

  return result
end

function VariablesConverter:to_string(variables)
  local result = ""

  for name, value in pairs(variables) do
    local converted_variable = convert_variable_to_string(name, value)
    result = result..converted_variable..";\n"
  end

  return result
end

function parse_table(stringified_value)
  local result = {}
  local trimmed_values = string.sub(stringified_value, 2, -2) -- remove square brackets
  local values = split(trimmed_values, ",")

  for i = 1, #values do
    local parsed_value = parse_value(values[i])
    table.insert(result, parsed_value)
  end

  return result
end

function parse_value(stringified_value)
  if string.find(stringified_value, "%[") then
    return parse_table(stringified_value)
  end

  if stringified_value == "true" then return true end
  if stringified_value == "false" then return false end
  if pcall(tonumber, stringified_value) then return tonumber(stringified_value) end

  return stringified_value
end

function convert_string_to_variable(variable_string)
  -- config variable example: variable=false
  local trimmed_variable_string = string.gsub(variable_string, "%s+", "")
  local equal_index = string.find(trimmed_variable_string, "=")
  local name = string.sub(trimmed_variable_string, 0, equal_index-1)
  local stringified_value = string.sub(trimmed_variable_string, equal_index+1)
  local value = parse_value(stringified_value)

  return name, value
end

function VariablesConverter:from_string(variables_string)
  local result = {}
  local solid_variables_string = string.gsub(variables_string, "\n", "")
  local variables = split(solid_variables_string, ";")

  for i = 1, #variables do
    local name, value = convert_string_to_variable(variables[i])
    result[name] = value
  end

  return result
end

return VariablesConverter