--[[
--
-- This is a CLI script to clean desktop, clear downloads and possible do
-- other things. I am not sure yet.
--
--  As it stands, if you dont put any CLI, it clears desktop. If you put
--  "lua script.lua downloads", downlaods will be moved to trash. If you also
--  put "lua script.lua downloads desktop" it will clear downloads and clean
--  the desktop.
--
--  If you put a type in either words there will be an error message thrown and
--  nothing will be done
--
--]]--

Dest = ""

if #arg == 0 then
  -- if no command line args are specified, clean desktop
  ClearDesktop()
else
  -- if there are more than one argument specified, do all of them
  -- I want this to be able to clear downloads


end

local function GetFileNames()
  local i, t, popen = 0, {}, io.popen
  local op = "cd ~/" .. Dest
  op = op .. " && ls"
  local pfile = popen(op)
  for name in pfile:lines() do
    i = i + 1
    t[i] = name
  end
  pfile:close()
  return t
end

local function GetFileType(file)
  local index, _ = string.find(file, "%.")
  type = nil
  if index ~= nil then
    type = string.sub(file, index + 1, -1)
  end
  return type
end

function ClearDesktop()
  Dest = "Desktop"
  local files = GetFileNames()
  for _, file in ipairs(files) do
    local type = GetFileType(file)
    local op = "cd ~/Desktop && mv '" .. file

    if type == "pdf" then
    -- if its a PDF send it to the pdf folder
      op = op .. "' files/pdf"
    elseif type == "heic" then
    -- screenshots on MAC
      op = op .. "' files/sc"
    elseif type == "png" or type == "jpg" or type == "jpeg" or type == "JPG" then
    -- most image types then
      op = op .. "' files/img"
    else
    -- I want a place for filetypes that I may not know about
      op = op .. "' files/misc"
    end

    if type ~= nil then
      print(op)
      os.execute(op)
    end
  end
end

function ClearDownloads()
  Dest = "Downloads"
  local files = GetFileNames()
  for _, file in ipairs(files) do
    local op = "cd ~/Downloads && mv " .. file .. " ~/.Trash"
    os.execute(op)
  end
end
