-- rosepine-moon — Rosé Pine for cordanui (Lua runtime).
--
-- Interaction model: browse locally, commit globally.
--   * Cycling variants in the picker previews them via cord["local"]
--     overrides (session-only, highest precedence, never persisted).
--   * Nothing touches cord.g until the commit key is pressed; that write
--     lands in the settings table and syncs to every client.
--   * Esc cancels: session overrides are reverted and the active theme
--     (or previously committed styles) show through again.

local cfg = cordanui.config or {}

local IDS    = { "rosepine", "rosepine-moon", "rosepine-dawn" }
local LABELS = { "Rosé Pine (main)", "Rosé Pine Moon", "Rosé Pine Dawn" }
local FILES  = {
  main = "rosepine",
  moon = "rosepine-moon",
  dawn = "rosepine-dawn",
}

local palettes = {}  -- id -> colors table (lazy cache)

local function normalize(variant)
  local v = tostring(variant or ""):lower()
  if FILES[v] then v = FILES[v] end
  for i, id in ipairs(IDS) do
    if id == v then return i end
  end
  return nil
end

local function load_palette(id)
  if palettes[id] then return palettes[id] end
  local path = cordanui.plugin_dir .. "/" .. id .. ".json"
  local fh = io.open(path, "r")
  if not fh then
    cordanui.log.error("rosepine: cannot open " .. path)
    return nil
  end
  local body = fh:read("*a")
  fh:close()
  local ok, data = pcall(cordanui.json.decode, body)
  if not ok or type(data) ~= "table" or type(data.colors) ~= "table" then
    cordanui.log.error("rosepine: invalid theme file " .. path)
    return nil
  end
  palettes[id] = data.colors
  return data.colors
end

-- Push a palette into a style table (e.g. cord.g.style or
-- cord["local"].style).
local function paint(style, colors)
  for role, hex in pairs(colors) do
    -- Unknown roles are skipped; unknown variables on the host degrade
    -- to onBackground per spec §11, so only set what we ship.
    local setter = style[role]
    if type(setter) == "function" then setter(hex) end
  end
end

local function preview(id)
  local colors = load_palette(id)
  if colors then paint(cord["local"].style, colors) end
end

local function commit(id)
  local colors = load_palette(id)
  if not colors then return false end
  paint(cord.g.style, colors)
  -- Preview layer now shadows the committed .g values; drop it so what
  -- you see is exactly what was persisted.
  pcall(cord["local"].style.resetAll)
  cordanui.log.info("rosepine: committed " .. id)
  return true
end

local function cancel_preview()
  pcall(cord["local"].style.resetAll)
end

-- ---------------------------------------------------------------- picker

local idx = normalize(cfg.variant) or 2

local function open_picker()
  local commit_key = tostring(cfg.commit_key or "tab"):lower()

  cord.ui.show_panel{
    title = "Rosé Pine",
    draw = function()
      return {
        { content = "Pick a variant", bold = true },
        { items = LABELS, highlight = idx },
        { children = {
            { content = commit_key .. " commit · esc cancel · j/k or ↑/↓ browse",
              fg = "onSurfaceVariant" },
        } },
      }
    end,
    on_key = function(key)
      key = tostring(key)
      if key == "down" or key == "j" then
        idx = math.min(idx + 1, #IDS)
        preview(IDS[idx])
        return true
      elseif key == "up" or key == "k" then
        idx = math.max(idx - 1, 1)
        preview(IDS[idx])
        return true
      elseif key == commit_key then
        commit(IDS[idx])
        cord.ui.close_panel()
        return true
      elseif key == "esc" then
        cancel_preview()          -- revert to pre-picker appearance
        cord.ui.close_panel()
        return true
      end
      return false                -- pass through to host
    end,
  }
end

-- ------------------------------------------------------------- lifecycle

local ok, err = pcall(function()
  if cfg.reset_overrides == "true" then
    pcall(cord.g.style.resetAll)
    cancel_preview()
    cordanui.log.info("rosepine: committed overrides cleared")
    return
  end
  -- Preview the configured variant immediately so the picker opens with
  -- the choice already visible on screen (session-only, not persisted).
  if cfg.open_picker_on_start ~= "false" then
    preview(IDS[idx])
    open_picker()
  end
end)
if not ok then
  cordanui.log.error("rosepine: activation failed: " .. tostring(err))
end

plugin = {}

---Open the variant picker panel programmatically.
function plugin.pick()
  pcall(open_picker)
end

---Preview a variant by id/alias without committing. Returns id or nil.
function plugin.preview_variant(name)
  local i = normalize(name)
  if not i then return nil end
  preview(IDS[i])
  return IDS[i]
end

---Commit a variant by id/alias (writes cord.g). Returns id or nil.
function plugin.commit_variant(name)
  local i = normalize(name)
  if not i then return nil end
  if commit(IDS[i]) then return IDS[i] end
  return nil
end

---Revert the current session preview.
function plugin.cancel_preview()
  pcall(cancel_preview)
end

---Wipe everything this plugin ever committed to cord.g.
function plugin.reset_committed()
  pcall(cord.g.style.resetAll)
end
