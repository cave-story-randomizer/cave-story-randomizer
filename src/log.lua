local LOG_LEVEL, _logCounts, _logLines = 4, nil, nil
local function _log(level, prefix, text, ...)
  if LOG_LEVEL >= level then
    local text = prefix .. text
    print(text, ...)
    table.insert(_logLines, text)
  end
  _logCounts[level] = _logCounts[level] + 1
end
function logError(...)   _log(1, 'ERROR: ',   ...) end
function logWarning(...) _log(2, 'WARNING: ', ...) end
function logNotice(...)  _log(3, 'NOTICE: ',  ...) end
function logSpoiler(...) _log(4, 'SPOILER: ', ...) end
function logInfo(...)    _log(5, 'INFO: ',    ...) end
function logDebug(...)   _log(6, 'DEBUG: ',   ...) end
function countLogWarningsAndErrors()
  return _logCounts[2], _logCounts[1]
end
function getLogText()
  return table.concat(_logLines, "\r\n")
end
function resetLog()
  _logCounts = {0, 0, 0, 0, 0, 0}
  _logLines = {}
end
resetLog()