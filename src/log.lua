local LOG_LEVEL, _logCounts, _logLines = 6, nil, nil
local function _log(level, prefix, text, ...)
  if LOG_LEVEL >= level then
    local text = prefix .. text
    if level ~= 4 then
      print(text, ...)
    end
    table.insert(_logLines, text)
  end
  _logCounts[level] = _logCounts[level] + 1
end
function logError(...)   _log(1, 'ERROR: ',   ...) end
function logWarning(...) _log(2, 'WARNING: ', ...) end
function logNotice(...)  _log(3, 'NOTICE: ',  ...) end
function logSpoiler(...) _log(4, 'SPOILER: ', ...) end
function logSphere(...)  _log(5, 'SPHERE: ',  ...) end
function logRoute(...)   _log(6, 'ROUTE: ',   ...) end
function logInfo(...)    _log(7, 'INFO: ',    ...) end
function logDebug(...)   _log(8, 'DEBUG: ',   ...) end
function countLogWarningsAndErrors()
  return _logCounts[2], _logCounts[1]
end
function getLogText()
  return table.concat(_logLines, "\r\n")
end
function resetLog()
  _logCounts = {0, 0, 0, 0, 0, 0, 0, 0}
  _logLines = {}
end
resetLog()