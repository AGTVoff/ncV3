-- NC Classic / correction visuelle 1.1
-- Executer APRES le chargement complet de Nebula. Aucun callback de gameplay modifie.
local env = getgenv and getgenv() or _G
local Library = env.Library or _G.Library
local Nebula = env.Nebula
local Window = Nebula and Nebula.ui and Nebula.ui.Window
assert(Library and Window and Window.Items, "Charger Nebula completement avant le correctif NC Classic.")
if Window.NCClassic11 then return Window.NCClassic11 end
local items = Window.Items
local root = Library.Holder.Instance
local holder = items.HeaderButtonHolder and items.HeaderButtonHolder.Instance
assert(holder, "HeaderButtonHolder introuvable dans cette version.")
local UIS = game:GetService("UserInputService")
local panel = Instance.new("Frame")
panel.Name = "NCClassicToolbar"
panel.Parent = root
panel.AnchorPoint = Vector2.new(1,0)
panel.Position = UDim2.new(1,-18,0,48)
panel.Size = UDim2.fromOffset(340,36)
panel.BackgroundColor3 = Library.Theme.Background
panel.BorderSizePixel = 0
panel.ZIndex = 100
local border = Instance.new("UIStroke")
border.Color = Library.Theme.Outline
border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
border.Parent = panel
setmetatable({Instance=panel}, Library):AddToTheme({BackgroundColor3="Background"})
setmetatable({Instance=border}, Library):AddToTheme({Color="Outline"})
holder.Parent = panel
holder.AnchorPoint = Vector2.new(0,0)
holder.Position = UDim2.fromOffset(6,6)
holder.Size = UDim2.new(1,-12,0,24)
holder.AutomaticSize = Enum.AutomaticSize.None
holder.BackgroundTransparency = 1
local layout = holder:FindFirstChildOfClass("UIListLayout")
if layout then
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0,6)
    pcall(function() layout.HorizontalFlex = Enum.UIFlexAlignment.None end)
end
local order = {Nebula=1, Panic=2, Theme=3, Find=4}
local function styleButton(button)
    if not button:IsA("GuiButton") then return end
    button.AutomaticSize = Enum.AutomaticSize.None
    button.Size = UDim2.fromOffset(76,24)
    button.ZIndex = 102
    local label
    for _, object in ipairs(button:GetDescendants()) do
        if object:IsA("TextLabel") then label = object end
        if object:IsA("GuiObject") then
            object.ZIndex = 103
            object.AutomaticSize = Enum.AutomaticSize.None
            if object:IsA("Frame") then
                object.Position = UDim2.fromOffset(1,1)
                object.Size = UDim2.new(1,-2,1,-2)
            elseif object:IsA("TextLabel") then
                object.AnchorPoint = Vector2.new(0,0)
                object.Position = UDim2.fromOffset(0,0)
                object.Size = UDim2.fromScale(1,1)
                object.TextXAlignment = Enum.TextXAlignment.Center
                object.TextTruncate = Enum.TextTruncate.AtEnd
            end
        end
    end
    if label then button.LayoutOrder = order[label.Text] or 10 end
end
local function fitToolbar()
    local count = 0
    for _, child in ipairs(holder:GetChildren()) do
        if child:IsA("GuiButton") then styleButton(child); count = count + 1 end
    end
    local width = math.max(1,count)*76 + math.max(0,count-1)*6 + 12
    local available = math.max(160,root.AbsoluteSize.X-36)
    local scale = panel:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
    scale.Scale = math.min(1,available/width); scale.Parent = panel
    panel.Size = UDim2.fromOffset(width,36)
end
fitToolbar()
Library:Connect(holder.ChildAdded,function() task.defer(fitToolbar) end)
Library:Connect(root:GetPropertyChangedSignal("AbsoluteSize"),fitToolbar)
Library:BindToWindowVisibility(function(open) panel.Visible = open end)

-- Enlarge existing checkbox surfaces, retaining the original Inline ON/OFF state.
local styled = setmetatable({}, {__mode="k"})
local function styleIndicator(indicator)
    if styled[indicator] or not indicator:IsA("Frame") then return end
    local row = indicator.Parent
    if not row or not row:IsA("TextButton") then return end
    if indicator.Size.X.Scale ~= 0 or indicator.Size.Y.Scale ~= 0 then return end
    local size = indicator.Size.X.Offset
    if size ~= 8 or indicator.Size.Y.Offset ~= 8 then return end
    local fill
    for _, child in ipairs(indicator:GetChildren()) do
        if child:IsA("Frame") then fill = child; break end
    end
    if not fill then return end
    local label
    for _, child in ipairs(row:GetChildren()) do
        if child:IsA("TextLabel") then label = child; break end
    end
    if not label then return end
    styled[indicator] = true
    indicator.Size = UDim2.fromOffset(12,12)
    indicator.AnchorPoint = Vector2.new(0,0.5)
    indicator.Position = UDim2.new(0,0,0.5,0)
    indicator.BorderSizePixel = 0
    if row.Size.Y.Scale == 0 and row.Size.Y.Offset < 16 then
        row.Size = UDim2.new(row.Size.X.Scale,row.Size.X.Offset,0,16)
    end
    label.Position = UDim2.new(0,19,0.5,0)
    for _, child in ipairs(indicator:GetChildren()) do
        if child:IsA("UIStroke") then
            child.Thickness = 1
            child.Transparency = 0
            child.LineJoinMode = Enum.LineJoinMode.Miter
        end
    end
    -- Add an inset outline; do not change the fill transparency or flag setters.
    local inset = Instance.new("UIStroke")
    inset.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    inset.Thickness = 1
    inset.Color = Library.Theme.Outline
    inset.Transparency = 0.25
    inset.Parent = indicator
    setmetatable({Instance=inset},Library):AddToTheme({Color="Outline"})
end
for _, screen in ipairs({Library.Holder.Instance,Library.UnusedHolder.Instance}) do
    for _, object in ipairs(screen:GetDescendants()) do styleIndicator(object) end
    Library:Connect(screen.DescendantAdded,function(object)
        task.defer(function() if object.Parent then styleIndicator(object) end end)
    end)
end
-- Constructed indicators can acquire their children after DescendantAdded fires.
local originalToggle = Library.Toggle
Library.Toggle = function(self,...)
    local object = originalToggle(self,...)
    if object and object.Items and object.Items.Indicator then
        styleIndicator(object.Items.Indicator.Instance)
    end
    return object
end
Window.NCClassic11 = {Toolbar=panel}
return Window.NCClassic11
