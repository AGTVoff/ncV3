--[[
    2/22/2026
    Library.lua
    Purpose:
        NH ui library

    Author: @joestar._3
    Dependencies:
        None
]]

-- hi guys

if getgenv().Library and getgenv().Library.Exit then
    getgenv().Library:Exit()
end

-- Bad executor support (atleast by a bit)
cloneref = cloneref or function(Object) return Object end

--#region Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ContextActionService = game:GetService("ContextActionService")
local CoreGui = cloneref(game:GetService("CoreGui"))
local GuiService = game:GetService("GuiService")
--#endregion

gethui = gethui or function() return CoreGui end

--#region Variables
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = cloneref(LocalPlayer:GetMouse())
local GuiInset = GuiService:GetGuiInset().Y
local BlockedWindowInputs = {
    Enum.KeyCode.W,
    Enum.KeyCode.A,
    Enum.KeyCode.S,
    Enum.KeyCode.D,
    Enum.KeyCode.Space,
    Enum.KeyCode.LeftShift,
    Enum.KeyCode.RightShift,
    Enum.KeyCode.LeftControl,
    Enum.KeyCode.RightControl,
    Enum.KeyCode.LeftAlt,
    Enum.KeyCode.RightAlt,
    Enum.KeyCode.Up,
    Enum.KeyCode.Down,
    Enum.KeyCode.Left,
    Enum.KeyCode.Right,
    Enum.KeyCode.Return,
    Enum.KeyCode.KeypadEnter,
    Enum.KeyCode.Slash,
    Enum.KeyCode.Backquote,
    Enum.KeyCode.Tab,
    Enum.KeyCode.E,
    Enum.KeyCode.Q,
    Enum.KeyCode.R,
    Enum.KeyCode.F,
    Enum.KeyCode.C,
    Enum.KeyCode.Z,
    Enum.KeyCode.X,
    Enum.KeyCode.One,
    Enum.KeyCode.Two,
    Enum.KeyCode.Three,
    Enum.KeyCode.Four,
    Enum.KeyCode.Five,
    Enum.KeyCode.Six,
    Enum.KeyCode.Seven,
    Enum.KeyCode.Eight,
    Enum.KeyCode.Nine,
    Enum.KeyCode.Zero
}
--#endregion

local Library = {
    Flags = {},
    MenuKeybind = tostring(Enum.KeyCode.X),

    Directory = "niggahack",
    Folders = {
        Assets = "/Assets",
        Configs = "/Configs"
    },

    FontSize = 12,

    Animation = {
        Time = 0.3,
        Style = "Quint",
        Direction = "Out"
    },

    Theme = nil,

    -- Ignore below
    Threads = {},
    Connections = {},
    Notifications = {},
    SetFlags = {},

    ThemingStuff = {},
    ThemeMap = {},

    OpenFrames = {},
    WindowVisibilityBindings = {},
    WindowOpenState = true,
    InputBlockAction = "NH_UI_INPUT_BLOCK",
    BackgroundEffects = nil,
    BackgroundBlurEnabled = true,
    BackgroundSnowEnabled = false,
    CopiedColor = nil,
    LayoutRegistry = {},
    SettingsWidgets = {},
    ActiveConfirmDialog = nil,
    MouseCursor = nil,
    MouseStateBeforeOpen = nil,

    Holder = nil,
    UnusedHolder = nil,

    Font = nil
}
do
    Library.__index = Library

    local Flags = Library.Flags
    local SetFlags = Library.SetFlags

    local Keys = {
        ["Unknown"]          = "Unknown",
        ["Backspace"]        = "Back",
        ["Tab"]              = "Tab",
        ["Clear"]            = "Clear",
        ["Return"]           = "Return",
        ["Pause"]            = "Pause",
        ["Escape"]           = "Escape",
        ["Space"]            = "Space",
        ["QuotedDouble"]     = '"',
        ["Hash"]             = "#",
        ["Dollar"]           = "$",
        ["Percent"]          = "%",
        ["Ampersand"]        = "&",
        ["Quote"]            = "'",
        ["LeftParenthesis"]  = "(",
        ["RightParenthesis"] = " )",
        ["Asterisk"]         = "*",
        ["Plus"]             = "+",
        ["Comma"]            = ",",
        ["Minus"]            = "-",
        ["Period"]           = ".",
        ["Slash"]            = "`",
        ["Three"]            = "3",
        ["Seven"]            = "7",
        ["Eight"]            = "8",
        ["Colon"]            = ":",
        ["Semicolon"]        = ";",
        ["LessThan"]         = "<",
        ["GreaterThan"]      = ">",
        ["Question"]         = "?",
        ["Equals"]           = "=",
        ["At"]               = "@",
        ["LeftBracket"]      = "LeftBracket",
        ["RightBracket"]     = "RightBracked",
        ["BackSlash"]        = "BackSlash",
        ["Caret"]            = "^",
        ["Underscore"]       = "_",
        ["Backquote"]        = "`",
        ["LeftCurly"]        = "{",
        ["Pipe"]             = "|",
        ["RightCurly"]       = "}",
        ["Tilde"]            = "~",
        ["Delete"]           = "Delete",
        ["End"]              = "End",
        ["KeypadZero"]       = "Keypad0",
        ["KeypadOne"]        = "Keypad1",
        ["KeypadTwo"]        = "Keypad2",
        ["KeypadThree"]      = "Keypad3",
        ["KeypadFour"]       = "Keypad4",
        ["KeypadFive"]       = "Keypad5",
        ["KeypadSix"]        = "Keypad6",
        ["KeypadSeven"]      = "Keypad7",
        ["KeypadEight"]      = "Keypad8",
        ["KeypadNine"]       = "Keypad9",
        ["KeypadPeriod"]     = "KeypadP",
        ["KeypadDivide"]     = "KeypadD",
        ["KeypadMultiply"]   = "KeypadM",
        ["KeypadMinus"]      = "KeypadM",
        ["KeypadPlus"]       = "KeypadP",
        ["KeypadEnter"]      = "KeypadE",
        ["KeypadEquals"]     = "KeypadE",
        ["Insert"]           = "Insert",
        ["Home"]             = "Home",
        ["PageUp"]           = "PageUp",
        ["PageDown"]         = "PageDown",
        ["RightShift"]       = "RightShift",
        ["LeftShift"]        = "LeftShift",
        ["RightControl"]     = "RightControl",
        ["LeftControl"]      = "LeftControl",
        ["LeftAlt"]          = "LeftAlt",
        ["RightAlt"]         = "RightAlt"
    }

    -- Folders
    if not isfolder(Library.Directory) then
        makefolder(Library.Directory)
    end

    for _, Folder in Library.Folders do
        if not isfolder(Library.Directory .. Folder) then
            makefolder(Library.Directory .. Folder)
        end
    end

    local Themes = {
        ["Preset"] = {
            ["Background"] = Color3.fromRGB(15, 15, 20),
            ["Outline"] = Color3.fromRGB(49, 47, 61),
            ["Border"] = Color3.fromRGB(10, 10, 14),
            ["Accent"] = Color3.fromRGB(167, 139, 250),
            ["Risky"] = Color3.fromRGB(249, 112, 135),
            ["Light Border"] = Color3.fromRGB(30, 29, 39),
            ["Border 2"] = Color3.fromRGB(19, 18, 25),
            ["Text"] = Color3.fromRGB(237, 236, 244),
            ["Section"] = Color3.fromRGB(21, 21, 28),
            ["Element"] = Color3.fromRGB(32, 31, 42),
            ["Hovered Element"] = Color3.fromRGB(43, 40, 58),
            ["Inactive Text"] = Color3.fromRGB(143, 140, 161)
        }
    }

    Library.Theme = Themes.Preset

    -- Built-in UI typography
    Library.Font = Font.fromEnum(Enum.Font.Gotham)

    Library.Exit = function(Self)
        Self:ApplyWindowInputState(false)

        if Self.BackgroundEffects then
            Self.BackgroundEffects.IsSnowing = false

            if Self.BackgroundEffects.BlurEffect and Self.BackgroundEffects.BlurEffect.Parent then
                Self.BackgroundEffects.BlurEffect:Destroy()
            end

            if Self.BackgroundEffects.Background and Self.BackgroundEffects.Background.Parent then
                Self.BackgroundEffects.Background:Destroy()
            end
        end

        for _, Connection in Library.Connections do
            Connection:Disconnect()
        end

        for _, Thread in Library.Threads do
            coroutine.close(Thread)
        end

        if Self.Holder then
            Self.Holder.Instance:Destroy()
        end

        if Self.UnusedHolder then
            Self.UnusedHolder.Instance:Destroy()
        end

        Library = nil
        getgenv().Library = nil
    end

    Library.Create = function(Self, Class, Properties)
        local Data = {
            Class = Class,
            Properties = Properties,
            Instance = Instance.new(Class)
        }

        for Index, Property in Properties do
            if Property == "FontFace" then
                Data.Instance[Property] = Library.Font
                continue
            end

            if Property == "TextSize" then
                Data.Instance[Property] = Library.FontSize
                continue
            end

            if Property == "Name" then
                Data.Instance[Property] = "\0"
                continue
            end

            if Class == "TextButton" then
                if Property == "AutoButtonColor" then
                    Data.Instance[Property] = false
                    continue
                end

                if Property == "Text" then
                    Data.Instance[Property] = ""
                    continue
                end
            end

            Data.Instance[Index] = Property
        end

        return setmetatable(Data, Library)
    end

    Library.Thread = function(Self, Function)
        local NewThread = coroutine.create(Function)

        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        table.insert(Library.Threads, NewThread)
        return NewThread
    end

    Library.Connect = function(Self, Signal, Callback)
        local Connection

        if Self.Instance then
            if Self.Instance[Signal] then
                Connection = Self.Instance[Signal]:Connect(Callback)
            else
                Connection = Signal:Connect(Callback)
            end
        else
            Connection = Signal:Connect(Callback)
        end

        table.insert(Library.Connections, Connection)
        return Connection
    end

    Library.Tween = function(Self, Properties, Info, IsRawItem)
        local Object = Self.Instance or IsRawItem
        Info = Info or
            TweenInfo.new(Library.Animation.Time, Enum.EasingStyle[Library.Animation.Style],
                Enum.EasingDirection[Library.Animation.Direction])

        if not Object then
            return
        end

        local NewTween = TweenService:Create(Object, Info, Properties)
        NewTween:Play()

        return NewTween
    end

    Library.GetTweenProperty = function(Self, IsRawItem)
        local Object = Self.Instance or IsRawItem

        if not Object then
            return {}
        end

        if Object:IsA("Frame") then
            return { "BackgroundTransparency" }
        elseif Object:IsA("TextLabel") or Object:IsA("TextButton") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
            return { "BackgroundTransparency", "ImageTransparency" }
        elseif Object:IsA("ScrollingFrame") then
            return { "BackgroundTransparency", "ScrollBarImageTransparency" }
        elseif Object:IsA("TextBox") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Object:IsA("UIStroke") then
            return { "Transparency" }
        end
    end

    Library.Fade = function(Self, Property, Visibility, IsRawItem)
        local Object = Self.Instance or IsRawItem

        if not Object then
            return
        end

        local OldTransparency = Object[Property]
        Object[Property] = Visibility and 1 or OldTransparency

        local NewTween = Library:Tween({
            [Property] = Visibility and OldTransparency or 1
        }, nil, Object)

        Library:Connect(NewTween.Completed, function()
            if not Visibility then
                task.wait()
                Object[Property] = OldTransparency
            end
        end)

        return NewTween
    end

    Library.FadeDescendants = function(Self, Visibility, Callback)
        if Visibility then
            Self.Instance.Visible = true
        end

        local NewTween

        local Children = Self.Instance:GetDescendants()
        table.insert(Children, Self.Instance)

        for _, Child in Children do
            local TransparencyProperty = Library:GetTweenProperty(Child)

            if not TransparencyProperty then
                continue
            end

            if type(TransparencyProperty) == "table" then
                for _, Property in TransparencyProperty do
                    NewTween = Library:Fade(Property, Visibility, Child)
                end
            else
                NewTween = Library:Fade(TransparencyProperty, Visibility, Child)
            end
        end

        Library:Connect(NewTween.Completed, function()
            if Callback and type(Callback) == "function" then
                Callback()
            end

            Self.Instance.Visible = Visibility
        end)
    end

    Library.MakeDraggable = function(Self)
        if not Self.Instance then
            return
        end

        local Gui = Self.Instance
        local Dragging = false
        local DragStart
        local StartPosition

        local Set = function(Input)
            local DragDelta = Input.Position - DragStart
            local NewX = StartPosition.X.Offset + DragDelta.X
            local NewY = StartPosition.Y.Offset + DragDelta.Y

            local ScreenSize = Gui.Parent.AbsoluteSize
            local GuiSize = Gui.AbsoluteSize

            NewX = math.clamp(NewX, 0, ScreenSize.X - GuiSize.X)
            NewY = math.clamp(NewY, 0, ScreenSize.Y - GuiSize.Y)

            local MainWindow = Library.MainWindowFrame
            if Gui ~= MainWindow
                and Library.WindowOpenState
                and MainWindow
                and MainWindow.Parent == Gui.Parent
                and MainWindow.Visible
            then
                local PanelPosition = MainWindow.AbsolutePosition
                local PanelSize = MainWindow.AbsoluteSize
                local PanelLeft = PanelPosition.X
                local PanelTop = PanelPosition.Y
                local PanelRight = PanelLeft + PanelSize.X
                local PanelBottom = PanelTop + PanelSize.Y

                local OverlapsX = (NewX < PanelRight) and ((NewX + GuiSize.X) > PanelLeft)
                local OverlapsY = (NewY < PanelBottom) and ((NewY + GuiSize.Y) > PanelTop)

                if OverlapsX and OverlapsY then
                    local LeftGap = math.abs((NewX + GuiSize.X) - PanelLeft)
                    local RightGap = math.abs(NewX - PanelRight)
                    local TopGap = math.abs((NewY + GuiSize.Y) - PanelTop)
                    local BottomGap = math.abs(NewY - PanelBottom)
                    local MinGap = math.min(LeftGap, RightGap, TopGap, BottomGap)

                    if MinGap == LeftGap then
                        NewX = PanelLeft - GuiSize.X
                    elseif MinGap == RightGap then
                        NewX = PanelRight
                    elseif MinGap == TopGap then
                        NewY = PanelTop - GuiSize.Y
                    else
                        NewY = PanelBottom
                    end
                end
            end

            Gui.Position = UDim2.new(0, math.floor(NewX + 0.5), 0, math.floor(NewY + 0.5))
        end

        local InputChanged

        Self:Connect("InputBegan", function(Input)
            if not Library.WindowOpenState then
                return
            end

            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = Input.Position
                StartPosition = Gui.Position

                if InputChanged then
                    return
                end

                InputChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                        InputChanged:Disconnect()
                        InputChanged = nil
                    end
                end)
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if Dragging and not Library.WindowOpenState then
                    Dragging = false
                    return
                end

                if Dragging then
                    Set(Input)
                end
            end
        end)

        return Dragging
    end

    Library.MakeResizeable = function(Self, Minimum)
        if not Self.Instance then
            return
        end

        local Gui = Self.Instance

        local Resizing = false
        local CurrentSide = nil

        local StartMouse = nil
        local StartPosition = nil
        local StartSize = nil

        local EdgeThickness = 2

        local MakeEdge = function(Name, Position, Size)
            local Button = Library:Create("TextButton", {
                Name = "\0",
                Size = Size,
                Position = Position,
                BackgroundColor3 = Color3.fromRGB(166, 147, 243),
                BackgroundTransparency = 1,
                Text = "",
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Parent = Gui,
                ZIndex = 99999,
            })
            Button:AddToTheme({ BackgroundColor3 = "Accent" })

            return Button
        end

        local Edges = {
            {
                Button = MakeEdge(
                    "Left",
                    UDim2.new(0, 0, 0, 0),
                    UDim2.new(0, EdgeThickness, 1, 0)),
                Side = "L"
            },

            {
                Button = MakeEdge(
                    "Right",
                    UDim2.new(1, -EdgeThickness, 0, 0),
                    UDim2.new(0, EdgeThickness, 1, 0)),
                Side = "R"
            },

            {
                Button = MakeEdge(
                    "Top", UDim2.new(0, 0, 0, 0),
                    UDim2.new(1, 0, 0, EdgeThickness)),
                Side = "T"
            },

            {
                Button = MakeEdge(
                    "Bottom",
                    UDim2.new(0, 0, 1, -EdgeThickness),
                    UDim2.new(1, 0, 0, EdgeThickness)),
                Side = "B"
            },
        }

        local BeginResizing = function(Side)
            Resizing = true
            CurrentSide = Side

            StartMouse = UserInputService:GetMouseLocation()

            StartPosition = Vector2.new(Gui.Position.X.Offset, Gui.Position.Y.Offset)
            StartSize = Vector2.new(Gui.Size.X.Offset, Gui.Size.Y.Offset)

            for Index, Value in Edges do
                Value.Button.Instance.BackgroundTransparency = (Value.Side == Side) and 0 or 1
            end
        end

        local EndResizing = function()
            Resizing = false
            CurrentSide = nil

            for Index, Value in Edges do
                Value.Button.Instance.BackgroundTransparency = 1
            end
        end

        for Index, Value in Edges do
            Value.Button:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    BeginResizing(Value.Side)
                end
            end)
        end

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if Resizing then
                    EndResizing()
                end
            end
        end)

        Library:Connect(RunService.RenderStepped, function()
            if not Resizing or not CurrentSide then
                return
            end

            local MouseLocation = UserInputService:GetMouseLocation()
            local dx = MouseLocation.X - StartMouse.X
            local dy = MouseLocation.Y - StartMouse.Y

            local x, y = StartPosition.X, StartPosition.Y
            local w, h = StartSize.X, StartSize.Y

            if CurrentSide == "L" then
                x = StartPosition.X + dx
                w = StartSize.X - dx
            elseif CurrentSide == "R" then
                w = StartSize.X + dx
            elseif CurrentSide == "T" then
                y = StartPosition.Y + dy
                h = StartSize.Y - dy
            elseif CurrentSide == "B" then
                h = StartSize.Y + dy
            end

            if w < Minimum.X then
                if CurrentSide == "L" then
                    x = x - (Minimum.X - w)
                end
                w = Minimum.X
            end
            if h < Minimum.Y then
                if CurrentSide == "T" then
                    y = y - (Minimum.Y - h)
                end
                h = Minimum.Y
            end

            Self:Tween({ Position = UDim2.fromOffset(x, y) },
                TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
            Self:Tween({ Size = UDim2.fromOffset(w, h) },
                TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
        end)
    end

    Library.IsMouseOverFrame = function(Self)
        if not Self.Instance then
            return
        end

        local Object = Self.Instance

        local MousePosition = Vector2.new(Mouse.X, Mouse.Y)

        return MousePosition.X >= Object.AbsolutePosition.X and
            MousePosition.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X
            and MousePosition.Y >= Object.AbsolutePosition.Y and
            MousePosition.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y
    end

    Library.CompareVectors = function(Self, PointA, PointB)
        return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
    end

    Library.IsClipped = function(Self, Column)
        if not Self.Instance then
            return
        end

        local Parent = Column
        local Object = Self.Instance

        local BoundryTop = Parent.AbsolutePosition
        local BoundryBottom = BoundryTop + Parent.AbsoluteSize

        local Top = Object.AbsolutePosition
        local Bottom = Top + Object.AbsoluteSize

        return Library:CompareVectors(Top, BoundryTop) or Library:CompareVectors(BoundryBottom, Bottom)
    end

    Library.SafeCall = function(Self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, table.unpack(Arguements))

        if not Success then
            warn(Result)
            return false
        end

        return Success, Result
    end

    Library.BindToWindowVisibility = function(Self, Callback)
        if type(Callback) ~= "function" then
            return
        end

        table.insert(Library.WindowVisibilityBindings, Callback)
        Library:SafeCall(Callback, Library.WindowOpenState)
    end

    Library.ApplyWindowInputState = function(Self, Bool)
        if Self.InputBlocker and Self.InputBlocker.Instance then
            Self.InputBlocker.Instance.Visible = Bool and true or false
        end

        if Bool then
            ContextActionService:BindActionAtPriority(Self.InputBlockAction, function(_, State, Input)
                    if State ~= Enum.UserInputState.Begin and State ~= Enum.UserInputState.Change then
                        return Enum.ContextActionResult.Pass
                    end

                    if not Self.WindowOpenState or UserInputService:GetFocusedTextBox() then
                        return Enum.ContextActionResult.Pass
                    end

                    if Input and (tostring(Input.KeyCode) == Self.MenuKeybind or tostring(Input.UserInputType) == Self.MenuKeybind) then
                        return Enum.ContextActionResult.Pass
                    end

                    return Enum.ContextActionResult.Sink
                end, false, 5000,
                Enum.UserInputType.Gamepad1,
                Enum.UserInputType.Gamepad2,
                Enum.UserInputType.Gamepad3,
                Enum.UserInputType.Gamepad4,
                Enum.UserInputType.Gamepad5,
                Enum.UserInputType.Gamepad6,
                Enum.UserInputType.Gamepad7,
                Enum.UserInputType.Gamepad8,
                Enum.UserInputType.MouseWheel,
                Enum.UserInputType.MouseButton2,
                Enum.UserInputType.MouseButton3
            )

            ContextActionService:BindActionAtPriority(Self.InputBlockAction .. "_KEYS", function(_, State)
                if State ~= Enum.UserInputState.Begin and State ~= Enum.UserInputState.Change then
                    return Enum.ContextActionResult.Pass
                end

                if not Self.WindowOpenState or UserInputService:GetFocusedTextBox() then
                    return Enum.ContextActionResult.Pass
                end

                return Enum.ContextActionResult.Sink
            end, false, 5000, table.unpack(BlockedWindowInputs))
            return
        end

        ContextActionService:UnbindAction(Self.InputBlockAction)
        ContextActionService:UnbindAction(Self.InputBlockAction .. "_KEYS")
    end

    Library.SetWindowVisibilityState = function(Self, Bool)
        Library.WindowOpenState = Bool and true or false
        Library:ApplyWindowInputState(Library.WindowOpenState)

        if Library.WindowOpenState then
            Library.MouseStateBeforeOpen = {
                MouseBehavior = UserInputService.MouseBehavior,
                MouseIconEnabled = UserInputService.MouseIconEnabled,
            }
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            UserInputService.MouseIconEnabled = false
        elseif Library.MouseStateBeforeOpen then
            UserInputService.MouseBehavior = Library.MouseStateBeforeOpen.MouseBehavior or Enum.MouseBehavior.Default
            UserInputService.MouseIconEnabled = Library.MouseStateBeforeOpen.MouseIconEnabled ~= false
            Library.MouseStateBeforeOpen = nil
        else
            UserInputService.MouseIconEnabled = true
        end

        if Library.MouseCursor and Library.MouseCursor.Instance then
            Library.MouseCursor.Instance.Visible = Library.WindowOpenState
        end

        if not Library.WindowOpenState then
            for _, OpenFrame in Library.OpenFrames do
                if OpenFrame and OpenFrame.IsOpen and OpenFrame.SetOpen then
                    OpenFrame:SetOpen(false)
                end
            end
        end

        for _, Callback in Library.WindowVisibilityBindings do
            Library:SafeCall(Callback, Library.WindowOpenState)
        end
    end

    Library.RegisterSettingsWidget = function(Self, Data)
        if type(Data) ~= "table" then
            return
        end

        local Name = Data.Name or Data.name
        local Callback = Data.Callback or Data.callback
        if type(Name) ~= "string" or type(Callback) ~= "function" then
            return
        end

        table.insert(Library.SettingsWidgets, {
            Name = Name,
            Flag = Data.Flag or Data.flag or ("UIWidget" .. Name:gsub("%s+", "")),
            Default = Data.Default ~= false,
            Callback = Callback,
            Settings = Data.Settings or Data.settings
        })
    end

    Library.SetupBackgroundEffects = function(Self)
        if Library.BackgroundEffects then
            return
        end

        local Background = Library:Create("Frame", {
            Name = "\0",
            Parent = Library.Holder.Instance,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            ZIndex = 0
        })

        local SnowHolder = Library:Create("Frame", {
            Name = "\0",
            Parent = Background.Instance,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 0
        })

        local BlurEffect = Instance.new("BlurEffect")
        BlurEffect.Size = 0
        BlurEffect.Parent = Camera

        Library.BackgroundEffects = {
            Background = Background.Instance,
            SnowHolder = SnowHolder.Instance,
            BlurEffect = BlurEffect,
            SnowAsset = "http://www.roblox.com/asset/?id=6871196088",
            IsSnowing = false
        }

        Library:Thread(function()
            while Library and Library.BackgroundEffects do
                local Effects = Library.BackgroundEffects

                if not Effects.IsSnowing then
                    task.wait(0.1)
                    continue
                end

                local Holder = Effects.SnowHolder
                if not Holder or not Holder.Parent then
                    task.wait(0.1)
                    continue
                end

                local Width = Holder.AbsoluteSize.X
                local Height = Holder.AbsoluteSize.Y
                if Width <= 0 or Height <= 0 then
                    task.wait(0.1)
                    continue
                end

                local Image = Instance.new("ImageLabel")
                Image.Name = "\0"
                Image.Parent = Holder
                Image.BackgroundTransparency = 1
                Image.Image = Effects.SnowAsset
                Image.ZIndex = 0

                local RandomSize = math.random(5, 8)
                local SpawnX = math.random(0, math.max(0, Width - RandomSize))

                Image.Size = UDim2.new(0, RandomSize, 0, RandomSize)
                Image.Position = UDim2.new(0, SpawnX, 0, -10)

                local FallDuration = math.random(20, 40) / 10
                local SwayX = math.random(-18, 18)
                local GoalPosition = UDim2.new(0, SpawnX + SwayX, 0, Height + 10)

                local FallTween = TweenService:Create(Image,
                    TweenInfo.new(FallDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                        Position = GoalPosition,
                        ImageTransparency = 1
                    })

                FallTween:Play()
                Library:Connect(FallTween.Completed, function()
                    if Image and Image.Parent then
                        Image:Destroy()
                    end
                end)

                task.wait(0.1)
            end
        end)
    end

    Library.SetBackgroundEffectsVisible = function(Self, Bool, Instant)
        local Effects = Library.BackgroundEffects
        if not Effects then
            return
        end

        local HasAnyEffect = Library.BackgroundBlurEnabled or Library.BackgroundSnowEnabled
        local IsVisible = Bool and true or false
        Effects.IsSnowing = IsVisible and Library.BackgroundSnowEnabled

        local TargetTransparency = (IsVisible and HasAnyEffect) and 0.5 or 1
        local TargetBlur = (IsVisible and Library.BackgroundBlurEnabled) and 20 or 0

        if IsVisible and HasAnyEffect then
            Effects.Background.Visible = true
        end

        if Instant then
            Effects.Background.BackgroundTransparency = TargetTransparency
            Effects.BlurEffect.Size = TargetBlur
        else
            local FadeTween = TweenService:Create(Effects.Background,
                TweenInfo.new(0.33, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    BackgroundTransparency = TargetTransparency
                })

            local BlurTween = TweenService:Create(Effects.BlurEffect,
                TweenInfo.new(0.33, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    Size = TargetBlur
                })

            FadeTween:Play()
            BlurTween:Play()
        end

        if (not IsVisible) or (not HasAnyEffect) then
            task.delay(0.35, function()
                if not Library or not Library.BackgroundEffects then
                    return
                end

                local CurrentEffects = Library.BackgroundEffects
                if CurrentEffects.IsSnowing then
                    return
                end

                CurrentEffects.Background.Visible = false

                for _, Child in CurrentEffects.SnowHolder:GetChildren() do
                    if Child:IsA("ImageLabel") then
                        Child:Destroy()
                    end
                end
            end)
        end
    end

    Library.SetBackgroundBlurEnabled = function(Self, Bool)
        Library.BackgroundBlurEnabled = Bool and true or false
        Library:SetBackgroundEffectsVisible(Library.WindowOpenState, true)
    end

    Library.SetBackgroundSnowEnabled = function(Self, Bool)
        Library.BackgroundSnowEnabled = Bool and true or false
        Library:SetBackgroundEffectsVisible(Library.WindowOpenState, true)
    end

    Library.Round = function(Self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return math.floor(Number * Multiplier) / Multiplier
    end

    Library.RegisterLayout = function(Self, Id, Data)
        if type(Id) ~= "string" or Id == "" or type(Data) ~= "table" or not Data.Instance then
            return
        end

        Library.LayoutRegistry[Id] = Data
        return Data
    end

    Library.GetLayoutConfig = function(Self)
        local Layout = {}

        for Id, Data in Library.LayoutRegistry do
            local Instance = Data and Data.Instance
            if not Instance or not Instance.Parent then
                continue
            end

            local Entry = {}
            local Position = Instance.Position

            if Data.SavePosition ~= false then
                Entry.Position = {
                    X = math.floor((tonumber(Position.X.Offset) or 0) + 0.5),
                    Y = math.floor((tonumber(Position.Y.Offset) or 0) + 0.5)
                }
            end

            if Data.SaveSize == true then
                local Size = Instance.Size
                Entry.Size = {
                    X = math.floor((tonumber(Size.X.Offset) or 0) + 0.5),
                    Y = math.floor((tonumber(Size.Y.Offset) or 0) + 0.5)
                }
            end

            if next(Entry) ~= nil then
                Layout[Id] = Entry
            end
        end

        return Layout
    end

    Library.ApplyLayoutConfig = function(Self, Layout)
        if type(Layout) ~= "table" then
            return
        end

        for Id, State in Layout do
            local Data = Library.LayoutRegistry[Id]
            local Instance = Data and Data.Instance
            if not Instance or not Instance.Parent or type(State) ~= "table" then
                continue
            end

            local ParentSize = Instance.Parent.AbsoluteSize
            local MinimumSize = Data.MinimumSize or Vector2.new(0, 0)
            local MaximumSize = Data.MaximumSize

            if Data.SaveSize == true and type(State.Size) == "table" then
                local MaxWidth = math.max(ParentSize.X, MinimumSize.X)
                local MaxHeight = math.max(ParentSize.Y, MinimumSize.Y)

                if typeof(MaximumSize) == "Vector2" then
                    MaxWidth = math.min(MaxWidth, MaximumSize.X)
                    MaxHeight = math.min(MaxHeight, MaximumSize.Y)
                end

                local Width = math.clamp(
                    tonumber(State.Size.X) or Instance.AbsoluteSize.X,
                    math.min(MinimumSize.X, MaxWidth),
                    MaxWidth
                )
                local Height = math.clamp(
                    tonumber(State.Size.Y) or Instance.AbsoluteSize.Y,
                    math.min(MinimumSize.Y, MaxHeight),
                    MaxHeight
                )

                Instance.Size = UDim2.fromOffset(
                    math.floor(Width + 0.5),
                    math.floor(Height + 0.5)
                )
            end

            if Data.SavePosition ~= false and type(State.Position) == "table" then
                local CurrentSize = Instance.AbsoluteSize
                local Width = CurrentSize.X > 0 and CurrentSize.X or (tonumber(Instance.Size.X.Offset) or 0)
                local Height = CurrentSize.Y > 0 and CurrentSize.Y or (tonumber(Instance.Size.Y.Offset) or 0)
                local X = tonumber(State.Position.X) or Instance.Position.X.Offset
                local Y = tonumber(State.Position.Y) or Instance.Position.Y.Offset

                Instance.AnchorPoint = Vector2.new(0, 0)
                Instance.Position = UDim2.fromOffset(
                    math.clamp(math.floor(X + 0.5), 0, math.max(ParentSize.X - Width, 0)),
                    math.clamp(math.floor(Y + 0.5), 0, math.max(ParentSize.Y - Height, 0))
                )
            end
        end
    end

    Library.GetConfig = function(Self)
        local Config = {}

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do
                if type(Value) == "table" and Value.Key then
                    Config[Index] = { Key = tostring(Value.Key), Mode = Value.Mode, Toggled = Value.Toggled }
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = { Color = "#" .. Value.HexValue, Alpha = Value.Alpha }
                else
                    Config[Index] = Value
                end
            end
        end)

        if not Success then
            warn("Failed to get config:\n" .. Result)
            return
        end

        return HttpService:JSONEncode({
            Flags = Config,
            Layout = Library:GetLayoutConfig()
        })
    end

    Library.LoadConfig = function(Self, Config)
        local Decoded = HttpService:JSONDecode(Config)
        local FlagData = type(Decoded) == "table" and Decoded.Flags or Decoded
        local LayoutData = type(Decoded) == "table" and Decoded.Layout

        local Success, Result = Library:SafeCall(function()
            for Index, Value in FlagData do
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Key then
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                else
                    SetFunction(Value)
                end
            end

            for Index, Value in FlagData do
                if type(Value) ~= "table" or not Value.Key then
                    continue
                end

                local SetFunction = Library.SetFlags[Index]
                if not SetFunction then
                    continue
                end

                SetFunction(Value)
            end
        end)

        if Success and type(LayoutData) == "table" then
            task.defer(function()
                task.wait()
                Library:ApplyLayoutConfig(LayoutData)
            end)
        end

        return Success, Result
    end

    Library.GetConfigsList = function(Self, Element)
        local List = {}
        local ReturnList = {}

        List = listfiles(Library.Directory .. Library.Folders.Configs)

        for Index = 1, #List do
            local File = List[Index]

            if File:sub(-5) == ".json" then
                local Position = File:find(".json", 1, true)
                local StartPosition = Position

                local Character = File:sub(Position, Position)
                while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                    Position = Position - 1
                    Character = File:sub(Position, Position)
                end

                if Character == "/" or Character == "\\" then
                    table.insert(ReturnList, File:sub(Position + 1, StartPosition - 1))
                end
            end
        end

        Element:Refresh(ReturnList)
    end

    Library.AddToTheme = function(Self, Properties)
        local Object = Self.Instance

        local ThemeData = {
            Item = Object,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                if not Library.Theme[Value] then
                    Object[Property] = Value
                end

                Object[Property] = Library.Theme[Value]
            else
                Object[Property] = Value()
            end
        end

        table.insert(Library.ThemingStuff, ThemeData)
        Library.ThemeMap[Object] = ThemeData
        return Self
    end

    Library.ChangeItemTheme = function(Self, Properties)
        local Object = Self.Instance

        if not Library.ThemingStuff[Object] then
            return
        end

        Library.ThemingStuff[Object].Properties = Properties
        Library.ThemingStuff[Object] = Library.ThemeMap[Object]
    end

    Library.ChangeTheme = function(Self, Theme, Color)
        Library.Theme[Theme] = Color

        for _, Item in Library.ThemingStuff do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end
    end

    Library.OnHover = function(Self, OnHoverEnter, OnHoverLeave)
        local Object = Self.Instance

        if not Object then
            return
        end

        Library:Connect(Object.MouseEnter, OnHoverEnter)
        Library:Connect(Object.MouseLeave, OnHoverLeave)
    end

    Library.GlobalUpdateOpenFrames = function(Self)
        local StaleEntries = {}

        for Key, Item in Library.OpenFrames do
            if not Item then
                table.insert(StaleEntries, Key)
                continue
            end

            local IsOpen = Item.IsOpen
            local AttachedButton = Item.AttachedButton
            local Frame = Item.Frame

            local CanUpdateNow = Item.CanUpdateNow

            if not IsOpen then
                table.insert(StaleEntries, Key)
                continue
            end

            if not CanUpdateNow then
                continue
            end

            if not AttachedButton or not AttachedButton.Parent or not Frame or not Frame.Parent then
                table.insert(StaleEntries, Key)
                continue
            end

            if CanUpdateNow and IsOpen then
                local ParentSize = Frame.Parent.AbsoluteSize
                local FrameSize = Frame.AbsoluteSize
                local X = AttachedButton.AbsolutePosition.X
                local Y = AttachedButton.AbsolutePosition.Y + AttachedButton.AbsoluteSize.Y + 10 + GuiInset

                if ParentSize.X > 0 and FrameSize.X > 0 then
                    X = math.clamp(X, 0, math.max(ParentSize.X - FrameSize.X, 0))
                end

                if ParentSize.Y > 0 and FrameSize.Y > 0 then
                    Y = math.clamp(Y, 0, math.max(ParentSize.Y - FrameSize.Y, 0))
                end

                Frame.Position = UDim2.fromOffset(X, Y)
            end
        end

        for _, Key in StaleEntries do
            Library.OpenFrames[Key] = nil
        end
    end

    Library.Holder = Library:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        IgnoreGuiInset = true,
        ResetOnSpawn = false
    })

    Library.InputBlocker = Library:Create("TextButton", {
        Parent = Library.Holder.Instance,
        Name = "\0",
        Visible = false,
        Modal = true,
        AutoButtonColor = false,
        Active = true,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 0
    })

    Library.MouseCursor = Library:Create("ImageLabel", {
        Parent = Library.Holder.Instance,
        Name = "\0",
        Visible = false,
        BackgroundTransparency = 1,
        Image = "http://www.roblox.com/asset/?id=5545698398",
        Size = UDim2.new(0, 36, 0, 36),
        ZIndex = 10000
    })

    Library.UnusedHolder = Library:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        Enabled = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    Library:SetupBackgroundEffects()
    Library:SetBackgroundEffectsVisible(false, true)

    Library.NotifHolder = Library:Create("Frame", {
        Name = "\0",
        Parent = Library.Holder.Instance,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 10 + GuiInset),
        Size = UDim2.new(0, 0, 1, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X
    })

    Library:Create("UIListLayout", {
        Name = "\0",
        Parent = Library.NotifHolder.Instance,
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0, 6)
    })

    Library:Create("UIPadding", {
        Name = "\0",
        Parent = Library.NotifHolder.Instance,
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8)
    })

    Library:Connect(RunService.RenderStepped, function()
        local MouseCursor = Library.MouseCursor
        if not (MouseCursor and MouseCursor.Instance and Library.WindowOpenState) then
            return
        end

        local MouseLocation = UserInputService:GetMouseLocation()
        MouseCursor.Instance.Position = UDim2.new(0, MouseLocation.X - 18, 0, MouseLocation.Y - 18)
    end)

    do
        Library.CreateColorpicker = function(Self, Data)
            local Colorpicker = {
                Hue = 0,
                Saturation = 0,
                Value = 0,

                Alpha = 0,

                Color = Color3.fromRGB(255, 255, 255),
                HexValue = "#FFFFFF",

                Flag = Data.Flag,
                IsOpen = false,

                Items = {}
            }

            local Items = {}
            do
                Items["ColorpickerButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Data.Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 22, 0, 12),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(158, 255, 252)
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ColorpickerButton"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["ColorpickerButton"].Instance,
                    Rotation = -90,
                    Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 172, 172))
                    }
                })

                Items["ColorpickerWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.UnusedHolder.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1056, 0, 203),
                    Size = UDim2.new(0, 230, 0, 205),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = 'Background' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Items["AccentLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = 'Accent' })

                Items["Shadow"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    ImageColor3 = Color3.fromRGB(103, 164, 255),
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.699999988079071,
                    Size = UDim2.new(1, 25, 1, 25),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    ZIndex = -1,
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                })

                Items["Palette"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 10, 0, 12),
                    Size = UDim2.new(1, -46, 1, -48),
                    BorderSizePixel = 0,
                })

                Items["Saturation"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Saturation"].Instance,
                    Transparency = NumberSequence.new {
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(1, 0)
                    }
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({ Color = 'Border' })

                Items["Value"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Value"].Instance,
                    Rotation = 90,
                    Transparency = NumberSequence.new {
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(1, 0)
                    }
                })

                Items["PaletteDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    Size = UDim2.new(0, 1, 0, 1),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["PaletteDragger"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Items["Hue"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Position = UDim2.new(1, -10, 0, 12),
                    Size = UDim2.new(0, 15, 1, -20),
                    BorderSizePixel = 0
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                    }
                })

                Items["HueDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["HueDragger"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({ Color = 'Border' })

                Items["Alpha"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 10, 1, -10),
                    Size = UDim2.new(1, -46, 0, 15),
                    BorderSizePixel = 0
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({ Color = 'Border' })

                Items["AlphaColor"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(158, 255, 252)
                })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["AlphaColor"].Instance,
                    Transparency = NumberSequence.new {
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(1, 0)
                    }
                })

                Items["AlphaDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, 1, 1, 0),
                    BorderSizePixel = 0
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["AlphaDragger"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({ Color = 'Border' })

                Items["CopyPasteWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.UnusedHolder.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1056, 0, 203),
                    Size = UDim2.new(0, 96, 0, 44),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"],
                    Visible = false
                }):AddToTheme({ BackgroundColor3 = "Background" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["CopyPasteWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["CopyPasteWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Items["CopyButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["CopyPasteWindow"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "Copy",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 4, 0, 4),
                    Size = UDim2.new(1, -8, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({
                    BackgroundColor3 = "Element",
                    TextColor3 = "Text"
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["CopyButton"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["CopyButton"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["CopyButton"].Instance,
                    Rotation = -90,
                    Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 172, 172))
                    }
                })

                Items["PasteButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["CopyPasteWindow"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "Paste",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 4, 0, 24),
                    Size = UDim2.new(1, -8, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({
                    BackgroundColor3 = "Element",
                    TextColor3 = "Text"
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["PasteButton"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["PasteButton"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["PasteButton"].Instance,
                    Rotation = -90,
                    Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 172, 172))
                    }
                })

                Colorpicker.Items = Items
            end

            function Colorpicker:SetVisibility(Bool)
                Items["ColorpickerButton"].Instance.Visible = Bool
            end

            function Colorpicker:Update(IsFromAlpha)
                local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
                Colorpicker.Color = Color3.fromHSV(Hue, Saturation, Value)
                Colorpicker.HexValue = Colorpicker.Color:ToHex()

                Items["ColorpickerButton"]:Tween({ BackgroundColor3 = Colorpicker.Color })
                Items["Palette"]:Tween({ BackgroundColor3 = Color3.fromHSV(Hue, 1, 1) })

                Flags[Colorpicker.Flag] = {
                    Alpha = Colorpicker.Alpha,
                    Color = Colorpicker.Color,
                    HexValue = Colorpicker.HexValue,
                    Transparency = 1 - Colorpicker.Alpha
                }

                if not IsFromAlpha then
                    Items["AlphaColor"]:Tween({ BackgroundColor3 = Colorpicker.Color })
                end

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
                end
            end

            local Debounce = false
            local RenderStepped
            local ColorpickerWindow = Items["ColorpickerWindow"].Instance
            local ColorpickerButton = Items["ColorpickerButton"].Instance
            local CopyPasteDebounce = false
            local CopyPasteWindow = Items["CopyPasteWindow"].Instance
            local CopyToClipboard = setclipboard or toclipboard

            Colorpicker.AttachedButton = ColorpickerButton
            Colorpicker.CanUpdateNow = false
            Colorpicker.Frame = ColorpickerWindow

            local function ResolveAttachedFramePosition(Frame)
                local Parent = Frame and Frame.Parent
                local ParentSize = Parent and Parent.AbsoluteSize or Vector2.new(0, 0)
                local FrameSize = Frame and Frame.AbsoluteSize or Vector2.new(0, 0)
                local X = ColorpickerButton.AbsolutePosition.X
                local Y = ColorpickerButton.AbsolutePosition.Y + ColorpickerButton.AbsoluteSize.Y + 10 + GuiInset

                if ParentSize.X > 0 and FrameSize.X > 0 then
                    X = math.clamp(X, 0, math.max(ParentSize.X - FrameSize.X, 0))
                end

                if ParentSize.Y > 0 and FrameSize.Y > 0 then
                    Y = math.clamp(Y, 0, math.max(ParentSize.Y - FrameSize.Y, 0))
                end

                return UDim2.fromOffset(X, Y)
            end

            local CopyPasteMenu = {
                IsOpen = false,
                AttachedButton = ColorpickerButton,
                CanUpdateNow = false,
                Frame = CopyPasteWindow
            }

            function CopyPasteMenu:SetOpen(Bool)
                if CopyPasteDebounce then
                    return
                end

                CopyPasteMenu.IsOpen = Bool and true or false
                CopyPasteDebounce = true

                if CopyPasteMenu.IsOpen then
                    if Colorpicker.IsOpen then
                        Colorpicker:SetOpen(false)
                    end

                    CopyPasteWindow.Parent = Library.Holder.Instance
                    CopyPasteWindow.Position = ResolveAttachedFramePosition(CopyPasteWindow)
                    CopyPasteWindow.Visible = true

                    Items["CopyPasteWindow"]:Tween({
                        Position = ResolveAttachedFramePosition(CopyPasteWindow)
                    })

                    Items["CopyPasteWindow"]:FadeDescendants(true, function()
                        CopyPasteMenu.CanUpdateNow = true
                        CopyPasteDebounce = false
                    end)

                    for _, Value in Library.OpenFrames do
                        if not Data.Section.IsSettings and Value ~= CopyPasteMenu then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[CopyPasteMenu] = CopyPasteMenu
                else
                    Items["CopyPasteWindow"]:Tween({
                        Position = ResolveAttachedFramePosition(CopyPasteWindow)
                    })

                    Items["CopyPasteWindow"]:FadeDescendants(false, function()
                        CopyPasteWindow.Parent = Library.UnusedHolder.Instance
                        CopyPasteMenu.CanUpdateNow = false
                        CopyPasteDebounce = false
                    end)

                    if Library.OpenFrames[CopyPasteMenu] then
                        Library.OpenFrames[CopyPasteMenu] = nil
                    end
                end

                local Descendants = CopyPasteWindow:GetDescendants()
                table.insert(Descendants, CopyPasteWindow)

                for _, Value in Descendants do
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    Value.ZIndex = CopyPasteMenu.IsOpen and 4 or 1
                end
            end

            function Colorpicker:SetOpen(Bool)
                if Debounce then
                    return
                end

                Colorpicker.IsOpen = Bool

                Debounce = true

                if Colorpicker.IsOpen then
                    ColorpickerWindow.Parent = Library.Holder.Instance
                    ColorpickerWindow.Position = ResolveAttachedFramePosition(ColorpickerWindow)
                    ColorpickerWindow.Visible = true
                    Items["ColorpickerWindow"]:Tween({
                        Position = ResolveAttachedFramePosition(ColorpickerWindow)
                    })

                    Items["ColorpickerWindow"]:FadeDescendants(true, function()
                        Colorpicker.CanUpdateNow = true
                        Debounce = false
                    end)

                    for Index, Value in Library.OpenFrames do
                        if not Data.Section.IsSettings then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Colorpicker] = Colorpicker
                else
                    Items["ColorpickerWindow"]:Tween({
                        Position = ResolveAttachedFramePosition(ColorpickerWindow)
                    })
                    Items["ColorpickerWindow"]:FadeDescendants(false, function()
                        ColorpickerWindow.Parent = Library.UnusedHolder.Instance
                        Colorpicker.CanUpdateNow = false
                        Debounce = false
                    end)

                    if Library.OpenFrames[Colorpicker] then
                        Library.OpenFrames[Colorpicker] = nil
                    end

                    if RenderStepped then
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = ColorpickerWindow:GetDescendants()
                table.insert(Descendants, ColorpickerWindow)

                for Index, Value in Descendants do
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    Value.ZIndex = Colorpicker.IsOpen and 4 or 1
                end

                Items["PaletteDragger"].Instance.ZIndex = 5
                Items["HueDragger"].Instance.ZIndex = 5
                Items["AlphaDragger"].Instance.ZIndex = 5
                Items["Shadow"].Instance.ZIndex = 3
            end

            local SlidingPalette = false
            local PaletteChanged

            function Colorpicker:SlidePalette(Input)
                if not Input or not SlidingPalette then
                    return
                end

                local ValueX = math.clamp(
                    1 -
                    (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) /
                    Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
                local ValueY = math.clamp(
                    1 -
                    (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) /
                    Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

                Colorpicker.Saturation = ValueX
                Colorpicker.Value = ValueY

                local SlideX = math.clamp(
                    (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) /
                    Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
                local SlideY = math.clamp(
                    (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) /
                    Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

                Items["PaletteDragger"]:Tween({ Position = UDim2.new(SlideX, 0, SlideY, 0) },
                    TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update()
            end

            local SlidingHue = false
            local HueChanged

            function Colorpicker:SlideHue(Input)
                if not Input or not SlidingHue then
                    return
                end

                local ValueY = math.clamp(
                    (Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y,
                    0,
                    1)

                Colorpicker.Hue = ValueY

                local SlideY = math.clamp(
                    (Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y,
                    0,
                    1)

                Items["HueDragger"]:Tween({ Position = UDim2.new(0, 0, SlideY, 0) },
                    TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update()
            end

            local SlidingAlpha = false
            local AlphaChanged

            function Colorpicker:SlideAlpha(Input)
                if not Input or not SlidingAlpha then
                    return
                end

                local ValueX = math.clamp(
                    (Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) /
                    Items["Alpha"].Instance.AbsoluteSize.X,
                    0, 1)

                Colorpicker.Alpha = ValueX

                local SlideX = math.clamp(
                    (Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) /
                    Items["Alpha"].Instance.AbsoluteSize.X,
                    0, 1)

                Items["AlphaDragger"]:Tween({ Position = UDim2.new(SlideX, 0, 0, 0) },
                    TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update(true)
            end

            function Colorpicker:Set(Color, Alpha)
                if type(Color) == "table" then
                    Color = Color3.fromRGB(Color[1], Color[2], Color[3])
                elseif type(Color) == "string" then
                    Color = Color3.fromHex(Color)
                else
                    Color = Color -- lul
                end

                Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
                Colorpicker.Alpha = Alpha or 0

                local PaletteValueX = math.clamp(1 - Colorpicker.Saturation, 0, 1)
                local PaletteValueY = math.clamp(1 - Colorpicker.Value, 0, 1)

                local AlphaPositionX = math.clamp(Colorpicker.Alpha, 0, 1)

                local HuePositionY = math.clamp(Colorpicker.Hue, 0, 1)

                Items["PaletteDragger"]:Tween({ Position = UDim2.new(PaletteValueX, 0, PaletteValueY, 0) },
                    TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Items["HueDragger"]:Tween({ Position = UDim2.new(0, 0, HuePositionY, 0) },
                    TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Items["AlphaDragger"]:Tween({ Position = UDim2.new(AlphaPositionX, 0, 0, 0) },
                    TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update()
            end

            Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
                if CopyPasteMenu.IsOpen then
                    CopyPasteMenu:SetOpen(false)
                end

                Colorpicker:SetOpen(not Colorpicker.IsOpen)
            end)

            Items["ColorpickerButton"]:Connect("MouseButton2Down", function()
                CopyPasteMenu:SetOpen(not CopyPasteMenu.IsOpen)
            end)

            Items["CopyButton"]:Connect("MouseButton1Down", function()
                Library.CopiedColor = Colorpicker.Color

                if CopyToClipboard then
                    pcall(CopyToClipboard, "#" .. Colorpicker.HexValue)
                end

                CopyPasteMenu:SetOpen(false)
            end)

            Items["PasteButton"]:Connect("MouseButton1Down", function()
                if Library.CopiedColor then
                    Colorpicker:Set(Library.CopiedColor, Colorpicker.Alpha)
                end

                CopyPasteMenu:SetOpen(false)
            end)

            Items["Palette"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingPalette = true

                    Colorpicker:SlidePalette(Input)

                    if PaletteChanged then
                        return
                    end

                    PaletteChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingPalette = false

                            PaletteChanged:Disconnect()
                            PaletteChanged = nil
                        end
                    end)
                end
            end)

            Items["Hue"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingHue = true

                    Colorpicker:SlideHue(Input)

                    if HueChanged then
                        return
                    end

                    HueChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingHue = false

                            HueChanged:Disconnect()
                            HueChanged = nil
                        end
                    end)
                end
            end)

            Items["Alpha"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingAlpha = true

                    Colorpicker:SlideAlpha(Input)

                    if AlphaChanged then
                        return
                    end

                    AlphaChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingAlpha = false

                            AlphaChanged:Disconnect()
                            AlphaChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if SlidingPalette then
                        Colorpicker:SlidePalette(Input)
                    end

                    if SlidingHue then
                        Colorpicker:SlideHue(Input)
                    end

                    if SlidingAlpha then
                        Colorpicker:SlideAlpha(Input)
                    end
                end
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if not Colorpicker.IsOpen then
                        if CopyPasteMenu.IsOpen and not Items["CopyPasteWindow"]:IsMouseOverFrame() then
                            CopyPasteMenu:SetOpen(false)
                        end

                        return
                    end

                    if Items["ColorpickerWindow"]:IsMouseOverFrame() then
                        return
                    end

                    Colorpicker:SetOpen(false)
                end
            end)

            if Data.Default then
                Colorpicker:Set(Data.Default, Data.Alpha)
            end

            SetFlags[Colorpicker.Flag] = function(Value, Alpha)
                Colorpicker:Set(Value, Alpha)
            end

            return Colorpicker, Items
        end

        Library.CreateKeybind = function(Self, Data)
            local Keybind = {
                Flag = Data.Flag,
                IsOpen = false,

                Key = "",
                Mode = "",
                Value = "",

                Toggled = false,
                Picking = false,

                Items = {}
            }

            local Items = {}
            do
                Items["KeyButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Data.Parent.Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "[...]",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                Items["KeybindWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.UnusedHolder.Instance,
                    Visible = false,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0.7021276354789734, 0, 0.4859813153743744, 0),
                    Size = UDim2.new(0, 200, 0, 82),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = 'Background' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Items["AccentLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = 'Accent' })

                Keybind.Items = Items
            end

            local KeybindObject

            if Library.KeyList then
                KeybindObject = Library.KeyList:Add("", "", "")
            end

            local Update = function()
                if KeybindObject then
                    KeybindObject:SetStatus(Keybind.Toggled)
                    KeybindObject:Set(Keybind.Value, Data.Name, Keybind.Mode)
                end
            end

            local Debounce = false
            local RenderStepped
            local KeybindWindow = Items["KeybindWindow"].Instance
            local KeyButton = Items["KeyButton"].Instance

            Keybind.AttachedButton = KeyButton
            Keybind.CanUpdateNow = false
            Keybind.Frame = KeybindWindow

            local ModeDropdown = Library:Dropdown({
                Name = "Mode",
                Flag = Data.Flag .. "Mode",
                Parent = Items["KeybindWindow"],
                Items = { "Toggle", "Hold", "Always" },
                Default = "Toggle",
                Callback = function(Value)
                    Keybind.Mode = Value
                    if Value == "Always" then
                        Keybind.Toggled = true
                    end

                    Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                end
            })

            local ShowInKeybindsList = Library:Toggle({
                Name = "Show in keybinds list",
                Flag = Data.Flag .. "ShowInKeybindsList",
                Parent = Items["KeybindWindow"],
                Default = true,
                Callback = function(Value)
                    if KeybindObject then
                        KeybindObject:SetVis(Value)
                        Update()
                    end
                end
            })

            ShowInKeybindsList.Items.Toggle.Instance.Position = UDim2.new(0, 8, 1, -8)
            ShowInKeybindsList.Items.Toggle.Instance.Size = UDim2.new(1, -16, 0, 12)
            ShowInKeybindsList.Items.Toggle.Instance.AnchorPoint = Vector2.new(0, 1)
            ShowInKeybindsList.Items.Indicator.Instance.Position = UDim2.new(0, 0, 0.5, 0)
            ShowInKeybindsList.Items.Text.Instance.Position = UDim2.new(0, 15, 0.5, -1)

            ModeDropdown.Items.Dropdown.Instance.Position = UDim2.new(0, 8, 0, 8)
            ModeDropdown.Items.Dropdown.Instance.Size = UDim2.new(1, -16, 0, 40)

            function Keybind:SetOpen(Bool)
                if Debounce then
                    return
                end

                Keybind.IsOpen = Bool

                Debounce = true

                if Keybind.IsOpen then
                    KeybindWindow.Position = UDim2.new(0, KeyButton.AbsolutePosition.X, 0,
                        KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y + GuiInset)

                    KeybindWindow.Parent = Library.Holder.Instance
                    KeybindWindow.Visible = true
                    Items["KeybindWindow"]:Tween({
                        Position = UDim2.new(0, KeyButton.AbsolutePosition.X, 0,
                            KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y + 10 + GuiInset)
                    })

                    Items["KeybindWindow"]:FadeDescendants(true, function()
                        Debounce = false
                        Keybind.CanUpdateNow = true
                    end)

                    for Index, Value in Library.OpenFrames do
                        if not Data.Section.IsSettings then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Keybind] = Keybind
                else
                    Items["KeybindWindow"]:Tween({
                        Position = UDim2.new(0, KeyButton.AbsolutePosition.X, 0,
                            KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y - 10 + GuiInset)
                    })
                    Items["KeybindWindow"]:FadeDescendants(false, function()
                        Items["KeybindWindow"].Instance.Parent = Library.UnusedHolder.Instance
                        Debounce = false
                        Keybind.CanUpdateNow = false
                    end)

                    if Library.OpenFrames[Keybind] then
                        Library.OpenFrames[Keybind] = nil
                    end

                    if RenderStepped then
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = KeybindWindow:GetDescendants()
                table.insert(Descendants, KeybindWindow)

                for Index, Value in Descendants do
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    Value.ZIndex = Keybind.IsOpen and 4 or 1
                end
            end

            function Keybind:SetMode(Mode)
                ModeDropdown:Set(Mode)
                if Mode == "Always" then
                    Keybind.Toggled = true
                end

                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            end

            function Keybind:Press(Bool)
                if Keybind.Mode == "Toggle" then
                    Keybind.Toggled = not Keybind.Toggled
                elseif Keybind.Mode == "Hold" then
                    Keybind.Toggled = Bool
                elseif Keybind.Mode == "Always" then
                    Keybind.Toggled = true
                end

                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            end

            function Keybind:Set(Key)
                if string.find(tostring(Key), "Enum") then
                    Keybind.Key = tostring(Key)

                    Key = Key.Name == "Backspace" and "None" or Key.Name

                    local KeyString = Keys[Keybind.Key] or string.gsub(Key, "Enum.", "") or "None"
                    local TextToDisplay = string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "") or
                        "None"

                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = "[" .. TextToDisplay .. "]"

                    Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                elseif type(Key) == "table" then
                    local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                    Keybind.Key = tostring(Key.Key)

                    if Key.Mode then
                        Keybind.Mode = Key.Mode
                        Keybind:SetMode(Key.Mode)
                    else
                        Keybind.Mode = "Toggle"
                        Keybind:SetMode("Toggle")
                    end

                    local KeyString = Keys[Keybind.Key] or string.gsub(tostring(RealKey), "Enum.", "") or RealKey
                    local TextToDisplay = KeyString and
                        string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                    TextToDisplay = string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "")

                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = "[" .. TextToDisplay .. "]"
                    if Keybind.Mode == "Always" then
                        Keybind.Toggled = true
                    elseif type(Key.Toggled) == "boolean" then
                        Keybind.Toggled = Key.Toggled
                    end

                    Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                elseif table.find({ "Toggle", "Hold", "Always" }, Key) then
                    Keybind.Mode = Key
                    Keybind:SetMode(Key)

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                end

                Keybind.Picking = false
            end

            Items["KeyButton"]:Connect("MouseButton1Click", function()
                if Keybind.Disabled then
                    return
                end

                Keybind.Picking = true

                Items["KeyButton"].Instance.Text = "press a key"

                local InputBegan
                InputBegan = UserInputService.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.Keyboard then
                        Keybind:Set(Input.KeyCode)
                    else
                        Keybind:Set(Input.UserInputType)
                    end

                    InputBegan:Disconnect()
                    InputBegan = nil
                end)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input, GPE)
                if Keybind.Value == "None" then
                    return
                end

                if not GPE then
                    if tostring(Input.KeyCode) == Keybind.Key then
                        if Keybind.Mode == "Toggle" then
                            Keybind:Press()
                        elseif Keybind.Mode == "Hold" then
                            Keybind:Press(true)
                        elseif Keybind.Mode == "Always" then
                            Keybind:Press(true)
                        end
                    elseif tostring(Input.UserInputType) == Keybind.Key then
                        if Keybind.Mode == "Toggle" then
                            Keybind:Press()
                        elseif Keybind.Mode == "Hold" then
                            Keybind:Press(true)
                        elseif Keybind.Mode == "Always" then
                            Keybind:Press(true)
                        end
                    end
                end

                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if not Keybind.IsOpen then
                        return
                    end

                    if Items["KeybindWindow"]:IsMouseOverFrame() or ModeDropdown.Items.OptionHolder:IsMouseOverFrame() then
                        return
                    end

                    Keybind:SetOpen(false)
                end
            end)

            Library:Connect(UserInputService.InputEnded, function(Input, GPE)
                if GPE then
                    return
                end

                if Keybind.Value == "None" then
                    return
                end

                if tostring(Input.KeyCode) == Keybind.Key then
                    if Keybind.Mode == "Hold" then
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then
                        Keybind:Press(true)
                    end
                elseif tostring(Input.UserInputType) == Keybind.Key then
                    if Keybind.Mode == "Hold" then
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then
                        Keybind:Press(true)
                    end
                end
            end)

            Items["KeyButton"]:Connect("MouseButton2Down", function()
                Keybind:SetOpen(not Keybind.IsOpen)
            end)

            if Data.Default then
                Keybind:Set({
                    Mode = Data.Mode or "Toggle",
                    Key = Data.Default,
                })
            end

            SetFlags[Keybind.Flag] = function(Value)
                Keybind:Set(Value)
            end

            return Keybind, Items
        end

        Library.Watermark = function(Self, Params)
            local Watermark = {}
            local PrefixText = tostring((Params and Params.Name) or "niggahack")
            local WatermarkTick = tick()
            local WatermarkFps = 0
            local WatermarkDisplayedFps = 0
            local WatermarkStatsText = ""
            local DynamicTextProvider = nil
            local DynamicText = PrefixText
            local DynamicTextTick = 0
            local WatermarkLastShimmerTime = tick()
            local WatermarkShimmerPhase = 0

            local Items = {}
            do
                Items["Watermark"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 42),
                    Size = UDim2.new(0, 0, 0, 25),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = 'Background' })

                Items["Watermark"]:MakeDraggable()

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Items["DarkLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    Position = UDim2.new(0, -8, 0, 1),
                    Size = UDim2.new(1, 16, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Light Border"]
                }):AddToTheme({ BackgroundColor3 = 'Light Border' })

                Items["AccentLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    Position = UDim2.new(0, -8, 0, 0),
                    Size = UDim2.new(1, 16, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = 'Accent' })

                Items["AccentGradient"] = Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["AccentLiner"].Instance,
                    Offset = Vector2.new(0, 0),
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0),
                        NumberSequenceKeypoint.new(0.5, 1),
                        NumberSequenceKeypoint.new(1, 0),
                    })
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Watermark"].Instance,
                    RichText = true,
                    TextColor3 = Library.Theme["Text"],
                    Text = PrefixText,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })
            end

            function Watermark:SetVisibility(Bool)
                Items["Watermark"].Instance.Visible = Bool
            end

            function Watermark:Center()
                local AbsPos = Items["Watermark"].Instance.AbsolutePosition
                Items["Watermark"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["Watermark"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            function Watermark:SetText(Text)
                DynamicTextProvider = nil
                PrefixText = tostring(Text or "")
                DynamicText = PrefixText
                Items["Text"].Instance.Text = PrefixText
            end

            function Watermark:SetDynamicTextProvider(Callback)
                DynamicTextProvider = type(Callback) == "function" and Callback or nil
                DynamicTextTick = 0
                DynamicText = PrefixText
            end

            function Watermark:SetName(Text)
                self:SetText(Text)
            end

            function Watermark:GetBounds()
                local Instance = Items["Watermark"].Instance
                return Instance.AbsolutePosition, Instance.AbsoluteSize
            end

            Library:RegisterLayout("Watermark", {
                Instance = Items["Watermark"].Instance
            })

            Library:Connect(RunService.RenderStepped, function()
                if not Items["Watermark"].Instance.Visible then
                    return
                end

                local CurrentTick = tick()
                WatermarkFps += 1

                if CurrentTick - WatermarkLastShimmerTime >= (1 / 30) then
                    WatermarkShimmerPhase = (WatermarkShimmerPhase + (CurrentTick - WatermarkLastShimmerTime) * (1 / 1.2)) %
                        1
                    WatermarkLastShimmerTime = CurrentTick
                    if DynamicTextProvider and (CurrentTick - DynamicTextTick) >= 0.25 then
                        DynamicTextTick = CurrentTick
                        DynamicText = tostring(DynamicTextProvider(WatermarkDisplayedFps) or "")
                    end
                    local PlainText = DynamicTextProvider and DynamicText or (PrefixText .. WatermarkStatsText)
                    local ShineWidth = 6
                    local ShinePos = WatermarkShimmerPhase * (#PlainText + ShineWidth)
                    local Rich = {}
                    for Index = 1, #PlainText do
                        local Distance = math.abs(Index - ShinePos)
                        local Alpha = math.clamp(1 - (Distance / ShineWidth), 0, 1)
                        local Color = Library.Theme["Text"]:Lerp(Library.Theme["Accent"], Alpha)
                        Rich[#Rich + 1] = string.format(
                            '<font color="rgb(%d,%d,%d)">%s</font>',
                            math.floor(Color.R * 255),
                            math.floor(Color.G * 255),
                            math.floor(Color.B * 255),
                            PlainText:sub(Index, Index)
                        )
                    end

                    Items["AccentGradient"].Instance.Offset = Vector2.new((WatermarkShimmerPhase * 2) - 1, 0)
                    Items["Text"].Instance.Text = table.concat(Rich)
                end

                if CurrentTick - WatermarkTick >= 1 then
                    WatermarkTick = CurrentTick
                    WatermarkDisplayedFps = WatermarkFps
                    if not DynamicTextProvider then
                        WatermarkStatsText = string.format(
                            ' / %s / %sfps',
                            os.date("%a %b %d %X %Y"),
                            WatermarkDisplayedFps
                        )
                    else
                        WatermarkStatsText = ""
                    end
                    WatermarkFps = 0
                end
            end)

            Watermark:Center()

            return Watermark
        end

        Library.KeybindList = function(Self, Params)
            local KeybindList = {}
            Library.KeyList = KeybindList

            local Items = {}
            do
                Items["KeybindList"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 10, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = 'Background' })

                Items["KeybindList"]:MakeDraggable()

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["KeybindList"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Params.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    PaddingTop = UDim.new(0, 4),
                    PaddingBottom = UDim.new(0, 4),
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })

                Items["AccentLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    Position = UDim2.new(0, -2, 0, 20),
                    Size = UDim2.new(1, 4, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = 'Accent' })

                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 25),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Padding = UDim.new(0, 2),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    PaddingTop = UDim.new(0, 4),
                    PaddingBottom = UDim.new(0, 4),
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })
            end

            function KeybindList:SetVisibility(Bool)
                Items["KeybindList"].Instance.Visible = Bool
            end

            function KeybindList:Center()
                local AbsPos = Items["KeybindList"].Instance.AbsolutePosition
                Items["KeybindList"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["KeybindList"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            function KeybindList:SetText(Text)
                Items["KeybindList"].Instance.Text = Text
            end

            function KeybindList:Add(Key, Name, Mode)
                local CanShowInKeybindsList = true

                local NewKey = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Content"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Key .. " - " .. Name .. " - " .. Mode,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                function NewKey:Set(Key, Name, Mode)
                    NewKey.Instance.Text = Key .. " - " .. Name .. " - " .. Mode
                end

                function NewKey:SetStatus(Bool)
                    if not CanShowInKeybindsList then
                        Bool = false
                    end

                    NewKey.Instance.Visible = Bool
                end

                function NewKey:SetVis(Bool)
                    CanShowInKeybindsList = Bool
                end

                return NewKey
            end

            KeybindList.Items = Items

            Library:RegisterLayout("KeybindList", {
                Instance = Items["KeybindList"].Instance
            })

            return KeybindList
        end

        Library.Notification = function(Self, Name, Duration, Color)
            local Items = {}
            do
                Items["Notification"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.NotifHolder.Instance,
                    Size = UDim2.new(0, 0, 0, 20),
                    Position = UDim2.new(0, 471, 0, 678),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = 'Section' })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })

                Items["Stroke"] = Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Items["Stroke1"] = Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Items["AccentLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    Position = UDim2.new(0, -8, 0, 0),
                    Size = UDim2.new(0, 1, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Notification"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 2, 0.5, -1),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })
            end

            for Index, Value in Items do
                if Value.Instance:IsA("Frame") then
                    Value.Instance.BackgroundTransparency = 1
                elseif Value.Instance:IsA("TextLabel") then
                    Value.Instance.TextTransparency = 1
                elseif Value.Instance:IsA("UIStroke") then
                    Value.Instance.Transparency = 1
                end
            end

            local GetSize = function()
                local AbsSize = Items["Notification"].Instance.AbsoluteSize
                Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.None
                task.wait()
                Items["Notification"].Instance.Size = UDim2.new(0, AbsSize.X, 0, AbsSize.Y)
                return AbsSize
            end

            local Size = GetSize()
            task.wait()
            Items["Notification"].Instance.Size = UDim2.new(0, 0, 0, Size.Y)

            local Info = TweenInfo.new(0.85, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0)

            Library:Thread(function()
                for Index, Value in Items do
                    if Value.Instance:IsA("Frame") then
                        Value:Tween({ BackgroundTransparency = 0 }, Info)
                    elseif Value.Instance:IsA("TextLabel") then
                        Value:Tween({ TextTransparency = 0 }, Info)
                    elseif Value.Instance:IsA("UIStroke") then
                        Value:Tween({ Transparency = 0 }, Info)
                    end
                end

                Items["Notification"]:Tween({ Size = UDim2.new(0, Size.X, 0, Size.Y) }, Info)

                task.delay(Duration + 0.1, function()
                    for Index, Value in Items do
                        if Value.Instance:IsA("Frame") then
                            Value:Tween({ BackgroundTransparency = 1 })
                        elseif Value.Instance:IsA("TextLabel") then
                            Value:Tween({ TextTransparency = 1 })
                        elseif Value.Instance:IsA("UIStroke") then
                            Value:Tween({ Transparency = 1 })
                        end
                    end

                    Items["Notification"]:Tween({ Size = UDim2.new(0, 0, 0, Size.Y) }, Info)
                    task.wait(0.5)
                    Items["Notification"].Instance:Destroy()
                end)
            end)
        end

        Library.ESPPreview = function(Self, Params)
            local Preview = {
                Player = nil
            }

            local AlignPreviewToWindow = function(Frame)
                local MainWindow = Library.MainWindowFrame

                if not MainWindow then
                    return
                end

                local MainPos = MainWindow.Position
                local MainSize = MainWindow.AbsoluteSize

                Frame.Position = UDim2.new(0, MainPos.X.Offset + MainSize.X + 10, 0, MainPos.Y.Offset)
            end

            local Items = {}
            do
                Items["ESPPreview"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Position = UDim2.new(0, 860, 0, 430),
                    Size = UDim2.new(0, 258, 0, 334),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = 'Background' })

                Items["ESPPreview"]:MakeDraggable()

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ESPPreview"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ESPPreview"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Items["AccentLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ESPPreview"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = 'Accent' })

                Items["DarkLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ESPPreview"].Instance,
                    Position = UDim2.new(0, 0, 0, 1),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Light Border"]
                }):AddToTheme({ BackgroundColor3 = 'Light Border' })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ESPPreview"].Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = Params.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    Position = UDim2.new(0, 10, 0, 6),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Accent' })

                Items["Background"] = Library:Create("TextButton", {
                    Name = "\0",
                    Parent = Items["ESPPreview"].Instance,
                    Active = false,
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 10, 0, 30),
                    Size = UDim2.new(1, -20, 1, -40),
                    Selectable = false,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = 'Section' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Items["Viewport"] = Library:Create("ViewportFrame", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })
            end

            AlignPreviewToWindow(Items["ESPPreview"].Instance)

            local IsVisible = true
            local ApplyVisibility = function(IsWindowOpen)
                Items["ESPPreview"].Instance.Visible = IsVisible and IsWindowOpen
            end

            Library:BindToWindowVisibility(ApplyVisibility)

            function Preview:SetVisibility(Bool)
                IsVisible = Bool
                ApplyVisibility(Library.WindowOpenState)
            end

            function Preview:SetText(Text)
                Items["Text"].Instance.Text = Text
            end

            local ViewportCamera = Instance.new("Camera")

            Items["Viewport"].Instance.CurrentCamera = ViewportCamera
            ViewportCamera.CameraType = Enum.CameraType.Track
            ViewportCamera.Focus = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
            ViewportCamera.CFrame = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)

            local PreviewModel = nil
            local RenderObjects = table.create(25)
            local Connections = {}

            local OFFSET = CFrame.new(0, 2.5, -8.5)

            local ValidClasses = {
                MeshPart = true,
                Part = true,
                Accoutrement = true,
                Pants = true,
                Shirt = true,
                Humanoid = true,
                BoxHandleAdornment = true,
                CylinderHandleAdornment = true,
                Highlight = true
            }

            local function DisconnectAll()
                for _, Connection in ipairs(Connections) do
                    Connection:Disconnect()
                end
                table.clear(Connections)
            end

            local function ClearViewport()
                table.clear(RenderObjects)
                for _, Obj in ipairs(Items["Viewport"].Instance:GetChildren()) do
                    if not Obj:IsA("Camera") then
                        Obj:Destroy()
                    end
                end
            end

            function Preview:RemoveObject(Object)
                local Clone = RenderObjects[Object]
                if not Clone then
                    return
                end

                RenderObjects[Object] = nil

                if Clone.Parent and Clone.Parent:IsA("Accoutrement") then
                    Clone.Parent:Destroy()
                else
                    Clone:Destroy()
                end
            end

            function Preview:AddObject(Object)
                if not Object or not ValidClasses[Object.ClassName] then
                    return
                end

                local IsArchivable = Object.Archivable
                Object.Archivable = true
                local Clone = Object:Clone()
                Object.Archivable = IsArchivable

                if Object:IsA("BasePart") then
                    RenderObjects[Object] = Clone
                elseif Object:IsA("Accoutrement") then
                    if Object:FindFirstChild("Handle") and Clone:FindFirstChild("Handle") then
                        RenderObjects[Object.Handle] = Clone.Handle
                    end
                elseif Object:IsA("Humanoid") then
                    Clone:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    Clone:SetStateEnabled(Enum.HumanoidStateType.Running, false)
                    Clone:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
                    Clone:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
                    Clone:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
                    Clone:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    Clone:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
                    Clone:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
                    Clone:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
                    Clone:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
                    Clone:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
                    Clone:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                    Clone:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
                    Clone:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    Clone:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
                    Clone:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                    Clone.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                end

                return Clone
            end

            function Preview:BuildFromModel(Model)
                ClearViewport()
                DisconnectAll()

                PreviewModel = Model
                Preview.Player = Model

                if not Model then
                    return
                end

                local Viewmodel = Instance.new("Model")
                Viewmodel.Name = "Viewmodel"
                Viewmodel.Parent = Items["Viewport"].Instance

                for _, Object in ipairs(Model:GetDescendants()) do
                    local Clone = self:AddObject(Object)
                    if Clone then
                        Clone.Parent = Viewmodel
                    end
                end

                table.insert(Connections, Model.DescendantAdded:Connect(function(Object)
                    local Clone = self:AddObject(Object)
                    if Clone then
                        Clone.Parent = Viewmodel
                    end
                end))

                table.insert(Connections, Model.DescendantRemoving:Connect(function(Object)
                    self:RemoveObject(Object)
                end))
            end

            Library:Connect(RunService.Heartbeat, function()
                if not PreviewModel or not Items["ESPPreview"].Instance.Visible then
                    return
                end

                local Root = PreviewModel:FindFirstChild("HumanoidRootPart")
                if not Root then
                    return
                end

                ViewportCamera.CFrame = CFrame.new(Root.CFrame:ToWorldSpace(OFFSET).Position, Root.Position)

                for Original, Clone in pairs(RenderObjects) do
                    if Original and Original.Parent then
                        Clone.CFrame = Original.CFrame
                    else
                        Preview:RemoveObject(Original)
                    end
                end
            end)

            task.spawn(function()
                local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                Preview:BuildFromModel(Character)
            end)

            Library:Connect(LocalPlayer.CharacterAdded, function(NewCharacter)
                task.wait(1)
                Preview:BuildFromModel(NewCharacter)
            end)

            Library:RegisterLayout("ESPPreview", {
                Instance = Items["ESPPreview"].Instance
            })

            return Preview
        end

        Library.ModeratorList = function(Self, Params)
            local ModeratorList = {
                Entries = {}
            }

            local AlignModeratorListToWindow = function(Frame)
                local MainWindow = Library.MainWindowFrame

                if not MainWindow then
                    return
                end

                local MainPos = MainWindow.Position
                local MainSize = MainWindow.AbsoluteSize

                Frame.Position = UDim2.new(0, MainPos.X.Offset + MainSize.X + 10, 0, MainPos.Y.Offset + 96)
            end

            local Items = {}
            do
                Items["ModeratorList"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Position = UDim2.new(0, 860, 0, 410),
                    Size = UDim2.new(0, 228, 0, 170),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = 'Background' })

                Items["ModeratorList"]:MakeDraggable()

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ModeratorList"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ModeratorList"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Items["AccentLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ModeratorList"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = 'Accent' })

                Items["DarkLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ModeratorList"].Instance,
                    Position = UDim2.new(0, 0, 0, 1),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Light Border"]
                }):AddToTheme({ BackgroundColor3 = 'Light Border' })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ModeratorList"].Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = Params.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    Position = UDim2.new(0, 10, 0, 6),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Accent' })

                Items["Background"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ModeratorList"].Instance,
                    Position = UDim2.new(0, 10, 0, 30),
                    Size = UDim2.new(1, -20, 1, -40),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = 'Section' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Items["Holder"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    Active = true,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 6, 0, 6),
                    Size = UDim2.new(1, -12, 1, -12),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    AutomaticCanvasSize = Enum.AutomaticSize.None,
                    ScrollBarThickness = 1,
                    ScrollingDirection = Enum.ScrollingDirection.Y
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    Padding = UDim.new(0, 4),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Empty"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Holder"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "No moderators detected",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, -2, 0, 15),
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = 'Text' })
            end

            AlignModeratorListToWindow(Items["ModeratorList"].Instance)

            local IsVisible = true
            local ApplyVisibility = function()
                Items["ModeratorList"].Instance.Visible = IsVisible
            end

            local UpdateCanvas = function()
                local Layout = Items["Holder"].Instance:FindFirstChildOfClass("UIListLayout")
                if Layout then
                    Items["Holder"].Instance.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
                end
            end

            local UpdateEmptyState = function()
                Items["Empty"].Instance.Visible = next(ModeratorList.Entries) == nil
                UpdateCanvas()
            end

            local Layout = Items["Holder"].Instance:FindFirstChildOfClass("UIListLayout")
            if Layout then
                Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)
            end

            function ModeratorList:SetVisibility(Bool)
                IsVisible = Bool
                ApplyVisibility()
            end

            function ModeratorList:Center()
                local AbsPos = Items["ModeratorList"].Instance.AbsolutePosition
                Items["ModeratorList"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["ModeratorList"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            function ModeratorList:SetText(Text)
                Items["Text"].Instance.Text = Text
            end

            function ModeratorList:Add(PlayerName, Reason)
                local Entry = ModeratorList.Entries[PlayerName]
                if Entry then
                    Entry:Set(Reason)
                    return Entry
                end

                local EntryItems = {}
                do
                    EntryItems["Row"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Items["Holder"].Instance,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -2, 0, 28),
                        BorderSizePixel = 0
                    })

                    EntryItems["Name"] = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = EntryItems["Row"].Instance,
                        TextColor3 = Library.Theme["Accent"],
                        Text = PlayerName,
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Size = UDim2.new(1, 0, 0, 13),
                        BorderSizePixel = 0
                    }):AddToTheme({ TextColor3 = 'Accent' })

                    EntryItems["Reason"] = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = EntryItems["Row"].Instance,
                        TextColor3 = Library.Theme["Text"],
                        Text = Reason,
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Size = UDim2.new(1, 0, 0, 13),
                        Position = UDim2.new(0, 0, 0, 15),
                        BorderSizePixel = 0
                    }):AddToTheme({ TextColor3 = 'Text' })
                end

                Entry = EntryItems

                function Entry:Set(NewReason)
                    EntryItems["Reason"].Instance.Text = NewReason
                end

                function Entry:Remove()
                    ModeratorList.Entries[PlayerName] = nil
                    EntryItems["Row"].Instance:Destroy()
                    UpdateEmptyState()
                end

                ModeratorList.Entries[PlayerName] = Entry
                UpdateEmptyState()

                return Entry
            end

            function ModeratorList:Remove(PlayerName)
                local Entry = ModeratorList.Entries[PlayerName]
                if not Entry then
                    return
                end

                ModeratorList.Entries[PlayerName] = nil
                Entry["Row"].Instance:Destroy()
                UpdateEmptyState()
            end

            function ModeratorList:Clear()
                for PlayerName, Entry in next, ModeratorList.Entries do
                    ModeratorList.Entries[PlayerName] = nil
                    Entry["Row"].Instance:Destroy()
                end

                UpdateEmptyState()
            end

            ApplyVisibility()
            UpdateEmptyState()

            Library:RegisterLayout("ModeratorList", {
                Instance = Items["ModeratorList"].Instance
            })

            return ModeratorList
        end

        Library.ConsoleLogger = function(Self, Params)
            local Logger = {}
            local CommandCallback = Params.Callback or Params.callback or function() end

            local AlignLoggerToWindow = function(Frame)
                local MainWindow = Library.MainWindowFrame

                if not MainWindow then
                    return
                end

                local MainPos = MainWindow.Position
                local MainSize = MainWindow.AbsoluteSize

                -- Match main window width, keep logger shorter, and place it clearly below the main window.
                Frame.Size = UDim2.new(0, MainSize.X, 0, 220)
                Frame.Position = UDim2.new(0, MainPos.X.Offset, 0, MainPos.Y.Offset + MainSize.Y + 10)
            end

            local Items = {}
            do
                Items["CallLogger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Visible = true,
                    Position = UDim2.new(0, 860, 0, 132),
                    Size = UDim2.new(0, 474, 0, 262),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = 'Background' })

                Items["CallLogger"]:MakeDraggable()

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["CallLogger"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["CallLogger"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Items["AccentLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["CallLogger"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = 'Accent' })

                Items["DarkLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["CallLogger"].Instance,
                    Position = UDim2.new(0, 0, 0, 1),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Light Border"]
                }):AddToTheme({ BackgroundColor3 = 'Light Border' })

                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["CallLogger"].Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = Params.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    Position = UDim2.new(0, 10, 0, 6),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Accent' })

                Items["Background"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["CallLogger"].Instance,
                    Position = UDim2.new(0, 10, 0, 30),
                    Size = UDim2.new(1, -20, 1, -82),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = 'Section' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Items["Holder"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarImageColor3 = Library.Theme["Accent"],
                    MidImage = "rbxassetid://129030709932941",
                    ScrollBarThickness = 1,
                    Size = UDim2.new(1, -16, 1, -8),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 4),
                    BottomImage = "rbxassetid://129030709932941",
                    TopImage = "rbxassetid://129030709932941"
                }):AddToTheme({ ScrollBarImageColor3 = 'Accent' })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    PaddingRight = UDim.new(0, 8)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    Padding = UDim.new(0, 0),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["InputBackground"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["CallLogger"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 10, 1, -10),
                    Size = UDim2.new(1, -20, 0, 18),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({ BackgroundColor3 = 'Element' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["InputBackground"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["InputBackground"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["InputBackground"].Instance,
                    Rotation = -90,
                    Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 172, 172))
                    }
                })

                Items["Input"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["InputBackground"].Instance,
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    PlaceholderText = "type command and press enter",
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    Size = UDim2.new(1, -12, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 6, 0.5, -7),
                    ClearTextOnFocus = false,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    CursorPosition = -1
                }):AddToTheme({ TextColor3 = 'Text' })
            end

            AlignLoggerToWindow(Items["CallLogger"].Instance)

            local IsVisible = true
            local ApplyVisibility = function(IsWindowOpen)
                Items["CallLogger"].Instance.Visible = IsVisible and IsWindowOpen
            end

            Library:BindToWindowVisibility(ApplyVisibility)

            function Logger:SetVisibility(Bool)
                IsVisible = Bool
                ApplyVisibility(Library.WindowOpenState)
            end

            function Logger:Center()
                local AbsPos = Items["CallLogger"].Instance.AbsolutePosition
                Items["CallLogger"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["CallLogger"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            function Logger:SetText(Text)
                Items["Title"].Instance.Text = Text
            end

            function Logger:SetCommandCallback(Callback)
                CommandCallback = Callback or function() end
            end

            function Logger:AddError(Text)
                return Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Holder"].Instance,
                    TextColor3 = Color3.fromRGB(255, 41, 45),
                    Text = Text,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 15),
                    BorderSizePixel = 0
                })
            end

            function Logger:AddWarning(Text)
                return Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Holder"].Instance,
                    TextColor3 = Color3.fromRGB(255, 222, 32),
                    Text = Text,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 15),
                    BorderSizePixel = 0
                })
            end

            function Logger:AddOutput(Text)
                return Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Holder"].Instance,
                    TextColor3 = Color3.fromRGB(255, 222, 32),
                    Text = Text,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 15),
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = 'Text' })
            end

            function Logger:Clear()
                Items["InputBackground"]:ChangeItemTheme({ BackgroundColor3 = "Accent" })
                Items["InputBackground"]:Tween({ BackgroundColor3 = Library.Theme.Accent })
                task.wait(0.1)
                Items["InputBackground"]:ChangeItemTheme({ BackgroundColor3 = "Element" })
                Items["InputBackground"]:Tween({ BackgroundColor3 = Library.Theme.Element })

                for Index, Value in Items["Holder"].Instance:GetChildren() do
                    if Value:IsA("TextLabel") then
                        Value:Destroy()
                    end
                end
            end

            Items["Input"]:Connect("FocusLost", function(PressedEnter)
                if not PressedEnter then
                    return
                end

                local Text = Items["Input"].Instance.Text
                Items["Input"].Instance.Text = ""

                if Text == "" then
                    return
                end

                Library:SafeCall(CommandCallback, Text, Logger)
            end)

            Library:RegisterLayout("CallLogger", {
                Instance = Items["CallLogger"].Instance
            })

            return Logger
        end

        Library.RadarWidget = function(Self, Params)
            local Radar = {
                Entries = {},
                Range = 250,
                Visible = true
            }

            local Items = {}
            do
                Items["RadarWidget"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Visible = true,
                    Position = UDim2.new(0, 860, 0, 132),
                    Size = UDim2.new(0, 220, 0, 262),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = "Background" })

                Items["RadarWidget"]:MakeDraggable()

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["RadarWidget"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["RadarWidget"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Items["AccentLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RadarWidget"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = "Accent" })

                Items["DarkLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RadarWidget"].Instance,
                    Position = UDim2.new(0, 0, 0, 1),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Light Border"]
                }):AddToTheme({ BackgroundColor3 = "Light Border" })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RadarWidget"].Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = Params.Name or "Radar",
                    Size = UDim2.new(0, 0, 0, 15),
                    Position = UDim2.new(0, 10, 0, 6),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = "Accent" })

                Items["Background"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RadarWidget"].Instance,
                    Position = UDim2.new(0, 10, 0, 30),
                    Size = UDim2.new(1, -20, 1, -64),
                    ZIndex = 1,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = "Section" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Items["RadarBounds"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, -6),
                    Size = UDim2.new(1, -20, 1, -20),
                    ZIndex = 1,
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({ BackgroundColor3 = "Element" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["RadarBounds"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["RadarBounds"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Items["CenterDot"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RadarBounds"].Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0, 6, 0, 6),
                    ZIndex = 3,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = "Accent" })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["CenterDot"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })

                for _, LineData in next, {
                    { Name = "CrossX",     Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0.5, 0) },
                    { Name = "CrossY",     Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(0.5, 0, 0, 0) },
                    { Name = "GridTop",    Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0.25, 0) },
                    { Name = "GridBottom", Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0.75, 0) },
                    { Name = "GridLeft",   Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(0.25, 0, 0, 0) },
                    { Name = "GridRight",  Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(0.75, 0, 0, 0) }
                } do
                    Items[LineData.Name] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Items["RadarBounds"].Instance,
                        Size = LineData.Size,
                        Position = LineData.Position,
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Outline"],
                        BackgroundTransparency = LineData.Name:find("Cross") and 0.3 or 0.55
                    }):AddToTheme({ BackgroundColor3 = "Outline" })
                end

                Items["Footer"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RadarWidget"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "0 contacts | 250 studs",
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 10, 1, -8),
                    Size = UDim2.new(1, -20, 0, 15),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = "Text" })
            end

            local function ApplyVisibility()
                Items["RadarWidget"].Instance.Visible = Radar.Visible
            end

            local function CreateEntry(Key)
                local Entry = {}

                Entry.Dot = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RadarBounds"].Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0, 4, 0, 4),
                    ZIndex = 4,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = "Accent" })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Entry.Dot.Instance,
                    CornerRadius = UDim.new(0, 1)
                })

                Radar.Entries[Key] = Entry
                return Entry
            end

            Library:BindToWindowVisibility(ApplyVisibility)

            function Radar:SetVisibility(Bool)
                Radar.Visible = Bool
                ApplyVisibility()
            end

            function Radar:Center()
                local AbsPos = Items["RadarWidget"].Instance.AbsolutePosition
                Items["RadarWidget"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["RadarWidget"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            function Radar:SetText(Text)
                Items["Text"].Instance.Text = Text
            end

            function Radar:SetFooter(Text)
                Items["Footer"].Instance.Text = Text
            end

            function Radar:SetRange(Value)
                Radar.Range = Value
                Radar:SetFooter(("%d contacts | %d studs"):format(0, math.floor(Value or 0)))
            end

            function Radar:SetSweep(Angle)
                return Angle
            end

            function Radar:SetHeading(Angle)
                return Angle
            end

            function Radar:Upsert(Key, Data)
                local Entry = Radar.Entries[Key] or CreateEntry(Key)
                local Dot = Entry.Dot.Instance
                local Position = Data and Data.Position
                local Size = Data and Data.Size
                local Visible = Data and Data.Visible
                local Transparency = Data and Data.Transparency

                if typeof(Position) == "Vector2" then
                    Dot.Position = UDim2.new(0, Position.X, 0, Position.Y)
                end

                if typeof(Size) == "number" then
                    Dot.Size = UDim2.new(0, Size, 0, Size)
                end

                if typeof(Transparency) == "number" then
                    Dot.BackgroundTransparency = Transparency
                else
                    Dot.BackgroundTransparency = 0
                end

                Dot.Visible = Visible ~= false
                return Entry
            end

            function Radar:Remove(Key)
                local Entry = Radar.Entries[Key]
                if not Entry then
                    return
                end

                Radar.Entries[Key] = nil
                Entry.Dot.Instance:Destroy()
            end

            function Radar:Clear()
                for Key, Entry in next, Radar.Entries do
                    Radar.Entries[Key] = nil
                    Entry.Dot.Instance:Destroy()
                end
            end

            function Radar:GetBounds()
                return Items["RadarBounds"].Instance.AbsoluteSize
            end

            Radar.Items = Items

            Library:RegisterLayout("RadarWidget", {
                Instance = Items["RadarWidget"].Instance
            })

            Radar:Center()

            return Radar
        end

        Library.TargetIndicator = function(Self)
            local Indicator = {}

            local Items = {}
            do
                Items["TargetIndicator"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Position = UDim2.new(0.4242021143436432, 0, 0.7932242751121521, 0),
                    Size = UDim2.new(0, 256, 0, 80),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = 'Background' })

                Items["TargetIndicator"]:MakeDraggable()

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["TargetIndicator"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["TargetIndicator"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Items["Avatar"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["TargetIndicator"].Instance,
                    Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(0, 60, 0, 60),
                    BorderSizePixel = 0
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Avatar"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Avatar"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Items["Healthbar"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["TargetIndicator"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 80, 1, -10),
                    Size = UDim2.new(1, -90, 0, 10),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = 'Section' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Healthbar"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Items["HealthbarFill"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Healthbar"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(70, 255, 144)
                })

                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["HealthbarFill"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "100/100",
                    Size = UDim2.new(0, 0, 0, 15),
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -4, 0.5, -1),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Value"].Instance,
                    LineJoinMode = Enum.LineJoinMode.Miter
                })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["HealthbarFill"].Instance,
                    Rotation = -90,
                    Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 172, 172))
                    }
                })

                Items["Stuff"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["TargetIndicator"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 80, 0, 10),
                    Size = UDim2.new(1, -90, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                })

                Items["Name"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Stuff"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "sametexe009",
                    Size = UDim2.new(1, -90, 0, 15),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 80, 0, 10),
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = 'Text' })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Stuff"].Instance,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            local HealthConnection = nil
            local BoundTarget = nil
            local BoundHumanoid = nil

            function Indicator:SetVisibility(Bool)
                Items["TargetIndicator"].Instance.Visible = Bool
            end

            function Indicator:Center()
                local AbsPos = Items["TargetIndicator"].Instance.AbsolutePosition
                Items["TargetIndicator"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["TargetIndicator"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            function Indicator:SetPosition(Position)
                Items["TargetIndicator"].Instance.AnchorPoint = Vector2.new(0, 0)
                Items["TargetIndicator"].Instance.Position = Position
            end

            function Indicator:GetBounds()
                local Instance = Items["TargetIndicator"].Instance
                return Instance.AbsolutePosition, Instance.AbsoluteSize
            end

            function Indicator:ResetConnection()
                if HealthConnection then
                    HealthConnection:Disconnect()
                    HealthConnection = nil
                end
                BoundTarget = nil
                BoundHumanoid = nil
            end

            function Indicator:SetTarget(Target)
                Indicator:ResetConnection()

                if not Target then
                    Items["Name"].Instance.Text = "No target selected"
                    Items["Avatar"].Instance.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
                    Items["Value"].Instance.Text = "0/0"
                    Items["HealthbarFill"]:Tween({ Size = UDim2.new(0, 0, 1, 0) })
                    return false
                end

                local Name = Target.Name

                Items["Name"].Instance.Text = Name
                Items["Avatar"].Instance.Image = Players:GetUserThumbnailAsync(Target.UserId, Enum.ThumbnailType
                    .HeadShot, Enum.ThumbnailSize.Size420x420)

                local Character = Target.Character
                local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                if not Humanoid then
                    Items["Value"].Instance.Text = "0/0"
                    Items["HealthbarFill"]:Tween({ Size = UDim2.new(0, 0, 1, 0) })
                    return false
                end

                BoundTarget = Target
                BoundHumanoid = Humanoid

                local function UpdateHealth(Health)
                    if BoundTarget ~= Target or BoundHumanoid ~= Humanoid then
                        return
                    end
                    local MaxHealth = Humanoid.MaxHealth
                    local SafeMaxHealth = math.max(MaxHealth, 1)
                    local SafeHealth = math.max(Health, 0)
                    local DisplayHealth = math.floor(SafeHealth + 0.5)
                    local DisplayMaxHealth = math.floor(math.max(MaxHealth, 0) + 0.5)

                    Items["Value"].Instance.Text = DisplayHealth .. "/" .. DisplayMaxHealth

                    local HealthPercent = math.clamp(SafeHealth / SafeMaxHealth, 0, 1)
                    Items["HealthbarFill"]:Tween({ Size = UDim2.new(HealthPercent, 0, 1, 0) })
                end

                UpdateHealth(Humanoid.Health)
                HealthConnection = Humanoid.HealthChanged:Connect(UpdateHealth)
                return true
            end

            function Indicator:AddItem(Text)
                return Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Stuff"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Text,
                    Size = UDim2.new(1, -90, 0, 15),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 80, 0, 24),
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = 'Text' })
            end

            Library:RegisterLayout("TargetIndicator", {
                Instance = Items["TargetIndicator"].Instance
            })

            Indicator:Center()

            return Indicator
        end

        Library.ChargeShotWidget = function(Self, Params)
            local Widget = {
                Visible = false,
                Minimum = 1,
                Maximum = 30,
            }

            local Items = {}
            do
                Items["ChargeShotWidget"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Visible = false,
                    Position = UDim2.new(0.4242021143436432, 40, 0.7932242751121521, 82),
                    Size = UDim2.new(0, 176, 0, 44),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = "Background" })

                Items["ChargeShotWidget"]:MakeDraggable()

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ChargeShotWidget"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ChargeShotWidget"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ChargeShotWidget"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = "Accent" })

                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ChargeShotWidget"].Instance,
                    Position = UDim2.new(0, 0, 0, 1),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Light Border"]
                }):AddToTheme({ BackgroundColor3 = "Light Border" })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ChargeShotWidget"].Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = Params and Params.Name or "Charge Shot",
                    Size = UDim2.new(0, 0, 0, 15),
                    Position = UDim2.new(0, 9, 0, 6),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = "Accent" })

                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ChargeShotWidget"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "x1",
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -9, 0, 6),
                    Size = UDim2.new(0, 32, 0, 15),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = "Text" })

                Items["Bar"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ChargeShotWidget"].Instance,
                    Position = UDim2.new(0, 10, 0, 26),
                    Size = UDim2.new(0, 154, 0, 8),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = "Section" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Bar"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Bar"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Items["Fill"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Bar"].Instance,
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 45, 45)
                })
            end

            local function UpdateValueText(Value)
                Items["Value"].Instance.Text = ("x%d"):format(math.floor(Value + 0.5))
            end

            function Widget:SetVisibility(Bool)
                Widget.Visible = Bool and true or false
                Items["ChargeShotWidget"].Instance.Visible = Widget.Visible
            end

            function Widget:Center()
                local AbsPos = Items["ChargeShotWidget"].Instance.AbsolutePosition
                Items["ChargeShotWidget"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["ChargeShotWidget"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            function Widget:SetText(Text)
                Items["Text"].Instance.Text = Text
            end

            function Widget:SetPosition(Position)
                Items["ChargeShotWidget"].Instance.AnchorPoint = Vector2.new(0, 0)
                Items["ChargeShotWidget"].Instance.Position = Position
            end

            function Widget:SetRange(Minimum, Maximum)
                Widget.Minimum = tonumber(Minimum) or 1
                Widget.Maximum = math.max(tonumber(Maximum) or 30, Widget.Minimum)
                return Widget
            end

            function Widget:SetValue(Value)
                local Min = Widget.Minimum
                local Max = Widget.Maximum
                local SafeValue = math.clamp(tonumber(Value) or Min, Min, Max)
                local Alpha = Max > Min and ((SafeValue - Min) / (Max - Min)) or 1

                Items["Fill"].Instance.Size = UDim2.new(Alpha, 0, 1, 0)
                UpdateValueText(SafeValue)
            end

            function Widget:SetAlpha(Alpha)
                local SafeAlpha = math.clamp(tonumber(Alpha) or 0, 0, 1)
                local Min = Widget.Minimum
                local Max = Widget.Maximum
                local Value = Min + ((Max - Min) * SafeAlpha)

                Items["Fill"].Instance.Size = UDim2.new(SafeAlpha, 0, 1, 0)
                UpdateValueText(Value)
            end

            function Widget:SetFillColor(Color)
                if typeof(Color) == "Color3" then
                    Items["Fill"].Instance.BackgroundColor3 = Color
                end
            end

            Widget.Items = Items

            Library:RegisterLayout("ChargeShotWidget", {
                Instance = Items["ChargeShotWidget"].Instance
            })

            Widget:Center()
            Widget:SetValue(Widget.Minimum)

            return Widget
        end

        Library.StatListWidget = function(Self, Params)
            local Widget = {
                Visible = true,
                MinimumSize = Vector2.new(208, 102),
            }

            local Items = {}
            do
                Items["StatListWidget"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Visible = true,
                    Position = UDim2.new(0, 860, 0, 916),
                    Size = UDim2.fromOffset(Widget.MinimumSize.X, Widget.MinimumSize.Y),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = "Background" })

                Items["StatListWidget"]:MakeDraggable()

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["StatListWidget"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["StatListWidget"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["StatListWidget"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = "Accent" })

                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["StatListWidget"].Instance,
                    Position = UDim2.new(0, 0, 0, 1),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Light Border"]
                }):AddToTheme({ BackgroundColor3 = "Light Border" })

                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["StatListWidget"].Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = Params and Params.Name or "Stats",
                    Position = UDim2.new(0, 9, 0, 6),
                    Size = UDim2.new(1, -18, 0, 15),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = "Accent" })

                Items["Content"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["StatListWidget"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    Position = UDim2.new(0, 9, 0, 24),
                    Size = UDim2.new(1, -18, 1, -30),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    TextWrapped = false,
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = "Text" })
            end

            local function ApplyVisibility()
                Items["StatListWidget"].Instance.Visible = Widget.Visible
            end

            Library:BindToWindowVisibility(ApplyVisibility)

            function Widget:SetVisibility(Bool)
                Widget.Visible = Bool and true or false
                ApplyVisibility()
            end

            function Widget:Center()
                local AbsPos = Items["StatListWidget"].Instance.AbsolutePosition
                Items["StatListWidget"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["StatListWidget"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            function Widget:SetText(Text)
                Items["Title"].Instance.Text = tostring(Text or "")
            end

            function Widget:SetPosition(Position)
                Items["StatListWidget"].Instance.AnchorPoint = Vector2.new(0, 0)
                Items["StatListWidget"].Instance.Position = Position
            end

            function Widget:SetLines(Lines)
                if type(Lines) == "table" then
                    Items["Content"].Instance.Text = table.concat(Lines, "\n")
                else
                    Items["Content"].Instance.Text = tostring(Lines or "")
                end
            end

            function Widget:GetBounds()
                local Instance = Items["StatListWidget"].Instance
                return Instance.AbsolutePosition, Instance.AbsoluteSize
            end

            Widget.Items = Items

            Library:RegisterLayout("StatListWidget", {
                Instance = Items["StatListWidget"].Instance
            })

            Widget:Center()
            Widget:SetLines({})

            return Widget
        end

        Library.InventoryViewer = function(Self, Params)
            local Viewer = {
                Visible = true,
                Entries = {},
                Sections = {},
                Columns = 4,
                MinimumSize = Vector2.new(336, 140),
                MaximumWidth = 420,
                MaximumHeight = 460,
                CellSize = Vector2.new(62, 70),
                CellPadding = 4,
                HeaderHeight = 48,
                ScrollBarThickness = 2,
                MinimumVisibleRows = 1,
                SectionSpacing = 4,
                SectionHeaderHeight = 14,
            }

            local Items = {}
            do
                Items["InventoryViewer"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Visible = true,
                    Position = UDim2.new(0, 860, 0, 776),
                    Size = UDim2.new(0, Viewer.MinimumSize.X, 0, Viewer.MinimumSize.Y),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = "Background" })

                Items["InventoryViewer"]:MakeDraggable()
                Items["InventoryViewer"]:MakeResizeable(Viewer.MinimumSize)

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["InventoryViewer"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["InventoryViewer"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["InventoryViewer"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = "Accent" })

                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["InventoryViewer"].Instance,
                    Position = UDim2.new(0, 0, 0, 1),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Light Border"]
                }):AddToTheme({ BackgroundColor3 = "Light Border" })

                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["InventoryViewer"].Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = Params and Params.Name or "Inventory Viewer",
                    Position = UDim2.new(0, 9, 0, 6),
                    Size = UDim2.new(1, -18, 0, 15),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = "Accent" })

                Items["Summary"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["InventoryViewer"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "0 items, $0",
                    Position = UDim2.new(0, 9, 0, 20),
                    Size = UDim2.new(1, -18, 0, 14),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = "Text" })

                Items["Target"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["InventoryViewer"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "No target selected",
                    Position = UDim2.new(0, 9, 0, 22),
                    Size = UDim2.new(1, -18, 0, 14),
                    BackgroundTransparency = 1,
                    TextTransparency = 0.35,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = "Text" })

                Items["Background"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["InventoryViewer"].Instance,
                    Position = UDim2.new(0, 9, 0, Viewer.HeaderHeight),
                    Size = UDim2.new(1, -18, 1, -(Viewer.HeaderHeight + 9)),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = "Section" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Items["Holder"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.None,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarImageColor3 = Library.Theme["Accent"],
                    ScrollBarThickness = Viewer.ScrollBarThickness,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 6),
                    Size = UDim2.new(1, -18, 1, -12),
                    ScrollingDirection = Enum.ScrollingDirection.Y
                }):AddToTheme({ ScrollBarImageColor3 = "Accent" })

                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 0),
                    Size = UDim2.fromOffset(0, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0
                })

                Items["ContentList"] = Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Padding = UDim.new(0, Viewer.SectionSpacing),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            local function ApplyVisibility()
                Items["InventoryViewer"].Instance.Visible = Viewer.Visible
            end

            local function RecalculateLayout()
                local Holder = Items["Holder"].Instance
                local Columns = math.max(math.floor(Viewer.Columns or 4), 1)
                local CellWidth = Viewer.CellSize.X
                local CellHeight = Viewer.CellSize.Y
                local Padding = Viewer.CellPadding
                local Frame = Items["InventoryViewer"].Instance
                local UsedWidth = (Columns * CellWidth) + (math.max(Columns - 1, 0) * Padding)
                local SectionWidth = UsedWidth + 12
                local ContentHeight = 0
                local VisibleSectionCount = 0

                for _, Section in ipairs(Viewer.Sections) do
                    local EntryCount = #(Section.Entries or {})
                    local Rows = EntryCount > 0 and math.max(math.ceil(EntryCount / Columns), 1) or 0
                    local GridHeight = Rows > 0 and ((Rows * CellHeight) + (math.max(Rows - 1, 0) * Padding)) or 0
                    local SectionHeight = Viewer.SectionHeaderHeight + 4

                    if Section.EmptyLabel and Section.EmptyLabel.Instance then
                        Section.EmptyLabel.Instance.Visible = EntryCount == 0
                    end
                    if Section.Content and Section.Content.Instance then
                        Section.Content.Instance.Visible = EntryCount > 0
                        Section.Content.Instance.Size = UDim2.fromOffset(UsedWidth, GridHeight)
                    end
                    if Section.Grid and Section.Grid.Instance then
                        Section.Grid.Instance.FillDirectionMaxCells = Columns
                    end
                    if Section.Title and Section.Title.Instance then
                        if EntryCount > 0 then
                            Section.Title.Instance.Text = ("%s (%d)"):format(Section.Name or "Section", EntryCount)
                        else
                            Section.Title.Instance.Text = tostring(Section.Name or "Section")
                        end
                    end

                    if EntryCount > 0 then
                        SectionHeight = SectionHeight + GridHeight + 2
                    elseif Section.EmptyLabel and Section.EmptyLabel.Instance then
                        SectionHeight = SectionHeight + 14
                    end

                    if Section.Frame and Section.Frame.Instance then
                        Section.Frame.Instance.Size = UDim2.fromOffset(SectionWidth, SectionHeight)
                    end

                    ContentHeight = ContentHeight + SectionHeight
                    VisibleSectionCount = VisibleSectionCount + 1
                end

                if VisibleSectionCount > 1 then
                    ContentHeight = ContentHeight + ((VisibleSectionCount - 1) * Viewer.SectionSpacing)
                end

                local FramePaddingX = 36
                local FramePaddingY = 21
                local AvailableHeight = math.max(Frame.AbsoluteSize.Y - Viewer.HeaderHeight - FramePaddingY, 0)
                local NeedsScrollbar = ContentHeight > (AvailableHeight + 1)
                local DesiredWidth = math.clamp(
                    SectionWidth + FramePaddingX + (NeedsScrollbar and Viewer.ScrollBarThickness or 0),
                    Viewer.MinimumSize.X,
                    Viewer.MaximumWidth
                )
                local DesiredHeight = math.clamp(ContentHeight + Viewer.HeaderHeight + FramePaddingY,
                    Viewer.MinimumSize.Y,
                    Viewer.MaximumHeight)

                Items["Content"].Instance.Size = UDim2.fromOffset(SectionWidth, ContentHeight)
                Items["Content"].Instance.Position = UDim2.new(0.5, 0, 0, 0)
                Holder.CanvasSize = UDim2.new(0, 0, 0, ContentHeight)
                Holder.ScrollBarThickness = NeedsScrollbar and Viewer.ScrollBarThickness or 0

                if math.abs(Frame.AbsoluteSize.X - DesiredWidth) > 1
                    or math.abs(Frame.AbsoluteSize.Y - DesiredHeight) > 1
                then
                    Items["InventoryViewer"]:Tween(
                        { Size = UDim2.fromOffset(DesiredWidth, DesiredHeight) },
                        TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                    )
                end
            end

            local function ClearEntries()
                for _, Section in ipairs(Viewer.Sections) do
                    if Section and Section.Frame and Section.Frame.Instance then
                        Section.Frame.Instance:Destroy()
                    end
                end
                table.clear(Viewer.Entries)
                table.clear(Viewer.Sections)
            end

            local function CreateEntry(Section, Data)
                local Entry = {}
                local Amount = tonumber(Data.Amount) or 1
                local AmountText = Amount > 1 and ("x" .. tostring(math.floor(Amount + 0.5))) or ""

                Entry.Frame = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Section.Content.Instance,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({ BackgroundColor3 = "Element" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Entry.Frame.Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Entry.Frame.Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Entry.Image = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Entry.Frame.Instance,
                    Image = Data.Image or "rbxasset://textures/ui/GuiImagePlaceholder.png",
                    AnchorPoint = Vector2.new(0.5, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0, 6),
                    Size = UDim2.new(1, -14, 1, -30),
                    BorderSizePixel = 0
                })

                Entry.Image.Instance.ScaleType = Enum.ScaleType.Fit

                Entry.Name = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = math.max(Library.FontSize - 2, 9),
                    Parent = Entry.Frame.Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = tostring(Data.DisplayName or Data.Name or ""),
                    Position = UDim2.new(0, 4, 1, -22),
                    Size = UDim2.new(1, -8, 0, 12),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    TextTruncate = Enum.TextTruncate.AtEnd
                }):AddToTheme({ TextColor3 = "Text" })

                Entry.Amount = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = math.max(Library.FontSize - 2, 9),
                    Parent = Entry.Frame.Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = AmountText,
                    AnchorPoint = Vector2.new(1, 1),
                    Position = UDim2.new(1, -4, 1, -4),
                    Size = UDim2.new(1, -8, 0, 12),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = "Accent" })

                Viewer.Entries[#Viewer.Entries + 1] = Entry
                Section.Entries[#Section.Entries + 1] = Entry
                return Entry
            end

            local function CreateSection(Data)
                local Section = {
                    Name = tostring(Data.Name or "Section"),
                    Entries = {},
                }

                Section.Frame = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.fromOffset(0, 0),
                    BorderSizePixel = 0
                })

                Section.Title = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = 9,
                    Parent = Section.Frame.Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = Section.Name,
                    Position = UDim2.new(0, 2, 0, 0),
                    Size = UDim2.new(1, -4, 0, Viewer.SectionHeaderHeight),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = "Accent" })

                Section.Divider = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Section.Frame.Instance,
                    Position = UDim2.new(0, 0, 0, Viewer.SectionHeaderHeight),
                    Size = UDim2.new(1, 0, 0, 1),
                    BackgroundColor3 = Library.Theme["Light Border"],
                    BorderSizePixel = 0
                }):AddToTheme({ BackgroundColor3 = "Light Border" })

                Section.Content = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Section.Frame.Instance,
                    Position = UDim2.new(0.5, 0, 0, Viewer.SectionHeaderHeight + 4),
                    AnchorPoint = Vector2.new(0.5, 0),
                    Size = UDim2.fromOffset(0, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0
                })

                Section.Grid = Library:Create("UIGridLayout", {
                    Name = "\0",
                    Parent = Section.Content.Instance,
                    CellSize = UDim2.fromOffset(Viewer.CellSize.X, Viewer.CellSize.Y),
                    CellPadding = UDim2.fromOffset(Viewer.CellPadding, Viewer.CellPadding),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Section.EmptyLabel = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = math.max(Library.FontSize - 1, 10),
                    Parent = Section.Frame.Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "None",
                    Position = UDim2.new(0, 2, 0, Viewer.SectionHeaderHeight + 5),
                    Size = UDim2.new(1, -4, 0, 12),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    Visible = false
                }):AddToTheme({ TextColor3 = "Inactive Text" })

                Viewer.Sections[#Viewer.Sections + 1] = Section
                return Section
            end

            Library:BindToWindowVisibility(ApplyVisibility)

            Items["InventoryViewer"].Instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(RecalculateLayout)
            Items["ContentList"].Instance:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(RecalculateLayout)
            Library:Connect(UserInputService.InputBegan, function(Input, Processed)
                if Processed or not Viewer.Visible then
                    return
                end

                if UserInputService:GetFocusedTextBox() then
                    return
                end

                local Holder = Items["Holder"].Instance
                local MaxScroll = math.max(Holder.CanvasSize.Y.Offset - Holder.AbsoluteWindowSize.Y, 0)
                if MaxScroll <= 0 then
                    return
                end

                local Step = Viewer.CellSize.Y + Viewer.CellPadding
                if Input.KeyCode == Enum.KeyCode.Up then
                    Holder.CanvasPosition = Vector2.new(0, math.max(Holder.CanvasPosition.Y - Step, 0))
                elseif Input.KeyCode == Enum.KeyCode.Down then
                    Holder.CanvasPosition = Vector2.new(0, math.min(Holder.CanvasPosition.Y + Step, MaxScroll))
                end
            end)

            function Viewer:SetVisibility(Bool)
                Viewer.Visible = Bool and true or false
                ApplyVisibility()
            end

            function Viewer:Center()
                local AbsPos = Items["InventoryViewer"].Instance.AbsolutePosition
                Items["InventoryViewer"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["InventoryViewer"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            function Viewer:SetPosition(Position)
                Items["InventoryViewer"].Instance.AnchorPoint = Vector2.new(0, 0)
                Items["InventoryViewer"].Instance.Position = Position
            end

            function Viewer:GetBounds()
                local Instance = Items["InventoryViewer"].Instance
                return Instance.AbsolutePosition, Instance.AbsoluteSize
            end

            function Viewer:SetText(Text)
                Items["Title"].Instance.Text = tostring(Text or "")
            end

            function Viewer:SetSummary(Text)
                local SummaryText = tostring(Text or "")
                local ShowSummary = SummaryText ~= ""

                Items["Summary"].Instance.Visible = ShowSummary
                Items["Summary"].Instance.Text = SummaryText
                Items["Target"].Instance.Position = ShowSummary and UDim2.new(0, 9, 0, 34) or UDim2.new(0, 9, 0, 22)
                Viewer.HeaderHeight = ShowSummary and 60 or 48
                Items["Background"].Instance.Position = UDim2.new(0, 9, 0, Viewer.HeaderHeight)
                Items["Background"].Instance.Size = UDim2.new(1, -18, 1, -(Viewer.HeaderHeight + 9))
                RecalculateLayout()
            end

            function Viewer:SetTarget(Text)
                Items["Target"].Instance.Text = tostring(Text or "")
            end

            function Viewer:Clear()
                ClearEntries()
                RecalculateLayout()
            end

            function Viewer:SetSections(List)
                ClearEntries()

                for _, SectionData in ipairs(List or {}) do
                    local Section = CreateSection(SectionData)
                    for _, Data in ipairs(SectionData.Entries or {}) do
                        CreateEntry(Section, Data)
                    end
                end

                RecalculateLayout()
            end

            function Viewer:SetItems(List)
                Viewer:SetSections({
                    {
                        Name = "Items",
                        Entries = List or {},
                    }
                })
            end

            Viewer.Items = Items

            Library:RegisterLayout("InventoryViewer", {
                Instance = Items["InventoryViewer"].Instance
            })

            Viewer:Center()
            RecalculateLayout()

            return Viewer
        end

        Library.SpotifyPlayer = function(Self)
            local Spotify = {}

            local Request = request
                or http_request
                or (syn and syn.request)
                or (getgenv and getgenv().http and getgenv().http.request)
            local GetCustomAsset = getcustomasset or getsynasset

            local SpotifyFolder = Library.Directory .. "/Spotify"
            local CacheFolder = SpotifyFolder .. "/Cache"
            local TokenPath = Library.Directory .. "/token.txt"
            local PlaceholderImage = "rbxasset://textures/ui/GuiImagePlaceholder.png"
            local PollInterval = 1

            if not isfolder(SpotifyFolder) then
                makefolder(SpotifyFolder)
            end

            if not isfolder(CacheFolder) then
                makefolder(CacheFolder)
            end

            local function ReadToken()
                if not isfile(TokenPath) then
                    writefile(TokenPath, "")
                    return ""
                end

                return (readfile(TokenPath):gsub("^%s*(.-)%s*$", "%1"))
            end

            local function DecodeTokenConfig(RawToken)
                local CleanToken = (RawToken or ""):gsub("^%s*(.-)%s*$", "%1")
                if CleanToken == "" then
                    return {
                        Raw = "",
                        AccessToken = "",
                        RefreshToken = "",
                        ClientId = "",
                        ClientSecret = "",
                        ExpiresAt = 0,
                        LyricsApi = "",
                        LyricsFormat = "raw"
                    }
                end

                if CleanToken:sub(1, 1) ~= "{" then
                    return {
                        Raw = CleanToken,
                        AccessToken = CleanToken,
                        RefreshToken = "",
                        ClientId = "",
                        ClientSecret = "",
                        ExpiresAt = math.huge,
                        LyricsApi = "",
                        LyricsFormat = "raw"
                    }
                end

                local DecodeSuccess, Parsed = pcall(HttpService.JSONDecode, HttpService, CleanToken)
                if not DecodeSuccess or type(Parsed) ~= "table" then
                    return {
                        Raw = CleanToken,
                        AccessToken = "",
                        RefreshToken = "",
                        ClientId = "",
                        ClientSecret = "",
                        ExpiresAt = 0,
                        LyricsApi = "",
                        LyricsFormat = "raw",
                        ParseFailed = true
                    }
                end

                return {
                    Raw = CleanToken,
                    AccessToken = tostring(Parsed.access_token or Parsed.token or ""):gsub("^%s*(.-)%s*$", "%1"),
                    RefreshToken = tostring(Parsed.refresh_token or ""):gsub("^%s*(.-)%s*$", "%1"),
                    ClientId = tostring(Parsed.client_id or ""):gsub("^%s*(.-)%s*$", "%1"),
                    ClientSecret = tostring(Parsed.client_secret or ""):gsub("^%s*(.-)%s*$", "%1"),
                    ExpiresAt = tonumber(Parsed.expires_at) or 0,
                    LyricsApi = tostring(Parsed.lyrics_api or ""):gsub("^%s*(.-)%s*$", "%1"),
                    LyricsFormat = tostring(Parsed.lyrics_format or "raw"):gsub("^%s*(.-)%s*$", "%1")
                }
            end

            local function EncodeTokenConfig(Config)
                if not Config then
                    return ""
                end

                if (Config.RefreshToken or "") == "" then
                    return Config.AccessToken or ""
                end

                local EncodeSuccess, Encoded = pcall(HttpService.JSONEncode, HttpService, {
                    access_token = Config.AccessToken or "",
                    refresh_token = Config.RefreshToken or "",
                    client_id = Config.ClientId or "",
                    client_secret = Config.ClientSecret or "",
                    expires_at = math.floor(tonumber(Config.ExpiresAt) or 0),
                    lyrics_api = Config.LyricsApi or "",
                    lyrics_format = Config.LyricsFormat or "raw"
                })

                return EncodeSuccess and Encoded or ""
            end

            local function WriteToken(ConfigOrToken)
                if type(ConfigOrToken) == "table" then
                    writefile(TokenPath, EncodeTokenConfig(ConfigOrToken))
                    return
                end

                writefile(TokenPath, ConfigOrToken or "")
            end

            local TokenConfig = DecodeTokenConfig(ReadToken())
            local Token = TokenConfig.AccessToken

            local CollapsedSize = UDim2.new(0, 248, 0, 88)
            local ExpandedSize = UDim2.new(0, 540, 0, 250)
            local ResultButtons = {}
            local SearchResults = {}
            local SearchTrackResults = {}
            local SearchAlbumBrowse = nil
            local CurrentTrack
            local IsExpanded = false
            local Seeking = false
            local SearchRequestId = 0
            local SearchDelay = 0.25
            local UpdateQueueCanvas

            local Items = {}
            do
                local function CreateControlButton(Key, Parent, Image, FrameSize, IconSize, IconOffsetY)
                    Items[Key] = Library:Create("TextButton", {
                        Name = "\0",
                        Parent = Parent,
                        Size = UDim2.new(0, FrameSize, 0, 20),
                        BorderSizePixel = 0,
                        AutoButtonColor = false,
                        BackgroundTransparency = 1,
                        Text = ""
                    })

                    Items[Key].Icon = Library:Create("ImageLabel", {
                        Name = "\0",
                        Parent = Items[Key].Instance,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0.5, IconOffsetY or 0),
                        Size = UDim2.new(0, IconSize, 0, IconSize),
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        Image = Image,
                        ImageColor3 = Library.Theme["Text"]
                    }):AddToTheme({ ImageColor3 = "Text" })
                end

                Items["SpotifyPlayer"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Position = UDim2.new(0, 30, 0, 240),
                    Size = CollapsedSize,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"],
                    ClipsDescendants = true
                }):AddToTheme({ BackgroundColor3 = "Background" })

                Items["SpotifyPlayer"]:MakeDraggable()

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["SpotifyPlayer"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["SpotifyPlayer"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Items["AccentLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["SpotifyPlayer"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = "Accent" })

                Items["SearchBackground"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["SpotifyPlayer"].Instance,
                    Position = UDim2.new(0, 10, 0, -40),
                    Size = UDim2.new(0, 250, 0, 24),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({ BackgroundColor3 = "Element" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["SearchBackground"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["SearchBackground"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Items["SearchInput"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["SearchBackground"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    PlaceholderText = "Search songs, artists, albums",
                    Size = UDim2.new(1, -12, 0, 15),
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 6, 0.5, -1),
                    ClearTextOnFocus = false,
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = "Text" })

                Items["SearchResults"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["SpotifyPlayer"].Instance,
                    Position = UDim2.new(0, 10, 0, -170),
                    Size = UDim2.new(0, 250, 0, 114),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(),
                    ScrollBarThickness = 0,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = "Section" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["SearchResults"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["SearchResults"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SearchResults"].Instance,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 4)
                })

                for Index = 1, 8 do
                    local Row = {}

                    Row.Frame = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Items["SearchResults"].Instance,
                        Size = UDim2.new(1, -8, 0, 36),
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Library.Theme["Element"],
                        Visible = false
                    })

                    Row.Divider = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Row.Frame.Instance,
                        AnchorPoint = Vector2.new(0.5, 1),
                        Position = UDim2.new(0.5, 0, 1, -1),
                        Size = UDim2.new(1, -22, 0, 1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Outline"]
                    }):AddToTheme({ BackgroundColor3 = "Outline" })

                    Row.Cover = Library:Create("ImageLabel", {
                        Name = "\0",
                        Parent = Row.Frame.Instance,
                        Image = PlaceholderImage,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 30, 0, 30),
                        Position = UDim2.new(0, 3, 0, 3),
                        BorderSizePixel = 0
                    })

                    Row.Title = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = Row.Frame.Instance,
                        TextColor3 = Library.Theme["Text"],
                        Text = "",
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 40, 0, 2),
                        Size = UDim2.new(1, -44, 0, 15),
                        BorderSizePixel = 0,
                        TextTruncate = Enum.TextTruncate.AtEnd
                    }):AddToTheme({ TextColor3 = "Text" })

                    Row.Album = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = Row.Frame.Instance,
                        TextColor3 = Library.Theme["Inactive Text"],
                        Text = "",
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 40, 0, 17),
                        Size = UDim2.new(1, -44, 0, 14),
                        BorderSizePixel = 0,
                        TextTruncate = Enum.TextTruncate.AtEnd
                    }):AddToTheme({ TextColor3 = "Inactive Text" })

                    Row.Button = Library:Create("TextButton", {
                        Name = "\0",
                        Parent = Row.Frame.Instance,
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        Text = ""
                    })

                    ResultButtons[Index] = Row
                end

                Items["LyricsFrame"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["SpotifyPlayer"].Instance,
                    Position = UDim2.new(1, 10, 0, 10),
                    Size = UDim2.new(0, 260, 0, 146),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = "Section" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["LyricsFrame"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["LyricsFrame"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Items["QueueLabel"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["LyricsFrame"].Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = "Queue",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 8, 0, 6),
                    Size = UDim2.new(1, -16, 0, 14),
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = "Accent" })

                Items["QueueScroll"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["LyricsFrame"].Instance,
                    Position = UDim2.new(0, 8, 0, 24),
                    Size = UDim2.new(1, -16, 1, -32),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    CanvasSize = UDim2.new(),
                    AutomaticCanvasSize = Enum.AutomaticSize.None,
                    ScrollBarThickness = 1,
                    ScrollBarImageColor3 = Library.Theme["Border"],
                    MidImage = "rbxassetid://129030709932941",
                    BottomImage = "rbxassetid://129030709932941",
                    TopImage = "rbxassetid://129030709932941"
                }):AddToTheme({ ScrollBarImageColor3 = "Border" })

                Items["QueueText"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["QueueScroll"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "Nothing is currently playing.",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    Size = UDim2.new(1, -8, 0, 0),
                    BorderSizePixel = 0,
                    TextWrapped = true,
                    RichText = true
                }):AddToTheme({ TextColor3 = "Inactive Text" })

                Library:Connect(Items["QueueScroll"].Instance:GetPropertyChangedSignal("AbsoluteSize"), function()
                    UpdateQueueCanvas()
                end)

                Items["PlayerArea"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["SpotifyPlayer"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(1, -20, 0, 68),
                    BorderSizePixel = 0
                })

                Items["CoverFrame"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["PlayerArea"].Instance,
                    Position = UDim2.new(0, 0, 0, 2),
                    Size = UDim2.new(0, 50, 0, 50),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = "Section" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["CoverFrame"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["CoverFrame"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Items["Cover"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["CoverFrame"].Instance,
                    Image = PlaceholderImage,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })

                Items["Info"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["PlayerArea"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 60, 0, 2),
                    Size = UDim2.new(1, -176, 0, 38),
                    BorderSizePixel = 0
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Info"].Instance,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 1)
                })

                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Info"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "Spotify",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 14),
                    BorderSizePixel = 0,
                    TextTruncate = Enum.TextTruncate.AtEnd
                }):AddToTheme({ TextColor3 = "Text" })

                Items["Artist"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Info"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "No track detected",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 13),
                    BorderSizePixel = 0,
                    TextTruncate = Enum.TextTruncate.AtEnd
                }):AddToTheme({ TextColor3 = "Inactive Text" })

                Items["Album"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Info"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "Waiting for Spotify",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 13),
                    BorderSizePixel = 0,
                    TextTruncate = Enum.TextTruncate.AtEnd
                }):AddToTheme({ TextColor3 = "Inactive Text" })

                Items["ProgressFrame"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["SpotifyPlayer"].Instance,
                    Position = UDim2.new(0, 0, 1, -3),
                    Size = UDim2.new(1, 0, 0, 3),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = "Section" })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["ProgressFrame"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })

                Items["ProgressFill"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["ProgressFrame"].Instance,
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = "Accent" })

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["ProgressFill"].Instance,
                    CornerRadius = UDim.new(1, 0)
                })

                Items["ProgressHitbox"] = Library:Create("TextButton", {
                    Name = "\0",
                    Parent = Items["SpotifyPlayer"].Instance,
                    Position = UDim2.new(0, 0, 1, -14),
                    Size = UDim2.new(1, 0, 0, 14),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Text = ""
                })

                Items["Time"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["PlayerArea"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "0:00 / 0:00",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 60, 0, 40),
                    Size = UDim2.new(0, 90, 0, 15),
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = "Inactive Text" })

                Items["Controls"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["PlayerArea"].Instance,
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -18, 0.5, 12),
                    Size = UDim2.new(0, 96, 0, 24),
                    BorderSizePixel = 0
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Controls"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 4)
                })

                CreateControlButton("Shuffle", Items["Controls"].Instance, "rbxassetid://9607545176", 12, 12, 0)
                CreateControlButton("PlayPause", Items["Controls"].Instance, "rbxassetid://9622475855", 20, 20, 0)
                CreateControlButton("Repeat", Items["Controls"].Instance, "rbxassetid://9607545605", 12, 12, 0)

                Items["ExpandButton"] = Library:Create("ImageButton", {
                    Name = "\0",
                    Parent = Items["SpotifyPlayer"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -8, 0, 8),
                    Size = UDim2.new(0, 14, 0, 14),
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Image = "rbxassetid://9607545497",
                    Rotation = 0,
                    ImageColor3 = Library.Theme["Text"],
                    BackgroundTransparency = 1
                }):AddToTheme({ ImageColor3 = "Text" })
            end

            local function FormatTime(Milliseconds)
                local TotalSeconds = math.max(math.floor((Milliseconds or 0) / 1000), 0)
                local Minutes = math.floor(TotalSeconds / 60)
                local Seconds = TotalSeconds % 60

                return string.format("%d:%02d", Minutes, Seconds)
            end

            local function SetProgress(Current, Total, Instant)
                local SafeTotal = math.max(Total or 0, 1)
                local Alpha = math.clamp((Current or 0) / SafeTotal, 0, 1)
                if Instant then
                    Items["ProgressFill"].Instance.Size = UDim2.new(Alpha, 0, 1, 0)
                else
                    Items["ProgressFill"]:Tween({ Size = UDim2.new(Alpha, 0, 1, 0) })
                end

                Items["Time"].Instance.Text = FormatTime(Current) .. " / " .. FormatTime(Total)
            end

            local function SetControlState(Data)
                local ShuffleEnabled = Data and Data.Shuffle
                local RepeatEnabled = Data and Data.RepeatState and Data.RepeatState ~= "off"

                Items["Shuffle"].Icon.Instance.ImageColor3 = ShuffleEnabled and Library.Theme["Accent"] or
                    Library.Theme["Text"]
                Items["Repeat"].Icon.Instance.ImageColor3 = RepeatEnabled and Library.Theme["Accent"] or
                    Library.Theme["Text"]
                Items["PlayPause"].Icon.Instance.Image = Data and Data.IsPlaying and "rbxassetid://9607545382" or
                    "rbxassetid://9622475855"
            end

            UpdateQueueCanvas = function()
                local QueueLabel = Items["QueueText"].Instance
                local QueueScroll = Items["QueueScroll"].Instance
                local Width = math.max(QueueScroll.AbsoluteSize.X - 8, 1)
                local Height = math.max(QueueLabel.TextBounds.Y + 4, QueueScroll.AbsoluteSize.Y)

                QueueLabel.Size = UDim2.new(0, Width, 0, Height)
                QueueScroll.CanvasSize = UDim2.new(0, 0, 0, Height)
            end

            local function SetQueueDisplay(Current, Tracks, EmptyText)
                if not Current and (type(Tracks) ~= "table" or #Tracks == 0) then
                    Items["QueueText"].Instance.Text = EmptyText or "No upcoming tracks."
                    UpdateQueueCanvas()
                    Items["QueueScroll"].Instance.CanvasPosition = Vector2.new()
                    return
                end

                local Buffer = {}
                if Current then
                    Buffer[#Buffer + 1] = string.format("<font color=\"#%02X%02X%02X\">Now playing</font>\n%s\n%s",
                        math.floor(Library.Theme["Accent"].R * 255),
                        math.floor(Library.Theme["Accent"].G * 255),
                        math.floor(Library.Theme["Accent"].B * 255),
                        Current.Title or "Unknown track",
                        Current.Artist or "Unknown artist")
                end

                if type(Tracks) == "table" and #Tracks > 0 then
                    if #Buffer > 0 then
                        Buffer[#Buffer + 1] = ""
                    end

                    Buffer[#Buffer + 1] = "Next up"
                end

                for Index, Track in Tracks do
                    if Index > 6 then
                        break
                    end

                    Buffer[#Buffer + 1] = string.format("%d. %s\n%s", Index, Track.Title or "Unknown track",
                        Track.Artist or "Unknown artist")
                end

                Items["QueueText"].Instance.Text = table.concat(Buffer, "\n\n")
                UpdateQueueCanvas()
                Items["QueueScroll"].Instance.CanvasPosition = Vector2.new()
            end

            local function SetDisplay(Data, EmptyText)
                if not Data then
                    CurrentTrack = nil
                    Items["Title"].Instance.Text = "Spotify"
                    Items["Artist"].Instance.Text = "No track detected"
                    Items["Album"].Instance.Text = EmptyText or "Nothing is currently playing"
                    Items["Cover"].Instance.Image = PlaceholderImage
                    SetControlState(nil)
                    SetQueueDisplay(nil, nil, "Nothing is currently playing.")
                    SetProgress(0, 0, true)
                    return
                end

                CurrentTrack = Data
                Items["Title"].Instance.Text = Data.Title
                Items["Artist"].Instance.Text = Data.Artist
                Items["Album"].Instance.Text = Data.Album
                Items["Cover"].Instance.Image = Data.Cover or PlaceholderImage
                SetControlState(Data)

                if not Seeking then
                    SetProgress(Data.Progress, Data.Duration, true)
                end
            end

            local function RefreshAccessToken()
                if not Request or TokenConfig.RefreshToken == "" then
                    return false
                end

                if TokenConfig.ClientId == "" or TokenConfig.ClientSecret == "" then
                    return false
                end

                local Body = table.concat({
                    "grant_type=refresh_token",
                    "refresh_token=" .. HttpService:UrlEncode(TokenConfig.RefreshToken),
                    "client_id=" .. HttpService:UrlEncode(TokenConfig.ClientId),
                    "client_secret=" .. HttpService:UrlEncode(TokenConfig.ClientSecret)
                }, "&")

                local Success, Response = pcall(Request, {
                    Url = "https://accounts.spotify.com/api/token",
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/x-www-form-urlencoded"
                    },
                    Body = Body
                })

                if not Success or not Response or Response.StatusCode ~= 200 or not Response.Body or Response.Body == "" then
                    return false
                end

                local DecodeSuccess, Payload = pcall(HttpService.JSONDecode, HttpService, Response.Body)
                if not DecodeSuccess or type(Payload) ~= "table" or not Payload.access_token then
                    return false
                end

                TokenConfig.AccessToken = tostring(Payload.access_token)
                TokenConfig.ExpiresAt = tick() + math.max((tonumber(Payload.expires_in) or 3600) - 30, 0)

                if Payload.refresh_token and Payload.refresh_token ~= "" then
                    TokenConfig.RefreshToken = tostring(Payload.refresh_token)
                end

                Token = TokenConfig.AccessToken
                WriteToken(TokenConfig)
                return true
            end

            local function EnsureAccessToken()
                if TokenConfig.RefreshToken == "" then
                    Token = TokenConfig.AccessToken
                    return Token ~= ""
                end

                if TokenConfig.AccessToken ~= "" and tick() < (TokenConfig.ExpiresAt or 0) then
                    Token = TokenConfig.AccessToken
                    return true
                end

                return RefreshAccessToken()
            end

            local function MakeRequest(Url, Method, RetryOnAuthFailure, Body)
                if not Request or not EnsureAccessToken() or Token == "" then
                    return nil
                end

                local RequestBody = Body
                if type(Body) == "table" then
                    local EncodeSuccess, EncodedBody = pcall(HttpService.JSONEncode, HttpService, Body)
                    if not EncodeSuccess then
                        return nil
                    end

                    RequestBody = EncodedBody
                end

                local Success, Response = pcall(Request, {
                    Url = "https://api.spotify.com/v1/" .. Url,
                    Method = Method or "GET",
                    Headers = {
                        ["Authorization"] = "Bearer " .. Token,
                        ["Content-Type"] = "application/json"
                    },
                    Body = RequestBody
                })

                if not Success or not Response then
                    return nil
                end

                if Response.StatusCode == 401 and RetryOnAuthFailure ~= false and TokenConfig.RefreshToken ~= "" and RefreshAccessToken() then
                    return MakeRequest(Url, Method, false, Body)
                end

                if Response.StatusCode < 200 or Response.StatusCode >= 300 then
                    return nil
                end

                if not Response.Body or Response.Body == "" then
                    return true
                end

                local DecodedSuccess, Body = pcall(HttpService.JSONDecode, HttpService, Response.Body)
                return DecodedSuccess and Body or nil
            end

            local function CacheImage(Id, Url)
                if not GetCustomAsset or not Id or not Url or Url == "" then
                    return PlaceholderImage
                end

                local SafeId = tostring(Id):gsub("[^%w_%-]", "_")
                local Path = CacheFolder .. "/" .. SafeId .. ".png"

                if not isfile(Path) then
                    pcall(function()
                        writefile(Path, game:HttpGet(Url))
                    end)
                end

                if isfile(Path) then
                    local AssetSuccess, Asset = pcall(GetCustomAsset, Path)
                    if AssetSuccess then
                        return Asset
                    end
                end

                return PlaceholderImage
            end

            local function ValidateToken()
                local Data = MakeRequest("me")
                return Data and Data.display_name
            end

            local function GetCurrentTrack()
                local Data = MakeRequest("me/player")
                if not Data or not Data.item then
                    return nil
                end

                local Artists = {}
                local ArtistList = Data.item.artists or {}
                for _, Artist in ArtistList do
                    table.insert(Artists, Artist.name)
                end

                local CoverUrl = Data.item.album and Data.item.album.images and Data.item.album.images[2] and
                    Data.item.album.images[2].url

                return {
                    Title = Data.item.name or "Unknown track",
                    Artist = #Artists > 0 and table.concat(Artists, ", ") or "Unknown artist",
                    Album = Data.item.album and Data.item.album.name or "Unknown album",
                    TrackId = Data.item.id or "",
                    Progress = Data.progress_ms or 0,
                    Duration = Data.item.duration_ms or 0,
                    Cover = CacheImage(Data.item.album and Data.item.album.id or Data.item.id, CoverUrl),
                    Device = Data.device and Data.device.name or "none",
                    IsPlaying = Data.is_playing == true,
                    Shuffle = Data.shuffle_state == true,
                    RepeatState = tostring(Data.repeat_state or "off"),
                    Uri = Data.item.uri or "",
                    UpdatedAt = tick()
                }
            end

            local function GetQueue()
                local Data = MakeRequest("me/player/queue")
                local Results = {}

                if not Data or type(Data.queue) ~= "table" then
                    return Results
                end

                for _, Track in Data.queue do
                    local Artists = {}

                    for _, Artist in Track.artists or {} do
                        table.insert(Artists, Artist.name)
                    end

                    table.insert(Results, {
                        Title = Track.name or "Unknown track",
                        Artist = #Artists > 0 and table.concat(Artists, ", ") or "Unknown artist"
                    })
                end

                return Results
            end

            local function SearchTracks(Query)
                local Data = MakeRequest("search?type=track&limit=8&q=" .. HttpService:UrlEncode(Query))
                local Results = {}

                if not Data or not Data.tracks or not Data.tracks.items then
                    return Results
                end

                for _, Track in Data.tracks.items do
                    local Artists = {}
                    local CoverUrl = Track.album and Track.album.images and Track.album.images[3] and
                        Track.album.images[3].url or
                        Track.album and Track.album.images and Track.album.images[2] and Track.album.images[2].url

                    for _, Artist in Track.artists or {} do
                        table.insert(Artists, Artist.name)
                    end

                    table.insert(Results, {
                        Title = Track.name or "Unknown track",
                        Artist = #Artists > 0 and table.concat(Artists, ", ") or "Unknown artist",
                        Album = Track.album and Track.album.name or "Unknown album",
                        AlbumId = Track.album and Track.album.id or "",
                        Uri = Track.uri or "",
                        Cover = CacheImage(Track.album and Track.album.id or Track.id, CoverUrl)
                    })
                end

                return Results
            end

            local function GetAlbumTracks(AlbumId)
                local Results = {}
                if not AlbumId or AlbumId == "" then
                    return Results
                end

                local Data = MakeRequest("albums/" .. AlbumId)
                if not Data or type(Data) ~= "table" or type(Data.tracks) ~= "table" or type(Data.tracks.items) ~= "table" then
                    return Results
                end

                local CoverUrl = Data.images and Data.images[3] and Data.images[3].url or
                    Data.images and Data.images[2] and Data.images[2].url or
                    Data.images and Data.images[1] and Data.images[1].url

                for _, Track in Data.tracks.items do
                    local Artists = {}

                    for _, Artist in Track.artists or {} do
                        table.insert(Artists, Artist.name)
                    end

                    table.insert(Results, {
                        Title = Track.name or "Unknown track",
                        Artist = #Artists > 0 and table.concat(Artists, ", ") or "Unknown artist",
                        Album = Data.name or "Unknown album",
                        AlbumId = AlbumId,
                        Uri = Track.uri or "",
                        Cover = CacheImage(AlbumId, CoverUrl),
                        IsAlbumTrack = true
                    })
                end

                return Results
            end

            local function Previous()
                return MakeRequest("me/player/previous", "POST")
            end

            local function Next()
                return MakeRequest("me/player/next", "POST")
            end

            local function Resume()
                return MakeRequest("me/player/play", "PUT")
            end

            local function Pause()
                return MakeRequest("me/player/pause", "PUT")
            end

            local function Shuffle(Enabled)
                return MakeRequest("me/player/shuffle?state=" .. tostring(Enabled), "PUT")
            end

            local function Repeat(Enabled)
                return MakeRequest("me/player/repeat?state=" .. (Enabled and "context" or "off"), "PUT")
            end

            local function Seek(Milliseconds)
                return MakeRequest("me/player/seek?position_ms=" .. math.max(math.floor(Milliseconds or 0), 0), "PUT")
            end

            local function PlayUri(Uri)
                if not Uri or Uri == "" then
                    return nil
                end

                return MakeRequest("me/player/play", "PUT", true, {
                    uris = { Uri }
                })
            end

            local function UpdateResults()
                for Index, Button in ResultButtons do
                    local Result = SearchResults[Index]

                    if Result then
                        Button.Frame.Instance.Visible = true
                        Button.Cover.Instance.Image = Result.Cover or PlaceholderImage
                        Button.Title.Instance.Text = Result.Title
                        if Result.IsBack then
                            Button.Album.Instance.Text = Result.Album or "Return to search results"
                        elseif Result.IsAlbumTrack then
                            Button.Album.Instance.Text = Result.Artist
                        else
                            Button.Album.Instance.Text = Result.Album
                        end
                    else
                        Button.Frame.Instance.Visible = false
                        Button.Cover.Instance.Image = PlaceholderImage
                        Button.Title.Instance.Text = ""
                        Button.Album.Instance.Text = ""
                    end
                end
            end

            local IsVisible = true
            local LastEmptyTokenNotification = 0
            local CustomPosition = nil

            local function NotifyEmptyToken()
                if Token ~= "" or TokenConfig.RefreshToken ~= "" then
                    return
                end

                local Now = tick()
                if Now - LastEmptyTokenNotification < 1 then
                    return
                end

                LastEmptyTokenNotification = Now
                Library:Notification("Empty Spotify Token", 3, Library.Theme["Risky"])
            end

            local function ApplyVisibility()
                Items["SpotifyPlayer"].Instance.Visible = IsVisible
                if Items["SpotifyPlayer"].Instance.Visible then
                    NotifyEmptyToken()
                end
            end

            local function AlignAboveKeybindList()
                local KeyList = Library.KeyList
                local KeyListFrame = KeyList and KeyList.Items and KeyList.Items["KeybindList"] and
                    KeyList.Items["KeybindList"].Instance
                if not KeyListFrame then
                    return
                end

                local KeybindPosition = KeyListFrame.AbsolutePosition
                local SpotifyHeight = Items["SpotifyPlayer"].Instance.AbsoluteSize.Y
                Items["SpotifyPlayer"].Instance.AnchorPoint = Vector2.new(0, 0)
                Items["SpotifyPlayer"].Instance.Position = UDim2.new(0, KeybindPosition.X, 0,
                    KeybindPosition.Y - SpotifyHeight - 5)
            end

            local function SetExpanded(Bool, Instant)
                IsExpanded = Bool

                local Player = Items["SpotifyPlayer"]
                local TweenInfoValue = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                local PlayerAreaPosition = Bool and UDim2.new(0, 10, 1, -78) or UDim2.new(0, 10, 0, 10)
                local PlayerAreaSize = Bool and UDim2.new(1, -20, 0, 68) or UDim2.new(1, -20, 0, 68)
                local SearchPosition = Bool and UDim2.new(0, 10, 0, 10) or UDim2.new(0, 10, 0, -40)
                local ResultsPosition = Bool and UDim2.new(0, 10, 0, 42) or UDim2.new(0, 10, 0, -170)
                local LyricsPosition = Bool and UDim2.new(0, 270, 0, 10) or UDim2.new(1, 10, 0, 10)
                local ExpandRotation = Bool and 90 or 0

                if Instant then
                    Player.Instance.Size = Bool and ExpandedSize or CollapsedSize
                    Items["PlayerArea"].Instance.Position = PlayerAreaPosition
                    Items["PlayerArea"].Instance.Size = PlayerAreaSize
                    Items["SearchBackground"].Instance.Position = SearchPosition
                    Items["SearchResults"].Instance.Position = ResultsPosition
                    Items["LyricsFrame"].Instance.Position = LyricsPosition
                    Items["ExpandButton"].Instance.Rotation = ExpandRotation
                else
                    Player:Tween({
                        Size = Bool and ExpandedSize or CollapsedSize
                    }, TweenInfoValue)

                    Items["PlayerArea"]:Tween({ Position = PlayerAreaPosition }, TweenInfoValue)
                    Items["PlayerArea"]:Tween({ Size = PlayerAreaSize }, TweenInfoValue)
                    Items["SearchBackground"]:Tween({ Position = SearchPosition }, TweenInfoValue)
                    Items["SearchResults"]:Tween({ Position = ResultsPosition }, TweenInfoValue)
                    Items["LyricsFrame"]:Tween({ Position = LyricsPosition }, TweenInfoValue)
                    Items["ExpandButton"]:Tween({ Rotation = ExpandRotation }, TweenInfoValue)
                end

                Spotify:Center()
            end

            local function RunSearch(Query)
                local Trimmed = (Query or ""):gsub("^%s*(.-)%s*$", "%1")
                SearchAlbumBrowse = nil

                if Trimmed == "" then
                    SearchTrackResults = {}
                    SearchResults = {}
                    UpdateResults()
                    return
                end

                SearchTrackResults = SearchTracks(Trimmed)
                SearchResults = SearchTrackResults
                UpdateResults()
            end

            local function QueueSearch(Query)
                SearchRequestId += 1
                local RequestId = SearchRequestId

                task.delay(SearchDelay, function()
                    if RequestId ~= SearchRequestId then
                        return
                    end

                    RunSearch(Query)
                end)
            end

            local function RefreshSoon()
                task.delay(0.2, function()
                    if Library and Items["SpotifyPlayer"] and Items["SpotifyPlayer"].Instance.Parent then
                        Spotify:Refresh()
                    end
                end)
            end

            local function SetSeekingFromInput(Input)
                if not CurrentTrack or not CurrentTrack.Duration or CurrentTrack.Duration <= 0 then
                    return
                end

                local Bar = Items["ProgressFrame"].Instance
                local PositionX = Input.Position and Input.Position.X or UserInputService:GetMouseLocation().X
                local Alpha = math.clamp((PositionX - Bar.AbsolutePosition.X) / math.max(Bar.AbsoluteSize.X, 1), 0,
                    1)
                local Position = math.floor(CurrentTrack.Duration * Alpha)

                CurrentTrack.Progress = Position
                CurrentTrack.UpdatedAt = tick()
                SetProgress(Position, CurrentTrack.Duration, true)
            end

            Library:BindToWindowVisibility(ApplyVisibility)

            Items["SpotifyPlayer"]:Connect("InputEnded", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    CustomPosition = Items["SpotifyPlayer"].Instance.Position
                end
            end)

            function Spotify:SetVisibility(Bool)
                IsVisible = Bool
                ApplyVisibility()
            end

            function Spotify:Center()
                task.wait()
                if CustomPosition then
                    Items["SpotifyPlayer"].Instance.AnchorPoint = Vector2.new(0, 0)
                    Items["SpotifyPlayer"].Instance.Position = CustomPosition
                    return
                end
                AlignAboveKeybindList()
            end

            function Spotify:SetPosition(Position)
                CustomPosition = Position
                Items["SpotifyPlayer"].Instance.AnchorPoint = Vector2.new(0, 0)
                Items["SpotifyPlayer"].Instance.Position = Position
            end

            function Spotify:GetBounds()
                local Instance = Items["SpotifyPlayer"].Instance
                return Instance.AbsolutePosition, Instance.AbsoluteSize
            end

            function Spotify:SetToken(NewToken)
                TokenConfig = DecodeTokenConfig(NewToken)
                Token = TokenConfig.AccessToken
                WriteToken(TokenConfig)
                Spotify:Refresh()
            end

            function Spotify:Refresh()
                if not Request then
                    SetDisplay(nil, "Executor request API unavailable")
                    return false
                end

                if Token == "" and TokenConfig.RefreshToken == "" then
                    SetDisplay(nil, "Add a token or refresh config to niggahack/token.txt")
                    return false
                end

                if TokenConfig.RefreshToken ~= "" and (TokenConfig.ClientId == "" or TokenConfig.ClientSecret == "") then
                    SetDisplay(nil, "token.txt needs client_id and client_secret")
                    return false
                end

                if not EnsureAccessToken() then
                    SetDisplay(nil, "Could not refresh Spotify token")
                    return false
                end

                if not ValidateToken() then
                    SetDisplay(nil, "Invalid token in niggahack/token.txt")
                    return false
                end

                local Track = GetCurrentTrack()
                SetDisplay(Track, "Nothing is currently playing")
                SetQueueDisplay(Track, GetQueue(), "No upcoming tracks.")
                return Track ~= nil
            end

            for Index, Button in ResultButtons do
                Button.Button:Connect("MouseButton1Click", function()
                    local Result = SearchResults[Index]
                    if not Result then
                        return
                    end

                    if Result.IsBack then
                        SearchAlbumBrowse = nil
                        SearchResults = SearchTrackResults
                        UpdateResults()
                        return
                    end

                    if Result.IsAlbumTrack then
                        PlayUri(Result.Uri)
                        RefreshSoon()
                        return
                    end

                    SearchAlbumBrowse = Result.AlbumId
                    SearchResults = GetAlbumTracks(Result.AlbumId)

                    if #SearchResults > 0 then
                        table.insert(SearchResults, 1, {
                            Title = "< Back",
                            Album = Result.Album or "Back to results",
                            Cover = Result.Cover,
                            IsBack = true
                        })
                    end

                    UpdateResults()
                end)
            end

            Items["SearchInput"]:Connect("FocusLost", function(PressedEnter)
                if PressedEnter then
                    SearchRequestId += 1
                    RunSearch(Items["SearchInput"].Instance.Text)
                end
            end)

            Library:Connect(Items["SearchInput"].Instance:GetPropertyChangedSignal("Text"), function()
                QueueSearch(Items["SearchInput"].Instance.Text)
            end)

            Items["ExpandButton"]:Connect("MouseButton1Click", function()
                SetExpanded(not IsExpanded)
            end)

            Items["PlayPause"]:Connect("MouseButton1Click", function()
                if CurrentTrack and CurrentTrack.IsPlaying then
                    Pause()
                else
                    Resume()
                end

                RefreshSoon()
            end)

            Items["Shuffle"]:Connect("MouseButton1Click", function()
                Shuffle(not (CurrentTrack and CurrentTrack.Shuffle))
                RefreshSoon()
            end)

            Items["Repeat"]:Connect("MouseButton1Click", function()
                local RepeatEnabled = CurrentTrack and CurrentTrack.RepeatState and CurrentTrack.RepeatState ~= "off"
                Repeat(not RepeatEnabled)
                RefreshSoon()
            end)

            Items["ProgressHitbox"]:Connect("InputBegan", function(Input)
                if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end

                Seeking = true
                SetSeekingFromInput(Input)
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if not Seeking then
                    return
                end

                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    SetSeekingFromInput(Input)
                end
            end)

            Library:Connect(UserInputService.InputEnded, function(Input)
                if not Seeking then
                    return
                end

                if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end

                Seeking = false

                if CurrentTrack then
                    Seek(CurrentTrack.Progress)
                    RefreshSoon()
                end
            end)

            Library:Thread(function()
                while Library and Items["SpotifyPlayer"] and Items["SpotifyPlayer"].Instance.Parent do
                    Spotify:Refresh()
                    task.wait(PollInterval)
                end
            end)

            Library:Thread(function()
                while Library and Items["SpotifyPlayer"] and Items["SpotifyPlayer"].Instance.Parent do
                    if Seeking and CurrentTrack then
                        SetSeekingFromInput({
                            Position = UserInputService:GetMouseLocation()
                        })
                    end

                    if CurrentTrack and CurrentTrack.IsPlaying and not Seeking then
                        local Progress = math.min(CurrentTrack.Progress + ((tick() - CurrentTrack.UpdatedAt) * 1000),
                            CurrentTrack.Duration)
                        SetProgress(Progress, CurrentTrack.Duration, true)
                    end

                    task.wait(0.1)
                end
            end)

            Library:RegisterLayout("SpotifyPlayer", {
                Instance = Items["SpotifyPlayer"].Instance
            })

            UpdateResults()
            SetExpanded(false, true)
            Spotify:Center()
            return Spotify
        end

        Library.Playerlist = function(Self, Params)
            local Playerlist = {
                Items = {},
                IsSettings = true,
                Players = {},
                Selected = nil,
            }

            local Items = {}
            do
                Items["Playerlist"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Size = UDim2.new(0, 461, 0, 403),
                    Position = UDim2.new(0, 828, 0, 99),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = 'Background' })

                Items["Playerlist"]:MakeDraggable()

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Playerlist"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Playerlist"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Items["AccentLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Playerlist"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = 'Accent' })

                Items["DarkLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Playerlist"].Instance,
                    Position = UDim2.new(0, 0, 0, 1),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Light Border"]
                }):AddToTheme({ BackgroundColor3 = 'Light Border' })

                Items["Background"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Playerlist"].Instance,
                    Position = UDim2.new(0, 10, 0, 30),
                    Size = UDim2.new(1, -20, 1, -90),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = 'Section' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Items["Holder"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarImageColor3 = Library.Theme["Accent"],
                    MidImage = "rbxassetid://129030709932941",
                    ScrollBarThickness = 1,
                    Size = UDim2.new(1, -16, 1, -16),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 8),
                    BottomImage = "rbxassetid://129030709932941",
                    TopImage = "rbxassetid://129030709932941"
                }):AddToTheme({ ScrollBarImageColor3 = 'Accent' })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    PaddingTop = UDim.new(0, -4),
                    PaddingRight = UDim.new(0, 8)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Playerlist"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 1, 0),
                    Size = UDim2.new(1, -20, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Padding = UDim.new(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    PaddingBottom = UDim.new(0, 10)
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Playerlist"].Instance
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Playerlist"].Instance,
                    TextColor3 = Library.Theme["Accent"],
                    Text = Params.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    Position = UDim2.new(0, 10, 0, 6),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Accent' })

                Playerlist.Items = Items
            end

            function Playerlist:Add(Player)
                local PlayerName = Player.Name
                local PlayerDisplay = Player.DisplayName or PlayerName
                local PlayerUserID = Player.UserId

                local PlayerItems = {}
                do
                    PlayerItems["NewPlayer"] = Library:Create("TextButton", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = Items["Holder"].Instance,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "",
                        AutoButtonColor = false,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 20),
                        BorderSizePixel = 0
                    })

                    PlayerItems["Username"] = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = PlayerItems["NewPlayer"].Instance,
                        TextWrapped = true,
                        TextColor3 = Library.Theme["Text"],
                        Text = PlayerDisplay .. " (" .. PlayerName .. ")",
                        Size = UDim2.new(0, 0, 0, 15),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0.5, 0),
                        AutomaticSize = Enum.AutomaticSize.X
                    }):AddToTheme({ TextColor3 = 'Text' })

                    PlayerItems["UserID"] = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = PlayerItems["NewPlayer"].Instance,
                        TextWrapped = true,
                        TextColor3 = Library.Theme["Text"],
                        Text = tostring(PlayerUserID),
                        Size = UDim2.new(0, 0, 0, 15),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        AutomaticSize = Enum.AutomaticSize.X
                    }):AddToTheme({ TextColor3 = 'Text' })

                    PlayerItems["Status"] = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = PlayerItems["NewPlayer"].Instance,
                        TextWrapped = true,
                        TextColor3 = Library.Theme["Text"],
                        Text = "Neutral",
                        Size = UDim2.new(0, 0, 0, 15),
                        AnchorPoint = Vector2.new(1, 0.5),
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(1, 0, 0.5, 0),
                        AutomaticSize = Enum.AutomaticSize.X
                    }):AddToTheme({ TextColor3 = 'Text' })
                end


                local PlayerData = {
                    Name = PlayerName,
                    Display = PlayerDisplay,
                    Player = Player,
                    Items = PlayerItems,
                    Status = "Neutral",
                    IsSelected = false,
                }

                function PlayerData:ToggleState(Status)
                    if Status == "Active" then
                        PlayerItems["Username"]:ChangeItemTheme({ TextColor3 = "Accent" })
                        PlayerItems["Username"]:Tween({ TextColor3 = Library.Theme.Accent })
                    else
                        PlayerItems["Username"]:ChangeItemTheme({ TextColor3 = "Text" })
                        PlayerItems["Username"]:Tween({ TextColor3 = Library.Theme.Text })
                    end
                end

                function PlayerData:Set()
                    PlayerData.IsSelected = not PlayerData.IsSelected

                    if PlayerData.IsSelected then
                        Playerlist.Selected = PlayerData

                        PlayerData.IsSelected = true
                        PlayerData:ToggleState("Active")

                        for Index, Value in Playerlist.Players do
                            if Value ~= PlayerData then
                                Value.IsSelected = false
                                Value:ToggleState("Inactive")
                            end
                        end
                    else
                        Playerlist.Selected = nil

                        PlayerData.IsSelected = false
                        PlayerData:ToggleState("Inactive")
                    end

                    Library:SafeCall(Playerlist.Callback, Playerlist.Selected)
                end

                PlayerData.Items.NewPlayer:Connect("MouseButton1Down", function()
                    PlayerData:Set()
                end)

                Playerlist.Players[PlayerData.Name] = PlayerData
                return PlayerData
            end

            function Playerlist:Remove(Player)
                if Playerlist.Players[Player.Name] then
                    Playerlist.Players[Player.Name].Items.NewPlayer.Instance:Destroy()
                end
            end

            function Playerlist:SetVisibility(Bool)
                Playerlist.Visible = Bool
                Items["Playerlist"].Instance.Visible = Bool and Library.WindowOpenState
            end

            function Playerlist:Center()
                local AbsPos = Items["Playerlist"].Instance.AbsolutePosition
                Items["Playerlist"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["Playerlist"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            function Playerlist:SetText(Text)
                Items["Text"].Instance.Text = Text
            end

            local StatusDropdown = Library:Dropdown({
                Name = "Status",
                Flag = "PlayerlistStatus",
                Items = { "Neutral", "Enemy", "Friendly" },
                Parent = Items["Playerlist"],
                Callback = function(Value)
                    if Playerlist.Selected then
                        local PlayerItems = Playerlist.Selected.Items

                        if PlayerItems then
                            local NeutralColor = Library.Theme.Text
                            local EnemyColor = Color3.fromRGB(255, 0, 0)
                            local FriendlyColor = Color3.fromRGB(0, 255, 0)

                            PlayerItems["Status"]:Tween({
                                TextColor3 = Value == "Enemy" and EnemyColor or Value == "Friendly" and FriendlyColor or
                                    NeutralColor
                            })

                            PlayerItems["Status"].Instance.Text = Value
                            Playerlist.Selected.Status = Value
                        end
                    end
                end
            })

            StatusDropdown.Items.Dropdown.Instance.Position = UDim2.new(0, 10, 1, -10)
            StatusDropdown.Items.Dropdown.Instance.AnchorPoint = Vector2.new(0, 1)
            StatusDropdown.Items.Dropdown.Instance.Size = UDim2.new(1, -20, 0, 40)

            for Index, Value in Players:GetPlayers() do
                Playerlist:Add(Value)
            end

            Playerlist.Visible = true
            Library:BindToWindowVisibility(function(IsWindowOpen)
                Items["Playerlist"].Instance.Visible = Playerlist.Visible and IsWindowOpen
            end)

            Library:Connect(Items["Content"].Instance.ChildAdded, function()
                task.wait()
                Items["Content"].Instance.Position = UDim2.new(0, 10, 1, Items["Content"].Instance.AbsoluteSize.Y)
            end)

            Library:Connect(Players.PlayerAdded, function(Player)
                Playerlist:Add(Player)
            end)

            Library:Connect(Players.PlayerRemoving, function(Player)
                Playerlist:Remove(Player)
            end)

            Library:RegisterLayout("Playerlist", {
                Instance = Items["Playerlist"].Instance
            })

            Playerlist:Center()

            return setmetatable(Playerlist, Library)
        end

        Library.Tooltip = function(Self, Text)
            local Object = Self.Instance

            if not Object or Text == nil then
                return
            end

            if type(Text) == "string" then
                Text = {
                    Title = "",
                    Description = Text
                }
            end

            local TitleThemeKey = Text.ColorThemeKey or Text.colorThemeKey or (Text.Risky and "Risky") or "Accent"
            local TitleText = tostring(Text.Title or "")
            local DescriptionText = tostring(Text.Description or "")
            local ShowTitle = TitleText ~= ""
            local TooltipFrame = nil
            local RenderStepped = nil

            local function DestroyTooltip()
                if RenderStepped then
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end

                if TooltipFrame then
                    TooltipFrame:Destroy()
                    TooltipFrame = nil
                end
            end

            local function CreateTooltip()
                DestroyTooltip()

                local Items = {}
                Items["Tooltip"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Position = UDim2.new(0, 873, 0, 10),
                    BorderSizePixel = 0,
                    ZIndex = 50,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({ BackgroundColor3 = "Element" })
                TooltipFrame = Items["Tooltip"].Instance

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = TooltipFrame,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = TooltipFrame,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                local TitleLabel = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = TooltipFrame,
                    ZIndex = 51,
                    TextColor3 = Library.Theme[TitleThemeKey] or Library.Theme["Accent"],
                    Text = TitleText,
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    Visible = ShowTitle
                }):AddToTheme({ TextColor3 = TitleThemeKey })
                TitleLabel.Instance.Text = TitleText
                TitleLabel.Instance.Visible = ShowTitle

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = TooltipFrame,
                    PaddingTop = UDim.new(0, 4),
                    PaddingBottom = UDim.new(0, 4),
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })

                local DescriptionLabel = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = TooltipFrame,
                    ZIndex = 51,
                    TextColor3 = Library.Theme["Text"],
                    Text = DescriptionText,
                    Size = UDim2.new(0, 0, 0, 15),
                    Position = ShowTitle and UDim2.new(0, 0, 0, 18) or UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = "Text" })
                DescriptionLabel.Instance.Text = DescriptionText

                local MouseLocation = UserInputService:GetMouseLocation()
                TooltipFrame.Position = UDim2.new(0, MouseLocation.X + 20, 0, MouseLocation.Y + 20)

                RenderStepped = RunService.RenderStepped:Connect(function()
                    if not TooltipFrame then
                        return
                    end

                    local UpdatedLocation = UserInputService:GetMouseLocation()
                    TooltipFrame.Position = UDim2.new(0, UpdatedLocation.X + 20, 0, UpdatedLocation.Y + 20)
                end)
            end

            Self:OnHover(CreateTooltip, DestroyTooltip)
            Library:Connect(Object.AncestryChanged, function(_, Parent)
                if Parent == nil then
                    DestroyTooltip()
                end
            end)
        end

        
-- NC 3.0: independent visual primitives, original behavioral API retained.
Library.Design = {}
function Library.Design.Round(object, radius)
    local c = object:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius); c.Parent = object
end
function Library.Design.Stroke(object)
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Library.Theme.Outline; stroke.Transparency = 0.35
    stroke.Parent = object
    setmetatable({Instance = stroke}, Library):AddToTheme({Color = "Outline"})
end
function Library.Design.Box(parent, position, size, theme, radius)
    local box = Library:Create("Frame", {Parent = parent, Position = position,
        Size = size, BorderSizePixel = 0, BackgroundColor3 = Library.Theme[theme]})
    box:AddToTheme({BackgroundColor3 = theme})
    Library.Design.Round(box.Instance, radius or 8)
    return box
end
function Library.Design.Text(parent, text, position, size, theme, fontSize)
    return Library:Create("TextLabel", {Parent = parent, Text = text,
        Position = position, Size = size, BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = Library.Theme[theme],
        FontFace = Library.Font, TextSize = fontSize or 12,
        TextTruncate = Enum.TextTruncate.AtEnd}):AddToTheme({TextColor3 = theme})
end
Library.Version = "3.0"
Library.LogoAsset = ""
do
    local ok, asset = pcall(function()
        local loader = getcustomasset or getsynasset
        if not loader then return "" end
        local path = Library.Directory .. Library.Folders.Assets .. "/NC-brand.jpg"
        if not isfile(path) then
            local hex = "ffd8ffe000104a46494600010100000100010000ffe201d84943435f50524f46494c45000101000001c800000000043000006d6e74725247422058595a2007e00001000100000000000061637370000000000000000000000000000000000000000000000000000000010000f6d6000100000000d32d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000964657363000000f0000000247258595a00000114000000146758595a00000128000000146258595a0000013c00000014777470740000015000000014725452430000016400000028675452430000016400000028625452430000016400000028637072740000018c0000003c6d6c756300000000000000010000000c656e5553000000080000001c007300520047004258595a200000000000006fa2000038f50000039058595a2000000000000062990000b785000018da58595a2000000000000024a000000f840000b6cf58595a20000000000000f6d6000100000000d32d706172610000000000040000000266660000f2a700000d59000013d000000a5b00000000000000006d6c756300000000000000010000000c656e5553000000200000001c0047006f006f0067006c006500200049006e0063002e00200032003000310036ffdb00430001010101010101010101010101010102010101010102010101020202020202020202030304030303030302020304030304040404040203050504040504040404ffdb00430101010101010102010102040302030404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404ffc00011080438043803012200021101031101ffc4001f00000202010501010000000000000000000102000304050607080b0a09ffc400741000010204040305050505050207070129010211000321310405124106075108226171f0091332819142a1b1c1d10a1452e1f11516172362243318262734437282253644537374a228374654636492a4b2b3c2191a3538475657658493a3a5b4b5d2d3d566757795c329454855838594c5d4ffc4001c0101000301010101010000000000000000000102030405060708ffc40053110002010302030403090b090605050100000102031121043105124106135161223271071442528191a1b1d1152333536272b2c1c2e1f016344363739293a3d224358294a2b3255474c3f1264445838455ffda000c03010002110311003f00f3ff008913771f289001b51ef03e76b44f1821b7fbb7800436a043171e568588febac013ce2794489001f0b8da07ddf9430d3b923f3805b6fbeb117c801f082fe1b34089120274ecff00388d5bf99681d69fca24005cd8134b5623d08eb78106ec00ac400b543daee217ab3c4a7a31036fd22412239162d122401227ced6823724388100482fbb978243750377a182c090de571000d46943f53588ef725ba412963435db680124c2c0563d20d4f8fdf0749b0ab5e0a52e4d837888949bd80a09db7a79c46a134a7d61f433bfc9a0fbb2c6a2b489e597802afba1ab6bbf8bc59eead5a3b13fa4112cb5c103e50506f705442459dfc7ca0793b45c50180036776a88aca1ea9fe507160818071523e95853535f5d21ca0b0aedb440870e4b1e86af11cb2b82b890feec91e22ef688104fd6a0c2cfc00ae46e47ce093415722f04cb356a81e30c99648637fc21cb2f005753535f3885b67347262df764529523ccc1f764780f1a44f2cbc0599531b9714a163028c2fe3d22ed04b8776eb430beed9ac7effce1c9205649b3922217b17f0787f764bd3676786f776058d1dc9b79439257b5814c31340c4d9887a438977a8b41f745853e66e61cb2f026cca47ddbc1debbef16fbb15dc08210e052a0d07d627925b9192921ad63689723512df58bbddb165391d06d034fc4c1fc40b447231629f9bc101e2cd0d4bf8c112ff12d5ac39657b1366541cd41abb78c1005412c450748b7dd82e41af488503cfa9eb0e497520a43bd1eec5a9049a354397222df7628410fb37e7004b2e4104b54f5311cb2f0162b0934adc3c0fa853c5a25fdab31df7aed13dd28b306045ec6279240a88dc3f8936860458d48b1720343fbb2cdd0bd6014540a03b96221c92f0162ba3de9e378845680fce2ef76090c2f589eecf417630e4902963d0fd2087177620d3e5170469bec7e7042756ae8f6df68b776c1486a004b3ef4e900d58004b0a9de2f4ca635a743d208944397b9daa62bc925b831c85160c7ca1d882c4127abf48b44b24bb30019f68010012ce5edd225536f616652db9a86a355a03331346bf58c9f76494806e1cd2a217dd026b46f881ade0e0fa029624920dea2ac6f0b5277768c8f760b966a354b7ca025152490e051ef0e4913cafc0a83807702c6c2e22303705fcfc778bc24b54d774ee7ca0b0a02c7631654de1849b6633921a90b192658028459c1f94032c6c456a5448ac42a72166f628001fc3ce0b0ea6a6db98b3402cce962ce4d3ce0a65d751722fe311c8ef620ada8db5fab79c2351e32ccb771420efb40527490e5fe513ddb26ccc72ea34b1b4066bdbf18cb28492c030fb547de2a280fdd6347b5fe50eedf416654d5dd856a2a440b1a6d68bca6a55bb77411104b04db6da8d13dd4ba0e5654124311781a5de8d577661191eec3035f10ccd0feeac5d9cd03c3ba913cb2f03158b38538bfd203387abefb88ca12482ccd4a93568025b00e9a97ab37ce2ca84c8e5918ad427a44a966058506f19464298960c0b92cff005864c9569a8aec19818854677b342ccc5d05dabd48b344d2a0ece3e6cf196252bf23d60fb951b8dfa83f38b7bde5e04f2b310a0d146967f1f9c0090d5a815a3c65aa5906d4141d20894e0b0650b9b83d227ded37b21cacc509634abecdf485d0c58b826dbf9c65fba53f97d3f189ee943e94783d3cba225c1ad8c5285313bbb3758212a602cde3453c64fba533817f9010e24b1a80cee52444fbde4f61c8cc228d8034ad7a44087706c37fca350f72412c1dec06de515890a3f64b6fb3c169a6dec42848c4d05ae08771e304cb2e013e4046a030c010482c6a2a444fdd81f8438f02f1a2d24fc0b776f634d29533b96e9583a081aae6ccdbc672b0c46da7601e20c392cd6ddf78afbd65d510a0d983a146e0fd7cda269247de7d7e719a641b55091d77f941121d26956a802b165a49df664f76618406b03561d6014a8b5d8ed19e30e18d082f4ab443299c5d8fc4c6225a59f8074df430022df488515609d5b9ea232cc921880de076a4219276af98688f7b4d742141f5312a295a5c34062db920b58d0465e82e36373d6014d4b0f974a466f4f3dc8706b63158d45fc9e25c6f4b7e717196e4bfdec20196d5b0356dcc64e9c93b1528afcb7890e535600c2b176b91b5da2967b8202d6371f48113e5bc1a53ef10006b5abf7447bf8de244f5d6002e480361602200372cf68107a177373e1004ad059bee8600394a9ddee0c2bbdebe3bc0b5e2005856b407e66039162d10b6cff38900125f727ce25bcfe8d03eff00c2253d18904a9ea7ef88c7a5ed04358dbaee20b03a8bdaa3c622f6029fe5120bf573f3811209e8c4834a53cde2400208a1a87f0811200913eefbe1986a67a758585ee0912183b1ab0fa3c2edf9ef0048229e3e710024d03f8408009772f7de238a3d40895341b9b40fc7788f204672c2bd219994376a9f0882a0802bd7ac14bd85954f288be40a431f03506250350b5eb478163d58fd60d547d522c09bd478b0a40f286487a06afd61d32ddac6be348949b0200efe1b7582107cb62f71170497b977f2116252aab0634a8b46b1a4ddae59464f263e8a783b96a9116896081668bc4a53a753b1e80823ac65e1b03367cc4c9952e6cd9d39411264ca42a64d9a49601280e4b960c0131b434d29612cb2ca9dcd2fdd81d5dfce1f4000b00e43b4762f84bb2c73d78be48c565dcbacf70180500463f88e47f772494e9d414846234cd5a48b290823c639067f656cb7854a95ccde7172ff008467c99417372ac3e3c66b9c02e02922425426387ffc5d768f7f4bd92e3ba8a7df474b28c3e34ed08ff7a6e2adf29d50d0579ae6e476f1785f4d8e9968704149bf9561d32945804f8960ec1a3b813382bb2ee4e8489dc6fc77c5d352015ab23c9865b85986ae12a9a8496b576788388bb36e5652701ca1e23cf6684b03c43c4cb44b761532d2b29af88f9475bec9ce92e6d4eae847d93737fe5c66be92ef47cb994a3f3dfeab9d40328a5891522c431222250f729a9607501f58edf4ce6f72cf0aa032ae407034a092c8fed24cac72fe6f25c98b13da1b2ec3847ee9c9ae57619290c08c965a88b8da5da1f70b8547f09af8fc94ea3fad223ded47ad4fa1fee3a7dee98fc480f47d49686128289efcbf2d49a563b889ed22c5cf297954add95c3b2c934dce98c85769b5b253fe10f2a10924064f0e22bffa2f12b82f05ff00fd05fe0cfed1ef7a3d27ff004fef3a6624822e87f158686f720dd52d8d07f989711dc8576975803fe497952583d38725b9a7fd4da17fe12d356c4729f957ddad387e5b0ffd082e0bc197ff007ebfc29fda42a1497f49ff004fef3a77ee06d3250dbfde27ac2aa504b77d05c57be922d1dce4769c524693ca4e559015739023f0d118ebed22262d4bff0008f950a2455f87904fd74c5bee3705e9afff002a7f68ee697e33fe9fde74e952d3bad2f6002857d7585f74800695201bb1580df7c7718f68f0940ff924e5580ec74e42963e7ddac14f6954cb24ff00845ca92d67c812e3ff00462af837055b710ff267f68ee295d5a78f67ef3a72252348216824d082b49689ee524d264b077d4b48f9c7720769da8ff920e54dfe1feefa5be634c658ed4129ebc9ae532992ee3204bb7fed9157c1b8325fcfd7f853fb497429fc7fa3f79d2ef7093ff488b5f5a58f8886f708a0f792c01665a49fc63b98bed3f24b14726f953e3ff70525bff4231d7da6e4adc7f83dcab4921c2864690dff00a112b84707ff00cfff00953fb49f7bd25b54ff00a5fda74e0c9482e5686dff00cc483bc37b89756992c1351fe6263b74aed1f21442d5ca2e56d4fc472149d5ff00a1171ed252c4b095728795600a829c8101ff00f422df723837fe7d7f853fb42a149afc27fd2fed3a8025241d2264b2f52f313483ee907eda2829fe626b4aef1dbd97da4e4215abfc1fe5692ecffd852fff00b88c957693c34c5a48e4ef2a40009d272196a0587fd489fb8fc1ad7fba0bfc298ee297e33fe97f69d363213b2e590f5ff3120fe30dee25b252572fabfbc481f8c772476979029fe0cf29140fc2fc3d2c8fa68845f690c295151e4df29029541ff17914bffa21f71b82afff0020bfc2a842a14af9a9f47ef3a76644bf8b5cb71461312e69104a43b95cb2ff00fb3131dc21da4e44b0527939ca9219c69c82586a7fd4874f69c90962ae4df2a8a59dce468ffee21f72382ac7bfd7f855097428dbf09ff4b3a729932c380b457ff66269783ee104241992d81de6a5a3b86bed33879a34a3935ca996a76a6428634ffa97b4543b49ca97ff00c88395069ffcaf20134ffa915fb93c1d2c6bbfca991dc53dd4ff00e9fde7509521157992c52844d4fd610484876992ebd662691dc51da652eeae5072ad6cd43904a61ffd4e2cff0084d61d243f26b94e5d82b56408707ffa5c3ee4f07b7f3f5fe14c7714d6d3fa3f79d373212555992886ff00c6a4f48064268cb961cd5a6a47e7e9e3b8c3b4c4a0a511c9be5254d7570e4b537fe843abb4fc9aa0f26f9468045d3c37240bff00e4e0f84f06ebae5fe14fed0a8d3eb3fa3f79d34321352664b24ffecc487a1871252c46b963abcd4d7ef8edf9ed2b85673c9de5413771c3b2406ffe970b37b496116c93c9ee55cb533b0c82591e0ed2c457ee4f07ebaeff002a647754ef6e7fa3f79d413210a63ad018301ef121af13dc2481df94081b4d4c76ecf693912f494f283953514238792e7e89874f69695f17f843ca93d5f87d35b7fa61f72b832cfbfd7f853fb48eea0f1cff0047ef3a81ee527e1992697ff3524987125151ef1007fe552f1dc03da764218ff835ca75bd09fec14ba7e7a3d3c37fc272402e792fca520b328e412c81f3f770fb95c1ff00f3dfe54c9ee69759ff00d2fed3a7c24a0b77e58635066a43c29928258cc456b49a96fc63b8733b4d482747f833ca7964870d904b248ebf05a023b4b494104f277955a49d2e9c825036ff00c9fdf0fb95c1b7f7f2ff000a7e442a34dbf5fe8fde74f061d3a8ff009929bff2a97fc61bf7749bae5382e4fbd4b6fe31dc4ff84d48d2529e4e72a89722b90cb636ff00d9703fe13585046be4c72a2cec32092fe67fca88fb97c1dafe7cbfc2991ddd256bcfe83a7aac3a45972875ff0035209fbe1bf774103fcd94cdbcd4dfeb1dc893da870e86527931ca55a41ffa4e1e96afbf40119533b57a3484cbe49f275942aa3c3682ff00fa305c2f83eef5cbfc2992a9d3f8ff0047ef3a52ac3a013fe64a3fc3fe6a4fe711121203fbc940b7fe3527f38ee20ed3f87593317c96e4e824d1b8611ffdcc640ed57874f753c95e4f243690a4f0d2126cd7d3e70fb99c1b1fedcbfc2991ddd35bcfe8fde74e3dc4b0184d95f39c96fc617f7696e0fbd94fbff9c9fd63b9f2bb597bb57feb17e5094d5bfe2ea124d7feac09bdac55359b931ca14750786d0a1beda20b86705bdbdfdfe54fed23929fc7fa3f79d3238796dfef6539a969a9681ee50f5992ba526a5beaf1dc51da9a840e4cf27ca9577e17402283fd30a3b4fb10b4727394443d5f86d2e2b6f862cb85f066ddb5dfe54fed2ca9d37b4fe8fde74ece1e59b4c9434d0113521fef88244b6d3ef258a54998924c772ffe152c3ff58ef2947774f778750df7a3d34507b4e4a03de7f83dca96517ffbdc9409f9fbbde1f72f83db1aeff2a7f6854e9bcf3fd074efdc4b1433251ad3fcd4948fbe21c34b707de4ab8ffa6496ebbc770d5da7f5a4a47273950e5543fddf96f7b368851da70ca607937ca4219cb70ecb614ffa9155c2f83f4d6ff953fb47774dfc3c7b3f79d40f712cbb2e502ecfef53510c30f245e649714a4d491f8c76fd7da81d4928e4f729924076feefa0a36e8914874f6a89891a0726f9424bb13fddc413f84170de0eb0f5bfe54fed0e9d35bcfe8fde74f4c894e1a64a0901b4fbd4feb03dc4aef0f7926ae01f789fd691dc14f6a69e924a3943ca6053f6470ea0907ff6d88bed578b5a4a0f2979549043f7387a58fa772d13f73b82dbf9ee7fb29fda42853f8ff41d3a32250a19928867a4d49fce1cc995b2e59a3319a9fbe3b763b502a8fca7e579502f4c81009fa22166769d9b884e93cace59241b27fb050a76ff00b111f73b83dff9eff953fb49eee9fc7fa3f79d471290c405ca09ff00ca27f586f752880d3250d8933520fe31daa1da4b1092aff92ee59020b03fd8081f826d19c8ed35889652a1caee582b4ff1e429376ff4c5bee7f06ffce7f973fb47774fe37d1fbcea409127ff001922ef59a83bf9c4f7128853cc923c04e457ef8ee44bed5d8a960a4728f94caff5af86e5a974ff00b10a7b56e26855ca3e51b9352ae169448f3ee50442e1fc1fff0039fe5cc7770bdb9be8fde74e3dc4a6ff007921ee3fce436de30061d25415ef24dead391e3d0c772a676b0c4225a82793dca0634d6385d0923e404628ed558aff00e645ca215b27869237f282e1fc1f67adff002e639295edcff47ef3a86244ba9136410dbcd4f4f389fbb49703df48ea4fbe48023b6ebed4d89243729b94e1aa52386d1a453a698cb93dabb1c82027951ca866b8e1a974b57e0a45e3c3f82ffe73fca9fda472d36d5a5f47ef3a869c34a60f3e4d6bfef915fbe2cfdda410defe481b7f9c8e9e71dbd1dac73162dcabe55ac82000be1a9445cffa21ff00e16b988ef1e53f2983259d3c352c2a9ff66378e878145675bfe54fed2dddd3ddcfe83a809c2c87acf905e81a7200b8f183fbbca648f7d2016650188453effbbc23b823b5ae64805b951ca562757fdeda4a887f28599dadf315253a3953ca9954ef14f0e27bc18eda6f12b47c0eff00cf7fca9fda5bbba6d627f47ef3a81fbac8b89d243023fdfa7f586fdd242401eff0f7727dfa037cde3b6eaed659a4c3dce57f2b90e9fb1c3a84b90dfe9bc099daab385e954be5a72d0048d4b49c8d2a018f4d3411a4749c053fe7bfe54fed25428eee7f47ef3a9070b228d3f0fa4dc99c873f7fdd0c9c1c82693f0e0117f7e81f9c76c476abce904ac72d7964c68eae1f4299f6f863224f6b6cf25b84f2e79620dca7fbba925a9e117f7b7015b6b2ff00fea9fda39287c7cfb3f79d4b384c3d53eff0fe07f7847e2f0460e45009f872c1a93e583f8c76f7fe1799f2405ff873cb2075534e40975576eefa783ff0becf40055cb7e59943f7df221d3ca9e712b4fc07796aff00ca9fda4f252bfadf47ef3a849c1e1aa0cfc3f9fbe4103ef87384c296231186045ffcf457effbe3b72aed779d2c777967cb262ecf91820f8da191db0388007ff0c795841dff00bbe6df2bc5fdefd9e5ff00ddff00953fb49e4a5f1f3ec3a8a9c260dc3e230c4d89f7e8007df168c2e14927dfe119981fde25fd59e3b6cbed7b9f150983969caf748fb59193a7eb1908ed93c4928148e5a72c8ea1451c93411f75e34850ecf259d67f953ff516e4a5bba9ff004bfb4ea2270984512f88c3314d1b128fd620c0e15ab89c2a542bff00399601fbfd3c76d8f6c9e2605c72ef97001356ca0807ee8b15db238a34a9f979cb94bddb2a53fdd1ba8766e38f7ddfff00d52fb42a7a7eb3ff00a5fda751c60f0adff38c291d062114fbe27ee3872e7f78c287a37bf453ef8ed62bb607149482397bcb800fff003a167f3883b6271521234f2f796ee0b97c9d446db3c4a876652bfbebfca9fda43850b5d4fe8fde754ffb3e42b4ff00b46149b5310861f7c4397e1925fdfe195e3efd0df8f9c76d13db2b8b1dd3cbce5d25203d72d5d3e6f142fb64717127ddf0272ec02970f94cc2df32a82fe4c6d2d4bff0a5fea1cba7b5f9be83aa49cbf0fde79f8767a3ce43fe315ab018703fdee1d9eaf3d15fbe3b57ff000c1e2f5b8fee3f2f86ce9caa606fbe2b1dacf89d6b0711c15c073e516d6839691d68090445ff00fa5f6f7cbff0a5f691cb43e37d0754ce0a4314a6761cf51ef900dbce21ca94b4909014d5ee9d5e8476c57da8b013c14e61ca5e08c4a4fc6f84c32b5860e197863f53d62d473d79399938cfbb3e70c4c4cca6bcac6130538870e52a44996a7bd418de9f0fecc6a7d5d7c22ff2a9d55f4a8c8d151d34bfa557f38bfde75066656b4ffd1b6c28c630d596ad207754546a0b38f9c77c301c41d8b789122566fc3bcc6e5d4e5cb006272ac5cdce3029517a947bc9834dbec7ca375e17b3d766ee3798895cbbed33c37231d3d0f232de2f932b299fab48212a33ff00752ee74b0d45c1678f4e8fb9f53e238e15add3569748c6bc232f92355d3937ec45d70fef3f035232f63b3f99d8fcdc5e097dea56c0b7af08c53875027ba4ed7f38fd1ce28f67f73d72cc29ccb87f2ce1fe38cb148f792313c399f48c3e231087605127146509848fb3296b27678ea2717f2cf8cb81f1dfd99c63c29c45c258f29ee61389726c464b36733d6519a94a6627c65a940b88f0f8cfb9df6878347bce23a3a94e2ede9383e57e169abc5dfc99856d0ea687e160d7c98f9ce185c8524b69277a08a0ca70ea0c6fd098de73b2d9b29f5a140b58820fcfd6f1a34dc2a81219d94c0b97bc7c36a78554a3868e3952b659a12a59b331ddcb456a4316b9e91a8ce92b41aef4a82c631c25c503316d42c4c795534ee3d0cdc1ad8c424d01dad12c416240eb19265aaa1dc5c0b88a548237daaf411cee0d19bc15c4875258f4ab54b3c2b167f422a084b924fdd03a7841001772cdf7c0885e002c69e35102092ede01a0448244860091400fcea2031a8e95f188c005bd3c489122407ee6b0eb037bfce0d0ed617104b325aed588be40b120b167dbce244dd00448910d7f94010fd624489b5fe5004894dfe5120ddec28fd20080916803c6912242c021c751e22044fb841b10e29e3bc005ef462435216a3c20d41a7eb787d24d4825e8ef4782c8004d01bf80de2c097f89bcfa78432430617e8d19289454415077661d7c237a749c9e0b4637dca5282fdd62f6003c5a992686c5fe42d68d424e1144a528415296a084a52351528d0002ee4d80a98eddf2d3b1df1df1665638bf8eb30cb3945cbf9004ec5f1471a11859f3259ab61f06a29529640eefbc523c02ad1eff000aecff0013e315bdefc368ba92ddd9622bc652768c579c9a475d1d3d5aef928c6ffc757b23a772b0ea52d284a14a2a3a52121d4a2ec00f17da3b09cbbecc7cd8e61ca466185c8a5f0df0e848993b8a78ca71c8325908672a4eb066cc0cf5420a69550bc766cf337b37722e42f2ee48f00279a3c69247bb9bccfe644b2bca652c50ccc1e0804ad61ea9d0242281c2ee7ad1cc4e72f30b9958b9988e30e27c6e63275154aca70cd96641841b264e0e5b4b481b3851f131f5b4fb3dc0384be6e2fa9efeaafe8e83b413f09569277f3eee2d784cec5a7d2d07f7e9f3bf08e17cb27bfc8be539c6472dbb2672ad257c7bc7f9ef38f8a25063c35cbbc3270f914b983eccec69589612f47139669540b42afb5261b8451fbb726394bc0dcb1952cff959bcec2a788f8a260ab154f52529077fb578e9aab1ba5570946c94d87dd15ccc4289254ad4487487627ce369f69a5a25c9c0e8d3d34575a714e7f2d59f354bfb2515e44bd534b9684543f3567fbceefea399f8bf9e1cd5e39f7a8e29e61713663859e0eac04bcc95976585c7c3fbb49d12dbcc1f18e2254c405296024a8bba880a52be66a4c696a9d4d44396a2450463ccc487d352929a8f18f9bd5f13d56b2a77baba929cdf5936dfceee72ce6e6ef51ddf99aafef4426a4d2801af58ad589a6904513424589a7af9469866d417506a84867203d214ceaeafbacf4fc63865a971c19b9db08cc52a815a9c935269bef14198a4ea734241b57d758c63386a5bd03daede00454b59aecf504dc7cfd5e309ea22473bb194678513d051efd2184e018b8d40d5c3bfcfa460a141cba803b160de5e10750720fd93721c1aef19f7ef7b91cecd413368ce4377896fa44f78eec420b5de87d7e51a79981db510e68f07510e090ed5adadf7c47be24fa8e7667158207f13b11b7f48ad530a4a8b327a3d0c63898581f883b39bf84452812a248b3843b11f38875a5e2399b66509d4d409048620a5bd3c2199a83aabb7af08c70a0e4934219c57d3422a61249d5dd1dd00962febf1877f2d98e67b9966654161a7ed38b7840335556701fbb473e518817f6897482c403de4c2051a38577956f2f5788efdadc733338cca065e92012433d6291314485137ada91505b9246ad29157ded684d65ec4b8b000c3bf7e24733ea672668091d05281a9104f075004b2c5c8623c84608995203e901c8ddcc10ba90180624b9a9f5f944f7f2d89e77b19c958767d434fe05e27bd1a87da003060db4626bb2812136a5def0bef0a54e0866a7f1443aefc486db59351137f894e45051c758accfb1d435583fcfee8c0d6e40d45945fc040d6092487d92d4b742d12abc9f51ccfa19e662824b2aa52c41bd83c2098a0451833806e0c62958d4348fb2e0a8d5262198430a837bb3d6c3d6d10abb1ccccd4cc56a0094822ba9a9bfa7f1863316496a9d9d9eb18614ee0a893b1dbe700cc0c5ca80029d486b8f548875e4dee2efc4caf7b303106ca6767f1fc217de288bb96bb8abbf8c638524a88a82daa956aef09a9d40817b5bf088ef5b7b8bb3275935058bb92181b5a015162492482edb88a0a8b91504072915f4d0bad9dcba89a1347f0877aec419217a480eee289e948816c8ee5ee1c311d2b18da813ab53288a2b6dead0814749afc2962d63eab11df497506719ac0129a33dddfad7d5a015ea02ac1ba8af87f28c2f78a720971b57e16f1820b049b3d94283e90ef5bdd8327512cfdd1b1060ea52c54dbe202fe0f18e16960c033bb1dfc60fbc0358aea70e6c93d21debdfa82f131940924148a0f8bd5a2f0ba54d143e205d9c7e71a76b5392483b6a768b3de0d206a76249003b50fa682acd1376652a61a31218fcc9f1842a51b9075173e37f4d142a6324f5d5721c8852b70000a4849ac1d56d906519b41a8b876f30dd21bde172cc5c967da3135385ef753d8260a96da486009a3de2aaa3dd82e24b30b936b7af1840ad940120b84ee6debe50a576648d4ed434f45e17597517140eb09f86de50751b05e0f786a20135d54bb8f4f0e26383a4b3101da84d7d7ce31010e4312025dcef57860a7203ea616f1ac3bc7b8b990547bca4d14d615110a94c1c8adc1bddc4637bc2ecee19c0b01e5081654a4973e2de26f0ef1f88dd192998144914367219fab8fa7dd1689cddd67229e0c630c1512c40720f795dd49832c91b8720ea73b5bd79c4aa924f02e6699aa0c0306e8ccdebac2aa702c5cb937df78c5f79a9c92da4500a8bf4842b48b150e841f5f582ad2be437e264aa629a81f7a758533549670d5a55c88c50bf849155067788a24310a7da82a223bd937962e65fbc06aee6f6a8f9c3058a24ba9ec0ba479c6324129211500ea7258a7686048ab1706ccc4f9188e76c5d190161249a6a03e1ebe50bad477048b2888a945cba4583927e2ad1dba562bd497370ca0e5affce27bc95ac860ca330d0bd8f7828071167bc0d429b7749b9b5bf58c2ddc92ce4350bf482263b9352cc2b6f1f2ac4779206515916555a8e3d7d6182ddddc16f9dbf1f08c3131d6f51dd622e21b5d17a496db5fc558b2ab2d983275b5055839059bfa45616973b877348c7528a9c9a30ad6debf28816f4512e2a1ac227bc05ca25f5a5824806b7722e61d274b241dc93427ef8c6d40241a86adc3507586528dc13a59db4b6e2ffac154b6103292b2ce403b134005e019aca34a352d5a4627bc2c4294e92c748a01530a266a2412038db6877ac19a56c477aa4d99c0b37ca219ab64a28dfc4599378c570483a980a126a456958248a25812294b4477b3b609b9785293a7bcfd0b54464a665162c92589b967f54f18d3f5824847c20d9e8d07de94d48d557ef16043c5955688b999ef02bba544953005986f7fc207bc2c4820149b58d5a30b593524bfd866f18226122a00292c41b97eb0555b7964dccc0b259aa972e68c6bb03bc1d6b3a807a97ab33346282ee41a02da49bd68c2194748ba881bb69556e7d748b2aaf71776b195ad4585188a8b0f2300cc6517229bdc1029188161cb2544252dd0806184c001528b24dc52bd3cf6fa459557b84da32b5b11deb8d8f5a560aa6924b3020696341d23114b01c12c0070ade07bc0c097a064960354477eed809b45ca5a9eac0fda24bbf988b5330925ed4a5dfd37e118a95254c925957d49a90f002c02d50a0a72a36f943be95c5da330aeb709005ba5008424d9c69157fb4631d5319c925c741f11ebe504ac04bea577aa2b68b77ced86399992a5a529a1eedc58bfae90a493424390ede5b3c62fbcee8fb2459ef10ad9882929001241a5bd5223bdbec2ede4c8135405b4926a6ff31f745fef400c05cb914a07358c22b9654748d2925c39d444382964b904ea7241ab78c4f796d895268ca0bd4e28ad42a0795a2f0a425454e4274fc37e94fe663075e97092f4d2a4b31f978430580a2a2a50243a749a00fbc6b1ad6ea4a9e2cccd1306a2c4949a855ab5da14a92b20a8053163ad0080df8fcbac6305b31d5a42cb062dd6095508a51542f4148b73b96e4a95ce4ee0ee65f1f702cd97378378df8a7861699826fbbc9b3b9f83c32c82fdf9217eed429652483d23b91c23ed01e6de032f190f3132be0de6ef0d4c48462329e32c9a5a26cea104fbd969092b67aae598fcef130853b84900114717e919489c48d45629bbd09fd63ecbb3bdbaed3f66677e0baeab497c5537c8fdb4dde0d7b62d1d743595f4ef9a8cdafe3c0fd37c0f117614e7bcf382e25e1ee26eccfc518c3a2566b92cd19cf01aa629802ad214996e4d42e44b4817989bc695cc6f672f32b28c90f18728788b83f9fdc1f3107132f15c038f969e289324390b5e5a662e5cea377707889b33ff006508fce8462ca4ba55a58060778e42e01e69730b96d9bc9ce38178cb3fe15c74b589866e4f982f0d226b1b4d925e54c1b14ad2a8fbda1dbdecd71f8f73db5e13095478f7c696da7aabce54d2742a3ff820dfc6be4eb7abd3ea31aaa79f8d1b45fcdeabf997b4d979ff000b6699263b1595e6f96e332dcc30934cbc460730c1ccc16370ea0ee172a6252b491fea02369cdc009542935a80d4f38fd68e19ed9bcb1e6f65d2784bb64728725e38973650c2e179b1c0f834e47c6f93bd04ec46192a499ad4ef6166c9551ca2655071f8e3d9ef87e3ac871dcc4ec8bcc8c939e9c172e4fef93b854e225603993c3a921fdd4e9274267e9b77e5e1e6bd34acd4ceb3dcab4fc734b2e25ee7fac8ebe09394a8dbbbd5d35f9541b7de25f1a8caa2f1b133e15dff00a7a09f78b76b69af6c737f6c5c8fc8e9b21414435fc1be7188a45188755d2f78e4be22e12cdb87333c7e4b9e6598eca738cae71c2e6395e69835e0331cbe60ae89b21602d058bb280a178d9b3f060127497673b347e29afe0d5f4b3953ab16a517669ab34fc1f833c79d2945da48d00a412e52c6d4dfe508a42a843915f94672e4b28b75dc5479450b48b0157ef52f1e0d5a128bb58e7707d0c5b7c42ad4e87ce055ed5e8d16a8598023a18ac82ee4002d6a0a47335676280dcbd5e07eb43120d0f40c3eb10080b3b123c8c088dd2b05807720f956230095a529b78c4726bd3a5220670f6dda27502cf7890073120b54004178841058b4002b6ebb75890e40648a13b91bc480120b6e4381788f57146b44f17af480044f389120091227e71200906a0f422082db57f181f2f9ef00082c4d3a6dd219287dfce2d4a1f5503586f16516f62526f6204b3bb39152c58c5a84295a581a160768b654a2a21deb6dcfaac6a7270a5c0a92f40058fade3b68699cf36358d3b98b2f0c4a988771b08e7be4a7678e6573cb375e5fc17924c9b96e0a7265673c4b8f0ac3641926ea13a7b32a604ba84943ac80e40158ece7253b21e4597f050e7a769bcf4f2f395d2509c4e47c385664f1971b96d52d3270ff00ef25cb9ccd2d09ff003a68254d2e5ff98743e70f6a6ccf8ab231cb6e576492b94fc9dc120e1309c2b9214e1732ce653d4e633e5b0ff30f79725048528bcc5cc358fd4387f6334dc2b4d4f8af6ba4e9c6694a9d08e2b555d252be28d37d2524e525ea45df997b30d0434d4d57e22ed7578c17ad25d1bf8b17e2f2fa27b9bdc669d9efb2c899238330f80e797393081587c471663c257c17c33382485a707a4a925482e09904ad41c19c01298ea8f3279c7c7bcd5cdce6fc75c498cce6621446072e0afddb22ca104d25e0f0686952c0a5402a372a24c716e2b147ba1204b40469294b2401b00d61e51a42a797a1a6c079fa119716ed356afa75c3b4308d0d2476a54f11bf8c9fad525f9536df858e7adaa94e2a94572c3e2adbe5f17e6cd4a762dcba5454e6bde20787f58c2993ca8abbd4074904b6a6a52315730339600da94f38c62a05942a0508258f4a47c6d4d437d4e472c1795ba95a45f6bc29981ddfa0049709bb562852c32dc0054cc9663d3d79c50a23536a091734a8f5d239a759dca733324cc5177a90598163fd5a292a00a9d24ea35627ba3c22a0ba8766b1ff0048852a480430aac90f7358e59546f621bf11c4cad09a552e76ade02963482a35516001d47e662824a8172a27a1144f8c2060d5341fa5628e6d82f5125d254e125c97ef11e30a56482e4b336963400c06214924a4d695d9ee621a000862953b04dc1703fa455b22f926a015a887480cc49f93889a8904390ea703ac005ca9c002a452002ee054374b5602f644d4492a16b0a97f082e43b3937ad41b7af9406490a2ee407ad7eff9c4551be10003401c9788be484d5c62a253a828bbb3071160552a5bbaee0924c52c97497d5b302c7eb0c7433e9a82f40c47afce26e4f3752d2439290c0972972588f0e9152d65cb12e5980f2b42135512c09171d20b80e43b753b7f2e90b8bbea8218937721c9b698802b4824d017353def2f0857a10d5269a68ef0d52c504020541666688be2e579b04f78c424b10478b8e8f009720b967ab3bef085b5b104135a80619c82c003e54685f1926eee884d8bd1a808205af0e925f4aa8056c493ebf284a1041370f4a1f5d6187788014e456b7367f5e1124b76dc6734a865172f7847208724923c5c0682a254aae9274b0760ed128026806a1de290feb688b91cc96e3254a36614eaf0cce91a6b4a3077f558ac14904b90c6a1817ac3021c243258d77eb789bf50da592b491a924120355dcbf56862412ce4f799dcd2028d490ce694145521096507142a7716ac096fc0675d4926bd687fac3a0ab497a81f0920b1eb14027510ce0ef4037de1dc6901fc58b1d3e515e6ea45ee3959a07a8a0a1ef03d61c1041058a8d433bc52c097603721be1ad6904d0b8b0a93f7faf382771cc5aec1ea03b12e4fd2149f8af5341d367fe900ab53871b2804d226a4740aeeb2ba9f4f0ba239bad88a00a92ee52401a2df482450802a5c9487a78c01405d9dbeaf685aa8b92e4d081756debce1cc9e1b25cb3640b24d0122d57d510ad4c755965dacdd3f282ccf5b588601cf843056a2c4e9094b2deaf0724b0c376cd85ef38636a0d947ca0820050720b32ab421e2161472c2db1f18524774742ee2e7d52907248295ed7206667ef7436f9fd61c28d5cdee1edfce14124b15024fcda0e8173a40486d2f425bd7d21ce88e60a94a20025a84b0761eba440e0300c5ea0b94abc47ada10064924805d806751a878258056a0285cb57e70e65b90e48b08fb2cc7ab910b66a93774fdaa1f5f7c36b4b074287769ab7f38008d40860e0ba8b33868737890e6fa1092a2904e84b1296763d7d78402ec007701b7755214aac4b5e9a69d6202a49291614ff4da1cf11ccd0c0abc5c934dcd7783de3a4eca3f3f5fa9857d9bbc0fc4433da00500284155ea2beaf10a6dec5b9db782e05c29854d09724c20a33b24b3d2e0b8a784063a89041a3b10e1248b4174daa4dc1a06f388526dd8aa9109536925aba957e9014680bb3963b1f9c3150d246ea1dd4b513e422a147a8a97f04c5b995ae4deed32d0400480cab5cd2b52d1582a014c1241bbdd3d1a2067dd9ea5fe180e136218b0208777fd2f15e7f11ccfa90bb96000152ea2e282d0c544b55d8d0bb1bc4649651ee81b9ad6f10b96609d24d6bf0f40f13cc826960705c0a84b82a74a8d1a08a924126835778901ff0028acd6cc34a6808651a6ef0a1800d73f16e7ca2399e122ae57d8b5475549245ef7f9c0d45c302410e024547cfac544b00ddd7b01f21012ad235752c4b562ce56dcb26ed92cd4ead4ec0dc1a8108e5d99c81d6fd1dbce2050a80030b922a6200029c8013ba8d844736724293586404864ec038624c3a5455a8a9c0d2fe261480a50296a060e181aef0c0a080486504b100317f5b44deeec2f943900a5bbd437a91e5034b69b9d4eee694bc283521c0b820d0b748808043a8f74915ab797eb0e64b72799edb842994417234d2846d7f2867209ef3a9af7062ba024f4a0b57e508a252e585e82ed5da279916e6bec377890c582ae5ac6b1122c0aae09a880fa88a3350d995e70c0a406a390fde069ea911cc8853f12e0a34a134661b748014541dd98b024b56b48ac004d0948d42ac28e7ee88ea24100116002807f187311cd70ba9eb62e1c3b44553bab6d2ce0dde1096706802bbc0310180a1fbe19c288d4006ef12c280d617ea89f6114a214c01a8600162ffac4d45ae003f688a8115105c5b402c34da210caa77b506097bdaf11cdf311cc640594b81b2772ef5bc3859297d4024ddfbc474f9c632490490a0f63a76860a49dc009b500d7489e6eac2978969511a88240352ef61d3d6f09a94028072f705f4f818236ef249d924b81e5d214d406a1352917f389e645f9910a94404f903a8ea7f1f5d208d5572e59eed5884025dc0a0722dd62697212a01d219ef7f1894fc08bb686d6c12c1b6b12e07482a3f69aa92e1efe5e51587259c3bb391416ac351dc00a00fc44fdf129b43995ec863a8966277aede10ba94497ad585d922192010c4b338249a2b780a2349290e77530a7a788253f11f53d59ca5212905c848ad614959a81523bc0776f0b425aa1ec54032a12a960580059a843f485c5d6c5e497662010ce012d6de184ca28a8775f4b331158a3506054edaaa05a9e10756a15162e903c69f9c4f33dc731929984049428359cb158617fe704127e114ad0b937f4f18a592a7000eebaac0a77a1862a26616985291f0a99881f96f1653b209998fa4ea20d0310dadbe70e14011a4ea25214c4b11e7e3184262b4001fb95734d5f3f9413306925be20cee091416fd62caa5b089f61a8a58a85eb5d4efa773f382901b4eefa812a66bd18c610594116bb8614556182ddcb8adf507d26b1ac2addfa44a7635042b5a00b94558d3ea7e7199227141600ddea2a2b711a5255500d4949ef353e7e71922651214a4d77ba535fc7f48e9a75ad9468a6b635e9789615555f5383f083e8c6fce05e6271a72eb88303c57c05c559f707f126066a66e133ae1fcc6665b8c4b10742ca4b4c41de5cc0a490e1a38a04c4ea0c6c0b9a00abd046a32b14a01002833176dba88f7f86f15d4e8ebc2be9aa38ce2d38c936a49aea9a774d791ad3aae32528bcafe307ec1e4fdabb90bdaab21cbf813b6b70760b22e2ec249185c8bb4672fb2e46579f6584d02f32c3a10a1ee9eb32584af0ca7244996aefc7527b49762be3ce496065f1d6458ec1734792f9b2138cc839adc1c9fdf3225e1e6ab4c9563932d4b1862494a4aca8cad674eb0aeec75124e30a4a552cb3d98b2beb1dbeeccfdaef997d9e31d372ec9a760f89f9799da952b8a3963c4e938de13cee5cd4e89fa2597fdde62d04a4cc9634a81698858711fb569fb65d9fedcd3870ef743a4d6a2dcb1d7528aefa384977f0568ea20bacaf1aa9654a5b1ebc355a7d73e4e22bd27b544bd25f9cb69af1da5e6f63a3d88c02826a34941ef06afce3489f20a5c690c06e19e3f7078e7b21725bb58f0166dce7ec4f3e564dc6b9361bf7ce3feccb9c6225e1f3ccaa610573159315298a15532407c3cdf812b9531a59fc74e20e1dcc327c76372ccd32fc5e5b9965f885e0f1b80cc30cbc1e3705365929992a74a500a42d24314a8020fd63f3ded97b9df12eccce15ab72d5d2d5bba55a9be6a7563e317d1f8c256947aa3875bc3aae91c65269c6598c96d2f63f15d53b35d51c74a974d403b077eb18c521debe552de71af4dc128021a8294168d3572c26e3e4c1847e53a9d2ba5269a3ca9c2c69cc5a8087f1886c28de3d632169054cce7c2c229219d2e0576b3479b28f2bb188837a123c290007f4f120bb1a7e115006b9e9118983772d4dda8d04b00cee5ea1ad117e801e366b3442d7ab9bbc0894dfee890463d2f6f18905cd03dad1200112092e5fac001ed00483b5edb44636fbba40800d9bd3442d71bedb8896b8bd44403ad1c50c479823dab6fba19297a9148890750018134eb1909492c0023aee3e71a4237252b80243176f002e632a4ca24856c0b36e6b0d2e5294c03955ea2372653926619ae330796e5d83c463b1f986265e130382c1c85627178c9b354112e54a96975294b51094a40724c7a9a3d154ad2518a6dfcff258da101329cab159962b0b82c0e1a7e371b8a9e8c360f0b8692ac462711326282512e5a120a94a512004804931fa31c35c97e0aecb5c3596733b9fb81919ff003433392330e5f726ccc4cc4e055f14ac666c2a0a925890aff2e480cd3661094720707f0e7067607e12c2f1c71fe5596718f69fe2bca4cee0be07c44f4e232de5ae1e6a5bf7ac72925c4e57db5a0ea649952d41d7323f3f38ef981c53cc3e22cd38bb8cf39c57107116733d53f1d98e29406e4a65ca963bb2e54b074a252192903ad4fecba4e11a0ec369a1a8e2705538bb4a51a5249c34d7b5a5556d2ad6cc69bc53de6b9ad15eec29d2e1d153ac93afba8bda1e0e4bacbc22f0b77e06bbcd8e72f1d73838815c43c719bcdc7cd90152f29caa4a952724c8251b49c1e1fe140b02b235ad839b01c413f13ab5104ea550156de30b889a428927bc058d98f8c692b9840aba9850bd9cc7c2f14e2baad7ea6a6ab5951cea4db72949b6dbf16d9e6d7ab52b4e55272bc9eede58d3a71003d48157348c452c1059252770ff009c56b593f15d4491bb6eed159510f5d41be26627c3fac7cf55ac9b399b7b0c660512a2a34a02f76da14cca14bffa8a851cf87ade285ea24ab63b33015865104f75fbc6c2e6389d4bdc843a96e438b0dcb6ae948a482594c9005bbceaf080e363a95b28c004a59eaf552487ad7f97dd15726d0b903d59dee6971e9e22940d10cc4dc873e0200500e6a4df50a014860c012a09d46a08704c548bf8959275312086aeab13580c5c8d42b56e94824107503462406727e710ba8ea2c93a41200a7c8c55cba22ade3012199458d5887d5f5866a28b9760452bbd2029405425812c1436ad615c129ba5203b92e6d15e7455c9bc0e6a2accce14f416f46148f8838242afd43c42a6d3d082d47e95f3b881dd60f572e481668af3b2b7640a6a020937076a7e30c14ab0725988368524920a45401bc4240d490a512d5d5bda1ccc36dee434d34b2aa6c4f94328fc4a04b02c06cdb42354382eeee2226b4a3b3060c9f9c4f362cc5fc03460c0f5704d6214d12c45681ecfb3c0bdbecf5a30e9107c557bd3ec9b44397813cd9ba1ca183b8200ef14961e2c613bb62ecec08a12d0ee08018bea66dc5a108009eeef563410e676b322eed66004ef573424c382e5bad355bebd040ee91a41749ef82d5276804024519c304eab79fdef052b2b13ccfa0da9241d403b5dddff009c23870680568ee4988496218d9cee47cfa442a415174bf7685da254ac45dad984ab5548096af586d92ff0b6d5262bb8aa7edb1068fe305a80170c3ad443bc4ecd06d8414b29cb1d85cf9c1d4410a1e00eab181a4ee428b6a55284b8dfef80ba8008d23ec8f2dc0887364f336c670da5fc4826d15126f420a99c9bc3120b80ec2e455ffac206767d2c5dc9717fba2ae564404e93f11aecc7e185095299807373a9b5411521d98d0822dd2198f800c74d5c24b0b44297417610a0e7e136620da02944240a11700170f0a4b107ba13d2e497885c307a5d9bd3c4f35b02f9b8c08672ce3eef386a3d1d941ad5bc200ad20b3b9d4592c4f9988a2486666a82f6ac473222ec776a395016d5b41043106c6ecee22a3de0091b57abc005e81c3bd45cf485ee0b4280048340583549f5f9410a2e4bd5ebb168aee7492f6243337478029fea0526aec40fd62149f50ae5c950170e540b6edd5e11c0621fa569f2804870454285adf3108c192092003dd3d7a8fe713cd7ca176b61b5a5259cd0b5cbc359ca4beee4d8797ab454400475fab562c150dde556a0299bf9c4f33b12ddd589de0ab822e0bd1ba7f589a92900024d6a0dcc10d5005b6de10a9d443390a72d688bbdc82c3316905cba4a7bc41a87a3341052e2a4129a39766f5f7c56cce560b02e06e4b4292c6ec424a5afeb68af33058e6a4d4eaa076a4126858bee5c5e9d2109d203062ce4a8137f0fce2153dbe25862f74d22799decc0c56ea7b126a6e62254e4311a59897a8bc2853151670cda48a9ac414a85339a8218f8b988e67d00fef360554b3d0130c58b39abb9277aec7a457a92181a387240f5e8c121882c48360ff0d6279bc0044cf8945c103487a6aeb0a4820abe071d6b13556a4023a8748bfdd01d258508af83794399d80410010fdd2c09dfc60a484b12756f4ac230d4901c936e8debf081a9869167ef3d88e910e4d645df42c2a53064bec97bbec7f28892abea276501b0f084a90585ea0f4fe9114ccce5ecc297feb1376f7058eea0e5833026844151ba6edb9a3f4844a8354bb543fc23d7e51094b30af78281258b97bc4dfaa04a5ea1c3383a8ff488a6218bdc006f4f1852aa821cb3829356f1e90010431702ee2c37b447334b23a8ea7218338a3970478520380c7ea0971b560905d6da5a945548da9f581a545e8e3afd20a4f601513ba817352ed47867481a98b13dd00b02d150569350e92373f7c10e598bd030a9480d5f08733ea0b029d5a925942cc6fb42b8255d0d1cd1ebbc02428867606aa21c9820860ec4bbb9487f54113cd77b9377d007ba145c3696bbb53ac3020806a772e58984a36cc9a14bd0d2096aa839a30a1bd2b11cced722e303de6d9c1ad15f77ce097482535abf9520254a50f84310fa9e85b688580f894da1ea5e239a56242540005542eec6f11dc022bd1c697606b089d2c5d2fbb0debbfeb06a08653123ba0d74ed4f5b44a93b90338ef5ff00d5bfdf049142ea3a855e9d29684d4e28403723a8660c61d4c4815a9b58f9c4f37417149a1040eeff0009244297585023c88a1368651704a8585482413b7af942bd00a901eaf734688527d405d2fa4300da4befe106e3497621886a208f181525440014d41702b789a99839a0ef35ecdf58b73326ecb1d8b921c5189fbed10ba4851357a3569012a04b3925ac05edbc0a00f53bd4b84de25ced82549a1c005c8209ba81a522053104dc3d01a01e23d5e015f748771a74b80edd22b2a7600d5be2bc39dec45cb8920164852545d8515e0feb68877214038ee8ebb456086352a2080483a4982ec43a4149a0ea6d0e677f31d470080ca6a39bd0d3a7485248a12c145f492083fd206ab800a9ac0b820b3fa10a4b8ef1722b52debf9c5b9fa04f1e43a54484d4800d090cf5a3405598a88d41e951e8c2125ddf764d6be50c1b4a9d550cef41668732b84c95245091bb0bc44bb962eca6009b75316062e2d4eea81fcbeb08565ca4b3fc340c0b1de279fe709e30339d3521ea6a5e03f78d1c90c0aa8d6bc21d4ec2c03020391e2f0e9b0ef779ca6a0866f089e6c64b278181a97154b53adf7860a72030662c40f0a9fca2a0ca23a580261ce9f898e9f3aaa9f8c593b964fa8fa8ea1a0dae4d0793c3a49706f52a0d7f9fdf153bb00e2a487abd6a0c304d28482ced6a743125aead93252a70f425dc9d2fd37e90faebd0120b2accf7f9c6292c05afb123c9eb0c546805817a835aff005fa469193d89dccdf78900280aa830637f078c84cc5325206f520bfd3f58d31134a534d2412c90afb34bff0038c89734288649000ef5589b474d3aa5a326b06b12b105d2e5eac0d9cc6ab87c42905dea6ba8d41e8236ccb98a4515a412a2055dfe51972b10b3f112762006207403d347a7a6d5ca12534f269192e8ce6de5df3438c396fc5395f18f04711665c35c4d934d133019b65788327112c382652c7c3325a99972960a142e23f59f0985e4e7b4db870603192b87f93ddb6f2ac014e0b3140181e08e77a24cbee098a1544f500c410a9b25441499b2894a3f0fb0d3ceb4a2c05428977f07e91bfb8778931d93e3707986598ec5e5d9965d8946370198e0314bc163b013a5ab5cb9d2672485226208052a4970447ebdd8dedc4b434e5c238bc16a38755fc25193766f6e783f8151749af64aeb07a7a3d6ba37a7563cf465eb45f5f34fe0c9746be5c604e6772c38cb959c5f9ef0271f70de65c2bc57c3b8c560f37c9735c39918ac3a813a540d972d63bc89a8250b490a4920c7126230c4034ffd1ef18fdece1ae6372fbda67c0bc3dc98e77e679370676bfe12cb4e5bca5e76cec3a30597735e54b43cbc9f3e9686067cd00394328ac7bc941cae5abf1ef9b5ca5e37e4f71be7fcbce60e418be1be2ce1bc59c266596e2c6a0a7732e749983bb364cd4b2e5cd4775692fd40e3edbf622868b4b0e37c0e7df70daadf24ed984b774aaa5ead48fcd25e9471b46bf454e9c63a9d34b9a8cb67d53eb1978497ccd65636ebecd97eedb4b529e07e718a407a0b1f28dc18cc2a924902e6b43f58d1e6a0a4b004d5ba08fc4b55a59536d3478b383dfa982a0df648fc2051856bb88c921d8b540703a450a4b55b4f86deaf1e64a2d33115d9883589773bbc082366bbc5404355c38fbe17a0f1866d550cfb81731039620541a9d8c4750066a6fe712000f41122406e097de04489001249b97a44b9a9b9ac4a3d3ef88cd7eb51bc300801bec3788de23c7668146f1fba2f420160ee36076f97ce2629c9d81121c02e0d1fa011972501fa86b340952c9606cf4611ace0b0654410f5b35cbda3d3d269a55249451b4226665d819b885cb4225aa6cc98a0844b44b2b5ac96012901c9268c05cda3f5f781796bc31d84b95f94f3b79b782c066dda338ef2c98be5272cb18d326704c89b2c056639827eccf0858330ff00d089824a4fbd333471ff00654e50f0b726397b88ed97cf3c12676479262861b927c0b8a963f79e3bce06a12f3054b55e4495a34c84b10b5a664d5108949d7d3ae70f37b8d39d5c7f9f73178ef32999867d9dced32e5159382c9f0c827dc6070883f0499409603e35294a2e5463f77e07a1d2f60b83d1ed071085f8ad75cda68495d51a7d35338bf8527f808bf0ef5a6b90f7a94170da10d4cd2efa4af04fe0af8efcdfc05ff1781b478e78cb88f8ef89f39e30e2ecdf139ef12f1062ce3b33cc712595354688972d03bb2e54b484a25ca4b25094800068d8b32728121abb8d87cfac5d3a60041a2944d7668d227af512b05bbccc691f99f10e2152bd69d6a926e526db6dddb6dddb6de5b7bb6fa9e655a8e6f99bcf5f17fbc136712eb57c37afe11a799ab21d880ee92d56781397de254487a30a90628d41419c962e48048158f9ead56eef73072772e2aa33125f4bdcf80f5d62a2ad3a8120b9653fc27f9c2821c00a20359fbd6de15d4c6a29b2be27fe71c7295ca81db6203ea162fbdfe503517d542a15af74c36b2a00148513b35bac561a9a7480cce682d146ec55b60d60104b541aa7781aca89d5dd045da02882143edb8603bcdf380e149a82c4d6c3ce91594ac51cb1826a2d671601aaaf1fc218a890ce353ea14b0a3c2312e1c7c3ddd87f480c6acab0635778a395c8bdd5877b00475f27f1f94453e9b6a2051cda91538d35154974d6cfb188ec0e9a3fc55bfca33737f21171c950727fcb068120d4d7685d4cc1806bbefd601049b3bd89a0bde056a145ab5ebbc1b6d60818a8b96a0660c5f51f1f5b43235122c350a1eb153d3a805d8d4b440b1ef1c13436bfdd10dbea0b980d20a93de2f4ad86e2207156296a56149eea8b80496a5e20ae94eab0b93457f485dadc0c0b24f75aac14ec4f589a892cc7502e6b402cd0891428208ba807d46058915723f85cc37688db61ca81b3d4d74964c14820574a9cb35dabd62b0a500e43aac081f56867482901c96b2ad5bd6276649605024a404824fc5676bc228b3b8041156b9f18014183020bb12da830b520dea5890282c4fcbac2f7c01810ca02a5a849a8dc5778509722a95bd0835fe90baac406725de87c5a2005da81be2a17574884fa21ed0b14a4b105acf10a4977291d1fe2da20512afe2af5bf9429a90544514ee69f48648f610153801f53b00d487d45d418060fa80e9bb42877500c4f525be9fce001a9921eb55036782ca5624b5c925d4181b0ab5610922ba80205cb0d4ce3e500104e9a78d05fd7e312a42554a901b7bc2fd7a001663d6ed60697fc60b071f53466303ed1ef3b5d4dd290a490e456bb3d6bb4437b788087045012dd1e080e0b96d925540f08ee97ab74346f083b020971e1410be524c82def50d1ddc8018a9b78048d04dc137bf8d0c2514d560fa8ec442951daa1d999c430d5ae4f52d00149092755d8fc4614903e201cd2956ac2dc9624b91402be3f97d6090f7a1dfc47afc6174b6d86c1d8906f420ed10a98b16276616f130801208fb2d450b81b082f5f889764801aa3c622f6c201a9249500ee5c8b080002c40bd58c16a00f57abd4c2a492aa30161aa8ff002867af5058e4d541da8035a1803dd72c01ee801c8f3fa7dd08e348623a10cc3c2202aa3a88dc1151129e7601a1d41e8da42bac41a874766adbd78c034620b87aa6e478410c5c90588a02abc136d006a00d4339a8150619490e1851e84d5fc2168961baa843c396d4ea0da7e100d609f400ef549141dd637b4021aa07745355be5eba40a108206aad8866fe51283a837ff4dfd7d621b6900294e5fe16623d7e511209666bb06b871d62b26e0aaa6b4a00dfd60214030274dfbc0d2186f20b942e28aab926d01c9aec294a81012addfe60000c40541c0209d85c44dd49ec06a870d521835cc162e13553df722b084120125dcd4d87ca188200b9af56d508b00eeb1b8096615292ee3d79407ae96ee8b11f68b436a2cdaa82e3f5f180db6e2ad7a42f900d4295abd8dae6b0c0d038341b07b423b92d52373615ac42429803bf7cb13d62b2f2d80e0ea6b0d27bac6ef5f9c2926a4a52e0307a135823ba033588077ac0b0ddadfc4f16bec064ea17525cfc40d879c0b0704100b10cf7de0381dd0ad20d48347300924b3906d5143e11577ea06762d42e7a7d2212e76eed5ba17de09212490a0c6a69128c40b1f1623e704edb82134268e058d09fe5102b500e05aac5e1194efaa8684339a758505c3924849615611676be01610ee0b31356bc40cca770c694bedebe7109214198a4d85fe503bc4a8905d9d40188524acc10a80008526b40902a45218b9292c7a59bef8aa8a21c2890694d23ebeaf16072a23ba52f4ab1112ef7c6cc1030040d3dd0e2ceaf0110a8950d4748d2c090e36a443570289b0fa42a7577ace0bb28ede1109b030552e43d9ddc3410cc01b10c146a008142684827baccef7ac2d5240a962c28e0433d40fdd50d40929528b240a9885546ef0abd77f0680e49605eacc29bc29604b82433009ab37e50dd5902c0486aa80248206d4bb4397ea031fb55773f87eb1439a970f62cdb432547bbb3fdfe9a1cd8c01c866412da45081dc2e1da2b70cce599ece3c61ca9d9c07774ff0008a74805476a0353f77f388bd801d89451c8ab5fe7041b100000e96be9f38adc85b06ad4d3f3866bd3bad562cfe516e9640b756a1dd01249ae917f288e4000313b122e778a92a6762011602ad0c145955249b38ac4ef8036a7a24866b24388201704d99d9361fce2b1306a62425812e91f0ff47860410524901dc1eb15df703355ca800aad2bd2e603809670a3f103b8dfe5b42d49215460587ea600207fd670e6e0c4a6fa6c421df5fc2483b8fe2f07846734d892755a233289701c3023cff9403a9c1a82ed6f8a0aed5890a8b0236d8b51ed4fa441a88635d29a961b8fe67eb0ba8380ca539a3587ce0ec4548dd2cc0faa44abded7058f54d05124380c69012fde538234b80ce535b9850f4344976a6dd22c770482e0d483d6b129b6ae08280a9c93d49a7944d41a94a0736dc52087219c390c46c69bc42a20b2429dbbc45bc037e70bbbd901d8056a50002acdb91d2212cfa8a438b5c0a7dc61351201b55d8914bc02e1201d252eeeeff77e513cd67617c96248624d8aaa4fc40430524b90400cda8f769e1f48ace9268e6ecff12878882490010453bbdea01bb3f5fd22ea5e04dd8c0a4121c12fa5c1b5b78724966502416606d51e9e2b0681377ad038782090410da452e1878c6a9dd5d964fa8faa8962ef4d2287c5c45a0d7bcc593de49ab78c5212c40748d36f13ebf18625234b13a94fac3bb0a57cfc22c9b5b174ef93284c413dd2e1983d0d3c7eb1625649249704020b690fb36f1889592c6e50192149d200fd3ac5a14e19c00dad40548f2f38de152d8b965b9aac998c401a486751058f8bc6b32310c84b12450f74fe3d5a36acb531b94820d19cbf422351913b48a3b9f89c9d223d5d2ea5c1e0d612392328c74dc2cf9189c3e227e1713859f2f1585c56167af0b8bc24d94b1325cd953524291310a485216920a5401168fdb1e10c6707fb51395b86e54f1d66795f0ff6dfe59f0ccd99caee36c7ad197cbe76e5b8449993b2bc74ca09b8803be523be853ce402933531f84785c5196cce412054dcecf1c89c29c619df09e7d91f1470ce718dc8f89386f33939c6439c65d38e1f1d9562a42b54a9d2960b8524863fc40905c1223f5eec476be1c3255345afa7dee8eb251ad49ed28f4947e2d487ad09747e4d9e9e8b59ef6728548f35296271f15e2bc24b78be8fdacdb1c73c1b9f706f11e7bc27c5593e3b21e24e1ccce764f9e64f98c83231b96e270eb32e749989365248f9820870418e34c4485249748ef1b74f9c7eedf3a321e1bf68d723319da378032dc2e03b5c727b289586ed0dcbfcb6509337995944897a2471365d240ff326a128515148d442264b5874ca27f1271f81295a8314b16ef5a3c2edd7643ee3eaa357473ef3495973d1a8962707d1f84e2fd19c77525e1632e21a35a7a8a549f35392bc65e2bcd7492da4ba3f2362281429419fc83b45131205a9d4b3fca359c4c92925c0a1771578d26607702a1dcf8c7e45a9a0e12773c89c7aa317af9f4802841e916148b507478434b17171e11e71981efe3782f6036fa931366677b758868436df3800bb176ac4858911caba8244eb12244809dade2c5e08028497d985498501e1886218b387778203000f5f0dc45e8482407f006de10897615af86f199210a2a4f76bb0e823aa852739ab1a535d4ccc2c82a291d0b06a8fac77abb167665573ff00988711c4f3ce4bca2e019038a39a7c4d3a60c3499180c3a553d5809534f7533712994b057ff45253366312120f52b83f85f3ae2ccff24e19e1dcb7119ce7fc459ae1f23c9329c225f119962f15353264484742a5a92351a00e4d018fd66ed53c4d93765de45f0bf629e5ee638599c4b9a6130fc5dda1f8a32c504cdce7158912f112f2b130778495944a2507ff0007c3c8040d6a07f71f734ecf70c4f51daaed253e6e1ba3e57286ddfd695fb9d3afcf69caa3598d28c9f54cf738750a694b5baa8de943a7c693f563f2ef2f24759fb62768ac3f3db9828c3f0ac9fec4e5272ff0dfdd7e5770c6151fbae5f82c148489471dee453de623424826a99499697f89fa51899c5cf79c13522a0466637143bc03dcb901ab1a04e9fa439a3b9158f9fed576835bc7b8ad6e29af9deb546dbb612e8a315b28c55a314b092496c72ea3513af3956aaef26eff00fc792e9e0849b34051753b11dd26f58c25cd485020d5dc3d4884985b58206a4d5552a24c52490ca4849d43494077f558f85ad55b7638dc9e442b45c778a8f4a34504800104d7e109eeb41512ca604177001eefd21524ea202438d9ddba470b975451d8028a14abd1ede5f7c3009d4aa289d8921be51140972a04288a8f97f2850a2051d2e5801555aad19dca395d5d0e0926aa09aeb3b1236ac54a3a8820fc2f74b3f8f9c1d48482ad209602f41537eb0a495bd4f74330a7adeb194a4d946f3817480453ba3a509da18021ceef6557f080015126a013dd0f60e36880ea57c35b8ff57ca336c8c8c3a151d2d5d5b0f0f5bc4a017605566763e301f4862a2a2a152b15b4202fa4126da5855e2addd001dd21887bb549dabf3886e055d4599984310c451d4cc4a684bef03724ea56ce45d8442bec46c02013524245dac18f4806a4e90297d45d2d563048677705dd9209022280077eed41fba174dab1200aad487ba77fbbebf48503bee2ca352039bed16696a121c872c6158934ad7ad4d5a270bd5d80a1c598b9d468e6bb7e30c2a1921201b8353118150a69d2e080ee69fd20109d372920b077710b59d98181364e921f492ce479447215a81a0b1772aebfd20778b2486ef1ab33c40ecc52451f51ab0b5e21787500018951d41ee05fc1a18851504b0760e4d14ff94415054a0ccd50589f5e10c4a812fad2ec1eecf5bc4bc6e80a5c9e8c34da861880000a6d4fdd17fbfd5a158925d9c1b1bb412d46344d4b8b6f0880104104d492efb8a7582c4b2aae682a290aea50ef2400051c1fbe1c336bf895aabd7a4576780282da890014f4154c238d407759bba4d2d0d5a8f8a8ec0125bd3c02ca70402521d89a54c4dbe080bd1800492e08fca03501701cd349b42d68c036df5fe5f741d880086b44dd818f420537019ff3861a400594e1d838a456a511451342ed561118d4d2b60c7d7a311d40c582002412412ed43e103e10ccc05478f4803502e1c0d347069483501881f0d41b8734fca0ae084bdc82d5e85abbfe50a4052525c804b11bc4096eaccc7a8f28342c922846d73057b618d8701c1a8a5c6e2143d090e00f881ef78c40ad252401570d62220ab3d195e3535859bca011b30012431dcc4364b11e26c07aac0d2286a40b82e48f08252c52a66fb4c4bd3d6d13e8f401533824351830a4284d491577a9dbca2d511e3dea051852e5890c077520d0fa1b985927702b258d1c25567627ab440a0e14749e808a83682748a12f4fb4748803edf5b17a106f68ad9244109009b93760681e15ec050a052b4fac329364926a6c2f12b415200a30bff286c9923691f10ad29a880620497019269b0b4561ddc01f372ef0d7704949771b8a44abd804915363b00966804804124124356c7c008249a54aaaea1a59a0102a3bad71aa843c31d0014cc4369e80ddedf58059dda8069670479c420115b9f9b529f388a00d2a403f37b44dbc015ee41009d4e4b314c4762a50092fb11f58623bc3ecd2a5cb988417b39664a4793c516c02e0b3ab4e9aa4354fca15d5425989b00c478343072c14ee0b86a9542ea7361ff5aaff003890596058b86b35fa440a1dd2431d36554030b4014d43753835f9c1aaad41d45416a189cdf2000921c6904dc3521c909082003b9207784561fbddd0482da8daaff287048b10583289b44656c089d2580046aee936bc160e07c241a03b8f188096ef12a00d0d827ca21a8773dd0da74b000c5bc8045350a1a390cced08402011615ff541777205ae1c9102a1c80ec281f78af4b8051c3b52e542b052c4a8b6a50a00ee3e70c5ecc0855c8a335a204b1538512056aefd291394804167a03fc5fd217ba55d29402257bde2286fa4f47eb0095246c4b55a8fe304dabdc0685ed671e3480096b3905e8286031246c0070078c300c080436e5dd8d221616f9029212404a48d5d20bd193b54b9fcff00380482400546b42457e504ea770e7ccb089b3b5c10974b0605e9470a8604f79c31373d2ff8c231624a438b3d218692c40a9ee915b082b3002f534648766a4404b0d403788606a208a0243598b0d4f101a1218bd1aeef11740616770091667eb56857b87702a5c54b44ad0807512016275344506516a86775388957ea08481bb3ee05ba4401eea09d42848bff00389e0cc0d9deb56ac448ab5155052c7cec7f282b27800d228149008ee856c478c42963f133970e6b0c595704ec06c2004b10406a901c988c2c80ba4824066342d43ebf389704b8059c91682a0ce2a0b3a9dde102450b11d5cde25672c0c058e9150d52debf9c101ab40ca00d1f57ce141621c926f50748ade26a2fdd0ed43b071585d6c0620396d2e3f84394c296ab57ccfc2f1180777aa76f8887f5f483a415331d44545a08003a5f53392ee1363e50e15a8b33b8b80c5ec088421442f4ea4a1474f896870951096722c4ef139b002c006a5a952a2ef086808205dacff38b08d810aab92d407a7dd0a5c383524efbf4f94461ec01403bc410db3b9dda0b17043ba8301761788e69467a83b8821c9059c8b9b44acac8214904b021a9537f280135205083635b43acb2402efe3b78c04953d145c8ef13724dde25ab600026e08054f77a08620b3242536dab0a0aaa05cf4a97f5f582428a402f52cfb5e236c009d40f43ba46f4bc4d3a892fa474776f2ebbfd61144395021d98f7bca0824064a8906a5be5bed12ac95c12cc0816f88874ab6825fba936b109a396800048f0554125cb57f9c00e19a9a43baa9e7f8c47982c2c4a89704070454bbed01c94a42802e6ad5f3784720820815eb5bf5832892ec482eee7ed0ada263643da5d476d4012694620d20d14421048375903a55dbc22b480ea09dd249245be70da8b835672013b74062d19641612e4f741005c6ed6feb110a048b1eeb82a0ff5fba2b62a293de4aaac9fb30c972aa10c3e370cc459fe91ac5df05af82e2096d2416ad6c5bac33e9634b39a50c54c41753072c2a4b9b882e54509720dcb75bd2354f62f16cbf577828824004904d99a9f788bd0a512967b5deff28c54af48528ac10546ae1cfebe51621495381ac27533dc98e9a5369a68ba9246ab2679eeba825092fa1f7dcc6b72279d695025b604b3fe7f38db728f78a7a961567f18cf91358d5c849d21c7c31ec68b52e1353bec6f09753b7fd9939f9c5bd9d79a9c29cd6e0f9826e3720c57b8cd72798bd383e27cb67109c7659891632e7cbd4012fa5612adabd8dedf9c82e00c27f74fb5676780ac5767ced07ef33791974846b572d388892acd322c401fee87bd1356896a6d0b13101d1eedff0037b2ec6142824a9d452e2b503c7c23f4fbb07734f84f88a571af637e72e325a3941da334e5d93e3b1530253c07c5a5225e599ae116aa495cd989929243054c972f5382a8fdd3b2baea1da8e1cfb1baf6977b9a137fd1d7b7a2afd2157d49f44dc65f04f7387d4a7aa83e1b5b0a79849fc1a9d3fe19fab2f925d0fc91c7486d493427a168dbd3e5e924509029bc763f9e3c9ae31e46733f8d3953c77825613893837399996629699465e1b3195f1e1b1b877bc9c44a32e6a3a05e92c5240e05c661fdd9d2c002482d731f89f1fe15a8d0ea6a69b51070a906e324f7524ecd3f633c3af4a74aa38d45692766bc1add1b78a35005cb26e1eb14949b5016b0378cd989624849ab83f7c622869676f5d23e2aac796470c959d90956600ddcd2b0294fbc1884904d4fd6233da83a9a08c88201d5c3c488493425e24002080f40de4d5805ec76a416a3b8f287b0021d2dbb56dd61439f1d86f172534492d6a1b6f1682bb095f058804901459cb3b5e35fc1e1b5350b81b5488d264a0a99c6f61ebee8e63e54701e79ccce37e14e00e1a91efb3ee2ecef0f9165a4cb2b97217885842a74c03ec4a4eb98af09663e9f81f0dadaed553d3d08394e6d46314aedc9b4925e6db491d9429ca72508abc9d92f69fa2fd87f85326e4872cb995db878ff002b958cc1701ca9fc19c9bc9f1a961c53c4b8996644d99241a9448f7a242a60b6ac4805d25bf3c78d78c33ce38e25cfb8c789f319b9af12713e6d3f3ccef319c752b1589c4acae61036487094a451294a40b47e8c7b43f987c35c3b88e5df642e592912397bd9d787f0f96e76bc34c0a4673c433648562d738a68a9b244c519a4d4e2713883d23f2cf10b36456874d6f1fb77ba057d3f01a1a7ec170d9a951d15fbd9476a9ab9dbbf9dfaa85951837b461f94efec7129770a1c369bbc295eed6d29bf59f9dbd55e4bccc29f354a532880c7631a6ce502185439620313d3e662d9ca512482c49723a88c1510490564ee4bdbc23f11d4d66f278d278c8a4abba582a9a4f56eaf1528330a77e85e80086d552e4949480965313f7456a2ed563b576f5b479729e7050a82940849b8350123c3ef8040751008f102f056a6538000f035262b26ac4a9c508258bfeb18bb19c9fcc02ad21999801a9dc9261359a921da8db0f9c32d45448551a893d2094966075f8a4fc4231726f7332b6497602be21878c3020025c00da4288bd2df48852580704136018fce105dec4efb466db60b090026ade34716fe503510c1ae68de7fa7e30a0b82c7500aa94de21d49014e0a9d9b737da0f7b8097344867beab8a6f02b6041dc93453c072d52424d0173587ffac050d080dbc32f0064a6ca2439a124f9bc03a4325c02d526a00f38504f7980a8709dc5de002c6a4dbc9e91002ee5442ae1828d8c067413ba5890294b402f61553b01f8c1a5029d886a1a51e8621d985e01eed9ddece37a401700901ec771580aa8a97041d2000febce022ac1daf7dabfca165b2dc0e19c1f8544d5577313e21fc4a0e4960c61011d7c80dfd7587f85dc14d6a05a16607083521401218ea00a47f28523525dc35ab4d420901dc12011f384040ef120866ee83f8412f101524821c25839a97578c2b8662c412c428dfe710a9cadcd2c285c7aa40043b96702e5cfd209bbe40413de700107cc91ebf081b7c4c5ba31deff007417ab82456c77310a9c1661b925da96fbe17b6012a00b5aaf068056a4d0776b42cd081fc9ea7630c141922e520d5449de26d758d8080ea528d1c075126a7ca086bd07c9fa7af9402069245695ad200090d52ed50efeaf04f375b01d408b00474a7d6114c9074b82c3bc6f68b09adcb0147a167852011b166f38ae13b260049054d715ad45778809700975354a5a9761054d6040ebb3c10198d5d81bc4e6f66057513a98b5886636bc12c1ca88624b11e7049d23a126a5e83ee889343a83d28a660fb446502b454bd92c5b76f38725f72e0509a9b0bc1018382e557d348259812ee68c4d7e712d62e00e5c5680bbb3bc317772cedb06fac2d892598a981ddde20097502a04dcbdc41bba01721da9577a52c20904ba99de8480d101d8170eefbed78814805445c9a026d0dd7a4c0a12c0806de2e2083ba9cb0d2dd221003ea6d440663dd3fca21702953f50e6272bd140560482a0090a62f1680efa455d8536f08ad55bbbb586d09de6155162e003668a82da8dbbc28482eef48459d20dc1771e22005824b814341b9f180a249240a16aa8d5dad117ea076a1eebb00c2956e911356a8a548e908480aee920022a4d6d5805c17480d6721de2caf6b82ca948d269e2cd04072dbdf6255784045b4804ee6c21802348bb9a11502230d8189034822aec2b43e10a421c35cbbec0f87f48200b1d23fd44b889bb57c002cd12ac801d9c82e5eac0561406209fe1ee81b52056a2840ad4b3d60bea609b9bbd08f5f9c4378004aaac4b0bbddf668203b10c52e4b800ab7a442904d285ef726b12b5a973423730f682101c00e484b5dc00d0c68f52cd4340cd159586617a873710faaf75005b56dd221302b6aa953b8703ac0b12e2847fedd478720ec1b57dd0120024850524dc9bfca26ced600001002a8c6a057783661b5d25ed13ba92e4e97ade910a42aa0125becbb0f5d61e606b86535455c5a8222800c520006840b428704935d8eaa9f5fa433820172db38620dcc4a6b704a26ce494e9219bd7944606caf07760478f94021ca54934df575880a53a8541d2f5ddfd7df0c6c07a0a900b53ca14860f62fd1fe510d007704dda821351d4c1c6a62012e3c60dbf00581994cafb2ec43edb4210e904b30b5184170ea2417a52d15abfed02aeb6315e9603a599dea4da84de0902fb84ef47805c54b303a4b0a9ac330207c5a7ec834222cf0c03fde38773721d84104024a806142f5110960a552b4eed00850e5290082353a8bd2f4da18dc041487ad4d80b87b42e9aff000f5342ff002884a5b55486ab508e904281d4051a8e4f9445b208091470a62e4bf9c100a89729e84101c7f3851de0c141debd2201570435989700c4f55705a05c02c412413525cde1451c1157d44d8f9442750635513dd21c0021451252540b172debce21f981af404390fd21d0ec195e0280d5e2a041621db4f9becd0e1d82ac055a19042c1254e547ed03f3de146805c6e3bb504ed0e5546703517b3c57462c08ad074f5f9c4daf8408c545cd2b4eeea686142c37db6b5e20241297249763d2002ce4037008d8c46120120ea003a402eeeff77dd058ea3673bbbd87afac05518170e1eb736ac40ca069520815623d7589dc110494f7ac2f56f945896665072ee43b7d7c22a24824514e59c6c3afaeb0cee15505aaf06d34072c0166209d42a0180a014ca57c43bac1bac2b93dd0c5c5cd1bce15434948254e09b5527f289cee83f218a881a4b31140ee4c2120eab850360183444900381bb576f188540934f980f58addd902cd55b9503d450089a540e97b58b8634108e4a93a882059af0e0a80701f56ed501a2d7bac8200e5dc004b0376b3520254c54965149a9648f9522002e5cd481d7a318354ddc12966f9c1b4ddc10a82992c3e941684496a800518b9fbe0a9e8902a0382082f4ebf941600915750a01403d562b7e9d0013a88037f89f637fbe0b2887604014ab90042071a52e45f517876510428d054007ca0ac064b90453a9360a17fe911dd8b30d8ee6005120d8b1e9782e0a93de0cf61b3c5bad8160028527ba28c40f91fc6154097048035503bea62e3e50a546f46258120bf9c12a6a38ee9ee93b78ff2863a0201afc52281cb901a2c4359d9491a8a8ee3e7f28a890c546aa29b0b17eb053f09621cd189b45d3c60190a514800976b16a7f4ac4dbbccc43920010a080c12ee6858b429501500b10e94b8fbcf48da2eeb25a2fa16a54c051249a8490e078fce2cd653a9801400d36b53c2319cab49721eae6b165d07bc1d9d40d7ca348bb3b9652665249d646b054ee09351199256e4b9606a234d4dc97494b54bf79a326528b258696a31a1fe51d942ad9af0358bb3372e127250a4a83598b9a3c6edc06257ef252e5cd992664a9899b267499865cfc3ad2a0a44c42854292a095248aba446c1c3cc602c4a4bb8f0de37060b144b10a673529a8bc7d6f08d7ba35239f03a22ef83f64bb4c893db2bb1c70476b4c24b978ce757215385e53f68c4e1658563b3acb5d32b2ae229881de201992973155644ec4a8b09663f16735c389648527be09a59bce3f4afd9edcf7c9f955cea4705f1e1938ce4ff003fb259bc9de67e5b8c505e5d2a566a8561f2fc7cc49eeb48c44d40593ff453e60de3aa9da7792f9af2139d1cc2e5466a99aafee9e7b370d9562a7249566197cdff003b2fc46afb5ae42a5b9142a42a3f52edee9e1da0e09a6eda53cd59b547536fc746378547fdb5357f0e784fab3d7d7f36b2843883ccbd59fe724ad27f9cb3f9ca475467a0926fe3d046028248daed5de35dc5cb092a70ef63b0f38d194c5c2a852e00bc7f3b6b6938c8f9ca916629b96810ea01ecc0ef0ae4381e5e71e61903e7120d5bc0c48804b9afdc220009676f9408912064d2b5634b3bc6420176ad7ad0df78a520b8a0b5cde32e48054c598071d45637a31e692b968abb33f0b25456181005cd9bca3f59bd9f990e0b957c1fceded95c4f8695fd9dca0e1c9dc2dcb797884832b35e27cc252015201a1387973f0886dd58f57f018fcb1cb70b327ae5cb94854c9b3141089481ad6b24b0481bb9614de3f567b606313c87ecedd9cfb23659304ace266408e74f35c4a5b2a663b3154e397e1a70bba57371939955d0647f088fde7dcae953e0f3d676d3531f4787d2e7a77f85a9a8fbbd3af3e593956f6527d0f7b862ee79f5cffa3575f9ef11f9bd6f90fcdfe20cf331cfb33cd73bce315371b9be7798cfce335c64e595cec5627133573a7cd528d7bcb5aa3684e5a941f53909d34a1de3227cd52947558fc2a15fba3489f352924eea0c94a58aadb47c1712d654ad52539bbb6ef9ddbddb7e373cf9ce4f2cc79aa5157c5dd27bcc2de118cb5bea404d487240707c0412a0a49a9009ef57e2222b7146551c90a1b1dfd08f97ad3b9cf7b89a880c03d1ab552368a8283f7ea2a025ea7cbc61c152b50282157a0048f97480400152ca46abe970416f18e4725b22b278c15923500402c5d2e1c1e91142aa582cabb28167ea4c1d214689058bb03a48f5d2154351ef26f76a0a6d194dd8cdbba21603bcc5c3924d7a9f9c28555242772435026819bf388a340010cd60011087526a4fc4680549148c5cb2547246925ddcd4aa8c3c22ba39fe001dc173fd619d8a5d94901c1480c1cbbf9d61400ca0ce45030749110eeb2016d9a9d7c4444b3d1d8ec078c586a451892e4b33db6bc2934350124b0a07f99fd61d404b85390c5dc066001ab343173fc4c28026a7fac20ee916a8706860170a70a624bb8219566824f701ef33bbb062d73d20124b07249254c4b186ab9372433920bddeb10740599352aab53688784ac00ed64df7724de23f5014c5ed782da88d24106828c7e7d214339357ddaef12ddddba022831d56ded4113760efe05ced10004004851621858783c1208be96f060d5a4435757002039068599c1f87ac3a25820124a5ae6eff0028ac825880282a48034ff3860680bb0143d444adeec058163572a6ea77b42b8620a4becdd1adf9c3b04b1bb0a5818520bb9a3d4ec45e18bb028760c494805deb4f1f080efa497714a51e1ca749f0736353e67f18535b7749a316311bbc82249340050f74fe3f288485390fe560200152c52001514b0b444d5c94d41ee9352f10fa020a13a812497f0f5fac354e90058d89aaa174917035a7bacf6f4f11892daaafbb3a6b7f5d22cdb4901894b5cbee2ac3c216c4bfc26c4d1fd6d0e125541a4f551a13128b04bea1f09ea3d5e1be5016aed64b107a93e2608afc2efa6a523c221fb2d47b50123d520077252188a109606d156be601202989701152e19e011570092a35d9af6304a4336e4b900076e9009b38670c006b08376042e5c754b37410406603bda4be9029485ef105c066a10cff00d6188142e976b80124d6ef685efd410a824950af400b1b402e43338237fb3e310d19831dc1661e70a482a2050aac1d920f845927d40e4b2850b3d0397fe50a08d540cfb817a1fbef12b605f6761d62162a00951043088e966005fa006ce4343248049d2c40a9ad2230003a816ab116f0802859eb7008b7afca217281926c59e8cc4d0df6eb10693de20b390abb0f2840cc580b384907a447fb2edf69b6fac1600e55dd2e033f4b8d9fc210ba988a81b0a9f9c13e0c4bb80cc442d4134d00a8391bfcbe9078026e5f5126a1aa6821c9530093a41af5222380a601248b1b3c153e93624072c416f9445d5b2008150ee4bd0310de2f0f424920a8bb39aa7a93e709548074d5570d488c502d525c01e516db0c0ca209d4f51dd67a41346eed126eab18517729058d4f4f9c3a5d86a6a176a5c9dbac134085aae0b69bb55e002e0963aa8f5b7aa4470ea4a6e4501b411416624bb9a445eec0a1ea5810ce1edfd22312752802599dbc225aa48249b10e20ba9bec87bb300222fe2001206a0d70ce6e9a8b7ade0d92193501f51abc400d5d886bee4c25dc2545c7906897758028f8882d5ad433dab16802e5c93f2df6840010ee5c1a935d30540924172199c35fc60be904b907666677884b5ae2a00d879ef010033b6ce19abe3112681c82544d598fd6167d40ceeda886f1b5e06aa0290a26c4a6c20e90d7762ee4063ebf288c9f272cc520eaa4459b5802382f7076a3886d40a5aa120d49a6f1086d474926cc4d2142406209a9a83f08f387557059a814e9486362f4110b104db6726a61405135d27551880dea90d6766bbb90e2b1375700539d2aef2436ce4404d03d55d433189a5c29d40331068c2f4fe701983b1a9a29dcabc0c3281024a588513d5c5a9680096b167b914316167068592c4d098405350092e181b883badc05aaea7d40eba0a0f286d4e7722edd3f9402c082db54822b68834b0502030a3f77682b3dc11409d40864bb962695800503b9637d99e10d496a859a54521db677a546d12adbb0005212487ea07e5e50412124820151ad58114b44b300ca0a2ef4fc2114cf47041a0fc4c1a4981c1097486f022f0e1a84b02d52d434bc5412c0394dae6905151a76d89df78ad9818935a163de009f1de0936d219fba45c185dc825956d3f3f5f48890ce92c05c3ed489df0072a20074e970da40703c6239490c74b9a977153785258824800be9614f3f3f082407a1043b8a3989bd9010a88340e452a2a7d78439258126dd6eab54085b904e902da9ea2f05403867346f1da186ae00e4d7490c5faf4fbaf10a891de01cd0386221cb06a8aa9fba03a602921c11a48b100b922ad1080100d812fb93f2b410a766510966b8607c225001566367fba00d214192146a588a5cfe10badc058801fe2d8bb002004b330362487262328552c1c352c075686a80faea087df50f54879006a36625c5da9e30cb48058501a17144c02e1dc33f78007488524120b0092284a9eaf0b741d45493e3dd0e36fce20d4a26a1946bb44d2ee7e9d04314b925c1243350030c2f54048b7789600a4a41654302412407eedcdc528f0ac4331229a88029d7ef8001ff004824750c62cbc2e3d833823e171d58b9f5f94392e1d4909a306b9f310a4962a60c376762f02a3417043f462223ab7d00c6ead40fc44a4905d3e1116012e351dc94d4d2d0a4925d3522cea0411e5f5854d4324e9607574f2fe9109a40014a212ee0949fce2c4d00a02c2a4963668003b693a771b59ed06a6a43b0076ad3f28957f940094cb250907bd52a24b017820b2599f4d4d59ef054faaac54f50198d6e214690c4972d50e3ba3d082b3b26024af480010185a8083fd3ee89b804d8b283f7af0487abd00a91409e807dd000008268416a86173bc2ef7607d490c024b1bb023aff002880a5c9341d74b74da0b80c083423bc401d7d7ca2b2c1c915774b905fc62cf2ecb740706c54a6670126c07eb0f42cee94b77583345092c6b77d37f568b52fa5c568ece00776bc5a2d37909e4228e583dba03ea91633d4953d8d3a7a1085c54b59cb55fcfe90ce4924835167dbc3c2368bb96561920900dc855998464216a61407510925df48f5d631d9c84b821fbc0507ade2c0450150bd88a9bfa68d60ed23557ea6a129406a4b923ec801c3f48d5a42c20a5409045d2f43eba468529d895003487a90edb7af08cf91302b4ad24104d5c54d778f5b4d565169a3483c1be72d9ca3a54952a5af5054b989514ae51154281b829201076223f527b6361d1da17b2a767eed7b810313c5dc352072139e064a75ace2b0690729cc6791f092754b5294e5433493fc31f945809e016b30748219bc5bad63f557d9e18dc2f36325ed1dd8df88f112ce55cf8e5662b8a3810624a548c071570e23f79c29940d12a9d214bb54ab0d2cd74c7eddd81d4438ad2d5f64f50ef1d6d3e58796a29dea506bf3a49d27e551a3dae1ad55753452fe9559794a398fcefd1ff899f9118c925d46f5a748db9386951059cfdd78dfb9f6027e5b8ec6e5d8c9624e2f018a9982c5c9a1f753652d52e620ff00d55a543e51b27148ef3d1ee92c291f8bf1ad2ba355a7ba678b563634b5806a0dcd4c531913001425cf40229a1b966f08f9292e56d339002b401c9fba244a8f03f43122b9e801049f001a940d1016d81a6f11dfc49bf5890588ef1de9d4bc6a3844852c12e7625c823ca34f402eea700d09de355c1021692430352fbdef1dfa28734d266b4b73ba9d85f9552b9c1da7b949c238e929999061f883fbdbc57326a4ab0b87caf2496accb16661d84c548c3e1c1342ac5246f183dae39a479cfda239afcc244d33b2dcd38a67e5d91329e5c9cb72f270581423a23ddcad400fe38ecef61491fe19f24bb5cf6969da64cce17e59af967c2f3c82269c7670a9495041fe213e7e52a0db485c7e684f5280016a2546e457513f117f12f1fbd7108cb82fb9cf0ce1fb4f5b3a9aa9f8f2536f4f417b2f1af25f9e7b555ba5a2a74d3cc9b93f9311fd7f39a64f984862ece4902e634898a3420148720bbb9f08d4679209724a8d986a4b3d046993493572e90e1c339afdff008c7e41a9a99763cb9ee53a83101059c125fbd4b521167e2008602c2ff330e48209657f16a068dd1bac56b2055229bdd5a63ca9b5b1415d4534356f99a4292aad08011a4936ac026ea04a83b970cdf4800ab501777770595fce3093f1316ded6029f504b38ea76807e1490c028b2545c910ca6526a82402c2a59a21003d1f700b81e718b6c8b8842b4bb97677dcbc2d00248255b55d8442750ef12920b6a3524f46eb48808d2a2e496601af678a3bdf0411bbae1542aab5ff00ac14024962198f7aa0017b42a427ed79252d5ac401bed2831a30a988b2f9c0f57068ba10cecd159d24bd037c2051a0ea2a569629068f7a6e200228c2bb9d2efe30bbe8080871436a16bfca1ebb12402ee41045ab0a92485062410ee68d48748626a6a2cf5544b4b6ea0505c8f106a6e62124b246e1d2137b7f288cccf6b1f0f0f5d22509eeb92f521c054570de41001a93de2fb6ed588cc07505c32a83c0feb0c18ad24160039510c6ec69f38040d343f37bfe712fc8018901403951254a269d19a05284961aae1c83112e03803c03383042944a8a521236043d7ac459edd00aaad090522aef582904a5cb02fa43d35400ec4ee9a10de1f843a454bb02da81d8faa43a020ef0001750356fc6d002895024b38dea2b1080c540549624020b7eb11f496e82a4540788b780258307ef17a9e9b7f580480121ca9291b540885a85c50d011054c1828b103e26fba252f0dc00fc4a04b167152f56a44d491dda20dbc4fe510312c6848e953b402592da0826e763d3e5117005d03ea0c281816301ec55e64dcc00c5c0d4c9ebbc30492750ee1550d283c226e9bc821b9151d3e90c48a8006a07e70a40b392d52e19e9bc02f5500353b11fc515f60204a81212f52ee36bb88228ca0a3a88212556f988290ea0e084814ddcee214b0d46a12453ba54d4b45966d64072e4d4e92c5d40c212a701a8c1c92e0dda277aaa15166b136880bb5189a87a445efbee00eca62e0e9615a6d0c459ebd2ee7d7e50a0692c6bbb82e078182914725e8e48a835fe912fcc00bd458d9badff0094059a31b3bbbd768706e457c5d8c0209753b59814bbc1670037d241ab6d7689e4aa5ea68d048748291de7e8efe70080c52a7d746f13e9e2774980024851a39a5dc1870f6a12430503e3585008749350682a06d0c45541aad6e81e2bb302a82a9674d80fb5f380ca20970e46f0ec90004b9dc93530ba454b91a4774f8c31d0042493a81f10755e26ec7aef40af94287293aa8c7a54f8c10c4ea2e1c801f7f285ba104aa5ae4836da15be22a1a68ca0ccd162d93726a68d784360450b5491d5a09b4f089113a9e82e69aa822d02e01258333400960ca24970424d2fbc3a7bcfd19dec49885e20141500aa8da54683a41d9b4b934725c08509b33ea258806d00b87353501aaf7eb12f600a926ec284ec478435dec1a9e100bd1442885d0ec609a3253505c3bbb41f8811d83b953904134020d05c3023577681f77112c00240daa684f96f018970a538ff00d234da18b019dd458b8bb0a94c40addc806fd4de11c25412c5b7ddf78b01766008e8febc21b81400a4bb902f4fb5058391beaab9a5e05810012e6a3730492090685dfab45aeb7f000037d4e49b3be98522848a9d4e55b08362e5d9a8050262302e12a63b97a1f18a3601a882a72541236de19dd8786e6c61121828f4a36ff2877a7cbbb4660444a609b555a9ec5de0528129252f5d879c326a37702a026debf3805c14d5c74dc442f10104b029241d890f480144ea510469f843dc9fe911ec053a03bc1219cda8d770d17cb6ae05ab1d5a94c686f045ef4156143e30a59d85010e48ac331770482d5294d3e915df702b1d2a15725ed0e90400c68d6351f2824312ee4e9ba4961e701340092eea6a0a8686ec01989d44b6e48a0ac2d48142402e01a13e7d21c8702f70fb1de1144f5208b30a0a58c3aec08056841493de6da2ca1205aaee5d8034b4560d0926aab77585e08f8eae77603c3685c0c129ab3bff0015e00a3d4b83f137e22224b12540b9b74542d8aeac5dbc3d5a2337b203774800397ad038309a5d92e15bb970de70eec0b54861d1a1750274e9d2541aee3ce0022e5dd200a1353040bd49511bd6055c6e0d057e1ac3804aaa59e869fce26c80ab72010d4ab181aaae145ba1162f0598104b83514685ad014b021db7045a0afb01989604ba965c04c339aba8151abee6152a243125f63a6a6238655189a31b0b561ec04295800b9201625ab5316246900970ad20853b37cda11824ee435c3815860c00b9f3da2525601504b3ec6e417f9bfab454cc4d28f7dcc3a893a9c28907493bc02c34951da818b78436e808e59b50274b90f5311a8e46c7e188a0ec9f071b13e6620341d01621ef11e4026a6cd5667a9856492a2c40240ebf486252d42ca0c1882478c4481521c12a7a92411b183c2bf8812a972050518d14910e54c2a5d2ab07b188c6e1c9350fbf530451c9001b8252e01a44c700360144a881427cbc22b512e592e9d340fb45a42882c0fc2fbd61540150dc815d8dba415d3021202b4ea71622e766885b510144757510e2010c5203d5c90012fe70e0f7935b937142ff00388b81481dd7d440156fcbe4d0c5c58150d4e412c4c16d8d18dc07d5e5005dddaa459ebe5e50f300a55be552e2f710c68f6a0a07aab6f5e50294705897f130bd03b04d4bde1be5819af50c297a16305eda7550503da90424d2a0105803426bd208258803497b9a86ac5a2b38011acbbbbb6e7e6d10d4004a81ddc3bd5be710b804127e2776ef5808055de4d083a883483ba6084eec0a760010e47d6f0ac6afb8d5a4977fd20bb300592aa01526c614070972c6cdbfce0959d80e9ef53bcc7621c9820382ee934ddc111582e5c396e819f63168605816012e776f13137c600c19c24849dc253576dfe50c284905292a17219fce2b01ea4f7802c4027ef87503a8a6ae6a953301e24758d69c9742d1b3bdc67058025ba173f380ea04020162cc2a47aeb04121d645599c50187606803925ef5fe91b2dcd535b17a14e4254c924b6b346f08d46451428456801fbc9e91a6cb3a980001353a8d4f93d23324ad8e94b6a07bd4a1aedf9c7650a96762c9d99b8b0aa50524a9caaeef58ec1f67fe69e2f939ce2e59733b07357297c19c6582cdf15a145066617de8938c965ae152664d491bbc75c24cd24ba028306235384c6b92099c832f5100a4cb51dc3c7daf00e27a8e1baba7aad2bb55a728ce2fc2516a4be6691d542a4e9ce3521eb269af6ac9dbaf68272e709cbfed49cc9564f87f75c27c7b3f0fcd2e0d9a8484e1f1597e7d286256a9405908c6271f2c0b8084f58e86632580ee4b6e086af818fd5eed78b91cd1ec8bd8d39eb296bc467795e4799724b8ca668d65388ca9493841314efab4614ccadff007db47e54e3522ae34b8b1de3dbf754d069f49da6d4d6d2ab50afcba8a7e1c95e31ad14bca3cee3f21d1c569c21ac9ba5eacad25ec9252fa2f6f90db8b1772480695358c70e4f52363bc662924051d2d53bbc63170c5ff28fc62b2b4b078b2b733b084b9789037a57f389197b0827aa4338e8de3722160d09b7c8412bb06420300d57b17668d5b0603a7fd26a0b023d7e51a523ececd466f5e846b185649d42a024cc6762a60edf747ada15152e67d0da9a5bb3f54b8eb113f967ecd1e4b709c9548938de7e737730e35cc578729f7d8bcbb251344a4ce6a91ef2661687ff001098fcd09f37e25a8b806c1b50f5d63f45bb7463d390708f647e5061d32654ae5e767ec26678cc3ca52c94e373a5cbc4e214a0ab174114e91f9bb895e92400492e2b68fd93dd32b4a8717a3c23e0e8f4fa6d3a5e0e1460e7f3d594dbf36cf6388aeef51dcaf80a31f9a2aff4dcc298b7515029d249ee9a98c2980172a2e4a681ea1de2c58515a8f75c307766fa452b34624952485129bfaf08fc96b4afb9e54ad7c14abba18a8a41f843b93e27f9c004509006ee0863f2feb1165c28177d474a2a48852f6ddf736fe71c0db646e0362a494f7ada6c3cc4290287bc424d4387f38605dc152989163f740aba48274dc0b3edfca319b7b18b6f6602a6246ba38d23636f0fba21275001fba1dc9d492372c61557621c9af7aac6d006ad44ea6d26c4b34659bddec542b292123bac6a00019f684621214417249019a1fbd5490cf42e1987ada225297d41c8058815778a5bf8f98049ab1014e3a58b4202410f553317154b5a1bba4870ad24d4b1012444484b129502c19c96f422559ab01189240d20dd8d8c3022eceb01cee05fd3784121cb976b28814f3111344a8117b3efe11196ac05d25be21f0970ee1a9b4324bb860c52ce5ab6857170fa9aa0384b35e1829a8ee935a07aecf1295ae9014934729b54060f7f4d04acd40d36d3401acd1124956a72eec4bd28f48629049ab815dc6dd22159ec09d4129000bfceae61547f888b7743375fd61920b1480e09d419ea1f6fc605f5313a457510c77a42db58012da544071e27e13478892a2081a946ae3e7ebe911351a9c80ed537005cc3500582b2a63706fe0f13d720a802c5474848219516248ad1207fabad20540d40ba5aa9ba95f2842aa93de651bd98f84426c0e540ba8a923ec82d5f5e30812c0100b01770e7d7e504872412c0d0feb10775f4a887a87fba1d6cd0086b82087b12e7a3c025da8e14296b412a24779c051ae9dfc613e13a6ac06cec6276c2012cc4b800d1b7fac1f105f7456f08e090926df1036358b5cec1945c3ec7c3ce23247511200048530b9259bf9c1a2886d376005778b12fa4f42adcb88425c28d3f859d99a0f292448bde04d054d4167feb01eecceed51430e5d45360e18bb8dbee885ca4f4028482e6dbc178302397a10e3a37cfd7842ea62c43b9707a9eb0f436219ea34d20540160a161f288e96b80eec006a96676b5a012016bb541dcc002a50165c9a937f182cc410e7550035615859db0001941c17d46c2fe5fca1cd01b07b5031ac207a69b3b17b830ecc0d4bfd091bb44eeec00685b480e3e10debfa4450484a946ae1d81b5b6847018972e0b5e90cab69aba86d6b445ba30149700b0036ddeb12f5353d4976e958080d6701dfc491042aa45dc313649894a5b80835b835b96f9c11e1f6430b16ac29a00db8760e48b413434002b724b1541e3286c02406b31f2bc176dc1167e908a65100b80cf4763eba7841040048bb871b9f188f68092091577a03bc424aa8cdeeec4114685a93de6625fa1f0f5e30024a4b29c91b0060b2c0ee14e4b00db4421da848352430220976704ea6decdd6010c2e481b01de260d82298777bb770480fb7ea2212e40ba98060c0aaf13bda8310cbabd5c4282772c40d3aec209f5058480e1806dc5fc58c2a5d205ef63bd6141d2e092c6c5a8d11c209a905e8e6e2cc2176f603ec43bb976351e3e8440c6ecde24787af9400eca1a9c82e01f98b413a8024f4ab071f382c2b8204822ac2b42450fae908ad2ea07bcf72081b436a50620129b312e5fac0512092371460f138b5ba821094948241dc02d118027ecb9a741077a9a0a8f1f9b44625cb6fdd22a4de2b8021a3a43d6cdf134051ab77481507710e6aeee0dc7e9159249a248fc4c2ced9033904877058a93b446600b02126a7ce0249d89d37adfe516d141c835767a1313b0114c06d5b80c0fab4404b8052086707a34135a9344d7c6ff7f9c07a12a512e5c0fb55862f903534a9aae2e1818800ab329af514850e28e180a1a9e90d5d418a46a35d4ec7c6186c12e4bb31b12439856042881705852be30ed47a548a3bbf9c213af5105408eb630780282689b281a3ef1633950b36c18c21fb3aac10eed78648615a2941eb710d811c16d94cc3c7aff48008670c90cd6a1f5d623a9cb80480e08b0deff5800021eea1409228621637033804a4509ef31a8f082749bd080e48003f94035205401d0383d2013a8b289019c39f0eb1394f20014ffc200147153f3fa412a772e94bf7587762120e8a029e82a6ff00d2084dfe1538fa3787d2b0f26000970ccc962eafc6029947536ec48b18843e90e41096539a1a518c453a4b05126c1c59f788dd5c0ee28e777021480481dd7b8630405000962ab0245035e2020b1049eaf7789cdee050e92c3491e3524987b25fefdf7b428674bea6d547dabd226b2ec1cb1ab0b085bab002c6b726a91fc36880853835634501435a43dcd4df7b1840a65331a1a8140626cad7e8025dd00014a8b52f0429cd039352435690480da6a1c070f41007705c83467ac427e2024974a5839a97650f9440433b01b787aa429ab80a5171abad7a4049292450961aaaef056ea07331cb3822f40c9310288295690758d2c482074850481f13051ba6a0783c351dcb93b0174c4a6dbb823543d41157bb789850ce433826e1837ce0d98907bc2a1e82017d88a16d40d4f844a69640c40a6ce4316751a7e510900e974dcb817112a428d52370690e10cc35059b820b1beff7c46d10286a141d98006d4837b0ab6a3a998fca01a03426ac43b01d620218b2aa0d8bb36d0b26c0dd0821eba80ab18ad454096d240a0eafd0414bb11ddf883949d46ff8c4a8b5435c8a88204ab925bf073e712947486059981771ebeb10b949737bc282c3ed302f52c4f97d3ee887940649a6c18107706957fa44202d94490e588761ead014188d04a410ee1dfc618021c3d1ea4d1fd7e5137eb602bd8160c5def50f0c94b9538480cd40e6d58167d218dabbc0152c6a77297afaa44305c19800c54d42e3bb5a4228825c8014052a19ed0c3ba09d4c1dc06f4d0a4bb105ebb0b787ae916dd59019c392c54541da97e90a41ef020d6aa2e037ab42073526828c3a0de1aaa539a97b54888ca76014a886014f47ef559ab01dd2414824862a0da6b0402c5fab10a3786720a940240b9ab0368956b810072c080a22c0800b7e70dde20829001a3fc255d21a86f56a86141e30c749735e9549685d6100b92e970f7607c36821214a2ea4bb00f4a7411183330487a024b9f9c4410905c381b3f5b18ba033058492030201090001bbb7ca1d21495062921f512c0e9a42800904288abb3d2029634ba68fb0a35ef1ba6ef665e2da76182ac0e92c5d20a43d7c632a54c3420000bea60058c61974d0a859831241f2317a0805285b9ff4bbe97f568de9b344ee8d5e42d419481502a09014cdd23726057a8a4809d206d523c236b482412aa1a6e4831ade066b5092e92da5cf76b1f43c3aaf77562ce98bb599fa21cb5c4cce3eec15da3781674e4257ca3e63e4fcd9ca2584a664e548cc65a3098d4a05c27561412a1fc71f9b198206a20b38a78d1de3f49bb0b2579dafb4c72ebfcb99fe22f66dcea4e1a4cf514e1ff79cb48c5c959a5d2e5ba3c7e6ce35457a574266244c63b6a483f998fbdedc49eb7b3dc0f8954f5bb89d17e7dc57a9cbf353a94d1d7ac973e9a8547bf2b8bff8658fa1a36dce275abe1e9466f568c25000f8bd7c233a707529a8d534bf846229816a87b88fc5350ad33c692c9592fe7bf48902247395243a761bec48b5215c871d6f052ce3abf98895b83290cc95015dc59e37770ae57373ccff0023c8b0e85ccc46759de0f28952e5875ad58bc54ac38007526630f131b4658ef00ec199c5ad1cfdd9ab2d39b7683e44e5806afdff009cdc2f845357baacf302547e8931f41c1a877fada5a779e794636fce697eb3af4d0e7a91878b4be73b4bed18c5c8576ade38c9b0dddc3f08e4592f0ac9922d2061b2d94bd02b4d3ef58f947412682ad4494902bddb8f5f9c76ff00b736628ccfb5c7684c62260989ff001131585d4a57fec3a25c81b6deed9a3a7b396c1a9aace964923a1fd23eefdd0756f55db0e29a97b4b515be6ef2492f991dbc425cfadad3fca97d6ec61ad449a005810cce4d631543bda6c48a9fe1f0bfdfe316cc2a72ddd24053867f3fe518e482189a90ead2cc4748fceeab776d1e78a490094a588a17b9f9fafce23252514605b53863e3bc57de0a142124535105cf8430516ef03a85402c74f9472c9b48ce52f9889212ece3a00c4fc8c0776015de06cdf385d4ca600db531605fa34215172e9624d5cea2db88cb0507531aa482450b9eefca154905fbb5352e2a7e4f06afdd0ec9d058b3bff282549ab07090db53ad632df0c8b08925dfec80ca70e474f5e3052b6ab0767f3e90a18a80a00aa1ab83d220720ea290c685bbdf589db00705ea94861f1a49777da1054177b3801354fa10c016253e443b83536825993a8e95338660df388b279012ea074bb00cc0135f38529760966f1a91e1129a189604dcb1262777ba407dcf4dfd341ae880349a91715a9e9e0f0c0ef4ef92e34d4076785494d431a864870c7c3d7587700339034d122a6213695d02048480545c125836f5a9fba15810a22aa218b500f4d16062122813d7ed7af0f1850c7bc9d2370ab13e0ff744d920461a9350e0f76901412d564b9a0b9f9c158dc3d0b8ab81bfa7845300f425dcd9c74313b2ba0212dbdab54d7e9fa410c5342a15b697104b0068ee2ff480e6bd2de75a44653c002d40ec4166a0602902b5a0259803406df7c3105248d80a292424978557740d4ce2c583d621a6b00200a50bd8a5d9e0848b96706ece1bade25f486a6c6df289d5c8000d8c2cd3b81492e3bae08a6cd04b1a1a9661e110bbabbcf47d811f2fca15375121206c4553584b08103952411a5bbd6bc307d41a85eb4710ac753bf79419e9eba4382436e49651b9110bcf6010d4704d7e23b79885a328bb31a9615afe304ef5b380f45181dd4b3834b3b75b44e10258eec4568e0c026c9d4417d852fbc125c0d9c7774b03f285605ca5ecdd4c43dd20382c681c9a5a97bc297206c5e94ac11dd1700015ab1de000010c05280f4a5e2560013ba9aaa3a839afd218121750cc35120da15275ea70e012e598c3a4a981000228080091e7109d90148fb2921cd4b26a2090c2b571b6de710b02497700bda0778104e901e828e60b70304b24b316bb873fd6159dd8821f6b0f18848ab064aa8e285eb05d80146d806047afca21e580b0a3b162c34ed0a9a0503a7bc598f486530f84774d48f2bc2303a8e9a3b8538ac5afd181a80871a402c00ad69e30c68c927513724507942820392017b83bfa6816ef00ea07c3d7cbc216b2b02104823c8312690480083526c3bac4402a4825c9d5bbb13482438ee8eebb858533f84425d180a920d8392dabc3ca004a6e951209a1e90ce0f502ae68d03ba000ce3aa761d22c93b5c108ef02092376a10d480350346e80f5896a8047524d488884ea2e02881f3115bdd8214fc34bd5b730024a9449aa7a130f5aea4d00603e102011472c680386fc3f389c3e8052c900b3f4e91186c1448fa318622b4621aa76dab02ea242b503b860622d8dc01408ef3173f11d2e6d05c690ee458f5f0815068c5e9705a14921547ad482057c60de6e80ce13421ba69ab8802b54bf42e0d622887161d14de7e10c1c77555d8581f9c1e5dd0028501d21ee47f2fac172c001bddd887780e424935201049abc04a9c39208b508d4620102a8431721813f8c1480c68e5d9c1677857539a12e1c39158605254ff6aecf62f4894fa0024000a403e2e971eaff00587767007897a11f7c2135676b9d3b6fe9a092425fa0248a55e180120ea034e94b3f9d6f78aec2a0148347a6982babd087a7f28508b3104f8dc6c20ecde016070cc052a4ef0080a04b30777b8889028ff12a8e3e50ddd0e1ddac363139b0093de62180480185da2b56c096370db8fac3a94541c8d4f42ddd8424023bba8b3b50088059b821b5269d4f94210541dd942e2ede3e5103805c339700c04ba594039a85581f1827e1b008040486a804106d4eb0e026e6a4d00b0f0f9c23252092e526e49abc176484d09b1538313d3601eeaa81c126a1b5379180a14ef3902c40a182aeeb77284390e1cc295518f7490e40661ebf2887e2c02c3bf400bdbe21d2212124300c4d400efd221a82951048141b880a21ee5c51c1607e5ead12f1b81bbaa3e2ce3a400904dcf4a87e9f58296670c0b36ae9e50c142b47043173506230004066068f770f08469ab7c3e3522194807c08b1a37d7d5a0b92fa9206c1ec7ce231e008010b21b67157110a41ef0a6a2f7a520f956ad563bfdf0090c00275156c0009bc59ab3bc80480f614b12199e010ce28000e5ff588e6d62cc082ee3ac1b80145f705875eb15e970063460c923bce18fd6194c6e413749676b5200622aa0592348ebe110120820b3f951ec626de0086e4b026c5cb0a185d092fa89676702de1786653b000377af5bda0780f370435ab1679c30409042992c9b249554ed0401e15b96a42db5a88607e1f0f289df2028bb22a54e083f28adf16046350481b82fa89feb054c3a10ed40c7ce028baad55598b379c162c140821242751fbc433b203503fc3d01f89a0b9d88bdc2584210013560431602a7ac46bb10c435377bb41006ea6d54f86ace618592f47884e9aecce6b6a440ca140e090351350f589b5de00a7ed69481b39153e31639b3a8b3327ca06e5ddc1b12f6e900583d3555c9d4444359b202b124825882e40dbef862e059ca4f5bf4884021ca9292f66bc44d06909d4e5e81dbc7f944e130000e9ef06ab33b9b1fd61bfed3d68ff0015c6cf00a920b9704960e435b783a426a1883e4f11e40525d44105c58b50dfc60a521857538720d083e9e0e9a26d5a806be110b35c5892f714f5589db00290cd4a90ce05ab0000c5c39b017ea20905ba156c1403d615c2010974bd1a87d6f1166ba00b3397218b16a3da1833bb1d1614d445771012c400a7200a5bf1f5780182be2018b392caf01ebac59d934d018d429ac13aad616884109a29f5067fd6189760f74b0218957aa52158a59f4b540b1627a41db701d4cc3410a26b561e111cea05817a01b0824298d404a680aabf285a9092a49a062051a09f801813fc4413414f861c9d9c1a54e9763e31583dd20961fc2d6eb5e90525e9dd040b3383f9413770300e7bc900bd1adebc21c390a4b07764a9d81f5f9452090d65025897a1378b02890125c949ee92cc1a36bbdfa12b192cd2da7ed69f89d818ba580544914d4e1882631cb0275148eebf76f0f2cb143ba6c1e80ef1b41bb266d169a35242c80970588247da7f9c6a585584a83bea26bd4da34c96c54598009672c3e7f8c6a18721c06034d413f11da3d7d2cdf32358b3bf7ecffcd9381ed31c23869a842e4675c3d9f6493a54c4ea95393372ac42ca141ea0fbaa88e8871365eacab3ccef2c5a4a4e579e6372c32c0ff77fbbe2e749091d1b437ca3b5fd8df301977694e4fcef7894fbee229b97b9603fda7038a9001f32b03e71c1bcf5c18cb79c7cdbc0a13a5186e6667a9969007712accb1131200f2588fd0f8d548d7ec4e8a1bba75ebaf9274f4efeb8b3b2acb9b4715e127f4a5f61c213d9c93f27b469ea20d0f5f38ce9dabde13b034f94612c87a0a3bd63f20d5625647953dc4a6cefd6240f4d12390a047460ef722b0c825c6ed67da122c4872ec0344c7740cc40203dc3d01158ed7762e909c476abeceb2d6031e71e44a650a829c62561fe698ea9c9abb003ccd63b65d8bd5a3b54f677582cdcdec9485503362447db764209f1ed0f32fe9a97e9c4f47438d552fce8fd68c5ed593d73bb4c73f94b2544f37b3e4935344e3e7a07dc0475b6790aa02756d7d47a7e11d87ed42b0bed1dcfa9892197cdee20583d5f32c4475ea625cabbacc9d40ddff4fe51d7da793971bd637d6ad4ff00b9227559af37e6feb31355800a06b505d40bfe318cb67ef3a88048490cde25a3208a97371473f80f568c558512aabd6a4d0fd63e4aafad63945de81c0155171f2804a920004a95649f0ad200412084d9dab47ead0425ac082ec5ee04612dae524be12086ef2404b94b1526a6225d04872028312450fce012ce59eada9e83e709abed0774907490e0b6f184b0ee643bb246924176aba4fcbee80a7003974bd4017fe90541dd4031ea6a3e50ba4eb162527bcf6a6d15be3002a63a6840f8aae4b35cfdd0a52c096207c2482687688a001604920dc862fb6f01414e0383d43b8310fcb701ad09528a5274801c56254a8742492c2c2c6010ce0b126a40a01e67e9588ea4b774b81d5c1f2885b5a22c58006502da05770444d008b2897090ceca1e30a4051590fe0e2f672d041018b1294ee157bc5b6df600533f7852da4bbb354f586492af0af7aa4b871480a756a29ef3862e194ed678800771602809d2c7ad20a3e002a670e58d85fc5e17ec803bcc48503410e41249240040351ada14b90e039b5033fafca358d37626cc7015fea53f7450f7ab100212a040eea828b0dd88ac3a52a2482e0ee0072f5ac44a543503470ca0d5316eefe72ce0ed729520d5c873b55fe5034aaad5f104d7a45ea4a8d48a1f84b5610243a9ed7077f288eedd8723b14a87758302aa162c49f5bc10eda894964b143124fade1d480431ee9615b826108354a002050b5fd7e915e47d115b3402cc3700b002a52fe10b5373dd01988682e7bda41660e4dc7588e09a2497a39bab68a59dac4043b9704d5b49152d01b7a80f406adf3825eea4934f224ed0031243697a8315e5b6e004d4302038a8b27ce186a4b3d3666840482ea6fe1491682c0efa88ee8ac462c00a49a024b8b0ab01d4c284a92aa0a12c15b111629c9371b8dc1f088c052ee7ab9f568590054559c8eaeef103d2e40725c1222bef062ec554ea0c3848b13635630c3d80c07c41aba9cb38110259944e9001601eb4bc1b90ec03dc4424124384bf5ab35ab04af96043f01623feb0706fd20d585556f84b906f11c501a81b0f8afbc45300092e0ee00a0884bc0100200096655c0b7f588c5deea70c13ebc623392d760087a44ddeeefe0079c4abac00141f898354280b6fb400482a777b135f943073b8bbd031afce21a8d4cffc422316b2042082a5017b2479c0a8a914666d24b7f2823bf4a006d4ef26b0598d144ec4b318977dfa00317a90c03d5c3faa447b31724b80db4466a104bf415dad0aed40016342eda60b280c012525c00ce6e4b40abd120b3b8ad22020b80e682e2de510ef6005cd1e213ce40ca3b006a2b5a9847284bb967709621a0b800ee3e8f043024d45773782bdc0140339abd68eed0c415106b400801e9002c13a6db05300fe304004a8307a0a6cd079c82310ad406ff11704c4054e58872e1ea768142ea707f8b6685068c5f482c0ed0cac01dc80d42eaa1a9104904ea028f400c0636b006d710a4d4801eb460cfe10ca574c0c033d4b3387049854ea2ee0b92c090e0c462e43d541c07611085330a106a771e022126062f525e86a4937f3eb0198b817a92e440294b8724176a58d60061a99d5d03da9fd62c92b640ea25b49362f40481e70852d5041003820906f582198a5a9e6efd20d807b114a391117b82b1dd20d15ae9ab61686d440d9c101d8ee609d247c57a864b6d1147480e402ef41f156bebc6093ba401a8d09ee8018f537b7ade25362e165c392e3e511f513b3ff00e8f4815a39041a3a441f981c9a94970c18f4358504d6a0693bfc44440f44debf13c4a1154d7e102edd6174000b0724778541da092ad2e4bbf850f940665390cc18926f01c294c414d28c5c882b3c02cf892c41d92017a79c210ab7d91d1c440a4b165303f68d8c02281cbb9ab5198c4be5be0160622e4817f96d0a9173b13406ac7a4464960c5c8a107e55eb0ce9761682c6c0adeaeecbd9fcbac385121c7740ebf0f8c29d5bd5fa06fac16d2e6e08eb5fa442b81fa5c121c50b91e9e293550eed74b91673169b51570e68cd15be935a37dab8835601a692a2e482ca009821c90ec5db4b02e20582aa0bd430f282c58d29f11d34310b0ee03de721ed5501e1b4424bb0720a7c5f6fe501351dda121dae60b382146a7714f9c59ed760152c93402a1ed06a7e2052f56eb1055c17252003d3ce2357bb76b3b8fc62b7c580d620a46ec940fca2106a7ec80dde0c5e058970401524d1a0136a3824b91b78de2cacc013d49722ece078560914245412198104d6210d4507ab96af9c0352024d0dfebebe905b019fe2a92d601cb082f72e5db6723cbf0852fa8973ddd9a082aa80c4b12d10b0c048553554ec34d088526c2ce1c924b5a0a454105da8ef5fc611372e59ec0c4bb59b4026efa6f4772530e5d81d258fdaab98462e496201bbddfd7dd160147d556f84d87f282405ba9925c9b50d3ac210583076577bf87cfd75860937342cce0b41fb800ec68af088ba78602545ee58d0eff280e1f4824849634259bf483420559cd806061598925c17b5f7de16f0058ab3249623bcf4b784231254aad28a26e91b40201f86ac1c3d619235050a8203906f16be6c08412c0b9ad2a47d2203a46aa2482fa6a6f4b4396ee900870d705fca11c6e08203151008553a430b2026a544b31f8526849a429fb43ba6c6aa20935d8c31614a1fe126836f5f285a00ce5c1dc5a0d2b25d412ed40014d01060d4967750a90a74c426aa4b7c42a4ed10dc54552c12da49886082956506ad9c9bc1154805c01b8b08370c76a823c7d5fce0929d29a9626a6eab085d8033105c280bd5cfeb158058b06ab8724910d6ef0a8059ac479c448a3b10417360df27b42d6ca0369215a4922c592fe110ac9292cc4dc90e487a1863de0580d3e1711014864b95866714022d6bab015c029d8a4ea76b38b79c4ef280035104ddea6201a81203e92c05dfa9bc06b39517a274d02778a5b006046aee1d45f495104835a437783fd922a54fdd59fce10d4b3311761f7c025d98060281dc089586adb819d574949d57092eafa42070ee1c5aaf510c00043025aae0bbc36a1a986e6834873e662cda42dd080328d002f65743e30ca0a3d685d802cfd2201b920926c054f4680054fda3709059846b057659791630331d561b55f6da192c0b3902c3512f7dfe71554a925b6a925abe5f21164b254748660d5201fce36594691f23325ea60e497d85ced1aa61cb3103ba0d9477a5a34c948b00a761453301e51a9485369a55d813bd7d7d23d1d35b74690b9d8becdd3172f9efc97988242ffc4bca10e28c158a4a7f02634aed49225c8ed0bcef932c00997ccecd92cccdfe7927ef8d47b3b38e797268805c733b2624eeff00becb8d2fb544c2aed15cf25070fcd1ce092474c4a87e51f6baa77ecb43fb6ffda4753bf716f3475ae79af52fb5c469ebf2b758cf9c03a8bb1bb9f38d3d7453106dd5e3f34d566573ce9ee21f37fca244891c8509164bb9f1a78423d5ec5f68b658ad6c451ecf168e64912b733e4241a814de3b53d8eca53da87b3f15164a79b3931531b36223aad872a2454bbd0016a4769fb1fa5533b4f720c357fc53ca547e538abf28fbcec7a6b8e689dbfa6a5fa713d3d026f554aff1a3fa48c0ed2acaed09cf35103bdcd9cf949ad4ff00dd19e47af18ebf4e62a7aa4a8b1008d2fe51d81ed292ca7b4173c3507239ab9e0dff00f63e7c75fe7aaaa07e2140c3ba9f947476a62971ad62feb6a7e9c88d527dfcefe2feb302655468c914558915bf8bc632c21c8054134291a838d9a32167a92dab4bb3178a540b95302c2a41bfebe31f1d52eddd9c8542a18558b5fbde70fa81adc26848352fb4292a2f7352e6b000ab9b92c639e7b19cec292e08480e82e90ee29b7f380411520004bd5d86d78b0905c77982ba1092dbfdf08455cd56a36263096e9a331c304d815016046db980090492a00015d17f9426aa91f0aa849b6ab5bd6f0c1449510eee28cc0ed117c6502ba55f715d4a76a79428d26a9b0dc432d474a8d6bdd550daf0a6a198b0a9157da17ea982cd35eebd43870cf109fb54d49a009b1fafaa42b91b5765027e8f118b2430f37366fc221b7f2808a0d20e97157abc04dc03a5854bb8fa4124822a121ea4177f5e1049254924289228c090d568b5eeec00db6aa1b00a8b12c56e05427ed0a5eb089043a7e225567b751e51724ac9582c9290ea51ad1c45e29ec2cc1470011e4ce37aff0028894295dd0c18d00a9b458905fa86a1622b50f1908406d4da8b3ea0e2b1d108736226e924ac2a2592da58b9a9378ecbf65decb3ccded79cd9cbb923ca19196e65ccccfb8633bcff0084386f1b89561b13c5f3f23caf139c4dcab06a0929fdf27e1b078b321130a52b5c908d40a931d7592eee1d9e8c97de95e91fa2feca8e759ecf7ed0dec6fcd85e32760b0dc2bda0b877fb566c87331781c7e306558f966a1c2f0f8f9e823a2a3be9e954974bf996b62e74233fe11cef85b36cd721e20cab30c933cc9f1d3b29ce328ccf0abc0e679562b0f30ca9f87c449580b97325ad0a4a90a00a4820c6d69987208012686e43357d563d3ffdbc7ec0de02edcf93f14f6a3ec99c339470576c2cbf02717c5bc238112b28e1eed0d2644b797efd01a4c9ceb4008958d1a7f780112e7956996b479a7719f01f13f03f12f10708f16e439c70c714f0ae7589e1ee25e1bcff002e9d93e7bc3b9860e72b0f8bc16370b300992674998852172e600a4a9263d3a1c3e9eb7451d46955dac495b29fd8fa3ea4c6d35b599c54b40a28b9512c4002b4318ea97562a20b740d1afe2704b96dac2829cbd0850f18d31721480a2a0ea21d26bd23caafa3a94a4d3562ae2fd56600041ef005cddd8b7ade210e14c52c6803b98cb32d3a4b02e2fa8f7478569f48a52c93415aef78e29d3e5dccdc524ca9405c025c3124d127a810800048a333126194a70a61f314fba13bcc35332588a59ef1ced789980ba980604975751fa4301bf435ab8220005cadc20834636864a92351218bee2c0f8451c56e807e15060920876168012924391514f03588544b0a0a51412df26829e9bd80667f9c5124b70544390492ece18d2d0a4b2c5c24d1fabf4870e2a535b6ec7a4001cb289258806a03de22cd6e025ea09eebb8ad0efebce14800243a54921eb73e70e6a1f592e0b38218bed15b86218a837944bbdec060ea0e58134a5e09b06623772dbc292ec5340436a2ade0243d750500400e589bfd62317058951a80432854c02f649762d4b42a40d445a87ed1634eb04d581b7c5472ff00289c5803503b5050bdf768605e801ea5e80ed0800075ddcd03d6d78b76704d09701c53cfee88f2040084b850201a0245de09b87093a833580bc21524129650492e5201d8c101add28c6b0d81091dd66a53bb73ebf385b1fb24287780358b19be21422837dbd7ce03ff00d6042992c1e8f5895e605aa5029577d3bc2b9513b6dde3687fe2587a0ef29cfe10c4925c27604866f2312f190211dd03ad35030033e905eacaad3a3413550d0e2ae6b10d68295befe7154ba0001b58055cfe70087766d46cd40621352091e46e6207ef38761424378344a6f74017210cc1aa373e661c04809ade83a2bee889bba80b500abf84000b0ddc394b38f088ca607eaa4d41fb46fea90aa142e6af404d5bac414049058172002f0ce1aeaf898802dfd443c97502170f51a80f889ac424b8034f7ae0d0c4201621c31bd4d3c622989a3bdc92491714305b801068cec2eecf058baa956fb469f741b55bc8125cc47ab8293f69de8290b36ecc13ba2b4722b67800d01229d0d09bc1201ab02c2c09bf58520916b8d3e50f204241600b38d8d5bd7e101880e4055586db8820690c41622ec4ed0cd62016b69b93582f1408198b692772c5c44624b6c29a41a6cef1134045924f79bca0807725d99200a8142f07cbd0019964b06b004d4d62355400249724d0b79431ab3127bb57ddcd612cccf50cce5b7bc1ec00da929076a004bd6f074921fba1a86ac7d78c36c00605aa45cda0394b820b0f1248da184ee0acb174bd5ddbec9f181d68c49a86ee9f18b1208d576297ea6a62317f8dc8a0dcc16f6010012904ece49d84162351fb00b0d54557ac43400bbd1cdd80857d49a00ceee60b7b00a92daaac08a04ede503484824124814e86d0e433b3106a1fe2fa4233829a97f077b5bc22729a04249040041352490ca88d54b694d2a017dbd5225753d74e91717ac13a8bb39a3a98d7e4616dac01a0d583927bac5c1113a9046a6673d60862a0ee05925cd60934a006b5dc9fe51095d640b5ee8716daa550ce0543bb542aef485248240776a1356a41a906a7502e54cef682c2ba040a53109ef58906d578660592c9a872f42ec3d7ca02689d45e8004deb5f5f4862410183123a9a4595ec056048490075d37817bb31a036eb04b9219fe272eee617c407d88622958872f9813748ae96d4e284b43240dc31152ad8d60242a81c824d28e4522026ba48357a96a75f3f2e9116b80b866ab814e900104966eed496a1f3884b5cb950a06601bd18293461f09151b9b7f2898e18081b060087f055617ba96ea43dddba440497d4f52c1b6ac172e5d8921b4d8dbf282b6c05d4e4d6a458c5800d258876ef6c535fba17c480a2dbd0b7e70c0924240622bb930df00548ee81dd1bb0153f3829bb1653df56d1095295b0a696144a6012b48620b124003c223a610090f6615d44bb81e308a65aba17ab1ee9f010d577723bb6ebd2147792ca1a456a90d68b580cc08624961462dd69e701208ffac491400d3c602750bd3c5cd4344d2a7762523e205c9da0acde40ee1c3925a805dbd7e5084aece0b12007748d888760cc4daa40a9fe500bd6ecce407603ce22f7400096215a439624f5112ad4ad6a074816013a684bb57bb0546c4822d77afaf0887d18200c4eaa240b6a6b0115ea1a8bb924b39a010c439003396142c0bf5309470c2e5c9bb97107e3d016a5c1ee90c2a49f8b7f5f382681c31a53f8830bc062e4b780293677f5f382e0004135bba4d295887e208c18289043b568620d0454b916a5043332aa4274a68eb676ea7a9851417a28396abf84593b59b0585b4abbc10c19c7afc220d2752594a04d43e937b984028c4a980a067f5b441a94cab9b13565741e713d6cd01dc06e87ed12e6d12dab48abda845456b002bbaa15a9a0674f5fafe911c8400356937a576887256c01753125cb2bbac36782c0d007dbba58a84472d6b166671eaf10d5c25fc039eed2d1376c100012fa983d12ff008c30ee9550106c1d9fc07ada1420f72858b82c1c1864d4a855dcde8d12b7f303123525f5b82c504b91e307ba4ba6a948a922c62a4bfc492d4aa89a9f97e7e116eaa105989aa41f89bf38d23e04af20dc01a520780751f9c5881a4d02a8a752435074eb158715f060c491170fb24803554d686acf1bc7757365648cc412ce43ec920302f19d228c5e8ee5ea7c0469a8616512a0183a8b8f548d430ea72144bd34f41ebf58f434eeef05e36cdcec7f66f489bcf5e4a4a0a2d3399f92bbd7ff000d971a6f6b09425f690e7b4b4d34f353384806c1b12a8d4bb33052b9fdc91734ff0014b25648040ff9ea2317b5b3ff00c25f9f80d3fe55f3a0d6ff00c297fa47daeab1d98827f8e7ff006d1d6f343e55f51d5b9a0021f6348c255da828ec6c6f19f3c071e05836d180b350007adeb58fcdb57eb33cd9ef7298904d6b4e91238ca13635b55bac588037a74eb15b559c79dc43a1b7b8b753168fac895b9a9e1becd77b350476c3b1d103b51f20890491cd0cb1e9765ae3a9b8624101d92039e91daeec76a29ed3bc8758ef69e66e5aa15ff5ccac7df7635db8e68edbf7d4ff004e27a9c3ed1d6527f951fd2460f6962fda179e340e39af9e3821ff00f0f9f1d789e5cd4b90e001503f2f5e51d81ed28bd5da179e2ca21f9af9e39171fedf3da3afd88d3501989f8be96fce37ed53e6e35ab6ff001b53f4d8d5e35152ff0019fd6612c029528b1366704a768c5556c5c80e4b31ac652d9880cc07c4771188a55353246c43388f8dabeb791c56b1584fc6e1f7f05440014a484ea51a6ddd3007c468faae4d8431002589b901d3b7578e792b94926c50e0b3ea480f52082613e1b28102b5a1feb0e52c5bbd42e09367ebfac21412c482426f4a3edf38e6774fccc861a89235369f840ab97fd1fe90a5552c0056a73a94ef580cc0b5ddd89dbc28f78243824972a1a439a8f0689e982370ea24a98bbd6a0690fb45445c905447c4c4398b581410349504bb5c08a92c14e1a85d855e212beec919d4c823e02aa8240483e5068c4339b0205bafe710a03800d4d5ba414ea05008484d8d6b68257029090a7e868e1c36ff00791175082583960ef76b4290092e430a324b2abf2820be9d448d24820d41f54898e1e01080038a020b00c0d9af11212c687575b977d86f101494a884b8029ab72d09a554248aec0d45455bd5e3a22d35b178b56b32f00901c92cda76119b2c82529ddd8b0a5ad1852dc91af63a40f37a08ccc3af412e00b9d24f78b758eca0acd1a476350932fbc454824f46bde377f0963f1990e7b95677802a463b25cca4671815a55a5489b859a99f28a4ec42a5a58ecd1b670dde4eaa312da6cdd237260da5ccc3cc6dc2540134adff0018fa4d0e9a152d29ac1ba8a6b27b67f679e3091cdcecefc84e6be07188c54be3fe4f70e7160c5c9c427132e74cc6655859b3889a28aff30adcf58fc3ff006d8fb08b81fda19c319df3ef90f96643c1bdb2720ca7dea96bf7793e43cfa938495a64e579b4f6089798684265617309b4712e5ce57bb6523b1ffb3ddcef3ce9f640f644c7e24ca979972f329cdf92f99c844d132683c2d9b62f2cc3ae66e15330f2f0d358ed301de3f6704f9b29731832541d3befb78feb1e76975dade09c45d4d2357849ab3578ca37da4bac5afb534d26b184e70cc774788d736b945c69cace2ee22e05e60f0ae79c1bc63c2b9acec9388f86788f2f5e599d6478bc3aca26e1f1125554ad252416706841208278331182282a0a0e03801abe5e1e7e11eac7eda3f625f2e7da41c0999736b94d86ca7813b5ef096526664f9c2a4270bc3dce1c348416c973e5240289e425b0b980754a580898172d474f996f3b7907cc1e4971df14f2eb995c299c707718f0866b3726e21e1ecf706ac1e659662252885cb98822a0d0a569252a49052482f1fa96b384f0ded570a7c7bb3d0b4a16efa96f2a527d7f2a9cbe0cfe4769268f43915783a94d656ebc3f71d549b24254e523b87577438f9758c15a0851502e925d03723c6376e3b03324cc52026b724d149f08d026e1d490a53851b30fe91f96ebb874e8cacd58e29536af7349524eab3821c87bf410aa608b1ef1a9bb465a90a65100ba458dc1318ea1dd6d20153384de3c69d292dd183493b22bd3a52003e440673e10c4ea2c007176e9b8fe7041720391a41abd3c202ace0b38d2a7f1f18e76acca3ba6450a00e4877d3f8c23316512403404bb561da89d2c08a2403530ae527ba2d67da33927d0823b39d4e1aed53e1fce016ba5f7556a45444a302eec695ac377410414977245c8ac51bce40bd410fdebd09310916a390fd4103611090fa8825254cc0b14f4fca198692ec4b7c20334459b7920ad925fe6430600880da8026a2c400014fcbc61c867492c91505be2de253ba002f671f382b7c84880b1014c0bb061422028b934058b311f15619d25ed4156173f4822801d2e5d883bf9c1d9600894904d28cecd449b45a2c410003451672283e714974f7aa4d9c5a1dd94188d3b84d08b7a68610228ba5cd4b317001a7afc2212401a450d07df109ab029049dfa794461b900b74716ebead0eb859012e528dd428d466eb0c0a4ac866005410181f5f8c2305062e4fdad89f2f5b4167292c6b4d2ced5846d7b3030dc91a9ab52011e9e202f52e4ff00138a0f088a604a092c91a4834f5e107bda46c0d052b0eb8d80aa0a26fa86c5b49061522c4804db625fc44136dc16ef31702200013a416b11100521208eebb9a9018111362a04872da49710407d3ab4b588677e902fa8a58ec0748616c009d4f562dbd88630fb9aded410a6c2acc5aadd43fe30c583904d4b00222c00280d1c93f10204170594c01229467f182a1b384b17287036da1580059c35127f389576ac08fa40291b0529d9bd7eb0a0b96347dbf0862d405e82cd6310949533007672c20f0089480c4976ab9af5881cec0397761d2204b2dc0601811bf98fbe0b824d6e6ed5da1ba006ad083a8d585bc4416b5450970cefeab08a002897533d120c109372686a1abf2f5d225a92570465757a3820369a431f324017a078848bb0bb36f12fdd00970480e1837a7884ad90290ddefb240bede378b3bc1cecee9219f68a4ba12c6a0905cfd62d4f79d3a69b2ba520ae8105c5b7228ed5854867068093763b3c1007da26db071788026a090033a776fd61672dc10b01dd02a5daefe30091f09ab9a0b84c31629490050329cde0060686a68c683c62360460127ec822a7af51eba406d42a031a8d9bce0b97b829d3d615d25cb86f0da2cadb0251c07d26e46977f3fa41248006a65153d981ea61527a90c14d46061a8927556b47bf9c31b2033d08eed0d6829fce21510f5f8a8035202cf74001985544dcb40510a67ab5696104fa8228e96abd58d1dfca05406482cc00a8a8f388a63dd0f7074bb88701d44512e2a01a5a913d0082c5c1f2b35af0c1881b926a1abeaf08b01c312458107c8c124b298ffd97622231b021a39d60b55c878035124d13470455c4103ba18355ea1de9bc1615f8852848788be2c02972904ddaae3ef689dd0970432aee6a290894da85c1ab97d558249d4a00508b8da1956606706a09228e598fafd2251c07706cdb9ac12a604bd1201adcd478402a70e08ad92aafd21ca053a811425ba162296886a0ee42aac19ab05228c4248517b39b7485a8720a6b70cf489b3408194c4dddc06b375820000bd402e140540f4f007c40a9c148703abed0e4d9c1248a916835902bf74b248720b3b11002a85566da911490eeec3ff76bed10a48097a9e86b116b6cc0c1f4d5dc78338dcc331a9614353b87850140900eaa39dc9def048a02039bb35fc4983c80b568e3486a30a440054b97723a53785029626bdeebf844daa1ba806253e8024306a953834fb3019d83101ec69a61a800b83f65af0aa014ec680bb115541f8015cbab4872d7e83d7e50d770ec427bd583420b80c76da9f9c4eeec41f9f486cc05a8924548bd9c56e7d5e0295a554761bedf4872c08d25810c450817b42020b2417a0749da18566015a966eef5704bef048b03b31236783dd770e0eab6c222b4b0218f79c9b10f12f64c1594d0b10351703a5a22451540492d514ab436815bd6a0034b5a1850862e00f85fbca37788f940120529e66e0de18125409531bf5e8d01356b392f5ab5e0e9ef121c51cbd1a9d622f900ab002c092ec0d41860cc12c9034d01da23252ca50a82ce2e2b00f7828b80cc5a9e2d485fa815269560cee4062ab37943a4074a03201ab934fac210010c52a0cc02ad0e0e8292eee09001d22f13ed0324a59203b82cf601bf2b42921decc6a1ee608090439d449ee905cd2ff280a012145c1201d21d8885bc48f601d83006a5c101c7f3863a4692e3bd2ec2fe500970826fd126ed040d4cf41a4a934622252ce49024283b1deac3494f9c17075b10e430a016e90145c32aa09aa8860af2f085d246b20d1d880452262d240b883474b336a000247944292081dd2c0815701fc22746f86f5b98723bacce1bbd4eed6d68ba7956256e80014a5dc6af10febca1816014eda4fc5b110ae0fc20b0fe3208dad1650d14ca0689219ebb46eb6358d8b50a767602841223539013a922d41b774d7f18d3d046915736b5a3509015adb605ded5e91e8699d9a2f1dcec8f667ff2f9ff00c907218734b26d20063ff3c977de307b5bab5f695e7da817ff00957ce6bffd14b119dd9b10073ef928a621479a193173d06310634fed5a41ed1dcf822a15cd6cebbc6a43e29663ecf52fff00a6a31bff004aff00eda3aef6d3f2af1fd475827820eec4f4bc60adcb93b9b35e3509c49200b03578c098416b3f847e75aadd9e7d4e855e8c489d29fce24711984302093bf9c322a412eef5a5214333d0d59a2c9646a21a847d2263ba0b7c99f8605e80972dd23b55d9069da63918521c8e63e00b7563363aab870f436b3585bd563b5dd8e11afb4f72293b2b98d812e7c04e31f77d8fbbe37a251fc6d3fd389e9e82def9a5f9d1fad1a3f68e07fe101cef51b0e69e765c54d71f38c700cf4d4973a417208249263b03da5084f680e78a52094ff8a99e3022a7fdbe708ebfcd048218390e9b30f9474f69ecb8c6ad2dfbda9fa6cbeaff009c544be33facc051d4540b9a32401620ef152dd830484ee52e6ffce32ca484971dd21942cc7ca3116294e8c059bce3e42aa5ccd9c25550e1241502e03381e70121f51a923ecf487ef16000059d440754004829ab0d88a3c73cb187b146f0c53abba68fa1dc0a0ab547ca02aa77000ab86048b7ca193a050920a9ca587c702a181214e5d03ec8f38e77b99312aa29d41cbfd9dbcfc6028e90496248a38a066ab433292c477483b1fa98943a5929729ee816177315b26ac813ba09533518b164f56f28a892a24e80cecd6885d921d86e08e9e10c0392a3a74bd3f88da23184c0c12a5848a060c0000115f5780ec9ad93d2e68c6024025d2412ece03015825249709433901245a8408969a5800d4a2ef766ea4f488ea20243172e353b83585eaa7029de55fa561d29142e0b87000706f73131f16009be91a82427500a2e6d0546e0392ecef43e0ff9c58f5f880504d54038148af4b1511a891de259b4c6f05e25e297c22f426814a7d4536e977a464cbd20a2859bbd7f9b4634a2fa42b74b3fd5ab19635022ead9c0eed05e3be8abc8d51abc85a5274e92c48012cfe40b46e6c1a0cc4806aaa301bdd9e36b4a6052a98c9240014d7afaf28ddf93879f2c1355100936378fb2e0b053ab1874c1d34f2d5cf43cfd8ede6ae133eeca9dae3911899b3a6e67cbae7b653cd4c022692a9787c071664187c0fbb942c90319c37982c81bce2778fb069d86549297d3dd2ea490e0bc79edfec88f3465f08f6dae6ff2b31d991c36039c3c819cb9196998512f31cc786335918dc32b4d8ad185cd73063703547a1562e6152e6b801414c1c51dda31edaf08abc33b40e9fc0a90a7523ec92e576ff8a3233942d51c7e5f9cd2d04ca98e92400ad48de8d6fbe3f113db25ec60e5b7b4938026731380f039470576aee0bc9e649e1ae2e12d382cb799783424ad191f1010195a54ff00bae308f79214b292552d4523f6de627fcd0a2ca664124f71f68d6b0ca28d00ab5023bdfc269b88e4e03c7f8a765f8a52e2fc267cb5a18b35784e2edcd4ea45e27092c4a2fc9a6a4935ad39ce9494a9bb35fc7cc78a6f68aece7cc5e41731b8bf95fccfe11ce383b8e382b399b91f11f0fe7584561330caf112eba549374a92a4ae5cc4ba1685a549252418ea766196aa44c5062921ea5dcc7ae4fb5fbd8f1cb1f692f2ff0011c59c3786c8f83bb4e70b648703c17c79889230b82e2b91242972324cf66246a548d44893895052f0e574743a63cbe7b497669e65f677e66718f2ab9afc1d9b705f1cf046753b21e23e1fce70feeb15809f254411aaa8992d6005ca9d2c997350b4ad0a2920c7ed9abe15c0bdd07834fb4fd92a7c9569abea74d7bca849fc28f59d093f527bc5fa13b4ace5db52943534fbea0b2bd68f87dabc19d1a9f2082a24105fbb5fbe34e98900b90ca48a38a08df398e5feed4a70400480e053c236ccfc301dd00bf46a75afdf1f87712e1b52854714b08f2e70b1a37bb0458b11ddd9a02803f1390281e8f4bf9c65ad1501d923761a4fafca285a0b16d2c2a15bc7cfd4a2e2ec64e37282412080c0170eefb5bd6f1084821c12c1cb8202a1945c82ad2ccf40fe7084d03369351a85478ff28e4947064e2d6e121c92016b80c7d6d118bd3cc962c2192000c5c8219954108aa3f785038a3a8d452326afb10020b8a8538705361588c59c820ec6b5a4100d9d9baef5bd622430a92ec4826e3c628d595d8f602a0397049a822a2b00ee59c3820da8f6fc219552ec7a006f5a5fe70020962199d988bd58fe5154afb000773fc245285dfa883524b8a8b79bc35dc5c80dd41eb0a402967615a91debc5b6578b0062ca7a1174b40a9dca76243b93b43000964804915a3937820382e052aa7f97f3ac459adc0803352a4bbb1a56085802cfaba1b6f6e9169f88001d8324d87df1590082451c5cb54ed11b3f202d49568a25c55aa7a4339528856a7259c1d3bfd214f753516e943d60b8a824ba83a6ccef12b1d405c871b83451b1dabeb6829240a8770527c2b014961a49a8a922c989a14c082185286aafe5119406487a0a07f9456e5d54a82c68c034124d436d4a369dde00a8512c5807f18b5ddb0023762e96724061e711833d80371fa41767604248a86706159c58252433341df6011ae86e054102b7bc33359c0a51e86212a48d2080f4481521ef10b335d246a21558afb40c0800b862f5246a2f08cd777d5dd62ff588f42c59c31f1e90480750040360450830bab012c0921cbbd3707a56152545ce9a12e0dc43b38ad490ecccfe7fa40a06218382c0061129db70472cc5dc1bee2225ca4357554d0b8a414a424316248ef15508aed12d54a9e8e2c400de841a56b820041a391f6893f578672c469dddecfe515a4b3ea2e454d1de0d094bea61b8141d20f008010033b7da706bf3e906af44a88b10284c0d41b7d23eb68201247794c46924905e2bb3b80a4d9c1356d2aa8113e20ee68e6a59e145887729a6a35f5e7009f84d438fe1a1da270061b30a5aefbc4d574a85fed10e44029ef5c0015e69f55fba01a9035001f70c930cac201ab3380e7ad85a2176a823ed03f3da0b8500e90e4d69f14307a92181a2426a078c4a4b17021722a29f6410ccdd60907490c06e5a80f58621455de4a5448b8ad7c368424a41046ecc46de110f39000a2350e8689d3f586296722c3f883e982410a7a543ea663e5040f2d291de82b5aec0aa4d43391b13430ba966a19851b600353f08750d24f78bec96f87ca2000dec0ed41f311676605627c9ee492de10d57274905ab7ad2860102a030a96a56012137362c7a8a442ce5802924849b02a6676503d2031074a403e75eaf0eaeed5c335c8a9e90ac92774d2fb9789df70300480545c3e9a6d0c1d3d54e34877506a5e2b660ad8d830a9e9f3b411a8292417b52978258b3042ef67ab1077e9118b10c58fd97657d620653f7ac6ede6ed0c6a1800f773f081e9a0ddb310282477482e0bbefd5a01b3a85ba58c312d5a26a01028f013bd12c0bbbf9c424ba0192e5d810e2a051a9b4022c4331a006febf5873df00fc24593b3358f584b1ab12e5c1a84c5acf001507bb66a8b88243b80e46e1eaf48013a6a0bebf10496bc3121a8c18b16aa8446d80015a121f6043bc4dddc92ccc5da23b10082751f24def0c6a77722a181d310eef0052ad9405bc440d4e9ba8bd08dc748660cda5cb5cdcff002885c12925c86a9b7cbf589db702e96620fc21cb29eaf5178201a1fb26aa70ed58b4003bca4d1490cc012ed7220a8114ef2435086286bd0c2dd015a812ddd50717357dc1f080c4976b5eb73f5866a83de07aeab0d842924b9615aa6c77de16be1304d4435983b6a766fd20243034a1dd5f281a48f106ec6d4e8ef136162ce0f844dad903b86e813404867f3eb095d44822a0122c69d205c302e41f85a848860e4ea512580aa83e9a5045527f040353a882453a8a5fef8777b2ad5b7cef0004ff00150fd900398291472c0be9009f1de167b010a81a38ef166660091d21811a885176b162456d1594ba890c183f47f9438207768e0ea722c682257a38030b8a1209b3339ebe75866228c55abe22fb7a78811dc49746a52a8c0ba7c5e0152ab52a00b1ef3bd2cd0b5980ea0a05490fa6a2954d7aee20ea21cea0183a9833dfd378c2b123524024d9c800bfe50a49d2349aaaaa0a482d48616c00351d4f57ab134021828b58a43b54d7ce2b670c8d2e14ee52daa91620b1049008d80702b109e3206ab9b9068a091a48221944e804876f85b6f9c0a54e95149152cc3e47d6f106a6569a050abdfc6262b02c88a770e90ceee91dd63d4c402e55de73a4801c11b388290c145d9c8d009704ee621706a541eedf091fce215dec2fd4ad89482c5829803577bfaf1872e016606ed05d89a16049a281d3e308140a9c10c2a09a1e9ebce2501eaa049152348a9d2218a480905fa82ec68fb42bd54cea60ce0d3cc7e105c84a40297350555fa45e2deec2dc812a5124927a245cb8f5f58b002024a8dbe107d7d20a34872e0d7539b83482756a621259540050bd8c6f1d8da393250e0243e972ee1201551ea6350925942a748e849ab8f5f38d3a58a873de1400d93e11a8c80411a583176b83ebef8efd3c4d21b9d8eecd3301e7ef24c2dc8ff13727a1761fed6817f568d3bb5530ed19cf520923fc55ce403b0ff6a5faf9467766dd5fe3cf267491abfc4aca165ed4c520fd68634bed3cad5da139e0a04f7b9a79c1737ae2967f38fb3aedff0026e3fdabff00b713a7fa2f97f51d6b9d7258962682c634f597ab7dd511a9cf1de3d0178d3a6062d52770cd48fcf357eb3382a7429fbc448912388cc259d9deb55343a1be7e309f70776bc580826e0015b39895b833f0e5d40d0f5ab931db1ec75344aed39c8c517091cc5c11a9a8eecefe51d4ec3d6ccfd00ac769bb2324cced2bc8e41775731f2f05a8d598f1f79d8eb3e37a2b7e3a97e9c4f4b41fcee97e747f49181da4883da039e2b4b11fe2ae7ac3affb7cfa47014cbeadd9e86a7e51cefda25c73f79d817551e6a67a58d41ffba188fd638167d56a29a076ea478b7ab46bda5b7dd7d535f8ca9fa6cb6a9fdfe6d2f84feb31c90a2e75774d185231940294a3b94f7413551da2c25406949009346ef11e314922a5aa030617e87ca3e4aadef738f72b2e8674d858a9cc40681807154bfd91fa41517487002887725e9d610b94b13441ef25afea9184b6c99c96064518098ad4d5a339e91096205435758a949f11f9c14a9d81721daecde5151213624bb9575a519e39a5be0cc6d4ce14a72455c3456ea705de8025a847aeb1512492026e1c39768700a545c8ef5d5b888bdf007028eee40a021bea617ba540390e1c259dacf0ce28d5adc6ef6fbe155a3e2ef313726af4afdd12f3b6e3cc7a0342497e8df5f0840df68825eaa07bc0fae903bb4517041660ede2f0ea0c19bbf53a541cb18afa3d00a031059c5b4d9fd51e1d21b4ab50662083517a561030354867a13d3f2dbe917240200f858172378d239dc10ab7219212e49235130a4163bd5e86db57ef82406a87501aad434f5f5829085834209a9ab7834744764691b97a19290033a8170ce15d0bc5e0970348ee8b3d4fafca31d0c9480a7483de0542a43fafac5e903ed6e5d219dfd7dd1dd430eccbaf066a78707583f1126a0d40f1f06e91bbb275695a14087058926debf48da72554670092c1832935a57d5e35fcb15a66cb6043062f41e7eba47d9f036a15a127fc6c74535947ef6fb06b9c13393ded3aec93c41fbecac0e0788b982ae5e66f88c40ff2d386cff0388cbd693d0a96b9001ead1eae1899331055ef2ab2b24b8a82ed431e2cbd9c38e715cb4e68f2db9938352ff79e5ff1f649c6f244b5994a59cab32c2e34a42b60a4c95027fd463da4325ce64713f0ef0f711e1552d786cf720c0e79226ca9826ca5a3198595894942850869a188bc7d9fbaa691fdcce09c712f5e35a8b7fd9ca138ff00dd7f31d138e6136b7baf9accad32810b7373de49dbac14296900535397a90e0500fe716cd0028a763bb31fac2070a72ce526f506debc23f1d94af9672b7caee6b1839c10194352541887607c1e3f187dafbec7ce55fb48b9698fe22e1f9593f05f695e16c9a6238138f578308c071309482a959167e5035ab0f348d12f14352f0cb50500a46a4c7ec419aa01949d350425dc1f9fe71aa6066338502c7ba413b35a3d8ece768f8cf6478c52ed0701abc9a88792719c5e254ea45dd4e1358945a69a36a5525092ad4dfa4bf8b3f23c567b49765ee66f67ae62f15f2db99fc219b708717709669372acef24cdb0c64e27073a5a88bfc2b4287791350e85a485249063a7998e5ab92a216929726d78f5d8f6bffb21b963ed19e566333fe1fc165bc23da4f83b2b98780b8f11253230fc4b29092a39067c00ff00370f34b7b9c47fbcc34c6292505693e5ff00da5fb30731fb3df3138bf963ccfe12cd783f8cf83f355e539e6459be195231b819a3bc8245952e625972e6a5d1310a0a49223fa26a706e05ee9fd9eabdabec552eeebd249eaf497bca836edde53eb3a1276e596f07e84f3cb2977ca952d5d275f4eacd6f1be579af14fa1d069d8621c100240a1343ebc234b5a34802e9578b914e91bff33cbd7214a49411a4ee2e7f28daf3f0eb46a5a800450327f08fe7fe2fc267a5aae0e3b5cf26707136f29146482140bb353eb0812439219cdac7e719d390ca21a8475d4de02318a588b2810ec47e263e5aad2b3662d14d4000a9b63bb06a57a402e49048274b31a37d3d560aae349ef7da2e1ad03e125c824877368e39412651af006a6a1a17a86703c6055370c4d010753521ca48ab774dc9b12fead08a0c5aa0292c140d6d1934b7450952e4871b125a08ef519b4872412544d621702a0bde9b1bc02c40d4402db5357f28cde3704200068c9219c6f0092407160c58b0f98836150a551be22eedd211200d4438a541a905e22c93c00b977d4d4d208a0a4100127bc5200a825c1f11e10b40c1d81a106f4782cec402a6a80ecf10af80120383dd22ee0903e7009a1a93bba6adebf282e0312684394ee3e7bc2d1800083aa841029e304dac8002eeea3a8a6aaa3ecf4872a4b8245402ca05da0101ec75692362f0101d8292484edaaa3c60b0c0c967a9d34fac021c90189350755223380cc2c966602082186905c16f389c3609504382fd01f8bc5e2300080ad20540ead0694249253704b3eccd04909f00054a8b8f386cc0bdd049a824155450f84404b5582887f0f94453e9d3a9c9a160c3f9522070c6e934650707ca167d7604049774a4bec545cf9c0249e809626b6a5bf9c1a076650142df64404b1142185016d444162c08a2951212e92d701d3115a5c3a8d05004b18248600d09a160d480ec400ecf43a9dab530b3dc0352804026fb9f2860416d4a76a209a11e1f9402d46ab5bf87ebd223025c82ce4dde17b8230705836a02ef1084a4b300a3477ada1164024e9eebd2ac4faa40a924fc3d5c38fafabc56f60585409253b0700dbeb03baa67bbea6346bc0003ea21880d7b4120100ddcfc29a11e2f12df502951d542586cd73eb78650208a9d3671680b0c454e914ff51a07ac36920162412680dafebeb139b58002411b3a7e67fa41551d8a946d50df23000500ea4b9d567af9c42f42a2e2de5f3f9c45dbc300a2be204eee18c0482e4a98803badeadfa43964b16ee8a742ef11c073a5cb51869f22d1366ddc0093a599274d0569f7414848e8f721db788121882fe25fe1f2860c284bb162e18780884050c19c8008601cd621092c0973b106f0aa21dfc5c7faa21d268d505c1ad2271ba23a8e9a862c1ae525c980e3a9b35768212a0e14a1e645619815170f4052ddda7afc62cd3b122bd9d476d234bbc03ab52a80067a2984310120680d5abd59fc3f2806a2ee5d9bac145815c825d8559245c44601c7c400a9b7a10c129d88a801ca45fc20500177b1707bde3165127cd8054101c52ca17aed0ea761a9c029b33fca1425c31248347a88b2e4816f12faba44a8a5d082823bb5eeb58bfe1fca1b4bea0d426aeee7a43329355289662c454407d4edf68b0788e54c0592cc92ea1f12452109530ee8737ef1eec3696606fa6a6c2e6e20a802a04a9944396141eb683866f604a3d6e9a120b810b70f425e80dcc3382ee583d5ea7e504821c33e965383402b0e40470c5992a25fa810124d7490080757d6ef16100824bb9a3bdcf944400164909203856c079fe716e46c15076a7924016bc33177dcb8fe87c208a1000703eca6213a4922f763f23050d90b0ba405036500cf749f9c292000aa00033b31f988b1815060500d59c978851560a0960e1243826254495d409208625d9cb7878fe901407c2e748147153e8c3327e1dcd0ac5c7ca007605c91600807579c459b202142cb241506d576f382495003e20154351a9ba42943170e06efded23d180ea4ea0927f1062791ad80c48626a09a10d4108ccd460ee1dfad9e180174ea2a147fe50ca03bcca22ad5ad5ea60a0ba13b88589242483b0726b0026ae0849ddcd22cd20066d5a4bb3914855333dc15170ee7f943900ae4288a10cc1ef06ac36047520fd36f9c420b85017a8b07f1860c189aea0c3a0a7e11571e89116c80015156bb333406702b7d89a81b79c1255f100581a3d5a21a167a5ad51f2fba2aa16dc1538a1343e7f37fa438001a1672efbfafd6084d35120ec5c548685767a7daebead0b605cb50bfb258005ab4260a99aa0822c126c37af5f38420170e3a80d451ac4f02436ee1c45370293549241243382c4f9887651048b1a17a03785493e1aaa7510d682142ba9c8235248a17377fbfeb12974042683a69a1e9fce227a3901b52aac6f0e0105d209252c415774f842100900860ccc0ba8106a7f185adb84124b1772486734000eb0013524856a3e2761482092e03ab50a034f460534d364d41a11e5f38856c58042ece1c1340ce475f5e10c261502e74066040b834a8fbe2aabd01001a1268d0e90b406569259f49db71f9c4dd75014904bf743519d9fc609a2941c242920d4384f9c2a054b071d7481f468774b0d4090eca00d03c4c6cf200923525c020d1dfe87f9434c3b8536c074f0820077045f48340483f9c466b800a4d9bef116bb4c94ec44f76a588a001ea4f53eb68b0a4800b058f0513a6b5681504b30146e958255de60c010c68c0c6f1ca348ddac1908290183694a5df53bfca35290095a54012086fe13f48d3d0c96725448fe162f7b46a387ef1aa4802c41fa47a3a76f9d1ac5e4ec4767357bae7af27565868e62656a047fe7098d1fb4b2bde73f39d2a967e2e6666ea2763fed0a8d43b3ed39d9ca556c3981961bd9b1098d1bb461d7cf4e721b03cc7cd6c6a3fda0c7d6ea24bf93b15fd6bff00b68e96ed46cbc4ebfe218977203bbb78c69b3141fc3f1eb19f88725b67eb48c09acdd6b43bc7c06abd66d1c153a14d407a8ad0c480f6f0891c4661e97ac5897b123c2b58405a82cee5e1d04becc2d12b70b7350c2beb01c300e5e3b5dd8fe684f69ae462963ba9e646058f4ff7bfac754246d67ea4bbc769bb24050ed25c8d5a6afcc7c016170354cfe71f73d8fc71bd17f6b4bfee44f47449fbe29fe747eb469bda395ff2ff00cec5b38573533d2dbfff001427c75f66cd798a05d45c28edeb68e7eed125f9ebce905c9573433b0777ff006f9d6fba380674a554a45534a339ebebc236ed224b8bea92fc654fd365b52af5a76f17f598f53660012e2c45fd3c5014ec000ca0ce5c1148b55561b04f83dfac52a01292c18d540333ecd1f29570ce47e4280e1c8a3b3bde1540074823582c9637101ca800ca2ca25c5cda8219dcdf5350d07769d7a4734df446727d0846a75b377ae2c7c22b2c6acc80a674bb97dfca1c5284ea03e249dfc20d094f521c93457806f568c9aea6662996bbdeaceef0e9012da99413f08773f2f18b48f8f496d4a6721be70aa09a0248d3de091de27ca2965e2420152a87749dc5c36f0b5f8493d599923c21b6d43ec9a8218c30b1258307f03e422159224af492a74aebb9d9c6d10bb6fa9dc1b13043b0ab776c1aa2ff00480901c3025c5090de3f58956d981c821c82050516aa87221aa59d4e19bcbc211200255a6a010c4fc40c5819c54f7ac34b691e1168ee4a212d43a8382c68ef0cc751d2092c0d3a168acb02493dd22859b4f8b43212428a49d2a3549d40055ac63a22ee5948b10a21d2a36b035219fd7ce32c691a5496483636a8bfd23087da5861463beada3250a0c8772821c021aacd7fce3af4f2b3b3355b9a94a2b2a0e080a2c1eaaf9c6e1cb8a4a92a24774d189af898dbd218d0a8d0be9bd3ce35fc09034b8ee82fd357f2afdf1f61c1e5f7e8be98fd46f499cfbc0b386b4a1659335064abc02869247c8c7af27b2379cd86e7f7b337b1973125cd5cdc72b92796704e7cb9aad53559970c85f0f662e6f5c465b38d6b511e3ffc25883ef2500486500cf7f38f4c4fd962e678e32f67971472ea7e623158de4ff3cb3ac3e1700666a5e03019fcac2e7b274a7f85588c663fe69547ed7db5d12e27ee392d5457a7a4d4d1a9ec8548d4a52f65e72a59f23bea5de9949746be9c7eb3e8ea72082a0e59ba50784621243dfba37afd23529e35288059adb79c69cb9773a9c92d4fc23f9af079f38b4df801095280052a25dea5d558cb9733403a54cccef7faf58c313050695a403a49506262c9751f1351c3b10078c65cd9cec669d99b8f0789d0c9590a4aa8a06a2dbf8c7e347b60bd917cb9f68d72b26e7dc3783c93863b47705e51330fc07c733b0e9c2a38870e9799fd839e4e487998652c93226af51c32d64a484a940fec04b9a13a402002188d40d7c2355c2e28a4a4298a141885070aad8c7b9d98ed3f1dec671ca3da4ece5674b534eebc6338b5694271da709c5b8ca2ee9a7636a356a52a8abd17692fa7c9f933c583b4bf666e63f67ce63f18f2cf9a1c239c70671af04e753b22e24e1dcf306ac366195e2251b2810cb96b494cc953904a26cb5a5695104474bb35c0992b5a196005331bbc7ae2fb637d8ffc01ed1ce5862b8978325645c25da5b84f275a38278c31f2861f01c5f2a5254b46439e4d424ac4959ee48c490a38752c1aa3508f2f0ed13d9bf98bc89e60713f2eb997c219df05f1870966b3727e20e1dcfb0870d986578894a295cb99f6540b0289a8251312a4a92482f1fd1faed0703f750ece54ed8f63e8a857a76f7e6953bca84dff004905bcb4f37ea4b3cafd09be6b397a35634b574bbfa0ad2f851f0fdde0748e6e189053a0d0fd5a30264924e9d2400188b121e37de6597992561b4ffa488db13f0ec0305503aba3f48fe7ee27c265a79b8b47973835b234232b577aac9f8880c4d2914001949b28164bdd20d498d4e64a6a01f11ab9a08c6d1de7fb3624a5f4f8c7cb57a3c8ec616b6e6394d030ba5cbdb7ac545248b8245497a9611944070487052c078bb7d62920009ad0871dd709def1c528b5d0a497545401aba0eab02090dd5a1944d081d12ed5f9442086d4e49a248b010180abbd016fb40d6309a6914033900bb00c0acd2dd6207ad875adeb6884015d2e74b94a6fe14809a172002e0e93f66d1975012024ea601d219c9a3bfa68562902ae2fa5dda1cd555d4286e00542283b8726b53e1e506acecc0a3555cb80598589f1829b300526c48bef0c1b6763b13f9403a85cb30ad6af078c020b390004d8efb5bef8835134a8e89fb3e703510ca24950b307f081dd3b9620d4d05cd3ca095dd9019c96290541ba521812c000455e82e7d3c21141563a43430ad41d446c433c46de8bdc108abb36c2ae49dbf18620eaef801c74a0f16886b7170ec075f1e9114ba060f56755cf9c4fc24ba011855be135adc7aac1002685981701ea5ecd137ad9dc03052904ea3a4306625cb787ade166dd9801481a803a8292e34daf6883553bb4218823bc1a1d2ce28412a705fa44a12aef11d4506c7d7ca254578813413567ae9ad000f1128214529fbedbd443d8b062e2809ee986b328d752748295388593dc0841d20392373b067fba10a6a4b8e8536786daea77720860610b97d2d4f163e711ed016a8043903e508c52748a38a1151e70c520d6ac90c0817801b48512a26a05038f38858c027792e529249a07a80fb886637651b02db446726aee6e0b44a3072433822daaed13601280e542aa7d5aaff58506e5dc9bb589f086ab8ef79b37df006aa90d4ef0ef78b185d2d80080c03805f7a11d22690972976d2cdb3f8c42c48005ee763ebf38875076008b81b8f5f94475c91b113e1a4d7c5fd5a0f78020e929b8f03112a01800c46e36ad5a2114b580662c1a277dc6405d20339528d8bd4413dd2e43b9a87785b2ac5cd5c166f943e90c4d35055482cfe1e704af924ac0292aa3b00d470886f7668c15fead3bf84369ee9651206e43130522d5218d059e2d18f884820283f70122d5a8022310a16addea43c1497a24b0df50ab8780121442b4903748fb5e51b28b65945bc0a1275316d35f8a80c3a75153b802d5bf8345c94e9028082e014f7b406e87683a6c42828a8d8a6ede1e31a774ddae4f2f46545203ecc5c78978aca4b12544a887626b58c9d2e4dd25a80d34c26862400f4b359bf2fd627ba6b64395f42a6d44155181f2801d2fb83623e11d22f12d7de240651621ea3c5a1bdd904d5dc35778b2a325b22547250a4929014c592c2ef0007aa8862180146ada2ed053a86962433de2c28500904245002017fbe2ca949851c18f70124ea60c695bd2114c0849b00c12cdb758c8285384924f560ecf13dd15294028bb382038f5d5e255196c145142439a0a8a97b7af18701c2ac09aa9cc5a25b06702bf5f3874cb14773fc258308954664b8f818ca4543028a035b0f1f5d21825c692c00a027ee8c829d556246e1bba079431401a88001d542aa9bc4aa12b5c38e2c62843693de3a5acfa47ca2140a80c9dd8d1ad78c9d0a620b94fc47a989eec900310c1c16706d68770de6c472f5b189a09abd0aae0b127ce0901f49b3382d5f9465e9213d12ec01abd61022ada351b852adfd7f58772efb6494af928d25811a69e05bc6b104b0ed560589fbff3bc5fee87783bb7d97b7941f76fa428b6d4353d61dc4ba84bc8c309d2c3493d0540221c80198692d561190a95556da4b927c3a7e5104b651ab1352e3bc61dccba916dae8c701805283b589a29bc60b11a7ba03d49173d2324a0299aa0d19a8207ba0c3bba4ee09f1de1dc31679b231f49529c24960ee6bf33e10a5252e494fd2b194121d418a98ddd818825855e9a5cd0392d0ee76b96e5b60c509772a634b3b2bc21c829a33b870a3b78b7e51901058922e402d43bc42864d4298eeeeff288ee5add11cbe662a9330a5cb692751268ed607eb0a03925e96319265121dc38d8968429342920166d2d50d19f76d60af2d8a5452c4becefb37568529d40a52e2971bff28bd28d4e541254ab105882d7683a52e5c1d228a55ef14eeed9b12e3b14b5402477520002214b860c033ab497a7f28b3491d185dc3a88f5582429212b00822a90d7a6f19ba7d4ab4d6198e41d813b25c5487f1da0924d4b8715a333587e31728024126ada9def58aca412e6a09a84d1bf95a28e0d221ab101162b70920900312057f380d673520b9a917ac369b904512cf4f46f0c7430606d4d942b571b451bb60815208a6a605b53171e3f8404ee1b50009040f5e116115660036956e4f8fe10ae5d2002c0b1501427c7c04474dc8ea22412540849253500dbc07e70cc0509295b7dbdedf7c134f892082f6de21209f85c10da80b7589ddab6c48a68180a5dd468209d3a8857bb760e5efe5f74313dd71a7bb42951a91d614ec5dc1ef0200d403f4859b03b3a88d2901dd98b08626a43a94c58125c5bac28208240702c007543a4853ab4b241b15391f28b2b3032830090edf137da3e27d6d0c0024124ea6ab5cf94292e4778a49bb51bc20cb028e188241d898de3b23582562f944100549be925c7af28d530e0b85ea673400693e3f83469a860ad2ce908f880f0f5f58d56469294848215bd5e9e31dfa7766ae8d61b9cf5d9fc3f3af94a12484ab981958009ab7ef098d27b47c93279f1ce3960927fc47cd4106bff004e4fe71acf67b6573bb944a501a473072c601a87f7817f18d3bb4b2c1e7df3a75f77fe52b350480e693c88fabaedbecfc63fd6bfd089bc9aeeade675cf12975a402401d691833856e482c295119f38b1373537487feb1a74c2433917702f1f07aadd9c33e8525a8c3ef778913c9be71238ca03d79c58921d98bb79342313607f18741db4d0d1ded131dd12b7350908d2a1de0e53d5da3b57d90f4a7b49f24144fc3cc1c1a98d0064ce3f94754f0e4a54ec4101af6f08ed1f6475157690e4b001ff00e3de188043d44b9f1f6dd9276e35a37fd6d3fd389e868ff9d534fe347eb469bda35213cf7e74006bfe28675e207fb74e3ebca3826691a17fc62a41dedf28e79ed0caf79cf4e72ac160ae66674a551fff000d9d1c0f38e90df12454b8a9b36f1d3da3b2e2faa4bf193fd365b54ad5e6bcdfd669d340709605aae0b28924bff48c7536abea7fe215f5e319139ea3bccc0a43543c6285149d56a30533fdd1f2553d667188cfa8598b026d0cc6efde07bc91f17a3114594e5ca54c351bc41f689012a240487ad3c239e56b946a3b818ea74b252d623bc3cfeff28504ea019455b92f0ea21d45ea00512437cfca15d243a9f4bfc9519369e0cc00020fc608a80003a8f9fe5128a002a845c81f0c44d5c06001a0ad602cac3b17a5183856f1576495c1144d1c87703c29d209f89ce921b70cdf38501d246920fc573f7c0249552a4160361136603a5cd935ab9bb7510e90529d4ce48245695eb042520820392eed4f93c2f7983298804a40a8b455269d811c2ace960ce4d5ff002a4109601d9f60439dde204820075241b91514f182c410c3e1146aaae62d1bf50464953a82accb0ee3e5048a9243a526837559878415ba815aaa407501714e90c961700ea0e0b9f08de05a2ecc1452812069018804f8d62f4b1200040092122fa69d7eb18eb2c5252587f0ee0d6be71912564b299d5f648afd23ae935748d5596c6a7873de4903bc032d5d3d5635ac229bbcefa4bb01e71a1cb50d542125ea1dc3c6a786590b0453551af1f4fc32a724d27e28de0ce50e1cc42e5ce46921d4ad5535f178fb9dfd914e73af07cc1ed45c90c4e2240fef4f04e4dcc2cb652e6113e7cecaf153f0188f769b30958c964f908f84ec926844f94ee281d8dbfac7d3cfeccdf35e5f2efda7fc9aca27cd5a70bcd8e17e21e5a29085320ce9f972b32c3950b51596a80177547f45f67a92e39d81e3fc15e5cb4956a25f95417be23f4d247a14d39e9aa53f27f464f4c3c54ad2a5076ea40ada34d290949246a24efb46b58c50592b487d4494a4023ac6873286b4254e082df28fe524ef491e7cde79988525824778953b28d3e5114a6614d5f6ba440b0904a9cac17720d7d7e908540b977511abbd624c61293463718282aba3e13d3513e3172671480c436f77118a16c2809d45d54a261545c024ea62e3661d1a2d1926d264a6d3b9b8b098b70eb1a93f094ac5163c63f123db2bec72e5ff00b44f9658ee3ce5fe1b2de15ed3dc19942d7c27c40a928919673130f29255fddfcf140380a0ff00bb6303aa44c090ad52d4a03f66e54c28012c6ed4bbc6bd81c7e83a16094a8685a49a286efeba47d0f667b51c6fb19c728f68bb395b92bd3dd5af19c1fad4ea4769c26b128bc35b59a4d7453ad529d455a8bb497d3e4fc8f14aed03d9f78e7927cc1e2ae5e730b85f35e14e2ce14cd66e4d9e6459ce15585cc32dc44a2ca96b491e44283a54920824111d51c7e5ca92a524a4800d4b5047ac5fb69bd8c1c03ed0de03c4f35795d97657c2dda9384325548c9f3b9684e0f2fe6860e4a4ae5e499d30633905ff0075c69efcb2b285154b5327cc379ebc95e32e50f1d715700f1c70d66bc2fc59c259e62787f88f20ceb04bc166793e330d3152e761e7ca5074a9240f02082090413fd13c4b49c03dd13b392ed9763e9f24e38d569af7969ea4baaeb2a3369ba73ff825692cf7ce34b554fbfd3acaf59783fb3ccea0cf90a486fb4280e97241f5f7c612a50009014082cc45bc637ae3f2e98851201ee9b1168db93642d048539249adcc7e0bc4b85d4a137cc8f2e5169dcd0952c51dc1142c5855e9188b4ea00b394967368d56720a7bd64dd88fac612d3755503ed02493e0fd63e52ad1e532b5998c5880ce542db86f558a8b870410aba69f5f38b88d25aa0a8ece0dec210851f2360c7bbf28e19c1a6524b648ad3727a8774dde18307245f7b91b40014e120d1b538bc135347075351dcf888c1c599bc11869bb149dcd3c2149a1d24924b56d04d4ee40ab90c3e90b425c24006b766e914d9dc01c03a4935200003b43970144807506bda1405bb8eeb1b9debf9c105cb97009b0788c360818dd9219c8d89e9034f502962ce036f07c41673f0b57d79446a33b826b43f7b44e2d7029ee80cccd424ba77f0864b12544d08a101e255b4a86d4ff004f8c40eda41203f7a8d53bc4636ea062a252c2d7703bc7d7e71283e200001c002a29bc02a2ce2ac3bcc1bd7f280e5c2812411471550e8f0040074058f5fce013d18927a380f6824f74102b52abb420003d1d40b024756fa988b8436a0c13563b0b830e1c31000d5dd23ef730a07cb4970054fd21b55cee6e77a8bfaeb16e971b84000005c1671f85622883a43171b03b407200dc0b81b40b386243bd052f109d81124397f30fe9a2060e5235521439d8b90d6a1fbe09765072d709b342ed2b300764d5d9d8880c29ab504b3a45c185d408005c1bf58b010749d0580753067f941e5dd0175506c75500a9bed04310429dc974977112e3715b35079c2e9aa6a01172efd5ab11801b5c24004800dbe704100ff08b299ede9a1544f7436a0cef5636fba095355458b3900381d1e0ddf202cced57e94bc254b8059ac5aa4c312182493a55f22f5b431aeecc1ddafe50b3e8054d402c0105985098600a4331a96bd3afe5050ee49154877fd622b502e1d2e01a55a9168c5ee804170cd520bbd3a4409234be93572c19a231d259c8f26503052285d2c7e23bbc6895ec80cc09058302e481defac4605443b81de1d3ce1be2a24690d4043ed0e94920eb5024002a36f1fba36842fba2f18aea56cdd1476dc18b10834a2492ccee34c5c8496274ea0f423c694f08cc44851ab3a99cd2f1df474cdac9a259313430a8622cc1dcf8c14cb3550a9ffabf08f031aacbc21982808d25ab19a8c1282288517fb403e9f28f4e970ba952ce28b2a7cdd0d08492752542b6d44394c4f70b008b9d3dd366f946e01815580d2fde762f7b437f67cc24167558306f9c74c384d64b112dc8ee6dcf70402e1c9152f58b04962960a248a85971f2a46bc32e5a5e840d5702a22f18058b2490a0c14d6dabeb68eb8704abbf2b255395ed636eab0f4734a11416f97aa40f720534b901c17a46e7196cc06a2a0b31de2c3962947bc860cf5de2eb8256b59402a6cda630e565c02757c4d160c338094800b6f4269ea91b8bfb3d49b034350283d521ce5ef6049fb4aa8682e0b55ab7264854d9b6861c12c0004d483b97dbd6d162708189d27500282c2f1b91397a82b530a877218d0ec3c61ff70580921352ddda8ebfac6d0e07379712ea99b6bdc29214ccd72045670c4d59b5750081ebf28dd4300a2e0a4dd80b0db6fce11596ac904820034d9bc20f8255f8a1d3f036b092401a8306624f788863219240014a06dbc6e5197288d405455b4bb5e115815a4eb292ea152ccd67110f81d64af61ddf466da5c80a49ee84948d64d85e1861ec0a4bb3debd63737f67acba74d14962e3c613f70215a8a097a6ede710b82d5c7a3b91ddbdd6c6dd1877d250920e92920dbeb04ca015de00b1ae9a111b88e096a20247c22aa02ad158c12b510524ac9605980f5e10fb8d5561c7e80e9f4343187abe94d811aacdd3f08270c4bab40e9e1e2d4da370fee0a2163dda89fb45ade5160c128e91a54a218333fce23ee3566f311dd49aba46d9fddd9ad766d9fac4386506012147a93dd1e3fca3749cbc824b50aab46853829840ee00013a6ee3cfaf8c4be095961c4776f648da8a9043100104b17a1b5207eee1cab4e91604efe71b895812010504ac543bd3f940fdc6612ec4274b91778cfee3d5f884aa4d9b78ca1609045dae4fe90a6402084ea01e8e696b53ac6be7004b10921ba0a9afe315a706a50206a5125d44269e3f9c652e1553e291dde523433205004167650059a2b549a3000106a9143f38dc430332e125bc411151c14d2486649f0a88ce5c2aa5bd52bc8dec6df326ecce2accc2225170c1f7601f6f5f38d695849a0324325bbc46f48a3f7550245833fc2c368e29f0c9a76e52ae2fa234632eb7043d7aef056974d02883dd487240a56357fdd89d24a4058140dde22b08708ad4967d241351e11cb5387548ad88706d5d9a2a901aa9601547046f68ad893a08353e5b7afac6ba70aa0922ec5c50b5ded180a945ca8bdda9617f4f1c5534b386e88716de51a7e90a724300920330f2864b06331d9aa695f548bd52ee4023bb601c136a454a77dc81420d92238a70b2c194966c8049a150242aa40bd3ac2875b1166b0a9a402d52429f4f758f85212e751707550df5473db2542e49d8e93a681beb16778240d22942c686aefeba4569a1510092d570c078b7a3075101c3b03f0aa83ce0b2fc81677545d869360685bd6d01bbc157fb3a4a6b4ad0fabc00a5060e520d15b57a3c22430512e0548bc23b601628d1892970c08dba4305060927e1b286f0a0692c010c2a43b18893525892d4046fe3168b4ddc22dd414c28fa6c28de5f5874a4ea497ba98ede515a4382482402d4a016a46526a52c9ee93dd4d4fca3a22ecd2358be83870a240480180704a7cfe719d214524ba4d135ab00090f18416c7bf57a80cc124ed1952d443ea73abbae46d4a475d176b24689db28ec2f6781ab9d5ca201203f30b2b4b0ff00ce47af9c60f699484f3f79d09041d1ccccd9cdaf3ced197d9d5611cefe50abf879899593571ff391fac607696505f3fb9d64167e66e6e0245750188508fa9af34b81c175ef3f611b49de9d99d75c490146eefbd85a34e98c37726f4bc6a33c104a1c924bf58d3174715bd4edbc7c36a5de471cde6c20d3bbfca244e848a7d1e2472345029a58b13401af05370ec03f4b7a68034ea2f616820bd092e4ec6263eb0c99d283107ad0015f5fce3b3bd92b527b477254a5fbdcc1c0a282a1fde83f898eb24b20970e403d69e31d9cec993512bb46f2516b64847303066ec3e19c07ded1f67d969b8f19d23feb69fe9c4f4345fcea937f1a3f5a34ee7eacff008d9ce204b3732b3ab8ad31d3adeb78e0b9eb724a94c19830ee88e6fe7eac4de777379480485f33739512f41fedd3a383e7965104d19dac3d0fce3afb44d4b8b6a5ff00593fd265b519ab35e6feb661292540d5c82e6a29d2bd3f58c75001497200bb339ac649ee907517b122a93bfa118e4853302c0dcddeb1f293f59b394ac36a1414bbdaf0cad2eb218048a109dbf18146fb2e45ea1e18b2829cd92ec0d3f9c73cefb994966e843a80ef24aaca5020022212e08246a50b2802043692c2a4a89a8773e5eba456a4ba89a0add46ffce316f7b941037d6aa7de1c97a8602818814fac42146ae1c86a51ba42e92013724d03b93fca213bec0b58b9d243eef5167f42119248e8f5602213a59cb0615b9b440ccf43de73a0de90be2e0670455a874906227481d1ed405e971bc2a5eec403522efe30c9342ec364bd167f9ff38876c600d570080e68966635143159253425882ec0778f9f843eea258062cc6a4161089008b329dcb9eea9e2d7b303949d652484923e24b0a37a10493a4004774e90929ac22555dc93751341468b7bc525752cad208a867dfc62f069bb057be08c9087375a58775c7945b2430429ca43f78bd6d78a920d00269526e00ac5a8297483a8b508361f38eca77be0d93c64c9046a2b0401d1bc691aa61944317049a0700c69608f780a4ba5d8903ef11a8e1480b0cf4373611eee8aab525ed46b079b9be32a9a5d04101cd5d9d31fa55ecfbe722b915dabfb34737ce613f2cc2f2db9e3c2dc539b62f0eb299f2f2f959c6125668ccc7bd839d8b491b82447e64e5c74b1494a81a82f48e7fe5ece337132240590bc43e1d2b074941582949f062417ea23fa57dc635b421da2d369b579a351aa735e309fa325f2c5b3d4d24ed52cbaab1edc189549c461e4e2b0ca4ab0f8b9631721691f1226813107c28418d1a62129d3a8541b5098eba761be69ff008e5d8d3b30736178e1994fe36e4770e66d99e282b5ebc77f6648958d4a8ff1267cb9a953ee931d8ec5242751049a3bf9748fe60e27c3ab707e23aae0fa9fc250a93a72f6c24e2fe9479d523cb1e47bc6ebe9b18aa4076720815118a425eb548f840dc45ea9a3b8cf5fb5f69fc7c62900956a7a02e428ed1e64ee60f7c1595ac381a595407a43394dcba9df4a43edfca18855424a455c02a314e85254556d45d5570fd44677445f1765e92424974872e4b8731932a6e920953b9ad37da34f2a254a2124800686f885af16cb53909530eed589e97fe51ac67745978a37561314b414a490a42a852a2e08f18f9fff006dc7b147853da03c1f99f3bf927946539376a9e1bc8fdd94832b2cc2738b0984967dc65b8f9c5909c74b40f7785c5cdff4ca98ad1a4a7f7a24cc234870ed56a74f5fa46bf85c5841015541005d82a3e8fb2fda9e35d8de354f8f7019a8d68a719464af0ab076e6a75237b4a12586bd8d35249ae8a55a746a2ad49da4be95e0fc8f129e6c72838ab96fc4d9ff000a716f0f66fc35c43c3999e2325cf322cf32e999566f93e2f0cb54a9f85c561e600b95365ad252a4a8508dc313d6dccf2d5c82a641705f6eb1ea93edbef626f0b76e8e0bcfbb40720727cab25ed4dc3395ab199865094232fcb39d983c3a1d581c4cc01a5e6689693fbae2560a6629224cd212b1325f99ff0037f951c4dcbde23cef86f89324ccb23ceb24cc676559ae539ae0d781ccb2cc4485944ec3cf92a01485a1408293631fd1fc5786f673dd07b34fb67d8b8f2f2d96a74cdde7a6a9e0fe35296f4aa592924e2ed38ca2bd1a90a5aaa7ef8d3ab25baea9fd9e0cea7cf9408ef03ac1a30a6fb7ab4696b402906ac2852cfb57f0de37ae3f2f992a63e92db9fafaf946dc9d21482a04f883707abfe91fcfdc5385d4a126a4b27952834cd0969abb02756970589621bf26842962ccd47aa994ce4bc674d935749aacf783fc3f28a172c935214a6d21d45dabe11f2d5a834ccb6d8c220574db4bb80cd15a807146fb3e758c9983baa6ad1b4874bd2a628d040724807c6a4b88e09c5bc193c81ddb56df373e30ac002482490c0114168b12090a7a1b778d4c05024848d4a013d6c7a3460d59b2a2904b8347a5c5fac15009672477433307def06c016512f73d1e09d402a84d28902d19b56770023bae400a1416312d4208abea7624d6038653800aaeefe10412ca6524926c6b48376000b0433867b90ee6d01458100021ddc6c4c30167b10e40bd3a7ada20171471b13522230ac001d8390c05413e312d7219aa1c1862e02120067bee7785a38d922a4bd5462526c05813dc05c96ef1bde11490144d5c963588482fde04ef5b41a129366dc1a1886dee09a5485900a4a8a5cd1afb40092092482949af7749fbe1998043127f88dfcbca14353bcdf6439885e2034008b005800ced4814ad0962c00b10f04100329c827533b3c12a2d4090fbb79faf9c5acba8006575a54ecd4dc4294bb172924d77deb040a9715d34fe134801dc971e201bc474b8030a9d2180660c1fc7f0874b9d2c188724135ac048605c97162ee456080ffc4a24329ea2a21668043024d48018d6a2106c0aaa2b40d0e92a0e19df77625a1402ea0f4676b902253b66c02f62e349fabb3bc1009a10ce2aad4295e9001b13de16005c7589426c4b559ea211db0089451825e86ec03444861a49d9c921da201dd04dc9677a0bb458da4774b9d2c43b87dbd784592be00ac53f0973774ec1e81a1b53e96b9eed45dfa428a5817772762218b1502c482c46c131ac60ae02d415a3547da820302054f9877fd61c3160f7b241b1a46409400774926a58b79c7453a7296e5e29b10219c292cab120b83bc64cbc3950532469218b90ee7a45f2e4296ea62cc00160635491853407ba97a50b9f311ebe9b4529b4d2c1aa5b14e1f0d6d20151f8a80e9dab1ace1f2f5280d2012e760de71ac65f95ae68484a4806a68c4f9f84722e4dc31326aa53ca529cff000972378fd0b81765351af94614e0db7848eaa549cb646c7cbb225ce4949964a8d59be268dc28e169aa424fba575074d4c7d197b243d857ce5f68667f96f303888e2f951d97f25c7a55c4bccac7e01473de35f74a066657c2b8458099f39754ccc64c230f20125e62f4cb3f51f3bf6587d9b299c52788fb45c8492fee91ccac17bb97e009cadfea63f43d5f0aec6764753f72bb55af50d628de54a9c255654fc154e5f46337bf25dc92b7325757eb70a549a84f2faa59f9fec3cd0a5f0a625649125443d19353fce35597c153ca42bdca8067019c00dbc7a60e17f657bd9aa8d253c53da21dacbe62e0c9faff00674677ff000ad1ecd800247127685507723fc47c2a41ff00eb7c5f4dc73dc5e9c577bc46bb97fe9a7fea3355f4ab64fe63ccb57c213c38f70a24976d17b43a383711a47fb3ac921df45a3d3413fb2d1ecd70ad5fdbdda0944d87f8918550ff00ed7c65cafd970f66ccb25b3ae7fad46802b98f87a7d32f8eca7da3f71352bcf8957f934b2ff597eff496b59fcc7999cae08c4a921b0eb25a834bf9c58ae08c5248ff00216e06e9a47a688fd978f66f8f8738e7e0f1ff001230efff00daf80afd976f66ea9ffeed73f9c1a91cc7c387ff00eb7c7747b4fee15f0b89ea2fff00a497facb77fa3f07f31e654be07c49ef7b8538b8d0cffce284706e2428b48212aa00131e9b63f65cfd9bfbe69cfc2377e65e1c378ffcc202ff0065bfd9b6baff006a73ec756e64e1e8dffd01159f69fdc2b9949712d47fcacbfd642d4686f9bfcc79987f72e7f79e42881be9fce2b3c193e853875bff00d5aeff007c7a67a3f65bbd9be925473ae7fa86c0f3270da59fc32f82afd971f66ea8bff6c73f53b53993873fff00af8b4bb53ee137b2e23a8ff9597fac9f7ce8bcfe63ccbcf05621409121414f7d37f2fba18704e26af87984937d2c0d63d3395fb2e3ecdbd2dfdb5cfd05a8aff11f0cff00fdaf844fecb97b38bff960ed04037ff346c2a9ff00fadd1a47b4fee0bbbe25a85fff002cbfd43df1a27977fee9e666ae08c4a4b7eed309005d3d7f38acf03e2d61ff00775a7fec47a66aff0065cbd9caf4e23ed04dff00e71707ff00e0d874fecba7b38dc28711f6812c18a7fc43c191f5fece8b4bb4fee0cf6e29a8b7fe925feb27bfd0daf9f999e65b2f82318e4190a209be968b26f02e280a61d6437f0375fd63d3664fecbd7b3865ab52b35e7d4c005d5cc7c337dd9788ca9bfb303ecdc5a0a138de79a68da8732250503d7fe62628bb49ee08934f896a7fe51ffac7be344b19f98f31847056298a4e1d6c28c25d4bb456ae09c524ff00cde616df4dfd563d32a6fecb67b390a967fbd1da1a5035d28e62604e9f00f96c147ecb67b380065715f686593fc5cc3c0fe232d87f293dc1b96df75351ff00292ff50f7c689eea5f31e6792782b12a24091307fd9afab45aae08c4820fb95022ff00e5d63d30bff8571f66f23ff5e7ed06091f17f88b83d46dff00cee8ad7fb2e9ecdf200fef6f6844105a9cc3c1173e7fd9b08f69bdc26d69711d4dff00f492ff00590b51a45d25f31e686382b12e5f0ea2d6ee7c43cfa4631e0cc402dfbba8d6e53a5ba47a618fd974f670053ab8b7b41949a04ff88b82adbff9db017fb2e3ecdc2e7fbd9da0c358ff0088982fff0006c43ed37b854b31e23a8bff00e965fea2eebe8adf0bfba799dab82312c74e154e6bf031a7e7083827126bee156208d1431e9908fd971f66d04f7b8bbb42902cfcc3c111ff00dad851fb2e9ecda07fefb7b421ad3fe50b041bc3ff0089b15fe51fb8549abf11d4ff00ca4bfd457bed261ae6fee9e66a781f161401c3a81bd534313fb8d8b4a48fdd96a245000c49bd63d3257fb2edecdb7eef167684d5b9ff0010f06edffe8d843fb2ebecdc21ff00be1da1ed56e60e0771e396c43e3bee10eed712d42fff00925fea1de691edcdfdd6799c1e09c506690b72e281ded18abe0dc4827fd9d5fc24b1b5778f4cc3fb2ebecdc70fc5bda1e859bfc40c0fff0083201fd973f66c288278a3b432dcd8f30b041fff00adb18cf8c7b864b0b89ea3fe527fea0a5a578f4be63ccb7fb978a3438756915629a8a4553782b1694a8fb822ae068731e9ba9fd974f66a1749e25ed09401bfe50b0676ff00f27462cffd96df66cacf7789bb451f01cc4c08f1ff00f96c70d5e23ee212c52e295fe5d2cd7ed1552d3bc2bfcc798a4ce14c4a4e9325409db4d376813784b1613a8c950a3be8a86b47a6e2bf6577d9af3194bcff00b459e8a3cc8c103ffdad68ca97fb2a7ecd4c4a748e23ed1e5645c731f065429ffe4efbe3c3afacf7244a56e2551f87fb34fed3394a8c55e49fcc797e6332599870ca94b4a9d9c26a7f9c6de9f8097250a9935a5a134007c4b3b04fe6768fbddf6a37b1bfd8a9ecd4e4862f9abcd7e29ed37c57c719b6bc172a792f91f3732cc0712733f324b34a54c565a4e13012890ac563940fba960e84cd98512d5f06dc5989c362f3bccf1780cac65195cec74e9b966529cc57990cab0eb98a54ac389eb4a5737dda4a50662824af4ea203b0f82e31a3e1bef3fba5c339a7a7936a12941c39acecda4f2d2dafb5f17c3b73ce5171e682c1b167bad41668d49680aee81d3d5e31485124821d9dee4c66cc9a904ff96cc6aebb5bc2309eae94900171def1ac7e6b56ca4ce4925bb1569013766e956f08a5d248b9f34848340d190a5248d4010922c0d0d3a4633960092ece1ac23867e28c58fa80258bd59800c2a76870fde07482057bb51e462a704bb299259dc6a35e9b4356b5703bc2b68957d9e00ac544a402ed41b1ad22ea8432880e1e81ca9a2a417d434a945bf885478431750eeb8ea9faff00388585604625828d535a1704758b424b90542acc74903ca1121db48258554ece7d7e116252195459254ed178a087424ea51dc51c501f38b42ca4ff000e92e0bb8077fe715a5988043bb17259ba79c3254ddc05290aa851368dd63a9a2b5cc870589012904788af5f5bc64cb500560b9254df16a06d5f5d631659090353901c1092e6c7d346520a6a524809a79c74d2b5cd3739ebb3f29b9d1ca24a4fff00243cacbd2bfed4098c1ed22aff0097ae73b962be65e6ca1e1fed2a317767d2b4f3ab948490a7e61656c9b14be25314768b04f3d79c8542a39919b3926dfed0a68fa4ad2bf078dfe3fec236937c983afb3c154c3f648f28c25803a3bb55a33e7a46a23ef25a34e983bd5b0373bc7c6ea773927b88e4835a0da24062cfb448e52808741a8f135a4243a1ae5e9e3ebd0898ee819d2aa4000de8f1d90ecb00ff00c217930927bc798381aed799fce3adf240258b860e0f84765bb2a235f688e4c0a93fdfdc1970ce584ddbce3eafb36f978ae95ff594ff004e277693f9c53fce8fd68d1b9e4e9e71f36858ff008939c8b38ff9fce8e199d55925c81dd14a52f5fa7d639b39ea8239cdcde49a69e656736670d8f9f511c27395f100a14ea287d7e71ddc7db7c46bb5f8c9fe9326bdbbc93f37f5984bd213a5cd4935a1aef146cec4528aab08be7072ea09b3b5fe6f0890349a02c1eb46f18f979fac61b0a922a08000b0663e0c225c5038003b1ef3bd7e660a0d0a8900bb6a55cf842801b4d7592e90ce96de39e7d518b6dbb00a6a0d5295d1b53943d0d615445dc50b00c4388956228a00d5547f5fa401deefb3048670749aef19bc2c1522d885301de01c877785091fc35664dc6aac10ce6c024b56a4bef10865a5ca8b1ef02006f944592b2608084a89a9eeb83721fac2b800b55ee45cbc0b026e14592a1dd3e6f0ec0934f2adadf58857b5d0016a02fa8b0a12006bc33065072ce2840d36f56880bec9d562ecde1fd6029989600a43300000f4b42d1ba680e4948d2e925df591401c51e11643004dacc97eb0756a4966530ab1a7942950b921c8a06f858d2acd5fca22f903588bb3304814f1ade0915001d3deb39eb09de20a4a94096a83deeade1e50e4595750539240bb831a41d9d80e545dc06622829d7ef8892a5172ce0d5268086897d3401c13a8302f535fbe02681fe220bea7736fc778ea83b3358b8d8cc0a52b491dd4bb800d079c67c83de0a736650b8aff004fc634c9668521fbf5539ade3364a99807d40b6c1e3d2d2cecd34689d8dd5829ad4074bd126e079fd5e397781b1ca918ec3b298cb989980b93505fe8ed1c2f83242c31003f783797af9c724f0dce4cac64a29b85396fc7f947ebfd84d7cf49c528568bf5649fd4775095a5647ab1fece7f35bfc47f65d72bb2298b96ac472cf8c788397eb0998664d972a4e3d78ec3ea734ff2f1a00166488fdb3c56b4ac804e8069472f1f24ff00b23dcd2c3677c99ed4bca29f89d78ae19e31c8f98182c3198e9448ccf0137033084ecf37046bbd23eb6716befa85540962cc1a3c5f767d24747ee9dc5e54d7a35e70d42fff00a69c2bbffaa6d19eb2cb513b7569fce93facc000149afdbb9a11eab68548d4b2a524004bb2ab48a92a1a965e8564924035f11f945c4d00a57760c63f2aa97b60e39610e543e101419c3b6dfac63a8e952925448605219cfe3192c520a58101373507c2305485291a8a9926aa5d014c732c332ea3904825982a8faabd22d080929d02960cee2284807bb548b5480fe7e9e2f965350972c6ae3a7e916e74b089e64ad63210749b77ba00e00d8c674a98494805eae49b88c1052c8d26e0b1a3c5b2d418ea776ee90439f3f08e884b069195d5d1b8f098832ce95b942a8a26f6b47cda7b73bd885c39db3f85338ed25d9cb22c1651da5387b2d5e238af84f03265e1b2be75e0a4a0a838000979bc8096953853108265cc05425ad3f46d2e7001ae1bafae9f58d4a462c00124ea41bf878c7d4f643b5bc6bb13c729f1ee053b4d2e59c259a7569bf5a9d48fc28c97ca9da516a4935d542b4e8d45569eeba746bc19e24fcd0e53e7dc119de719067d94e3f29cd727c7cfcb732cb331c22f078ecbb118798a973b0f3e52c052172d695254853104178eb9667972a49502960e52d5069f9c7a7afb75fd88d95f6b4c87887b51f664e14c2e1bb41e5b97ab1fcc3e0bc970c8c3cbe7361b0d29862e4490c9fed8952d0101400562912d0853ad2831e6fdccae5ce6dc319b6372fc7e031383c4e0f13330d89c362f0eac362709325a9489b2a6cb500a42d0a4a92a4a80524a4820111fd21da1e11d9eedf7677f977d8683ee2f18ea34eda7534b55acc656b374e566e954b2538eea33528c7d0ad469ea297bef4fb6cd754fecf06759e6c80977492a17a9019c5e34e9b2fbca1a74ba5804ddfc6379e3b0132528a0a183b543149b5fee8dbb3a490a090c05e8c49357f5e31fcedc538654d3c9de363ca9c5a7b1a04c414ac10eb214c69a416bc50c367eed3500e2fb4672c3ea49603aa407360d18e404b857752ecf463e51f2b5e938bb58c5f9940043916b870cf7842469d4090a2a3ad8b9148b1428f520160ed485b8756907a33816fd3ee8e1a89dae672026a6e189dc31f5e10a1649601f55287bde70090e0000801cbd2afeab03507d22b4704063bda306fc372a311df2cea243172cd0a4106a6a3c1fd7ce0394900d090e4ddc06a403a6a4a9cb80c286230b28167c24021dd3ab50a10f01235393463aa9bc0ab299cee7c696fe51183397248b136eb0566f282f10a812a258826c0559a14397363b9660618b0729042ace3782f4008f0d2438ea222c9202b6ece1c1701cb784155d45897b1019ed05a8a20b1487000b75f422b356009d23a8bc4dae08e41d4a481572a06f04bb0171a496d351e66225d4c0004a4d2c3d79c1eb4003d035527a3430d012e1c8048dcbb7d5e080df69ca88a10c456b0ccc4820381f09663bd7d6f0286e19856c2d10980333eefb3d7fa44142d52d5f87d7a30c03848a826ee002ed789a5ca8328e9a9a861eab109e2c084a880d53f0bb311e7e304b8095061a43100fc5f284deddd600d5fd3412055d8104100805e2d6b5810105cd4034b7e3113ddb02e6ec3e501be26ab9701e87c61d092faaad701ecdf7c1277c20290134b3588148351b1a5c378c3774923650a8f94383620023720860d48ba8e415871600254057e202e59e1cb101aeaa02d4a35a14d0b05e9700002a2b5fca192ddc245ec00bd2348c1b762520249b2812450b8f1de1d280ed5fa1a4196ea2681c17ab35fac664a94438d2038e8ede11d5468b9bc6c6914ac572e50774d4034fe22f19b230aa594850abea09e9e9e32e548764d4f461668d730b8252d684815373a40abef1f41a1e1b3a92492358c1ed631f0984551200255422da7a53e51bab2ecb7510560a8ea6d3b8f28dc19270eab1052c8ef11660757ca3b37c95ecddcc5e73f1e70b72eb969c1b9e71bf1c718e692f27e19e16e1ec02b1f9b66f889843225cb4bb2521d6b98a6421292a528004c7eddd8cf738e29c6ea463a4a57eadbc46314aee526f118a596db492cb691e850d24eab4a271d702705cfcdb13869587c24cc44dc44d448c3c8932553e6e216b504a1084004a94a240090092480047da0fb233f671315c7cbe15ed05dbcf86f31e1be5fa7dce79c23d9eb18a9995f10f1ba4e999227713a9044dc2609434abf7142913e68204c54a49293fa75ec75fd9fde5df636feed7680ed492f25e64f68fc24a4663c37c268928cc38079433ca5c4d91a836373296edfbda87bb92a7f72925a647d2963b1094503049dac4ff005de3b3b55eea1c2bb2ba57d99f73b9467ad578d5d7c768bd9c349e6baea37bfe06d65565acea469bee74ef6de5faa3e3edf98c2e17e1de16e01e1bca384782b87b27e15e16e1dcbe5e579070f6439749cab28ca30f252112e561f0f292944b42520009480231b193f5ce259c92f6ded13f7a52c9725ef560d142cea04020905cb5088fe758f3ba92ad564dce4eedb776dbcb6def77d4e16f95fa1f39932b1052948aa5cb17da2ff7e583ab76a548da34752ae90588fe2a982898492003e3e1e2ff009f8c4b517b93de3f135d4cf24b38a7a78733f49001248ad6d7da3433380f12f4163115396c974b17eed62bdda7b91dec8d68e2cb3051a963d608c42f502486b06a18d104cfb4ec771423abfe71789849150459ecd0eee1b12aa3f135c18a15751a55ab585562945cb914b7f38d1fdf338219cfd7d7e708ac4a89a3311b17062bdd448551ded735938b98e03963b0abc21c4ac9049206ee5da34613d443e92cfa4bb30f0f5d207be5170ff3614bd62ca943aa279da3555e29409673e04c0fde940b1b0a924916f18d18ce2e19a9b8a9310e219252a2e5d9830a3fdd13dd476414dd8d5ce355bb100b023e700e3929a824d8468467a5c5483e14f561480a9faa880e46f43e878c4f771bdd8ef1ec8d73fb417ae87c5afbc37f6892e5db720d5e36f2662926ee49b9dfd3c36b7009b28514eee7ca27bb807526d9ac1c6afbce5cb58edebf28a958d5848ef2bbc2b4a88d2bdf0ef1209229d43456b9c4325cf7a84ed165085b61de4afb9a8ab1c43d5c350b9a7888a158a5289a900070f63e9e34c56a4eee4d58353ccf58a8951203973466629f068d54217c11de4975354562cac36a56a05a295625603959a9a312c6303de33a43b11a7c411fd210cc4909eeba1ea280de9174a289ef27e26a29c54c051de1a6ae3579c22b17b8528ec49f9469fa9215aba8ab55a913524b805cb3a68c044a8c473cbc4d4ff7cd258ac971e6c7782716e0b2880054dc3c69e9427ba47c5b11430e1249d2456d402b48b5a039e4f3732d38a0a206a557ed56bbc59ef9603ea624d00761ea91862510edf103514eb16a65929152e54c6a297a7e310f96f7414e4ba9a84a9da52e41528d80a831a9e106b505a8b245d2772e23489085121235742d4348dc784c23146ee682ff0038e5ace318f99b53e66ae6a6308b5cb74a0937a55847433da09ed0ce45fb3839159b73879bf988c766d8a44dcbf97bcbccb3192e4714730f344a354bc1e1017d12924a4cfc49053290492e592778f6f5edebc8bf678f2033ae7573973c9324152f25e07e0cc262509e27e62672652a649cb72e92fa949006b9d39b449960a94451fca67da49ed0be777b4179ff00c41cece6fe76bf76a4ab27e02e09cbf10b1c2dcb9c9a5ad4a9196e5b20960e4fbc9f3c8f79889ab2a516084a7eebb0fd8c8713d24bb53da74e3c2a9c9a8c53e59ea66b7a707ba847fa5a8b6f563e9bbc629f3568b94ff07f4bfdde26d7f681f6ece74f6f7e7e71873f39d99f0c66779ee2d787e1de17cba64c4f09f2fb294ac9c1e4d94485125187909d20cc53cc9cbd532612a516fcd1cd713ad5309275155cd4c6b38ecd97396b49516a926e4f946cec54d0a512c1409b51e2ddb1ed07dd4ab6a5150a514a308455a308ac28c52c2496df498d59dd5918330a4d0001fafdedf5118e5acc589a0a849ab79c3cc50515122a77a78450164b779c070ed772c297f08fcaeb4bd2c1c536ecae02286a401f174f957ce128d4777a6f4dda09092ca25b55c6c3ac10ddeb2c04d9361e9a38dbbab99859248a2bbd71680ca4b1dc86596bbd1a08012c46a3a8b8a861e30baca5dcde8d731577e806034f79fe135630cfb100397013f67ca2a21d4c943285eda48fd21f491a58253770802912b0f940cc0a525a81f539bd7d345c18f7439511435a452fa4b13a98fd9603ce0a59c1ab781707c2348dd34895e258964906a08d9fcade060f78bb8d440ab8a01d6143a8b801cdd408013e11600ff12810281cbbc6a96725a3b96a086d258006caa28b8fc632c152d80b1a90c12d18085048d29502e58860520359feb19b24a54451803534f0a474d27936473df67997af9ddca00198731b2a49ea7fda51fa457da51d3cfae74337feb4acd48a5ffda0fe517767ceef3b7949303009e61656a014cf4c4078c5ed22bd7cf9e722cd8f31f34536d59e63e926ff00f068dbf19fb08d1db92e8ebf4f26e0b8343d079469aab17f86fe758d467b0366ddb731a62c52d525808f8fd4bc9cb3dca879b7e312210de112394a13d7943872189a5ea68214026820a40240357da256e0ce92ab015dbbd48ecc7652528768be4c04fc438f706c01ada6c75965b6b0ce76b308ece764b00768de4ba8b149e3fc1dddaa99d1f55d9dbbe2ba55fd653fd389dfa3fe714ff3a3f5a34ce7a7feb68e6f13de279939cbd0803fdba79ac7084eeeeab312da9dc98e71e7c69ff1a79be94061fe2567203ddbf7f9f1c2139290685837789147e9e71dfc7d27c4aba5f1e7fa4c9d4afbec9f9bfacc198e52ca66d4c96353f28a48d4cc14c077bc62d985c32880416602a03c54c0821de9a83523e5e5eb1cb26d6500d4289d8b3ec01800b8353a4d4f8b5ff285a10e012a76d15f99881c12765924048e968c272339658ae08533d9f4dd43c21524294e5a95054e0458c2ca0f5725c87f5d215214aa0d2003f5eb183cf52a301adf4b84958531a9f3f282a26ba944bb04a9697205844243a5879fd9f9fe90ab059ac1eae7513e516784070ce431605cb9fb9fd085ad522a01704fc4dd21751a7da71d1881e5bc0210497720967a868aab6ec05208218015ef54d2254f74db5b0dfea610ecda981772935bc470fa83b80c29b342e9600ea776a312e025d8f4847d42a4822976eb100d83d7e2245bca080ad21882eaa52a2271b0192a51eebd83a5ac3c87e70e011620907bce59ead08900380962d57b5ab1610285dcd494f51e6f1296401dc97d24ab77a0f180a040a9abfc5f2820b00e40d55005d378974bee366fc23a22cbc5f46644a2da4b9a9617eb195294ca5a5c545c18c248ef1528f7ba1b464a08761725cd2deab48eea13e59246aad7c9ade1a610032884d81353b46f5c9710a97365949724bbea6abd9ff38e3fc39600a412f6178dd994cc3ae5ac87653105d8d7f0fd63edf80eae54f511b3f03a212b651f63bfb275ce95f09f6e9e31e55e27319785cb79d1c82ccf0785c34d5e9399669c3b8dc2667849681bafdc6233057fd596af28f428c5ba56b724e9510437e31e4fbec47e722f933ed18ec7bc752e6cb972b0dce9c0708e6b2e6abddca5e0789e462386e7ea2e289399cb98f679423d60334988462b148a8d334848d80d8c7d97bb45055abf04e3b0cf7fa38c24faba942ace2efeca72a4b3d0e9d7c52eee6bac7ea7fbd180a609624024be93468796b012180209ef39f08c3333514149763f11a3dede117cbef866704b960c0ef1f85547747993db264826a14552d24120006de30a0ba80ba74369bd5ef17682aa1043ee0394f979c4f760825258a7ba54ce9f90fd6306645646a514b8000773468852e4311a52199e09012149aa83b924555f7c07146bb84971f4f9c40c1096228b6aa4bfc2fbb4442f45cd1d9c5fe70c6a007258ea666f0840904a54d425ea282f1a4258b168cadb99099a49b009b820b11e7f7465216751b04f5b03ebf28d3c0d2490800f916f421d33d89eedc5091f7c75292c1aa78b9baf05884e9f76b24a2e924d41ebf2fca3e57bdbc9ec3ac1f691c9b8a3b597657e13c2ff008d797e0e6e75ccfe59e4785461a6736f0f2d3ab119a6592800839b4b482b5c9a2b1812a0354ed2267d4149c46925dfa10ccd1abe1b1814344c754b702f51bc7d7f623b67c6bb05c7e1c7b835a5f06ad29ddd2af4db5cd4ea453578bb2cab4a324a516a4933ab4da8a9a7a9ded3df66ba35e0cf110e61702e3f87730c76071d82c460f13839ebc3622462242a44f90b428a572e62140292a490414a8020820806381b1f8354a24250425eaf511e951eddcf612e59cfbcb789fb59f651e1ac1e179a385c2cece79b3caccab0a244ae624b4275ccce32642404a732960154fc31eee291de494cd4699de797c7fcb6cd785b34c6e5f8fc24ec34fc24f5e1e7489f2152a74a5a1452a42d06a9524820835041063fa2bb47c0f80f6e3802edcf61b3a493b56a2ddeae96abcf7751595e2f2e9d44b967158b494a31eead4615a9fbe74d98f55d53f06759b11255529052d50c19e978d3572c80aba8f89f18df198e00ca5abba48492f4ddad1b5b112146849157602d1fce5c5b8654a151c1a3ca9c2c68da4a41069afbda81e8f611481704929d2e82adcb7f38cd5cb01cb9a166a9a318a1419c8700545366f558f95ad4795d8c5c6cacca88761f0e9a91f9c2b035a822a1cdc359e2c29019988fb459c8f0f380c2943d4162c696f28e29412ca336baf42b203024b935eedc5041a0629277ee962483115500b782985edebe70a00ef30626818ea6fe718dadb104b022aa0407e90cc1cea700864b08042aa19daf4eec175b6aa380ccd46ddcc15dab0087d297003967fce192e190192c7bc5a8378096d352082412f48551297090ca1d43d3f9c513c3b8201421dc02c492403585d55249b866d8c45160a50a95062007880123666bb5fd7e716567d000588407502ee4d0faac44a8f74b1a8a0e85bd560160da9c00ee0060078c4018dd924543393fca2137d404962188a9752926a21b72e5d4e3483e37802aec0a74822d556f0a4331d25896b57d5625636d81602eca3a483437045eb05eaa7d3e043d4521051890e94905ca59fafd20bb921c002b41bd2860bc5201049a0291b00fb405a4837049162af0806cc524286eceeeef0a493a4378a4110e64b0062c06a0a09d3704924d4504302482039043b0a69f1842ee588001a816368896a7987bd2f1293d980ea0454bac0a24d0da2c7d4e40a9a163510a90e0a8338140ce1a90e909ef69dc390030157bc6f083be0957dd0120906ac52c902a5e2e12c961a4861a9eb5828493705d46cce6331325c0d5aad501ea1a3bf4fa794dec6964ec2499649206a0f42051ebfcf78d52461896704a5d80373e716e170a564306dc829f548dcb82cb5530a5210e5fbc5aafbc7d470de0f52bca314b3ffc1bc21765182c0aa62929425b6601c5c08e43ca72199315290894a52d4a1f659cf9fe71abf0bf0c4cc5ce96844a2a750ae97fa7ada3e8b7d931ec3ae71fb40f3eca38d33afed2e56766dcb7344a78979a98bcb7fee8713a252c7ef19770b499a3462710a654b38b50561f0e492af78a4fbb3fbe764bb03a5fb995bb41c7abc74bc3f4e93a95aa5f9578462926e7397c08414a527b2dcefa34125de54768addf43a13ecf9f670f688edd7cd3cb796fc91e1138e12a74a9fc61c719debcbf80f9758051026e3f36c6e92da53abdde16485e227ad932e5972a4fa557b383d955d9bfd9c5c07264f0465587e31e74675962705c73cebcff002e97fde5ce52a00cdc2e5e93abf71c0950a61a5175694998a5911db0eccdd94f909d8d795b92f277b3ff0001e59c13c1d934a4aa7195fed79e67f890909998ecd71ea1ef7158998412b9b30dc909090c91ce589c56a762ce58299dbca3e0fb7deeb55fb41a17d91ec7425a4e089fa57c56d535f0abb4da50eb1a117c8b79ba924a4ad5ab778bbba4daa5f3397b7cbc8389c400a6490e0324469538953959726bd3e90b3565c382edd6978a54b0487140686c63f208c634e271cea3b5ba18ca74a8a6e48fa0855294c760695bc5aa5026d7176b6f18ebdb4dc50528233757991836d9428f7dc004ff000bf7bce1d2e862e14155171b6f169432816760c4ec615482fa52a25ffd0c7eaf14ef3c0a88e5200d45c9aa417f5fca005174809fb55015f84129ae929217fc4eff007407b243d3e20a4d0bfa3f5877aec2ecb82813a45402e349a3b45841d2a01e8aa56846d18e90a4a438007823bc92dbc1331c1001501bd9e23bd77c0bdf72c54d01be251dd8b04c4d6fa49213b96a9b748c62144543b00491720c3a7bae4f83518dbce23bc685d97a8920acd06ad2ee4bd62954c62007d552e2d516f5d202d403f4372768a4a54a70188f00453a46aaaf89376454def14a5446f50c0d36fccc5731641297d157dc3c3048700971a5dc06219b78522a4b51dc3f789afaa45bbe44f3b40484ea06c2a48dc431550ac6929258a5d879b40fb208bbee971fd3c62a24a49a80ec4f7748111df2be073b323580daa95663667a4054c6ab59b4eed43431410a5007a9af75cf5fac062ce080121882286910eb613279db1d4b51170e0d82aa6d58855a4a54005149621ec3d6d00848a312497762e7ce0b000280d35722f175593d829788753a857ba92e03d41f5bc230ef14acbbbb12c4fa10c402c406d43bc0021f68834a410c1248a287787ce2eaa45bba2c9a6b2632d2360c5dc1fd3f48a402924283a87dab83f28c9554779f60348d2ffce0774a86949093dd72183f511af3b09d97998892414b242537d3e2d1701a4f7886672df28b3dd905dc2d3f6814d07ca1909152a0188a1219e2ca7757e84dddc29d4024776a1d9c925e1c80a049201602a5c83ebf18b51281d2aa804588afca1c4b7ad88b163f788b2772c9dc3a09486219da86bf38cb95282941f49b0f86b125c85292a013a83bb91511abe0f04b2a7d24b90e058de2273518dd9318b93c16e070875304b876036b47577b72f6dce45fb3f7901c51cf7e7867f2f0380cb64af03c29c2d8098899c59cc4ce14852b0b93653862415cd9a52eb985a5c99695cc98a4a524c5ddb4bb6c722bb00f21f8979f1cf5cf4e0b24ca651c2643c3597291338ab8f7325209c36519461d4a1ae74d5000acb2252752d6a4a4131e591ed2bf69c73c3da35cedcdb99fcd5ccd59570d603133f07cb7e58e5b8e5e2386396f96296d2b09877004dc4290127118c290a9cb72c94e948fb9ec2f62e8f6826f8ef68e4e9f09a4fa3b4f5135fd153f05f8ca9b41615e6d235a70ef3ada0b7f336c7b477da43cf1f686f3db35e70737b365cacbf0899d93f2ef807038a5af86f973942e69989c0e0a59a15af4a1588c41017396805459284a7f30337cd3f782b24920d7feb7afce2ecdf30132628053825cb53ac6c5c462ca955dcd4758f7bb61daca9ada9ef7a29434f05c94e9c15a1082c28c63d12f9dbcbbb6d8a953e0ad8a3158856a5693525a97e91a42e69d4b6235330d5407ca2d9b34ad6a00809d985286303ed0a9d4ee49a8f08fc735ba9739377386527bb21ab3ba433104b1315b2812c542ae011e31690aa93a4dd87c2efd3f484013a8062c6b5a3b478f51dd58c1bb80020ea52994fd583400ce407ad451eb0082083d0b94554440ef6861572e6951d44639b6081c92c1e84508ba7eb78429203ba4821810eea8b0d188629228f6bc0018d4b51b4b59e095d205474b82493b8636b54c5a00724e92fb8591f5a79c2b10ecc4b3e901fe70da400542ae1c0dbfa41277bb0176b13457f530c000ec4000b87afce1003ad897243905144fca2f094b022a46c2a22f1ce0940d44104d428b97a3f9c4242946b46a102a3c040d2e35315120397648f086153a74b07602cde2f1bac5ae68acb71936201b518d0f9c6761f64ea600391d4fd23090952d447c2c284ede719d2135a7798d08f568de926e572e8e7cecfe7573a394da8f77fbfd963797bf11a5f68a3ab9e3cdeab7fca1e67d4b34e23f28d4b9020a79cfca7b6a571fe584005d80c4243fcff28d33b42b1e77f37816a7313350075ff68547d24eeb83af0ef3f611acbd4b799c0d38ba8b0f3a98d3d6d522cec1c98d46702e49157b37ae91a74c059cd2aecd78f91d4acdce49ee545c989118f4312390a91ea4f5da1906a3abbb8610a4d5fc5e1921c861f3bb415ee0ca9770c2e58d408ecbf655251da1b936a05b4f1e61140d28c99b1d6a9400209341bdfce3b2bd95dcf685e4e5486e3bc20a5fe19bebe71f57d9b6d716d2bfeb29fe9c4eed1bfbfd3b7c65f5a34ee7877f9c7cd898a24295cc8ce0d189ae3671ac70d4f01988049ad59ff58e69e74d79bbcd81abff00922671524ed8d9d1c293d4cb7700338b85477f1fb2e23a8fcf9fe932da87f7c9dbc5fd6cd3d43700289b2831dde31d4583ac01774d01fa4642ce9582c90a2a2480ec1ffac6351f4864a99c9bd768f979e1b399ed9056b54d7ba08a16f182400ccec285e8c7687a69492e963a546f5ea201b860c0861473e669f74613b3316202493a6ac2a2835340ab3302a04fc2d4dde0a811f1172ddd02a927d6f0950da9ddaf504bc60dabdd103fc4e4a5b550ea3a9f7de036a0c41667160a856529828b809d6cecdd1ff482a5509665307b80af2836dab11d4a9ecc40a9624026cdebce1b51bd0d198b503c1604a54a07ab87707ab4455cb39a382430a339110966c490fc25d86a2ec081e70524914a28d02a8e7cbc615c2c29c906f5142dd290f2c3a8b853e9715b9f389c6c80ada455bfd22c2861ee1c2c92c1c5c6f04f79d2e4b1704067b3b440596581a80e482006786d8040192cc2c4778b014684624a4920b51c90de1ebc21ee5833b5cb90aa6e7780412c6a4a6c2cdd62c9ad801b531374d28434041200737ab3c5a82eec5258369ad456a20241a80c19a8492f4a7e11b41f9168b69363127ba1c16ab96ad7d7946424905d2d6b51c0318c2e43b04d09b8bde2c965692761b14824f9111d74ac9dcd22df566a72962e0ea700801551fce37065f38a16085072ad4598815b93fac6d896a219837f11aea11b8b02c56e015249002522aa3e8c7d1f0eaae355729bc77c9dcbeca79a62f05cf0e50cf933a6e1e6ff008a5c323de485fbb9881fdbf9654285411d45a3d9e31695cd9928ea2e9c149b9f8cfbb454c78ba766152473a39420299f9a5c30012e0d78832cabfce3da4310a0af755f870725882431f749fd63e9bb77abad5b8570ca1395d43be6bcb9bbabfcf646baa937ddc7a25f618f251a6c4122e48750eac361e1bc6a12925551529a8d2c7e67d5234f62a24f5b10487ad3fac6ad2002914651a11a8920b3927d6f1f964d5ae70cade25af40404a41a29ea4faf0857a3a586cb655fcc458b2507e27d5621c802282b495281242981d24102bf9c645052a0ea62c74ea008703a98529672efaaa1aa2d47881452484952bbdf1177f94172a4920115efdc54d6040a7baa46aa13dd046febef840b5a0b1be9a90c5237a7dd0c9eed1d5f1502dc35a114973a094e87a9363770617c85926a2c45c1a173d7d7ce1546ac75045c104023c5e2ad25941886a29c9623d75821642490a25bbac01503e51ac256572f16d32e417634a28568f47fe748d4654d0e09a0b963421a3484ac820bb12185d2d5ad23284c22c08290eee4021bf9474426ee8d13bab9bab098b96b4aa54d0f2d6181a6a4f8c7c8efb79fd86396f36f2fe31ed81d943864cae3b461e667bcdee52645810ac271689682ac467b91c84074637424ab158540d33f4fbc425333de7bdfabe44e32cb24aba825c831af60f13a8097309d0a17dd27a8f18fb8ec276eb8cfb9ff001c5c6b833538497256a33cd3af49b5cd4e6be98c97a5095a5169a3b34ba8a9a79f353d9eeba35fc75e8787f71d703e3f25c7cfc3e230f325685a9042a599658518836219ab668e18c7e055294bd490085350071e31e8bdede5f61764bc4d9471c76c7eca1c1beeb3394311c55ce9e52f0ce00ae56312a79b8ce21c93072c3898e573b17849418ea9935097d60fc0071e708e2328c7cf94b96a08d474ac025243d2b1fbdf6a7b3bd9fed476723dbcec3c9cf4337cb529bfc269aad9374aaa58c6f09af4671f49754bb6be9e9d4a4b53a67f7b7f3a7e0cebd4d905048480a1756a661e7182a4777bce90438623511e846eec5e0548d41887ab543de36f4f9453ac6ccf5727ca3f9bf88f0fa9466f991e4ce166694a480ece002c07ce915d59dabfc24863e5198a0a531537f0b1241318aa77e84324016a47cf54a76dcc9be8ca88000167a81bc2b1200001502c0a6f0ceca27512aea2d1145d5de51a5d852ff7c71ce3d51496e28248d2c1b7258a891040605c90c1ca6c0fca03b0034bb9621d89a168014a04206a27cafd632ba58654b1350e1800402c29e0f0aea26e1c51459c78c38354bbb339f0f2847dd2a2c5dc9ae9de2896410d1d998170a343ebca14292e906aa51ab16d3e3e30c8a024d0da1031155123c010a116ca4902354967ab034049f1fd2186c05592286c07844d21e84b8f89ddc0f975809205f60dddabbf87ce22efe080015bb1b9f082b25f49604107bac20b69054198a480f6da1052b5173507a9ac43c6004d137b1a56212905554a5eb4a0269b4050048ab9bd686d6fc6210546b626f504fafca2370177ad4d37b0bc1be92c487a17ddb680fa4021d9ebb8881c1ddc06677222f14af8d801403829a31a02d43e3050c7a02091b0eb783b00d53f6aa0ed17246a4d016f5f747446177648b2572253e00ee5c81ebf9c644a9449484804bd1bcffaf9424b4a9d2c1c0362ee291abc8965d44121560054de3d1d3699ce49246918add15c9904f742751b12c2355c360ecc9773555ced78bf0d872c007b396fc6376e5b952a68432496a9bf9d63edf84705a9a89a4a274d3a77dcc6cb32c5ad4004dd5468e5ce1ae0ac5e63364a24485acad407751a8d4b01f336dc968e55e46f20b8f39c1c59c3dc13cbde0fe22e35e31e28cd25e53c39c2dc31954dce73fcf315354132e4e1b0f2c15295572a2c8424294b52520a87a1cfb1eff67bf81bb25e1786b9f5daf727e1ae617680972e4e75c31cb99865f10702f28b101a64a9d349064e3f349240ff0035952244c4bcad6a4a66c7ef5a1ecf7667b0fc0e1da8f740aae9d09a6e85085bdf1a992e94e2fd5a69db9eb4bd086cb9a6d41fa10a34e84555d4ecf64b77ec3f2bfd8d5fb3979b7356470bf688edc7c3f99f0872a5e4679c25c91c689994f18731a5f766c89f9d81a666072e98c957eece3113d2595ee907bdf753c35c3dc2fc07c3d94709f07e459470c70bf0f65d2b29c8787f20cbe4e5592e4b859290895230b869694a25a1290004a4002355c4cf4ca484a0f7427bc7ed2fc4c68abc42946a4b125935ee47e13db9f741e3dee83a9a6b5c951e1f42ea869a9e29524f77e352acbe1d59de52c256828c23855ab2aad4ea612da2b65f6bf32ec4cf3315476770230664d150e09146147813575090ce682ec3cbeb18535406aef289b39768f8a5cb08d8e694ef92e2bd44a9fbca0ccc36f08a16a1a429c33bb9b5ff0038a8a882925f50e85f540d6c2e002a6b9213f28e79cdbd99805454b2cc4022ce2bbc4f894c5ab55316d3d1e290a27720bbbd4bc5a145441d43512c093bf8c65ccb66064a8072e7bd4b03bdff0094052dc860520bdd9d54eb158a29446c4906ae7c6026a4b30a3b872233e6bbc8dc246b650ef56acce0435014a8ba481dd0586bfe90e125408200003909720fa7843b0ab1b27f1884ddacc0aa5153b04e90962054c26a0353697259d838afd21f5382c5442a95a7a022002ae2d46ab2bc845b096409dd6a2890a0e002c4fd614280d214c4243310e6debe90c5cdfba5ec5c131004d0926ce19d84426f0902109554b39a82050560b91a40160e48b815de09eea4b1ee10fa9ce9bc52b72c01ef10180fac5f9bc01415e92a0400ee6a030f5f942851d401292056cfa3f28b5612ab5480c4914f94280053e163de167f3894efb81da859cd1f51a8de2b29140aa52ea00955ab0ea258212a2d7297348a945deaa3a4380a7adad0bdc0ca4b0b87a69340f78a9cea7fb26e0b5088b1454e4157758289483a456c62b29ee95965005ea588895e2055294e4d8dd2695880d7bca0524bb5dfe707496a594753d69f3f941d40bb31203100b8dff185ed9400a59205dace7f4fca0ea06ece681daa0eed0a081504d46a65024ab788a0556772770691a45bba0215a4950157bb10c37f46002a70010cfde2e36b43252c4a80593577abd9e9d21d090451c1228ee155eb1bc79bc0d129035bb0d25c7c46801f38b1241aa989b14d0797e30ba14d5daafd296821040150f7f1f946d14db2eaf632101f4b972de000f28c94242d4972c12e4b357c7d75832a5d810ee6ba9dcff28d530d852b50d49620d0073ebce356d455d968c5b6919782c3296125854b6931c01daefb5e723fb0c72338af9f7cf6e26c3641c2f9061d586cb72d4ce41cfb8cb325a16ac2e5194c82419d8a9ca4b048a21214b510949317f6b5ed5fc92ec3bc88e31ed01cfae29c2f0d70670a60c8c2e104c4af3fe2dcc660230794651857d789c5e25602132d00e91a96ad284a943cb07da99ed43e797b4939d98be62731b33c4e4bcbde1c9b88c0728f94982c5a95c37cbbcbe6abbca12c776763f1094cb389c629d4b2908494cb484c7d87637b192ed0a7c6f8cf353e134e56725895692b3eea937d76e79ed04fac9c53ba8a9e17abd7cfc9157b523da77cedf69273cf33e6873231ff00d83c1592aa764fca6e54e538c5ab86797b94eb5684804b4fc74f1a578ac62c6a98beea4225a1081f90f9863c852c83724dc345d9ae6ca524a752896a1abda91b23158b54d2c1400355778ed1f5fdaced2d1d5461a7d1c152a14a2a14e9c7118416d14be96de5b6db6db6c99cd2f452b241c662b5bb121cb3b80f1b7e74dd4a704148a31dfce1b113945dd804806a59c55be5184b59001701cb80ecd1f8eebb573ab26a4ce494aec498b65009293de7350a07d748a8ead458a7bc9dae2195524e92c154097a562a510a5120121d898f12734ddd9836ba0cdf0bb964ee47ddf2685a1700be9a82198d7d7d2092a001b86dae3ce05027e205d44b5469af58e4936dd9140390970cca3770143e705c8497527e40026d05252593e0ff00e9f9185d5d48a962a2483e104d2c02061a456a4b390de62181ba4397b924101a226a125e8eee5ca925dab0484b289240d24ba457a5a176c100d21c0b8a92438e900b0d2c4837bb9623f94034a83f0ec69f7440fab777b28ef118c205c900281ee8d1b166ad8439208213ddef778259835a2a02955049d0ef5726194af0502051ba3748d22d5b04adc62e950234b2a8d607e505c173ab4a88bd187568aeed42aa377bd7df0e536aa5cefa8b08dd6c6aad8bee5b2d92141d24101b768d46414eb536905e83d7aac69c031ad058bf96e6350c3956ab3116a3811bd2b5d32eb7473af20d7a79cfca6538a73032c24f5ff684d634aed0452be76f378bd15cc6cd88a8a8fde56d1a8f2212a3ce2e562410e78ef2e5f9b4f11a373e95ab9cfcd82a7528f1fe6947bb621558fa29cbff00084bf2ff00611ac927138467ba5497dced42230267c3f3f08cec40750a95353a4604c3dd6ab8fa47c96a5ab9cb3dd1513f202244ab1a51e247219822c9745020834a88ae1d1bf953c3c6263ba0652039490dd0ff0014764bb2c2823b41f27893dcfefde0d249b544d4fe71d6f9447749666635bc7617b34ccd1cfbe502c3a529e3fcbc9dcfc6a78fa8eceb4b8be96fb7790fd389dba4c57a76f8cbeb451ce5583cdae6b1347e6166e5c5dce367470e4c049721940d05c1f17e91cb7cdf2a3cd5e679d209573033662777c6ce78e259b42a6249074902edd3d758efe3ff00ef0af7f8f3fd265b51f8497b5fd669d3080a26a469604067aedf48a0024d077778ca997b3a9dc294581f3f946328fc4ff111503ba13e51f313c3673cb60ec48512006a9a8f460ba4005ca4b3960e4fca2b428170e007a923afe5fa43a9436482580a58b78463379b1936ad9dca94a04a9418241ee8bbfafce012c5f482e96605c830ca480c68b6ab92c1ba34001b530f8aa48a18c5a5b9523292dadd9428c6a4eefd201b3022fa430d304325285311565569e0445874a9c77481b9673f3f4f11b7420a2801000726be105c10ca27a80edabe50a689048373b072f78767212ca516a3905a2ab2c9204a68ee49b1d937bc3862129510c9bd181a375844b805816766153ebc61dbb80be9294daca25bd5a2cae93038154ea05ab41b74ac05325aefd0025efe3135bd41009f893bc2be9aeaa1012cd7befb7ca2537f2801b065014614a1f0bc01b827cc0ddbc7eb135007ba970038760d485d4a3400d9fa6ade11560324d494a99cdb4b968b3bb6724163afa78fce2a491720b5b57d7f08b433048019bbc1db552f1ac1dec8944eea94400c45129d4dbee62d966a58905aa0061bfdf1412ca4bf4a2926a2b68b50e936b07254aebeaf1d3079b1a2bac1972832ecc1b62c6c3c637065ea1ad2a3604240350e3c636fcb0977d4a66efa4b46bd979d2b484b00a3a8021c5e3dee1d24aa47da6d076676bfb36cdf75ce4e52acb8d1ccee1b9a0efddcfb2d3f50d1ed3eb4a552b0aa21f5e064288b9732911e2b5d9ac89dce7e542024907993c380becf9ee5b41f7c7b57e902460fba18e5d21b620fba447d176c13f786824f67deff00ed9b6a33c9ecfb0c352094be91e091bfaa465cb5684a4e820a851da9e70840ee93423a57e7fca18070925d45994050fafc23f3d92b33964d5b25da814a483424955189e8d5f3b462951a9d25601b0352202a633254ca0125c5d98dad78600d497582970900050f3eb1cef7b98bb5c60c49701c300199bc6f166b0e002e2ac5abd6d159b0d2569243b95054561435335436922849376a7df10405754b92544d007d213e5d62b1334b7da2aea180f38331454455440533d08a45449f84ea0a0750d25c3401655492e494b9746903e85e2b0b07ba2a00705ab04cd4d83b101c17293d43ff0038034824b0d330b25294b310367f5585c10b7e7d4def0759028a0a245013a4885d64a986a62188040dcc2213a01d6a0a22cadadbc6919f465e32b6199485ea2424eaea77319d2e71964281246e5985f6ac6952f76fe2626d1965669a966a181a30bbd3f18e95377c1aa7d51b8f0f8e44c41953405ca586d258d08aff00431f147edf5f6114a972b897b65f644e0c4cde1f9ca9d9df3bb94fc3380ef642a513366f11e4f8340ae1892a38bc2ca0f289135092833023ecde5af4a9275ba08725e85bc237461e7e1f11869d82c64a9789c1e265aa44fc3cf48992a6a1634a92a49a10412083420c7df7607b7dc57dcff8bbe25c3e2aae9aaa50d469e77eeebd2eb192e925bd39a5784b2aeb993ebd36a5d09f32574fd68f8afb7c1f89e1e3c75c1b88c87133e4ce92b414920129a6ff00a470ae370cad4aee9a5124dcf48fbe5fda03f616cde0f1c4fdb0fb277088c672d332993339e6df2cf87f046662b97988592a9f9ce57874249565d3944ae7c9487c32c9524196a697f0dbc57c238bc9b113a5ce96a4b13a4a92c00fa47ed3db2ec9f08ed1707876efb0d27538556c34d7df2854b272a3592f5671e8f69c6d38b7168e9d4d1a5382d4507783f9d793f35f49c2936469a84b109a51f557a469d3002cb0087ea004bd5fc6371e3642d2b5243820ee6bf38d12621455a6841ef1237f28fe73e21a2951a8e363cb92b334f20053ecd5600398425882da540b53ed57a464cc21b4870017516a2be77eb14ea4922c412c4aaac63c19c795994b392b20b2bf881677b7ca189a151615eb53f282a04927ba49aa7c7c62b2ec5ea09ea239251762833d52e4000390df144a14b0a39eeb0f178450059c32477b5432546e5c0f8cb0bb4676b636012478104b0535bcbf5803491405241a801fd7ce26b048f84050240bb75685a94a8a6a1c1eeef0cee02002a26c5fab986601810016671572d0834ea0492e6e9765430a9a3d4f75c837dbc3f944b4de7704f8f53aaa4d01000006df8c02e5890751a06351f7c026d555090a2154f2686049d274d0746f185f176040e09b2881450b0837d8dc97363d2181701824955ad5110b357e24d18d84146f802801418962ee142e2f48b0303562ad2c4b864fafce2b090410054d7c4d690c800a989606e4b380c1a378c3362526dd90c6aa64a410477492cd58c9961c25dc12c3ba68417da222592a48084b8a07144d59e33e4e194554661521bf38f4b4da7949a4960d92b610f264254400093625ade5e1e51b830781721904b5053f186c060d4b294804a8efb88e58e1be13c4660b952e44a54c9b31410964b92e58378da9e11fa37673b355f89d68d2a30bc9b564965bf03a68d2751d96e68191f0fccc5cd4044b52d45a8d511fa89d837d9c1da13b71733f2ee5a724b81e76798f5aa5cfcf73dcc35e0384783f0931401c766d8e0952644948d4424054d984699685931df5f64b7b0eb9f3dbdf88705c5b89c2e23967d9ef28cc53278a39bd9c60750cc3dda87bfc0f0f619600c6e2d8292669ff006790af8d4a23dd9f47eecb5d95b90fd8cf957937283909c1397f0870c655250ac6e35294e238938ab1812133732cdf1e47bcc562669054a5acb25d9094a4048fda38a710ece7b8f691d2e2b461abed0b578696f7a5a7ba4d4f56e2d3e6ca71d3c5a9bdea3a71e5e7f4d2a5a48a6ed2abf17a2f397d9bbf23a59ecc9f644767af66af0661e66412f0fcc6e7be6f96230fc73ce7ce7289783c74e52920cecbf24c2babf70c0254e9084ad536604854d98a5161faad8ac58664901290c120da30b178d331448357a91478d2d534a8125cb96fc63f9b78ef1de39dace2b538f7693512adaa9daf2764925b4611568c211588c20a318ac2491c5395e6ea547793fe2c97445b3a7aa65cf97af568c35cc2003f0eabb176f5f9c24c2b0f4f220f96f1886692a525c52eed1e65e31583194fc4bcce0e126c2d46fe90a59648d44b826c01ead18c5fe2d5de02a5dc432165c901dc3104b3472d59dcc1bb84b0ea080e083b1eb115b90416aa82af0a4a41587eff004e9eba40d4920b38502c6b7f18c1cbaf420aca8b172581ee8dcc32547531003b84eec69581a8b0525e9462cff38212fde356a957d2336eeee0b5241041237736a78ff2824259218a89a96480fe7e30a4d884ef520d487da14298302a06d7140d0bf810863334ea15d3fe953378dfeb0bef52cefbb543eafe515120eb00021e8db7478aec129512770d6f9f87e905b9265172d773de05c3fe30757c3a4501f2262a4f78e90c7bae778b424000310475abb4367801287734d4402a176f9c22804d0fc37045cfafca181ab84b16624d6fe10aa402df1311420b81f38949dc0a545415752753b0b5ea6fb402007208269514220b84d19418397b9826a825800a02a2f139be0150291a8281a2be2de2252a2e90185d248ab3c3196b720be97f06b45894905803416d5abd7cba45ad7d814e8043b00a6674efe700a0248d4b0ccf6aeccd19850957780653020a69eba462ab4f404b77451f6f5f285ae809462c18d88b923f58a929095384b06356a276fa45e561d8b860c002c7eb14a98259c384b126a0f9f8c4d9dfc8014923482429c1dc318ac6abb86b10c1fe7580ec900815faa7ac00c6a13de0199d9ef174b245935602ae439626a0559e2c0909170ce1b48bfca02003abba0245ace7d7e516b07006a0a21ea5c1f5e1178ef624046b2480a7bd038f33d2084e927517559ed17809d234a4924f7eaf08a49ab50153872e5b78e9a69b79358dd08c49a3b1a1168c897293b83a81ad1c1f4f02504924b1241a0346a5da3569386331490124ea34dcc74ae58ee5d26de0b30d85d64757eed2c1e385fb53f6aae467625e4bf1373dfb40718e1384b83386f0aa3264d3139ff13630a09c3e5794e0c1d789c56214021084d06a7514a4150b3b4f76a0e49f62ce4af14f3e79f7c5585e16e0be15c29294a9499b9bf1162d4957eed9665b8670a9f8a9ea0128969ea544848263cbafdabbed56e6f7b4ab9d998f1cf164cc570872b38727cdcb793fca2c36607119670665ce409f8a5064cfcc712005e2310cc0912e5b2121fef3b11d86a9da8e7e35c624e9707a2ed292b29569acf7346f7bbf8f3b38d38bbbbc9c632e9a7494f2dfded6efc5f82fd6cd03daa9ed58e72fb49f9e58fe39e34c463786795dc2f8cc460b941ca5918f33f26e07c02945099d3803a27661884049c46259dd450821003fe416719c7be246aaa86dde2631f36c715aa610b35e86d1b23138d21458934fb5514e9f7c7d776a7b56a54a1c3f4b054f4d497253a70c4210e8a2af9f16db6e4ef26db6d95ab512c2d90f98624a8876d2c5cfca8f1b7264e75a9200ee8a1d8c5b89c4952585cfc4a2c41eb1a72960d59c916f1f131f8cebf592ab36d3c1c752449abd4188a94fc566f0fba318b90281f7377fd3e50ea7620b00ce5a292289b861426d1e0d6a8db7930934bda12c5eb451a351bcebe9e16837a350355eb009d2141ddfbc6ac7e51121c6a24e8eae1cde3927277b146ee143bd5c6a0496a35a0eb62c9484d282f4f1fc60061de354a4b86ebb410ce14c40720977dfd5232bb5b90282feed83b076234fa305de8c53a7a07634866012017206e4b18034ea2fa8b595a9fa6d1195d0055a401bbdcd9a0053aaa5dc31245fc2228070a512aef586e2f00a882c0de81c0eec5b093480c74b800390964bd0084a3924bb0b9df62208342e3524daaede460d1d2024ba2a4b381ea9111cec017515001493f201a2c0e48eb63aaa6b080a7f88312e402df282a2e53a812a0682c5a2f1c34c1602588605fc81168b00a2402c19cea2cde715eb480492ceab9decf0524ea7240426a006611b45e30691db05c82ca2972a4900310c0c66cad4e0100b9a00686bb4604b21cdc857c3deb783fe71a8490904003bc9a124bac0fc3fa474d2b2773439cb90a40e7372ac9f8471e65cc1ddbfcf02349e7d009e73f36002dff2859a8b6dfbcaa355e4407e7372a18920f1ee5ade04cf0f48d2b9fc08e76736805b69e61e6a08219db12a8f76acbff085fda7ec23595942c8e0d9ff001021bc3a1f38c05963e0f50cf19936ab2d5ac61cc2e7530bb7818f96d42bcae72cf7457b7e02240312394a122c45ee3ab758ae192c2a49f21129d9832d04861f315a88ec47661906773ef94687aff7df08b05c96d026afff007d8ebbcb48245edf38ec5765e98b95cfde524c480e9e35c301b39d1347e71f4fd9eb7dd6d2a7f8ca7fa713b349f87a775d57d68c1e73a3dc735f9a527e2d3cc1cd924825a98c9b1c3d394412c1b49671451b1b472e739d657cd9e694c554ab9859b922cdfedb3bf18e209c5964a7a5755cda3bb8f3bf10aedfc797e932d5ddea4ade2cc79815aab7a692545213f3fd6285a4778d5428fa814b45a41551554bbb00013e315155e8f5a39043379c7cdcf7b1cf34dec22bcea3bc2ee3c22be8a0e19dcd4fd47abc3380f4274d4101cbc2166259b4d433318e695ecd2337e212ea22ed4006de5f8c03b6e9eb5a1f1f28293414b541340222982810c400e68c437f58cda49e0a8120b6a7a583540f28b353a8f79c94ed522be115866041704b30154fa7304965500d2cce007104fa20429d60a80b50b9655a06aa93e2c6feba442900776bd68fa7d7e7058a9ec0b6a66f43d0861bb2015003486ee92e4051a447259ae010353a89fe6d015670cce1cb3df76109dd0ecc4ecd66bde22d9b01cad6a0124b302490f6a44528b026db0029e64c2d1ca4b00f5adc433bd007657901e30b736180abbcee74a6ea0c428f8c0a950a1a9eee977f081ba9a8c2afdeab410c05dc14d5877af6fbe0ad6bb010963b921dc106b788092523e27a3d41b0860a49018825292188622febe70aa292a4970090e4dced1ac6d74021254482b0c2a18106edf286412e0dd205035ef0a0125c0352e41aa84380400e43eaa0164defe26378bce4d62af966749af7c02295d468281de35bc1289524a6a4ab770f5bc6de4a9c9528697480122a4c6bf81ef2d0e4d59942e6b1ed70f95eac51ac37c9dafecc808e7272bd64b7bbe6370f2be99e65c63dad741384cb94c49fecc936167948afdf1e2b1d96e4fbde70f2be590fab991c38805a95cf72e11ed5812d84c012a00272c9041f294911f69db1a4a3c1f854bc7bff00fda3a2b6793d8ff51a7a89019028555dcbfeb0c40d2349756eee098453d4b6a077058df685428e94356af6721847e6d356bdce52141528805acc90ec963bf87eb0c7bca0953050a149a378458b2c1012295ef06a78fdf18eb4855d494a80751dc5ff0018e4926ddd983612a60540310e9245881e27fa452b00863df043bb160213de82c94baa9a936496874b299c0483f17c83868a9044960c364eea2018066332410c410c28dfd62b364b90082e83b07da0960433508d4059237802255a40a921a812ad5a6210e0cc2a1a4067aa48b5042cc1de2a4b100b3b5e8ce0405290e6e2aead56346f4d6801812e1201d26cc4973588e0f79b51b9a5452c631dc25412a502017a1eefaa7dd13de77941209d41ee0134fc60892f27e2d2e29525e9e3ebac496b2e18500b92ef7b455a92410e4a4004101dcfe958200d241ef5945292ca17afd23584dadcb4656dcce0a4b54eb501addddad4fe51932f10a4964970075d9e34d0a6ab8014186cfe7e30e95b104b382cccf578e984f6345bdd1bc644cc3e27093f0198e1e463b2dc6c8561b1b83c6494e2b0f889531251325cc96a052a4a924a4a482082418f81dfda07f61aaf9298be26ed6fd9738666e2f9139de3579b730f81b28c299b3f93d8bc4add789c3a121ce5136629c7fec2aa6693fe5e929fbc5913e8c4b87666603c0edfd23331781c9f88b2accb86f8832ec0e7390675819b95e679566b84978ecb731c34f41973b0f3e4ac14ae5cc4a9495254082090d1fa2fb9dfba0711ec0716a9aba30efb41a84a1aad349da15a9dfa6fcb561bd3a895e2ee9de129465dba6d4f7136dabc5e24bc57daba33c367897857159662664b9f254908510c5058b1fd638d31b8754b5970431a16f031f67fedff00f61de37b29e719bf69aecd5c378ecd3b33713e60bc471270fe0654cc76339238ec44c2af7332ea394ce5288913d64fb85112d65b413f1ebc4190627053e64b9d2969209b88fd2bb75d92e15a8e1f47b57d90a8ebf0ad4ddc276f4a9c95b9a9558abf254837692f64a2dc6516f6d5e9e092ad41de9cb67fa9f99c62a4050554b0a8497a98c650009f0b0625eaf1aecfc2fbb52814e96a1559edebe51a54d492549a000b3903eff5bc7e03acd1ce9377479728bea6210a2c0b907607c2cf1410a3448deb462445cb04d7551d81034edf842870e5d99351f13b7df1e34a19ca32698b670e4d5d89a40538341721357204310033d010e9a79c56a3d0b814535eb768e592cf91047a9202bc1fac03d5269d039bde1882c59aa2ac5dc40600b148d26be23c2fe115e8981882f54bee1dd8088904b82fe2f46a40a101cb917ebe500952598f75ab5062d1bdac074de8ab9637f5f487152921269425c92056112aa2b52431a7427c7ef8090002c4b02fd0988f45ee0662ca4953a48a9173fa410289154a5ec5c9857a9294ba0ecc290cd43de040a024f7bca368c5bd80c12a259c01617dff0028b912881d49fb5502de10a94955cdaef527ca352c3c90a1dc018d4249bc7a1a6a4eac9456e6d14de07c3493ab5914660412f1bb32dcb264f503a452cc0da30f098252c8212ef501be51d8ce4972978ef9b3c67c37c05cbde11cf38cb8bf8a332979570f70cf0ee5abcd739ce31330e94c991211551248725929155100131fa7f63fb31a8e33aea7a2a306e4ff008bb7b24b76de12cb3b28d17369246cee1fe0cc7e3a7caf73254ca21d4aeea00ea4d80ddcc7d98fb193f677389f9d381e15ed15db4325e21e00e4ae2532b3ae14e55e265cee1ee3de69c8242e54ec7021388cbb2e9c1a8c8c4cf965d265a54167f5a7d8e5fb3d3c07d96b26e12e7ef6cac9b86f8ffb42ce97273fe1ee57cc948ceb81393ea64cc90312a50f779866b2e8a5cc6fddf0eb1a657bc28f7cafa7cc74f4a19082c840d12d340001401bd6d1fa0f19f745e09d81d3d4e01ee77255f89bf46aebb0e147a3868d5ad29a787a9774b2e8a7e8d53b215a145777a6dfacadb7b3cfcfe6344e11e19e11e5cf07e45c07c03c3792707707f0be572725e1ee19e1bcbe5e559164d84c3a34499186c34b010842521980a9726b587c4621c82e456a926a6299d89362de158c252f582a1b59ec7ca3f9ff0096a4ea4f51a89394e4dca526db936f2db6eedb6f2dbc9c929455f97aeefc4c813b5149725cb537fe7142e604b9a383562ffd228d5a58240d0e41db78a4a8a9c1a0f26a75a45272513194adb1695b92e4a9cd59fe508a4d4d19c8abd7fac2a69404006ea507676b560ea0a15aa5c821aa2b4fd6392552c66db7b903249000248a778b8f94312e5c53a8dbd7eb08b2c5212905eb66542953394976eeb01527731cf26db77ea40c4380012b0096ea9f28ab5005c55c31f0e801fcbc62509be961dea53ca00d2a5048604509342629722eae404d829812c6ff002fe917cb2da95525bad098a149d20926ada580f18724900b12901b500e043a10ddd1612e19d2a2ee349601a28515ba8a4b3f980cdd3a45bf13382c0b3967308b48d241497604285ec6b057bd828f888084970e06e03bfaafe10e51ab4a43946ee0bdceff003846246926afa98507ce2d4b1006901cb3bb58ff0048ba8c95992bcc28484966d5474dcb748c8a9008605418972fb6fbde148704e96291702082cd566d9548951e84818862c6a0907ec9bc14971f2ea69b18b7495a52f7d80b7aa4214dd24161524774da2ea177b02a54be9420d41dcc2314d580f03b466ca4802a090d471aa117289008609617def1aaa522dcad95e90535b1a860db57f9c3004bf75e95a92f074901dd859850c1677e8cc0ddbce2ca8487248a54ba160e4160e6f1594cc3505801616f5fa45c25e92090ee6e031305492c4907e225ae6d17ee18e566190125241abd87da3f9c54b24117655d3763192a4a4a8b2496a970e0f9c54b96e06c77f1f2898e9df80e5b2306639514eed624802d5f3b438662e42801425c5ba18b5481de0285e9aae7af8c4d00307b5dc303ebc22ea8b5b8b59d99607ea199ec55aa1404b929a6e407a7e5085694853b86dafe348930a4b5d87def054a57c849a69b085bbd0b5c173ea919728296588d43a9dbd3c69457a14581d37b5446b7974b56209f76356a3de607eef08ea54f9126cda29bd8be4e1cb827634378e2bed2bda67931d8cb91fc61da079f5c5184e15e05e0ec1eb2662933334cff00173014e132ccb70efaa7e2f12b0112e521cd492c9492352ed15da07937d91392dc65cfbe7bf1765bc1bc01c11952f30c662f1b353fbde693b49fddf038090fae7e2f10bd32a548960a94a58b0048f2daf6b1fb5b79c3ed28e754ce25e22c5661c27c97e0fc66230dc9ee5149c715657c37875928398639093a2766588404fbc9e5fdda4996864beafbdec3761d76ae52e35c666e8f06a32519cd6275a764fb8a37c39356e79e634a2f99de4e1097453a6aa45ddfa2b77e3e4bf5977b5bbdac9ce9f695f3917c47c51889dc25c98e0bc4cfc2727f94381c52959570d6196a295e618f20e9c4e6788484fbdc428112d2d2e584a412afc53cd3375cc52895f75a8e7ee8c8ce73833cac85971404968e3dc762964bbb937dc47daf6b7b4f45c61a2e1d4e3474b497253a70c4210e892cb6def293bca526e526db6c559af8385d117e2f18a5951059cd59c96ea3d6d1a04f9c545dc1482c1dc37ce04c9cea657dabe9af48c35a8dc9092ec92cfabcfeb1f8bf12d7bad2bb6714e422894bd497dc56b18aa52aac0746153f282b5eba01506b46140229aa892cc07daa39348f9da9533932735e2020ab4ba4960ee5dc7480c181a002eee0abc21b7ef1767291607d5214174924b96753871e11c9293326db1349764babc59c5e1aba402c0d59fc200539a0a10c400dbc072e0900825c75dede31cf7bbb9046704bd3e10a26c61ba209ef13707be3e77fac048daa376b80d0496510c1b56ec07f482f10302fbd4fdaad40fca231492753bf4a823a421353635a960eae9f387d4583540a96bbc4bf68254960ad201042483423a42972f7725c9627578c30512a3577146ab01b78c42a3a436aa9a834229726215f209524975108eefc2581884294a152412c0a54fe507bc3ed243f7989a988e92d41514292c527c617b2b2057462c588274868772ddd2c19ca8067f13e1108b8d3de672a7de27786ce02753a54cf4da263956058e4a140026d506a29012295621dfc545fd78404d89761b0a387822ff0ea269a5ddabe71bc1e2c5e3b58b925941c80487eadebc6350920824b87b3d7c3ef8d3129256c1c825d9aae3e719f2fe215d40efb18e8a6d266a738f221453ce4e54a9c694f3032c536c7fda53185da0f48e787372e1f98b9b2b5076ae2147f387e48a8a39bfcae5072a1c779630662dfbc23d7ca28e7f2b5f39f9aeaa39e3fcc896a13fe71ac7bd369f08567f0ff006116bb71c9c153434c208292f51bfce30977a3817625e3326dcefd5c3b461afcebd6d48f96d43f4afe273cf72b8906840ea2247315035fc21c29875fca121d0e7ab75735a7afa44adc197288d4f6ebb4762fb2fa81e7ef29810348e35c3134bf727475d509d441b0b0dda3b0dd99993cf8e541ab8e30c39648e889cd1f4bd9f69716d2b7f8c87e9a3b34cef5a0d78afacc3e75e81cdce69a43e91cc1cd988ffcf2708e1a9ca7ab3eaa016b758e5de7139e6b733ca9caff00c40cdcd1ebfedb39e388e63f78971e41dfafe51dfc76cf5d59af8f2fd264d5779cafe262289f84b2b5001c1703a45694aa82cfbb318b545d495b30d807115a75171a9a8e6e0c7cd4d7a5839e77b084b02a3a95a8d092094ff28ab4d569357aa5c800bc58e6a039041a540f168501c9203f83b08c2492ea642820e9052685b4b50f8c02753b009deb52c219c821c3b8670a623c6156c541925fe16a878c9bb3c8f69120d85d4964921d221be16705c0d9b492f1010da49a0a800b8fac3025218802b41d46d0cdae0506a127bca676029048672ee08290c5c03135025bf88b39ee9b5a20d4e436800b91b1fe5136bee01ad44104a4ac800f783c21674a47f0b90aa8862c490f505e8e5eaf08417d4753a892e4339f2f5788b3d9820d20eceec45fa6d052ea2f405fad20583d6a58326b78228ec598b546a353116f4b20670081de657517f94420f7a8c5bad59ea215c921eae18bd48f3e90e09724b92d7d5530b5d79816ba92069274f5bbbc33021f48721dba758094b162486a10a37f94415b52bf13ddfac6b1c6db8097dec18953f8ede10db900d36afc5e7108a9776164925842849248b0ddcdfce378ec690b99128ac10400094b24036f18d7f2fd456002410413405aaffac687292400ce4a43f78b748d772f5a8a92593a89724031ed70db77d1b1ac2d7bb3b8fd9693315ce3e568921cab993c38027607fb772e6fbe3daa427fd8b2e7a2bfb364a54f5149488f16aec8124e239ebc9f94ce17cd3e1741a6c78872b1f9fdf1ed38b967f72c230a7ee52924794b4c7e83db8828f00e092daef51f47727654b5a0fc9fea345002896a04ff0016d5bc164a127412956ca357f288a0ad4c487258806bfd7f482b0a425ca817490826cf676de3f2ead86ce37b881ea8512971ab506ab5c7abc63a86a1a940021c30530f9c3a811ab502a614fb2dd096e958a497268e40d3a90e123f431c33dec632b5fc8a88093a404b949014093a620153a815101925e95bbc396d4015a5c062137ad6bd3e71595142592494aa8c0b911428bcc0af814cb2160b2837776a830a8242c10a3a5554ec4d588fca02cacba48751aba6cafe63c3ac42194483460a4a988092054b74f3802c528328d2cc01351b7e70aa503a8153d0b94d40b5a108b289482a439d2974b7ca8c61574241551434b7f09d8fdc61b1202ea081a41d21f495692d7707ef8a48d3562106a5455a96aa5ba459ad243972428259c82eec3ee1054c4b83a141d2971a93a48258f93b4081758290e9054a56a049eea6be5e9e1b592a01d2f4d468c05683c7f0852427bb5014349517249f5d22b659a3380410ee0a9ae3e70253b190852941880749749d5a7578c5a3502c431d5f0bb7d2918c8203b851773572d4dcfc8c5fa8a5cd9ce82145d443da3584ad82ea496e5e899a09057455d8b817f4d1989c5368215502a0de34a2454b50d8825fe9112b2950480c08ab9a00de9e3a69cda65d3b651aae7394f0ff001a70fe73c21c6193659c47c31c4996cec9b3cc933ac1a332ca735c2e21065cec3e2642c142e5ad2a295254198fce3ceb3dbb5ec30ce3b1df13675cfde416458fcebb2c716e6a679918696ac76379338dc4a8b6598e5555fb8ad6a6c2e2954014252cea092af450c34d08485befbd4a6bebe91571670c707f32f83f88b979c7b90e55c57c21c61934ee1fe24c833bc1a71d95e7383c4cb54b9d869f29418a5409adc1008208047e99ee77ee835fb13c42a53d451f7c70ad45a3a9d3b789c7a54a6f6856865c26bce32bc64d1dfa5d52a2ed25cd07eb47f5af068f0e3e26c827e55899d87992d40cb511de0df28e3dc4c8624e93e3bea8fac4f6e47b0ff8b3b0a716e379bdcabc2663c59d96b8cb3a549e1fceca558cccf96d8bc4294b9791e74407d2ce9c3630f767253a5444c0caf96fcff269b97e226ca9929402491df04015fc23edbb7dd8cd0474f4fb4dd97abdff0009d47a54aa2dfce135bc2a41e270794fc534ddb57a454ed5a93bc2594ff8ebd1a38e262011ddd77a8342228252ce9a0b6a3423d346a58890a4a98162284170f187eedd2468600d4d77eb1f836af4d2a52cab1e5b59b33194527bac40a07bd6114c40d56db48afd22d5274ba802ec2ea6019e2b22c6849ef3b9a4795386e8a35613e205e87a8bfafd2142989706a1806f578b3a872012e0355fce0174b92f66018b01ebf18c70ae990021854020b825d83bc40fa15a8051d346da0242be2a2aac028d40786362c1bf898d4443c62204510e9a5eb50c4459aa840258106ec03c2dc82c05d8de910dea59b7677fd60af740b13dea391dda51be70c00d41c005aafb584225c815aa8dd9be516949bdc33bee63a60af92d15765f28052a95a554ec6f1ace0a5152d212e6a3496a98d1e492ad2c1cbf8831b9b2cd3ef00482a5b7c3e27a98fa2e1345d4ad18799d14e3767e857607ec23cfeedffcedca7919d9f38413c49c533f2f3c419fe698fc6232ce1ce0cca65e224e1e7e6d9ae295feef0f2d73e523b815316a5a528429463d3ebd957ec66ecdfecc6e04c066395e0f05ccced1b9c654997c79cf2cef2e4271fef161e6e5bc3d8656afecfcbd0aee84a099d3b4ea9b3144b0f96dfd8d3e06c4633b41f6d0e612c9385e1ee4b70df06a8b1aaf37cef138f64f801937fe947a0162e7a66cb0cfdd012039a00f1f63da3ed0713d168e3d96e1d2eea8ce11759c713a9cd76a1296fdda8d9f22b29377973595ba39a73bc5622b7f3062b18b4a8b2c9d6a725df4f908d1e7623de3babbd535358ae64c51043fc9ab68c3234ab53b020b1b25cc7c3d3a518c5789129ad873de21c3d194e6b0aa5542416604a835006bfaeb1595960137076b18a8a9534b9a1034916a3d07d47df1339d95d993958709492144172a70e683ce154a1b16041d409865a999f50203822a0758a829e8c0837725cfa67f94704a4dbbb33224a880e9034961fea82ad49254953167506f5d7fac03b8496aba8fe862024a8298a53a988554c65297811d302a892007660fe34eb01dc821c6abd18c064b53bdd40a7cbca02414a839fb3449ad0fabc6772bcced77b8ea06c49767009a286db41480c00480ff0010724c4ae93a9dc9a17fb89881f515000a8ece4a7e702addc2aaf46dd4457d7eb0d2d04825bc83de200c4289d2a2e0a4dcfaeb17a1694805bbcc6971e0f12bccbd96d6144b214050003e6618e9d412cc48d2c7a41136a9f88a812f56deb19004a59096256a603c4d801d6378d352c3c16ea6399542c02482459c1115194bd4c1835c3dbc0475878ebb79f622e58f19677cbbe6276b3ecf9c17c75c31884e1388b85388f9a59665b9f64939690b1271521535e5cc0950250aef25c38168db27da43ecf400a8f6d8ecca0b395279bb952be7fef63e874bd96ed0ea611a94787ea2506ae9c68d469a76b34d45a6ad9b968c64f64dfc87731292c0b12e18d59dbac59fbbbf5ad04749d3ed2ff678cb204cedb1d9ac8764e9e6ae5aa7036a2e35391ed27f67acc4ba7b67766f99477ff1572d49f9f7e3d287623b60d5e9f06d5bff00f9ab7fa0da146a357507f33fb0ee54b96755890294fd6328e141008487377a8ac74d47b493d9f2963ff0c8ece2c6a1b9ab9693bffafd3464a7da49ecfe500a1db1fb39b5037f8a796eff00f6e2dfc87edc7c1e07acff0095adfe8365a5aeff00a297f75fd876f552c82425340588358064ccb377486ad879475347b45fb032c829ed83d9ce971fe2a6563ffd678c327da27d828280ff00860f67753fc213cd3cb14e7ffa65e2dfc87eddedf70f597ffd357ff4175a4acf7a73fee4bec3b63fbb287c49276146829c391ddd2fb960408eabff00f043fb08005fb5ef6786b7feb53cabff00be4147b42bb084d5012fb5df67b596661cd2cad8fd66442ec4f6efff00f1359ff2d5bfd04ad2d6eb4e7fdd7f61da75482c284005e2b5485b1484d3a91de31d681dbfbb0d253a8f6b3ecf6d773cd6ca01ff00deb18dff00c105ec29adbfe16dd9ef53513fe29655ff00df2263d89ede378e07acff0096adfe821696a358a73fee3fb0ecd9c2a9894a4d2c14189ac52a907ba4a0050dcd488eb9ff00c3efb0d14eaff859f67a236239a994ff00f7c8c53ed00ec26496ed6fd9ec96a81cd2cac8ff00de91a43b15dbc7ff00e0b59ff2d5bfd04ad1d797f453fee4bec3b1e6582140a684f4b4533641d9f4fd47af18eb5ccf681f60c4ab4abb5c767c49172799d9617f2efc567da05d831482aff85df6780905cbf34b2c07ff007a3c6bfc89edd4732e05adb7fe96b7fa087a3af7baa53fee4bec3b17365a99ab43d18fca1112a612a4dc11426efb18eb24ef683f604d475f6c2ecf09205bfc50cb4b7cf5c2cbf683fb3fd1df3db17b3b52a7573572b469f91991b7f237b68a379703d67fcad7ff00413ef4aeb7a73fee4bec3b492b0b35454853d054b3bf846c0e79f683e4d7643e5071673e79f9c6182e09e5ff0006e0158cc56331475633329ccaf7383c161c77f11899ea0112e44b04a94760e475db8c7da9bece5e5df0cf11f19673daf790d98e5fc2d916278871395641cc6cbf3bcff32461a59986460f072d6664f9cb20251290ea52943c63ce57db1ded8de687b4cb9babc42158ce06ecfbc0d8c9d86e5372b25634a84b429450ace738292133b30c4240a553874112d1f694af6bb39ee7faee21a89ea7b634aae8785d1b3a8e7074eb556fd5a3423349b94be154b38528de52bcb9213a2838beeea2715d6e9a7ec57fe3f564fb5f7dafbcd8f696f3731798636763b82f90dc1f98ce95ca3e544bc615c8cae40d484e679a049d13f319e9aad6da65255eed1404abf0a735cccaa62ceb24d68f5898fce3de39d5a8dc0ac6d1c5e24a8a8b315161b98fafed7f6c28d6d2d2e17c329c6868e8479295286234e0ba2eae4db6e7293729c9b949b6ee4d6aca49460924818ac5955353a9ee368d127ce0090e9d2db6d0f3a6ba4006a4ef6bc6993a6b90c0053779cb13e11f89ebf5f52a49b9338e7222a6d4b330b6ed18aa5906e585439722a7788a502cc00352a23e23622108a1037d9cb8ac7cf56aae4ee64df560d45c96510039a3953b42ba490a167f86ef101a501200600125e9d201d42a2bf64b54f908e293b2b994bc58d57a004d1882c7cbefbf842d146ae9d468137348424a74b0292d77a7aac414d20d1c5dc8dbd5630727d4a91c2955a134636bc3268e6a48351723c5e1413b10a20d091a89ac302188234b8b9516545317012a6a0052d5253730809ab820155daa6b040513a893dd05c13e505235283d492e589207978c4aba01513560686a3f869b180028a411ddd94a258a874864d02a8e126c5c398661dd2a4d402c01b79c30d58005dc9ba9801723f9c3129058b8029672778465a1c803a850b8fe70c1ca9c258b50d444c6f7cee08ef44a4545cfc43c21436a623482058c30527bd40c59c92401d1a11cd3528b3e9636f0f9da222b3817c85f49d2e4a5618ecaf9c00dde6502d4ad2084a812428baaa48a08801d454425c0a33907f97eb164acc164b3a882033072a4a69e7fca1d21d562c6ea6adfa40482c1dd2e9d40076ac58970c6cb20d5c9de36879178ee3a005170904bb1068f4fc6d19a81a348625af5bf87df1861dbbc3e2a9634207e51972c92faaa0d8870d668e8a7ed35c743983920e79bfcaf00e97e3acb8801c91fe7a778ab9fa529e7473592937e3dcc6b71fef6bf7bc5dc8f1a79bdcaf72fff001eb2d556ff00f384fa68c4e7cab5739b9aea02bfdfeccaff00f9750fca3dc78e0f9fc67ec22df00e149c96512ff7b5e34f5595d5e33e785559c57ad630164b0046f7ebd23e5ebddcae73cfd62b8910fa6891ce542687e7d286192ee0deb6fac2b9372fe6619208241a7cd9e256e81992ecefbd7c23b0dd98c1ff001eb953a85f8ca45f7ff2e7c75ea5925490f466f0263b15d97c6be7f729504b83c67871e0feee747d2f0076e2ba57fd653fd389d7a6bf7b0bf8afacd2b9c409e6b73454c1c73073704f43fbecf68e225a5924d91d59ebe5ead1cc7ce2a735b9a40803fe50b381de2dff00874f68e1f9c0b28ba4d6a90f4f55ac7771cbfbfaadbe3cbf499355fa6cd3e6518809008f88fc23c3f94529533920d114fbed17adc3b6d5ef166f28a0bd085514080c7bc9a5dbf28f9c96e64d27b8a0d400455f67d300a812ea50a0d35a802bb0f9c465021c82157068de70a0554480db911cf2b33160296a0a9165dde14b851753021880011e0f05ec146d5bf9d2238d445189a69afdd195a2caa01205825c3574b082a3a80ee80e5c7ce109093425f71bc329881648018006a7ce2aac8926cc5d4e7bcec76b182090e9068ecccff7fd2096535bbb53eecf8456a5024a4f7349770fab6bc59376c81cb249d1416240afabc1482082a06a283701a2a76502e9208a14d3493eaf1682c1829c8ee93f8b430dec02904bf7833d458a5ba7ada00aaaca7b85120902b5fe504b8034d1a8c697f5f742972d5a0147a1de1776f3016487a0292188dcd3ac369753a54181d21855ba7dd0a0a9403e976624966a6de30c084ea400082a7717872ecc01e802aa5dadb413e090c76b1827a1d567a9a26ed0a4026842547fd54112adb82c0f47b8e81c86ab080120848701cea0e1ceef02b466d36d4ee14c6b0c91dd7734dd41892d1d51e86917d0c900920386762c011b46b180705c6ca663578d2127469d4eba506cde5ead1ad600d75062a760976f9c7b5c31deb44da1ba3be7d8a70fef39f9c992aef13cd8e15a137ff8c59547b454da6130c4d1b0b2d9abf607af9c78c2761f97abb41f23c14aabcdfe134149177e23cac347b3ecd48384c392ec30e8200dfba3d7ca3f4ef742828f663b3cd2ddeabff60eeac972d37e4ff51a013a5654c417a81dd21fc7f38a82c0294b254c180a53c6b0eb028129ab9704ecff009c63b94a89538d4aef100151a5dbf38fc86a5b279e328b15970a010c4581a866fbe280900b0d2ca0ec0d2fbfcdeb114aab28393514bf888a815052d4903e1ef027bbeb68e39a56b949a5b962c2490406d99877e2958504bb25214a6530ab7abc399c5497582149aa48a835de295a96a55480f623f031999fb46a060c5ae08ee978aa62c82ff115a9cb37a6f185529495775dc829511670d68a9414560062e289592906b11d4192850f80072120b330fa7e514a9545f78ba6a12aef16a7c30c909d282104eca757792ff8c159aa8e90ad242421fe173f743041433975125418926a7c01f1668842c92a960017ee860035be9b43809056353023594dc03d408472097b905490977496b7dd780d8b75a26d9414abb28500f07fcba444a44c006a346624375f4fe515ea25495ac14949d0da77dbf0fbe1c11a524ead695bba877002f4f28018684b80bd41c92a6623ad4c544a7bba890012525550cfb81f28b595df2c06af840ef3d0357d5a2a50a975a480086b5fd34013524b120a4afe15166dfe978b082970483b8dd56de3165a95a4eb527ba5c68a8178b8134ee94bd5dfc3ee8d233cd8b45bb99485dbbba9e80a54194496af48ba5ce52149290c1cbd7e1bfa78d392a016429868ba8548aec62c135c1725bc13a4c7553a925e92364faa30b98dcb7e5ef3cf97dc59ca4e6b70d659c61cbfe39c96770ff116439bc813f098e91392c417aa5692cb44c4f790b42540b88f348f6dbfb14f8e3d9fbc7f3b8bf8364e63c69d9bb8ef329aae01e37386f7b8fe169ea257fd819e948d28c42127fc8c4511899697a2c2931e99b2710b4a85e80122342e6ef277957da57955c5bc96e7570ae59c69c03c6d952f28ce726cd10e169503a26ca9a3bf2a7ca532e54f9642a5a92083d7f53f73df74397642b54e19c5693d4704d4bb6a2861b4ed655e8df11ad0f6a5522b925f0651eed36ad53bc2a2bd37bafd6bcd7d2787867990cfc0cf5ca9f28a4a54d66b46d39b2b49603456d607cfc63e91fdb3fec7ae61fb3c39bd8c97829398f16f22b8d31d3b15ca7e644dc377b1526b33fb2734291a11986193dd533267a122620075253f3bf9e6513b033a64a9b2c852545946847847d17ba07612970b8d1e35c1aa2d470cd4c7bca15a29f2ce0fea945a719c1da509271924d32355a5ee9a945f341aba6baa3644d402ea208ab81f9c62101241018350131aacf94a47c42a430d87cbc634e5cb2120d43549168fc3b53a795293ba3cd92b6e52a6670f6a0b8d87a301ce91dd2481a48352218ea2a00a6e28c5b5429046c407ef2418f3aa2c5a251803066a7798aaef1030a14a7bd43bbbda23312031482e1cb2a0d4b874802a412ede46324ae089d214c083b333b0864062a000043904b1060001d5d456f41105092039ea4961117f10588ad0d1cbb0f2fe9111bd598b0342d6800f75210d52c49bf4870e2b4005c26e4c74d39268b470d24654a0403a7bba8b1f1f0fe51aee5aa289c97f88de95b6f1a0cb6003dca9d2496f9b46e3ca51ae7cb2199ea4ed4fe91f43c2e5275e1c8ecee8e8861ab1e865fb19dc16993c9eedabcc59920cbfedfe61f0c70449c492c277f666578bc6a9007fa4e64eff00ea8fb36c603296a092e047cc3fec93f2fbfbafeccde26e3928284f317b4567d8f41662a4e5987cbf2d04750f2951f4df98e2354c590e01fa523a78ad69ea78dd79b7b72c7e58c229fd45e94df7726bac9980b5380c756f5b1f08c75ce0c14a291fe96fbe2a54d5977fb3f0848bc50b51253dd60d5268f58e2a8d448be2e59de50550693e2c0dfd3442e13a59293b53e2a0dfe514a495380e121881af518c84a886ef38dcb5bd7e71c339f31985c96a6960e2b4bff5ac565406a50605034a9228aa037105445194a4e95774034a9f5f58559068a3a4a4d85092d63f58c2643ce0286663f110e9b0bef014e95015046e4f762a3acbe96041a90ecd0ec450804dca89a0f9c679b95b74658053e204b6a0ddd07c203b904b026b5a1f5e11650eb0e0a524115a90d7f384052901206a51b1b01e710f2426f6094b07f89d7f28701200b3873d7e91595e96a9b55c8004631983621ed42e07ce2522cb632758d7ddaea2eecff7c5b316522e2a87240f862992120a4bb781371bc74c3b75f6ff00ecc1ecf1e53cee6bf694e3d91c3f87c4e1a71e0ee01c9ccbcc398dcc7c54b4929c264f96950528295a52ac44cd3265824a97463d14294aad48d3a6af27b20dd8eda67dc59c2fc15c3d9cf19f1cf12e43c19c19c3381999af11f16f14e6b2323e1ec8f0b29255367e2f173949972d090097510edf28f857f6c0fed40679c6b88e2decfbecdfceb1fc23c0889989e1ee25ed3e9c3af2fe30e3496c64cffee949989133018458d6118f9894e256956a96995431f887ed54f6e1f69cf697f126639066f8b5728bb37e5d99aa7705f21784b3398acb972a5922462f88f1a34ab32c6a877d45491225a9444b96c013f88189cc55355de5a98d2a5f68fafd1d1d0f0651d557b54d4744f3087c8fd6979bf45744dd99a28e39a5f31c8798f18e3336cc3179ae6d8a9d9a66998e2a663731cd73498730ccb309f354573674f9f3095cc98b512a52d64925cbc612789541612944966a3c84313f48e375e28970090a069578ad38a21417a9d851e8047d1c3dd078cc64bbbd44975c49afd66aab49592672fcbe2a52523b920354012100b36d4feb1908e31981474a64948b91290df84710a718a5070a3d2a5de9eab168c6b135ef58bdcdab1ecd0f74eed0c1270d6544d784e5f69a2d4cd2b5feb39a91c7130693a50086007bb493f87df1988e389f7696f7632d20fd1bfac708a71a1c0d44901c33968bd3986a51ef1a062050931ef50f760ed646c9710aabd9525f693ef9a8f693fa4e74471ee265b9d32c837ff292c6b7b5a3365f313112c8f819bf813ebe71c0a33153901448dced0c3302405157fd96702f1ebd1f76bed9c128ae255bfc497da596aeaf497d273fab997895249ee8ab3e84b11bed191279978a0cc425aa06848023af69cc6e9715a872ff002f38b13999762a2ceef47feb1e951f774eda53c2e2557fc49ffa8bfbf2b6ee4fe73b1e8e68e3828b4c430157427ef2d1988e68e34d4cd4b8e894d3ee8eb28cc945c6a01c5de2e979a2935d44528753bfafca3be1eefbdb54ff00de75bfc59fda4c75b596f37f39d9c3cd0c780409e1bc5091f94638e6763d249139201a11a526bf48eb69cd15ff008d2594e58b41199a9fbcb2ccc9d26bf48bcbddf3b692b29712adfe24fed355afacf793f9cec74de66e60a7266a0804d34a4fe5180ae64638820ce452ac109adfc23afeacc8904fbc3dd340ff0010f18c639928127de55e8e7eafeb68e3afeee9dae97a4f88d5cff593fb4afbeea7c67f39cfe79878e51054b404b33e84fcb6b46958ce3ac54d2a519a83d4e84b0f9b563858e68a500359762c905dfabc52bcc894395f75dc6df38f1759eec5da6d45271a9afaafff00d93fb4a4b5756d893f9ce4bc5f139c425626094a5283a57ee90149a5c52f1c7d8cc615a96a2b73a88a9a7cfd6f1a52b305380092142a371f38c0c462492e08dcf74f8ef1f9c71ded96bb8c72cb595a5392f8d26dfcecc2a559495d9993715aecd44b54efd634e998805df49a549624f9460aa7a944a49201152edabca29753124826c7af847c1eaf88caabb37739e53bab21a6cc492082024741ebd18c42a258dca8d751726196a6555246ae9478a8904004b02280166a748f12ad67376326f171482144804806c2d07704b853b106afebf380a2a26a0decf40205827554d4000bef1cb29d9dd9594ba0cea0155237497a13e1fac2289254eafb5572cedd4fd6149bea20a825887a8a52239ab93601f716f4f184a4f7666421ddafd0dc440915ae902aca3410e3becd701dbed1685673ab57c55601c08aefbee029dc25852aa018c000962482134200f3b7e9028492976662fd6222e68188a56a0c461e7a0ba055d98b6a661723ac44b0243e8d2aa915f5bd607781254c40e8a23a43a40d552d5d8d0fca2beb4ae07701c90cc3ba1edd2012ab5086766aecf0b50e6aa6bf44fce092ece493b6c08a44ddbc00b92485268483a41610f563a5f500c1ea19acdbc561e942dbb53e90f77d2b64dc021cfce26f2b003f7188fab0fac400b90090a6a034f9c05396258241f85e820a48ba8075064f51e3167b019c1214495023492a63a6d5864a402f62033ec5fa428d292496a52a5c18b854eaee92c004805b7a44af304d24692e425995fe810494949d2c14a1dd70e4f8080146a93de6252fb379c3b2684124a455ecde0d1b44b218383b926e47d96fc7e51972cb3e962db9a031864519b4bd12417263264bb90e2da77240fc23782ea6a733722d267738795c9019278e72e04dcbfbf1ebe9189cf91a79c7cd5019c71ee640b51ffcf54677229a5f38795aa2aa0e3bcb490ccdfe780de2f1a773de61573979ac48651e606666edff00842847b4ecb8463f19fb28bfc0385e7300d6268c43c69ead80ea1b68cd9a5f50292e6a1bd794612fc0b3d2b68f99af7e6bb39e7eb1590dd0f88890684f79c6c4c48e66ec540c4876a0864393677a5614924b9de193e07e47aef168bb340cb966805cbfdd4a3c763bb2c77bb42727c00c55c7185475354cd14fac75c25eab0663523a7aac7647b297ff001c4726c382dc77847ad2d37d347d1f014d714d2ff694ff00491d5a6c5585fc57d669bce2ef735f9aae037f8879c5771fedd3852387a73f792ec923493b3b0348e5fe737feb58e6a86240e626722e1c7fb7cf68e1b98492caa105dac9a002b1e871c77d756b7c797e932f59de6edb18f3080482e400c7bd46ea23148b26d47048d469164c723a25cd48a9ac56a04904a8bb8d3a6c5a3e71ab3b18495d5853de15bf5178604f4241b359300f7aa4906ea55c9853dd3ba4170750d20fd239e6964c9ab005097014a22a0171e109ab6715ef384e930e592c032527701d5e508412407727c2db08c9a76c901d6e4d0060c091530013470cf4f3ac1f303ba3ba5550600b552cf7245fa5217c6001c075330eb6bc02186d5ef3ddb6fca08041d40f8386006f113bd4970fdd0e4758ae5e4008147218786dfa45840d258167a310e9bfaf94290004dddc1d2778b12557000d5770cf4a078b2ca028b82c49292e5d8fce053725245944bb439762da4a89aee7684700050d25d894b5479c467660800046ea1535bd2f0c14c5c82f605ea01222316274a41d9fe2301409655deed430bdb3b02c490f400934093526f0fa438003a903bce59e918e93424b171bd481eb686529c8160da5ff008837aac5a3e607172a047821341e604025885b066a8361d5bd6d11474962776f2f9c2a6a6e7e27d0d411d304acae68b1932e5d4a45546efe0c291ae6594980e9aea7a9f1378d1a5821c949151a546ade0fead1ace04b2d0d7b103ecd7ac7bbc2ff009c452f13586eae7e88f615520f68ce4502155e71f08802c3fef972ab47b3a4f2061259a06929a9dbba23c64fb0049fde7b4e767c90a034cce77f07a0f42fc4b950b7ce3d9a31093ee522adeec01427611fabfba65251ecaf66a4fabd5fd0f4ff0069e8d65e852f64bf51b7e6a8956a4b8ab3d89af48c198bef3a52e0774b9209fd7ac6a33259d4e53be96156e8d1a74e413334a980501deb38f3da3f19acad3b23cf92c89a9493a59c00c14e1d8f84001284fc4405b84b9700dcbfabc56c351d52d2ecc9700801ef0192102a9d4a0432ac40dbcbc638669b329a6f24d6ec41a36a2e283f43fac2b6a0080bbd5c1483e115b929241b900a0500f1820e90c4a53ac777507497f463133b0b316c90929a11a92a07bc76ac5009aa75f7855d4357cfce1966e28a20312ab1e80f94225296d43425aac454dde9f5810586677198d2e1da135152924a88d43bca09629b5fc36f9c22f4a59d813f68d4a69164b258906a9b743fd1e209b8ec3bce91b202802a3f33d3f58ac8d20bf4625c96f9fe7161502c077497702be26004b107569480fa01ef1f975312404ea034b106972f47828d5a14865124dd4cc1bc7af8784555040514a54db17a3d21c14314900d75201b935802022afa8ffa52580a7e058443a40d4a1505ca00737b7f3845129a8252542847d871ebee8735097048480926ef0052ba850048d75609008f078ac2b512972e9152f6a0a7cbf38698c13ac1d27750dc0f42be318c4875008242ac537553c600c851d2543e3218e949a9aede5110b524135a974f8794529d45c2c328283905c8ada22aac28b049ef3f786c088d21371c168bb19826005c02fbd4d7cbd6d1a9e1b10a4ad2a7649a02e401ea91a4205524ef57dc0a3c640568aa08000b8adfc3f28eaa751a9268d53ca68da9da0fb3df27fb5df2678bf911cf5e15c0f17f04f17e5abc14f938a9606619462349fddb30cbf11f148c5e197a664a9c82085218ba4a927cb6bdaf9ec99e687b3c39d189e16cf6462f88f96bc5533119972ab99b2b046565dc5d8296a75489c523ddcacc30e95244fc3d2e1681a0d3d57a4660b95a40569536c6ad1c1ddadbb2a726bb73f2278a7907ceec8a566bc3b9f4a18cca7359529033be0fcce4a543079b65b3887958892544382d310a5a14e95111faefb9bfba0d1ece42af66bb49075f80ea5dea53de5a7a8ec96a28784963bc8615582b3f4a30947d2d1eaa14e2e857cd27bf8c5fc65fad753c4ef3ac9e6e0d6a050cc48208b7946d29d2880a0c585df7f9c7ee07b533d977ce5f67ef3c33ae5c71fe4d8ac670c66066e73cb5e6160706afeec730f29330a5189c34d034a27caa4bc4e11444c933058a14851fc66cdb2a9b869b312b4e9624374f5e11dbee85d82adc0b531d4e8e4ab68ab4554a35a0f9a9d5a72ca9464be669e6324e324a49a32d5696549df78bca7e28d90b62490082451ce978ad4961ba83397319f3a594a8ea1a459ee3c8c612ea5869766506b374fac7e29a8a1284acd1e6356762b700d2c45756c3c2230624d00f8401580d56367d2f727d7e50cea492d7b17b103d7dd1c528d9dd90caeec37357b010c5741b07d203ba8def0480684242817dc136a456af8807720b9dc0eb196fb02d7274a8546ab33b0022d177abbf58a83d59d26e5c522c05c559cfd4f5ac6f4fc898e1dcc894c1ca806ddbbca1e71b972c5944c94c492486205768db0849352a48d56ad4d6c235eca5691352a3a8842496d980de3dce1d55c2a292e87441da49dcf5aafd9b8e0b5f04fb1cbb31cc5ca992bfbf38be23e3b1aef306373ec6cb4afc88c28223f6b713375294e1aac1360abc740fd93fc18395fecc2ec1fc1a1455fbbf665e19cfcbca324a559d60919ca8149dc1cc08f16263bd3327152aa4126a0f4bfa6f08e997a55ab577d672fa1b5fa8986292c1145d8eeee58b3fa78ad555150a280aa5ea1eed14fbc76146d552d586d49214c52eeda55f65bf168e3aef18643bec38584a49496d9547291ebf18652c014f85bab12629433a8302e012afad602dc25810438662ef4148e378c955b5d97998e402e1edb94d7a417d4ca00d7ba4aaa41ea7f58c60a2a51775289d2eab3ff28b90a0949d4a75354b1240aff48a498c22d490077c1a160525b5c380c45802750ef3815e915152585454501bff00281acbd0076ab6f19bc95cf546485307426c2ccfe758c752c80cd5f0a8022d97de480924166001eefcff00945ffba89849294bb3120b8559e911b6e158d3c1241248627bbd5e2b0eb9a2549499b3a6282532e5875289219878d3eb1a7715e7bc3bc1d90677c53c5b9f647c29c2dc39964dce788f89b893339392e419060e424ae762b178b9a532e54b4241256a207998f847f6c27ed42e619f1e2aece9ecd1e24ccf87f87973711c3fc63dab65e11796712f114b015267a38325cc02661242cea09ccd694ce5a595282010a378abb4916babe0fdcdf6b9fb7ffb3cfb377059ef29f9629c979f5daf53839b85c3f02e0f304cfe03e55621482256238ab19294e66cb51d632e927dea8a0059940931e6a3daafb5f7680ed97cdbcff9d5da2f9959f73278ff003e9ca54eccb359e5397e4f87d4552b2fcaf0493ee70784920e997879290960e7529d51d7ace33ecc339c6e3732cd71f8ccc732ccb15331d98e6398e2e663f1f98cf9ca3326cf9f3e6133264c98a254a98b51528a892636d4d98a2c49621c2a9531ea42b52d2c12a0fd3eafc7ec5e442c3bbdccc9b8b52aca2d70a156b83184b9c5dc07d43bc5df6fc228f79dedc17161dd1e71412c494a8dea1ff08e2adab949ddb2252dd32ef78a20bfc5aaadd3630c998428177a6f63ea918af574b0d883687d6e4060c9f0a13182ab24ee9946fc0b93348bd41fb2368b533ea09077297aa7eb18a4ea66a01572c1be504a52da838492c48a907c6348ea249ee4a68cf1394ce4d4aea477587aa4326704ccef152410c0a877406a39fce34ed4400926960c6b04ea059ca98301bda3a61ab9a7b97e6c5cd5533d8ad414588a826f5832e7174ab5e9ab6977268f1a4ea2090520966a1b56d0c9596725c6e1dc91e11bad74ed961b68d54e2144920bbdaaec3d08b04f2c0b9bb0aea68d2bde07043f549b066bc5a55a982767760c2a62eb5f3b6e4f3a334625441a8bdc547d22cf7ca2c1246a15d46cccf1a67bd7a92353b127ed40d7a493aead426805a2eb884b71ccb735744f0aa160ca622cfe504cf5105e9564905943c3cff58d252a5ad570036a725bcc986054cda81d21dcaaa6bb7eb165c465b5c9e646a9fbc9496a971b9a8f18abdf07417720d46c634fd6a7517234f8dcf4f330bef016209adb734dbf1a4525af93ea4a9bb60d4d53c28a947ba92037d97f08ad735c02e58540ba898c2f7a4fc5a89008493b7480998a097154be977b4653d64bab1cd758324ce53b581ef52c98ad730a8543bfc5b7ab4639537449d4f47f5f28abdeb9ae9d2f42f6e91cd3d4c9e087b17fbc256407516a1eb084800953a54f77bfca13605c31b180aab8212b533bbbfca396551956ecc605c901cb0a3d0d4c44b05310ed4757c4217bc9219c25c172df7c2952d4c92ad5d49abfa68c652cee677698c54e094d1468771531492cec1c5fa35da1884121c06ab30ef1f3847aa8387776d2e0d4ff0028c79af845426c05681dc24bdad10173dd0ec082c1dad7fa4297a0008d89163e710162a624173437368cd5de00417340fa52edf743136d36bd0b9b42a1b49046924d458188ce5fbb7fb5420888cbdc11f5173ddd5605b578d62000696012373b7af1f182a049d403ec2b0006091d5d86c22df0804972c5218d0f4b0882ee52351eed450d6d1188350e402c05a092a749236203ed116f9c1010010ca63f155ef0a40a105d2431049004312ad3dd3dd5514af958c2ead43703500c2c3e5057c01b554537664866864a850a53604106a52eff00742f781009242bf86840f1827bae05090cc378618f68486400ce08255defa404bf79c1019d8fe305890431255574f417fc6094a680004bb38a9fafe713f28202140920066645b6bfe50e0a77a101981668a5453a98900b8258134f5f84580827bb51b05562eacf605e430bd2ce0d4c36b70c1981b1151e71482082d4a51291bc5890a0438049a925aa6358a65e293cb2f407501a54e9ab28b000c5f2c21249293f11d5d1566fca3112492595aaaccdb7cfe71992943490c6d56a901ec4f48de1b9aa78399391cad5ce1e5700e5238eb2e607ff00384bc697cf527fc65e6a509278ff0034a92c3fe70bbc6a7c8e56ae70f2bc3369e38cbaae1cb4e07e5183cf6469e72735925bfeff00b326f079ea3f9c7b2e49708b2fc67ec22df07e538566921f5303661bd7f94612dd830b170d52632a73a494901c5c8dad184417bb9b5d8c7cd57f5ce79fac2bb9726be229120448e7b150b509a33b341487eafb814711082056cf053b50d0de2cb2c192825c1661bee44764bb2a908ed11c9c510348e3ac21736349b1d6c48720d9aed468ec5f65f5a91cfde51cc0a034f1b615bc3bb363e87817fbcf4cbfac87e9a3ab4f675a9dfc57d68d379cea2ae6bf34960b95730f38240d87efd3a387e6970482e7a9bed1cadcd652a6732b99249aaf8f33651537fed6cf8e269a2ac41a16201d37f1f18efe34ff00db6adfe34bf499351a726d18aa505280a904b97358a8805e8487252d4610ea0c48726b43b8e9ebc2154924382480582452b1f3d2b27e4652c215c8140353bb02f07528e9d4ca172f41bfaf94232825c12eaf8b7f3f38aece543ebe11cf27632dcb4971b384df6880bf74a4ddc30707cfa45692ecd745fbb68241664d48ae9058faac66ba7811e4369f8aa40d4c0121c52225228497bd3705fe90280075076a86a88890482012c7bc09a0885959006297bb1f854ce00880962c6a05542a0fd61d542588d44300ec07988506852a012455d887859f881ac4172a243061d62034493b24a4d1cbb400bfa01504b3c470748f85c514efebe7165603170d66dd5b81e568892097041a55f6d811e30164104aaf703616fc7f385d4082e93abf8ba0f5f8445d277617910d6b4015dd737f086200b0b3397dfd748520820ea074a88a27eff9c120a9ea48d4e929a016f54885957600082c2a295ea0fa378800001a826d424797e510100949d4e0bbb3bfaac393ddeaf70d7fe71649277608a0123ba3507704f74bf5809bf76a4dd8e96eb0dde72400010c5246a261127bda81034d80158e8a7e459754654b0eec58353a1e9f9c6b98274a934a380e6c6344490cc68a554005ff00a5a358c1025694d039d4f727a0f5e11ef70b76af1bf8a3a216e6c9fa63ece908576b0ecd29580b42b9f3c19ad043850fef365543f28f659c400649ef3004d2c45a3c6bbd9bb865e2bb5df664c3cb0eb9dcfee0b9600df5713e5223d9471400965240a2886b3b47ebbeea0fff00a4fb3315bffb5fd7a73d1d435dd516bc25fb26df9ab29720d8916768d315a992125d92ecba284664e500aabb3b4620d2753a49625bbd5f38fc5ab45dee79f3dee52a5108253f124d02abe662a0a0500aacee140b83f2de2c9a430a0ad0efa4f8c6282121490ca5249524e9ee9ebeb78e2a98d8c9dec5855f6800ee014d4b8deb15aa66b1a55dd0e414b3a9476fa440da0f794a1f6549a0a8e9f5fa18c65148d2959056540a342aa1b7f2f18e566582e0428921490522ae9798b1b56038a1215a529342c14903c60f748eeead492e7e62228805c9b9d41147a51879fe7020a12a597a0009b5875686d3a48a121db48352fbf9410029800e0d4950614dbeb014a09012f54a89d4a2ef6fbe19e8064f78a8060f700d7c2199294b948053525458d9ebe303ba4b805ec569b0bd2154752887ee921212d6a7af280212a07514a58b923c6c1be6d054b5692090c400e2e00a5cf5ac56b1ad7d0582546819bfac070547529465b7714a0c97abfe1003a995dd500b4a52e5ea55417f5fa4424a541455a000494a685c98ac2ff81048d3a428d81bbf957ee8a8933036a75a54c576d405c37ab4017ea0439a1144901c925ff18c52092544960598d59c0d86f012b075a4bd0050255506bb7ab45ac3bc7baa0439ae95025ac6002e1c900858662de351fca0901452e59614eda5c0706915cc70a28ef0047c648200776fa45e1458b8529cead4856950dfd0f08121491ded3a8cc018b96486dfc7688951b8275746700bd493f7c56a3de2d6219ec367f3feb0e0b385a4a493fc558d612e57644c5b5845f476a050151b79c66e0f12a92414b820d2aed6b98d304c553e13d012c7e90a82a4d5c172c4a469037f5f38eba55395e4d62ed691c17db43b19724fb7df2273ee49739b2646230d8a973319c2dc53829083c4dc0999fbb299399e5f30fdb438d7289d13900a157a7954fb47fd9d9ce5ec1fcf8e2de4ff0035724efe5f89998de14e30cb30cb1c2fcc0ca14b230b9be5ab50f826274fbc90aefc899a90a1404faf1e0718a913504282595473431d3ef681fb3eb923ed20e4666fcace67e065e55c5d83c2cec672d799797e0e5cde25e5fe6a507dce26538ff3b0ab5009c4e11442674b2a6295e950fd93dcdfb7fa1e13467d90ed7de7c0ebcafcd6729e92a3c77d4d6ee0ff00a6a6bd65694573c5297a3a6d4c541d1ae9ba6ffe97e2bcbc51e2fd9b65aac3cf58095020b295d236cce91de2c972d524b13f28fd5ef681f606e6ff00625e74f15f2879b1c36bcb33bc967ab1183cc707256721e26c0ad45387cd32c9ca1fe661a70a8b996a250a6508fcc6cc32e5c93306820053816298c3dd0fb05abecdebdc1b8d4a134a74aad37cd4ead396633849625192b34fea39f53a59d1967da9f4b1b3149ab94e9ef585081101090f705802d6ebfd632e74a52497625fe16a98c598145d294ba854931f8e56a328c9c2470b4c4340a1a9c0a87a13e47e9158210e5942b448a810e48a020740361e30aab909a94b17245a38dc5ac1523d18b3b824bde2d4307a82f53d229f8891fc5f6bc62c1a436a7705c31bff0058b537d019329f503521defe71ade107bdff0026538993cfeee806e4cc6486f32a11a02142e03351c9b473cf668e059dcd3ed09c87e5b61a5a7113b981ceae16e099524964cd56699e60704104f899cdf38f5b452e5ad15e2d2f9da46c9d95cf696e496453781790bc88e019884c99bc0bc90e12e109a809d210bcbb21cbf08b0db31951c8e16a2872cf777a925e33388264b1996365ca4264a244ff00dda5a1096484cb642401e40379468d2d60ea0b2e7603f08f4e728ba2a51564f36f379346f0ac6a09207c54294d08f86156a6510ec5b539a0a6f18a260a8ef5a801723a459a89ad4949d2c45ab48f36ab655966b510094d5806d8c3a569d4ea07e26a0bd2a04548355f79268e01a910ca515a85d9274848b8f18e59376b158ec872c4801d9ea48a0f2fca2d0b00690a254454137a3346215299c9080f625d77de15c004ea7d26efb45337c86d99c9512fa8779ac03b0ea7f486d27f88824df61d1e31028000a4121fadbcff0058bd0a700d5828835d27c0ff0028a9577ea65a569454f7521859cc6c3e6df393857913ca5e69739b8c646698be15e52f2ff34e62f1261726908c4e718ac165385998a9d2b0b2d4a4a5535625e9485101d5531bc262c90520176d218bb7eb1f9a1ed89e29472ffd965dbcb8be719c25cbecfd9970fcb54a5b2fde667370b804007a3e218f8188e5e6b43c6cbe92adb679e17b5bbdbafda7fda69c45997080c4623937d983038e13386391dc3398a80ce512d4552319c518d410730c5170af774c3ca34420b6b3f84b3a7ae71d5314cb51b9ab6d19799a4a56e481a5001eb6631a07bcae9704bb026a7f58f4350a9d0928538db1f61a34a1b16cc5951724d2b67118e54a24b2d9e84350794059a258b39626df53094720b10031d89f18f3a751bdccdc9f40ea3a831d40d1e8008424b9672756f782487748a5c1b9de1469a12dab6148c5cefb950904821e80381d1af0428ea2ea624b1a545216ea4b302a70cd04de8c90cc480c62aa4ed903b6924820b8201219e9d2001fc25cbd8d29e9a00ad5d3414f28216900d3762052b1a295ddd81cbd0917db74f4882a1d35d434b58faf1841f0951075063ebd6d1090496748372cfb45b9c04865299a818b163051427771506e3c6012082cca2aa5980ac2a9c3b100d9825999e2dce8b7316925dd838a31a136bc3a54e7e20c934228d52631d4a3bb3f850ed106905c90aff480403e112e765618b170539a310f5236a1de06b2a517b1a16fc5e1432490926a1c6da6f482a35609043b9ab15352f16e76d6e594b64864a9d572c2db007ac3ea23e126c45406114a884a54003522a0d457ac051d2122df6bc223bc922bcd82e74a88490c6f7a188f4a392ee08a7a315a54e9a0258b123710d6771dd15f13f3e912e6d164dadf62127bc1c123624880494da800abd5a26a07a8d92e2debef8858b850042455a8a24ef157357cb239b207755c961424b34005419c90145ec093f2fc6004b9f86c2bde623e704a86a1b80e9a50c53bc5d08e65d077480e9761724f5fca1490033b38a16f4f084bd8790373ebf385fb40bb8f26022bcfcc886ef82c2a604862fdd6058f89f3800249726f54a5d89f1fc201291a4286f56342ed780c6bb316622a23372b9012586c3f898f8c2ea3a940870a6092055e0803490c54757748013e7f84071d59a87f4885e402e121254cc9b9163e22011a9c528680d1ab789b1206aa6e2a7e705372520ea6750268452289a5901b5d2fd2ae62280bbd59c8eb481427c056b4fbfe9f482401434535c9d2143c62716b8154cabb9ab50b027d37d608a004b86a02cdf23f4834764b170d4046fb4470e29415626bf5fce2767b80b862032b751b1f280525d8789d23ecc15172ee2a3ed071e0f0bb1e8f52687ca09db7fd402a00174be9d89b96ddbc60692092490ec0048a1a4173dd620b16aa5c9876490082cfde2f576f5f741356b01416d400a9a36c3ca20dc174a4509fb4f0029c92f51448b29306e140a4269f112084fafba21595ee024904b7c205435fd7875889252d5649b1bc4a28156920837bb6cd0a2ad425c1abb13eba44dee80ec484ee02a837fd6b074dc83bd1bed4204960ea001a36e3ca2dd1de7482183a94eff3f0f38b2dc818967625c8604d00866212924d59f773e70014a93f1314d4288707c7f1867059d95b862d58da2eeac689be83a5551626c7bdf74654b1a9d2a21557667dc46124172069a54926f19925455aba2586a1f12a3785db35594732f22d873839644d93c6d802e687fdf46273d4fbce71735147ed71e6627cff00cf23d79c5bc94504736396c403a871a602a0bbff009c3d7ca3139dc5f9b7ccfab9fefbe6054f525e718f5dff00baade153f6516f83f29c313b53b3324d875de3095570c0547908cf9cd52a04915ad84602c822afaadd047ce56dce797acc4200b17f93448112302a1152078c3a7e220581eb58ae18026af5b0112b7c03392b041dab6a82691cf9d9a1ff00c75e55286a71c6587533ff00a669fca3afe94eee2cde51d8aecb48d7cfee538580cae31917b7fba9f1ef70376e27a6fed21fa48e9d362ac1fe52fad1a4735a59ff0012398cc8513fdfacd9c0ff00cf67c711ce480a59624fc218fd6398b9be74f3439968048078ff00374b0ddb1b3e3886692eb61a49a5431da3d3e376f7f565f952fad9a56f5d9a5a920951b037872cc921c04ba748a5c50c1580e6a5d35b54d6c3a9fd614970f44a450106a078c7ceb4f639e6b66cac8f153b696ad62b2852879dff00d4dd22e009a298b8a06156f18521b76a329989178c269fca66c414502c029a82fabc6017140ceabb7d9f9c3a8ec58916510090f4a7dd0a5292e1887a74ac677eafa10072e5cfc4684967820e9512a3424f77630ba4b125880cde27d520148a962c6a010fead11bbb818d1209ee93f1124b7d621528b062dd458dacf0b52360db3ba4c1a90ce5852df51f8446cecc05d8d5de970f0a0904851003382e43c3328ec00dea0bfca01ef548041e8006688d8135288a827a0146f54880281d4d4670c2158a88b10ec4b8116021d9d7ddf8886d29fe716b7590f209146d254598eaa0b51cc30a0626b5705551080804120d98a41eeb341a328ba5435518031176d20049d2c492400c48a8def1601dd06ef517045037ceb0add34907e104d69e844ef060c2b44b1d40bc592bee02a2a0a0ec02a8482ea1e7eb6854a482e0d1dd4599af04e9293f6aae1efebf488c9531036725f7da3685d12ae640201dc1dc837b53f08d6f005e620ea17dae6341425dc3bd2e6c1b68dc196a02a624861e618c7d070acea62fcd1d1077793f553d979292beda3d94cabe0ff843f046cc0ffc68ca63d8c3313dd517a99ca26a7a98f1d8f65cca337b6876524072a3da2781c693bffc69ca2ff947b11e64400b2438d6a600f898fd8bdd4a29764fb2cfc56aff004a81e957c52a3ec97ea36ccf512a555dac41622ffce308a980528a46a0e9655fcbf38be7a8121219b57d2ff7469a560952477481dd1a43b79f58fc56b7a983cf96762f5ad3a2a5c10e4816e9f2f08c45a80615485246a0fa59ec0c33a4909492003426c4c2abbc421d9490cb494fc209348f3e76d8ca4ecb256669d410826ce54d4a7f4fa3c54a2ad45b52a5b0d69153a8d883e843a94005a750042b405920023c215252ca7584d343e921ba50ede3e31cad59d8c9e1d86750d4a7d253dc209203789fce0ead4a63a402b1df5f7353d2f14ea651429881f68f78ab7afdd164b3a9b569f89d04d5abbfade207b4b4105ca509992c38b957812f0812a524a49b01a89f88d46ff9c5ea5778851213729480e29d3adbe9188a9843bf7d574a43056df7f587b082d2b2905c8511b3b28559fd748289a4cd49035397eea752521bc229754c00804775ac0adcf578ba5a0a43ad23414b2402c4529f58014cba2561d2b2e0026abb3f9f9c527493a6ab246e3e0bd3cfc63226ad87c40ac56964871bfe518654661218bd0eab333b57d5cc003df690a214120021c13fe635dff06f084f8cfbc513a260d244bf858d6bf87ce229254148012e4386208506ebf718ad25be12ce0aeb6555d9bc5beb026c58501c80096002495335e8d1609ae1804a8046b0b344af62fe2205080a60e501d999314904d5c196a5317a1daf023da65e80a0e1ca41dfbc19fd56093a59ac53a37d5b905e2b44ed097008069a4b7bd05d8fcdff00184248d4ca3400a0101403efebc604ec5c092cad4410e0e9dbebbfe905f4106aa259dc9b1dcf8ef15257eed2c02941eaa03c9fcff9412b4ad1a75535ba1aaa77dfc6253e8c82c040604f7773fc3e662d0a21d0483f69be278a02a97b0660d485254901882952b4ea2ce8a07f9469191783b3b1929989721e8e750be9f38dc996e38c95a2aa4801d249358da892a258d89ee97158bc2ca08625d2182753811d94ea34eccd62f95dd1d2bf69d7b37393fed2fe40e61c03c5584cbf21e6d70bc89d9c728399b2b0a919af0b6606594ab0b39406a9d9763034bc46154e9f8262405a1263ca4bb627640e6bf653e71f1df26f9b5c278de16e35e07cd1580cdf2bc44a57ba992d4eac2e370cb21a7613132da6c99c874ad24ee081ecbb97e3a64b9a9256581012451a3f317dac7eca5e54fb4db93cb47b8c9b847b45704e513d1cafe66ccc2a52b9a921533fb17379891ae6e5f39760a73216b3310cea0afdbfdcefb71c2970f5d81eddcdbe0f36fb8ad6e6968aacdef6cb7a79cb3529af55b7560afcf19fa142b53e4ee2aaf41ecfe2bfb0f1e9cc72f998798b4ad2417aea15f0ac6de9a92092edb6fa8b08ef6f6aeecb9cd0ecdbcd2e32e54736783337e07e3ae07ce66e4bc41c3b9ce18cac460e6a1474cc96b1dd9d879c8d3364e225154b9b296852545e9d26c7e0d72d6a4970c493461f331f37ee83d87d7f6578b4f87eae39b27192cc670924e3384962519269c649b4d34d339753425464e0cd08a03575788fb30ac9a100b3d5e80dda9191325b1ff48a12431f9f9c62a9240dcd593e15a931f9555a4e2f95ab338991882454922cab7d7e51097500967018072497ac292c2a09510c1cdff9407055aaa0fdd1ce924c82f400001770ec4dbd7e51fa8dec56e0d3cc0f6adfb3df86bf714e608476b1e0fe26c5608cbd685e1f24cd24e733d4b4ee944bc0a967c1263f2d504100fda7a861f8c7efb7eccb7069e29f6cdf648c6ac1387e0e9bc53c6789d29d4948c2709e712e59276026cf945fa811db41376b74b3f9b3fa8bc5e0f55acdb192a6e6798cd4ac2d0ac62f497a920b1fbc18d3c6254a2120824f7947eb68dbd371817394b49f8e6ae63599d6e3f4f9c6660e6026a0824bd0d050c7a9565184234e3b256f99235e86e29216a214a5396649378bdcbbad3a8974bbe963fcaf1872565c943102c90cc436d19cb5253451150080ec9eb1c1295f72087b84121481a7f8588a7484130120b6d42eef48ac2bde382b201af7cd54dfa457a80580906944ea3a41703d7cfce319485ec5ea75282941ac0853a142b4f236872a40494b25407da0e40bc630294a4b8b9aee456f78b411a1414a0e08d203152a8e6b15bb2977d4c8428842988008624172dd2192a04a5209582a6fe1d3d2b18c57a83835a243961f4f94205124f476512921abbbc3da1e560cd2192b1b5fa79c7e1afed2573125f2fbd8c9da625ae6994be61714709f2df0c424a8cc38ecee4e2968f00a4e0155f068fdc89090a212e5ae54a627c9ff0038f986fdae9e354f0cfb2e38078282d085730fb57f0fa2624cc095cd95946559c639494a7701732593d348828f34947a94ddd8f33ccc26aa74e9c4961ad926c7cbe91a2b284c25201201d242691a9cf3ad4a26816ee0873f28d3c827ba0871d4b53a18d2b4a4dde4693deeff008d852a052417a905408778471a98307b824b8b4024024b17a82e28207c20dcb07008a18e3959a5632c3d821877858d1b76f0842c092c6b467b37f58625d44b577a81076b004ecc2919597ac808c45497a56f4b52200e49a33d89a0f9fd6212d43500d4589f2823490e1d2d60d6f386770330a90cbeeb04a4100d3f9c2d6ae9ab51c9053bfe50c964960c970fb25a212010cc5dc390ef13757c8b0038d8b529707d110da410295bd6a07840b0ef3004352250801c9ddaf56eb10ddb2c0351ad075276f0884922c0977de9430c0b927bb526a0d478c2d19a80eaab6ede8d7c62537601d20a4dea4d46f673010e9d41c0214595d7c218298fc21f64bd0c52a7343627bb4f1b459376c82d4959407a55ab723c20950092016aea049a184f852e7a3690c7d087671b2833f89b0ac232ea2f6087510e00716dcd690196183552290d648720b3d8bef6822818bb81f10f8806fc22652c8b8012e4a9cd58f42cd016df092f5a50b0f03e10090e7bb6a849a182b2e12013676bb44737893722882407702ec494f908340430d400f1d4210a944b00187749b79c401daa002188371d3e50726f24798cedf124807be90c48000804a8b1a17356b0ad09815059cb3bb1a351bd3441dd0a650d17a867daf1577dc041d21d3de77777200f385218337799d9a90c93704d57626c7ce14814751a79010bfc600243a74e90d773d7ac00a292684f4045e916e9484d1357d5672e7a4001692eaa52ac5c22961155e60ad882589347505162934852ea2007ee8ab5cde1886500372e4df579c0d37bd4d40f9c1ee08050a48531a97773161b9a90e5838a790846a80c0b58fca1c2880529d2752aba802f0b756810801f5317aa457e710071a592e3721c91e701810906bd68cc7cff00285249d454015003497bb0827903bbf77605bc211dc79f9b1befd209e94a07bb3c4009208d2d7249ac375600ef3163e22e4f4864953ddd44540b78c0727ec870593b3882039142fb1a06f085eeac01de3b1f22618a4900d4e9018335edf8447019cb31b8f88ed5fc7e505c9d571a438170621ec08e545c3dd9346b7979c4587510a3ad5b8ea7683dd154967ef1a3fd614a5b492a0c2ae2f589b7805b11a854aeebd6e4785a0907ba9a1ab821e20092e4ba9aa188735825891f0a436c9aa6255967a0199fba01ea481defac3b35c00c2eaa06ebf3844a800c1faea22aaf9c45159ef6a203b2aaeaf9f8c592ea07040157b0014cc3cbef862142d7376f8bc215145170554702800e916b5417482ef4bb46b0c32cbc1807509ab3123e11fca32a5d031a876d40f9463803ed28a402eda5bceb19290ec5c03a5d229a4da378659b2d8e5ce4b287f8b1cb500b81c6b80a0a9ff7e2f14f3b083cdce672882e78e331ff00deca117f2500ff00163966e024ab8db2f7d26ffe788c7e7906e6ff0033d2a70dc7398d36a4f56d1ec37ff85dbf2ff6513f06c8e199a5ca99882583ed68c050228de34b7d233a69092a66adc6d184ba001dc9152cc63e76b2576612f58aed122448e6693dca84163b74ac40fb3bf840f287433a5dfe43ce2cb2ec0ca4100302e00a8e863b1bd96a604f3fb949a87febe7207501e5cf15fa88eb927497770054353a5e3b05d9914a97cfae54ab74f18e1940b547726c7b9c171c474ed7e321fa48e8d3bfbe47dabeb469fcdb58ff0013b99ae6fc7f9b071ff9f4e8e269ce090e74b52afeb78e53e69b2f991cc8597d2ae3acd660d22849c64e358e2c981b51634a817fe91e9719bfbf6adfe34beb65e7bbf6b31263274f8dc1a98a57a42800da7e21a8393e717a8124eb492d5090a67def7dc46313b02a7d8b398f01d8c9a101a90f7ad43b41529c02c94b0ad2bbc00599ea1408240b1dbd78c021f510e5ac1a309ef9327e212cc91403cebebc2238ef33be96d2438802a7528120b114afca175282aa2b65034b464daddec4101ee3519fc757588ea243153b5098170e4015a0e900d8a54cdf117343582f142fd084302ea21cb3d09f47f389a8beec9f1bfa788405386203070e54de30c026a0b9614003c436ef90104114a2897255081d43ba5408ba81a74873a4b02c00140e43406724241f00058788eb12fe900b778b970eeed488146a2a948a002a497b3c328776e687ba1b6a3c44a8951d2f42ec43ef6835d3a86153d14e5c86531616dba42a0022aeec42482d041748275555aa81cda00246b3a426aceec6f685dac0140046c7483bd47f58672900814341fd6039000666af95e207d9dc9a5c8fac42dec065310ff0b17041b57f487960aa803289ad5858c03406e58d9cbc406be43506af5fba3a608b47c4ca96ee5daecfd7d7e51b832e752d0486513d691b765ec34971502c235fcb412b1b107adbe51ef7097fed305e66f4d66c7eb6fb2865267f6deec9a85d5fb45f0403e3ff001a32afcdbe91ec139b4c501300ff00c629abe263c7f3d93aa29edc7d920ddfb47f0324d2efc539488f5fdce6a66b1622629d839035111fb47ba7a8ff0024fb2bf9babfd3a27a95ff000146fe12fd936a2a692a2c430555ec47568c6d4a6531528336ab90fbbc34c042d5a8385125c6d1525692b097d485f7983e90c0dfc23f12d424a2cf36645a9d2508049200627bb77fac37bc6d29529418d482eb486fca16687d2a4164a5f51abaa318a941ca410ab122e696f38f326f2ec66f62c0402659604a4906e407f28a14a0ca62c91f65551662c7f2860baa8a54014a5dec4f4685152e90529531d4c4a41de9d239998b681ad243a8b81fc24877b066ad8ded166a98962348604b11f15e293407482b56a215ac6807c9b78ac2c0360e01a956edd7f28820cb562180696a21497d5ab73eaf0112d530a14a5896925dbed90e2a7a346325c4b4a986a08d449dae7e918b3f15a1832cba5c31ee9300744fda2fed0be0af66f704f2379bbcccca24e3f941c7bcf6c1f29399f9e4a9737139e704e5f98e0715364675829296137f769f265ae7ca555524ccd3de001eedf0b71cf0c730b87387b8cf82388328e2ce0fe2dc970fc47c2dc4fc3b8e466791711603172933b0d8cc26210e9992e621492142a1c8201040f967fdadcc54f5fb37f9749d4595da6f2b0120d094e51992a3f0d7f6763db972fb17f12603b1ff006b3e25c6cceca3c719e0fee071d6633978b5767acdf16bd2b5a9dd4325c5ad41588969a61e63ce4a59535e61094e3ce95d20aecf4835395153a8021ea5dcd2df7c57de09d44f74a74948b815f4f19631d95e370380cc72bc7e0733cbb33c0caccf2cccb2dc5231b9666b869e84cd9189c34f4128992a621495a1682410a0418c25cc4072d573ada80bbd22aafbb0588d28d49703fcb66360e2d085892c02882c922ec6ec778c6f7858948a293dd403dd21a95fc7ca2c0a3a52562953dd25897a03e113d496285a8397d242997a8beabd6085a7c54ea7614d3468a96e0254c4935502ec6f7f1ade2a0a502b60085abbc01f8037f28105e16ca510c58b6a3f609342df38c8405149d4e750d2544b93144b0092ea25cb197a2a3bcd53d22e5a5292c092087bb94f84015cc5283005410285be2f3fc690d2855b539f8d200290c77f33101353a4923ec93557e90c4a84c053a4914205837d9801cadd4d46772b49ef5695fba201dd01c06517d5de27ee8a8290ec35042a9a412527ccc5aec4014b976a9e9fce27a9372db25c03a52aa17d24458921c101452030268a2f18e16e08d2e00d49512c08f2fac3a0a9c949d44778558c6f0932f078b19f254d7003171a6e3f58d7b2fccd52480a2c4170fe51b5fdf0469506723ae921e192b015dd06b50351015d5bee8eca33e57cb35e89b465cafc8fc8af6cefb22b823da5dc9fc6f1570261327e1ded4fc0391cc1cbee24c584e0b01c6d225033070e6713c07126697187c4a9ce1e6283f70a847974f3ff00b3a71f723f8e78ab803989c299cf06f18f0966d3b25e22e1bcfb04ac1e6993e264a885ca9a8343674ad2e95a485249063dacb2cc5fb85a42dca48efbfda166f2ac7e147b6ebd8c9c29ed11e5c62b9bbc9dc0655c37daa381b275232c9e509c1e57cddcbe4a4a86459a4c1f0e2915383c69f8544cb98f2d60a3f76ec2f6bf82f18e1b0f73eede544b4d671d1eae4f3a59bcaa551bdf4d3975fe864f9afc8e5cbdb4aa42a4150a9eaf47e1e4fcbea3c9d71d855ca52d241005086f111a04e4942802585985c4768f9e5ca1e2be52717f1270571964199f0d712f0c67188c8f3ec8b39c22b039ae4d8cc34c32e7e1a7ca5074ad0a041163421c1063ad18994ad45d200366178fcf7b71d92d776638c56e15af872d583f6a6b74d35869aca6b0d3c1c5a8a32a53e56b634c2480e05050122bebf58415b12e3e21b45eb94a483576a6ef15a4779ec1eaf778fcfa54da7939acd6e34b7af74310e0bbbc7d517ec9270b4ac7fb4b38a38ca7aca65f017662e29cce420228b9f8e9d96e065b9d984d99e71f2bc924124a4b8500f58fb36fd8f6e0e959af3b3b6971c2d044ce1ce49e41c37829ba4ba266639e15cd483e29c2a6db46ba749558a6f195f3a64c5655cfbd2c3a16b4a262800e904eea16a7ae91ad613b852922854183b12e4b8fcfeb18d8095326251ac7c2c0b86dc7e91af264aa594e909ee9d5a94e48bdbf08d2753c4d6e6426621295149524d801b3547f38c84cdd613a8501620925eae0c618d40ac2824057d9ad29075b4c0a25252404a48510075a7ae918ca57d88e6be519aa52430d2349a07fd7f3f180e9d3472e77f8bfac2cb29214e52480e083bfa7a43eba80ce4d028d46d7f5bc55b2a9b7810050648242493624115b7ce21591a0b3114602a474f388ba8090a600df7a1dcf5da284b12433851f8802027c44062f66b25f296405ea15e8ab0f97d62e7d412a26d66debd231c174a80626e545dd50c85243a40d9c24d3e9128b3b5ee67c859040662cfe1d2de9a3e373f6cd38c65caecf9d84f978903de671cdee2ce35c412bef04e5d93617052869ddce36617f011f63889a35ff009629a7bc53b47c137ed94f181c573ffb117022274e32787b90fc4bc5588c2927f7713f34cf70b8642c0fe2d183507e8635a3e8d68cbf8f0fd643cc927b1f1393cb3804062de7e3182ad83b121d2456333125d4aa1153421c98c32e024803533149115af87913b0b54953a83b543d9e10a54baa5573a5ba88b481de7ddb51f18ad24275555dda24b5e38d9915b549a065394a6a55f382e1c900b10c49a910eea7555ca87787c2445641ea94ecc4de32c65b04252540fda6a1d841ae967b867f9988ce2a000f5d8c13714702de105749020092c14a1a43d09727c2141eebb1212a63fca0b382f7776b35218a4b02e0025d8efeab13b6401d2c93520872050180e08dc867a16f27f5b4004f525cbd0545e2153a599d2457a088b5ec0814ca254c05a9526b045af5f368afbcce9735e97ac38b052810a26f606f0b7a4026a454b3b020d6092012ce403d7c7fa42b9058f78a8d69416860482f47eaefbf9c1616c050c08d81fe2ab7988605c5d81b81710b5208b3d5d5bc33060f63722e1e270d0080cca4923553c031b183a9c872c4f74ddcf8faeb0c6b6012ff0060877f1101c8b92a64b104391e10cab48015a806531a3827a4563ba4311e041ef4305353725c3bd0425caa9de167b088bf88190ab87d4c4bd5a90e4b900243035d89e90a9496140a7a90ee47841777a91a416a42e96c02aeea428b975330ab42aea9d3435000fe188a152410490e4ede50aaa9701403316f18b376c00956902babbb649688588ab02439deb000624a7554500b188007b90a67a574c5659776072b62e49240d20eab6d48849a6a20eadc5cb0de17553bc036a06a2a61853e2482ee5209ef42d6dd0094bb39d35eeb5dbac2d1d810412fe6d0ca70b480a012981de0a2c031163f8bfabc4e2d6001577776a57e2a446b1347b56d68800d2c431ebb9a6d02a090e58037a9f2783680051eb4d54a878834aad564b9d89a7e50ec9d2d5722a4534de1149a120127e16b3d2910ddf0800b127770f4a3d6083671e0c2af0c002fddb25ce90c017ac0ef1660e6f516bc3c2e084b3807e20ececdeab0122c751206c0304b52d16009d24b13e2d5f5fac0506660c6ec43b87ad218b001b5094921c34005443d88167da9582a4ecea2950bf5fe502f604b061aacd04da7905a02496ab14d495167eadf942100242812451b559e0824313422e0d34b78c4052a228c0d940f7445af7d980824a882c361a6ca80ec540b39234fe1f580541ed40683c0c062e1c1af85e17bfb00fb0002a8593b01e3100092aa921d8817864973474a88ee914710e97a170122ac135579c4af0602901e8e14fbbd46f05c07201d20b0ab31ad7ca14071576041d4ed0500a94efa8b3802a151ac17565a38dc749526a4db61549a5a32e4a8ad8a8004961d1a30d254772075372fe1197254c5cd55f090cc008de37b9b2b74398b92612be6ef2cd140dc6d80600dff00ce0498c5e7b9079c3cd020d7fbf7995fff002ea8cee48e9ff173968ad2cafefae01213b8ff00386d1a4f3c493ce0e679affdfe6664efff004ea8f55bff00c2ff00e3fd941bf46de670e4c370f5b8fac61a852a6aeedb465cc7ab518f9c62ac825d4fe6378f9fac95db3196ec42d60de7d6240a7cf6891815243a5c32981ab35212ce0de19258dc81bc4adf00c9960a5aa1414e6d68ec3765f48573f395892c53fdec94f603fdccff00c23af282c433b5eaf4f947623b3091fe3d72aaa1bfbd72cb82ecd267c7b7c1537c4b4cff00ac87e923a283f4e3ed5f5a34be6dcb4c9e66f3265853225f1de6a80a6714c64d007dd1c513029c97a31200b83fac72c73595ef3999cc924b9571e66ca63bbe367c713cf3a5d25e86ac5c18f4f8c494b5955af8d2fad979ef73066853dbe842a9e1149a874d297040d5e5d22e550109a121d83bdfaf8f845694a4967344b1d88f1fe51e03bf43295b0d9528b029605cb9574f0788c3ecbb81500311e436872e350d4aa871d7e70b5725342a1a6efbc73cae64f62a02a007ad6a451fd7df118b50d8b548f944502492a6bf7ba9ebfd210b39ab692e08763fca33c3dc80e97ee82145e89602b12ce0a58f4bfce059db557bce4b37f388484102b4b0fbe2be8dc128012e34d05287f941ab6cde56f5f7c025e8c18d4a4d36f5f48354bd0105373f944a7d2e06dc0eea4dfe1aa7c5e1940249041b39228d47a4212a0d52ee07808625eec07c34352fe8413bee08403a6e4586e610034d4000aa24967a43aa840ab24b59926a2108215a4558b92ff9b44e3a6e089d4ecd6372401d7d79c0f1a02d6511f7c162490d4487a8757af0876aa94122a4d19da2bed0561c1008771462c3a43a05944948f903f744dac436e053cde1495006e43500fc62c9c7a82d248dac6a4300620ee960902a4b8a5fd7dd112e521cb80402e5da08d5a6f52749aed1d10b34590f2ddc3789ab7846e2cb4a4292410544db61e2636fca201ea1292cdde6f946bd9502660a33972e6de31ef708cea61fc781bd3f5b07ebc7b24522776ebec932e849ed1dc0ec052dc4f9547afe672357bda8a4d53d2a2a63c817d922a12bb77f645617ed23c0e1ee2bc4f95ff38f5f4ce56c67a6aca9cad447ce3f66f74ebaecbf65d7e4eaff004e89e95797de692f297d713684d525ce90093627cf68c67083dd05d4284867f11e9a2d9ba42881a8b55dbba07846395850005858ef6fc23f15d4ac3b1e74924154c4160a294a88a258051237fd61490122ce52ccc051cb79454a25814a92aad55d5aedd2220a428a90b2fac82df010d478f2e697428c010e005148d293a6c1418ee7d5e02a61084a3bc52090a21b531e80d9b78b09d4e84a802561aeea1bd7a7e9159742ca4ea0a3405e808b93f947333178e82296a494681f0d09275123afe3152cfbb582402515481577b7d222c2839012144e900ba890d52d1500755189040ad42459ad68820a84d6969d25274a68681a9b7d631b48d4038505871f6b487b780bc5e12012e03390e924eaf9c40521634a58b507d9dab1577be093e593f6b9c2309ecdfe5294a52d3fb51e0d134b8053a323cc086f32a3f7479b31cc1727fdd91762c6e378f471fdb03c4cd1ecf2e43a13a8a2776a7485149ee128e1dc63fdf1e6fa10ea512ecf416262d4eb548d274a3b32137947d9b7ecf4fb7d57c999dc0dd83fb677166226725331c7cae1be43739b3bc5ab10792d8bc4cc08c2e499dce5b9fec49d35425cb9e4918254c4ea691a952fd04f0e959bae5afba95a674a5a674a9c858d48992d61c290b0c52a4b820831e18f835990b4a905abde4d6b6ac7df2fece27b77e571448e0cf67af6d0e2d949ccb0d8795917664e78f1163f4cdc5e9ee49e0ce21c42cd4b048cbf18a2e7499133fe89516719c609cb259df94fb5d32d2900bb0d3a8aa8427e5e715ac001891556ad294dea1dced19f8c4a242d686d3312e89883705bd318d3a6cfd6e500a4fd8d3f10f18adac5472b49483ddb31d5529776a6de708896e490120a536046aafe5fce3180d201ef39552e46f5f5fd3212b01486001d0ea3bf401fe90064124063727bc007481e7b5ed1600da5454ce5d48a3aa85883e1d6294d46a0a72490e0b8156faf942959092e53a82685cb0fba0075cc4851624b554e96b37e11280b02e5635101922a77e9fca29f78a7aa8e8d5a483506cfebfa43098a428b1efb94a755f4befe2d005a000941a04b905243937a3c02a0ce0690477b5104f9f9404cc04b2c9aa5d29059cb6f15aa615ba400c92f525cf4802f49d274aeca4b288152de1eaf0e998140680024d02851206d48c60ad452ea66d94a603d7ae90c16ad2400a73f658b3f5f01178bb3c929e725da89605292c59d4077a3265a839d441243d83fc879c600538090e482ef701ffac5c95a4151155331d353ebc63a23266aa499a9a2694b9490001de76247ca357c0e76ac2ab4a56e08086b050e8446d64e2038075ab50a306005bd79440bd46e4b1a1048f5fca3ae8d457e59e62cd232e579d8f9d6f6f4fb0f72aedd9c2d9bf6a1ecd79060b03da838572833b8d783f08946170fcf1cbf0b24e86b2539bc84274c99a7fe7080252cb896479a4730b9799af05e779864b9be03179766196e326e0b1982c7e19583c6e067c998a973a44e94a0148992d695216850052a4104388f708ca337561562acb48d2155dff2348f95efda01f611e45da6f84b8c7b6a764ee13c36039f190e06667fce2e586438412e5736f0d210553f37cbf0e90c337952d1a969401fbe2104179a0157ed3d9ce3fc33b55c329f633b57351af14a3a2d54be0f45a6ad2fc5bc2a351fe0dda127ddb8ba7d8a50aa942784f67fa8f340c4e14a14494b1b00c003b4694af8d440a0dcb472a7176433f29c5623098895364cdc3cd5495cb5a148992d4924292a490e08218821c10418e319d2fbeca07fd2496e958fcd3b49c0ebf08d7d4d06a60e3560da69e1a68e0ad070972b28405294124d14a6602a4c7dff007ec6df2f912390fdb67983899084ccce39a9c2bc1b809e5002a6a7079763f19884056e9067c9245ab68f80dc0cb067235d46a00bed58f4e9fd938e5d9e1af653e6bc5d889587973398dda878ab3bc04d9696c44ec265f83ca32c966616da748c580361e71f33dcce1155a4b1faee8c9471767d23270a30ead2a0055dfecf9bfabc5854820249043bd28a4dd8bfe5e1195899a0d14e90ed6ee90e2b1a5fbd4a090dbba48bef1965e4b2f487989485850727531515306e9ebac552c95288025a8a94ca003a03aba7df042d4a04ba432999eaaa0f4d14ae668984cb3a752805025800454bf818809e76c993ad00a4940d42856814f223f38c8d692430f00c45234b4ac280014a201776200bf87df19026a50a0a25c10e509bed5fba22e96c55be864a4125554a41575d40d69583334cb4774924a5ca410c631c4d0a0b15bea02a520137f9402a7014a21905925df503d6253f122f7dcbe5a9b4a8b6920ea6a7ade14a96e3401d010c0c5649014084f783b6a63f2a4221d4a254e3a3580b45e37b9a45bb1a8e1c80541401ee17d0c0861f9479c17ed6f7134fcdfda67c3dc366695e0f817b34f0c65b8646bd4842f319f9866138b6d52807ab08f4799615a92c29a929ff00ac1452efe61e3cb67f694f8ca77177b5d7b4fcb99384ec3f08a387382f0c12b2a12860324c315a3fecaf12a8e9d228aaf76fa32136e69f43e7df140172e48074dd8a634f203867a0ef1228633b121d6e58035481531875ef02486a9a53ca396be5b13d84724104a43172f66315962e5c003c2a5fa439219cbd3e1a74eb114a07e2a10c43471b6eecccadc8346a9150976dab0529b924073470c150414bb134adbf583a8d800684392c479c42ce1804c601890e2b71ebfac2b540a071b80c2a626d524ee2b7f0883532683a977a07a45565a608e14e5d81ba8a5cf9c002e0d055d34ac42ab0ef02003d413e705492e0925b7617f5485a20501c0538096a38b79c0ee80588e85f7f9431000651aee906a5de1804a48510e137d2fa8d3782cbbb0006e525fca90a1805071d6ac5bc7d758762c425816a6c4d6143eb2e90da6e0301059c20477054e08ab100027d7e510114a80a176671046db014705b68040f117abb13072ce0002ab53b509abf845858872a0cd6141e1089008074b7cbef8b002492dab7049866f904ab8248a061fc47f9c2b59c9bb02e08de1cac05383deb123f2856eaa0c1ac7513f743aed9056a0416a11b117884862c7512366a7ca096054524b6aa0850545c80017abf9d0442bdc1600e90cc4a53b30d3e9e0d810c189e95f5e30ac08d29243b31763e70c400ec4d00627ce27ae400024a80ab55d83bfada0ea354b8bd9af0a4924a86a00dc953930daa9a41dc1a5f7b436ea0500a9c501b5155f5e3e1108a54129b38604f940a06dc7f15493f2825d9856ae002e044c562ed027c213420bb8059c1ad626a647754c49a921c8f282545d8936707afa68adc0eea9cbd08b0b6c22ade7007041d88eae970ae860779c397ab55a9e7009b8a829d9dc976a7e30cdbd5c9721ddbaf944ab75029ad0aa80396a93f3f944d5a8d48bba481e50e13701806a966761588058d9fc1c5e16c5dec01bd59ba16617fbe23359ba31153d6082c69529a904d0c0d4e012149ab81e1100350582810cc080c2f101a33820548a398814e092054b58b8aedfca0820b1209e8c7f1a44adec0b34b03a5c129a0eb084066042943ba5887bd47e511cb073f10d4749ef3d19e14abbc181045496a1ac4ab58012c3bb574d402cdebf4860ec5d833a9cb1db6880a8bff00aaa3f8bd78c107600311473f8c447c00ba4949496097bb39ad5be7f9c102ddd1f0b81b9f5d218121c55cf79926d11458a48d5514ad4d2270964013df605bbb5a303e3f38248352284960e09a084bb5e951e35b57f18720b83b14d7c6f04dec06018b0170e09adda86254d882db5cc072929009703bb570221b904a9b7006fe71314d600fb269a48b3b12bdbf94301a99a843b9234b6d0a1d4c0b384b254ce40876d0194e5fa1707cfc23a20ee8b27d0284f7800ad605c8a3d23265b6a24d6b40915bfe71427480545c001e84ea78c9924950604b92011b5bf58da18364730f25191cdce58aac4f1b65fa5d40bbcf1f58d279d9dfe6d73354ec3fbf5991f11fed0b8d4f92a47f8bfcb1a8a71ce5ce761fe7868d3b9dc1b9bdccf62c071de64914605b10b8f4eebee65bfacfd941ed938726d0a8b80de1568c62cc6a0ed41f74664c0029c12c4d5eef186a37ddcd2b4158f9fadeb184b712244fba2462413f18346dc17d8402db5bc619258bb38e97305be01928a0a55c6fb473ef66b3eef9e9caf5d401c552554bff00bb9d68e024a682c28ed1d80ecd12fde73d795c82010ae2b94181b9f753a3dbe0edae23a77fd643f491bd0579c52f15f5a349e67bcce62730a66c78df3425836aff006c9d1c613885b8760ece7e2e91ca3cd11a398bcc34101d1c739aea1d7fdb275238b66904b021d4351a871b7e91e8717fe7551fe54beb65e5eb3b988aa14dbbb5241f8a282495380749268abff58b565208a0247880df585d209f89a8ef70d5b47898dd99b692c88cc0900b6e76f28474a4ee929a9ddf68758569243303de3f9c56a621806528dc08e69f96c642924872d5a124171f2852e0bbd0825c0bd62cb91603cc691ebeb0aa0c18b160e96dfa4537c3640a431052e58543b02f1003526e36bf8c0fb2e46dbb3080905dc58d6ac7cff9c55db701720126a1dc50b9a40a150775254284d4188a274d8312ce4fe70c1ca4259be7e50dd800a92492458bb803f94106cce402e2951f3eb112540824077f8490c60909664d47f0882c2c809a8512e3601aa3ca135121c558bbd431882800b93bee6210535601cbb96f9186e0725c86042b4f78dabe504395106eab9721fc1be70942e010da5c1140690c3751019deac06df7feb1376f2c04820073401a81dbc22b25ca47781bbb3bc3ea724b0ef124877020a402e355121c3f95a0da780166d4e0856e2dbde1810909a6aa5c0a56001a8db496f8947513113417007c44b474c36256e5d24152943abfcfd346e3cb080a482e4b8d2d715a46dd42b492a01275060235dcadccc4951482ed1ef7087cba987b4de9dd48fd75f64a152bb79f63f41a05f695e070481ffe32e587f28f5f3ce98ce9e1ed34db7bd23c82bd92e5bb7bf636ab15769ae08451abff0018b2f3f947af7e78b2313894a4544d24934223f65f7499a9766fb350f086abe99d13d1aedf2536fe2bfad1b56729eaea439666d47d5630d6c082cd4efdcba5adfac5eb6502e5fa1e95b57f18c39ab2a2431d4a2fa5246a4b067fe71f8c57b2bd99c175cb600759003251aadb793f48763ad3a5454e7bc82000db3eef15a494b024124e909201d03c2092895de604a43a42994093e1d378f2e654b3de14d434d2b5b151a69f2bd3c2289ab3ac4c2348517212494923a92616639284a7ba02b5101920f8786f142d64a4b8234d83b80db35be51c8d64c306495062914a90926fd5cfaeb15921252520a4a7bcf56578fe31485053a8b3377542a0f831bb43ad5ef3e2512525828aaaefb988d88422d4493a9c6aef274dfafd2280956a213b9d2a72ea2e453f530ea03ba01212e02165812c1fefad222aee9491a4574a8022dfd204e0f941fdafef729f677f67b44c514cd5f6aa99ee909145b70f63353f90b479beac1363b3d8d047a347ed84e208ec0dd97b0c582f17da9f1cb4a54ced2f86f1a4b479cccc2c090c09e96f558985941bf30ad6656952838d8fdd1ab65d9b63b2dc4c9c66071388c1e2b0d391889189c2cc548c448992d5a90b96b49052a49014140820804468b77b0ad0f5de190b620136fa7afd22235a4bd07b04ec7a2ffecf27b7597daaf86b85bb10f6b9e30923b4bf0a605393f2539a39fe35185573cf2ac3cb030f9266735442559de1109d12a792f8d94846a067256b9bf5aa274dd6a4cd96b44c4a99685a0854b20b1043d0edf38f0ebc873dcdb87338caf3fc8b35ccf23cf325cc24e6992e7592e613729cdf26c561d699b87c4e17152949992a74a5a10b44c96a4a92a48208223d373d81bedb9c9fda1bc0f94f668ed17c4395607b6c702f0d119666f8d99272cff848e5397c879d98e1a580996ace64499666e330f28033508993d08d226844a526aec35d4fa499531452953d08f84d7e6fd62d75e960502fa480e40f4f188948672c922812a670ce0823c3f18544e0a3a4fc494dd243fafd6208b19a1449d290da86926a900bfa3fac31aa8a4a81013a4901c1a5a31c35180d0f55288a39abed0e5687d2e0289d2585fd7e5027614a9c9400484f7401406c7f3fbe152a206b7252ee431551f6adaa3ef85aa4a89202096512359007ab8bb43000a5988aea058007e501832414280528b690e92c411480924a0829092ee08555fca2a9668fa124046a1de05875f2f18834aa61d2194a0e1fa52d020b0aa5a5c300bd2f473e50a56c4d58a2e4d013d3e51590ad44a404d59cb28a8f8f4f2f9c050673a8a412c12195e40f5fca256e0c94120dc6925cb1722f0ca982a926a0b86356314a4208491649ef543fa6de01698544001cb90182bd794691693f32d1dcb5d7a89052920d05d2de7bf9c5d2961258ec5ca812df4fce31c03a0a748297d4016a5edb885d46a40490c0a8b83f58e884ae691699aa26610513028325540037df1b9b2fcf178658940d74d14aef3876208fc63664b9c1989480492433b74855151628524105c10d716fe91d946a46dc95331f02d1966ccf8e7fda1ff6116178ff0005c6bdbcbb18705919ee1f0f3b887b43724b85b2e0a9d9a6806662b8af21c1ca4879a94ea998dc24a0f3024cd9692ad693f00599e533b0f899b25685383dda50dab1ee579762c89815dd7527ddcf92b654b9c922a920d0a4d9a3e1aff68a3d811378653c67dbefb1470619dc1f89993b8a7b44725386304664fe0c5cc266e2f8a323c2205704a56a9b8cc2ca0f20a953923ddfbc09fd269713d2f697474f867159ff00b645254ab49e6a452b2a551bfe923fd1cdfaebd097a4a3cdace4a495dfcbf69f0b09c0ae52d0b3310920be92a670f1ead5fb39b3382723f6347651c170a712e45c498f389e2cc7f1ca323c7a31d3386f3ac6f13e698956598f4a4ea9389978556094a973003a662541d2a04f94ee3f0c70ca512751b82a209f03e51fa8fec97f6aff0038bd985cfac2f15e40bcc78c791bc6d8a919673cf92b333032b2ce33cbd2b6198e5fa899786cdb069529787c481deef4b98e85f77e178ba8e93fd8e51e5b4b3f518c9a8e2c7addcccc4cd56961a944b12297da0ea4a8120b1d20ac03472ed1c0dd9c39efca5ed57c98e06ed03c83e32c2f1e729798b967f6870fe7b87d32b1d819a864e2f2bcca43eac363b0931e54e90b65254970e92951e72f825a824049d2c496248aedf8c7833e5dd19a69658e66005218860c4245ff009fe622bf79ef8862cee5da8aadff0028c454c246a034029622842a805edfd2125b77525d293f1541de2a4bcbb2353964062a40f85d412b24541dbeff00943a80582052bf100c53e514a0960a01a8c950003f879eff00282ec0074849b7f1797f3f088be2e55e728c874a19241008f17714767ebb412b0b00203049abbb9005dba6f1428eb0094a4ac0624109d3e3f87f4869742c549d42ec19ba522567a1292b5d9912dcb125e8e090429ba5e2f09d354eabb80d51d69152427e204299cd198bddbe8f1723e349d441350a2a0096b01fcba45d6366697ba356ca2519d8dc348f8bde62108d268c750da3c837db21c73378fbda71db8b88553d7894afb4367994c99b30d7dde5d351804877341fbb903ca3d7bb013152f188c4cb0907080e316544311247bc27e89358f159ed5dc6d89e62f68ee7ef1de3260998ae2fe7471467f366a400999fbc6758c5a48f029d368ecd2ae694e5e097d64457a77fe3a1d6a9ea254a48664d0902a63094004ea1aa85c97ac64ced4575aaac6b42231941ec5eb476158e2aad5db2b27d0aa617d576003de10a800ec4176019fca18021db63549a36d0a525c3d1ea2a0fce38a6919914a0e5aa4800f77c7a7ab43a58bea24299b48059a2a292ee6a5dcbd8c306ef2831dc9040262abc581cb77aaaa5800dd211fc0d4d091abee862545dc015a160074301252e529b5c8a5225276044a94413a696ab9b0871d19f51bb92f6846a3b00fde35044339a11420f7588a5a23777608cc4a93520803554fca14d028eb604d401530c092c43382c55f940524070439bd183c367801a1d20b37854b9eb0077490093b75f46030e962e1aae4982a246a2135772c5fe7f5874ba00009249a00281bba21d8820d8950b87f934285317615a258576826a4bb3934b30fe5683bbc80aaeed72016b4434048091b102bd2024120b3f88260535105b5697240af8889b3bdc1017506feb13a5487dc866f180c03386abd588bde092e6a6f773aa23a8207777a93701dbca010096a8277e910b2430200b382c4c1a8bdae4dcbbfa788b66cc00519812c2a4ec20b3a48507d437a1a74889069def1bb84fca19a86b6167da26cd814b04b9771b33c4d5677afc844367b077bd60e9616200a0b57685fc40a487dddfe70c013504d295a31a5e108014e5851c31a7afd21c10e7530176d8b3522526ed66086868413b30a4560134507a877f8845c92c49d2003bb822118a4a810d5a9706911e76022431a02e4ef5d3d22d71a43062f52ce935da14b0f11aaa49061cd400c181a007788caf6021a904805a843100d3783f0920a77a37788b3d61767bb867d414afac2ead34b125854035a1afabc593be410b921880920966a0bc2a831001292d52d6a082006600002cec4c12002564a4951b748ab6d80b1a90f42f449ad6007736a54397688a27555d4934d4481bdbd7480142aa0c4d457ed9f4f13b6cc10962035189371e4f11c97092c41651157aedf588ca6aa4049de876f5f480c01059810cc2807aebe310dbbe016a40bb92c9a81505a21a84fd97f8833136844f7599d812d51a8d2cd0db695329eae0c4a78b019443101df7605c57fa415070480ca21c3061f485243d5925b494bb8857510e3bc0172d623ac5934800d0b1353462092a0603529426c6e61881e058f466f5f94304a54484a4048aba6fe515b379040a001b920fc469abc84325cb0a2b70c6f01d45f4b6a258b9fa444f74f7bbb56d44da9611603a454b5092e41dbe70ec54695734705b7fe5006da802d7b39861664904bb1d89e91a5369659298505828b1506ef54827e7190870486206cf406a3d08a180456e92e525bf08ba593bd43ea77b18dd6d746c9dd5ce5de4bb8e6cf2caa1bfbf197396a83fbc25dfd6f18dcf07473879a0901c7f7f3337d41cff00ce17191c9850ff001679660904ff007df2e2c00a7fb425a31f9e85479c7cd02c3fefef33eeb01ff842e3d47feebbf5e7fd944fc1baf1386b1095126df15b6f9c632c9f2afd632e700a2f40f66668c35fe1f48f0ab6e632b5c4f9b4489eaf12302a4822aed4a586f021d201635bb79c12bb064c9f877777626b1d88ecc05239f9ca826c9e2e9543deff00a29c63aed27c051a9e11d86ecbfdee7e72a87da3c592810d51fe54f8f6b837fbc34eff002e1fa48df4edaa91f6afacd239b4852b99bcc848b7f7f33626efff003d9d6a47144c4b12d76a06ada8f1cafcd93ff297cc8a83ff001ef351dd1ffb5b39e38b2602e540b80e5c076f93c7a3c5ff009d54fce7f5b2f2f59980a249fe237a5550a93a400e4021c16a0f548b0a4bb2a84175116f231480e48d419dc75b1fbe3c492dd3319357b302d552439a30003d22a5a89201d54ab37d21c8045d8f57727f48521c0d419ac5abbc72cf38336b22820ea2192185c973f2fca0150d22aa0f4483610c012e74bb59cb9804eec0d2c6a53b452d7c02b500cf57342c2a044d3fea555aacc20b1d35635d8d44292c03b04eaa26e6f10c0c5fbce14360f630c92402093a9db48ad22ba295504d1c0e8d040059c170ec1aff003863a0e83a4252496241218beefbf48269dc620f81a4292a2479580bc312f40dd03d4bf58969ac580010490751635736f282c0024b2b52e809208300a5b5105dcdc9d3eb78ad248041ee97a1670af3ac43df20b8dd475774a5cb0736b79c0702e054b50d478c46ef0355122c9606d488d57259cb014eb12ec9dd0155dd0922c4311d60821892e43505cf580524bb392ed5b53e706f46da83f860f640b5d924d414f5dde001a839703648d8f53084ec5c106c057d79c107ba58973425eb1d10dec5a3ba2c424ea52750d2d715e948d7f2b3a66a2a69f080fd6343451ac962c46e635ccbdbde23cec033563dce169f7f0f69bc564fd77f646a0e2bda03d8be480fff00aa7382965addccf70932dff623d7a73e98138dc70ab89c4f888f226f63ba929f686f62e2b4bbf693e1261fff007494df947ae971086cc71a69598c06d1fb07ba0ddf02ecf297e2f53ff7291dd5eca14dbf07f5a36bcc2492ad459275357e663089d608d2c5f5951f8a9bbc65ae6052b49eeeca0cdf9de3050477dd88297293d2dd63f20d462270b4f61ca421c15005552a2b7b55bc7f389ef0cc1dfb9240514ba48bb12df7422d7dc5904a425800c18f99b9f946232929d435241984a7ed02186c0d7f58f2e6d6c458cb2a06a951592aef8ab0da292e4871de724d4929fe1040dcfe501049499ac52125fdd90c59fa5fe5114953a986972e52cff27f5f28e595aecc1ee5a544972a21413a06a7d07f4842a14342b5963a8387b420d00b85281173a5dfc81fc62b7492123501a877c8ab3dc78c5481d4410c901ea544073416f315ac52495292546894b067a31b8f5bc5931c10a042a8594f5553f08ad24280eeb53baca6662d580f61f239fb632b29ec4dd8eb0e96299fda5f395a883fc3c318c6fc63cea8a48ab909ad0563d10bf6c4f50ec85d8c105d95da13892669d9c70e2c0a7ccc79e010e9653de80076f94217519244e6c6256eec0181e00b0268378b141aa43b1ac28009b38ea1c08c082d41601ff89cd6bf48e48e5af31b8c7959c6dc27cc4e5ff12e71c21c6fc11c4185e28e11e2ac831d332ece720cc3053933b0d8bc3cf490a4ae5ad20d0b10e0820911c6692680335c903c22f4acbb0f86cc3e91bd39dbd164a7d1ec7aa7fb117db4dc15ed3ae567f86fccdcc727e14eda9cb1c8e5e238e784414e5f85e71e53242651e2cc825fc2b5a14529c76111df91326257a7ddcd96a3fbc292484a82b5258801db4bb36df28f13fe4073e79a3d9af9b3c0bcede4e716e63c17cc7e5d67d278878578872d9a513f093a512e89897699266a0aa5cd92a74cc973149218c7aab7b22fdac3ca4f6a972264f10652acbf827b4cf2ff00299387e7cf25ccf4a1723101225ff78787c13ab119563082ba0d78698b54a5fc2952ba9d0e6a7de47a6e4f2e7c8fd72f7e105413a8ea5304d8bdbcbafe915eb5384b9d058906a0791da34bf7852a2ef537bb7846461d456439ef6bd352c0d3c778c9d27ba2ce1e06a885294090097b697245afeb782120eb4228e977528a439bfa3d22a0552c7788049b81468b42ca9c800b0a106fe75b6f15e4651ab0c3bb2c2482c2a5813b5fe507582c00510eec9ab35cb9ebe114ad4a5252490e003a40626f0a01228fa48d2960c525bada2b620c82a0a6d4c0eb3a58d77bc29255a92e1817512a2088a006d29569005c6972aad5cbc5eee59c6a353b38e904bc0159512cb000d25890fa80f5b438297d4a246ab3d1c7898ad4a629a848763a8bbbc3a4d0105258d8860db915b562c9b24b16524148d603ba18914f2fca2a042144586927531d27e5d621504a892a001ef170e3c5ab68af515161f094bbb599c8fce2f1966ccb2693ba2ed5de04300ab10498be4d4e9d55455d8a40727ef8c14300ea7526ecec12febd5e2d2d5500faba56df9474c5e2e8b2b1ab20e92929501a9203ee29d3a46e6c263f0cbc262f019a48918dc162e42f0d88c262e509f84c5cb98928992e74b5029521492a494904104820bc6cc44d60aee92c9a0528249f330cb9cb29607bad56a94faa475d19c64bbba8b0595ad63cfa3f68c3d842aeceb9ae7bdb7fb1bf0ccfc7f674e26cd266339cdcb5c9308a9f8ae44e67885957f6860e52412ac9314b510583e0a6900bca5832be3727e126cb9c44d0a42d1b8043347b991caf28cef039ae47c4595e5d9f70e67f809b94710e419ce1118eca73bc1cf42a5cfc362242c142d0b4294929502085479d67ed09fb06311d8af89736ed69d94f87331cd3b1f71ce63fbe71170d6112bcc71bd9f736c54c3ef3073161d47279f314f859abff009b95192a514894a3f43ab8c38bc977f52f5ed86d7e12cbabfc625fdf4afeb27cd13cdaef07e737b17bdb35cd4f65d7373fb33354e67cc0ecb7cc6cce4cae71f288625d726d2871070fea21387ccf0c8aec8c4a11eee65d2b47a8472af9d5caaed01cade08e74725b8d32be3fe58731b2295c43c1fc55944df79231d266075c99c8f8a4e26429e54ec3cc65cb98852488f133c7c95e127290ca4282a85d95ea91fbd9ec39f6d271a7b3779b12796fcd2c6e6fc5dd8e79a39dc995cc8e0f13558bc5f2d31b308948e2ce1e965f44f9208fdef0a96462e4a48204c44b5a7e3f5308d1aca0d58c9ab3b1ea332f52d12e6149d45374a4a80a0b8f568cb96c12400a2403520803fa4683c11c4dc25cc4e08e13e63f0071264dc6bc03c7590c8e25e0de2fe1dc6271f91f12603112c2e4e230f3524821bbaa41ef214952540281035b5a421929053a681292d735dfc632ddd912b23a564282b4d5418393aba45a14e002e4d5fafd23191ded2410ad3b02cce1a2e7f77a4a9c872e137e8fe1164af84126f63210e12a160ecc49d46b606d0c09041672683c6966dbe701202c827bc0ee1c11f28549294a9652c407059c911a2567b168e11900a8004a8a857cbc8c5aa9ce1252a530be9ae9fce310ac2c2484814b135fc615292a2a2a530b02fa41fbe2c93c32fb1a373078993c1bca8e7271cccd4b93c15c9de27e2c9849d24a72fc8f30c5d4ed59423c4c389f3439d66d98e6e52a4ab37cc3139ae93520e267cc9c07fe9c7b167b48398987e54fb387b7bf1de2311fb94bc9fb2af15e5c8c423e3953735cb66e552824bdd4bc6a53ff006a3c6ff1a92944b04304c84218ec424036f178e9a09a84e7d36fa1110f59f858d1a6952967512141201dc4621b00c417763427a562c9cb620024b3926e6b153eb0e6c37f28f3aaf96c5649ee56402a3535f0bc0600172e7a1ab7afca0a964b1d25540cd71e715934aa5c354817b472b77ca330328b9bb5401bde2248aa491ad42f504410e492d5507d41541f2804072d46b1670aeb1096cae094ab9621f5101ded6866170f5e82bebf5803507296f3661f3afa782038a77544f47fa43a02268925aaf5d9e19401a077771d034259ba8a10680c31003822be7b41bbe063a0180347725c015104b50bbaaec76f9c2eaa6a650a80ccf0a1408a020a8d4b386688b6360580d5c3b7803d778520595520ea2a1e458410485778d3a0a0bc426a5cb16a51fac4e520106af5a8bdbeb042e8d572a77b54184018d1ece5e861d249b00ef5de09e2c00c6842a8d6b93e4221b025440676a924d218a92925c3ef76d30a198906c28e1c1b5a25d92b020fb7570c686f4f420e9648ab06a8de9bc0704925e82874effa435155bd2896a7ce22cbd540162439201f26f180005692189276043784073deee692a2e459dba4301a8153e93720966f9ef119b800e8496dc00cd06e6b44b7741fd2214d085061f6773f578034b3355e95d3ebca27afa4004b8a5433124d5fa7ca083aac74bd02ab5f94420303dd73524d40842c1831772e2e130575803149a5680548a887eed492a0d4a3bbfe915ba8834af47afd20295776a8b7dadbf4895e8dda05b5014cc4022847de616897d5602aeef510a496040706f4b4453e9766ff0041ef5223280da4903490e5e84b30f0313bc00d4410fd6822ad47527c2b66f95e1e8d4538ea6c2f12aef00291d0804172ca73f280c9b92403505debd623bb12e480d662690588ee904801fbc971b4434acac0092d52a25cef6ded0e490349539350c1898ac8213dda81b11114a64bb8b062537b437c81892c182b493b8b6d0416767040abede0f00105dc292c5dda1c00c685e85c1a7cc43a5ee00431a151f1341b42a68492ea06cfb5690e3487772097fe10a885cb93b963a40a5616c610175000821d92c93527e70a0967d44f8d84115d4ca4900e9538bc297ab00002d42efeab11d136074a4dc17a172ffac17ee949ef38a0771f385512c4bb026c05e206000aa68e03436b3012900805c0b3758b0a4170c02477bc042b5188751a0ef303f2de1d2c40b159a1068db88b349ac01431d4cee035cbd7f38b025c690ce06ef4dc454e9d45882dd2d160200705ec6b7262636be00ee01a14970e2acde1052d52e50007049ac001c93d0d41a13f288c4b8209d552c3ba2b58d63b12b258ee9480ec6b42751a45da490e951094fd87a8ea62909a800337c2406f9f9464202935d20b7c459dbce3756be4dad6472b725c81cd8e5a126dc6f97518bffce1378af9ec09e72f34c125bfbf7991006ed885983c9c63cd6e5a903ff5f8cbc150dffda1346f5689cf104f3839a4b5124ff7eb3220015ff7eade3d3df85bfed3f60976b5bcce199a0bb17bb84dbc23196295a1e9d3ce3266d5ab505ad43188b7fb5778f0ab6e612bdf229660cefb88902246041208ad2cd5816820b1f4600ca96cc58b3d4785ad1d82ecc44279f1cac5331fef64a258303fe54e8ebecbd44b30d4df231d85ecbfdee7df2a92affe5b6524ff00f4a9d1ecf08fe7fa77f970fd246f41a55237f15f59a2735d5ff293cc653b6be3bcdbbc6fff003d9ecd1c63354c1c072ce492f4da9b472773502bfc48e6300d4e3acd6a49a7fb6cfa4718ce6297eeeb2c0396a36c23d2e2d9d554fce7f5b2f2f59980a25d4c469e847d76f3bc560034a3f5168b16a248048a54b3866fce2b20b33ba8d80156fe558f119949abee2162ce4333e9a26b01443b925f762e07ae907ecb13dde8f57842c3490c4fda4d697bfade39a56b99751c109a06600d4b3c280901d46a43355bac2821249748203801e86213504a8b90e69568cfcc0947007d00734884024120f776b81588a04d4805c3106f0d57bbd2803c5700524b9208ea4d09f2824800d487f928c4abbb920d482f6680ee0972002c48727682f2041f08704f5ef393e70e0fc2a60366a3aa152aa0201a1726a3ac46201006aa3bbfaf4625790148ad0b925c82ce088009049012a20bb6c21c80766604b9246a8156d496751b9a0dff009c2f6c5c0c2be4d60c1a916392749d2a041776a788f18a9249a86005355dbab087a024872146841249845be805a115550fd914b3c1a69d8ba6a5c388269a4a456c057c6154c486d458541a13e504f376070c35100ac84d5c8f5e842a680b8ef11ddea226e59e95aefd7d78410a2141b5310d507a1de37834b6251726a43d1838fe231aee5d4580d525c8a523414b90090c4d8558f478d772f534d0c0b3877dcbda3dde16d2d444e886247ec7fb1b657bdf68af62d41485ff00ea8fe155d4b9eee3d2afc9fe51eb8fc4ab09cd31e9a0ff00328f6b479217b1887ffb46bb15049254aed1dc3000dbfe74b27ee063d6d78ad4d9b662953869b43b1602d1faff006f1f3704ecfb7f8ad4ff00dda7f61dba8cc295fc1fd68daab502a3471d1ea22af79a7584e952ac12a0294dfd6f08b98a490ce5cb0770dfca31f5a9412a41510b4ba8905fd78c7e4ba957e871345badd3a88770d4d3ddf27fbe14901800529154949003ff003fd62ad4ea607ba91a9f5901c5dbaff38b120a5c9ef198f37e2234b5c6ff0048f22a6f728fc196254c4ac9209354258807a0fa443314424ead21542750098a8b2819941505c2b51246d48a9d40a1455a0924900f795d1c7e71cb279326efb16ae6218001d2e14e0d0f4f940131041248059881415ebeb7f28ad04ad6aaa8108a02e52985ef28aa852545c92080af5f945482c2a254c59434b820849b7a78594e9241d3de1427ec926ad0856e411de480ec924876ad7ef78792b595072aad404b96f1110c1f20ff00b6333bff0052976299208017cf7e2898dbf7787d23ff007e31e78caaeecdd5aa63d0a7f6c73fcaecc5d87e595175f39f8b67125dcffdc4901fef8f3d7517040b1b8fd3f58885dc192b6663331342540d1b778ac8b03473169352a7507b3035f0853a9c13d2b43f8452496c882b2f6150db522c40502000d46a90c6017bb3d6a03b1f5f943ea2961726d71111767740ca94a29adda8e0868ed3764aed63ceaec69cefe07ed03c82e30c6706731b80f34463f2fc520aa6e559cc8d49fde72ccd30a084e23058a97aa54f90ba292b7494ac2549ea882a6bb8371d23225cc23f880454017f0f5e11eae8f532a351497ca8d61356b48f606f663fb49f935ed46e406179c1cb89785e12e65f0ecbc3e59cf2e4c4cc727199a72ef36989ef4fc29202e7e5b8a5256bc362748a775612b4a847e92230c6504a94ca2ecea62f7f4f1e3adecf1edefcf5f67af687e16ed03c8de20180cdb2d58cab8b785b3252e6f09f31f259b31271b92e73870597267243a563bf266251310414b1f577ec35dbb791ded11ecf1c39da1791f8e12a5620a326e63f2ff198b4cfe25e55e78996956272bc7cb1532cbebc3e21b44f94a42d3b81ee6a385ca7a35c47471bd1c295be037b27e4fe0cbc7d179b5dc8dbbfcc76d1734b90401a54e41bb353f130d2d60b94ad286d824776bfccfe90931907555ada882c2c58f87ebf4c6993d20962097d259cbf8bfe7bc7873a56bd838ab58d47de243924778305518fcdbd3c22a62402412038041a82e6c6309256a6d243a0321367705e1940804a96c41d25892078466e0472d9dcb84f24b1280caf899d4bf38266005800fabb8a24007c63174b9d2ea487beeaf9f845c955425f77720d1bf38c1c127e451a2d0a60cc14142f42cdb1f1fd202144b3a4b1172c430b37808a4809d49512104bd2a474f31487254a4a5292ce412a0a3de3d0f5884afe88f604cc4cc750d4ea04114d23c479de0234832d201012aa85172afe9b4328b1086237514eaee56b682015b0258a50d4b0d8fca263e23cc2a5965500a9d837afc6152b60082c0529e3d7f068944a7e25936b90f6bc025dbc4540490078febe71ac6562d176df618cc2e0bd362e0134b45d29692c56a2c55a5247787e1e623101295825354b805c9481514fbe2c3ef524842682a6ac2bd2378cb382fec3514cc62ddd60a1a4b02079c66e6f80e19e2de11e22e05e3ae1cc978cb8278b328c4641c53c23c4b97cace387f88b038994a9589c262f0d31251325cc429495254198c69689ce9d3561de208620fa78554d5a99941dace694dc7afc23d0a1554ed09f8af6dd755e6bc49ba783cccfdbe9ec33e23f67ef1c63fb40767fca339e26ec5fc79c4253956291ef736c7722330c64d793c3f9d4f3a97fb9a96af7581c74e3df7972662ccd29337e6686197875e95a1960b104347b8d716f01f01f35782b8c395fcd3e14c9f8e7971cc3e1ec4709f1c707710e09199649c459762e59973f0f3e4ac14970414aae95252a04100c798afb77bd893c6deccee64cae6772cb0b9a71af639e696773a472f38e1958ec772e33056a9dfdd6e2258732e7096eac2e266327152e52c057bc96b11df5f47a7d74e55e2fefd6bb5d24965b5f94b7947aaf49754a9359bf89bb7d83bedd3e22f67b717617b397685cdf35e26ec61cc3cfd13711ef573734cd39059a620a652f3ec9e5b950c14cee9c6e0a58d2b08f7a8489815afd23787b8ab87b8c726c8f8af84f88727e2be11e2cc9f0fc49c27c57c37984acdb87b89f2dc6cb4cec263f038b964cb9b2674b5a1495a09042a3c42a67bc9734fc4e0d410c151f55ff00b3f1edcc57633e20c83b2376b0e25cc715d9278a33a387e09e33c4a66e678aece39ae3e79267840798ac8f113a615e2e4cb04e1ccc5e21093fe6255f36e4aa54963d8fa154ecee7a34a084252c40ab80a01d4c3fa522ef7bad8390a6d4038d0d66fba36e61b38c1663270998e5d8ec0e6d9663f072b31caf36ca71c8ccb29ce30b3e589b86c5e0f152c9973a44e96b4cc44d964a569582098b578f9694566565bd03ba81afdc7e8f1a283f94b7358d7953b4af4966525c9a75b7e50c2695864950511a890a0121fa08dba9c626610e5490193a49245fef8ce973741651ef200a25d4e2e2be158b72bf009e4d650a4850ef0701cd43abc4785e2f98b0a4967601dc335e9ebc23125a8cc4050a289d3a45fc4883abdca4853801dc9abf9c5a306f725ddfa28fc78fda0ce60e1f97dec66edaaac64c44a99c7396f0c72d72f71de993734e25cb0fbb14b94e1d7f7c7945e6388266cc03ba12a2c411500d9fa47a55fed5f730e470f7b2cb87382c4c44b9bccaed4bc3184f765fde62a5e4f85c7665300f0494a147fea88f342c44c52a64d51d44959b12488bb9ca2a546d64f37fa2df41109593b98aa35fe10497a8853a438494822a9f1f288482285d23ad0faf2842a2a0000ffc22ed1c13d99125710bb93d6cd44da14ba4002ca777ab43380a2da8b0ab8eaf03c490522c012fb471b567933082fa8800378b030b77f27a51a905d4e7554d19a9bc12493b92ecdf285da448a4b021cb12cc14d11dc51c1760453e7f941528a5ea770fd2cf08544500a5ddcbd618b5902c043330d49bf5b7afa42be90f662c09678849a021c9157dc9b44e8a2282818ef0bbdc0144160495797ce00b1d2e4815d9bca2121c5df72050c43524310c286c4d22b7bb0381ded5bbb350b442e01748d20d145a900a8867157603af94104e962280beed5fcbc2263be000804f781d5a6accaa52180094909660aa543de0b25dc020bb1036e90aa3a54525fa8005e26dcad8033953dc9dcbed68043125c006c9a33d29049206a6b5417a404a9d3a88376a7788b5622f603035b802fdeb9860006606a9fb25bd0852b34097249b0fd2277ab536ab55a9d616f8c06350412750a804821bcb688050b32890e000290a9340092c6e06c3c62150258d59c357ef1137b819d2580e957341100a5541c92ee59c4564b8716b28d6af0d52f5600b6a04d7cfd6d118208c0b8b581720285290349059d980bb3f94153dc1049b9258429d43a3a580d3e7d2253f027a90ec6c450b541845063b94bd6ac07ca2d7371570e5c33537f080a1ab63d7c3d7e910f390577538700f8dafebe70c2c75120a430d059c45a9450e92ce580218bfafce1400c763a2a439048897b600a34a480412142e487f088cc192d5ae92ce7a4374357bb9a8310a6ae1d2686bf6b6885e0001cb1510d6297a4329882c491b126141370f424ef51766e8d04ead760c0541a35ad129d80aa53001fef6f54894701e8038b0d34820126ee09b0310ba5bbcef401d9420acfa64041667676602e2f0c189b84ec47c3e3f381504122c4d5ad5a403d542892eee690c5f206d4c96a16f8753015da14870c0b549a1110ec00268e1ec3d3c1725dc93d1ef7eb10c089a1018ba5891d7d7487012410afb576627e51183a883403bc08627e5f482ddd667a3904b7a3e105759400589292493f66ae4f48090083de24035147f286a92e480599c9b08203a406d290594402d6b9895e4050aa80c0e906a1992f7fafe50c0b122a037f33580012c2ee599de9bc173405f4ec3a0b42efa6e050ce680051a78fca2d0589f88d6ec18c57de2c4311a98bbb81ead0e904b87a3dd9d47f9c593c58169218921cb90c480043021900920d8104070f15a485071548551c313166a0e92355031a36fd23584958b45abe4b50e03904822e48a748b98546a77a1237b51a29402400a2e1b506153e5b46425c10e0a4866041a56374ae6ab6394b93207f8b3cb324820f1be5c8228c1b109fd440e789279c3cd0d201ff8f1989007fe5d50fc9d1ff2b1cb55b951fefb65c4b5bfe709fd631b9e24a79b9ccf45493c739902f463fbc2c47a8aff00732ffd67ec8b62c70f4c352d61506e631554352e2e41ab464124bf4d8d9ad18ca15aee685a3c1adb994bd660ee82f71d3a4481460c2bbd6f1239da4f72a43524f530033d6dbc1b9e83c6259c50f944832e59096b1276da3b05d98ce8e7c72b142e9e2c94435ffdd4e68ebda5c8760cc4358fce3b01d9909ff1df95bb371649dea7fca9d1ed708b2d7d0fcf87e9237a0bd38fb57d6691cd348ff11f98a54588e39cd4b8ff00cf277af94717ac02e0ddaecff77ab4729735013cc7e618f841e3acd4134ffd8d9fe11c62b0487ef3827bc583787aeb1e8f16fe7553f39fd6cb4b7b1a7a921c1341714dfeb094700dc06fe9f945cabd3bce49d24b90f5262b5330a92f42ec1a3c37e651e1dc42000edde3b6e7a93142995ddd9dc55a2e05c1d24863563f74566a42ee9662d48e76ae8c442ce585851aadf388c486173514729f180416142012cfab6e862020060fe262966959ec095d83ee492df744500c43d09b302441a927607b9d7542f7adf0b0724960444349e10082c4851602c6edd29053725e9d1803019c851da94bf9c1b1362776a031166b202ccc9a56e3ac28a9a160cc03344a324921ecd77f2fd218a00042869a6a2e456971069bc8174ba92e350725fd7ca232580009abd5a9f7c451a29804b0a117897b9a1037dfce1bfb00c59dc259befa0f18209008a11662036de30094850a1d2cd462fd5a03f79c02412c43dfe7137b3b2609606bf3173e55853a8f7824949172589a414f882ca3ddb6d0ed4ab129a6926c209bdc0454b8ee936e83c62693a880124b5de81ba0f57884bb86d4909da8055e02080439d9c6e5dbd52368ab5ac4abdf05e9005c92e08666d2635acb87f9a2ad56162f578d1104294df22490c635bcb9404d40340ec7adf78f678736abc7da74477c9fb43ec53657b48bb161580c7b45f0e10c2c44d9eaa7d23d6a38b94467798015ff00301fbbfa4792dfb148157b48bb14a4103ff545f0f3752cac418f59ae2e9a7fb733006a7dfdc6d4178fd87b70efc0bb3eff00a9d4ff00de89db5ace349f93fad1b65435b04975bdac7cbcc4636a0853351ca74dda85cc15cc3a92e08a901b7f9c3a8ea08510e1d92c1c8711f956a329dce36ac56957748a3a400cc7cfc9bc62e532520150d446aa240578102114a4a4316556aa661147bc762540ab512e7ba474023c5ab8583396cc65ad6a0a0010757740501f79fc3c6114b1a5887292da9c02296358556a983501a4853848b86a16eb085686530491d5c8009e9fce391ef8327b97a554621475aa80d36723f38807c20126ba483de0cfe70b249524390e2a09a94bd9bd79c382a49052a3a4a9c17d2f5f28820b2c9490a040bd1be50f24a685074a49d2a6fce31d5368105dd40be967b5ad4b44c3ac166082c1c12bb7837eb10f607c747ed92633fe403b0ae0c10d37993c658c48ea1396e125bffe9479f62921a8091ba6cc23efe3f6cc66251caaec038742982b3fe389e520d1c48cb52ff798f80853924866b10f7f18b52c26847a98cb4ea7209707ab3787ae901ec1c97a56c98b1496d4ad292e6d5ac23805b4f8172e778c9ef648084259ba1ac45290a05833503d622fe266f8763e1f742ece5b7b7e5146b38010284824b170773f28b92b5248b5454dc450ec433007686241729a38ad685a3584ecc1ac6167a90a068c2b5dab1fab9ecb6f697f3a3d9c1da0726e6cf2d7329d99f0be64a9593734f9658fc62a5f0b733725f780cdc162e5b94a27cb1a9786c5a46b933199d0a5a55f920853115248bd69e1b46b783c62a5a92a4aca4e9749b37818fb3eccf1a5c3754a55a2a7464b96707eace2f78b5e7e3ba7959499d14a714ad2d8f69becd7da8392fdb37917c15da2b901c412f88797fc69830317835cc47f6ef04e6684a0e3724cde402f2713875ab490aa286952494a818e6a424a0a8a80efa81482d503fa4795dfb1a7dabbccaf66df3ef099f4a9f9971572338f27c8c979dbcac5e2cab01c49807d28cc307294744accf0414a99227862b485ca59295d3d47f959cd4e54f68ae52f05f3d391bc599671d72b78ff0029466dc3fc41964f4cf4c927bb3b098a963bd2713875854a9b216cb42d0a0447d1769bb2d4f4742971ce0fcd3e1b5dda127974e76bba351af8695dc25855629c9654e31bd4a7cb669e1ff16371ad6535d540c90c97f9888a5adc8f893f659927cfe558253312bd2482907bc406269b98a5d009d45ca8def4f4d68f82a9465076306a4b28ba52b5280524a4247c6ee1bab45a147e125d4fab51eed3c22a42db4a46a4a5dc10c1cf5b6dd2205b975690a1b02e29d3c3c631e5ea2f92e5e92b497251b6950a1f08b12a21292e4149629164fdf6ac617c487049635d2417f01eb68ca131225a34820bf78d13e623170b32396f92ff007854e7e15be9241727c2150e0a8124a9dc2294f9bd6295109700690efa95510a82e14c0109357340760fd62b66904b17ea6615aa6332450d74b0fe516a53dd524aaafd438fe518a0b1d21812280ddbc3f3f38bc2e88b0a30b126be51295b616561bbadf097b0054e01f189a4390d50090e589347f9434ba052ca41043d4775c8b1eb478ad61d42da00d2e28e69fce354ad822cfa14eb006a51f84b5dda2f944a805006b52e40fa78c5400ef6909209abb3f9fddf745654520b12474760691a425caee4ddc5dcd59334a028120101d04173e34f18e38e6ef2a3967da17963c67c93e75707e59c7fcabe62e4ebc878bb857389226e1b11256fa27c955e5cf92ad33254e410b96b42482237a19808603490a72a17da9fd7a45a85281724b9b24866bd63d4d2d7b625f634d6cd3e8d1aab33ca97db5bec5fe677b2df9d3331b932b30e607653e65e61371fc93e6ccbc2954dc1214eb5f0df10048d32333c1874853fbbc549089a8d2a3364c9fc34966661a6380c41ab55f668f6d8e7bf67be4df6b4e4df1bf67bed0bc1d82e3be53f3072b5e5d9ce538969399e553b49f71996598900af0f8cc32da64a9f2ea95245c383e567ed85f646f373d963cf79dc239bcfc7f1df23b8d71388cc7925ce34e0061b0bc59804ab57ee598040f772734c2a1484e224a592a23de4b010ad29ebd469b4fa8a2ea249558a6e496d25d6496c9af851e9baf4711c9c797767eb57b017dbbaae44e2f867b1176c7e29c462b9099cce4e4bc95e70e6f8a562b1bc89cca72c0c3e5399ad4ea9b906296ad1a9f560669428032953347dd5233998b9c5e6499f2e74b44f9188c34e4e230b8b95312172a6ca9893a5685a4a5685a490a490418f15344d992268992e85343ba770691f657ec08f6e0ab873fbabd867b6571a215c1937112723ece3ceee29c6be2b97f366abdda384b88b18b3fe6e5335653fb962e69d78298b54b52972172d323c4d155a4eb3a15b0ba3fd5fc7d7bc45d9e4fba3c1e3d24052940a430292413766fe5d237248c485977abeaf78140293f2dc5be51c5e84e2f05889b86c6ca5e1f11226e89d2a681a92ec41a5082082920b282810482f1b93039921065ba829c30259d4c3d523d39e955af12eb7ba3922562004dc6b60e09678bd534cc9530b6b2525d20b15536f18dab85c799ab20160aa795a91afca5a8333b921923e6d56feb16d2e91cea28b469157763e3dff006bd78ca5a7b3af62be025627fda336e6b715719feea13a55365e172ac3e1133155fb2a9c523ce3e03e71014a3572483f9c7db5fed80e728ff143b14f06fbf4a8647c9be21e219f87490344dc766f87941646ce99040f011f1298c253354ca1453d368db8969614746aba8db99b77f15d2c52d68bb78fd860eb03530a28bd056159ec183500fbdeb1144bbbb9b016f5e700a802556a57a0f947c9ce57664ddf217ab1600dc5ddbc7d6f0144025c51ab471b4021f76a3b82c5dafebac56492e4120b378131cd2dee882ca153bb82188b7ce141160766346fbe2aa82c09277037d9843b94b39040a1a3111557d80ca60748092e18825a1082e4301b902a3f1f4d04568589d9b7872017a0a8b02c77a0897b640ba832411422bb3410970b24009d83c4f85800482280b4148b9a3ef4b7dd0dd5c041d80008d8f89310a4bb380c1d835623035b02451d99a09a3b14d2ae036d10d2b0f6084792bccb34401ddd4cadc1a433153ea254a7a96681a5aa58021ba9de25e1806a70ab2766000304d2d555c3ec2d11980000601df5547840662e3553a9b5616c00920df70ec3ad60b80cd472f6788a666b50331a9800ab6292502cf53056402c3e6cc43d5510d003409b52f108701b4a5ae0f78c4001b977558066f941ed76014ef9ddeed7febf9423280068e6a0bc5aa675778973dd17308524b5c786e3c60bc2c044b3b976351b87f1fac5808a25d86c45044503422e59c27e13eab1091b81e0096f2feb0b75402c18545dbce141a9a697dc541afa680c40b36a2180b8f5d21cb5d806a9076ac127b2040fbb0fb403fe704d9c51cb2588610a96a310c456b777311c00ee915fa1f5f8415af740b0d884d83b951bddc4564b824062f448f852e3d79c004072efdf72d7305d20aaac0d4027e9092b818960e082c6a199adbc420048249a53ca1353b39090ef5ded163ea5153a427480c7ed31f5f5826c09d4b93dd72d4f5e51199401045285b50f282a166506f03d763eb6824b35f49377f87c222ed302a81f89aa0b03b98526c58b37754430b4594d8dfab36f58adec4905cb0069f285d82d00287c44294370e05615412406676eac1e23efd1830f1e910d479d6a6bbb43a01417a28b10f5b830e541f48aa5d94fb9854b30a1a519c30829014a34d357d3a9c1eb58b59a43d8125da8f562683ee82f72a25d296b3b980580366f89d9a01ab1600aa81eb0590401ca490e496490ce3ef8b0e9753b12280ec29ebeb15160ecc3a07fc7e7160716202ba81423ca0ad6c8225c6a0970fb90c605024001ceadfcaf0428934abec58b9ea22351608153b9b7aeb116f00104017252a209280ef0c1cea0695601a112c411656cd46f18b027500a218f5bbfae9174eeac09a425443369600dc98749054aa0247c98bdc0fa42a4392412ccc6b58b129a8d40822a6a351f078b2b6c372d4240203d527bc7ecfca32905c8a9048dea1ba18c643904690e6a1bf3fd232526a4fc245024173e7ead1d31763a16158e55e4c27fe56b96a07c238e32eef691be251189cf40aff1839a246fc7799907ff00a217199c98af367968c589e37cb89762036253fa6fd229e78a92ae6f733cdcff007e33137b7f9ea31eb269f0bff8ff00650da367e27092ec4f55379748a0dacd561d7e719539405ae4b3ed18ca22b677e91f3d5adcc632f598bf2f078901cd9e9d22462549e74822f42db3ed0218161f371476820654bff5123a6e7c1e3b05d9900573e795a1bff5eb94a3d292a79fca3af72767ab0a036ac761bb3101fe3df2b0ecae2a960817ac99e23dae0de9711d32feb21fa48df4ff00858fb57d6691cd20fcc6e6305a4b8e3bcd85695fdf67dff18e2d9cea0125c8407ee82543e51cabcd16ff0012f993a94120f1e66c6a1c7fcf677afa47144d2751297a12e481f77ddf48f438ae35334fe34beb65a5b984a511a8d5c96171e7f3b7d62953390d521983fcc98b0ea04122ba9e9522b404c537b920a6bd0aa3c2a8d5ec6536ae02e48274ab40a0ddad0aec68ec4fc3f8987012c54685ac58d615cdf5786ae918cb19466c0e2a0976614a8800b851760d5fb29260f703e9a13b35fce114ce02580155034f28c9a5d02000355082e9a1512d0c598330af52ff0048041241a0a58da091b8008772544302f129c559822817028401de3a8a459efe10c0b8d25ea5f72206a04800391f11a31824bb86662db3b758856780035f22a706baa09157048201b82002d0aef4626bdd077f3fa40ef38702a9201356f5f9c4b4baee06d46ca04debfac2e9d268e5ef7f4f05d2157a02c5a86a60022a06a357bb1115c82696662ea2a67513a4088c49218b0bd4807d7e710825ec46f0c49737a06a6deabf58b5d5bc80c353a4a9408b000bc425988a51cb97069b422542a1b6b1beff00587d25810c7f84529109d9dc10167a775ea082c6150003702b4772d7f9c30340fd6ac0353ac1003a5831a1268d507ee8e88dee4add162524ac0a552c5adf48d730214260248606e41a7aeb1a1a4806a14cce0d2b1ad607e24a48704b8a351de3d6d062ac7da6f15e923f6a7d89407ff0497b1205b90bed1590920dcb271647e023d61b8bd67fbc198b6b2a38920a454edfa4793f7b0f91fbcfb4cbb10c9d95da1b2650ff00b387c7ac7feeb1eaf5c54aff00bbb99b972716a2eec45458f58fd77b6551cb817025e146bfd35d1db57d4a7ec7fa8dbe5c0725fbce0124e97f46321139d82b5258b121d44bf9462923bc007a54f893e9e164101435aa814140048265fadcc7e59a895d3b9c936f96ecca984a9252ca51d5a983866a5bd5e31d41e582b015a5ca58693e2e7c3c62a5ce32e7170c90484a82815283ee36fe70daf5158600015d41c1f13f77ca3c7a8ddf264f6cee444cef25494a969ae920153ff2bb7941749d24a94492c12413e4078c2af4a428029097d2024b1a8bc545618249077d44775dac3f58e6b58cfae0ca4aca41503436d25ed7afa688262ac6ca661a994fe1e17358a92bd6c080c52e5c00edf9c30d00029477492ec0249f9f9ed10417027dda4a12024dd9dcd37f55828529dc1d008674a5dedd631812e8150c4820105e916a524e9042884ba803f661d01f16ff00b6613260e0cf67a4924996bfeff4e23aa82b2700fd0c7c142814970e42aa0b13e8c7de87ed99cf03873d9d9862a482bc071f62346f45e461ff00f49be71f05ca2ca2fd6e4b01e5eba44d37e8b263b3b6e63294f4b568972f0b46720d8bdc1de0ac312a0c55abc042924258b872f50ef19b6ef644080121f6140e1cdad0a093b5b7abc106ba68411bd425e00152010e0d2919b047dda96aed71f486d3e6d60d56840599c38351d21c6a7ab06b1d930564c0e9512e7a0f268ba5a8eb003917f08a4774971a833b86a7f482957c246aa9ea098eaa55395f3264a66edcb3335e1d60cb5171404120ed478fa3ff006187b6678bfd9edcd55f02731a6e6dc57d95b99d9ac897ccde0d92a563313c2d88eec91c4992c82698a932d84f9286fde654b482eb420c7cce4a9a42ddc804f9318de193e7533033a5ad130a548585a540b1041715f95fc23f59ec2f6ba970f9cf867178f7bc3ab251ad49b76946e9a69af5670769426b31924d1d942b47d4a998b3db9326e23e0ae60705f09f32f965c5394f1c72eb9819148e25e0be2fc871831b9567b81c54b13254d95313d52aa82ca052410140818eb5abbc144208a0a6923a7f28f3f0f6067b7031bd9438b727ecd1da2b33c7673d95b8e7391213994c98ac5e379239962d612338c1cb2e55972e629271b879754052a7a124a56957a16627099666597e5d9e70fe6597e759067381979be459e6598946372dcdb093902649c4499c9252b42d0a4a8281b111d1db5ec67f27ead1d5e82abafc37509cb4f5edeba566e9ced88d7a774aa43add548de1344d5a4e0d3598bd9ff1d4d00af530a0558aac45cb1d9e191309345b690c9625e66e6bf9c53352aa3a5cbb104b341469a28802a2df11f0f38fccea52945fa48c1c6db198544a4209212a0ea2016eb5f0864928214c5831ad5fa022d18a5418dc10a7f89c412b24b3b80970902a91e3e71834d3b32bb65ec66fbc2a60477522c43d2bfce1c200248514ea4ead492588f5bc5082da402f4a8530178b414970428915d0180adfc3e5e11451b2b0c6e3952941143a413de008d64b6ff4b4305a90692e8ec1403a87a6fc610800a74b80ce12a2ece7d7d62b330add8e8482c0a8bbf8c57955cadedb74338cc05d2086d3453900bddbc22d966c41ee815d448fac604b5005d6a4aabdd74b0552ed16a96c920d1f7fb22bfd2262bc0856c22c98aa824b151a048f88b9fd1be508b577549a6a01c072eaf231589856e0d15a43034d6dd7ee80a5b12b00310da9be1a7afeb164f04be8d875a81bba5d8a6b42f16ca5289ad52efa89b78463b255f11774b1d1e2cd16f7921252da74b163531bd29b4f05a32c5999c99eb9492c0937720d0797e51d62ed7dd943923db9b90fc69d9d3b4670b4be2ae5e717c8f7f84c648693c4fc019aca0a380cfb23c636bc3e330ab2140a7bb350664a9895cb98b42bb1bef94b4b0d4142a092c5bca282a014521c855daad58f6b47a974e49bd8d17833c873da91ecc7e757b333b4263b94fcc6c34dcef83788a5cfe20e4f734705835c9e1fe6764a89a11fbc4857c28c561f5ca978ac2b954a5ad248d2b4295f9a7875ccc2ad3311dd5a0b949f83e91ecebdb1fb0ff21fda05d9eb8afb397680c8b0f986499a05669c0fc61270b2d7c51cabcf132d68c2e73944f3de96a4ea299b2d242674b5290b0418f28ff68c7b3db9dfeceaed17c5bc84e736453a54dcb672b32e08e36c26197fdd4e66e493167f72ce72ac411a572e62404cc960eb91351325ac25498bcf8552addeea343b452728782f8d15f16fbfc56d2d9c5bcad6958fa86f6047b7170dc6b80e02ec11db378f2561f88f092a47067663e7af1a668250c6cb712b2ee09e24cca6aaa0129c3e5b8d9ea74032f0eb5e912dbeb726e658ec1e3f1181c4ca9b85c56067ab0d8bc26212513b0d325929521693b834f9f48f19154f9987524a1652a4282f520e95a4820820f50c0f5063ee9fd84fedb2c0f680c1f0a762aed81c6d272ce78657964ac8bb3ef39f8ab1deef01cdc9586409787e12cff1cb2d2f3612869c0e367908c57baf7131626995ef31d06b34befa7a3ade8a7b37b26232f82cfb08c93314cc12d4eb2ffc474d7d35bc6396b2340c5946b36ef58d87e51d74e1efdef0eb527132a7485c952a54fc3cd9665cd94b1429524d4104546d1cc196675fba61547de04a849514ac16a9059a3daee650ab6a7b9aa7669a3cfeff006b5f8fe5679ed15e10e0d913e64d91c07d9af87b2f9987249461a7e6189c6e60b6f129549fa47c94e30a8cd5171de7a92d1f407fb4bfc749e28f6c0f69fc048c57ef186e0fc270bf04c801408c32f2fe1dc009f247469d366d3ac7cfc4f2544920175350024478fc5354abe834f460dfa114b3d1add14525cab3fc5cc77ad88207c42ade705faa89e814287a41212c581a1b6e60774966538eb563e11f2d2819358c0ac4104386676b9884162536268f631630294124b8bb1a16eb0482ee764d36a18c7bb6d36859ee52da8506e0dc823ce2682031ef6cd5bb43e9034d0873de0403f5fa446dd886a31218888eee5d08b08124258b0bb90f5f9c332e8544e93f2dfac12ee090455c33412ea290da6ae07d7783a6de4009268a7059c0eb4b42b12194433b8adab0e03850672d414a180963a812ca2aa5007b5e2395a00a9ee922e0122afd209717705acec4d3ac3692abd026ec2a7c60e8ab9248150aeb4f5f489eedb023005458bb54971bdc437c44024df487140d786524500d46bf137e3d210a59eaee40347b08af2cba80115da940ef4f5f942aaa4a4dec9bd7c618871de02a6a48b968973405c50d8b8f0f5b4395df001522ef5a83634da0b1344876abb1af9c2b1043fc2f7b9874d2951422edf48950760284a8a8826a0f769f15441ab16eac412e987094922a051ec0b7af082c0b1352cc0d3ef872b05202a8689229a858783c39d296f80bf8973e7fac108eebec6e280fd20691e6f41a7689717b811c8773de7605bbb00875074905fe276ac580383f68114a33340d20124134a870f689e5eb6010cf4550594f482da8d482d5666491e500017d2de048af9c46054c52a041f00fe115e5d92029721c1d8b549f3788ca2c28c1c5a86db4581235a80b02e002e0fdf7804035a33b116112e2f760500922a4a9340d630a4151ea08add8f845d670c2ce1a8e1e12b420814243313603d341c716e84d9958402c08500f47ac3300d4a0bb3b93059a9bb54bd3681a55d1850bbbb1b345395a20370f44d48ef39db788aa02f524d4b129db7801249494a497f8b5105e91353775eaf4f0fca22c93b3d805415a5c06d541ddd83c5674ad20d8b6ef16518022c6b6f5fd614a2ed735d2e0a5a2b97b01817a39516a0b6fbc07234ee5ead717fbff0048094e9243331a115f382c4b1ab7980f175b26c10921831725c1ac10588f84124f78a8b5e114c15b8a503d4446a9048001a1bc572981dca98906ecd7b3c4e94abbd1de9e1080929fe1a3020d29ebee876749abb0620100aa18046550949bd0a8def6861a481a9215be92ec2b08e280a880058d8fafca1bba077850a6a59c0f5f9c32c05d8100d146c455fa42d0d1dac5f5690079c40180eeb8dcbb0fa5e0d08602aee77bdc4595ee027ba9716d2c08ad0fa7874ba53472dd2e3afaf1844e84b9150f503ef3d21c31f85852d78bab8183900ddcd29f9c5dde373ab4960ce41ad9a294920a549003ee1bd7f48b5d45441b8a8dc562f1dc94af82d0b292426a154ebb33f9c5c95331d4127e1d3524db6fac6282483bab5176dcda2d43e9767d5401af6fe51ba57c1bec72cf266668e6bf2e56a24e9e35cbc54304ff009e96a451ceb2667367998b20a75f1be60a06a1ff00cf5343f25c05f36396a95d4ff7cf000921c169e0c57cec1a79b3ccb4bb81c6d9811501bfce51fbe3d58dbee55dfe33f6507eafca70ece041d40d524b8b98c4237635b6ef19935c8259abf38c4502d5eaf5da3e7eb7ac632f5848912dfc8c48c4a93cab1007fab44fba0805c50def05b832e5f7424072e2b5b7ca3b11d981215cf9e56330ff008d52d40d830918827f08ebc208b7c9f631d88ecba5b9f7cad24777fbd0926f5ff67c4523d9e0eedc474ff9f0fd246d41fdf22bcd7d6687cd9501ccae649e9c7b9b2439a1ff006d9f1c53346a2a2d526ac5e9e9a39479b4af79ccbe62a86fc779b28003ae3671afada38ba692416a281ab86263bb8a5dea66eff09fd6cbbdcc25dcb7c3e2183c5643bb13d7ba1faf8458b512aa3817019c8eb15935d6486b503005bee8f1a5b19cae293574d523eca8b18504bb80520fc44062f04924d00200b0fb9e013ab4dc56e2f1849f532c741491de664907e21522168439d8dc7c51616ef3a4245ddc9d5e108a0e2acdb97b466ef756005005c54b07ad0c22555a3742f6aef0c5ddd8b91a5c1fa406252006008721cc1b6071a46903ecdf56e4f582188a04de8373152145c8677a1dc8a43b022ac49a824c2ef7602a20b80a3d4ec20dd29d8821d8de9485772ecc5e877f9412198b0722b5a11e111e2d805092cc4d4b130028f983726f0c416d297bd01e8f10dd258ba6a29e7137e6b20467b073601bf188a03bcec2af4a977b403556aa83720381686d21838fb4c3a134884ba21bec21d218917161586d4c40059c38d4682910120b14eee49ef130a43a42d24800d1dcc12bbb306425a8695241028fb44002480006177a400a510e4387bd88f5d6181a062ee6adb50bc74c2f6b92b19186a04a41a9a9a3b46b380075a48208b1ebe5fce346407ba99cd284d378d73009095821c07bfce3d3d0e6b44de3be4fdb9f6164a0af69ef61e49208ff001fb2e5599b4e033353fdd1eaadc49883333acd561442538f981c51d94df918f2b1f61121537da95d86e5a40215cf7c29f92728ce144fdd1ea759f2cff6a662ca2903319c4921c2bbe69fd23f5aed64a32e07c1d2dd52a9f4d6fdc765577517ed2b4cd3dd5314ba98948730d2f129d73a809d00274f53d3d56308ce2c960a045039205296e918b2ccc2b52d24a56a981566486a777d55e3f2eaf98b4ce4f2351c48056285330b2fc482ce0fada114bd2924589625d9c35488798b514a010ec972a22ae0dbe978a54b2588042800c4505ea7f28f26af53295ad82ff78a60c525c3926c7ca1a6a52ad2b0eaee8201340ff87ca3196a48d2856a075304209ef9b801ac22f4abba9481a41753bea7f011cfe453d85b2884a4241095331055f10a5a2d0a24156a34555a843ff48a90c12a132c588dc83fa562c50d214a27ba483abf0a7e71162064105886041fb4a659a6e22f4a93a9ea4bf72a001e71a789a592491a9c8524021dc43a14001a8b9074fc4e47f2887b03e253f6cdf16afed1f672e10b7fde3f313146bba71fc34814f998f8565d95b950a06768fb8efdb359e93c63ece7907513fe15f30e701520be6fc349fad23e1ce624ea2ee0834af78ff3b4694f14ec5a2ad0661a87774902957de2951340585684522f99dda90439a06262b201490cc1fe7e3194f2f3b1510115704b8bb5041228092c41602ef0a1eced6150de8c3b779219c8aee1ab19f90119bc0fdff23005b771563682a22a41531176680a248f1baa8d1186c1638ee8b55a9b442e0b54b6f00101c51db615305ce9041a300c22d161841214450b97007e51952668428024b0b0f9c610243a813a88db7864294141be82ff0048eca1565097a2c94da774727f0a6773b2dc5c9c5499a652a52c292753336d1f6c7ec02f6e6c9e574dc87b19f6b8e21fdef91f9f4d9797729f99399e2d4bcc793d994d584cbcbb193144eac9f12a50d2b25f0935af296747c31c8c51961352c68e28478c722f08714e332bc7c89b267a90a42c69ab8d9c111fbe7603b69c31f0d9f62fb554fbde17a96b992b29d29af52b5193bf25585db4f692bc26a5094a2fd1d36a61c9dc565783f9d79af33db5330cb4a0a26c95cac460b152538bc06370b304fc36324cc4854b992d63baa4a9241043862234520a0b291a484ee583c7c9cfecf4fb6af05c4390f0c761bed6dc6b2e7e11336564bd9fb9a1c498a031b92198422470ce6b8c59ff00324eb3a7073e697485890a51025c7d7af11e453b2dc44e91352cb4174103bb353b11e1f84783dbbec3ebfb23c6168754d54a3523de69ebc1354f5145bc4e3e128fab569b6dd39dd5dc7964da8a13a4d73653ca7e2bf7755d0d9aee5fbaeaa3dc787af08b0a58382fddd2b73784d2a495776f77ef37af1843319213a89528b5ba7e778fce2b5174e56b1c925e25c268042748092e09059ba078c8d40253748034ba8bbf8c69aa9a2c4a54a2e5203972f6fc6089a6854ca43770077aede7b471b566ec679c2337de1537782523ba092eb3fcbc2192415867290592a2004a8d69e4f18849075a52c96d2c4b906efe6d1929983402ad43bda9c02588dcfd628d5c84ef86659290035824109258bb5bf9c57ac820ac8d4a07497fa88a53303d4105983874f4b7abc2999a92a57c44774d2aa3461e1fd62b6b21e459ef4956af84369241ef5f7f0fd608554855404b1ad486dbce31d256480cc35076dee5e2cd4501442000432a8c4002ad05895913649e4c905490c90348a0af78f53102c9003e90d66bbbda31d2b495391e4a26be1f4a341d4e1b539673d01ab7ce2e9d990bcc65150259813405ed4de1d294f74901c3ea635358ad04a8151624aaaea228c3e4d58b68a51578801e829fd23ae8d4b1ac5dd5cd470eb32c8524b2455c53e91d1cf691fb3fb90bed2eeced9af2379c9849393f1360244fcc3943cd9c1e0918ae24e56672a4112b1328d153707354109c4e14a826621d99412a1dd813585983304a4d4c12813501e818de3d9d157eeeb42b465671786bf5f8a6b0d3c3574ee89b27b9e347db87b0f73ebb0573eb8b3909cfde149b90f14e418954eca337c20562785b8e32d5ad430b9ce4d8c20267e171096524d1482a285a52b4948ea4e5989c6e558fc166180c44fc263305894633078bc2cd561f11859b2d4172e64b5a594952540282817040631ebdbed43f660f28bda85d9cb1fca8e3019770b738784a5cece7915ce39980fde71fc19991493fb8639407bc9b95e3084cbc4490e50e26206a431f2b6ed59d9479cfd8eb9cfc6dc86e7af0763f837983c0f99ab0599607108333058f94a24e1b1f809eda67e13108026499e8eead2762081d7538069f5f19ebf416f4732a69e62afeb46f974dbdb2dc5fa32e8e58f2e5dcfb8bf60f7b6cb29ed6dc25927643ed55c4187cbfb52f09e5a8cbb94fcc9ccb128c3e0bb42e538794944bcb3305a8b2388308943216fa71d25ad350ad7f472788113737cb72c2b52138bce30d96cc45948337132e52811b1ef546c691e36b90f13677c219d657c41c399ae639267992e3e566994e7194e32665f99e578990b4cc9389c3cf410b97325ad21495248208063d07bd88bed89c93b78e23973c8ded019c6539176b8e0ec66009cf264c465b967690cb32b992e74ccd24caa265e7b264487c5e1e5b271699667cb48599898ebe13acd2c352f4da8972b69f2b7b5d278fe3eabdb4a728f372c8f8f1f6c7719af981ed43ededc58b54c50c676a7e2cc06184caa912301984cc061d3f2461d21a3f32669090e183dab58e7ded3dc6589e617688e7d71d63718ac66278c79d5c53c4f3316b56a54ffdef3bc74e4a89f2508ebecd5150b16163672378f93af174a338beb26d7b1bc19b78b148352c55f2117265900026aa720f56854a0a803514a8d846b385c1ae7490b00ea05896761b465a6d156d54b920aecb41733b58d3528a177616003980a4287c40926c45a370272f594b8490c5cd0d62a560541cb3d281a91df2e0b5e315e8e4d7ba76bb34312c120961a776af841520d8d4b3f76ad48d5d7865218a90c4ec05a1061ca48a114b9abc7154e1f5612e5712aa1e069865d894921afb8b4408a874dc329adbb78c6b69c3a545920926ee1fcfd78c6723299a50b9e2592849d290c4ea3560de178da8f09afa8972d28dcb72336afb8342c749734fb5e70a65281008b07a46be70a50a32d6829043b906903f732d40a00972c5e31970daab096515e46b73454cb0c6acf5200a13580535729a6ed50180de3505cad24a6a01a85310e3d0828905668929a3549ad3f18e6f7ad4e6e5b1165d11a71416604a8aab4ac132a9b5a849631a98c1ad2582084ddd896da1c60d6a2e416028c0e9222568eb3e84d8d10a4a400bbbd7c3cbef8501d4400e1e81e87c23529d87a11506c433934ebf7c568c3ac1600a58500a93ebf38ca5a69a95ac539726169a824167b10cd0ec18b966f0b799fca330c9d29626a13505c0545f270936669d28201b96bda14f4d524d4522d186558d304ba16ad5cc1091734e94afce35a5e026ca0ea41d46ce1c37afc22946156bab78bb7c3e11b4b455232b35925c5334ad3a9d3a5dc55c305456a9649eeb1dab68d51720a592c7535c5837584f76edd400cc1ebe3e3193d3c94acf72bca93ba34f282804d1f72f7b44d2a6627bc0f85446aa30654280b02e0b5614e0e607252581dc6d175a3adf1428bb6c6993051cd89b8b0b41620066555989ef1f078d4d78760014b9018829b7f3889c2a48f85daae287e512f4737d072f89a7141ef12012e0a4b50d378608551983f42f19ab9241530219bba28cfb432241d2c4509bb779fa464b4f36ecd649516dac183eec3801dfc9dabbc2992028306d83ded578d6460e603dd4b835b45ffb92c04ba09a929a1219a3a570fab25b17e46f736e845689a83b7e3680a4e9ee10039abd5b778d666e196925814b1ab88c45c92492524016f3f28cea68e71e851c15ac69c535097b6c6822697627e1d9fd52328ca5380583077341fd3c21172c94a8072a05dc3f58e49d169dda2ae2db31528214a290e09b91e706ff002a13626916b2880ee96666f9c294801b4a9af7a8f18ca54dae855c5a1480909629206cf0a08b51b53f43bfa687092c5c5367a55e90a46917bdef43fac676b6c5442cd400b583b40012e050d5c906b0c49537851fe1853a81721c8a16de3349b0060cd52e3e27872c18065519ddba402e9d20060aa56a55f38350282d52f108115577a31776af94005c2a890f502cdeba412e9b8bd43825e09777f9bb6983770471aaaccd52eff331090cc05ced72223392d5d43c875fd200d4480d56abd3c2255fa01ec0331ab0492c4c14836a1a51ea3c8f485a025bc1dc51bc22e04b14dc28bd37f2312b6bb22c00525e8694afaf18b5440f849045351a6a1d22b74ba4b5038507707a561b5121882ef73402b68d62f2892c48624382487240f0f548b925ca592c40b8e8e368a12e0383a549b93725a3225953e97674d74ef50f1baf13a11cb3c961ab9b5cb70189fef960425a8434e4d4f9fe518dcee013cd7e65209aff007d31e5dea7fcc3fac5dc98511cd9e5c114238cb036a0ff007c3f9c53ced513cdae65a8005f8d31e2be134b47a89b5c2bfe3fd9443db270e4c1dc360d525e86315449670db120465ccab302e5468479463289635b5a8418f0ab6e653f59957aa4486215b8b7df1239db5e2545f3a4104d00f31d605ff9c16bda9bed120c84390cc926f4a0b47637b2ca4ab9fbcaa4164a4f14a43abff37c4475ca5900e92cccee3bd1d88ecc2a57f8f7cad36ff8ce802bd646200ac7b5c19ffb7e9ff3e1fa48de83fbe47dabeb340e6a129e66732d3dd4a471e66c0029156c6cf6731c5b34ead5a856c76611c9dcd4595732398a5ea38ef352a6dffdb674717cf3ba491aacf57b563af895fdf353f39fd6cb33156b0350492ed4ab36de8c54e00621814ea622f0e4904835559c0dbf4855692aa96481420968f265b194b7b21001a5ac40771e3e84296496a3d8936ac43a41ee9704d09ee903ca054920b00cc0bd0f58e69368cc2966725241a505491e10cf40124ea1de04976850e14e929049724d0d220d345b105ebd3c9a2b77fc7c8005c82e95153eccc61594e93a934abf487716a13a7625da2b2c35501045284bc53a01be11dd01f55c0a59e0000b9a50d0fca2053bea2a005478ecd115f092c685dbf9c00c492a35481d08a789785d29a39ee91451a0f4f040d401531dc57cef04a86a018b500dc9f941dfa802890db922edb52189abb866b1fb37bfada013de6ddbe2341783404d5d23e649aed129a5b0f60037c4a2544860ab814b44340e483dea077de86211a8821acf5ab5225df67a12f7b75895678603d410c19dc0fc62104b001dc3b0160459a08370428809058edf2e907502134606fdeef4146fbb058e0743a6e2e3c842d52c5347ad085063ebef88a20bba8ea25816eeb79dde01042a84583925813e11d10e97dc959c32f96a1a83a4240a69378d6f00a75a5240ef29d8d410f1a102ad4c523a804d8f9fe71ad6014cb487672e4b53e51ea70f7f7e46f0dd1fbadec0bc3999ed58ec3090356ae76eb1e3a387b3e5ff00efa63d46739c409b98e62b4b8427319ee007349844797afecfda4cef6b2f612920d3fc62c4acd2fa785788d4ff0077df1e9ef8f9ab388cc1c31fed1c402f407fcd5dfd6f1fa7f6aaac23c3b8652f0a0fe9ab33a2a3c2b104c70ad4e12a0e9d2afa57a4664aa240000d08724fdb8dba89a661284b8b3806a2bb7afa46b2152ca86ad434cb1a5bbc5c0ad23f34d44d5b07349e15ccc9aa4696212949480165dc6e6af7808248357d20694b80febf28c2591dc2a750d3dd63ab76f5d1a2f4ea4fc41d2b609a5123a7ca3cba8ee9b467277c998a025a92e12ea1a8294c5a2d4a800b7034eaf89556f5b455f129c28000867a8005e13510cb484806c9528f8dc7abc63d0a19a9524a54805055421be1b0a79c63959048f8416606a91e3e30c3be0b8484a83165127c69f9c5625ac6c149269a0974d6dead104df1918951524125440727e5eab053300592ee6eec1bd7ada1e64b1f1328808b806948d1f12a992d61410a147052286a2f136be08dd1f0f7fb6593d73398decef94ef2a5f26b8f26a68e415f10646951ff00ea698f88d98a1a892add851c1f5f9c7db17ed8d6225cce67fb3e2593de472378da6b74d7c4b96a5fe7eecfd23e27278255a9c007a6d1ac1254db7d4bab7258c75900806840a97a79423d433392eca17101eb4a84ddfe5688ea25362a2417150de8461259b94152c4b820b39621bd79c1502e145ea6bf2305cba81d3f0b86b412092ce90e2a4170ff0038cecde1810904022a06dd203393d4d8fe71704288f84dda819e1ca08212cd4a016237838bb5fa0282823ceeecee2007362db7fa4f845feecaad7e9d621c3ce20912d4b09a9290edbd7d6d165069733063104d1aade50e90a058a482050d888de5c23c07c5dc779848caf8378733de28ce313313230f94f0f65188cef309ab5d1294c992852c9276023bcdc2deca3edffc5d95ab36c0f656e6ce5f804ad2818ce2aca25703c99854350523fb426c8514b0f88258758da8d29d4b7749c9f82cb2526de0fced721c02cc1e978cfc0621529692e192a73d63f45a4fb26bb6c09a9959972c328c81457a07f6df31f2592a06df0ca9f30fdd1d1ee65f2e388b945c79c5bcbae2d460a4f137066793f87b3b9796e3939965f2f15875699a89588480260069a8062d1ede9e86bf4928eaabd294237c369abbdf1734b4a169356378709f1de3f219f227e0f113242d0a1544c32c962f705efb8b3382e1e3d09fd813edbac2f68ac87847b16f6b4e370be6a607088c97921cd8e2acc13eff008d91265b48e1ecdb193080acc132d211879d30be25280824cd03579bb61f153353050201a24d1a39bf967c7999f0ae6b80ccb2ec7623098bc0e2e5e2b0f3f0b3d5869f879b2969992a6cb98921485a1494a92b490a4948208223f7fec476cb86f69743fc85edb4dbe1d36dd2a8acea696b3568d6a77dd6caa536d46ac2f16d3e5947d2d36aa3387bdebe60faf83f15facf6bfce787b15820b973651973105cd28a15620f48e3e9c16856921883a5d3423f9c7e14fb0abdb4bc33db3380323ecadda438af0d97f690e16cb1184e5e718e75894ca4f3970122581fbb2e72881fdab874a46b966b89963de21d495a63e80335cb4e1e7cd9735065ce9458a0d0831f01db4ec5719ec771badc0f8dc5778929d3a90cd2af4a5ea56a52f850975eb092942694a324b2d4e9ea50a8e1517b1ad9af15fc60daba8f74288516203b020bee61983a4a8f79cbe9342fb79c4988f7640aa424b8277dc13d62a4ac385292e757d9ee94d23f3ca94dc26e2d1c53bab5ccb4a92904ad61d23480050bd6807ca2b226070959291de4a925f48a9627eb14a96fa98d524900d07988a44c529691a599245fbab7adbe404734a2d19e2c66fbe41008529f4b300085d361f943a092b61451a0d4c52db815a9f08c042482002906ae55676b03f9c5b2d44208528a43fd9a927f9fd62965d0b59d8d5090fa1290080ee90cf730809512ea23525d2a29bd23190bee294a2925d88a96a934ea3d75828524a405121cd40a9b3fe910959e48df2cb95a48241000a1277afa68ba504d01248097d26a7e67d58f48a404862ca555d21ea2b73e5bc3ba18b02fba812fbedb0113764c93321612d67172a26898895690c52951f889bb797e918e66800a55f12900fc5e02fe304ac11a5d86a04355eaf174d221dd6c64a56589bf500b0fafab18c896a2e90080198316f9c62053fc54208602bd6ff7d62e0b08ef3804960c5c88eca5556326a9dd64d47073552d414083a6841a8676fe47e71f945ed7bf651f28bda95c94fecfc4a72de07ed33cbeca678e4af36ce1d32d13ca8199fddccfd406a9d96e256192a24ab0d3142620fc6957ea8a670268e03d74d4bef13de0295a58ad27b8e4301fca3dbe1faca9a6d543534a56946ff33c34d6ce2d61a7ba0d27b9e2b9da17b3ff0034bb36f3678e7933cdfe10cd381f987cbecf67641c51c399bc832a7e0a7ca510172d6cd3644d4e9992a721d1325ad2a4920c71ef00719f17f2db8cf8678ef81789b39e0fe30e10ce6471170c714f0f639796e759063b08b13b0d89c2cf410a42d0b48208f22e1c47a957b66fd8d5c11ed3ae576238d38170193f0af6c3e5c641311cbbe335a5382c2733f05202a60e17cfe601de0aef7ee98c53aa44c5692f2d4a03cc379b9c9fe3ae4bf1e715f2db989c2d9c706f1b705e773f87b8a38673ec1af019be478cc3a8a66c99f2941c10c0821d2a490a4920831ed54e014b5909714e1cd3a7169ca37f4a9b795e6e2ede84fadaced24ca72d9d99c519b6678fcf730c7e6b9a62578bccf34c6ceccb32c5cd6133153f113153a74d533556b5ad459aaa8d2d320ad4526ac581d898cb5a089896604299def1fad7d80fd8f3da6bda45c13c55c63d9b38c7b396226f02e6a9cb38d38478ff009baae09e38e1a4ce6fdd31b88cb95819af84c492a4cac44a5a92572d695695000fce3a14ea54e5acd2b608493ba3f25e4e103a4153125ecfebca3f5c3d935ecc0e6d7b4d3b4361b949c053d7c2fc0791e5aacff9b3cd4c7e52acc721e00cb43a653a014a6762f15334cac3e1828296752a894931fae3c98fd91beda19df1864a9e7c73e3b34f2c797c71485f12e65c09c5399f34f8d65e1c281988cbf01fb8e1a42e7a920a5066cd12c120a8b068fb74ec23d907b3bfb3d792b967213b3770b6272be1e4624667c59c63c40b46338eb98f991484ccccf37c5240056406448434a92864203393ee709d63e16a75341494aaa5894b314df569e1dba2eaf7c1bd3938b4a08f94bcd7f63b7981879eb9586eda5cb409f785329388e5666e9514b9d2fa6710eccede31d1bf68afece071b7b3d3b2971076a1cf39efc3dcdfcbb8638bf28c873de1be11e06c66473f2fc1e6b395861982f11885a804ca9beec293a58899706fe8f633b918b99296ad2a52aa0ec3d78c75c3b77f25b01da93b16f697ecff003f0b231988e61f2733ac0e472a7534e6786c22b1996ac1ea9c461e510447b3a2ed6f10d2710d3ea3590a53a5cf1ef13a54ece2da52da3e06ce6e11e65bf53c67b3d46492e7a9187918f3a54427deae5a400edb46d89b364004224ac96fb4b0768dd5c4796e2f0999e2f018a40918cc162266131b24965499d296a97365906a0a5695a4bff0c6d5090998107492ed55061fca2bc73551adaf9ce8c211836ed684562fec22a548c9f347666e4e5cf04718734f8f784396dc03c358ee25e33e38e24c1f0a70b6459724cec6e698fc74e461f0d250901fbca5873609049a0263eeaf80bf63cf2dc770770a2b8d7b6362f21e329bc3b84c4f176459672b24e6f9765199cd9295e3b0d86c57ef69f7d2a5cd2b96998520a82016ac55fb2d7ec88c1e4b91caf69873f7874cde23cd3dfe4dd94385335c2349c9f0a419598f1a4f96a159d34eac2e03f81031136ea9447dab61c4ec3cd5154c51528b93abbc4f58f9ca3c6388f0bad521a2ae94ef66f9212f0c7a516bdb65be3a3318cea3bb8cac7c61e3ff006387826595abfe1abc49889c24ad726448e4ce150a9eb0852912c2958c67510120ff00a847c21f1a65b3f8338b389b83f35cab1181ce385b88b1dc379b60f187dce270789c062e6e127ca5a40eead2b92a0475063dc972d9cfeeb1130a94644c4ce43dfba417fa4790d7b76fb3e48ece9ed4fed8bc1f81c2ccc2e4f9ff003467f3332044e48966661789e54ace4ad23f84cfc562402364c7347b47c46b55942aca2dbcdfbba69f83da2bc898549c656befe27e434e9c5654512525d4084953e98c8c1cc47bc4a5600d402748ef1a801801526d130c80b052a21fa9500e7f58fa7dfd9a1f65223b64f6969fda9f9bdc329ccbb39f65dceb0b9a617039ae104ec97991c688d18acaf2b2950d33b0f810118dc4a2a92461d0a0cb20f0d6ab531a84d65dba63e8fe190e52493b9de8ec87fb23dc43ce8ecdfca5e6af3dbb43e7dc8de68731f8564719e71ca9472da471062b82b0b8f6c465b84c6ce5e225ad18cfdd972578892b4832a64d32cf790a11d819dfb1a5c0d28849edc3c56413528e4be119abb9c647db249c44e54c562710a2674d2eb72e056c7c21f138f5a4a98821a9b8de9183e23ae93b732f672c7ebe5b91e9379678b876f0ecc12bb19f6b8ed0bd97b1798e6bc453b91fcccc7703e1b89b31c0a32699c4b8591eee6e0f32fdd4157ba4e2644d93392015069818911d3a5193a82932c83b1f78e63ea87f6b77902ae5dfb49384f9dd9661b10328ed43c81c9389b35c5aa409581fedfe189988e15c74894a142a182cbf239eb7abe2df711f2e92f2c205403467d578ecf7cd5d6c23e8462d2cda297ea261273567ec340512b5a50897a96af803d498fad0f64b7ecd7677dbc3b27e55da8b9cdce8cef90796f30388f152794dc3780e08c3f13e3789722c18972179e62bdecd96a952f1389fde65e1d297d72f0def1d9623f23fd915ecdae32f695f6d0e5e723f29c1e330dcb5c97108e3be7b71a49944e1383385705392716a332dfbce397a3038596eea9b892b6d12a611eb8dc35c01c27cb5e0de13e5df0264b83e1be0ae05e1dc1f08f09641974a123099465f80909c3e1a4cb48a51280e772493531ccabd6d16aef4e5697b13b7c8eebe8f11cd2e6e58b3e33b19fb1d5cb39b8812e5f6dee3329516213c99c129297ea7f7c023e7c3db39ec95c87d93fcc8e4f70165dccce20e6f659cd5e03c6f17c9e25cd78770dc2b2f0b37058ffdce6e16549973266ad2149592a2fdeb47aae6192990b4905d9893d7a88f900fdb04e4c2f8abb2d7667ed1196e4e67e2b953ce4c672d389b364cc24e0f2de27cbd5370285a6da4e330058ff128758eea1c63514f591ad55466b29de10eab0f11414a509299e7ab8c187d4b38796a773552828b78811a58d297ee777a9537ca3710c0ac8528a5cb171fa46a1c31c0fc4dc77c55c3dc15c1d91667c4bc4fc579ce1f87787787b28c3ab179a6778ec64d4c8c2e170f2c554b993168481e2e680c46a554cea64978d924be6b245e7e27e96fb23bd98bcc4f6a3f6901ca6e1fcd27f01f2d7843239bc5bcdfe6aaf29fed6c370665e9065e124489054944ec66367e893264150a7bc59eea0c7d4e7ff09abcbe9d282e576dfe252487af2670a69e2d8cbc7ee57b1e3d9a5937b333b1f707f29f1f87cbb15cf2e39c3e1b8f3b43f14610257fbde7d3e4052326c3ce1556132a42ff007541b2d689ab6ef47eb961b1732481df2c3627f0f5bc72c2beb3ba53a756cfc125fad15f4dc6e99e75ded36fd9a1e1bec0fd8ef9b1da8724ed39c47cd2c5f2cffb3264ee119dcafc3f0ee1b112b1f984ac12e74dc50c52d4844af7a144849a911f2446625ca0484a482d4984b47b35fb47b9229ed2bd83bb59f27646569cef35e34e447104ac932d2bf74bc4e6383c1ab30cbf4ab657bfc24a68f1a2c6e5b8ec36266267e166c89a9504cd4141ee28516834b85050f3119d2ada8ef1ddfa36cdd2dfe6f6958dd4da6f069ca4a564b4b01aa4bbb53711aa6579763334ccb0395e5596e3734cd733c4cbcbf2ecbb012158bc763e74e5a65ca9326524152d6b5a9294a521c92043e1709366acb49980d824a4b2bce3ed67f6643d8d5278ef30c2fb483b4a70c24f07f08e61eebb2d702675830a471766b249189e2fc64958ae1304a024e092411367fbd9a593251afd070a71a3ef8725d3c3f8bfff003b2668da8a56386b965fb22ddae78eb92dcb4e3ecc39ebc9be01e65717f09c9e23e28e50f19e5999a317c173b140ce91974ecd30e172973d12552bdf809d32e695a1ce973d7ee65fecae7b53f841589feecf0172739a386c2a16b913b81f9cd9648c6e2c2524b0c26353217a95b26ce6f1e92b87c462a4a8aa6cc5198a56a2455dcbb46a3855cb998813b12b24a0bd6a4783f8c7b7a7e355f4f4fb9a9428548fe54669fc8e1521f4dcba94d3cd8f1e2ed3becc7edc1d9170b95e3bb45f665e66f29f2fcf7309d95e479c711e0f053b25cef11265aa74d9183c5c8c44c9739625a1733420ead0852806496e82e61934ec0cc549c4489b227a3ba64e2252a44d17fb2a00fcfc23d1dbf6bfb0231bd84fb2cf11e1d734a325ed6abca662d13140cafed0e0ae25d06869dec3247ce3ce7f138bcd752fde62e74f92e5a562cfef493536d4e47c8ef1ed4a1c1388f06a3ae5a7952af273e6517cd05cb3715895a4ae97c69131b4e0eeb37365ce90416615340d5a7f58c299295a8809d419c9dfc6373ce69a6b244a51155c9722dba4fe462b465ea980a98a812ee9b8f131f1ba8e18e751fbdf28a3a6dbc1b5d280e4002eda5218c56b90520e90413f0bd5a374cdcb549b0d2a22800aaaf6eb1873b0650c54821403697a8a6e23cca9c26bc70e257bb6b646db282824382c75126be845665b00c9a28d58b758d5a6e1c82a5049e81ebbef186b96da9892d52ee04797574f3a6ed2464e16dcc2092e4b1208340c2dfd60246aa3025ddc8a7845ca961817d3d102a6d088a30ef020d410e0c70ce295ac66e2d01cbb93a4eab91514da1482dd013dd621ced0e5810011a547bcc6ef08748550934a856dbde326926d3454052fa46a7ab9635100385004b01d7e70d42aa3380ecab5de077092ece2be1e510acd82292ea240de81a8a80a0a0b0426a49648f3dbf486a1a977760c685a08042b56ab54b55fc21f92b60027e17218554c3e1ad8c30ef24df4a6c0063eba4565c85312e4ef423ac324259eba8a40209a3edf8415ba82d9643381a491560efebf2835eaf4bbf8bc0964a412589ea0b57ca1fe41c9d9568d23948011404114662051bd758bd99418022ee0faac5043777e46b4e86b68b10090e4e963605c783c6e9dcd62ef9396b92fa95cd7e5c3b31e31c080c6a499c0560f3b500736b99696200e34c70634bcc8b39220279bdcb252ea0f1be5c9a0a179e91fa7d21b9e7ffad7f99ec0bff7eb301a760d388ac7aabfdd76fcbfd945dfabf29c33303034003dcd8c614c14d897f558cd9ae5c2ae4d00dba3c60aaa58d18b312c447835b73096f91355a9bb9a56242bdc75891cee29ee412bf27f9416a3fe505240bd474bc0f005e95116576ec0c994125240006e0ef1d85ecbc4279f7caad4ea038b24820d3fe8a77af9475ee5a5d86e2a3c691d80eccaa239f3cad50d20a78b6493d034b9d1ecf08fe7fa7fcf87e9237a1f858fb57d68d039a21f993cc75076fefd66a361ff0086cfa471a2d20ba5e83a6d6dfac724f33597cc5e612abaff00bf39a960295c6ce8e375a5c90d57620d7ca3b7892bea2a7e73fad96d8c05a18950241058017556b0aa04a6807913a9dab48be603dd7db6dcd6fe118e924b93f102e15b26febe51e3ca3e593292ea02c412c039674d211804de9abab1f18b0d19cb87ee8fb27f5e90aa0495255453d4836de39e5e0662e94920121bcf50f278563de72f40c05bd086482039603a2850c105aa1aa68e5c878aa69e18ea2965027ba76208ef7d6140aa88a2934036f378b02583a4067d24da0101c80e4024004308ab57cb028605dc00f57afd21480c5c9e97b43b0b04876a904d6f134589090e585e87ca1bbb20292e901343bbdc92f0016249a805aa6afbf97f38660e4b920970e284c21ef543027c7d7a11297801c38012077aee7bc0dbd560aa858d9aac5c93e5009290093a482e5b7855024ea04f78d1e84faac46ebcc11c59cd05417fa4329981208ad9e82bbfd213be092a20966ead4870cd520b37c5b7ca26fe20205146bfea0fe6608140f5ddd5b08ac16720b24d8354c59524300a0d52496104d5f210001467715a8778b19fbb766ab3283c0092d42aeafa8ea8648a333eaa6aebbb4744166e4adee387a3b5140388d67001d62e544b07d856f1a3a520166a5cfdd1ace5cfef017a3d0330bc7a7a1baa88e88fac8fdf1fd9ec9615ed70ec28953ffeb58cc163a77783b89d5f888f4dfcc66938dcc828ba0e6989018edef9403c7993fecf69d1ed6eec29a453fc51cd0026ff00f797c531e993356b562b1e560a9b30c42bba1c979aaa7df1fa0f6ce6a3a7e1897fe5ff00f76a1a57b7325e48b64322612c0a94901825c7f531946720cdd21496d2c54ceeaf03e846124ac909d4a495863a477827c2314ad499c406480c0254a74a40b171f7fdf1f9cd49397539ef766bfaf52252b532c2141490180ef0ab78c5e2780b9616e106aa72e017b797eb1863e0484f74d965dc82ce00f31586410740d2a5026e90e000ee4f8472bcee51a77b1ab898149d5a521292006ee93e67ac2ad5a94ddd052751480c43d5dfee8ac147780214a3de4a143ba96b37878c132f580540a020071b30ebf9466e2f620c99210a525a8083a9cebda8de1fac64a46822a342458ef185212ad4c942ba24ab6f2fada3514c99aa0a20289240601c9d830fca25536f72545b32e4a7de02951202aa49a18eabf6d4ed9bd9afb02f25f1fceaed2bc7b97f09e4811324f09f09e1264bc5f1f73231890e9c06479713ae72cd354d23dd4a0752d404741fdabbedacecf5ecbce1ac7f05ac60b9b9dac737c9063384792597e3d28c170827108270b99f17625049c2c8b2d1841fed13c0a25292563cd43b67f6dfed13dbab9c59ef3c7b48730b34e39e31cd4ab0b96e1662ce1386b837009513272ac932f49f7583c24a0cd2e5805646a5a96aac75c345274d56a988fd2ff712a2d9d99f6c27b55f987ed4ee7f643cc4ceb82f23e59f2cf9579263382392bc019528e619b64b93e2b169c5cf9f9be64aae2b1b8a9a84cd9852944a97444b4b073f90fef090351dab5ac67e254275b626eee3f9469c431bea09a1e82386b4396a3e5782ae2a2ec862c0bd81a902af13bc5988f007f384724d07803535f38ba5a0d587cb722d1926dbc100424951767a821af48ca4ca090282f76729b6d0f230ab249600253a94a5abdda40b549b7f38fd93ec15ec31f6857b4030f96713f2a39338ee0ce52e33132a54de747370cce03e035ca5a8054dc019c8188cc024176c24b583fc51a46318af4996496ecfc78918633190016340c3bb1cd1ca5ecf5ce1e7e71161b833929cb2e38e6b716624b4bc8780786f15c519922d59899085096ce2b30a4563d04bb1c7ec8f7646e524dc97893b5bf30b8afb4af13e16623198be05e1e9937979ca72b01fdd4ff76a38fc5a02a841992d2a02d531f515c91e40f24fb37f0760781790bca0e5bf26b8472fc2230387c9f971c2183e1613d12d012938ac4ca40c46216c03ccc44c5a9547348d14ed1b45164ec8f36becb7fb2b1ed04e6f7ee19ef3d330e00eca9c258f9027a91cc1c5ab8af8ee5a141253a721c02cad2a209a4e9c8660ecf4fa3beccffb305ecd8e436072fce39bd85e65f6bbe36c2a533b1079879f9e5ef2b5530cb29525190656513a6cad45d2311892681f77fa88ce72b91314b9c8960924294a62f537277f18d8989c081aa5848677006db4446312aac7e7f70a767de53f2172b4f0ff00227945cafe4a6478740972b01caee04c070bce50480126663c2178d9aa0001ad73c9a4701739b84959c61f153b32998ac6e257ab5cfc64e5e2e7953382eb24bd7caa23f50788b2344e49568d40a1d9a823acbc79c183192f100cad415a885a924b7afca3d8d16a3b9945c70bc8d22ed63f0178c382c6173cc2ca461908337319325444b00242f112d24fc812fd1cc7c2176abceffb77b46f3cf334cd4cf978de6c67b393352ad68583984f4823e40318f4b5e63f2c25233118d5c8427f744623319b30a190060f0b3f1855e43f770e378f2fde3fc61ccf8cf8bb359e5267665c4f9863a6a9034a54a9d8b9d30b0161dea47bbc7755efcd0508c1e549b7f325fac5493692366051042bc59c58c6b7976395865a4851041667b79c680492404301ab4eaf5e71cfbc33d9ef8cf8c3933c41ce1e1a44ecdb09c2b9f4ccb73cc8f078554ecc70f83958646227660803e395275a7de84825093afe1048f0b8655d62aed6820e528c5c9a5e11cb7f22c9485efe8a373f2a79c7c4bcb8e28c8789f86b3accb22ce721cd2466d9566d94e35782cc32cc4e1d62649c4489a96285cb524292a1623a3c7a6d7b163dafdc19ed1be59e53c9fe6ce7396e45daeb81b224cac499ab460b01ce8c0e19007f6ae0124b0c6252dfbde14542bfcc47714427ca9b038832d4813180715d4fe85beb1dc1ece1da078e3909cc2e10e65f2ef89f33e13e30e0cceb0f9ff0f67f94e28e1f1d9662b0eb0b953126c45d2a429d2b429495020911fd17d8fe3dc33b6dc19762bb6b5f929fada5d4bbb9692ab4967aca854b255a9f5494e369c22cf5b4f5d57a6b4da87e8f47d62fecf15facf63ecdf2b9d226ae5cd42a54e92a295a0a4a540b97047ca36d29252a50245832599bc5fef8fcddf64ffb59b979ed40e508cab3d5e4dc25daa7977924a5f30383b0d3c4ac0f196151a650cfb27412ea90b5309d26aac34c5e92e829547e97e2b0cb0b5828505a090b4a869d241a823f28fc9bb51d95e2fd9de255b84718a4a1a8a56bd9a942516af1a94e6b13a7517a509ac34fa34d1cd5e84e94f966b3fc65793e868ea5281a9d41f4a824b69e9168d2a53693a5c0435cf8f8d5e90aa90d529a241d42e4d2b4f186429484a0289d3abfcba974d6d1f1b2834ecce492bd8b524126ec9052010e4902a7cb6f288956935524867a0f86b1589df0ad2e0ea24a9a8685dc74880b2940821cea50d8ecff003f08e6945c4cdf81715b8001a1048d2c08a96a74fd20493a0805449a900ba85433796d0a5c286a018b3a8967e83d784444c590523516a87a921bd522a4a353333532810921412411f13f4fa4324a800004b9a90039debebc63094a090909ef034a1b56d0e97a777490197a8778d6c7f586d844a4f05eb24904042891d1d23d7e50c964921402d4f42af8555a1262a5a9b484abbc4b902d66a8ea20b95ba9443255605c248300d5cc954c4942b5917a91dd20ff005688850208a28bba9c7e0230d247794dddd40a88ef1f0a7cfef8bdca994a72055da8452d13176213b6c5fa9c863e24853035b45f2d25c12aaa895312e0d0faf9c62a5d44a8b25955dc17348c82b280125ab546ab0a758eca555dee68a499ab48c57eea533104020f74a6852cd1f33ffb479ecc0e0ced71d9e38afb5f72938174f6a7e46644339e2dc4f0c6144bc6737384706e71c8c7e1d23fda31996ca0a9f26700667ba973104948484fd21cec469025972a582e5adb5fe918184c5ab0b3fdfaa4c99f2d2152e7613172933b0d894282913254c42814aa5ad2548524862145c47d1f0ae215745596a693f4acd357b2945ef0974b3f34ecd292ca459a528dbaad8f124ccf04994a7d414149d69522a9524d41063be1ecc3edddc69ecf7ed6dcbce7af0f4cc463784e5624f0b736b84c4e52709c75c2d8f5cb4669809a81454c4242713875b3cb9f8696a1720f7ebdbffecd94760ced799be7fcb8e1e9f97f66eed033f19cc6e502a4ca51c0f0bce9b38ccce78642d981c06226932904bfeef3656c0c7cfccd0a94b52d05416898e90767318f1dd3d2a55a3aad05f95fa51e9f23b7ccd5f0f06376bd25b9ecd7cbbe75f08f31383784b8ef8173ec3713702f1ef0ce0b8cf82388b0b344ec2e7d95661284dc2cf4a85350efca989ba26c99892c4111cab86cfa5ced0a44c6abe949d20783c7c3cfeccefb42f119ce5599fb3b399b9f2b118cc0cdc7f30fb3066398e27fce9336627f7ae23e0e94a51732e7fbb566384943e19c9c4a5207bc68fb1ec9f319c94214260285a02c2829c10450bf4afdf1e869ebd3d568a359627f0979fef3a232e749adcecb603344a8395805dd2a1b7ae91b8e4e6eac3cf933a5a90b32895144c1ae5ac10ca4906e082418e07caf3c4964fbd64fda254c0b46f2c2e66662402680ed553ece23cdad5395f2bdac14bc4eace3bd951ecbae22cc733cf33bec23d9cb1d9c67198e2338cd31b3b85710a9d8dc4e2a7ccc46226acfbfbae64d5acecea2c046dac4fb20bd95d8b5a929f67ff668d0b57789e13c5a4fcb4e287dd1deac3e2144b037a283d7fa46ebcb46b62ce006f5fac79b56bce2af29c9fb652fb4aa491ba383728e1ee0be15e1fe0ce13c932ae18e16e1ac9a4645c37c3b9260d397e4d9260b0b2d32b0f85c2c84d112e5a1212054b0a926b1ae2908528977735eafe7f48d165ac828704b0dbecd6b58d5654ca77521c17bd63ca9cef272ea2c6749c519234b87dc0a79c74b3b43fb3b3b08f6a5e3ac4f34fb417650e4d737b98b8ccab0b9362b8c38cb219f8cceb1386c124cbc2c999325cf4029969514a696de3b8aa5eb0a3f091b8ab79c5f2920a4073de0e412e7d7eb19b92ba910d268fcbbc2fb19bd95b286947600ecd68411a491c298b51fa9c518efcf21f91fc95ecd5cb7c0728390bcb0e0de50f2e329c7e2b36c0f07703657fd959349c5636619d8bc49495296a99316412b5a9459290ec001ca094210ad2ec4574ec228593a892c3c40ab35a1cd17e245974330cf4851b14a8f768f5829f70b4973b77a8e0c60051502823bd521deaed0e08482972e7662dd5bf089e74b6658eb5f68fec5dd927b5d278313da6bb3f72d79e09e5f1c6ff732671f65537309dc39fda3fbbfefc9c3291310c277eed872a05c7f929668eac62bd8d1eca29434caec03d9d55bb2b86f17d76ff6911fa72a58049b31d23559e30e6904b296e0aaa4dc6ff4894f374dfcecaf2a6ee75e7b2e7643eca9d8fb0fc6323b32f67fe5a722c71fccc2cfe325f0065337033f888e082c61138899366cc5144af7b34a5092120cc51672f1d96c44c54f98fa814bf77668d342aa96a01437af9fe90e93a5ddea5e953e2443677ea4ac6c6669494d4849660a67178e0ee79f67ce4c7699e5e673c9eed05cb2e12e6ff2bf88331c1e699bf047196166e2725c562b2f9dfbc60b12d2d6898999256ea4a92a1f117a18e649b34806e41fb490e01fd44552d7577256d42f468b2949ac8e963f2cf1bec49f646ca428caf67f767c53962f97e6a924fcb182377725fd94decdae44f3378579bfca5ec53c93e01e64f03e60734e0fe30c9309994dcc720c5142e50c449973f1732499894ad5a54a412925c31631fa273ca48533dfbc9229e348a512c062c129672f48de9b8b87a4db7ed7f6965189abcc9a2705ac9abead44b92777318ba7514974815268c6918a9529dd2e425df50607a45aebd0549048152e0b08d63514362ca5658358c24d909499789952f112a6a15266c99c8d52a7a169295a149e8a4920f818fc8de28f6117b1fb3ec5e659a62fb0af2ce66659a63e7e678fc4e1f8b78a707ef276226ae74d504233008482b5a8e9480120b0000023f55d2485065165edf67c62e5970405171451362de1157184e4a52fd655a4ddda3f1651ec03f64219c92aec3fc1412545c4ae627162187cf1f1fb29c0bc2dc19cb5e02e13e5bf2f38672ae0ee06e04e1fc370b70870be4c85232cc8b0184962548c3ca0a2544252903528925c93524c5da58eab150a3546f0a262d240a07a523a7928bb4a2acd12e31bd922f9cb3ef4014d55a500ebf8c6514296090c094d7716fe7183ad3a92540a4917b92d78cd9531342564f75c01bd291d0aa5acd17e6c60fc6ef6f3763ae6776d1f66ff001d72c3933c0b8ae64736f8539a3c29ccee08e15cbf13270f9b631397e36661b375e13dead285cd4e031b8b025ea0560901cb479887387913cd5e4671563381b9cdcb6e35e5671760a72a44dc878ef86f15c338f2a4bbfbb139094cd07acb5281eb1ecf18a9ca5a4212a201b0dc1eb1c47ce2e44f26bb4670563f977da1394fcbfe76703e3e51913322e63f0d61f88d1850aa1384c4ad3fbc61961834c91310a0c18c7d3f08e3bef2d3bd36a2929d36efbda4af6bdaf87e36c65bc968b9c5de2b73c5bd7815ca9c52a4977a24076f9477b7b13fb3c3b5876f1e2e4f0a7668e4ef11f1dcac36253233de32f71fd91cbee16492ea56639ccd030f2f4804fbb495cc2d441348fbcdc2fecc27b2ea5f3cf0dcce564dcdc9fcb6c336326f674c5f1d4cc572ff00138b0b0b0159996ccff72b8382f7ba482da9a91f40bcbde5cf2ff93dc1b9272df93dc0bc23cade5df0de11381c8b82f80b2191c37c3997ca4a42404e1e4a5214a205662f52d46a544c74cb8ce934b5954d0d3e79357f4d5a2bdb6777ec58fca2caa4d7aaac7c1f7682fd939ed2bcadece793f32b957cd4e15e7af3db2bc3e2330e65725f87f27392616461c4b13252385b319aad58ec44ad33533a56204bf7a4a0c9d2c52af93ce33e5af11f08e7b9d70f7126459a6439ff000fe633728cf322ceb01332dce326c5493a6761b15869802e54c410c52a008bf8c7b67e5f3132ca668590525c17208f0fe71f8c1ed66f629f21fda4dc3f9a730f8332ec87951dae727c9572322e63e07049cbf29e6389282ac3e5bc532a58027d7b92f1c419f2429b5290340f6382f1ee11aeaab8676a928424df2ea2114941b7b5582de1d14e3e9457aca4b31d69d4bbe4acf1e3e1fb8f283c76586515ba58fda0d467b46d69f24853241ee962f46bfd7f94777bb54f665e727659e6e718724f9edcbfcef96dcc8e0dc71c2e6fc3f9de18a06225124c8c7607103fcbc56131091ae4e2a4954b989342ee0750f1d8309d615ff57a1f9c79bdabecbbe19a89538352861c65169c6517b4a2d5d34d6534ecd15ad4b976d8d9f325bb8a38b51922d186122a49a1704bb94bb46ad3a5e82a70490e007da34c28482e1abb582ab4f28fcbb5145d39599c524f62b5004ea76d3d4fca2b60491525a94f568655d8a8249f1a4420a5ea00d2427a0b479f3827b98b56c0a502e2a40ef0b307b456414a99aa0b241a38f5f743835000bd4805879c429513f0be90e5dfef8cec4742b0e0d4b07a7f0bef160bd082140f884fce152fa8ea2a2e3bb5ee9f2860481e00eaa58bc127bbdc00804172e48621ac07488cc7a06d4970e7ce082ea720a428bb3d06d7e90c001ab51720b07a8110f176c065962eaaee6ac6916856b29341d5a8a3e11580182814b0a3aaa498605ae2e1c122dd2345d00e00aa52e0a8d5ee3c7ce2d948492ab90dde7dab7114a4972e14a0438268a31912c28bd1cb57497b18dd2b174b18c1cb3c949811cdbe591ee96e37cb941c507fb4a686073c95ab9c1cd250ee8571e664a0078cf5b40e4ca0ab9adcb767ef719e5fa5dddce2127f22d1573af52b9b7ccc772a3c6f9892e2ff00e72a3d38ff00bb6cbe3feca35c5b0710acd144d493deab3c60aacc7af9ef19734508377a8b0318aa73e5b0168f0eb2773095ef91016b5eefbc488437d2be11230b2209bbdebf589bbb6f688055adb1881b706fb189064a7568bd2e1a8d4f38e7eecd001e7af2b9ceaff8d525c00c7fddce8e0101d2026ad420523b07d98a58573df956967d5c572890ff00fb2a747b3c26cb5fa7bf49c3f491bd0f5e2978afad1b679961f987cc12ccfc719a11b3ff00b6cf8e3c58652aa5b702ad68e4be66cb0398bcc340055a78e735d296e98d9d78e3359d3a8070e75131dfc49496a67f9cfeb2d2dcc65b5c94858d88771d631d20077a8370778b9645540ef5510ed15509241486048356348f19e0ce4d5c0b01c01aa96b57d748add352a2e4d858561c9258ae890080afd62bb302caabf523e51cf246402a5801890a0030603eb04172924316ef3dddda114cab162f404d7e7eb681a8a555341f091b46774d2058e966003934245e01a1615d347059bd5605003456a5d8ed100b6a6a9a518988b6401c8218b1b31f289f13ea1636760621a10fdeea0dc44dae0b547483b003b1d203b97701f7b40adc06abb5c9a41eed7483456c7782ec4a48200a924b88200054ca51ebf0d0c120e905f77147fac420dd2c6b5f180eed67d5dedc885ecac00c9d5bd0d09dddb6f9c1206a2e34b1abd7e700056a63427ad8d3f58845596ea7fab7583b5f0014357eea45183030f7a8243dab5348018380937a03fa4071d18aa801fb3e70cdec0b40240700015246f04b8d26ba41a86821203693ac0350f5688921ddf503500d1bd563aa9ac60b45265a0a482c6c1896b79f58d732c4954c153f151428fe51a34b402d72fb111b872d480525831351d23d6d0c2f5123686e7ef5fecf3ca9933dae7d851243a4733b379828df07047152bf28f4cc992c23138e2a2a48fdfe79001a9ff35578f34efd9d744a5fb5c3b0f1d2ea97c77c44b209d25d3c09c5401f3ac7a53cd9eb38cc7a561494fefd39ff008ffde2a83cfac7dbf6e20e30e170bfff006c9fcf56a9b6ae2a328e7748c9d414b25219d93abf843fe3144c484e28962b4fbb059442127ab7e9112af78421dc857758fe7f9c0c5a5c2152d492b44c0a254182a951f7fce3f3c9d93b1cf1c99f267a4824004bf7f5164f857c3ac644953a9c82a05455a9db51b0f3668d3e42c28a8696658132bf0eff00ce3544a409480154258e9a9f08c1ef9230b059ef1ca402c417537c35a7f28cb066a92ce0077203edb13f9c6261e5a674dd297582aa0144831ac6778be1be0ce15cff008f38eb89725e0ae04e0fca66e79c57c61c4b8f465791e4384909d53674e9eb2120001989a92007348d634dc9a4965ff1f487857130f2315889c2461d25458cd512a0844a4a43a973165825290e4a8960018f956f6cd7ed1d706f66a97c59d97fb04711651c7dcf5c309991731bb43603dde69c0fcacc40746232ee1c241979866728ba578a00e1f0ea04054c58207e69fb6c3f68c388f9f4be23ecb5d84b34ccb977d9e24a66e4fc7bce6c24c999773179e0b754b992702b052acbf2660580ff0068c56a75194864abe3cf31cca64f9ab5ae61512a2483d4937fabf8c7d253e194b8752eff0088afbe5b10f07f95e7e5b2eb9c2b469be5bcf63727307985c61ccbe2ee21e3ce3de27ceb8bb8c78a7359d9e712713f12e69373acf73dc66214573b138ac54d515cc98a26aa51a0601800071d4d9ba96a0a2fd18d478faeb066cdd4e5dc355ee7c631c076600b75bed1e0ea35129b77644a4d6c589a86a3b3bddef1880313574ef4b4666974b03e3a45c562c938654c2c12a2c45c3924d053e76de38671e75633b3964d38266afb82a6c90057d563f503d9d7ec90ed9bed27e2c9594f20b9773f09c0582c5a24f18f3b38e933387394fc192c93ad53b315249c54f0012309824cd9c5be14bbc7ed57b16bf66c38dfb562f863b49f6dec271172a7b33cc4cace38579632e42f2ae6773c5c85ca2b52c056579490015e214954f9e084ca4a013353e87bcb6e57f2df935c01c33cace5370670f72f3971c1b96cbcaf86383f857009cb325ca64ca484809969f8d6a09055356eb5972a51318a8b52bae84799f3ff00ecd8fd99bec5bd8bb37cb7989ce6c461fb5e739b2f5c8c6e5d9af1cf0ccbcbf959c278996996b2bcb3215a97fbca93312ad13f1da8b04912925e3e987098393859186c1e1e5cac3e130721385c1e130f293230783948012897264a404210900009400000034683846953124380cdbd6374481bb13567735894ad82049f29218b855c79dff58c351040a52ec2a63529ea0815600f5de341c6e213230f3f18b5cb9185c2a0ccc56331339386c1e19203954c9aa2129000249510217b6e0af1525337fcb0402c5c10e935731b2b31c0992b0a2183f467f578fcd6ed4fedbef66976369b9b655cd6ed21c39c53c6f938489bcb6e4f4bff001338ca62ccdf77ee949c3138694b4972a13a7274804968fc9ceccffb48d9b7b41bda21d9a3b1ff00661ecf99772db94bcc9e6166585e39e65737b34fef4f31f3dc9727e1fceb3bc4cacb729c2946172e5cf4e5a9489f366e2168d4deeee44c64d5e56c1293dcfa67c660913d2a27e16666bb8e91c5f9fe472a609aaf769550801d802378e65cc248c392905542a2c4b903f50df368dab88c37bf1f0b07356ea637a7395ee689f81f991da730a787394dce7e2d938765707f25f8df8a54a4b008180e12ceb100bedde4a6be31e4839a2e762317331130d714f8a5d5dccc254aaffda8f5fbf68f61f0bc13d80bb74f1a62e64bc2232bec91c6d87973c9d0113331cb7fb2a5804eea38dd23cfc63c8431c94bca0903bb2529e8ddd0f1d35ea4aba8c55f9637bfcb6fb0acad748d32461d4b5246c080587ca3e83fb06709ab21ecc7c299d4a414cfe21e33e20cea54d290a131126649cb8383428224cc4905d2a0a502082447cfa4b9ca96a0506a93a9600d818fac6ece1cbec564bd95bb34e589c3144c5f26b03c493e5a91a14666773b1399a8ac35da7a1cded1f4dd8aaf1d37159ea61bc69b5fde715f55cbd1694aecfc5eedb1d94a670462317ce1e58e544f0163f1bff1bf21cbe5ea5700632729d3384b15180c4a9fddac389331e5ab4ba0abf3e72dc7ce432751494d98d4758fac1cdf82d4538ac2e330b86c6e0f30c22f039865f8d9231182ccf0f38699b879d2cd14858a2927cc54023f0d7b667633c7f23f16be64f2fe44fccf9419ee30266ca0f3b33e5d6366924e5d8f17561d45ce1b15f0ad3dc5695a4bfd2713e132a1a99717e18ed45e6705f05f8afc97d574f66d7b383e68ec691d8efb557357b2c738b8279c3ca6e2bcc38538cf8333797996559ae117ae5d081370f89924e99f869c87973a42dd3310a20d588f53ff0066a7b42394bed34e436178ff00864657c2dcebe13c2c9c0f383965271426cecb7165202731cbc1efccc0e28bae52cd50754b5b2935f1efcb338185989655acc5da3f47bb0a76f9e757629e73709738b937c5588c8388b87f1691370d366aa7647c45835287ef396667860409f85c42414ad0aaa490b414a920c7ea5c0b89700f741ecd52ec6768b511a1afa37f79eae595072777a7aed5dbd354967aca8cdf7904ef384fbe9548ea292a151e57aafc2fd1f93fa19eb7b9b60ce0e64c4cc4fbbd24a4d349fa46845695212907528274a94a62696fc3ee8eb5f618ede7c99f694767ecbf9d1ca99d87cb78b72897272ee6e72c2762d388cf7807345cb0a50291de5e16694ad72310da664ba5169508ecbccc22a52d495d011a92a366f18fc638df67f88707d6d6e1fc5293a5a9a52e59c1ef1786b2b128c935284e2dc6716a516d3472d4a13a72716b2ba7f1f47898226cc44c4a147505026addc614aee62e049621bba18ba817b57f078ad484973a9246828490f53f48a8ab4b20a8a7fd491dd771468f969d3673b8dd99a3580c74a9c852812ebdd9bef885c12029414b45524e9d34eb18866287f9890356e0f7926184e252a75247701d6c55a1c3b7dd7f18c25028e36c9a9054b090950606a10456e2a46d5a0116a144875b9daee45d84694261ee57524a4b9662086da3253314ce565442a80009ebb7e2f19b4d109bbd8cb9ab2b73a6813400336cd012a04a481a6ada523505de9f4fc63194a4975256a0549a85174aa8291689894a8a540872c9520b0497dfc36f9c4117bbbb2c2baea64bbb30a88b52a218a8ea753a92eda59ab1853140124a594cca7a3b3d3ce005258824904b8502ee58521e43c919e26ba9df5778b16d2d5f45fc22e334a810ad012135d4589e8c3e71a5a263b101492496d5715f558bd3312c038254d7b961168cacc75b972d0e90ca362c05ed182993325e9493ab490aa96152e2b19a85a94fa433d03d74c0d49214145248351727e71db46b38bf2348c9bc33a1fed3bec15c13ed22ec71c7fd9e738381cab98b8191338eb90dc618a969d5c33c5b8190b5e0e4ae61aa70b988070588028513c28d5023c8f7997c01c4fcb4e31e29e03e36c971bc3dc61c1d9f62f86b8a722cc249938cca31d829cbc3e2b0f3127742d0a0fb863bc7b58292481a1450a7d4149705041b83b104523e0e7f6a8fd9c38ce07e6070efb427955c3c91c05cd9c5c9e0ae7fe172bc2e997c2fc612d0465f9bce4a689939be1d052a5961fbc618835588fa1a35156d254a12cf58ac5d3c5d7b1acaf069f564497c23e463943cd4e34e4a731f82b9a5cbbcf719c33c6fc01c4d83e2de12cf30134cac5e578fc14f44fc3cd717485200526ca4a940d0c7a9cf61bed95c13dba7b2bf2cfb4f70749c2e4d98716609791f35f82b0d3028f2f78cf2e4a65e7b97043b8c2e216d8fc21b1c3e31207c040f279c44b9d2cb104291716d3e71fbe7ec10f68d60fb20f68c9bc96e6bf149c8fb3c76959d86e0ee29cdb31c4e9cab96fc4809470ef142c2a89912a7ad385c62a8f84c4cc2fdc11f3da7d5fbd758a35311961fea7fc6e44656793d10b07c44113d2f3684b2d205117abfeb1cb390666672a5a92b0e6ca3400529e51f9e195f3f392871b32563bb40f67cc24d953d52274b3cfae15694b429495007f7ca87058ee18c73b641da37b3be0c23de768eecec8524000ff8efc2e53b5db19e71eceb6ae952e58d48dfda8d39a3e277a72f9a1690ba10eeeccb3faf946f8c02b40404972c1e9a5bce3a679776b0ecc32421389ed39d9be59491ac9e7c70c921f723f7a8deb82ed8fd91909d33bb55766b4d45b9e5c38a2036dfed51f3756ac1ecc8e64f6676fa4296a49214c97af53e719489a0114606841a8dfd7ce3ab12fb66f63f949af6adecde00a8279dfc3dff00fd31903b6a76393f176b1ecd6d700f3b320aff00ee4fdf1cb3926c8e65e276b65ac103e1662a7bc5c89841340ca2cc4bc7552576dbec6680c3b59766b0d43ff2d99028dbff00388c8576d6ec68005ffc2dbb35817055ce9c848fa7ef319293ea579d9daaf7cc592010d57bbc53356a32e8c00b80291d543db8fb17a090aed75d99c3a9ff00f5b5e420ff00f64459ff000e0ec62a3ffc771d9a09228073af21adbff6a2254904d2d91da32b0051aa1bc4c57ef08706a19d8d5a3abbff000daec6aa04ff00c2dfb34697a83ceac84e9aff00e71152fb6bf63820a93dadfb3314b5c73af216dfff006a21cd1f12ca51783b42a98a0085007f85ab0a9ef1725dfad418eabccedbdd8d25a09576b9ecc89a33ab9dd90269ff00f91092bb70f632b8ed75d98c87607fc6dc8483ff00b911b29c12c13cd1dced528b001a84b314b91f3f568452c924b907757e863abfff000dfec5c487ed7bd99031b1e76643d3ff0038873db67b18697576bcecca03339e75e45a7ffb2221cd4b664f347c4ecb28a890ea25be10f16251a5ddc1019dea5fac758e5f6daec547515f6bfecc5dd07481ce9c89407fee45201edbfd8a016ff861f660f859bfc6bc88134ffce3ca2fcd121b8ee766ce9510428a4921200158b749163a74d0b878eb54aedadd8b5402d5daff00b3281ffe79b22527e5fed112676d9ec528242bb6076652f52fce8c8c1357ff00d888b29f4fd4473d8ec794a8ea21c87a07d2de4df8458ad6a0c1f4b82526e7d3475a3fe1b1d8a94da3b5ff006634ee1b9cf9197f97ef10c8edafd8c666ad3daf7b32cc635d3ce7c8c37fee446d177ffe196528bea7658a34af53025982417fafdd0169d40de942036c63ad47b69f6352a03fe179d9992a0f7e73e4649f01fed10a3b68f639592076b9eccc41dd3ce7c8987cbf788e9842f9b3f99fd8594a1d59d92d094902aa27676b758c72920b8660fa9c3f48eb98ed9bd8f0a8097dadfb33cc2a3b73a32324ff00ee44651ed81d908a095f6b2ecd72d24bbab9c792107ff727c237507cb749fccfec2dcd176bb473ea882a49649f0248fa08b6521d2412753d41b7d6381b27ed43d96f88f1dfb8f0e769decf79e62d2c5586cbb9bb91ce9c3516074fef2f58ec2e0a5e1b30cbff00b4727c76033dc09485fefb91661273ac1a92a0e0899254a0c6ef1326a9d94f17daf80dc7789808002b5053a6d52e0dad17cdff0077a5981b1d43e87a7f38c34e325a9652900106a92188a8db68798ad4029825ac1af52f1aa524d5cbe55918a91290bee94a9760a670fd3f278d44ce64906c54e102e5d852312548410a248a97005fca0cc0d42ec482dbd2d5f9c6ee5768b1932e7aa52ee7492e3bd43e0638b7b48f695e00ec83d9df9b3da779a330ab85794fc293f3c46572a7a70f8ee24cc0a7dde5994e194aa7bec5e217264a4d74898544324c724c94296a651201375071ebf9c7cb9fed5be63da030fd997b3ae47c1d914f9bd9b311c6d8bcd79c1c5197621732749e249684cae1fc06632121918554b5e2a64b9aa242a7a509a167faeec8704d37693b49a2e09ab9a8d1ab2f4f3cadc211739422fe35451708db3792b6c4c6ce4a1e2ec7c67f6ceed91cccedc3cf7e62f3abb43e6a9c6673cc1ce978dc9ff71d53b03caac325e5e072bcad0a3abfb3b0d2c225ae4dd6cb9a3fcc2757e6fe7f839b96e3311839e50a9d2661495cb50992a70fb3310add2a0ca07a18e46cf674c9b32625c920b36fbdfd6f1b231e9562a42254eef4dc306c3cd3732d8932d47a0ba7e623f53eddf10a5c4e8fbc29d08d3ee928d3e556518470a9d962d15eabdfa3be2ddb5ed65082c1c75884951259c3dd546a0a4696b043aa8d5a811b9f1387d009228ff2f28d0e7c801f626afd3d7e71fcebafd34e326a479b38bbb6cd2083a924d36074b8f2261095289b12f7366f18cc988013b160c0b30f38c5209b6f566a8b47cf4e0d3b3dcc26958420a4106a412480011d09f38164b54a480056aa87552cdd091ebe6f15d8b50259fd7e9e11c92563214d8d95a459e81e1e9472cd6b1684042b57748ab106f13bccdf09146eb10b2ac371c0b07248bac569041b0a1abd4024ef0124e970024589b87f0824543d58529582b4b6030baaac3a6c7ce2cb12492a6b3070fe6f08806868ca0e5fbbf7c384a5a87a8a87d5174021d459442424774bfe117a0289a3d69a53476eb1550a9341e2a14da2e47754e9347a3965396a7ae91bace4d935d0e5de4a38e6d72d4ba943fbeb801535ff007e978ab9d21b9b3ccb6229c6d9880496779cade2ce4d2b4f35796ca01949e35c028821c8ff003c33fdf1473a940736b998e0ff00dfae60fd0bce31e9ac70dcfc7fd945b656f338767b1146a54f5b88c23466a798a98cc9c4f78503d3a131884b172c48b78c7875bd6307b882f52cf73789022462406c686d63052f567b586f0bd7f2821de9782f30644a4ea722f7b9023b17d96e9cff00e54bfc3fdeb96483507fc99f1d759407d936a976a88ec4f65e61cfbe569247fdf3a5983127f77c41148f6b8425efea0bf2e1fa48da837dec52f15f59a1734595cc9e62909201e3acd98b38ff009ecf8e2f989ef4cd882cfb6d1ca7ccdd47987cc3b247f7df342a00873fed93adfca38b66b127e1486ffb5f28f438a5bdf33fce7f59a4fd6660281538a84bd6846a68a924a8801c816a56d48bd41d4410145340c453c8454a040704241152ddef18f11ec612f0652a72e49f8aa4569b4292caa004160351bf9fada1d4fa59c10ee7f942d187549a3867f131cf2792856ccb528d8a6af716881935bb07d02a1a19357d29014687558ed0acc0592d4a1158a3b750149a06480ee0d1b57aac00021943c76aa6ad109ab917a334313648623ed51898af4c800510751d8395292c0bf5883502afabec3a400ca1566dc33da16c3ab9f30c60de00ee1c001882e0b30feb1183ea04970c75541a6cdd2200c0d4292ede3f280481721b7b1229d61d01092d74ea7a39b4292a3f102d604d3d7f286d208760c6dbf4865214db97172439af9c1a6b20ac9a8748662c40ac0700100779dab471ebac595b58b3d004914bc2d5c5016bbd48824da012a72ecca3670484c02ea482ce1aa5368700971434d983f4788965020380cc033b79c690ccae060fddeed94c5c45890a054059d9c5b7bc2905245981b821efd2180aa7bd4259b6f988e98742f1f233256a70cceddd1d3a9fc635cc0256a5a529d981276ad4c6932258241047d4031c93c23942719889699812949581a96c129ad49f2a92fd23eaf8070ea9c43590d3d3ddb3aa8c1ce4923ea7ff00656bb2b4ee63f6c8e2ced47c4380c6ff00747b2372e319c41916382a661f0589e2fe25933b23ca70e54184cf7583c466b3952cff00e36513611f775327e20125534ae62d456b52aea51a973e31f917ec3aecd327b2a7b3439389c6601380e36ed3198afb427177bc949958d197e3258c3f0e61a71b9030689334036338c7eb1a6619d3010e3577561268198bf9c74f6c75af51c5de9612bd2a115463ff00037ccfe59b95bcac63526ea54cfb0d6f07889855ad4000904005c25c9a92633674c212a01054a4dc0720ee3e8631112849948aa4b83312d727cf6d8d62d413300516f8746900308f8e937277656cd6118f231870f3828baa5ce7d6efdd20d15e77711b906355eed0c490450243218ee77ac6d79c4216525283dea95176fe71c65da1fb4bf227b1a723b893b42f692e2d93c21cb7e1b94a9595e0a514cfe2ae3fcc949270f936438270bc4e2672804f77b8804a96a4a4131ae9f4d5f575e1a6d341ce7276492bb6df812adba3917995ce9e51f672e57f17f3d79fbc7193f2cf949c038338fe21e27cee7894272dff00c9c160650ff33138a9eb6972b0f24297314a0948dc79d07b68fdb9fcd8f6907174de5af024fceb95bd91b8373552f83f95d85c59c163b8ea74a2532b3ae2a12cb622730d52706b2a9387d4fa5537be9ebe7b5afdaf5cf1f694f32252f392be5ff21b82f319d3394bc93c9b1a67653c36853cb4e6399cd4b0c6669325d266208d32f52932804d4fe27e2f18b5156a5124dc92ff002fe71f7d1a3a4eccc5467153d62de5bc69df750f197494be48e2ee5af22859cd67c0d4331cc57895ad6540ee6ae4c6d89b33528a8b5d9ba4054e357b0118ea52685831d857eb1f1baed6d4d4d47293bb66529ca41512cf422e766844936a16722ae05a19812684d2a1ae23b7fd89fb0ff682edf3cf1e1ce447676e06c7715f14673884cdcdf389929786e0fe06cbd2a1fbc66d9ee63a4cac2e164a5d454b3a9659084a94a093e4d495b2ccf3d4ebc72fb97fc6fcd3e34e1ae5e72e784b8878e78e38c334959270c70970b6573738e20cfb153d7a2548c2e1a582b5a9448b0a5c9023d0c3d8a1fb363c13d9af13c33da6bb7b643c3dcc8e7b6065c9cdf80b9138af71c45cbee52e2081325e333c0ca91996692a9a649d786c3ad2ed316014fe9dfb29fd8add9b3d97fc288ceb21c2e0f9a9da633dca86078db9fb9fe5c818ecbd1312d88cbb85f0eb04e5d8127524ad27dfcf03beb00e88fd9ec34b38742520e9eeb93d378cdb9497a4c86fa1aece3ef025208025244b94848d089694b0094814005180a6d18e10a0c5cb16a59eb186b9a680904805560376ac66e131099aa44b20a97a8699691a94a3e02e62364410621525414a04049ee822bd6365f37fb49722bb35f03627991da179b3cbfe4cf0461edc47cc4e25c370de131aaae9958544d50993e6299932e4a54a51a00e408fc1cf6c7fed00f21bd9e180e20e49723f13c33cefed86303eef13c3d85c62337e5ff2557365932e7712e224ab4ccc70052b46532d7ef2a954ef76823579abf69fed6bda13b5cf33339e6c7689e6a717f3538d736c7cdc6a332e27ce276330391226cc0afdd72ac1157eef81c3a1929449c321090940bde2a94a7172b609b36afd0fbf5edbff00b5d5d99b9672f36e16ec5fca9ce3b41715c8f7b86c3730b8fccee06e57c95a58267c8c20ff006fc5a0d48053252a09bd63e397b6cfb68fda21dbc730c749e75f684e27ca780f14552f0dc9de55cd5f2cb9558194a090652f2fc22d33318e5209563e6cf24d80b47e4ca71f354e16a2482e544b927ac09938a815100bfc2c4068e98aa314b977345c89d91aa6267ce9b3e662264c5aa64c56a59762a24b927c4977263e97bf64f38226f1bfb59f86789d7834cfc2f277903c71cc39d8a9a825181993f0b81e1f90b41b05abfb6a6a03fd954c8f995c34c4ccee2bbc49624de3ed83f6343959fbef3cfb70736664b053c27c92e1be04c0ce60ea567b9de2717894fc9194483f31133972d3e58ecf7264ed0b743ef271f8299881ef8a416a9a7567a46de99244a4a80494906c0778978e424a124041eb6d8468f8fcb52ad465a424acd40621518a9789926ba9f88bedfde3193c2dec73edd2a9ab99266e7fc11c35c1b825a1650553330e32c8d4b41f054ac34e491b8263c9f274c54d2a555aa097a8f28f4fdfda95c64fe1cf643f1c60a4e30e1d5c71da3780385e7cad412bc5c8973b32cc2621ba6ac2cb27c8758f30dc5c84c852d0e0bac91d0c6d4b9a5cd678c178d9dc39465589ccb1927058392bc4e2f31988cbf05212095ce9d394254a48f15296008f421e30e5165bc0383c8f8352301257c0dc05c35c13364c8289624cecb787f2e91884a520b069bef02875063cfb387389b30e12cff23e25ca274b919af0f67585cf72b9d36423112e4e270788978990a54b50295813252094a8104020b88fd58e39f6e97b4b38e6763f15997687465f3731c42f178afec5e5a70be5c56b59725c6009fbcc77f0cd7d0e1f567395fd24963da55349f91f41dc4d90e0d0b9c89610a658f75a10565cdddb6f2fca3aebc6dc3e31782cd325cd3224e7dc3f9de0e66579e64b8dc04dc4e5b9be166a74cc913800e010c42d2ca4a9295a4852418f9f0cdbda7fdbbf3d337fb47b4d71fcc4e20bcc46165e5b9502f76f7385437ca38c33eedb9dacf3e4818eed13cda9a91564718e27089fa4b29fbe3ebb49db6d0e9d352a3392f0c67e9348d551c5b06f4ed71d94b35ecf9c4587e22e1c939be6bca6e27c64c4f0ee719860a64bc76413fe35e5198ab484fbe960ff009738327112c05800ea48eace5f98195a085105deedf48d778879efceae35cab1d91718735b981c5391e645071f94f10f15e3739cbb10a94bf792d6644e98a46a429ca560021cb1a98e39933940ea7720ddfc23c2a7c4f490e212afc36328526eea3269b8bea935d3c3af4f3119252f4763f607d99bed14e6ff00603e7ff0bf3939639baf4618a728e33e12c6cf57f7778ff259b3107159566329f4a92a60b9535b5c89a842d04541f525ecabda8f925dbcf90b90f685e4067786cc326cc25a707c65c2532724f1272e3384a12bc565798c805e5a9255a90a6d1325ad2b4129553c62f25cd0e1e6208500490e1ddad1fb69eca3f6a6f367d9d5ceccb78ef83f1d3f3ce05cf952329e6772e3178c32725e39cad2b7329609d28c4ca0a59c3e208796a2525d0a223fa3785cb877bac701a3c1f575234b8ee9e1cba6ad2768d682775a5af27b26dbee6a3fc149da5f7b94adead17efa828b7e9adafd7c9feaf03d42b13865c89a65ad2a42927ed3a52de71a54e04ac8d4417d4426a0876611b5f931da1393ddaef92bc17da2b909c412f89396fc79801884256061f3ce11c6a404e2f28cdb0ae5587c561a66a94b42a940a495214951dc93642e5166a5ddd8a43c7e1fc57836b7876a2ae938851952af4e4e1384938ca138bb4a124f2a516acd3fa8e2a946516cc652d7b8d252a234a8e91e1f3a7d22e04f75540a25dd9936bfab428945c9290c12e413e76f08548eed1d459c02cc047ce4e9358660d5d58cc4ccd4ee4004849eef74576faef0c1492a53120d41d219459ef188e54e4a411a2a5c54bff3313dea8a52eab1635b33fafac72ce0ed93370666fbc50602a59c001c03e5f5f38c8f7a6bde502ef301018d768d31fbca48b692c41142cc7e70d2cead2a2a52a9f1b77a86e5f78c1ac153312b7331dca955496aef424f9c3a8128673a964295a8746da3182d3f69219434a0ec9a1a374a9fbe0a66805292fa50a62a25cbec0eff003f0880cc9493f16a4801ca89aa541ebf2fd627bcb1052a170c58b358f4f3de2924a941802e4901c00efd7ac4d634384972a6d2762cf5f2bc40dcc944d24824a8b03e0f6de1c2c153a5cd6c52411fcbc230424962fde770283ebf7d62ff0079de0682b449036dde3683c137e577467c8985200ad295a86e86388bb42f213979da9f915cdaecedcd2c0c8c7701f38b83713c219d89d2c4d9994cf989d597e6921fe19f82c48933d0b151a0ec4c72a8525452cd40ea2ec91d7d78c3297a124a19dc821e9d19a3ba86a250b38bce3e8ea5ee9ee78def6cfecb9c7bd8e7b47f377b38f333033b07c5bcaae2e9fc3b8d9d365a912b37c3526e5f9961cfda938bc34c913e5ac3822611b18ea2cc49973029242994ec5c8f331e893fb509eced93da0390981edcdcb7e1c13b9c7d9df2a93c39cdcfecec3fbcc571b703ae6a9384c7e2129ef2e764d3e6a926617230d882f4974f3bb9d2d52672e52c24a92aa90ca4c67c5ea51d44a3351b49acf85fadbf8d9946acec660cce781ad32e4ebfb7fe5243f8da1066f8a25ca24b5e92c027ca34f5b39a976720d478c576bd40ad44785251e6582a6b2336c45069945facb4d7ee8619a4f25b44a237265241fc23460436cf7bb43a555620122e1aacd11cd04ad606b68cca729bbb2dbff2491e7b4589cc663fc12831ff00c423f4b468817dda2857c19a095bb77801bee4c4a9c77b164d2e86b47329a7577648a7fe252ff84589cc9740532bbd70642097f02de11a13b82c7e10f52ef0c15de02cf73470cd12a714f089e657bd8d7ce633188d321c6ffbbcb6bf978420cd162aa9720d29fece87f1da344d6e082680d0f5ac10b240a0013f0904178d5554fa2254f3935ffed59a09484c9a8703f7797f7f761c665308ef270fa9effbb4ba0aff00a636dea2a24a43904d4b06871308a3dc3bd08de26359ad8953b23712b32201d2895ab531d3225b7feeb09fda4b73dc937b7b841afd2f1b7b5962c43835269b4326654d7be7627bbf5fa45fbf96d7279a3bb35ffed0995a48009eeffb3cb61f2688acc268b0c39a77bfd9e5b8b7846820970926a4d1e8d014aaa92e030a8f5f28af7b70a51bd91b8119acee9242458feef2dd55ff00ab04668b555699045c9187960fe11b6fde1172096a0dbcc45a998c2c1fa6d1a2af2b596c4f32491b8066b31dfdde1e9d70d2ff00489fda8b2fdc92f62d225fdfdd8dbea98e3661e5d610ad893a8124d491f8c5bdf352f70e496e6e719a94dd3240f0c3cba7dd1139b4cd4494e1e950061e59ff00df636d6a65514ed726a4bf5852ba0ad6e03da2cb57556cc779d59bb8e733198893e2918796ff00fbaf9c51fdb130121289203b1ff6696e7cce98db226ea04bd49705ebfd214ce5122a5cec5bac5fdfd59add96ef16c6e819bcdd435264962fff003796ff00fbac6a12f3a9a525932d2921923f77961fcc69b46cb4cc2589153d4d62e135407c54b35c1f08da8f11ad4fe116537b1bd30d9e62254e4aa5ae54a5fd952644b4abeadf7c763794ddb0bb4df21b1d87ce392bda079c9cacc7617152f1a85701f31f36e1dc14c9928ba0cec1cb9ffbace0280a274a5248704178ea12666aa02c5dc3b007ac64a3104dd44a7ce3d0d3715ad4eeb99e49524fa1f5dbd8aff6aebb5ff2d31b93f0b76c1e0ee13ed4bc0d2972f0d8ce33c2e5f87e5e739f0329d953bf7cc2a1382c6ac30eecf932c963de78fb59ec47ed19ec83ed0fe0d99c43d9a399d97e71c4d9560118fe2fe5271129192f35f82d2a1de5e2f2a52b5cd90092062b0fef2496f88104478e561718b964149018dac44732f2979ebccde4671ef0c734f93fc73c4bcb9e62706e609ccb8678cb84f359995679944e07bda26a0f7a5adb4cc94b0a9731274ad24168f4232d16aa8de6f96a2d9a4acfdb1c2f9559fb4b38a6ae9e4f6a754c44b483aa82a5b6a469b3b1e0150412a22c541a8f1f375ec42f6e7655ed17c261fb3bf6819dc3fc1ddb1b22c9d58bca313824a327e19ed0183c34b7c46272e904e8919b4a48f793f0483a66a754c94032923e8fc60e6800cd96a4a9248520a594936208da32eed42ce4ff008f1f67811169af3322462f5212351725ca455dbac71ef3b394fcbced19ca6e3de44737f86e471772c799fc393f85b8b7229e7ddcf5c99c96462b0936f2715865844f913d3de44c94856cd1be3dc996ea4f76b4208a45d879c25adc3150ef77bac75692bce85786a2936a7169c5a767169dd34fa34ecd3e8cbf5b9e50ded24ec0bc73ecf0ed45c69c80e3fc72f36c8242ff00bc3caae6162647ee586e62f0d6296bfecfcc08f813894006462a524b4b9f296ddd2927f38f1d82c0ea225e3702b24d1b192eb7ff00547b41f1270472f39853306be60f2df979cc0196c85e1f2e571d703655c62bc0cb98a0a992e42b192262a5a16a092a4a0849201678e05e29ec05d83f8f7133319c63d8a7b2be713549ff003279e48e43809eba1a9548c3cbf99bd63f48afdb9d1f11a318f14d1355acb9e70946d292dda83e5b5f7b5ec9bb2c1d11aada4a6b278e563b2e2af78652a54e4a457dd4c13423c287ce36862f08a412e0f4259dabf847a0cfed1c7b2dbb3472e7b1d703f68becbdc82e5a726b1dca7e628c9f99d2396fc2b2787a5e7b9371021385913b19eeff00de7ee98c93862827e14e326da3e08f3fca5585993429253a564064b9b9b7e11e6711e094788705a7da0e1ea5dd5494e0d4925284e0d5e32b36aed38c967d5922ae9f3439d78d8e27c54962c1c025ca4758d3972d4900bd1bbcce488dc58d9212a586029de56c1b7f5d63439a81a5c92a236b5691f92ebb4ee9d468e2946ccc358d241500c4b82285bc22bd206a6723671578c8577fbc52fae81d9c7a68a689a14b901897711e2ce365939da761086722e4d49a341259cee4505e9e9e250b0d290017a8ef1b4000b862fb2802014fafce31564407538ddac4dd3fce1d2494972454b1342ada2b4eda4775fba2c5fca1d4185412e1ae1878085ad905942aa8770ee054b6d166a014e5248a009502488a3606b43a525c07870a49ee8d4523601c1eb174fc017ba8ee4b1a31778b52414b694bbd09fcbe918da52a4977a7423a464a46a2c901c0ea01531ac74adac6ab2ecd1ca5c9fd49e68f2ecd01fef965e4d5d899e98af9d65479b1cc82cefc6d985377f7cabc65726a5ebe6cf2cd2c005f1be5bdda7fec4a1fd78c4e7a2129e717345205071ce621205187be518f5134f867fc7fb28b5b1f29c2d355521cb9dc82cf18c40673706bd3e519538254d6fad630d54b50599fce3c2adeb5cc64eec059e968902246241208bddba1e912a4d68e77a446a863f3b401912896a1abd412cde51d86ecc4b6e7cf2b0821c714a1cd9ffc99ff00afdf1d7b40b6e4b93f947607b34d39ebcb022a53c512f4866ffa19ff007c7b7c195f8869eff8c87e9236a0befb17e6beb347e67027987cc32a1f0f1c66ac5d88ff006d9d68e329b5ef14bea4fcba4727f32cebe61f3054aa6ae37cd5a858be3675e38c678292a09569d853cadf7477f15bfbe26bf29fd6cd25bb3056c54e9008172925e28556a2a19abbf845aaaa99b438a8f1114970a00b307ef585b78f12584ee653b58452d9d2c069346fcfac05124b1d4f7ab1021802a24e97003beab79c2923e2297360c4ea1d0f888e69190058872c07c428550ac486052458825b541255f0d3bb71668572d50087ab1b0e915767b8200c3515170fdd3782f40c4d681c92d0a4b021f507d2e3ee73046900e97a51c7578aab2609a8e951537d4b4224ddc51e801ad7a44770007bd585e910025cbdb668877796063b3a81e809768852415f7839dc12a151b430600e9ebb8a97e90b7d245c8235353c61e6081f6bd88d5dd57943102ce1a81c6f0140382492416e9e30e0d12025d8bb1b9f0112ba82b7177d55635ac10c4924b1143560622eabee821443d98416720949a067029b44a4c0401f777433137bf586046929d4438a83b4109609043b174b0626f034826c4a2a0172768da295c042cbd817a3bb98be5a0920b9006e6bd6d1400ca63424b35cb3c66c90a2c9f1bef48eea11e692b2358daf6356c1c82b58624b5c9b7d23f4bfd99fd93337eda3daff00903d9b72f933bf71e66f30b0395f176364ea0729e1ec3cc18ce22c51501dd29c048c5a10a2dfe64e9750f1f9e9916055885a50941726819fce3edfff006527b2b4ccbb33e7ff006cecf32961c29924ae4872d31d3e532139ae6e9978dce6761d5fc52709fb9cb2458e208ea23f5fec6e9a7c2f47aaed149628536e37fc64ad0a4bcfd3926ff2533b60b969ba96c5be967d7ff14e5793e0b1b2328e1ac1c8cbf86785f2cc370a70b65d85409584c0e032e929c261a54a48000484cb0c91b3468383c32d7368948484ff00980380dd3e65e3736265850d2ad4402c905ca9ecf124e10499604c0c663a946de43e43f131f956aa5275249b6ff5ff001bfb4e151f48c3339884a12b007753a8b8a1a01e1e70d204c985291f1057780a3374833a529092500b834a7c3e23d5e348c471070e70a651c49c67c6dc4396f07f0270364788e2be39e31cf7149c164bc3596e12599b88c4cf9aa3a432524212eea5148009201e4a542a569aa7493726ec92576df449757e489b5964e3ced15cf0e53f64de4a71d7690e7be769c8395fcb7cb558ec6813129cd38ab1eb0460323cb65a98cdc5e2e6012d28482402a5164a491e5f1ed20f69873dfda1fceece799fcd6cfb1985e18c0e2e7e0795fcadc16357fdcee5665056a187c16030e19067196107118b23de4e9854e4242523bb3edc6f6b97107b4539d32f8778171799f0f765ce516367e57c9de0b54e561a567d30932f11c539a49765e371812d282c1fdde4109480a5acc7cf163f1454b5b29dcdf73e023f4a96927d8ad22a7ccbdff35f7c6bfa34f3dda7f1be3b5d7d1d95def183a494e7bf45e1fbfeaf699b8bcc8cf512145def72634498b0a3b39b90ff0048a82ecb2428170037c30d2c9986b5a921854c7c46a755535555ca7bb3373bbc944c974abf7afd01e916e1f0fa8d4920dab7ac67feec54804a5926aa26c911f555ec5cfd9c6e3eed8337843b4876cccbb89f957d9695364e77c37c0beee6641cc8e7ce1d2a0b96256a026e5f954e003e30a44d9c83fe436a13470d551a335cc8ac925b9f9a1ecaff006347691f69ef30b009e12c14ce5c767dc8b354279a7da078972f99fddde1ec2cb5054fc1e4b228accb34989744ac2ca21095282a6cc96804c7a66762aec4bd9efb0172772be47766ee0c93c37c378632f11c4fc4f8f972a7f1d731f1e80caccb3dc7252153a62895144907dd490a64240a9ed8f2eb95bcb9e4df2ef86795fca5e07e1ae5b72eb8332b4651c2dc15c2396272ac8b24c3a1212944a949aa9659d7366154c98a254a5294498d4264bd130bd5d371e71e74e5cf3725b19b777746ab267ea53288d44026b515de3589050484d08d2e9366a46d494a2921414001770e0475afb5cf6d9ece7d8579498ee757697e6365dc07c258744d979165896c7718f1ee2e520ac65f9165a089b8a9ea3a524a40968d40ad69158a95bf89daae2acdb21e12e1bcf38c78b33ec9f85b84b8672d9b9bf11713710e632f28c8b20c2c9495cdc462f13308421090092547c9cb47c1c7b65bf69cb38e269bc5fd99bd9c39a63786382e5cb9b9171b76aa98b56178af8e16754bc46138430ccf81c080e9fed198afde27ea3eee5c942533267e487b5c3dbcfda13da67c478be06ca26e61c98eca5926394784f92591e66a4e27898cb5912f36e2dc5a08fdff0016a0c5387ff9ae1dfb8852de69fc11c74d4e216589555def7898537283949978c6f1e6665661c43996758cc76699b63f1798e679a6326e61996618ec4af178dc7e227ad53274f9d3564ad73262d4a5296a254a5124924bc6873a61502ef7a955e2899aa59743f520d5a1a592b2c412a352371095494ad07b112936add0a83a545c900559e863225a8287506b42c0445c85292a5682408cfcaf24ce7339b88959765798660709809b9a62a4e5f82998e9987c3494ea9b889a9402512e582ea5964a45c88cd3941a4ca94212bd695a43005ef7e8f1e8b3fb1adc1432aec95daef9938bc3224cfe35e7a64fc2183c4de66230f93e468c410ed613b1b369d63cee7092f56a0862169fb41dff009c7a7cfecb5f04ff0072fd937c199d2a4fb8c6f3039e5c5bc4b3a6b127112b0d3f0f80904f92642846f517ded2f13493f42c7d2acd941ca810c2da6f5f5f745452250724283d955118b2b1c9501fc44bbedf48c833d331e5d1c8a38bff0038cf6333e4b3f6c0f8ec64bd833b3af04ca2912f8dbb511cc27a75316c9722c54e496dfbd8a487d9e3ce131ab13164bea70f58fbe4fdb29c46351ca9ec399624cf1829fc7fc6598a894a8c8135396e5e80e6dab4bd2ed1f0273410024dc7c46f1d14a52545c16d7fb0d22fd16604e1a85d859bf3fe518eb3bbbb0ef178ca9ecc18f749d8c61aaa03b831c92693763303867e85c351cf8c0d9c9626c5cd37889676bd5af5310d985768cf22c3a431a96a078c80a02c6b6158c5043801cd6f0c2950e3a1bc74539bb6183569138a40ef105de97da375603379f2172f42c8093420b1f378d8a92685459efd01a46a522690a4a8b804f8b031f49c278aea3495632a5369aeabe43684dab599f47dec55f6bb71cfb3db9bb87c37100cc38cfb3df1f636465fcdee5d2714f32761d444afed8ca90b3eed398e11275a5274a71084194b525d2b4fa52f08f19f2d79d7cbae13e6ff0026f89f2ee35e59f1e6552f39e18e22ca667bd953113120993393f14a9d2c9285ca98ca4292a4a80223c56f87f3b9d829d29489ba52140862cd1f4fdec3af6ccf16f618e61c9e5bf3471b8fe31ecc1cc5c6cbc271bf084f98ac4e2383b12b294238872404ff00973e502d88c38ee62653d04d44b547f52e9b43a7f767e071f78d9769b4b49455da8ad7d282f4694db765a9a7156a151faf14a8cddbbb943dca2a1ad872afc2dbfbde5edf07f23e96f4199d2a64b99eee632092c3a1f07fa523066ba014bb101b503de4d3f08de09ccf83b8e784386398dcbae21cbb8c397dc759449e21e13e28ca27a71780cd30b3d2172c85a4b380588b82082c4111b327a2605290ad434864f9359ef1fce7acd154836a5071926d3524d494a2ed28ca2ecd4a2d3524d269ab33caa949c6eed831d53429265952505350a3f093d3f9c0d674a4872a2a08297a11573688a96d54d1208043382694fe900ac02cc7526a5e9d7d3c78d3a6b29a32320288d20cb6d419201a071ead195a8680dac905d45d905b76eb1a61515d7480a770e4902976fca2e412fde2e19cbf785c968e39d24b62ae09ab2328ad49d641d23e24906bbefd6205129577402d526fb562ba900a1200d34150010ff3dde1029492ff00654926624390682d1ced34676b7ac65217a7482b51041762d6f5f745a16147bbab53500babcc7ce34ea395d490410b0e1203f47e9b46524328050515283bb684d8dab104f4573282857536ba90b62143ac3966a9249dcd002f727f48a12b6491f107d2e90fa4753e3b7ca22e6287775506e03d0d403e10ca22c9b3314b32c14a005b86294963e67c2295cd9812952aa0f77a8115fbc3a90b53004774153297f9fce2690b48d40eb0e12a4a8e92fd3f9c6b4e4d35cc22ecee6919d65592f11e519bf0ef14e4f83e20e17e22ca715c39c4fc3d98cb13b039f65d8d92ac3e3709392410533654c58f02cd511e53bed8ff0067366fece4ed99c77ca7cbd18ccc3939c5d317cc6e407154e96a6cf38633198a9923093576fde72e9866606725c97c3a547e38f57699294b4324d4175694bb7ae83a47e377b737d9d63da03d89789470264b2b30ed13d9e7098de6a72704a949398f13e1644854ccff008650a624fef98796a9d213403118747f118ec97773a694d5ff008c7d8fe7e88b3775747955cc47bb5328387a1dbe71592e180350098d6336c34dc26327e1a6ca992e64a9aa97365ce94a933a52d24852168354a92410526a08223480145d8d19acc291e2578a8cda83bae8662d0509a82f76300798a0b8da233b020da807c50de77a6d58e3587801b1a177a907686a801c03de7237f28ac50909a97a78c5896249657fd5afaf422cbc6406762e18bd1ea1a900a80b9de95fc2148d25c972ee4588f2829a95d05b72e20d81b500017adcee3ce083460a01eae291500df6836e0fe70e4971de0c2d4ac45da03856a0e414934201bfca21242481460ff7c04a88240dfadcc2023512ce00a8d85e254982c249600330b58da2053805412f7a7d9ac2ea0f57a8a9bec29053b973674902b7fbe1ccc0e54410c74b1804fda21c1dd5685a102a58962c3a412e12e4135a17b8fd62799a030b80490c5c354f9c36a2490e4122d727c22ad4521c25443b904398256cc36661b910e7c5d8194028509047d93f8fdd0ae406a25875707ca0051ff50d806706212e4bf910d5f5bc5b9dbdc0c18172a23ad4d209207423624f58a8a924b0a80967fd62774b35c1dcb7cbf082a8df5191d99d8b8297b311fca001b9a01622ad11fa96b1000dbce0104396763402f4ad226327e20b814960ec5adb1f230c5c03504bb7c57b4520925abd5999a0ca0a2b09582146c2e0f845d4ddcb2934cbd2561aa52df4316266287758dab576e9196709a400568131c112ccc014fe4f78c29a954b98a4ad252a77037348d9371b3bee697b19099954ab5391723f3fba3330f38eb0926f67b98d2a5cc3a88a8ebb968d52490a1f0b30f992f1dfa69cae8bc77c9cb1cb2e3ae2ae5af1af0bf30380f89339e10e35e0bcf30dc4bc29c55c3d8e5e5d9df0fe3f09313370d8bc2cf410a4ad0b4821a86a0820911eae3ec84f695e49ed28ec79c3bccecf71396e1b9f7cb89d2797dda1320c08125073797281c367b2648f82466b253efd87751344f4060911e49b8398695292d5eb6b47ef6fecf676e3c5f63bf68472ef26e24ce66e1392bda5c2790bcd8c0cc984e5f859b99cd1fdd8ce949b26660735184066dd386c6e2c7da8faaa7dd6b34b1a2d7a71ca6b7e975ec7f5d8d26ae94a3b9ea00274b9c4e963afa7e30e894520a5810cc55b8f9c69f2e54fcb27cdc2e2d3a6661e6994a7040052487fce3504e2c105d1a90aaea49a587d2396fc924a1b7897f619d227195a412c0514d720dfe948d710b4cc469040dc56a6f1b614b2a5a4a406704b9a45a9cc2460938bcc732c5e132dcaf2ac22f32cdb35cc3128c0e5b9561a4a4ae7623133d64225cb4241256b200eb1d8a0aa479d3ca252b9c47dacb90796f69becbdcfeecfd9c606563a473579619ae4195cb9c90a4c8cd3f755cecaa72491dd28c5cac32b50a868f1d9e62e131794e7199e4b99e19584cdf28cc67e4f9a616624a6661715849cbc3e210452a99929748fbf0f69d7ed3470972a25f12f25fd9ed97e49cc2e39c299d94671da3b8a707fbff02f0ecf4ba16ae19cb091fda335041d38ac414e18100844e0e23e0d79ed9f679c73c739f732789b305e73c53cc6c6af8fb8a735561646095996699b138ccc67fb890897265fbcc44d9cbd12508427532520068fd9384f01ed3706ec26b5f18a0a953ab52955a7093fbeabc6709ce50b7a0a69534936a5e8ddc52699d508d5509392b2763acf8f00cc50a1a5ba797ade3409c080a60e0d4d1dbcbf58dc58ea12482eec40bc6813db4901c000d0867b563f07e2f4fef926ce09aea698c00525c000b8373e4ff9c54a00248160400778798e920bb8fe1677f9c5649d4ad22e1d8f58f959a6d3473cd7510b9d5520382356d058bb829637215de7801b6000372690490192c1441da840368e75be0cc80e91714e9457cbc61ca802002403b13784702801a962f71f383601d98d2ec5fd7488cbf458f68cc68087512e483f8c5841490caad5c1a37f484403a9dcd6a0dc1b431a9ad0bbb1defbef16826f216e38d5a5b7555fd6d17a4b242827e1a00f478c50ee18a800a724c64a1d4f72e685abf28e94adb9ba491cbbc95537373962aa13fdf8cb42bba5ff00e72978af9e2a0be71734949b7f7eb3100bd9a7a85fe509c99af367966d5278e72c07a8ff006a47f385e773ff008bdcd0eeb7fc7ccce9b0ff00685c7aab1c2aff00d67ec22df073e270ecd6a955439b1a461ababb8319932a0966f06b5a3116c0071debb8a031e056f58c25eb3122416a035bfd624625400b7ab4167fc7a4403cbc6b101636aed0064ca23ae93701e3b0dd98409bcf9e56834ff8d72c35cd24cf31d774b9209a386707f08ec6f659af680e54382a078b25a0806a5e4cf11ee70549f11d35ff00190fd247469ecaa47dabeb341e650f77cc1e60a1c029e36cd015162dfedb3a38ba693de7a815029f231c9bcd0ef731b98a7ffc79cdb48ab0ff006d9fb471aacb3583934e8d1e8715fe73512f8cfeb64cb7669ea3a4806e05cb10d18fa8151d8dc02cc7cbf48bd4c093424d002773e9e2a03bc144a8795febe8478727d59476f02b0c6e0b904d8048f0688bb8a0076502c7eb0da89d400a9b3d8c2125aa1f7eade51cf24fc0c9a0690ca248ee8720d874840f536a5416f28b0920114a871a6c3d342902aeec453ce324aeb08814b0096002771b9f9c423baccce59934fac2ec428b397157ac328bee41068545874bfca0ac055330dd8dd200229ea91004a8b38eae2af05a840a6adbed188e01700b80d4140ed04af96024f7435403626d0c84e96502149f3ad9a148a33e9ab5410e1cc46a690ee03026f6de215ef640600d49af5a3ef682cc0153b8a00e29ebac073a4160eda497a1b5e1092497f06f5d226f6dc04bd28494d09a1f5fd20904fc45924963606bd20338150124503b2adeab0c40055a5dc9a921fa44a8dde40ccc474068410043062b200a93d47d04226a145c04970faaa6fb430403a285be84c74c126d178dae5e80490583faf5f28cfc223bc95299b5690778c7943bc017209750351e71ade030c662d252092f662587afc23dbe1fa7756692f1368a727b1ccfcb7c966e67986170d230d33193e6cc4a2461b0e8f793f153144265ca4245d4b514a12372a023d697d9f3d91709d887b09f66cecf6a4257c5b84e133ccce6b62d329285e3b89f894ff6966414c1ca70eb9e70b2c1a8958696368f3d9f60df6549dda77da1fd9eb84330cbd18be11e14e274f3638e553e595e124e55c35a331589c598266621382941e84cd023d4233fcfe5e7599e371c3fdd62712461920b7bb952fb92903a32408fd7bb4b5e5c1fb29c3782c15a7579b5357c5a5cd4a82f65fbe935d6d17d0eaaedaa70847dafe5d8d8b2f0ca9f39961489681ad6a200d4904003e6584658c2cff7aa5a90e3e452dd06d1a94b4a0a0ad4ad4b52b5b9a04a45121bd5e220cf9b325c990854d9b31625ca948054544b3347e3ad77b55dba9c7b64bb05c3b88cd66a64ca4a04c9892a52e6284b952122aa5cc364a5290e4960c1e3e04ff686bdb1780e7b67f9cf627ecc5c52311d9df80b88d48e68719e498bd386e79f1065f34a4813507fceca7033d07dd25ccb9f365fbc65252831fa5dfb427eda2c3f26f26e28ec0bd9738ce54ee60e7395ab2bed2dccce19c7b1e12958a477b83b2ec5cb2ffbdae52c1c74d967fc94cd125f595847c04f13e66ac7cf5cc98a0e432422812914000d8011fa670ce12fb25c263da0d6a4b5d555e843ad383fe9a4ba4e4bf04b1cb1f4f771b74421dd47bd9acf45fafec344cc334998a54c5ae612b5a9d4a5a81bd636dcc5124f51b9178798a256c0b0058d6b16cb9466b3a68ae82dfce3e0359aad4f10aad49b72319394f0cd30a4b900960c4d6fd6372f0de4d9b711e6796e4d926578fce339cdf30959664d95655845e619a66d8a9cb089386c3c8960ae64d98a504a50804a89003c731f67cecc9cebed53cd1e16e4a7207979c43ccce66f1a63d397e47c31c3d86f7939654a0173f133d444ac361a5025737133d48952d092a528011e917ec87f60df26fd9a796e45cd5e6ba38679d1db27138044ec5f1bfee5fda5c17c999b3503df6078511390356250e65af355213314caf7425a4b9f2ead3ada692bee51271b5f73a27ec42fd9a4c8397b2f843b567b45385f0d9e730d0ac3f12f2dbb3066f2518bc8b831602276171fc6082e9c463124a168cb18ca9240f7dad4e84fd9cccc14896a4fba4a12896812e5225a02112d2900252848a2520000245000236765599cf95dd3314a24bacad7a8b92e5c9ebd6378e0e79c40254c4281621548e0ad56ad4a8e751dca4a52e6bb2a5c90a414b81b1b51e36b6692512d61482d560961734b78fe91b9f1988461644d5ad72d12e4ca54e9d3264c1224c842012b99316a64a10900952944000125a3e363db45fb4b5c27c92c47157662f67e66f95f1df36e4cb9d92f307b4a61a72330e09e5b4def4a9d97f0a4b629c7e612cb899982ff00d9e41004a13d6546563694b112ab3b1fa99ed63f6d6f672f66470ee2782953b29e6ef6adcdf2718ee1be466579a85cbe1344e4be1b32e31c44a24e0242dc2e5e089189c4243a50943cc1e6afdb73b70768eedf3ce1cdb9d7da4f9878fe36e28c6a4e0b24cad03fb3b83f8132e0a2a9394e4395a0fb9c160e5861a500ae614eb9ab98b2571d5ce36e3de2de6071567fc69c6d9fe71c55c55c4f9b4ecef887897883309b9ae799f62f10b2b9d8ac5e26692b9b3564f794a24d00b00236a2a6b825c96b82691ac69c2314dfade668a096598ea252a555c9a6a3e1164b51667756c45431afa116a6509e4690748ddbb91dbcecb9ecfced85db3b89d1c33d9b390bc7fccb98c95e333ec060064fc13914b528a4cfccb3dc599580c34a4905d73670b5013193938fb0cf373a86ac2ad69569495ba5f4a6f1cc1c83ecd7cfced37c7f9672cbb3d72938ff009cbc7f99cc6c3f09f2f786315c4b99ca96080b9f8932505187912dc15cf9ca44b426aa524078fb49ec17fb2e7c9ee065e49c63dbeb9b5279b3c4dfbba31788e46f2471d3f2be03c8e714a55fbbe6fc58b4a2763568274ae5e5d244925240c42d2413f5a3c8de53f213b37f07613975d9ef951c01c99e06c24b4cb5645c0190cbc98e65a3e1999862c0389c62eafef3133165ced1597a4d62c1d8f8e7ec1ffb21fccee30959471976f7e6c607953936225cbc6e23935ca7c4c8e2ae3f0e9d470f98e747560308b0da169c3fef0524d1548fd9bf6897b39bb207b3c7d8ebdb9b03d923909c27c05c40be468c9f38e65ab07fde4e6f71161b119b653231a71fc4988d58cf75351fef30f873270d7ff2847d07651c6b96a5a4fef12d0a49092954c01eedfd6387bb6ce13913c7dd8f7b41f02f3ff993c0dcaae55f3239499e703f1071f71fe792322e1be1e563b03325e17193264d5242ce1f11ee278952f52d5ee98024c44d36d5c36dee78b76065a9339254e000031ee8fa5ba47a85fecc8734386b8cbd92fcbdc83018dc34dcd795bcd9e2ae0ce25c22262153f2f9d8ac5a333c2198905d3efa46242d2ece0168f318e28c0e1787f36cdb27c0e6996f10caca333c465786e20ca8cc5e4b9dcbc3ce5c946370bad2898a933d2813505694ab4cc4ba41a47ec57b0e3dab79e7b37bb4ccac1f1ce371d9af660e77e3309c31cf7e1a4a9535391252a32f2fe2bcb65bb271b962a6152c01fe7e1553e59afbb29eba9151a718a46925e8247aa89cc9328129216082525fbade118cbcfd6929d2b000661bb8f5f746c4ca388722e24ca726cf386f3bcbf88f87788b27c3e7dc3bc459462462f2bcfb2fc64a4cec26330d352e172e6cb5a56083b91711ac230cb5906a05dd4e411e5d239cc8e9bfb477b0e72c7da53d9578e3b39f32e460b039ce290789b943cc1561113f35e5871561a5abfb3f32c3cca2c61e73ab0b8c920e99b879ea704a1047928f68eecffccbecc5ce5e62f2239bdc378be15e62f2c789711c2fc4d9462e52a584ce90aee4f925406b913e59973a54c1dd5cb9a85025e3da26421522a015b0bfd91fd63e5cbf692bd94b85ed69c9cc676c9e4870ea4f693e44f0d1571f64796e18ab13ce5e0bc2bae72929483af33c992f3a51359d85f7c87796806d09385d7426e79c14d4b7c5400daef18c492ee07881b08d471482898a414a90b4a9b42c10a4805988faf94616924288a3907a878c64baf420a052f6ead5882a3eeaede50c12082e4b0a917310022800a9a6ed14b300143e5636bef0439667bd7adae6214b935248ad0fca0d40d5b387ddfd5211c3b82c49fb2598960a68bd2bd274df49a0dbc8463863548720dc187d4a0eff0064d09f5e71d74aa38bc035fc162341493422e287e91c8f90f134ecbe6ca992a7292a96a0a4a92bd24378f9c7112262924312d771422fbc6ab87c4b292ea6abf83eed1f71d9bed2eb7836a615f4551c27169a69db28eaa356506a517947d827b083db5d8eecbfc4983ecd5da1f3fc5e69d9778ef390ac3e2f1f3d58b99c97cd314a095e6b8225d48c0ce569562f0e9eea540ce480a3375fdf666390c95603019c6598ec1e739167997cace321cfb2c9e8c5e599be13112d336462244e41285a16852541492410a04168f161e0dcfe76558cc3e2654e521685858295170c6bf947db5fb027db6595f024ae1bec55da9f8a74727b3ac40cab951c7f9e630ad1ca8c7cf5349c062a7acba32ac44c5e94a89d38498b0fa6495147f4af14e1b0f760ecf54ed5f0651fe515157d4e9e29736b69c639af492df574d2fbe4526f510cafbec7efbefe788d0e78fe196ebe32f2fca5f4fb6c7d7ee25024129537794e266a0c2d71f9f9c6933545482e490f4054cccf503e958dd5c4396e230b8a5a3df226ca9a0623098990b1370f8d94baa264b587052a041d4091f8c6d4f7465a4950282ee922a0c7f38eaf87f769548653cdcf0ea53e5ca2c90a0a3a49015a69a40776fc63294a06a9012122ba80d44bdfcfc2308af4000b241ef32684d01f47c22f13829409282002cc74824f5a5ff9c7895693bdcc8cb973123402e1df48047430163512ff00090ca140e76f9461a09d490561234b3a4922c77fca3325ad25c02496f85668a602beab1c33a6acd94946eee30065ea0c5800400a4817de01582194ca203a40a821bf0f131528b15b9215ba4bb5fd335e002a4a95a877800ca417d25aa3c5ba4612862e6798e4cb94a4a03295eef5a5ca5c1201b3f4fe70ea0402da095247c2417f16fca313595294ad2416058922a5bd7ca2c96480ca0975d00a923c7ee8a02cb80a090c4848722a77f90bc5c85d43a8b26ec1c29fc2282a4a7415107bb450a047488998580482413df51a189bd95859ee6a82601a5540ead292c090487f5e50e8c6cdc04e958bc1cef738bc34e4e2244d001f753124282ab423a8b3131a495eb7214e1e809d206fe8c02b5b292a50555dcbb07f94691aad6fb058ca3cdf3f692fd9cf27b25f6b347680e59f0c7f65720fb57e371bc5d934acb709eef25e0fe2d41f7dc47920d29d12b5ad6ac74996589973a669708537cd54c9650a293424336d1ec19ed01ec41c0fed0cec85cd9ecbdc5a8c26133de21c10e2de4ef15622505cfe08e33cae5cc9994e365a99d28c43ccc14f0182e562940c791cf353973c59ca7e3ee31e5bf1ce4d8cc838c781789319c29c4f9463252a4e232ec7e027af0f899242803dd5cb53122a083bc6138c67cdfc7f17faee126d58e326677201677a17a98818dfa3ff0058b08a80ec7ee115310ee7e51e74d59e482c04906a03dbac4140e5813b96addcc569eb60cf778677362c46f6114bab0092555a3ee375402e49a303d7ad20848eeb33ddcd5a0924aab7dced10acf0041404d0aded46f5fa431096b313702804060524824b1d8d625cd1cd3bcf682030a11a803b9b69eb042684f7bc81606f0e0dae18b0a1061082198a9f539abdde27a2012e1249a51d24071012a76da8683ce01d20dc9276da25c2807487ebb3c15ba00eab788a6f10bd1cff00d51b1b402a2e92a146dad04ddc1150e49a83e512b3b803b3056aad0925a26a090c3722a43110b52428924747f1865543b1a581bc46e9b60048d4492fb02ee3e5114e4396a8676bb56154122a29bb5844a97a9fad843007740482496bd2e69fd608012e28ed4a55bd3420734eb6377fa458e5c105d5e704fc0040043802818fe70ff1694a40a167b13150ef8412e487041b38de2d40ad6eec4b3b45936b0f00c891242d606a249fb01893e51f569ec32fd9ebcbbb77f0648ed67dabf32e25e15ecdabcea7655cbce02e1b98727e2de722f04bd18ec6ab1ea49fdd32b95341c389b2c2a6cf9899a105210a547caae06489d8bc3cb2b5253326a65a9695540510091e40fdd1ed3dd8bf96fc31cadec7dd987973c172c2785f867909c2984cab484033533726c2e2664c56801254b9b3e7294a172a25de2e9a93e57b12b7384f979eca6f662f03f024ae5be47d827b2dcde1c464ff00d873711c4dca8cbf8d38a719248214b9d9ee393373054e56a2af7e2709809a10c1be71fdb15fb2f3ca3ccb96dc71da23d9bdc3389e05e3ae0fc9711c53c47d98e463f139d70df1be0f0724cec67f75266217331187c78952e64c4e0573264b9e53a659412911f66425feec42b77ddff1fac6b580c42664ec329612ad3390342fbc14ea00a541aa0824378c5badd12e573c2e97865c898a4a90a4ae5a8a54149d0a490588524d417a31a821a225641620026c3ebe9e3f487dad5c09c1fcacf69176d5e03e03c3e1305c2bc3fda17885193e1703344ec1e1d389c57ef93654b50a3226e226a748a274e9168fcd7f7ba94428900d6be71e9529c542334f2cda3269266af8699549d2e371d6394782f37c66499a6599e65d88561333ca331939b6598b944266e167e1e6a27c99883b142e5a140ffa638824cc295dc9a331358dcf80c7ae4070a516b0767ade3e9783eae142b2a93d8da94ecf27b38f676e6a8e7f7663ecddcf39537113e67367921c39c678fc4e2d094e27158b9f974a4e3662c2680ae7cb9ca61d6395e5ea96412587c45228f6ab47e627b12388b1d9d7b267b094ccce74c9b3e5727178292b9ab2a5264e1f37c7ca9201e8101207808fd4754b2429ec0387b9763e9ba4654a4a2dc17ab776f65dd845dd1a861d4952828299ae09723cff009c7e127ed2ce6bc6792fb2f317fdcbe2ae20e1ac2665da5384723e3fc270f664bcb70fc6191e3b2ee204ab2bcc8cb654dc21c5c8c0cd5482ad0b5c846b0a01a3f71499fac1969243b01a99cef5fce3f27bdb97cb2e2de6cfb2f79ed9370af0a67fc619e643c75c17c6a9cab8772d999c66383c265d9c1fdfb1aa932c15fb9c3e1e7ce5cc5241d297243391fa2fb9c52a6fb71c22559ae57a9a31f4ad6f4ea463777c62f7bbd9e4ba57924fab5f59e6719ccf5ca52b5809d259980019987ca3657154f18bca3239857a948c1ccc2ece04a9f31207d1a39ab993c313f2d5cc52a42e5bba92ad24050df68e0ace252bfb1327075247bcc5a54f7a6209e9e31fd07dbad0713e17aee21c335f177e44ddefd2a42df59ec6aa8d4a33709a38731d2d4164b0bb9143f28db7884dc3313deab30f946f0ccc00a51077a9eb78d9f8864a988241068cefe71fc83da0a6a9d592478757734c597502127baec19fe83d5e28aea04a7ecf4a8f38be6005408eae6f57da2820bb0a3fc4c6d1f1553768e66bc4ac100f798b5813bbc3294e43e9a0e80379fe90080ecda9800e768601e86c9ab1353fce38de1d9ec660dc693a8b10c92c6084861dea83a851bfa44a380ec2c48727d521dca5c5c1b690e4f9c4a48112ce58804d5830506e8218104966535096703d7e510778821342fa891def0110100b82095077a9fa46b1dc9458906ce0020125c1717fa45b2dc9042424070fb5e2a4877d89a97e916a14a0bb82fdd605c36c0c6cae6c8e53e4e4cf77cd5e5aad83278df2e21883ff008523f383ced595f36f99eb342ae3acc9440f19eabc55ca3483cd3e5d000b9e35cb81bd5b1288b79d89239b7ccb490cdc6f985496ff00a7547ac92fb94d7f59fb28b5fd1f94e1c99a8d091bed4da31540b7cdba9bc65cc6d66bdd377ac62122d567a31a08f06b7accc25eb311dff08904d0900bf8f5891ce5481aafd2086f0e8d00d496dcc1b8b505cbb1820642082c08616b3111d8cecaa49ed09ca601804f174a35b169338fd63ae282ec42416a176ac763bb2883ff00084e53d0578b65b0e9fe44f8f77827fbcf4d7fc643f4a26d46fce979afacdbbccf011cc6e618249ff8f39b333b9ff6d9f1c6138135240480d507528d239439a2c798fcc35017e39cd89703ff0063a7b7af18e2d9e5c80c284a9cdcdbf4f9477f14fe7353f39fd6692c330d418b0002cd0829648805925882a253f08a83f388a50ab8df482480d5b42f7dc948a81a767023c293b2ba3297888a0c971420ee1cc2b9776a7422a61947bac1824b545543c2114033f5a0eaa6fd3ac73b7657321492357c24bb512c3c690b500ed46ea3c7eb1090dde0a04960fb41028492431a90cc7c633bd9d8158045186a25c6e22c6049e829e20c4d41c82c1aa377a4070e5dd9dc1eb15f3005b3806e453a03e106acd463eab100ef39090e376610b4a00524ea276dfa79c5bcc0c4105df5035b3b1880bb021dfc223b54f74593bf5b4404f77bc1d22c0eed788f602500609218d68dd20148706b4ae9297f5fd61b6344bbd0dc08ac1bd5cd81da256d605ae0bb397a970d5fd209274d833d6ae55d2112e4e92c5c6c189a439662280eaa86a0eb1a47390304b81a9828ec911908415100fc29ee8269b45028c424742a21951972b491a94492a141b475d08de4932f04f73224a352d24f7802ccc5c8da39138532efdeb1525251f12c014b88d958491ae6690d675306f38e7ce5370be6bc45c4f91e479360e663736ce333c3e5795e125235ccc4e23133912244b4a772b99325a437f147e9bd83e09578b71ad368a11bf3ce31f9da47a1a6873cd459f7d3fb2e7d90e5f2c7b3773f3b67f1265465677cd6cd25f24b9558a9f2b4cc193652a13f3cc6e1cff0e27319cac328effd8a1a91f49d849fa94a4a086960246ba24fdf6fd238cbb3bf27b2ceca9d917b33f660c9e4a30eae57f2af2d91c469094a1788ce31524627309935af317889f885a8ee6618e4392a034494a93ef14af79354e19c9b0f28dbb73c5a3c6f8eeab59a6fc03972525fd4d24a9d27ed9463de3f194e4fa99d79f34db4b1d3d8b635e958856227a65a4129244b42425d4a351d6a4ede31f87dedc4f6b970c7b3eb9499bf21f9339ee1334ed95cccc87dd2a7e0969c448e426498b42933335c5905bfb4f10825383c3fc492a3394c94242f9efda9fed3ae5e7b2fb9249e289e8c0715f693e63e558991c86e58cf98999230aa4a4ca5f136769ba32fc2294e849ef622684cb433a949f30ce78f3ef8fb9e7cc2e31e6873378b736e32e3ce39cf711c45c55c479c624cfc6e6d8cc4acae64c2f4480e108425928425294800011d7d95ecff000fe1da58f6abb44bef6b3a7a4ffa69af8725f8983dff001935cbeaa95d4231bf7953d55d3c5ff1b9c5fc6dc619c71367f9b67b9de3f1799e679b6613b31c7e3b1d895e2f1b8d9f3e62a6ce9d3a6a8952e64c5a94b52d4492a2498e3d9d38cd24d4956ea348b7173973d65458905c0350630fdc95a98024a8b01d5ec23e5f8c715d6713d5d4d4579b9ca4dbbbcddb2939b936d88990b98b1a43b2aa46f1fa35ece6f66c7691f69273a703ca3e41f0c819760e6ca9fcc1e66e7b869d2f803963805abbd8cccf1291de5e9d46561259f7b39419200750ee57b1efd87fcf9f698f16e138b7349199f2afb2cf0f66e309c6dce9ccb03a179eae5281c4651c2f2561b198dd3dd5cf0f230fa86b515320fa79f65cec9dc81ec5bc93e18e43766ee5f64fcbbe5ef0ce152932f01210bcf38a314523dfe699d63c8f7d8dc74f502a99889ea52aa129d284a109f35c16869a9356ab2e8fe0af17e1e4b77e4b2555e0aeb73abdecdbf657f658f65c72a25f07f2572a99c59cd1cf72c95279a9cfbe2ac149fefc71e62529066a2404ba7019785ea3270320e94a4275ae72f54c577733a016b5cc4cb014e4d9be9f7c6f19caf760a41013e242808db18c47bd5a998a0ba55620d23c0adcce4e737793ddb33b59733dcdab86c604a805af4a9269468d3f993cf2e53f67ee5a713738b9d9cc0e1ce59f2cb83f0871bc43c5dc538e4e032ec2302532650f8e74f984112f0f242a62d45824c7e53fb4ff00daedd953d995938c9f98b9c4ce62f3ef35ca0e6bc31d9e781b3094ae2e3266249c36373fc4b1979460e690e954f067ce4851952940150f3adf68a7b5abb57fb4af985273de75713cae1fe5b70f626627967c8ae0b5cdcb3969cbf90a2c1699054578dc72c01ef731c61993965c23dd4b6969c142351a8c9dafd7c119bcbc1faddeda7fda38e6b76d1c7f12f203b23e3388f92dd93e5ae66539b671266af27e68f3d100942a7e6b390a0bc0e5b30399796ca216b4a9e7ac93ee91f2b8a52d4954c502e4ba5203c762fb3e765ced0bdadb8f70fcb5ece5c9de3fe7271b4d095ccc978138727e7bfd992d674fef19862129f7183901eb3f15325cb1ba847d567638fd91ee6a7141c938abb7173b72ce51e553509c563b953ca0448e36e62283a4ab0d89ce260fecdc22882525528628a54fdd2cf1d55169a8b71a32bbe9d4d5f247667c69e47c399df14e6981c9b87f29ccb3cce333c527099764f946026e679ae613565932e461e5a55326289b250092768fde1ec85fb36bed2fed532728e23ce396796f66fe5be692d13ffbf1da0674fe19c44c91306a1370b90ca44ccca7a9be14fb940760a526e3d157b0dfb2f3b087609c970b86ecdbd9e783b86b8a4613f77ccf9b5c552471ef397881cbcc5e2388718173a48596270f811879018699423f43f33d18b7529d640ef296a2b51eaea352fd63cf9b727632726cf96bec45fb309d803b3061327e21e7460b3eed87cd9c104627159b732e5ab86793b974f4b28ff67f0861a6154f48a8d599e2a78536a1290683f74711c079370870ce5fc15c1991e4bc21c1b95494e1f2ce14e14c9f0fc39c399721218264e0b0e84491403ecbd0924de3b4b3f06812d4ccc525c338dbfac6c0c6e5b3b1f8d9784c3485e2674c3a65ca932fde2a67c8576abf48ad92778a21bb9d39cc30b89ca26ac849410592a05c2a9ebe919187ce262305996678dc5c9cbf29c9b073332cef39ccf172f2cc9725c34a1ae6e23198b9aa4c9932d2904a9731494802f1f9cfed1bf6d87602ec1f2f88383f11c5987ed21da0f2644cc34de4c727b3ac363f2be1ec6252c30dc49c468d785c1290beeccc34933b132f4292a9685347c167b427db23db33da0f9accc97987c652b977c8ec2e2953f873b3d72a66cfe1ae5b65c029e54dcd0057bfce3169007fb5662a98c759952e48514c253bc6fd48f69f571ed12fda25ecd5d9af0dc45c01d96552bb4ff3ca54a998093c5985c62f2fecfbc01890e933b138c4918acf66cb35185c17b9c3129ef630fc07e2a3b5376f6ed5bdb438ba6f14768de74f17f31d689a6664d90e331a72ee0be194b06939664b274e130a84edeee5855492a24927a8cbc5ae7206b512d424d5a30d400019ee4bb8620c51c9c6d9c90b1935a998b54f1df53956e685fa98a11384a524a402478469695104690e2caa8af5fc22c4294e2818aafb9f548d156932fcefa9f74dfb301ed5d5e7c701ecdeed09c4b2e64cc3a66669d93b8cb3ac5018892a5154dcc7813133947bd2d4c7179692e50b38a90fa4c94c7dbcaf08892ee0835490410a04120823f18f122e02e39e24e5e714f0ff001af0867998f0c71670a67186e20e1ae20c9f1070b9a6498ec1cd44fc362b0f305972a6212a0f4a31041223d5b3d8f1ed4ae16f6a07657cbb8d7309980c97b4672a70b83e12ed15c1b875a64a3118d1284bc371465f29dff72cd44b54c207fb99fefa59344954b8dad60e36499facb3129a80970d40378c19b8113c7fbb96a041eecd9626cb58234a90b41a292a04a5493421441a46a400522adf0d2a1de24a2a4929700ddcb38eb58aec42f13cdc3f68f3d90c3b1973a97daab915904f97d97bb4167abc56639360a40561f92bc5f3419b9864ce9034e031cad78cc12943b9ef66c973eed24fcbd19452e14fdd22869f58f6aced27d9f3953dabf919cc7ecefcecc82567fcb8e68f0f4ce1fced024226e6592cc235e0f35cbd6a0f2f19829c25e224cc0c754b6762447920fb453b0a735fd9e5da83981d9cb9a5875e60ae1fc5ff006af02f1d48c1ab0b91f32f87714b52b2acf3024d34ce960266cb04995391365a98a5a212f83d08474254a673476e8f158019573473468c853021d2df475450681ca684312f52d19bbac011ee28069ad19eb000649735b81716a9834bb05021892d481671b79d47afce2af0f2021fe2771bed1613de014ec4bb5898ac5cd09dd8300f01dc92439362ff000b1ebead129d902e0a25dcfc34dc0317a269490e490d6218784630219254cf60045ba8b01a5dbc408eca155a69a256e6e6c0e3952d9956af9794726f0771863b27ccb0d88913d49d2b0aa1a01e568e1295374a86c36720111b872ec5144c4a9459cbb0351e51fa1f647b55c4781f13a1aed056953a94e4a49a7669a69df075d0ad3a72528bcad8f432f6037b63387b8ef25e1bec57dadb8b132a62fdd64fc80e6ae778bd432c98a0112f86b37c4ad5496a3a46127cc3a43992a21e593f551c5dc393f21c74dc1e225b4c94c52b482513525d9493bbb478d772e798d8de15c76171983c54d90b90b1312b9534cb582082e08a82e36b47a05fb0efdb3795f6a7e19e13ec71da7b89528e7064d82464dc94e6ae758b49573070f250d2721cd67a8ea3984a4274c89ca27f79420249f7a9ff0033fa43b5fd9de15ee8dc2e7ee85d8d8db5f0839f12d1c52cf2abcb5da78ae8fd6d5528ddacd78e3bcb7b9569c75f4fdf147f0897a715d7f297ed2f97c4fa0098a503a4d4b1efe972cd16495292ee40400490d41b9fc291afe7192e272fc64dc262652a4e2242ccb5a54905cb0af8823ee31b716532a614b825887d2c935e9e7eb68fe6cd668545de9bbc7a33c59c1ae865a7bc34a8252348297aa89a9854ad69625981649d2eef5b3c552c82820a925c0049661768799dd4aaa75a485020a7bb6f9eff007c787528a5ba312e0b0ad69604d1c976606135100dc0531219890ec6bd6a23182d40b171a8b829d25eaf527eae63213d287ba014b823727f1bc71ce958a4960c8967e34d007d5a7e2276a078b3504941d4c599f4103ca3192b014a72826e0b36dd7afd60fbcd5ab50604384d19defe7e11cb3a7cb933db0cb428a8b6801247c255a897dfc3f94542690b482349ab2756aa3de2b512a583ad2002520a0b2816b3c062005a8a5d25f6d7d1879c664abf5330281ab04849aa89a2fa7aac64029243b10c1833027ebf48c00b41526a1d9b4a8864f945c8980832cf734dd4e1fe5018b79998a9fee80521452a4970520a552c8a8208370cff0028f85cfda98f670e2720e38c8bda35ca6c965a783b9998bc3f01f690c9f2dc2142385f8b254ad195f11a9290c30f9c61d0254d59609c4e093733498fb9698a96a1a50a482e4e937574dbf1eb1c5dce4e45f2efb4a727b99bc82e6ce5f2b30e5d738783b17c15c4f2d52d1326e5e99e97c266323503a67e0b10256225ac0a2a5f4262935171c91e678c3cf95a17a0802ad5178c552027c4ec5db4c770fb72764fe61f626ed3bcddecd3cd0ca71182e25e56f154eca24e3e6c8548c2f14e5937fda328ceb06a219787c7e12648c421692402b5a1f5214074f94c525c035b0bc73558c5abc496b1729342c7ab82cf0e09626849146dda22980b107605ab0010c598599c3931c9b15002f4ab5ad53d61c6ec9a5b533405350049048a116304a404dc100b972e60b19042cad2120d589d9e1fbb50d6bd1cc2065148fb23ab30f5f941f84f754f4ef00588f9c4db7680753ab512085180755c302cde3008f0009258122b0da7bac033070abd6b04afb813bbbb39a106fe10e2a9205024d0dcc54a0cc077b634f5e70c94922f62e5cb7ada16b640485000837a117fba03bb9623c488b0b1342283506229f280a14bd555dab4105bdc0031afc4e18518c05060c52c474a3fce0e90e09003d0b354c36c68ee1ea417f55897768159d29ab1701a81c08576a0206cda62d0aba58000336f034073b066049f1fe5119b204d240bb36f561e0618392ea21c74a4282406d249b97348214c924867f8430ac4db1803310e7bc492e1c301fce1d3f10e9e54b8da1351a3d5d377a0f0821e8a480d636825760d4a4cc4a549510e00f84d2eef1e93bfb39beda2e4cf684ece7cbdec5bcf6e33c9b803b4cf2472495c13c0abe29cca56579473b38770cc8cb1797e2a6a928399e110461e76116ad7352897325eb75a51e6ac14000492db28fd47af18b30f8dc560f1787c5e171188c2e230b344f913f0b39587c44a5258a5485a485023620821af1769daeb707b9de230f8c9f3c01859e8254e94994a0f5a69ebf28fcd8f69a7b4cf90decbde47f10f3379a39fe5599f3631390e20f26391d84cca5a78bf9879c996a4600ce90352f0d974a9e65ccc4e2e62584b96b090a51098f306e02f6bafb4cf969c2a382b81fb7876a8c8385d809594a39cb9be6230204b4494cbc2cec44d993a4202108484495a1234860f58e90730b999c7bcd9e26c7f18f32f8df8bf985c599acd562333e27e36e25c6715f10e60b352b9d8cc54c993965ff8951b284dd93459464c1cd1e64f15737f989c71cd0e35c6a730e2de60f17663c6fc4d8e94954a958ac7e698b9b8dc529082a2528f793d610973a53a43968d800d88b9defbc3e84b9585066daca832d01566aede3e31bd3a4d24ae5d2b2b5cc8927bc1c12058005a374e0b0dfbc4b59091ab4f74355e96fca36cca9447830777bf8c77ebd9afd9973fed93db77b33f66bc8703371a9e63f343032b89a6a257bc959470fe5aa39af116613a8c25e1f2ec1632617b9000aa808f7b87f24335f6354d24ee7a8cfb33f93f8ae47fb3d7b13f2e31b97cdcbb30c83b3ae418bcd7073a799f32562734c3ff006ace254ff68e2ddb6d40477de499219e5a03060c97ab44c727269230f97641879581c9327c2c8c9b24c249011230983c1c9461b0b290364a65cb4a436c23124ac8057a9c25541f46611e8507cf04e4b3f6e4d636e54ac6aca92955924103bb461f8c6a59362e665d327fbb4ba67a0cac44b9880b953d0410a4ad2684104820d0831a5499dacbd5276a87356a79c6a127bba893dd2038a53d758ea834e2e13574cbacab33e7dbda9bec09e5976afc978879cdd9172ac9395fcf4289b99f1272b905396f2db9ad3082b5cdc12689caf33517ff00325b61e7961325a144cd3e7bbda67933cc6ecffc6f99728b9a9c1f9e701f1ef036638ccab88f85b88702ac066d95cd5620cd97ef106852b96b973113124a5685a5492a0418f651c8710a566b82c2a66681366a4121a81c3fd2b58f256f6b9768097da5bb7cf6b6e6c48c66231b95f1073c33ccbb86e6e2e709f365e5394e24e5195cb0a0ec94e1b03242402c03347f417657b65da2ed1f63b8af06ed15455a8e8e951542bceeebc3bcabe85073bfdf29f2d3a928f3de50505152e54a2bba1a9ad3877751dd2586f75e573f247329c1c9241ad1207e3f7c6d5c412a2e020d2a0d4f846bf9aa9026a851ec430ac6dc59008259f5393668fe71e3755d4af2e66797379b18330b10d42db8a5e29539ba892eef17cd56a5bb82cd504327c1b68a14350ba7ab0178f91ab64ce693ea85205aa43d5ae2159c2986902a41bfade0b077d4ce2b5723c20b864b3d4392ee7c238dbb36ca1054816a5880937bc100b24a685fade02525401208028c58b6f0402a2000497aaae053a7cafe11365d00c1f490c0002e2df8c10da5c00c6d4a8ac02cc438553bcc002fe513ba017f02c0f58ba6d6c077054e0693b5e9d62e96c0b94bbf8b11eab1424a4820b964d2d1912807492028a7a311b7f28dd1ac5bea72af2792fcd5e5b2507483c6d971701c8ff6a47e90dcf1d3fe2ef338555ff1e3310cfd272a0726c94f35b96d467e36cbaa40ff00d894d6273be9cdee6712c5b8ef32a16ffc7abd7ce3d7497dc872feb3f6117bb51b1c393039ad816ead186ae9f933c654ca95bb024d3c23149abeef5ad23e7ebfac632dd8a3c9e24489181526f4f9341d47f51b40864b528e49fa42d7064cb0078b55ea1be51d93eca4e3b427294aabff001ba5b01bff0091888eb74a0c1458287d047643b291d5da1394d56238b504035008c3e21bf08f7781affc4b4c9fe321fa5137d3afbec5f9afacdafcd22a1cc7e62020b7f7eb3601812298e9f1c613dc248377269b4727f34f50e64f318007fefeb37bd9ff007e9f1c613410349a97767620f48efe2cada99ae9cd2fad979659a7bb81a817dfa0e8d04fc340a054c3bc081d624c0de4eecccdf378adaadd6a906d1e14ad6f2309dae290c3538000667607ca014b3b177a904d2b05c17a14ee010e3c21096ddf551807a472cb6bb2856ba1525dd857704f4785142492406342f5da1890752417091422a3ca0817243a9806bb455f8814b300ecff0008dc18961562a4ddea0f8c0d0aab5cd48e9103f792c016a9f88456eba818026ae1b4d6aff7c2ddca8b97648bd209090039670f7780e1814b906e48b45b17b0210aba8a41f1046f0e0b9ddb551af685000abbeceee6fd2086a07f100529bc4260357000506a3bc42051cd016ada140ef31b2a81cd9a233000972937688cb5703a477892493b3b82296885c2aae08501a4b8f5bc00c41353ba9cd41fac390054357a9ef6d1bd34b160302e5d8ea1429adabf74654a0ad0f604b915f08c60c093726a0bd5beb1a86151a94120d00bb3811e869a1cd24ba9b412c266eac924fbd9c90598a83243bf947d227ecedf646c3f694f68df270e7796ab17c0bc97c362b9f5c753a6492bc14bc370f19272d91354469ff3f34c565a341aa91227358b7ced70b60153f1d879694baa62c24009767219e3d1b7f662fb30cee4cf629e77f69bce70d2e4f137687e2ec372f783a6cd9013894645c3c310898b96a35027633158e596a118797760dfd05d8c83e05d95e27da56b96a420a8d17b3eff0051f7b8b8bf8d4e0e75bffd67ada78f77a69d6ebb2f6bfb167e43e83f8af35fedce20cc731492a44fc52a78009ee27e1969f2094868e9e76c7eda3ca4f67ff67ee28ed25ce75a33597815ab25e5672d70f8c4e173de6d7112d2a385cbb0c0d51879647bcc56258a654a96b25ce94abb05c7fc79cb9e40f2bb8ef9f7cf4e2397c23ca3e5b64f333ae26cde600ac5e60509ff00272fc04b247bec56214132912c1aa9690e1dc7987fb56bda5bcd1f68d7683ce398fc4817c2bcb7e1d5cfe1fe4e72b3078d54fc9797b91a66112659344cdc76212944dc5e2b48d7354529099694247ce703ecfe9b532abc678b27f7374ed45e6ceb4d24d508359dacea497e0e0d654a50be0a9a9a7397a8b17fd4bcfea3ae9db87b65f37bb6e73eb8ef9f9ce5e225679c57c5f8ed52b0b8798a464bc318094549c1651964927fcac26165912d081f11d4b53a944c74371730aa692092092e1897b5a33b178a528a86af12ab3c6988d53660484920d09164f9c78bda8ed156e355fbdae942314a318c55a308ac46114b0a31584918d59f374b2f02808986c090ec19cc7d447b08fd811c53dbdf35c93b4c769fc2675cbfec779066c99b93e04a5795715f682c4e196153303949500a9595a549d189cc40eff7e5c925414b47657d853fb3b98fed0b27867b6076ede13cc786f90328cace794fc94cde5cccab8939e2b4ab5cbcc334925a6e1323040290a69b8dab04ca65ccfbd1cab2ccbf86f2fcb321e1bca72ce1fe1be1ecb64e4b9070f645809794e4590e0f0e812f0f84c1e165812e54a968484a50800308f919d7742ea84bd2b6fe1fbfeaf6985de52392f82f979c03cb3e08e13e00e59f0ae45c11c03c1b92c9c8384b84b867012f2bc8f22c1c84844b9122420048019c9f894a254492498d6e74c5225ad25c3066afd4c6c0c1f13270f3061f1138a2529542a55127c2bf746dfe7473d793bd9df957c57ce8e79f30320e5c72cf83b2f398f10715710e2bdc60e42402532e4a003327ce98da65c894954c98a2025263cc73a8bd66ddfe56dbfadb2ae565be4deb8fc525299ab7421326599d3274e98254a94848752e62cb04a400e4a880002e63e3cfdaff00fb4cdc25c8ec7717f668f67c6699073039b382f7fc3fc71da4c7bbcef80b97d8b4ea9788c270aca6549cc71b24852558e56ac2ca5a4896272838fc67f6cafed15735fb71cfe29e4376561c4dc8fec9467cdcab1d982b17fd97cd6e77c949285cfced72564603013aa51964998b2a41067cc5289948f9b1e5972df8df9c5cc4e0ae5672e387f1bc4bc73cc1e24c2708f08f0fe5d28ccc566d8fc6cd12644942439f895a946c94a54a340626a42de9568d92f1ea1a6d7a4ac8ec7f2d7955da6fda0bda2f0dc21c0f96f1d7680ed09ce5e25998fc7e3b1b8c9b9d67d9d62a7a82b1799e6d98ce3a64e1e503ae6e2b10b4ca94848a801298fb67ec79fb261d99f9539270af1576d2e3ae20e7e73191225e61c45cb6e05cc66707f27b2dc428052b0271c809cc71e8964942a70561c4c21d2948a47ed3fb1f3d94dca9f65ef67dcb786f0397653c49da338f329c3e61cf6e6eab0889d9a6638c521330e4796cf3de93966096a32d1290def96954d5b92909fd56cd93f10625b723f38c759acf7c72c2314a28aca77c256475a3925c91e527673e06c372cf90fcade03e4d72f70612470972e78670fc3194e316948489d8e32d226e3271006a9f8b5cc98a352a24931cc4899a994eee58bb9018da32674a0a0b60e48a060ff38d127cc326704124a94ad0948177f08e033390329c50016012e9673522359fded2a584804955020392a2db0178fce6ed93ed2aec61ecf6e13999ff0069de7165bc359dab0a7159472b385a5cbe2de70714109d499582c8a5cc4aa585b869d8d5e1e48d40aa6011f0e3ed0bfda9ded69da47119bf02f647c9e77645e4d6244ec00cef2ecde571173db8ab0ea0a9626e3b3812d3232ef78924feed97a1d1aca4e266901504efb12937b1f701ed02f6bd7616f66ff0f2a5f3e79a1273de6ae3b04bc470d720b967eef8b39ab9d109742f198742848caf0c4803f79cce6480a015eed33543447c01fb493f68f3b69f6d84f1172eb961994cecb3c81cdfdf60717c1dcb1ce27c9e3de2ec1aca9264e7dc483462172d6860bc3613dcc953ac282d25a3e7d788f8bf8878b338cc78838973cce388b3ecdb14bc766d9f67998cdcd739cd272cea5cdc46266a95326ad45c952d44c6d89938a94a3b96a937f389e48c15e59659a8adf2664fc74d9a7bca2ca05cd4053d493e7b98c05cc04f5d8924dbd7e318ca582482092453603e504a80aa883a5a97319ca7cd87b156db2294a0c7bdd035879c2f573415245be51029c1a877a0f5b407b856f4a0678a63620297aa58849f86a695874ad98328916ac54cccc4568c28d05c0bdc9607f38259067ca98154d4e1342457a47e8a7b323da0fcc9f67176ade05ed01c108c4e77c3d227a786f9adc028c499182e62f0be2a6a3fb4b2d989709f7c129f7d8698aff773e54b340f1f9c214425891d43062d1972944949d5a4382e28555eb1a277766593e87b6772579b7cb4e7ff002a38039dfc9ae28c3718f2b39a7c2d84e32e09e21c2a8954fc262e52661c3e2259ef4ac4e19657879f25612b973252d2a00868e459cb00a8a6bd5aa4f58f3e3fd995f6b8607b3e7318f610ed0bc549cb3923cebcf44de4d7186718c5272ce57f1a62548972f05895a8e99597e705a4a94084cac5194a21a628a7d040957bc5c99c8289d266944d4d0e921b77af57b3111394ecc869a3213312a05d4c543c5c7947e33fb6bbd95391fb4cbb2f63f09c1d81caf03da979379663b89b909c418b5fee89e24225ab118ce10c64f62d2731d0461d4ba4ac5196689528c7ec97fbb66d2c14d54824c5d2a68424315057c4140d5c5411d2c08f2867a107886715f0c710707710e73c2fc5192e61c3dc45c3d9ae2324cef25cd70eac2e6794e330b3552713869f2940144c97310b4a92450a4c6d7585249b54d09e91f721fb50dec9b9d2e7627da4dd9f786153b2dc7e325653dac785f27c2200c931733fcbcbb8d65494007dc624a5386c72803a2719330b05a8c7c3dcd96b96a295a588bd3ef84a3cd1badc9bdd1804289d2a0c46e1d88da14d4b59b7248da2e525b512496b6fbc54a01895023a03bc679b9023120baad4290ee603bb87af8bb8f548600005dc96eb51e70a475a39aefd6280248600df73f9887770028abc40262ba3b50801b50a41019ba8269b9f18bae659064254e19833b300c4748cbc3ce524326841f331829a8ef6e5e97bc5a0a4177a2767a98f434f56519264a6ef7ea6eec1660b400ca20bb10e68cd6f28ec772779899cf06e7f95e73956658ccbf1b96e3a4e3f038ec1625785c5e0a7495a66ca9d266a48521685a12a4ad241494822b1d5492b6292e6ec59bea2376e5599af0cb494ac8653f74b3c7eb9ee77db5e25d95e39a7e33a0ace15a9b4d35f53f27d57547a5a4d4ce8cd5583b35d4f515f6367b5eb84bb79703647d9cf9f99e65793f6a1e19c8d32b8338bf173918491ce9c1e16580b4cd7608cd64a43cd9629884833500282d31fb159f64d8bcb715365cf92a9388c3cc32d72d4194920edeade11e40fc96e78f1572d78ab87f8af8573eccf20cf787b34919ce4d9d6518d5e0733ca715875a6649c461a6a485226214010474e8488f49ff6447b57f84bda4fcb0c0f2c79959be5194f6bee01c902b34929f7780c2738f2cc32120e718197409c5cb007ef7864064a87bc48085b23f63eddf64b81f68785d4f746ec05154f4beb6bb471cfbd66f7d4508ffe52a4b3520bf9bcdde36a2ed4fd0d4538ea20f53a756f8d1f0f35e4faae9ecdbf4cd880a25b4b396277f4df38b87781649054dde20d7c7c7c3e719d9ae5b3f2f9f3a4cd96a97312ad2b4293a54923c1fee8d365a542f7360cee1bcfce3f9f757a2717cdd0f2e7192e858a3a802352813a4b8200637f5787764b07750a9ab87885282431505949622c3c7d748c2514a54935728d2a0ee955fc6fe3d23c5a9496c8c2dd4cd2a4d8b3062e145401a7df054a5925414e29f05549f3f18c413dd83545b4a057ac305109201ffb3400b9b3bef78e0a949f529257c9901603eb51208d29677591bc52a51677a3bead4cede1e9a10ac31504b17a8501416eb18d3281824e905c1ba9fca38e7071666ee9962a7151d5a8809f8aa5c79c64489ab533390da524025403bfe7f48d31246b4b90e535a770783ef19f2e6b10ccc0d3486d514f6832d0a054493dd0199d4493f837f28ce4a94843242964a3be6ac3a08d2c4da104ea2154a31f2f3fd235096a484b859ef258f758f461109598c1f30dfb4cfeceb99da5fb36e03b66f2ef22fdfb9c7d96b22196731865f8233736e2de5fae7ad667ce08495cd5e493a6ae6025ca30d3a6d8263ceeb178454998a492192748370475f28f6c9c0e5f9762118bc1e6d9760b38ca734c1cfcab3ac9734909c565b9de0b152d5231583c54a53a572e74b5ae5a926e151e5b9edcaf66f4ff0067676cde2ae10e10cb7183b3e73484de66767fccd692b9586c9719354a9d91cc9bbcecaa7a978520973284825dc98c9a8a6d3d89c5eccfc4a5821ed40cef78ac84b54107715da328cbd458d007222b280093a6a4d4dc7847354a32596434d6194f78b0b38f9f8fe11149140e2ce456b109d20b807a306682349a922ee4bb748c12e8c8101a1001bd4824c58000685a95b9a3456482f47a866fce210c411461524d0ed12a3d40c6e4a4beec76aff4864390d5ef1ab4014d4a0e92ab78c3243a6dbf95a2dc97ea09a490ccc3e0b1f3ac4d241704809a31a1f4f0e03962c01bf85af0da7a97ad1c56fe71654b20a98b06a387a8bbc1e9b7768f57b438960b36db18850e1c01d09db68bf74ee4d988c410ca0583d4161043387deac4d416de2c29046a676df4d2148342902ccd7668954fc49516c0df150f745767301897721c1e84fd22c400a6607c7c618ca247426841fb9ab12a9e2c89e4652d70a069ff00a5d2014b52aeaea4de2d28500e412e34a40a9f388252bbac1cb561ddbb8707b1480a091521ea5a1bbc1880c901eb6f9c647b93a5d8804b97fd22194e2e2fbd18ed1a774ed7489e431ddaa5c05537a186046addec098b8cb48d29d8fc44070207b97600294d60d43168d269ec146db88c01042995700d0183de48ef00a2f60ef0feeec9a020b5aa5e322548243001d9dfafafd634a74a7295ac696f02b4a54ee28e3e172e2b68c99728aeaa3b87dbca32118748625c326e2f19b26415b001dd42c3eff3f08f52868db6ae5945b2fc16152b524170096ef12447a067ecb8fb36730e47727b8bbda07ccfe1f5e5dc7fcfec86772ff90b85ccf0c6563b22e0e188973335cf252541d0acd71187952652c313230aa23bb3140fe177b073d8a5c41dbe398f95f681ed0591e6d91f62ae5ae783139ccd98999976339ef99e156148e1aca26514707a93fedf8c965912c19482262f54bf49709cbf0195e4f9164394659c3bc39c399561f20e1be1cc9b0a9c0e539060307291230983c2c9480944a952d08425290000911eca8c5c234e947f39bf0e8be5ebe5ed26ca76496118d2a699494249d200620393e7ebac66a6705b32aa535dc1e83f18d214852d44a75b11de26a37da2d09f7284acba6967a1b5e355464e4adb9a64d550bc47bed3210b9caf7666a824e9d29482a5a94a3401201249a00234bc6f377937c2b242f8df9c9ca1e0e2404b713f34f20c9168d4fa5d33b16935ab52ad1f833fb431ed014764eec598ce4672f33d196f3e7b5ce1713c13869f83c41939bf06f04a3b9c4799a0a4ea97331a950cb64aa94c56214082811e72b89cd4c99a7584ad65202a64eff36616767528924f9c7dcf04ecbd0e23c3d6b78956951839351e58a93928e1caee4925cd74972bbd9bdac5e309548dd63a1eb57db03b627267939d947b4cf38b81f9cdca5e36ce797bc94cf737ca32be12e66e4bc4798af1b3f04bc160489185c54c9ac27e2a4a8103ecc79167146793f1d8bc46227cc54c9d889cbc44e5824952e62d4b985cf552947ad63742332127038fc715994ac524e57874a3b9ef7500b9c4806a129d09aef33c2389f379ae54524149350eda7ef8f738c2d3f66bb3ef8670ed44aa2ad35526e4a31768c7969c6d16f0b9aa4af8f5fc8d1c654a1e93bbff00e0db78d9bad7a9ddcd4b3d23469ca04a9249a592413b7aac66cf980158a96f96d1a3cc515126809dddfd7f28fc23886a5d49377dce293bb1497b7789a1630353bd08219347b6f0129a86bb50dc5fa7d61424bb6ad55ab8611e34df46612b00822a086b12e4c0094a4b050721cbb923ce038d5a6e6ec3ecc380900b001fe27147118377592a44bd4a6b4670497eb0c090fd030abbb42a4b30147a8037e906a4934041fb2031f38879030a12cd7bb50d8c3259be1505541ff5126f0ac157ad681ade42192956aef1662e7a08d22ae07487d46ce1c69ba632529005e8c3bb5707c62a48482f7a39243834f38ba5000fcdc97a8f946ebc0dd781ca7c971af9b9cb14395bf1ce5a097a0ff69451feb191cf8011ce6e69b24f738f7324b0abff009ea0628e4d28279b5cb2982851c779606ffe8a97ebe71673e095739f9aaa0481fdff00cccd2dff00385c7b0b1c22dfd67ec22d7f43e5385e6509d4c055c5411188b0ecd56f38c89dde3601c9a18c7580377e8d68f9eaf7e6673cb72b89122460406e6bb9a9828b8fa42c3a5d8daf7312b7065a58a4876e805551d8beca6b09ed07ca7557fefb65b9201ffa0c40fce3ae326a0b9b82ff0048ec6f6574ff00ea82e5302e757174a600587b99f1eef045ff0088e9edf8c87e9237a18a917e6beb36ef3414fcc9e62d1cff007eb3737aff00cf67c717cf34724020d1fd5a393f9a03fe52398a90effdfbcdd2ff00c3fedd3ff18e309f5008b01a4925943c7f58eee298d4ceff0019fd6cbcad7c181315de21837d1e2aa03e152e61d4a72a2a670001a6f42cf08f40926dde73416358f0e57ea64d66c2ba42b760e407a4292080748146575517de0aca98a4b07b0153b562b7722b60ef5af58e696d932616600867218bd84106841146b8115124166557721a1944ea0c1542010ee078f9c677c023a5cb8228c9036f380fbba6c198b0f9c4d4c54cc124b101c93e300860d604b1276304d74042010a274b916b00d04b91a598100306f5fd62300058b0bd943e510160c4f550156022165e1021293dd0cf60407ac374259ec2b405b6fbe277b60c2f6bd60177b027ab985da04018106ac6a760febee86a9602ad515af8c070e4692ff15a83c441734214525c92366f1894bc40b40a7a31d921883e505c6b6a3350121cff0028892a51662d6abfdf11882f47eb5adbf9469005c8043541fb25a840f38d570ac16025dae48b88d290198bdfbd68ce90b69808243d0bded4711e9e924a3515cda2ee8ec5f26b2dc6673c5991e519660a6e619ae6999c8cab29c0c99666cfc6e2f13391230b25090092a993664b4048a92a11eba1c9de11e11ec8fd95f90fc87cc71f95f0c70cf67de4be131dccce23c6ce461328ca3132b029c6e7f98e2e6964a52859c42f51dd6d1e781fb379d94a576a9f69b72524e778018ce05e447bfed17c70a9c9ff006550e1754b9f9261e6295dc1ef737999512957c52f0f3ae018fd08fda1df6cb7f8c9c43c6dd88fb30717226f27b2ae27988e7f732f87f187fe59f37c14fd4324c262506b926027a06a4a0e9c5cf90851744a43fef9a7e21a5d7767743d9eab2e5a549cf535a4b64e4bb9a5e4e718f7dcb1ddb9c5bb4549af55555ddc68db6bbf95e2ff0031d6df6e7fb6cb36edf3c6f87e48f256763385fb26f2b730992b8572b4ace1b1dccbcc25a952e6711e6c906bac38c2e1cb8932d4a5979935447cd6e659809c57a6aea767a5e34bc6638cc5294492545c972e634733895f7d4123650ac7ce71fed6c35942870ad15354b454172d2a6be0a6eee527bcaa4e4dcaa4de6526fa592c6a56728469ed15b2fe3abeacd4b0b839f9ae36460b09869d8ac662e7a70d84c2e1e599f889f32628225cb44b482a5294a525290012490054c7dd6fb0ff00f66e3fb024f04f6c8f680707ab1d990f73c47c9becb399e0bde9f7842676173be359645132dd1324654c3bccac41200943e4fbb0776d2e10ec3dc6b8ae7664fd9df977ce9e7ef0fe364e27941c53ce4c46273ae00e544e4214179b49e1d94509c6e641447b89f889ba70df1211ef1969e7eed5bedd6f6a176b1c263f24e3fed63cc0e16e0ac7cc9cbc472ff9313e5f26f853112a7a744c918a4e5499388c64a23ec63674eb93724c7c26a5aad479938d93be5ddbf24beb6dfb0e593935789e9e7cf1eda1d917b2ee593e6f688ed37c94e51af2ec08988e1bcef8d70078964484828969c3e478652f17a191a109449d34003347e05f683fdab7f67ff2b0e3b2ce47f02738bb4b67b254a44ac5c8c2c8e54f044d5a42be2c763113714a4150480a9586b1241a479c3cfcef15889f33118ac4623138c984aa662b173d78ac5acb924aa62c95135352634c998d52944fbc56a5871b7998f26a3a36e69bdfa6df57da65959933e9dbb557ed52fb4439c73f179672332de51f648e179936609388e5e70b0e60732a74858294cbc4e7f9dfef2942d2082276030d8453870d68fc42ed15ed05ed9bdad727c87877b4a7698e71f3af20e19c42f1790e49cc0e309f9b64f964e99f14f9785a4a3308007bc5a4a800002008e9cccc52d7425c07d4a14262a4a54b241d8509d9eb1c92d4ca1539b4f8b15e7b3ba359c3e38ad40288209652498fb5ff00d90bec1590f3079b9cdbede7c79932730c172530e3961c924e3b0fab0587e24cda47bdcdf37964d0cdc1600feef2cb3a17981502e047c47e1a58fdef0f52506600b25d80258c7aaf7ece57001e4cfb283b37946066e5d98f34e7e79cd8cdfdea74ab16733cd26c9c34c141ddfddf072b4bbef58ceaeaead787772df190e6dc6ccfa179980972810803f58d2b1b834a924306b32afebce30f0fc4289a5254a62a6705543fcff58d664e3246281495778fc209627cdfd52395bbee532ce09e67731380b93dc0fc69cd0e68714e4bc0bcb8e5ee413f8a38db8c7887168c164dc3f80c3a0aa64d9b309aa95444b94975cd5ad284824811f00ded24fdaa1e7bf34b32e2de567604c8f0bc80e5a8c6ceca91cf9cd30e33be7c7186152552ccdcb9339f0791c99c095032254cc6242504626592a4c76d7f6bfbb6671260b3ee4cf60de0dcfa665dc24bc8e4f3cb9c780cb73132d7c478e9b3a6c8e1dc06612d0a7549c2a24cec5a654cee99ab94bd24a1247c2b6226a7bc02994ec6b5317a74f9e0e72dba17845bf499b9f8e7987c6bcc5e22cd78c38f78af8838c78af3dc52f199cf12f13e713f3dcef369ab5152e64fc54e52a62c924dcef1b18cd6aa684516e5cc45aae141d92efd2f18fa9401569093a6958ce72b3b1572be3a07516a93d686d1585518bb13437062120dc7e2e0c00a0295db4fd6ed18b777e454651d45928b0b8a74b4417213f16e0d0400b61f13eda5cb5778651629d2f5f89b688dd640a5360c49dfc21cb174a83106b5b5214289760037ded7804820b067a8a9783b01884904805cd120d5ab0ae5445c102ae6bd1e189b05175020f81ac42e59567fb35687540292a5302080ce154119085b351db63b4633962f624877f28749b5cf420c4c7c41ade0b31c56027c8c56127cdc34fc3cd4cf933e4acca9d2968214952542a08500411504031e9d5fb3d3ed51cbfb7d766c91c98e6c713489fdacfb39f0e48cb38965e6389969cd39b5c2723dde1b2ee26909bcec4615e5e131da4385193315498e7cc090b048249213600924c76e3b1576b5e67f625ed1dcafed23ca3cc5781e30e5be7e8cc13835cc29c0711e026ff95996538c165e1b1b8754c9331269de4aae9491aaf495d3c965777f13d9566b31d243920d2e37a98a13a92eee1c3d4824475a3b2276aee56f6d4ece7caded39c9fcca463782f99b92fbf9f9609e99b99704e7386225671c3d98a013eef1381c40520a4fc72d529628b063b35316909059c94fd3f482c22a6dde28e1be1ee33c833ee0fe30c872fe29e10e2bc9713c37c59c359be1938ccab8832ec6ca548c561311294085226214a15b1622a04795afb6afd97bc51ecd2ed579cf0be5782cc31fd9ef9a6713c71d9eb8d2661d67098eca9738fef191cf9b548c7654b5a644d964baa59933006596f56797884ea70e4a6e0821a3a25ed28f67f72ffda53d95f8cbb3df19cbc160789c05f1572678d71529f13cbde2a912548c1e29130779387c506c2e2a58eeae52c1209425a6f677b13b3b9e3c731f5283166b121af08a00a492c2bd185a39d79c9d9ef9b1c8de6af30b933cc4e07e23c8b981cb2e2ec6f05f18e438aca31271796e3f013d5227240d0ea96bd299b2a68eecc95365ad24a540c71b8e05e3298a3a78538994366e1fc616f9fbb8aca31bdd7522c6ce21925203826a45e0b283300cee0131bf13cb5e3c5d53c1dc56b17ff2f8731cb29b30a4a8bffc2de615c703f1893d470ae6047fef188514b762c71d292e43172a22d407cbeb0348a80c58df78e423caee62a980e05e34240fb3c2798bff00ef18cb97ca2e662d95fe1e71db1a850e0fcccbff00f50884b39071b3005218bb59dc11ebf086343bf81bfce390a772b398787713f8178ca555c7bde16c7a08fac98c7ff0db8f15a8ff007378ac902c78731c156ffc9475416158b24f18367216536f3a33467cb9853a540daaa7343e2d1ad1e04e3192b526670bf11c96f8bdee458b966fe32e126f07f1548405ab8773d29162328c5102fbe88f5b4b3ab05ce93f98d23846765d9a2e494b2802f707ef11dafece7da33981c88e63f09f31f977c579cf08717708677233ce1ee24c8b18ac166b9362a42c2a5ce92b14ea952160a26254a42d2a4a8a4f5070f946752c2cccca7339425833166665d3d2252521d44ba68000e49602356cb718844c4b382555605cd6f1fae760fb75c5fb2bc4a8711d054e571c38cb31945e2519c5dd4a3257528b4d34da68ebd3ea274a6a5167acd7b2bbda5dcbaf6a5726948c7ccc9785fb5372e722933b99bc0f859a9c248e2fc324264ff78b27904951c3cd985226cb4bfeef367042bbaa964f7d71b8099829f324cc4ac31294eb1a4a08a11eb78f26aec71daeb9a5d9379c5c05ce5e54f13e3f86f8c7817394e6994663849aa095a54932f1384c44b769d85c4ca2b933f0eb74cc42c821c023d3d7d9ff00ed01e4cfb4df9127991c0f3b2fe1de73707e0f0f239d1ca61880732c8711311fe5e6d80413aa7e5d8b285997392fa5685cb5e95a0bfe89dbbec5f0b7c3976f7b170bf06a8e2ab515772e1f5a6edcaf76f4b525f81a8f14e4d519bcd373edaf4e1282ab4bd57f43f0f678786c76326a425bbc4106a76318056e0382413a5202832697fe71aa63251f78b965d829800e6af1869c3a928053f362cc3f4a47e23acd03a2eed1e7ce124b2205a425826a953176049da0ea2a55bbe6a4920b7974f1859929d5dd2c804120aaa0b748a8898ad4348041d213aae2e3fa18f12ad0cd8c5ae85c2612ad4a3ae8e5cb814de116cb07be52555166a176fca31f42f55586941d40974ddda1887af7be1704b803f979ee2382ad1c34d19cbcc40027bca244b26b670fe853c22e9692348721812953875397afe0d089d2e927bc4a34a9c96005bef78bb50d268187c1ded0aac70ce167833190545454fa458826aabfaa46a52d41280906a3bc7bc1fce34f4b11a8f7ad505c300d199ef4a120a4a6e124e90e5ed1959926b32a615a7b8c966d6e588f5f947e5b7b627d9db80f693762be32e5864b86c24ae7d72b84fe69f673cf672009d88cd707254acc786a64c04112339c2a66e1d20929462461e6312800fe9cc899df1aaa90413a5f52bcc7ada354c262d7266a26cb5aa54c95304c94b492264a524ea4a81ea0807ee8a49371c12d60f15ae25e1cc7f0d6699a6479c65f8bcab37c9b309d94e6f95e6324e1b30cb3158698a9388913a590e9992e62168524d8a488d9b34bd1296481503ce3eb4ff6a1fd9cb88e4873f72dedc5ca7e1c12b92fda6b399982e63272c921380e00e604a9267e2e4e2103fddcace242178d90a03499b87c5a5c12807e4c6620b172d5fa173685771ab14e2b64affacb3b35e662292c804bd685bca914000d5adf5bef1ae64983919966780c0e331f272cc1e271b2b0d8dccf1129736465f2a64c4a2662168482b5265249594a0151082c09a47d46e43fb2bfda8789721e1fe2ae1ced47d91b3ae17e2ec8309c57c2b9f60b8878826e0b8832acc24a31380c74a50cb4f72749992d6013a83b280502070c9e528a333e56826940cf5276f97ade182458b5124b9de3eae13fb2a1da9028cb99da7fb2ba6690c532f1bc493523ccff00677a68d6b0bfb271da9f14da7b50765da871a57c48bdbff308b46151fc060f92f092c41770285259845e9410e9a12c080ce07afca3eba25fec90f6a8582476a4eccd662d86e2520ffee1562f47ec8ef6ab2404f6a1ecd25c339c3f1207ff00dc38d69c24f7832cadd51f22424eb6d20862e5c80f0dee89234b807734de91f5f72bf645bb57a802aed47d99934607dc71193ffd89e368ce4fec87f6aa3fff00153d9a09370307c44c3e7fbb476c28c656c32e9a6cf8fb124800b56e28e77ac1121cbb13b9029d23ec3c7ec86f6a4210fdab7b35a8bf7db2de23253e3ff37a98ba57ec85f69d5ab4abb59767047fd5c938914df3f7223b168a0da7fad1374cf8ea124825c6f4a886fdd545c94b802a520168fb1f3fb20bda60391dad7b39a880fa4f0ff1269af8fba8bf0ffb215da5fe19bdadfb38a47f17f60f1239f97b98e8a7c3e8cdd9c92f9512adb23e3706194e01218876de2d18551a90a7140000d1f656afd909ed0a82829ed7dd9f16ad3df6e12e246966e40ee57ce0cafd90ced0cb5247fc2efb3e31352ae16e234903761eee3d18705a12deac7e7fdc5f9707c68fb8539a106cc91f8458306b360a0522a5be28fb3947ec82f3e8b95f6c3e41241be8e0de235ffefb1a8e1ff641f9d5513fb66722e5115211c0bc4533f48da1c0f44f32d4412f6bfd48ba82dee7c5cfee4b252749208b6c627ee0b21f41ff00b21808fb5397fb215cdc4a889bdb3f92e121240f75cbacfd6fb6eb8ca93fb217cd42499bdb4793a9940d0a79739f9596ddb5c7753ecff0c6bd2d6d35fdff00d5164a82dae7c50a704b0e0a029f63b7888b65e026124041d2f47a8af847db149fd90ce6028a8ceeda7ca605fba53cb7cf54e7a9ff003046b09fd907e334c91ef7b6ef2ad0b3608e58e76b4ffef58efa5d97e0cd2954e25497928d56ff00ed93dd471791f10aac0ad2bd3a3ea0031a9e132d98a0094904870c3ef8fb66caff00642b89d59b4939ff006e1e5dff006295013bfb079559be2b35297ae944dc4250fd1cc77e392bfb283d863816761333e7373a79e3ce95c87993b23c99380e54e4b8b34213366c84cec6e967044b9a825fe20d1cd5b84f08d149b957e7f0e58cf3f2b8c52f948e58c5e53679eaf0372bb8fb9a5c6194f00f2d382f89f8fb8df3f9e2464fc25c1d9162388b88b3251207f93849085cc290e09590129152a023ec2fd973fb2e3c539de73c2dce6f692627fb93c0f819d233ccbbb30f0d66699fc7dc685244c461b8a33194f2f2dc1aa9ef30f875ab15300524ae482e7ebabb3e764cecc5d8e3219dc2bd94f90fcb7e46e031787461338cf38472042b8ef89d32be1566bc43382f31c5aee4aa6ce35263b0383c52e402a24cc73ad456495a8925d4f778e77429c6f3a2f953dbc7e8c27fdef9192a2cd6b25e1ee15e0fe18e1fe08e05e18c8381f82383f28939070970670ae592b25e1be1bc0c840449c36130b2c042109480281cd49249782b62541c962cef4a91f74569c419a8513a8742010a66bc66c84254ca59241a240b1b5446508469c3963b165656165ca7d2917352c6f7de356c0e4a9cce6c8c212532e6e21089b300d465a54a4852be42ad183a4a08d29048218f846e5c9313ee668295172aef28ed176aa72b952c4ba0b3594796e7b7239c1ce5e6efb4f3b56239c195ab86f17ca6e6262f92bcbfe0f93895e2b2fe1ce17c85664e49324ad43be73090b46673260002d798960121291f8d98d188993e5ca960ae64e98254b43ba94545a3ec3bf6ad3b274be04ed3bcaded6d90654b9391f689e101c25c6b8f95288c3af89786654b9085cc5ffe327e5cbc25ee30947631f23d9c61a5649962f329ce9ccb3697324649248632248ee4fc61deae65cbf12b56c23f66a7a3a7afecb68b5fa77c943b9529f84791f24e29f8f789c629ef26bc4de945ba0b97a1c719be6012b18497335e1f02838794a069354ef317e6a513f20236762b17ef056db781ebe3166256a49520fc20ed57b7eb1a462261ef2cb972e93502f668fc4f8e715a9acad29cf0b6b78258497925839aa547d4c39b30b4c71dd7f8bf9fce3014925d8820974b98c89aa0a49d2c491aa97fd229d5dc7140cf5a39a6f1f155a7ccce66ecb00d40109f9022a0106f0a477940d43774a4d1e0a89212e5fa6a042a13480c5f503d1d8c70cddf08c41420b30200b7c553fd61dded50d42d41e6378560cb501e4ce4f8520d0025c97351a4d7c3fac51735b2050e0905dc0d5e0778649246e09ab822be70ca049492f50f414a444948218125aa7c2b7f082565659033354312a3abc62c1a53649209ef024388ad28620fc29bbd6a44104a4350024bd2809353e7e31a470c94eccb8901252e4050a171174a258f741750725551fce31410456c29a83b17a53c232a59d2a736d887a0a6f1d11b5d1b2ce4e58e4d4a2be6cf2ca5bbebe3bcb024121d2f8a453ee86e7d4b54ae7373552e1d1c7d9985127a6216d16f24d44f37b95a482ffdff00cac877ef7fb5203c1e7f8279d5cd971a88e6066bbd3fe70b8f61b6b84bfed3f6113d2c7064d2082e18bdcda31b61b83b7ce32a70a877ee9a9a96b6d18c4d5d247803f38f9cadeb5cc65bb10862dd039f089048662f5e9b8891867a15147ddbb432407a9a78d1e01b9f3fa440cf5b7df120cd95a5a8cef4f08ec77654247685e51507fdf8c90c7c654e8eb7cb50d8034631d95ec98cbed15ca04863ff001ce4f97fb99fb47d070357e27a6fed29fe923a34f6ef60bc64beb46d1e6729b991cc5714fefde6ef607fe7d3e38b67122628281721c06767fcef1cabcd3d3fe26732400e91c7b9b80c2bff003ec447164e4a8ea2362e49b79797e91ddc5bf9cd44be33fad9693c9813000a24016fac56da8125c86f988b56524920500650b28d612a03a4848a98f0a57b99bce50a48292a67714dc3f8c228ddee59880c6093dd2909b54102201f34fc4a259c472d4793278654ec4d6a6ec1f4f942259cba986ed735b379c5ad53dd040baba0f28421c3b01b5dfd6d19cb720052402aab92c18d60a6aaa9622db9ac322cc025c54b02f788e9d4c19f723788cadc118053902d705a152487a38dc81682a20162925c3741119d37670c7a79430d5d822bba5356ddc071fd62034b3127716f9c16b24375246ff7412f762a72c1ee218401a80a28595dd0d588e080c6aa2c0b3faf2887e2157b921dc9100809018006e8eb05bd810125c16a5998082d704877ab8fce006d2481b568e7d521ee2bddd5f368b293d80520b8b827c3d562d2bd2430aa4d68c0420f88026c58353c7a7ce2d0520972e905d5a47d0474c26d32ca56c9fa87d993da0d9ef63bec99da0b95dc84c4671c3bcf9ed598bc2f0373179a18548cbb15c13c0597cb54c9b9464b890ad63159b623133d33f1090932b0f274a4ea99a93f9cb8bce27e24a953893b87af5ddfc7f18dac164935624d58b06e911534b005d497a8263d78f18d4c68ba0a768bb5f3bd9595fd88d954695ae67ccc428bd410ee1a8d18c6710a1a58fdf18ca2083a4b176bbfca11dc10c4351cb1731c1575339bbb651cf066267a93bdefe17ac15cf5a9fbd4d8bc60eaf88177dfac2ea3a5aa4359ad1877ed62e47785e57650014a7d2e68dfca2a25e8f5157676f084b005c0abbd1e0288dd9ae58b18c9d56dee51c9b26a1ab4a4b8352df908c94d5cbbd28db462a09531fb491561431948a041167629dbe7158b77b90b06af974944c9f2924060b497def1ebd7ec89c3c94fb2cfb012d4015ffc1a328e8f5c4e348fc63c8632f03592f500ab50a0701fd7947afbfb28f0430decc8ec0f2a56af743b2ff0eac03b19889d355f7acc6d57e0e3c7f51a54d91df433664b24cb51a3334642337c5e1c2d416a504a5dedf28a7dda828d1800e7a9315e274cbc3cc6234a9075134d3e719145b9e5d5fb4a3c739d7167b60fb5848cda6a172784b1d9170764a25803dd60b0590e055252aea5e7cc24ff00aa3f03d6b51512430b753fd23f6dbf6899483ed8bedb690a0aff00940cbdba0ffb8195523f119542a63e0c4b88bf33eea2ba16bb50488a22a68091a430d4e0c52a6012d701ad5dde194483560c9b10ed09450068ad3423f48c6576f08a0a4339ab3b821ab10decc585c3c3a8e9203835634abbc472e1eb66068c22960210cc4d54eed6710c12f54920d8bec1ed114126cc1cd49dbc2086aea21cfc2051e2127b0108627603e26def05c37c2036ecf0280ba417346bf5860c120b29deaf0f600962e4172580fac149662a20014eadf9faf2850da520d774d2c6f0c598509af4a8316cee024a457533d481727ac28249504ee6fbf97eb08487142fbbec69786624bb97377b188577805e96152a6a330de2d42c9a254c2e5a918a3bac090df718b400da9c904d3eb129b8bc129f2bb9f46bfb3cded5147612ed15fe0c736f8866e03b2e768ccff0992f1a4cc54d54ccbf96f9fab46132be2b4a6a10849f7786c62923bd872951ff007423d30b4e225f756b953e594226c9c46166a71384c5ca98913254e933124a572e621495a56924292a0418f121c14c44b527501765022e0ec7d6f1e8bffb335ed4d3da779267b10f3a3890663cf0ecff00c3e67728b37cdf16a9b9df30b8230c803fb3d7316a267e2b25002411de5613ddb8250a546ca2f97996c4d972dd1f5048d6972d72e96671f38d52462cca012ec542a4d49f38c59bee50494292410fa81a1f1f9c61b9a94d1ec01a8dcfd622e54cfc663311366aa6a118354e98c26ce9d96e17158898c9090573152ca944000778960008b709899f2c05a91832a176cb3083ff00d5fa78d3d24a98b335df7afd22d2b00a42493a6aaab27e5f589c581b83fb4f10d418496121cb65b86076e888c19b8ec511a9336525f718391ffdc469f326ea058914a6c1bcb78ac28bb1a24172e6ff00745e315d51295c65e3f314d65e252972c1b09201ff00dd234bcc733cf34284bcca72084160995292c69fe98d584bd40d0bd34fd230312875282826cc540545bee8de0a2fa1aa516710e758fe2c9856846718e9648252a96994907ff4691c17c598fe3b5485a7fbc59bcb4e9354cd486a7826b1db0c665a95bd3bacc68c7d7eb1c759d64489b25495202d0526ad54d37a7a68f4f4ba95464ac97cc13bac9f9f7c4c78d56b9ea9bc479c294547baac4d0d46edf8f58eacf303fbd69938949ce73552b63ef803f6bc2e3a47e96715f08bfbc992e5b80a3a52901941f6f1f331d64e32e0afde3dea9329490ab8290f47716bfeb1f71c278ab8ca2df434833f2678a91c662762a41ceb33c4613132e648c5e0f18b18bc0e2654c4689b2a7495ba264b5a14a42e5ac14a92540820b47cbbfb467b0563b90f9bcee7672ab269a9e4bf12e67a33cc97052d5353ca9cce7a89184352a197625454ac2cc513eecea90a2e9415fda5f16f2f5291395ee4a90d5504049416dbc3cfc63a9fcc5e0fc26332dcdf20cdf26cbb3ce1fcf7013b27cfb20ce7049c764f9ee0f100a67e17152541972e624b166525402d0a4a92850fbcd42d2769f471d1d6f46ac7309f58bc7ce9ecd7d868d77895b73e0bf2acd9587524ad46877bbd6b1fa27d873b75f387b15f3a78439cdc9de289992711f0ee28231183c44c5ccc8f88f03314938acb3329008f7b85c404b2d17490169652418db5ed04ec339df651e2e4719707e1f33cdf909c6d99affba59dcfd58bc4f06e2d617355c3d9b4e0184e9402cc89ea09189928d43be99807e7ce033529524098431a87623a3463d97edd718ec2716969ea252834e9d5a534a54ead3962709c5e2709c6e9a7868bd0d54e8c9c5fca8f5f3ec4bdb47939ed16e43e53cfbe4c146559f61112f2ee71729b158a44fe22e57e75a5e7a1413feff033cea9d86c5a0699b296924216264a476931120ca09ff2d44900ec08f18f2a3f6757b4b39dfece7e76e45ce9e516632b31932568cbb8db97f9ce2667f75798d93a960e272acc10920a75a5cca9e8efc89812b4b8d493f62fcaefdab2ec23cc7c2e1bfc5ae4073d392399631a5ce9fc299ce59cd7e1fc12cb85120a7053c241ab096a2df58f678df67743c5f591d4762ed5747523cea93ab055b4edbcd16aace32ad08bfc1ce1cf370b2a8b9e3cd3ea9c55577a6d356bfb3cb3f46ecfa279ea1ac8093de2e9d5716f5b42fbb046a75948aa5252d735f0f18e8df247da8bece2ed08bc20e5f76bfe5965f9863948448e1fe64a713cb7cf3de280697a31894cb246a6252b6f18fd16ca72497c4797a737e11ccf23e34ca68466bc1d9de1389f2f5bd411330f316188d9e3e1f8c766b57c2e4a3c4694e8b6b1dec274d3f639c629fc8d9cd528ca2f95acfb2c6ce5a428b312c0380c08f5d378ac860a0ce086a805bcbce35cc7e5589c14c57ef386c5e189aafdfca54b09f370dfa4692b4a1a8352998b9bf48f99d4708aea3cf0578f8acfd462e9492bb469aa525255a40d2192922a3c77dad114a981674a80601c8015acdda094240204b746a6553524c425409212da8be9164f8478957495166c64e36e8592d45646870b35d2054f97d62e0a63fe62c020b00ddd1ebaed189ef350253dc5ead24d8fcba3f58a0a97df3af5254920b06a8de38a74a4ba15714f08dc32d7a7e23a55471f8fd7ac2cec6a52e12a0164e92a6716351fa4692eb4849a9601c02edbd7d6fe118538ea3f196724a01ef7917f95639d53b3d88e4f33837b517207979dadb909cd6ecd1cdac349c5701737787559262b17324a67cde17cca51f7b93e7d857f867e031425cd4a831d3ef12eca8f269ed53d9bf991d9479f7cd0ecf9cd2ca31193f1c72bb8b713c319bc9992948c3e311295af0b8fc32881ef30f8b90b938993313dd54b9e820c7b020c3fef043b104b04000936f5f38f9c9fda48f666c8ed2bd9d30bdb3f95bc392a6f3d7b35f0ff00f67733e4e5783d598731f802515cc4626784f7a662b229b316b130ea51c1ce9a934424a6654212946f8b91d2ff00c743cecf0a449505064905f50ad5a3eeabf66cbda2b87e6e727b887b05732b8952ae66724729c471e767b5663881eff8cb847de9999f70ee194a2eac4e4f3668cc24c904a95849d8cd21a418f863c6ca4c9985050942c6c6f1c9dd9ff9dfcc0ecd9ceae5a73cf95f9b4fc938ef959c5f84e31e1ac7e1e67bb2a9f86980af0f35a8a933e5999226a14e172e72d24105a30a90ee66a51ca5e19c12d5b27adf6054317313312a25d41448a922b1c99934a98149524b3900ab766bb47557b2773eb817b5bf223953da4395c65ff72f9bbc3a339958093304e5f0b66b215ee73bc8b11fc33b2fc62674a29554cb549559409ee765b977ba4254a42a819bc581fe87f18f6152e68a715865b953f499ae61f57752092ca047d7a7ab46b924a492c4dd829a8aa758d3644b0544328136636f946bb87c369486a9f1148770d2b345ade06402c9240a10f534368ba5ae5bd164127ba08d2479edf7c53350b960f81f841a1f5d61a4a4156a2a749fb24337918b2a56d819c564061b240adf7fba1e54d4d351d245c82f768d3d7a92e2a2b43f2ac5c12474d2a1406aa7a46f0a6d2c93666a2b9a40258872eee1cecf147be01455acb1530714b450ee08d4ca7a69009bf489eeca882414b970527500de1ead1a422d64b2496e6619fa4300e09f8acd0a99da8d0162c0f48accb3eef50676dc3948f422842820a92fa89d9e83e71ac79dac116ce0d4c93abbae90cee48310cc42883aaa0d1ac7e7186564002a52ad9ea442a5476e8e49ab4592a85d5eeac6699c903ba4a893f4f38b13302803f1303e0f1a610a0a483471460e7d7e9193216403a8970fbd47ca2f7690b5b25def01510450062e1a2c13506592b2f4b354c63a822eca0c6e4fdf18d316a7012433791da3684e6d2b168bc19427841eefc4ce3767b9879b8898501214c0d9f6f5f9c60896a70a00870e6b4207e10e4ad484948d833f96d1a49ca692659f91a46242a62c94b9254cc45bcfa6de984512d3df48d24005cbf5f0f5d2370c8c325455ad3526a486e96f548c4cda46172acb71b9c63f1b82cab27cae42b1799e739be3a565393e57292e4cdc4e2e6a932a5246ea5a80a1889cd45fa4ec1bc598d2d2529d41fba1dd3634fc233f018a4cd5680406a1ee8af87e91f3fddb73f68b3b14f651cbb3ee10e49cc91daf79e18597370584caf83f355e57c99e1cc504694af37e22092ac5265afe3c365c9515fbb527dfcb70b8fc0becedfb51fdb5f81b9d79ff0015f68ae14e5c73cb933c639ca71598f2ab877261cbaccb96b850c84a383b34419851eed203cbccd38a4ce2095292b56b1eef0cecef15d7d2955ee9423f079da839bc6229ac793972c5f8955ccd5d2c1e822b90004960033b814deaf1a860922610258ef8a06dff0097f28e907622f68a7646f687704cccefb36f32e4663c559760118de29e5271521191734b84c14bace232f2a3efa524ba7f79c31992ce97711c21ed32f6af725bd979cb99d88e213957303b46714650bc472c392b2f31f773b52d2a4c9cdb3f32cfbcc365e850d4477664f09d32c872b4d749c138a6b7883e0da6a0fdf7f125e872addce6e568c69a59751be54b37d8d23173f457ac74fbf699b9a3d98387fd9f38de5173bf3e9cae78f1371b655c65d9db853875187c6f15c9cc32dc469c76618d4ad40e1b2a5e0a6e330b3a71752973e489685a924a3cd878d73bc6e7f9ae2333c4a2549429099184c261dd386cbe44b4e99526583f65290078924dcc766bb5df6b5e71f6c2e71f1873d79edc678be32e60f1763d58ac562a68fddb2acaa4ea3ee70196e101d186c2484b225489744a521c92e4f4b31f8f5ad4b00920508b9df78fabe3dafd3704ecf53ec968f52ead28c9d59cd6233ab2493504d292a51b7a0a596dcaa4945cb963b4e5c9074e2ef7cfcbe469189512155daa4d418d0a74c2403a81dc38a18cbc44e2aa0274804120efd7e51a6cc20bd58dc00cd7aed1f876babf34f079f279c94b951600a890ec12cd4bc01334902ae07708b8780189dffec9f5e3002417b9214ee361d23c77357b98b92bdd816b4ead2ee74f7fc49f1f085252d564d1dc8bfaa7dd0ca292a5288436cff4778420692431a50ec1b68e67bf994254778283b3503b8eb0454b04bba43936312ac1407856bf485258a748ab387afaf28592c82c493abe22c0109277311255f13834a58910808d40d2ec01347f28b4105dbbac6ad71b44a78c00b6ea66142c287ef82082ab176620803eb00915a95114667fbfc21986906a750748605beb165b81877534aebf00e3ac644b4860d4d4e14e9a5ec231c29869d209f85ac4f58be4ea0eef4bee3e7f48e98e36375b1cbdc97504737795b761c7d955e83fe772c43f3eebce8e6c559f9839a13d3fe72b81c974eae6df2b83ba8f1fe520d3ff006ae5c4e7da8279d1cd7d9b9819a50d097c4ae3d949fdc976f8ff00b08938466b55ea096da9ebf28c55306600317f18ca9c407a020135378c4245e8aaf48f9dad8934cc25b95c4891239c8092ee7c60a439adbee85b1f283bed77f08032e5967a377580347f5f947653b2786ed13ca123ba7fbe328b8069fe4cf78eb6ca6d20d011b333523b25d93c247689e500350ae34929362cf2a788fa1e0293e27a6fed29fe9a3a34df8687e72fad1b439a3acf32398ddd35e3bcdc9b87ff006e9ffac7194c258f46bb96162cdeaf1ca3cd10aff12798c52c41e3ccdc249aff00e1f3da38be6a427de02c5a808a806863b38a7f38a8ff0029fd6cb4fd66612f5125c0a00ec08062b29d29ab92c03017dbd18755c80e771a5bd7ca10a43104824a7524a2aa3fca3c19d964ca6ddf05554a0bb0ad189f9c471dea900809d2ef682a49bba5c87a976fe709a487600070c40dde39e6deeccddde5835004e9a002ae5c9f385d2e09725d57a922014b2883bd05188f1fba225c8236a92d40f19e1619030056004f8934610ba412121edb12a26b0c0b50bea6daa81fce210599240377b3bc4600a52eef4203ea721cc0492c526cde4fe30f723e101b49717a4422b50ed56b13614afa683b01485775c92c6cfb3c472c54028171777863a85497373a9a9e5eb685702e492cc0534fd6175d00c2af40080c00a116806c82a0438fac2ba4b9342f56a186749eedd86a02df382cb01ef03a4a7c456d4a561824905c87d8d5e1497b3fc2e05c5a90458a48f88d6cc2d0be006a482c01bdef7ac3853066f84b962c567d18a8f74000134ef5439bc4a25d46b4a86b522e982cd6092407ab8a31aff580a36af9339115950727667205a9e30a16f5601ab5a022b05260b83106e146be03ce2b29a13577f1eb009a07a74abc425dceaeea8d13f3dfc621b6c058d42ed40e36a44b90189eaf610a5869704906bd0c0a829626ed5b45534901c863a4757afabc0524a8f52cf52cd4826ae1c17372c08f282c6a490c9a396d47c22f1f060094a9258d86ee47ca3210598b1605dae498a903620f47fb2d1908606a439b3d01f28b47744ab5f26ab862a0998a4a54c24ad62e2c8263d86fd96f86560bd9b3d847033834dc3f659e132b480e7bf82333ff007e8f1e5c32ff00cac48704fee93ae1dda52e3d953b06655fd8fd877b1b60e521025617b2ff00054b4a65b1487c970eb2df351b46b512b2ce4bd4e876ba64b01e8a096fb543b46839938933921419496d21dd3567f5d635c9d31c106b472a3603c6343cc19725665b6a0875101896d9bcbf18cad6d8a1e553fb440957ff00063bb721482d2b99b83935727bb90e52e7ef8fc5024924fc418bbb9e91fbd7fb47fc0d9b709fb5fbb5c6373647f93c779e64dcc1c8a6201d3370199643977b853ef59130121c3a63f06552f4ad40333b903c225c1c69c65d18e56a2995076208340e010ed58562407d292cfbd5a3274d080c773a936bd2140142c1826bfe9f18a5aeac414a9d546617551de01150146b6a3b88722a19e86a13e7bc211df2cccd52768a3029dc076aed78829450a9e9e70485392360e0820f482010c5c29aa0985d5c001502c010f5ad4ef683ad4c5c104f83bc1721248ebf09b088c6a01208ebb43da025ceee43500620c215283bdee28c479c174b024dd2d40ec6230ef0140439d41c883dee98169a58963b976221fbc00620d7a13bc200e1e8544d8d1df78b0252141dd24f4ab42c08905c967480c5eef1602598243559cb13e5f48b528704324121d448a379c5d2e48274b0ad0390fb45929344a8b663295312414a540aa8126a4c7d3d7ecbc763ae75f34bb7df0276b1cb70b98647c92ecb73f1b9e71bf16ae5ccc3e0b88332cc729c660701c31855d04d9f88fde44d9a804897265952c5520fe72fb297d97bcd7f69af683c1f2db84d33f85f95bc2424f1073b79bb88c119d9372ff29f79f04b24699b9862b4aa5e170a0ba94eb23425463d4dfb37f675e4cf64ae4a704767ee41708e1f837963c0196feeb94605294cdcdb3bc4cc4838cce336c401ab138fc62c1993a7adcb9090c94a409b3bef816b1c9c9f79265a1135d452800b1abd8b7e1193267027bd77ee9b5ee22ac4cb56a0a49d26a4148a794634a5bb05234b934614dbd758b2bb5920d7e504e92024bdc8529f57afca167050b020b5136237778db598f106599060731ceb3dcdf25e1fc8b26c21c6e73c41c499d61787720ca2424806762f1d899889125150354c5004b0bc6d499cf6e442e5a563b40767b4d01d4ae7a70bb0e95fdf5a26f617392e5254540d9268092483b7a119c9921275779440709627579470aab9f9c8090a7c4768eece52d29ffc6f3e7859205439ff009ec6523b4d7665960a57da77b32823ecab9ffc2a0867bffb6c4b9abe0b5f16399120553a5d2a2e121dd34da31674b2c4b52cc2e3d7e51c118aed71d91b0275e2fb5d764ec2693a4a715da438464b757271d1a2623b6cf62c9257effb67f63e97475157696e115359db4e30f48bc6a5cb2bdee8ec0ad218802d43768d031d82d695240ef5c25e8ba57e71d6fc6f6f8ec19832b33fb72f63b97de7207686e1f9c77d91355f48daf8cf68cfb3de44b336776edec8484a4e874f3cb2d9c51f24249feb1b46b2bdee4a6b67839e734c852b96a4995a90b0e41140cc691c1dc59c2a94eb9825098929208d24e9a1af9753e11b0732f6967b3ba53a0f6f4ec8ea4853ea1ce2c3aeae3a483e31b0b35f6937b37a625489bdbd7b2402a345279aa66917fe1c19f463d1d2eb9539664ac399fb4d1b89b8553344dff20a69a7e026de1f5fba3abdc6fc02857be5ce905d054428b775cd5fc475f08e5ae20edfdecec9def9780ede1d922621635a52ae6bad2a25ac07ee3f8f48ebcf18f6eaec0d8c0b972fb6ff006513a8b34be67cf9c05431253802ed1f67c338d50834d554be52f193566750b9cbcb3e19e39e1ae2ae5d71be432389781b8c72a5e4bc4990631d32331c3afbc85ca5de562244c4a27e1f10865c89d290a4962a0af8efeda9d89f8ebb2171f48c3cf4e33887957c613f113f963cc2461f4e13399520a4cecbb1ba7bb2332c205cbf7d87536a4ad1365ea96b491f665c4dda87b0966b3953a576ddecaea0f449e636395a5decd9618eac73d79b5eceae72f2d78a3945cc6ed67d9933de10e270954c397f1de60ace720c6c84a861337cb269ca9a5e2f0c662f4124098852e5afbab2df49c62a708e3da284fbf847574d7a32724b997c59676f07d3e83494632574fd23e27d58d9b2c94ba92c188a86afafac6465d9c6270b3484cc5844da2d94587431bdf9fbcb7caf949cd4e29e03e1de67701738387b2ac526770ff31f96b9acdcd384f8a70388489f85c44a54c952a6ca9beed684cec3cc405499a99882fa751e2044c2000e430620867a47e631e33aba1aaf41b8ca2edbfd18c3460a728bb1cc99771662240095ce5929341a8a853d08e79e5cf6b6e7a729330c366bcaee71f33b9798fc24c4ccc3e2b82f8eb33e1c5ca524b8eec99c94d087aa6b1d314e28e9052ad2a019cdd5168c51b6b4f8978fbee1beea5da6e154d52e1faba908754a4d27e4d5ecfe53aa3aba918a4a47d237243f696bda9bca34617039b73f301ce9e1f9465a2764fcefe09cb38ee76265cb0c52accd52918e05428a509da8dddeb1faefc9ff00dad2e1fcda4c9c1f689ec719009cb988188e24e4a71a4ec8e6a5340b5272fc7098926e40f7cdb1eb1f0952f1a41f8a82a585e919b27365a4162ccec2cd1e953f742d06b2f2e2dc374f524dddca305426df8b9e9dd272ff008b98d16a62d7a4aff41e9c9ca0fda12f6557356648c2e7dcd2e63f23733c5e29121387e697014cc5e4d86d43e29998e04cd4840342a29b56d1fa8bcabed09d9cf9ff00270f88e40f687e477393f799e30b87cb381b999966238926cc5314a06553a6cbc59529e804b24d5a3c7af0d9f4d94ca4cd5a546e949a3f48dc182e2ec660b13271b82c44ec163b0ea1370f8bc1cf5e0b192142a1489b2c85850ea0c4cf5dd8be20a55396ad19bd92946a43fbb2509bf96a9493a72778feefb4f657cd327cdb2398119ce4d9a652a21c1c7e0e661e52c782c8d2453631a32bfcd054956a0480e82fd2e7aff28f2c9e40fb5cbda1dd9aa460f2fe52f6bde74e479160667bd95c2b9cf16cee33e123674ab2dc799d2749018a426a23f5bf93dfb559db4384a649c373a3953c82e796092948998dfec0c472cf8916c53a94713972fdd28900fc52a84fca3c0d5f0bd038f369353192f34e127ff0fa497f88cc5c247de7142b4035e80a1c15577fc0c62fbb585051532407a02a2dd5a3e673945fb551d87f8c9783c173bb915cfde48e366fbb462739e0f9f96f3878665127beb3202f0f8b4a1352c35a88b02691faedc8af6ad7b33fb452b0587e5776dde47ff6d63d2b561f85b9a598e2f92dc4c828054a42919bc995862a201d2133c851a07348f9eaba0a90f4b96ebcad2fd16edf2d8cf1d4effe1e4ac2b514165072c9d276bfdd1ac8c6cb912a6a31580c2e6983c4489981cc72dccb0e31396e6b859c854ac4617132940a572e6cb5ae5ad0a042828bc6265b8ac266b95e173ce1dc6e51c59936330ffbce0b39e0ece309c6193e2a5966988c4e0e64d96526bde768d1e7660898b54a98a52665fddccee28f8693516de39e969e1379ca2559eccf34cf6f2fb2f0f600ed453f89b94d94e311d9639fd88c671b726a6cd52a74be0a9c667bccd783e6cddd5964c9c0482aef2b09324395292a51fc251879f41eec957526c691ebcddb2fb177297da09d9c78dfb2ff0036d432bc1f1423fb63973c7f2f0e9c4667cabe29912d632ccea43d4cad4af73899369d226cc4921c11e591da57b2ff0034fb2673c7993c81e7270f4de1ce6072bb8927f0f67f845249c0637ddacfeef8ec0cd3fef70b8b946562244c1f14b9c97621407569f82aaf55c22dded7b7978fdbe0fc9a2630bbb44fa1dfd978edf0392fcf9cebb11736f8bf0195725bb476609e20e5ce238a333184cb7817987869230f86fdd262fbb2c67b864cbc04f974132761300a7052757a0ee6fc178ec0cd32148904cba2b44dddabf4afd23c56f2bce71992e6183cc32dc5e232fcc72fc54ac6e5f8fc1cf561b1b97cf93304d933a4cc490a44c96b4a568502085241168f53af61dfb4c30fed2aec7b916338cb33c2cced2fc859185e5e73df2c414cbc4f12fbb95a728e2d932b79599c8940cfd21a5e324624304aa5bfa91d0e934fc8e8caf1da69f47d1af2e8fdabccba8c54b97c4fd5bc370e63ddc4a01be257bd077f553d235b19562a4a403281045c4c1431be861a5c8014b1a4358f57f5f58a67e08e3a5e9c3e875324951084cb1572546c00724ec04455a7a76f9e4ad1f134b47a9d60e7d73f391fd9938026f347b43f34f837939cbb939be1f8795c5fc6d8f9985ca578ec585feed8494252264d9936609730e9420b04289601e3a452fdb25eca2428ebf680767b201b231f9d2c01d29808f8affda2cf69e7fc333b52cee4072a73b562bb337659cf31bc37c3f8ec1cf2ac1734b8b43e1b3ee2658074ae44a521780c0bff00d0c89b3431c4280f9e1466ea4a0f7d228e2b78b50d269677f7c54947d897eb4f266a1cd94ecba60f5fcecfbdb97b1cf6b5ccf8b722ecc7da43967ceecf780f27c3f10f1664dc158cc62f32c9f01899e70b2b1ab9789c3cad72fdee996a54bd5a0ad1a9b525fb4b8799ef83a5c022e03968f272f65176cfcdbb11f6ece4673cbfb531383e0afef00e00e6de025ac9c3679c259f2e5e0b39913d00b2c4906463e58369b974b3b57d69f0196e126e5984ccf2ac64accb28ccb052732ca732c32c4dc2e6385c44b4cec3cf96b1429992d685022e1513ef6d341ba6a4de70df5f9b1fc79165157e5668a652f5950bbd88b0f18cd461e669252e5458287527f3ad23370d8354d9a181001fb43c5adeaf1d08f6a2f6e5e15f66e763de647686ce9584c671ecd94381b915c213a6a44fe30e2ecce5ad197f71f51c3601299b986216030461025c198974b4b66a9c333764978bfb3c5f459d8b4a2a316d947343da95ecdce47730b8bb945cdceda1c9de03e66f02666726e2ee10ce559b4ec6e418c12d1317879b3646126492b485a75042cb1241a82238bb0fed93f653cfc584a7b7cf210a0abbbfe7e768d5e15c04796cf19f30b897981c59c51c75c659e6333fe2de33cff17c53c519ee3e699b8bcd730c74f5e2717885a89725732628f8061b46d9c36653113094cc2ceeeec7e5d23e868f01e1f1a91a73af37cd64dae4b2f1b5e2fe4bb64c6936d36ff8f9cf65be52732b961da0395fc29ce6e46f1f70f734b95dc6d879f3b86b8db85e6cd9994e6830d3e66171294a66a11350b97364cc429131095029348df52b2e9fac832ca81342eca8f94dfd933ed8387e32e5173e3b18f1166c27675cbcce873a797196cf5a96bfecbcd968c367d2b0c0d34cac6095885245bf7a25a3ebba7e5939075252d5ab5401ead1e56b7494f876beb68252e6517e8c9fc28b49c5e3c9d9dbaa6443378cb7583692f28c4a92e25a4048a77aa47ae91c3fce1e69f2ff00903cb5e38e7373978c728e5ef2bb96f947f6df18f18676a5fee395c83311265808403326cc99326225cb952c15ad4b00024c73fe2710a940cb092a590c509ef2cf420799b47c317ed49fb47a4f10719f0ffb3bb95d9f4bc464bcb9c5e0f8f3b466372ac4be1b1dc4532589f9470ecd524b28e5d26623133d06899f3e58354535e1fa1f7d568d06ad1796fe2c55aefdaf0979bbec9979a514a31dde11f420af6e4fb2567c9a76dce5dca9ba58a2770bf10ca293b83fec5f746e0e5e7b60bd98fccbe39e12e5f705f6cae5b67dc5dc73c4784e15e16c9b0d9467785999963f1d353270d23decdc2225cbf7931494ea5a800541e3cadffb5e6cd74fbe5902c75bbfdf1aa645c4d9c64d99e5d9b65198e272dcdf29cc24e6795661869ea9389c0e270f3513b0f390b05d2a42d085022c447d553ecef078de9c6b54cecef0dfa63936f9510e8f2a6e2f27b404ec12a42a64a9c92999296a9731069a482410afa18c3387750003021c5e91d36f66076accb3b797617e44f692918dc3cee28cf3873fb9dcd6cae52f5cdc878b721232ecea4cd4fd9fde0ca9198201afbbcc511de09d86289a112c151416480c755fd3c7c953a6a152742afaf06d4bc9adfe4f07b3592f04a4ae8ae4e0662d2d2c92540b000eaf5e11f095fb55fdb2389b3bed29cacec5dc21c5d9de5bc0dc92e574be32e6ae4591f104fc0651c49c53c59346270b86cdb0b29694cf565f95e1306b9689da824672a3a43bc7de52337cbf8632fce389b3e5a3079170c64f8ae20cf3173804cac2e1305217899eb513464a2528fca3c823b6d73c7893b5ff006b2ed0fcfc465d8fccb13cd8e6d671c598597829133172707815e25587cba489a7b88972b0787c1cb1a940012e3e83b2bc3aa6bf89d5af4e9b9aa314d28a726e7376492576da49f4ea43a7cf56304b0b2fecf9ec752a6637e142140002884f7536b00282313dfce51d32c2e64c98ad329080573147a240b98bb1b94c9c948fedbcdb072f10032f2ac9e6a336cc25d1da6cd4ff009283e4a5111a44fe2244a42e565d27f7296a1a5534ccf7b8e9a29454cd87825847d0f13aef49564b8c54eea4be05d3a9ec714fd1ff008f95af036949ed3c1cf3c90e7c730fb35f3138639b9cb2e3be24e06e67705e628cd786336e10ccd596e3f2d9e82e062a7a5d2b94a6699852148989252b0c488d3b9edda07997da2798fc63ce2e7171c677c7dccae3dcda6677c51c539e631589c76633e61a2523e1972e58d289722584cb9684a5294801a3ad589c68512475a97631a7af1c52349512361d291f35aef740d6bd24f87516a345ab3b25cf28dd34a53b7335757e5c453ca8dcc9d6c59b35ac6e60a5295de25835dc1fe71b7311890b0cc5cef5118d3a795a8052dc05386debd630d734b8236d99fafaf947e63afe273af26dbc1cd39dd0eb9a42b49b01522af68c45156a70e90e6a4b910ca502cc5b4a6e3ed1a457a8a427bc028d053e5f2a47cfd4aadbbb3094bc0092a0c1209d41f517603ac0d544bdddf715e8627c24b394b5cb38a57fa443a54059cd80d9f78e59cba99b029556a03bb0a1f1802c1dd5dde8d48252c1ca850bd1abe1019418915d3a85be43f9452eec9300a2504924b59de9581723c7777ac4d400735abd9e21b8721248bb43127803a7bc6ec47c2d4a7a7877005a848abb827611487726e541b4aa853b54c5a820a5ac5aa5981fe912acf0c1655dd8543dea7afce08d6281d44100106d0ae6e58379307b44f20ce58541d55de35597627d8380e14451aae6c22f965eed40db968c70407096556a0d445890c68fde35e83d523757dd1ac5dd1cc5c947ff0017b95603927987940276ae3657df5fba2ce7fa74f3b79be1d8a798d9ba43872c3173008ab9220a79c5ca80a64a4f313282482e4ffb74a35fac67f68828ff001d79c5a74e9ff11f366269a4fef4b7fbde3d9497dc9bff0059fb05fa1c06b043b9704d6a6318b3386625cbef58cd99576d3d0381e1182a1d68d61d63e72bd9c9b39e5bb1486adc1dc4488e580d8448c0804327ef34bb406725a9bf9410589773b38895b832a59b025c037bb79c7653b28a3de7688e5084d5f8c64ab4f46933cb7ddf38eb5ca2c1cd86fd7d7e71d9bec8ca4a7b4772714a058f19ca496bd64e207e7f747bfc02cf8ae952dbbda7fa713a74b9af05f94beb46d5e68c9d1cc8e64254e0a78f3384b33db1f3c47134e2a627e256aeae0472ff003616073379961350be60672c1dff00fde18821a38867821730870976ea447a1c5d7fb4cedb734beb65aa5949a4612b700001aa01751f031502123525d34372c47880de5162ca41248ef69bbd3e7f231592c1492a6fb49a387037f18f9e961194bccac90486724558d13f5de154e1ddc137ab5b6f9561cd4051ee02281e87c8c229af662027a26309df262f713672a6373a5cb7afce01a3a455f7fc6091420035a1360222482fb91bede3f3f08c9b7b021fa807c9e0a8e9034bdaa45c0f088c0b073e1578048494d6868a7161078dc00f7b4b9aec6ed053d4a6acc0bd60779c6c016037a41481a8800d7ed39f9b44257c02164bdaa6ae48a40701240ef59bfd3e505f558bf50d43d07aeb0ae45477296dcbbfdf0f600bea05aad6260060e40a6ea157eb4fac07502c2800abd035290e43aa8ec051237f9c33701b8adcfc25db6fba0b8d441241340c407b7e30bf13d080f40f60d46864b072ceddd04d4a7c60b2fcc08540003bdf588e6a77a8636b4124390c496663502f0801a873dd151bed0c2c01d5bbb80d470d5e9150218ea60c28976af58b5949209a92281ddabbc292965002a6aae83d7e50b800018390ff006778670482cc2cdd6b00a760ad9ecefe3052c0ab702a4da16cdc018e962753960096b4129529c1a8677258a609a84e97d49352e594209655817fc61656004a40dddbe9014011b1a503d7d56080fdeaa40a004d7d78429517d205c5c8dbcf6894fab0321409621d92e49ab3464a0b8163b80ef18c12a20582853c22f43a4bb31fe10efeb78b61340d6b0404c5a64cc2def92a9069f08582973f58f5f2f64973532fe6cfb31bb0ef16e0716ac6cc1d9fb28e16cce6ac699a9c6649ef72ac54b3ff0055586a78111e40d85985249f17a518c7a22fec9b76a4c0f327b20f367b2e66b9919bc67d9d38e97c7992e5b889c153e770af13a9095cd9087d5eef0b98c9285b064fef88eb1b4b2932f25749a3eadf10b290751013701fd563479d3d20a98202fecb29dfd561f178af7aa524280f96a318812a0ad440d2dd1cf9c50a1f2d1fb499ec9be6476c2e06e12ed87d9d386b17c61cdbe4af0baf84f9adcbec970ffbcf14719709ca54cc4e0f36cb24246bc56232b52e74b9d864bcc561a6ea40519452af3c3c764b99e031b8bc063b038bc0e3b058956171983c6619786c7615682ca44d92a014850218a54010d511edbaa9b32504aa44d992a74b1ae5ce94a32a6cb2d42922a23a1dcf1f669fb3dfb4f712e278c7b417635e49f3278db1720e1f17c749caf19c13c5b8d492fab1389cb27c84ce5d49f7b350a5d6e6116e3b657804dac743c81266166cb6d695a5ac4a4a47d1a31424d3ba4937007d23d4af8e3f6717d8ddc54a18a95d9938ef83670432bfb89da0f88f2a947727dd4f5cd438d9c6d1d47e32fd95df660e74671e19e3eed7bcb95cd73874e59c739071861f0a1a81b199712a03c7eb1672f0459c9781e712a96b4d81041bb3030ab97d5cf570dd776f4f1f7cfc57fb243d96b1b2149e0aedb1cf8c9f1249d078cf949c3b9f494f47fdd172567c4d3e51d6fcfbf64173a2679e0dede7c07992856449e2ee4c66f904c3760b99231735236a81f28caf7dd153e2944bd2e46d76860971f503662f1f5bdc47fb235db2b01357fdd2ed11d96b8b70e104cb4e2388339e17c42cb59a761169ad7ed475ab8abf65b3da99914e9c9c8382f933c692d2a2252f20e76e53aa780685289e259f916310dabe503e6cc21cb12ec9a8fac58509a5188f1668fdcce2dfd9ccf6be70b20cc57644e27cfc0ef15709712e4bc4893e23dd62bf28eb4f14fb1bfda8bc16677f793b0c768dc14b92ea5e2309cbcc4e7320803699873307df138796c9c1f98da4060ed4a757f085482c4171aacc2b1da0e25ec6fda9b829534717f673e7cf0e992a299cbcdf9439fe1242082c5e61c2681f58e08cf785388f8715eeb3cc8f3ac95415a74e6f93e272b5035707dea135f08ab51f120dacda5826aa6d376f5bc592c5483677059cc5a8c3123585a2a6c67a1fc99e32d39763080a958652926ca4ab501585acaec140a1095392431ea23bfdece5f67bf3b3da39da1f87b91fca0cbd586c0852337e64730b1f865ab85f96391226a538acd3309a0697092a4c890fae7cdd2948f88a78c3b1cf62fe7bf6e6e7c708767ce44f08e3b8978cf8931a8fdfb12992bfec4e10cbd2a7c5e6f9ce2c0d185c1e1d014b5cc9846a2025014b52527d517d9d1d80f935ecdbece590f20394b85c3e6b9be2932b3be6ff003466e09387e21e6ce7fa009b8dc42db5270587754ac1e15f44b96351056a51376dcb08b5db396bb1df63be43f614e4370c7678ecf9c352b24e0dc8128c6e7f9fe264a0f16733738284a7159f679890019b889c53fe5cbf8244a089680026bda74afa171f081b98c2009b2cbd86cc368cd912c80e4904ec6ac7ce2c960876be013258a00ab54b970de11a466f8dca320ca337cfb3fcdf2ec8722c872d9d9d6779fe718c465f9464783c34b337118bc5cf53265ca948054a59360c2b1abe3572b0f267cf9f88c3e0f0d85c34cc6e371b8c9c9c2e0b2f9121066cfc44f9aa2132e54b4254a5ad4592124931e7cfedff00f6ee627b49e2f883b14763ee239f80ece390e68ac373739a79662972333e7f661875947ee1855820cac870ab4928486563263ad67dda5093593e8b720e19f6f27b6eb19db7f8a339ecbdd99736cd327ec85c139e0199f122f565d9df684cdf06a295e6d8b940bcaca64cc0a180c1a9cad2913e6b2969423e62978ec5217a04f9a13b7f9aa2df7c22b10a20a5cb13de26e23156095156a008a01bf9ff0058abe5b2e518e86a633098a1a0cc528f89a0b5e30e64e4ad7a90ce3e2eedff009c616a22e3ce19448620f74966b439dbc033a5e21291a4cb9249146960b7ce099884af504a06ec52234f4a8862c7a78c10b041069d2176903503887144a097a9f761bf08ad53dc92020219cf700dae03460a49b0700deaf6dbef8257d016a396bc1c9b5706609d77090c1d2c801eafd2009a4851eeb90eda47e918856a76a8aed05d4cc9f88163d1a213065a661d2fdd3b82103eb6860b6a320d1c7743b7d23112a514b936bf758da085135ad2e2f17534b640d425e2972d1dd524743a00fca31274e9a54485d49a0d22bfa45054ece1c9ab6e2109d0011f13547489954e656b2058075f8fad81730a35311462198966800b11bdd86efe9e1d4aff004ece1a0a4d610083a58036bf43163970d53bafe71485302145c915a12622482d724d5c96378bc6a3e8c94dad8c9d4ca67203777730fef58115717118a155d4cc4d9cc40a2ead248d54e91ac6ac935664ddb667227915a2411705cd2d48bd38b5017a1b1de34d2433bda841abc404502c30b0373e42378ea6a2d99653357978c29046a2082fa89a9fe70c314ad4e092ae8f7f18d20a88096b104906e4414ac82082c0dc35bc6358eb6a6c99653bee6bd2f16ba28a88d2aa9778cf199ad52c8514cc481ff4890b6a7522f1b584c3a980d25abde77f9458998450331b8b7ccfe31d54f88d5a6d38c8b466f66760b967da3b9dbc9cccb0f9bf2a39b9ccae5c66586a48c5f04f1be63c38b940282800993392960402c4347eaf7253f684fda93c9f1956157da2ff00c53c9b2c92242324e7470765bcc3938897ef0cc299b8a992d18aaea235fbdd401a1a08fc244acf564b311bf97af08bd389501a4a80d352e2bf38e8a5c49b97356cfb73f596bc6f768fb4be47fed6ef1be5d330f23b427626e5cf184a0bd33f3de4b73271fcb9cd8822aafdcb1d2715852a1700100d8b5e3aa9edb6f689fb36fda7dcade0de79f27a47363931db0f95781c370df10f08f33b8070d332fe74f0de227ca963052f3fcbb10b9231f93cc599f266e264cb4cec31c4cb70af7407cb20cc66a406569d2182934dae6289b8d9b349d6a2433687241b50c764f8ae9e94e35f4e9c6a2badddb3d2d7b5887caacd5ee6a4bc7216a5105ebf13d7e4db47eaafb1f7da439b7b34fb6672eb9ed889d9b63f94f9ae251c11cfae15cad1fbd62388b8571d3128c6ccc3e1ca929998ac09d38dc3a494ea5e1f46a4898543f235c4b58297219c3970c602e628027726ccd78f3a1c52a5393751295ee9ae8eeb2be55ffc99f333d3db8aff006aa3d98783cc26e0d3c33dae7108f768c56171783e54e4537078ec34e02661f13256ace028a262149500a008720804103a13ed00fda95ece3c75d9079bdcb2ec6591f3e386b9f9cc6cb51c0b92714f3338332ee19c9b84b29cc7de4aceb35918ac2e618859c5a30c9549c3cad01a662c4cd4d2ca55f07d93f104fc5e512b2fc52cccc4646851c015fc73308a515ae503ff00b2944ad2364ad71a263b1eac44c25ca46d5607a47d8eb757d9ef7a4351c3e9c94256928ca72972b5bc5bbfa5caf176b2aced9367cb2865fc86a98e9abc6cc5ce9b8d933662d4573664d9aa54c98a5175289672492493b9318070c92094e3b0752e754c506f9e98d2533c69b9249601e89f4f14ae66a27a061a7a563c3adc5b4f27cd2a577f9cd7d41cd356b1bc72f9484cc96f9865a0114d6b584f97c31f7a7ecd4fda65ec93c98ec47c91e4976bec373ef8839cfca8c8e770063788b969c0980e2ae1fcf327cbe7aa5e4389998bc4e61879871030664ca9a9d145487d4410de7f5266a90a076b80e4b78c6bf83cd6761d2a4254c825ea6c63d2d1f19e15a88468ebb4eed1774d4e49a6bc3e709c656727b1e95f2bf6a83d9732719a91c3bdafe6212bd401e54e432dfc2b9cc7ca67b727da8933da7bda1b29ce396d8bcc720ecd7ca6c94645ca1e18e2d9a9c9b3dc74fc4a12bcdb3bcc700854d44ac4e2260f749485af4499291abbc447e07af365901d571b9a457fda666274eb700317a1fa47b94f8e766e854757de8e53e5714dd5962f6d934d5fa5fc1b2f6a6e5e9e4d79394623532f34c8bbc681799900ff00f538d72470d4f9a12519c70ca0bd35e70a4b3fff00d231c67367ba9f504805dddc4676173054aa953a5e8f68687b4dc1295470d46924e3e559a7fa0cbc2b453b3583f61fd91bdaad7ecf9edc7c97ed27c41c61c3b3397991e3b15c33cdcc8787f31999af1067dc319b61a661b32c3e1708654b97367a09933a525531235c91de178fb8995fb521ecba99855eacbbb46cc5249007f7072b41982ac6b98d3f9c797eab3456a428534d52d436a46a1278827210354c21c333b935bb47bf2e3fd81d7544f88f089cda49292d5548b493bd9da293cb7f3b2e9e99c9f345fce7a3f7357f6a4bb0748e02e61af931c33cee99cdd4f0863872bd7c75c2796e07830e79324997805e633e56357325c89531499ca5265adc4ad2d571e7ddcd1fef3f30f8c78b3983c63cc5e1ce25e2fe37e22c6f16f15e7d8ece3153f1d9c663984f998ac66266a9525f54c9931659d806028047054dce272a695ebeeb3fc56859f9a99b2d409a3329cd4f8bc1769bb1b4a8d5a1a3e14e2e76cbd45493c6d96b6cb76f16c735272e6b3bdbc7f71b865e4e994a65f11f0cb0374e3310a07aff00d146ad2726c36a4ad5c57c2f2aae754ec52a9f2931c5536712b3d0dea47cfce2e978b9882da890dd4d6d1e669fb5bc229be4a9a1ba5b7dfaa78fb5145592c7eb3ea63d87bed9ee5dfb2fb823b4172d79c996f167367979cc5cc301c7bc09c37caf5cb978eca78930f2ff0071c77bd9d8dd12e448c5e15320ae6212b515e151ddde3be1ce7fdaeee37c662b33c27678ec7fc0bc21819d853272ce20e6ef1d6338d3887093481fe7fee783448c296aff0096a2478c7c42e1f33992d440595023bc096005e32ce6ab22aa2492c54f6dbd08f4ff00959d9bada87c41709a2eb3e54dce75e69f2a49370955eede12bf34257f660bc274d652f69fbf3da73f6877da4fda2787b8a384b38e6ee53c0dc13c5d944fe1fcf784796dc2d84e18ca330c1e251eea761e6ad973d695a0a924998090a31f8559e71ef12e6e84e171f9ce37f73949089780913060f00848760254b094fdd1b3f1399ea07be496667aed58d127e214a53ea70433b352b48f338b7ba1714aba67a0d0545a7d33de9d0842841f9ca34630537e73e66275d2f531ecc1aa4dc7808012a14fa83d634a5e28a89248bea6d8ff0028c15cd51ee807f88106a2918ca98c0825ebb78b08fce355c4ead69734a59399cd99b32728ee52e7735feb1893269510e7bc2809a452555145312e082ed7680541d2e92c3ba524bb8fd63caaba9949ee64e58215a89a923cc54d778ad4a37a924dc9f389ab7f88d99a8a30a48b7c2451ee37b471cea5de4a393e82929776660c5cd09eb68505815020915241ad218d826c5f5151a9368068a00177156b758e794a5b140b23f894ece033bc29200000d99def007c43bc4006b486510c348a0ab3bfcde2976d5c04ba5ba3005ab0092ee5468977153ead0ae490e2a433035610c872ea09ab6921f53442780c00f740724153aa9f8c020333b9b03b880581ee9663defd20249ef125fa8624c100d0a9c1626a5e9f7c5a0822fa411a59afd613e2a8f939678615721825f48dac22d17f382c252ccc5c50245bcc7e9042a9404a407d36dfa45458bd58b508a8860e121812c6a772d58d16f624b906a1b4bbbbddff009c5e970a493de415331a7d231d2283ba7490e18fe719880001a924396626cf68e983365e272ff23e5ebe71f2a25a454f317271a4ff00e7b2ade1191da24373d79c6086239959c50d3ff0c9b18fc8e4ff00cb2f291209057cc8c992ee5c3e3a50fce337b48274f3ef9d0829d5a399d9ca19dbe1c6cd11ed5fff00087fda7ec22ff00e00980b92d472d188b3e3e61ed19738b2896236d31887c99f7b0f578f9aadeb1cf2f59891225a2473bbf42a1a83e20c16601c5e00bdc06ad6044ec0cb48f85d40d76a5a3b2dd938ff00ea89e5069351c652086b81ee67fe91d6746e59cd5af1d9dec8c9333b46f2712cc55c692039a3ff00933e3e83b3ff00ef6d25ff001b4ff4e275691befe1f9cbeb46d8e6a057f897cc948db8ff003846a34a0c7cf8e299e13a94c41015a587c4dbc72cf35c28733f9969141fe21e72f4a7ff00143111c4d897d45b7a951fb5d23d1e2eada8a897c697d6cb54f58d32617269a40538510cf150a6a16ab006c69678ba613527abd4b356f18dde1a838723e2d5dd023e7a78b984ae86d4c155203b009fb36dbe708aa51c6a3bdfd79411a5d8816662eeadef10970a00135daffd639e4642873560da7bc122f0a524f75d2775130494be9a800bdbe28228d43ff541711974770210b4b00da5dece079c420281604b1a35950efb35cb1dcf8c0715d246aa1716487abc120284b12cca236b9864b6a48254c0ea2e69e841413462403f4f5e105ea0d1c6fb1f943a5fa82b15246917a2879ef0e425c150069a580ac42c4ea76ae957892fe8c07d340c092c0bba7d342d9c814a4120b3785ede8c10424a4a598d8b3b41b24b1b1a126bfce08a5aa41a3a59220b20843bab58200bee4b4210ad406a0c3bd57ab430a900300ee40884814a120fc40d12291092eac10a5c5186a762ee456df842148bea2081f6af0e00a6ef56b0f1804803e177a78c1e37040fb81a8877069f2852091ef09b864b8a6fbc33bbb7470e19e0101c6a04b0f86e05e271bb01054490ee74b848a7956202e6afa886feb06ef407bb77610896b39ad2dd0c4641090fb00136b0786625988a160f7308e90e18d4b1a83d6a0416a84bd121c12181b7a683df2020242ae0ee5e80c310e5c6af762a48012d78028c5dcec0966bc02ad9c6a7abdbcfa7844ab20304d490c4b74ac382a1a7e1ab9059cd0c2920268580373463e703bce188200a3866894eeeec19d2564107a972a3431fa17ecd7ede7c7decefed6bcb5ed1fc133f118acb7239ebe1ce65f0822719581e6170b663a6567193e211656a404cf9248ff2f118692a0c43c7e75214402f400f4bd6e233a52d0a097351553868d61356e42f196394f69be44f36796bda3394dcbfe7bf26f88f0bc5bcaee6970ec9e28e0fcf30b344ed72a681ef7078803fdde2b0b304c913e4a99485ca5022d1caf365265a81a2766bb9f18f2e6f63cfb6eb9cdecc2e289dc119b60f1fcd9eca7c699ca731e3ce4ee271e2563720c4af4a26e79c2d3d6746171da024ae516938912d217a54cb1e8e5d927b67f665eddbc0197f33bb2e737387f99993e270c8c466dc2defd39373378266a901733079de41314311226cb24a4ad017294ce898a060d38bf48ac938bb33b3c46b735d40548a14d3f9c55a4a6c000d57bfafe706662512a6aa4a941330774a48d2ba6cdd45602a62569d42e03a8bdfab7dd100d1f34c4040090eca146ebe31b3664f75804b109203dedd3ebe71ab667393ef1c7c3a98d7c4bc6dd212a51212a22c9254cf4b91b758105e80167bc06a6b740e2de0ff00846a52659ee9293b69550055ff0006da3125215a6a527bba86ee28ff00d2352c3cb2a5a74862a4b90ef67fe5e10065484296a4b90a056e482e2df8fe91ae7f65e166242d5224ccfe126524935dcb7a78ab0986206b20ac580ded1ac25d0862a517b166631578c93bee69c9c2ca92bd2994948660500cbd37e919f855e2e437eed986638524d061f319d2121ad65086285ac92002348d5ead08e12487d240dcb529138641a88e24e28c3a826571267a503bad3b32998a9447465ea0d5dc46dfcdb22c838953a38a784b80f89d133bca4712f2f724cf75937d4676154efe71aa2424e923bcf4f0bc292a7d3461f64885903abdcc1ec5dd8c798a26cce3bec73d9478b4cc1a26cccd7903c3d2e6cc71575c8912cbf8de3aa3c47ec6ff00655f19a92336f67ef66dc0044ff7a2770970e63782e74d2ee428e131280478111fa9a652569340fa9b4d8451ee92824000b936f388e58f8139388f909d9bfb3af655e0fc5703f66be45f2bb919c3999a50739c0f2db8564e478bcf8a0770e638f3ab158a63569d3141ead58e592a4ad428c6c960cf114b60525564b063463e3d22b9297592c14535a0a0f9f944a49611067243075301b90cfe3111327cec44bc36151ef26cc259056112d0002a5ad6b344a12015296a20242492401066e131334cb9587953274f9ead32e54baa96ff008355c9b011f149fb421edcefec64f1af604ec63c7b2e60f713786bb4cf3cb83730d4bc64d5128c5706f0ee3e5abfdccbacac7e2e49efa8aa4a14c16621be8b707117ed047b78715cc8c571b7611ec5fc6dee3951859f37863b40f39f85f19a715cda9d2165189e1cc9b1a820a7269531253889b288fdf152ca75194085fc66cf5eb25458397d8003c0436227ae62cad544d9281f0a458308c35289246a70d7fc6912e3c997b92d2587b88a51d46e43bb83dd8a16a06adf52ece22c2588077a8dabe3fa454a0492ec0bd5be11f38c9aea88000e3ec80d43fce214d5c102bb9829b117b93bc32b48609a3ddbf4862d6b815c9d9340c3a44142c5a95b5a01151534a5583c33bd2fe2c4811081181dd21851e082cc3524134ef7940d2e9a31d3b03de1f28043004b106837020ae9dc10d03bd5d89fe50411e14170291033d12588aff0c162c4921c0a015ac4abf404049772198b97a8881443243d6ec181aee223248dbc18f85842856926b5dcf5e90d80caf0433d4bd5da2024ab510c6e0b7480a2f4b6fd0bf944001206aa01473dd106ef8010ceea6ea1a8608240eea4336e1f6eb0a46ee452ae2182486bd52eecd129e6c00752882f7a69d86f11454c5aae6aaeb04ea5005987466536e6910a5560410f46bc43044fc4f461f0ea36f2880901d869d4e1eafe302a6e9a5c536829601c8620e9037f0a18b73018a98ec1c3d29101d44116342df80800029a921cd5ec7ca00b849045dd46c62ca60b2be26e0d1ca61a850e0970281c027e50afb3ea0ee46e7f9c4b0601cbbf7a8445b9b160324d5c280a33aa8609a258a8162e3487f5fca14b0626b7b87f288e429c1046f47f90829ecae2f6d8b0109a25d4f56bdf686259ca55de60fd054de2a2a20962c4dc8f5e30402e4962c18b1dbc045d4fc49bb22145c90a03c4d41f286a80e08d989142f159295172287a50d606a3501989ad28d12aa344f3651692149356524d3c373101248043115b5a102a8ccce2b4a3410b21252e7a070d488736d917cdcc897885495a2620b2e5ab5248db6fa17fa13164d5a4a8149225afbe849a90ef4f95a308a81b170f52443249f8094ff124f4eb5f1fc446b0af251eeba6e5a336b05c66280a1a1ea1c8850a20bea1a58ea55c0f9452ab86b126e6e7d7e30c749a81dd15205d511debbee39acf05a9985e9701ddaf0e2732490e15f100d41d4c63821945e8d4147850557772adb78b46ab56c853b19a99e92f753ddebe5487f7da4a48a6d5a81e71807512ce01b860c49820b8753962c0bda2fdf379459493337de9b850360a6ab43a671d4d42c1c31724c69e14039049003a40b9f38209d2540b13461e168b77f20a59c9a9a2710c029890dde2e01e91138950b00e68d727cbef8d350a514800b025c826fd6212490a254c49b5e2f1d5ce384c95348d50e21443920114d36f08533d6520153281b1b18d354a62002199cb889adef6b0ad4f93f9c5bdf52639b06a4279502497252cdb91fac219c58252540b333b8f01ebac6124f748276e8e6142d4e751a3307b1b443d4ca5d4852f9cd45388201725c162cd4f08b158c514b28100067fc234a2a7a28b005830b41517a12c1e8e5c3882d5492b5cb736306619ea219d892f52c4ff0038454e20de8cc08bf8c6210a53d4061527ce092ec124383572d6f5f7c673af293dc87248752897d4eecc00de03a8d4b0f938dba5a2bd44b8201b81d0412a0951a900a43162e6b6318ca7e2579ba31aa00ef33a9fabbf584b12e4120d2ae47480a51201014e03b7530ae921fbda5fbcde3768c2735b19dfc4b0d430525c9b0a3d6143a9ca59c0a002e214313a5bbc07fd9e9582ed6b0a86b380628db608c0d8b80198ee47eb00821c0b7931bc33920d46b357b8f57884b01a486d2e41eaf10dd9a0296b00a0c58921dfd5203302cc1be126e5e0395779ea14e49a78431514efa89b0b83e3157bec05029ad40150705bd5fc61812e18280526a5d88606ff009c0350f41a474706bebe90ece090e1ae097825f1815e90e28005022b73eab13bdb86028433521c92c03f74de81fd79402ee4100355f63ebf389575b020160ee2e0b33f943f572411d6c98549600a4a8816a34124b1be917ea6912bd61d48c42ac0355d980f187048d219802ecab9222b3520a028802e6e7ac3a8281ea4d9ea446d1b742cacf05a96d40d4806e0507e91972ca4a86a6207c41d88f9c61a4f7924972199cb56d568ce9440776539a8a56d1d10b266abc8e5ce49abddf38b94c581d3cc8c99492f76c7c9778cfed1a5f9f1ce85172a573433b58def8e9c7f02234be4b7779c3ca91b8e6264fbbffe1f2633fb43ab5f3d39c4adcf32b39bd3ff000c9b1edacf077fda7ec16f837381a650a8a839f0348c450a6a277b0bf9c65cc62542d5bf4f28c456e281ade3e9a3e66bfaecc24f362b62cfb4482e6db74891cd92a4dec2ff002894f0fc8401523ce1a8f4affd6b4483265b3150aa896634223b49d8e50267697e4b4b2abf1b4904d9bfc8c43d23ab685503205294de3b4bd8ec9ff84b726141ff00efd25a80ad3fd9f1263e87b3eafc5f496dbbda7fa713ab496efe9dfe347eb46d6e6e06e6a73452964a473173b090f76cc7111c413594a53b9041212febc639839c05239a9cd3029ff28d9d35588ffba188fe71c3b3c97580a2003de7168f478ce35552df1a5f597abeb1a7ce62400593f6813535b46311d02804dc2af192b5026806a1524d488a49bb92350631f3952ede0e792be520248215dd2a62e9ab691e11124036212c4f43009621aa145bc47580c48eeb5edb7ca309b4b732149292492ee1c86bf97484d7ab6340e00156f087592927ba015066a96f11fce109142055d89b98cfc2e070fb001d3b166883616367b12e7f2852521367172f0431a82fa4b136a4466c80c9d01d2c436e4b0f081b3302dbd5fe5048042814b86de8d0bf6886535c106bb445937801258518b962087021010428953a417b56b0c52a14667ef35dc5e014d8104009d89046f0bb01090482905cd5acfebf282010ca771a8053d034025daeeaa082282ae7c09b7afca1e1e20243163a5cf7bf8af08140513705cd3f1f5483a474f885dcd36fca214823c1de9527ce166b702ea1dd25c967d2290d470c000cf663d7d75801212092d6a39afcbf4805c2002091b824d619d98194459c823e7f2f5d6141ee9502c4d438a86f1870145c82c00f95e000e3e0a54dc8061b2b8054dd4d4b9a8579888922c40a9b8ad6000e834baad623ce0b2abde200530d9f7859ec8046972087502c5ac2090185d81a3d5e00eeb9dac68e7fa42925d440770da4976f1f5d616c00a9983020ea76163f28800fe10ed5789aaa1cb6a16ea6255ea924751bf8c13e8c04825826d57077894721cb8d9a148006a0eda5cb1bc10fa4ea059bad5505b00bd484960d405d9e2e42c0b90e4b92d4f28a140b56882964b559af5829212124115605b7e948957e84233d338ba424b86706cde51cabca7e76f34f91fc5b96f1df293981c5fcb7e30caa7a71397f12f05f1062787b39c32905d3fe749524a87fa561493b8223875cd08d83dd808713177003f50efeaf1753c7a45f9a5d4fa44e447ed437b4fb94b86cbf29e3ae2ae587690c8b0885ca5e1f9d9c012b15c4d312a0347fddcc04cc36215a0861ad2aa1209378fd18e19fdb10e39461f0d238cbd9ff00caac64e4a0231b8de11e7871064289ca0da972b0f3f0d3423fea95a878c7c5289a425dea2adbefb42aa628903512a672492c222eb0932b8dcfbdbe1dfdae3ecdb8f403c71d8739d5942d4ca5cee0ce7c64d9ba11fc5a6562f0083e5de8ec0709fed4b7b3533c124f10f03f6b1e0154c493325e2786387f8d65e14f452a46265158f1488f3a5f7cb2192a7a872e5cc58998b3a99400fb2f5da22ebab07a70f0afed1b7b25b890c992ae7af32b851730bad7c65c8accb0b2e4bb7c4bc3cf9bf708ed1703fb68bd95bc613250cb7b74727f093564253238972dce78527249b0509f86617fe268f27c13d6169502a04554f62632bfb4b1218227ad2db05149bf489bb6ec983d8ab87fda0fd81b88932470ff006d9ecb399ae7a41972d3ce0cb72e9ca2453b93d482ff00a4735e4bcf0e4a716aa5a78539e3c93e245e215a6449c979b59063664f25a8848c5392d600398f1669d8e9f3c25532615e9ef0d402c0f10f19787ce73291a552715324e8a8327fc9d3f300188775ed18b64f6d8c0cefdfd3a70589cbb30d5dd4a72fce7079815dec25cd2f19d3f23e2096a0a9b9167150fabfb3a6ac69bec0d2f1e295917367987c333513720e3ae39c8e6cb5ea44cc8f8d335c9d4822c5264e210c47511cff00c33dbe3b6af05cd933b83fb5bf6a1e1954999ef912f2be7ff154bc315301a952178e54b25835526d10b9af7e80f62b589f8703f78c2e32410a7299d8699298bf8a61138cc329f52e58276d612a4d2d58f277e10f6e37b5af821213c3ddbefb44a25a4ffbace78ab0fc5722962518ec34e49f988ecd706fed337b62785908958ded459671a842c12ae3de4e709f10cc50008d255fb8a285e27315719ea7a7823132c39050a04b8008d23d7e71691ad29524328121807d558f39de18fdac9f695e5d3257f7bf873b2af1ee1d07be9c5f2411c338b9f6aaa6e0b128a9afc2903c23b2bc2bfb605da1b0a644be2fec6dd9db3b425491889f90715712f0bcd9c9df4a3decd4037afdd12a4efb03ef02724275162970fa4d4030d974b9f8c9ca978696664d420cd989416129090ea5a946894800b953011f0f7c5dfb611c4d3b259c8e14ec33cbfc371029213879fc43cdacef32c964ab752e44a44b98b48fe1d61daa63f1a7b6c7ed08fb453b6670f669cbdc6732f2ce46728337d52f34e5a72032c5700c8cee4a801ee335ce92b56678c97f1032d73d2850590a4a85212962c327d1e7ed007b79b84b94bc19c49d8a3b13f33307c43ce2e264cdc839f1ce2e09c68c4653cb3cb54932f11c399266683a6666389d45389c4e1c94e1e5ba12ad6a3a7e013198b9b8b9ab9d356a98b98b2b5294b2a592a2e4926a492497b97de3131589998a9ea9f35666cd59d454a24924ee4efd629d6080c37a577f1888be5c929db2865cc6253b1abb5bd5631d668da6a6aae904a8bea21dbecbbbf5847240a9ef5a9785f3fbc814106ec4d1dc5e1dd8b300c2a286200c0ddc2983b86302a2e4824b51dbd7f3884fa817a849a3ee2bf382c092480e2e058c10a2ca7029b98294b01d1ea0871f38600a3bcfaac91bd4c28620b9b960e2f0c581040740a7996da216241b16a867de22d7f682300181ef78248220b2094a5ec3ce18e94d40662c52093789a13a5c063b6c6d0d8158ab825a940db8da1c7c140ca663d4c1d2c0b9a055842589d4fa87c2457ca22d6002e593b160c0d0d2e61800080b4bf91f5e8c0214e0804a80723a458ca0b0d524558dc44a5d015a92091a45c397a103c6084876aa9f7fca1ae926e08b54d2188a3004022a43c401140a9c875014f1bc1d2a4d81d3d097a406d2f5abb07153fd2189601813d0f5fe50cbc81484dc12e2841a881a5296249049f382a7d24303beaabc42f4d4012039dfd6d13b3c81c24b172a2086bb3794020026a491467a3188eb6650d45fbcf71e5048d20b5c0605a87d3c4ecb203700bbeec52cdfac00e0915623cdad6807e1a962285b731140b920bb57c60fc40362a06aab12188f9c1d9c8a58917f57894092027e2a90050432495129143d1ecf68276400351a500218d2de30349a024b26e4f4f5bc425400a024166eb5884b00a6201a920fcdda174ec06a312e348a789f2f97e1115d68102d472fe9beb0aee9201014ede3d5da254900a6b74bbc13406040dc10d470f4309d12962ea7e90e4acbdea1fc479400e5440aab4dede7137c5c11d26e481b81bc051b3a4300c43b923ce22425556db7259fc60a425f70db8fbe239bc00aa2c289052e5dea62209b821eec6c3a182a6d42a432b725da09249259f60e5ad0cee005b505121c87d22a21dd4181206afb3607d7e70a1fba5c501f86bb3c4a93a88d45ef729ab5a2dcd8b80850d4c285d9c8615a406dc10081bd4b4422801ef01606ff002886e55e1460e488952f1010e5a8039a121abfa458e3bc41d5a43920325444541cec59ddee6f0c0e94b0355519dd25bac4f35804ac54241a977059fe50144d5c2439b017f9c2d68037776112ad509ad4bde1cc9a03ea2c3b9a943ed36d110abbdee0b5e143d5c00496653971d60b90a4a7ed00edf0b4594804001c94ea73f0bb7df0c6e901292d7a30f5e308b00779c820f7b7884b024ba949a80ec05623bcce09b8c494fc275026c6845e07fa877802c0136fd7f9c053eec0bd039fbbc614d053ba01d4362a839dc82c2a4b02c497aa4381f3110900f76c28c431f38addc1b1eace08a9b410146c120f4b447300ea208af7554001b41043b8ef30a93dd3fce2b1bd2a0b13d6b0e038d2007776afdf07369d804d53d08a5eaaa6f01ddcb125e85deed4886b4614bb6cdfd2f02ada480e55f1017eb157277c80ba9449a249b97a4277535d44a6ce03bfa7b41209a0720d4a98eef014c18fc2c198543b0ac56f8032490ff6813703a5beb100200dc91614ebe9e1492091a74d69534ad62024d08622a075bc1d961801624690c124851371047d91725d88151e63d5a2026ae4eabb5feb080a9ff89cb2812cf5da236c303920864a48d3b6c6006666f127a7944376019bbb7a1f9400e0a9352054bd042d8bf403825d454e5c519a9d2910b2490438662c5c8f5f940720170e0d9de95e9041a8d29a2a84a7e13ebf285d7401087ab8a86b53d7e310b32405004172c9f8a2288a821824823f9c4a6c052f5b7844ac8217dcb24dd377f07851e2082ce2904b2894bb307d4d521ad04120339eaf7a0fcbc22637e802905d9d8339ea61aa0035606e6e6b6880aae5dac09fba1ced425bcc81e71ac5e42dd0522ad44a0ee6b68ca4124500d2ed773f28c60ef402b4f9006beba4654aeed45b51abb9063a22f37375e472df2453af9c5ca943778f3172600ee7fdba546abda365251cf6e726c13cc9ce0b0a82f8b987f331a672354a1ce6e53b129d3cc7c99daa5ff7e93bc6b7da552473f79d0c2dccacd9c587fce551ee25ff0083b7fd67ec139e57ed3af132ea0451f7b88c429717b9a358466cd29a822868a7bc6129ea4503f52f1f35a8b7398cfd62bb7cbc6244891ce548fbc10ee18b1f18104120b86a56a1e0b7c832a5060dac1d9a3b5bd8d34abb4d725d253ffaf8a5dedff34c5ff28ea920d5209ad4d23b4bd8f267baed2bc9c985cb718240eae70b8a1f9c7d3766bfdf3a3b7e369fe9a3af496efe9dbe347eb46dae740d3cdee6c2400e9e6567897361ff00747102385e79295a94aa851d346dabf48e62e724c4af9b5cd65172a5731f3b3d439cc3104bc70e4e2e092198b31bede11d9c66eb5756df1a5fa4c545e93cf566017d5a89bd1c33c5640497625c317a88b56749053a9bed589ac5254f7006c350eb1f3aee62efbf40f74bb5583337e70a1812e0816bdb7f4d10b07d2ed5377020ba8041150cec6ade11cd2f4ae64290689a384eaade168e4abba0860285fa7f580f4770e4b54540f088a0004b9ba9d9fef68cde1809b97219f50018c0048535189a300efebf18648228e9726ad5780424814a13dd340479c30d8010a16a9218787ca0a42454004eee684f488d42028827734f9881a45588735bd2215b600d4b249249502c2b616bc4a923bcce1dc0b44ef54062f636a74b41d340e7e14b96de1bdae0352080433b1f16880690039a9ad9ebd2024a58820ea3b8a80db9f94300006fb26c5cb986582162c14ff0d080c053a4129207427e176f0731012ec3485002bf6452d0544003a855d40e9f944b4db056450d5b536ab50ed03bc94b120d28c1dbca1d562da5ba1af5857d428cfb31788b3d90b0c400192a045189008bfe10c929a962af33bef082c42687502fd6b04805d92416ebbc182302ec069ab806bb5fd6d0a5a808abb8068d5dcc302192e081671f17ca09b7d9a9f8897689b2dae04516d5a99ba0d9a25815021826aece7ca18d76de837b6dfac471a48615a17f941f28274212e5aa916ada056ae410777ada091b025259855da12ae9662e2cec2d10975603f1077f9356210ba856e28e59ff009442521241b7506be6200d41ee0bb97fb505e0080b80093d751153e50402e3a24d18dfc5e10904ba8f90143f7c5808208767347de276d80d4a5c06f3710886a90c7620d026b1350605dd22ec5de08d346ab55d277bd618402c03ddd9c821c9308baf7a8484b103782755544506e0b93014435080d5aef116c0212129480cca53bbfaf4219c8219896774877a34238374a9fa6d03500d70c2a01fe511840b416341e67616104949058bd6a59f78a4ac02ad229b0376a40d60a745aaee77894d5983235162ec437473b40d40063f102ee2beaf1428d189ef33d0f8430245c80d5bd4c2f76073625d21a82b1609ac7e2adacde514ea49215423ed037ded094a1717b28de09b5b0320af5120166bd455e20511aaa07df140d21446a1d4934061c92436a0013b52176f0d82dd6dbfc47ad4436b22ba8bbbf468c72e9008219d86aab417f84820d6ac7d344a79c82f331c1621c9d2a045a15c258245e85cbc56922e537a9a335e239d4a00d0071a4b3413ba03152431a3bb905985de2b52826818d19da820a541ab52a2c1c5615c29440a55c51c061588bb6023487a84bee441005092492aa2a805a0298848007cc5a15dc249f8416a500886f160306662433f99f5fa4160454ed43a59fce206208ab02e14f6af483a83025c87a01137400948b12296a8a79c1666bdfada0066203ddda0924148a922e9665447b4014c45852a48a34129554381d0900b79fade0ecd6053436f5f28211a450d05c57e51292bd90148a8b598bd3785569605891a58310c21944b848720860454831506173dd0e0815837658058a040a5012c5f6ad214805d208d203b91eba43b87eae2e6c21080e40daa43fc46ad0c5ee003bc6e0105c107c22c2e2ca09367b83f38a85d80b0b0b9f1fe516eb0dfe907cb785f76054853b5003529605fd7e70c525d2e40254f5a0368ad44825cd0876b430a5c12fb92e20bcf603299c91562d5bf940d5e05c976a3f9bc4a3382c41a0def10855285887771478798210749d2c43ea02e2250b16f8aee2904558382c3bce59ec6212c121e962dbc2d77923a853548001eb535f0ac42ecef5b94d1ded12cc492185776a5a0129eeb80012c08b982b5c90b162e91a6c43d44040620e9208a95339f230484beea56a209d88311c0a3e90377bc31b80950d2e2ba68960c7c6200010400e0f57778504289a900160016fbfd5e0a491a827e21624d044aca0390414005350c5d95a5b62610a4924162c5cb900da1dd268c4015253627d7e1149bba81bf758dfce22e93c008a8243072c6debfa43254cc41040a02450181625daccc0d608219a8cf627f18592dc04a89054c1da81aa690a6b6ee901ca4d08880b120b27a7e9135100ea162d5371483f2040ec0866600bdd8bc4f77a5885509a835310d431b12e34d0f48242455ca40a56e2255f6408aef3ea625d9c8037843560412003a4ddef0e5aa2a137617f5fa4292010c5c9a0492c37f4d15bbc0203de6506007e03ac12fb51406a077358212478924b9156f0fe701c1208506059896262d6ba00147d44006c687f3872d562e1b71410802459856fb98848d9f529fbbb6d10bc405dec6a0d297ab379c11720b8203b1f0eb0a5d2e0bb035e8d0c2a097242b725cc4e5e0034a8b824004d0060d6dfe90491461a883621df67f18501cdc30bec61ea00054c1561d442f16c00100d5ec0dee61428529626acef0a54ea594b00c032a80c4f88b5dc7d931172021777513b241dbc6090a0bb8503b2684f87ce01a2598514037483a8a4b1b3814a3c2d9448e90ce4f7b60e6a08845076ab9ba852820823620b9a39a9782a604b0028d52ef689e6c8058e9a06b87eb5ac352bbf4a061158a28254d6af58672e010c08767bbf87d2231d41010f4371402a3e710a8074bb97a96a8f5f9c42c904a4329c307766824d093bd5926efd6270b60338605d813a5f657afca05c93401ebfce00b005493d03d13e71086512f46a11410b75b020604f5351b3de229d4f50fa58d282820258bb778f4788450bb31eeb825c521676ba010e7ba06ce14aeaf0aff00c7777046f06a6aa09d22cc7c7a44208776b51f7fe7588be6e050d704125d5e312e4502544eaf3f3820b062c1c3824381e311c001c3bee93e307e40894b1009763406849634782914140092edd621049171b97a1883f885436900867894f3e406209a06f2682433172010e0b5f6b4037a0d2f4209705be5112c49d9a85cbb43af2801a836a872e18982c08a871606d51bfae910b1774d832773ebc601d4c3ba0306a5c56f08f880310aa28175310453cc438ddcb805c16653c2d6c9019c056efe50c2814c2a2897fc2254baf50580bb289a0fb3b4310c490e9d5662c0d611ea58b1dc8b1fd208516092e1aa18968d637b82c0c038a37c3d632a4d0b0480f520fe2230c2934059c5c9b1f078c997312ea3a9957006fe71d30593657b1cc9c8c055ce6e534b7f8b99393330ff00dae931af769e484f681e7524d08e6566ce180afef06c236f722e604f39b94731ea3995932aa19ffdbe48f42371f6a43ffaa1b9d8fdd239939a125d9bfce8f762d7dc67e3de7ec17e875ba733a9240a1e97f5f9c6228351c54b00d5f5fac66ce1b937356371186a60c43a98dde3e62bfaed984bd62b218feb789109d449b7ce24732c2c95043026c2bbc0a03d403f5881de9f289dc1952a8d6510583868ed3f63d95ef3b4b726929a93c6285002c1b0d8a2d7f08eac200000604f5f9476a7b1b929ed33c9929604f19212e59eb85c50fce3e9bb318e37a2feda97e9c4ead227ef8a6ff297d68d9bce343736b9ac9b01cc7cec298120ff00dd1c478c70fce7256149ddd3e0639879c64ab9b3cd627ff9a3e76fff00e91c4470dcc242d41f482e0bb53d7e51d9c6bf9dd4fce97d6c9a8d73bb6c61907ba475af484539baad4d29b78439b77ace74d883e71594800ea604d98b903c7d6d1f39256bb30961a6565ca6e593b13f74451201205d8b5f78b090c01218d811f179c23020f7801aba7e318cddd141485281a10bf02c040634b14ee4d0c58a01e8f4a1a82fea915907ce941196cdd881881a6946bb1fa01e10a1aa497246c5c402094a43eaab916727c21f4804359988dfa34555fa82066352db1678857dd2037cfa5a820124ba9c00ecc90c61140904b0a9a5042fd101f50d40024b06486607e712e189d25ea6c05368448fb2e029fa30111c575136a822e5a906fa019886f02e46986a80029b49a802f153b9352091e693ebf387604860753d777866c064aa95d4037f0d7e910172433163f083488c5c30a9a3a8b8b441527bccdb8143e1040828c01ab3bdbac0b2480c69b923e5014a2c281cd8341e80b0268c454c4378b023924060126c6ca82357c3a9d363bb7cfe90b470480e4d051857ac10ce4310417eed3d6d05b8180093a99c7c2412dd2052cd7a87bc4a3104021d856e3f944a3866176f089bbe801625dc9237a4105c9ab06eb5f9c4a106808372407de10822a120d1fa3da195b01dc9140686bb342506d7492c1de1b4b171735241046ff84022a480016ab51a27a5ba0148551f63bd1e212ea20bd038e83ef86502a22a4907490a2e58c12974f75831aa6df7c42b75000029dc126c08fb43c6214a9570284316b0ddfee82da751aa49dc10c7e510387ab821dcdcc1bbbc81480458900d523786d541dd20870287e509a94524a5923a82c52290492402924817a7dd0b8f302451dcdec2d0a43b972cf54ee2db4585c03415bb33c23a41d80b1533bfa785decc11dac0fd1c8f088e0bab48f10050f8c304920d0313476680c0872c0a4b1091e11190202a26a297f0f08621494d6ae286cd0424baac03baba880d65172c74b10c4faa40008e8410d735110dcb93e34a791884050d4586c000c6d103329aac2c45056febac2e027ba183173715852cc19dcdc13e1040d243871b7f38663700104d19811fce095c0a120bdc1e8d043a592a008ebd7d7e70c12400e3cc16a880e281810c18f589db6dc0e68096a5fbb50f485059c104b96034f94024004512684815104125dcb5dc90cd1008680801f50aa535dbd1880960e9a115da0023ba4d54a2c583130c4bfc468aa0a561bec029152cc40a92efd6f00b85060095071a8de0b101c5921d469f7c44b28ea14a5413f844ddb029dc3ea04b126f58b0864d1ab504d8c231495742e1feb483a4004294e08052920051f385d301493f69371500d4c28a1046c3e901458b33f90a186d2148764b0fb40d41bb4100543329c37cc188402c4d006d2d781f086a6a22ba5ab058ba4174fda04b3907f2fd61ed030a90ecedf6be326086714505135e862962e092f46b3b4327e2352bee1636ad2d056e80651725cb3d5855a1493a967e601a4369294872405170edf3a4229209a6d7142fd7f083b5c1600012c1aad504378faeb0a4a424b3b9b102f7896526ace0eab106b631021da8c5e84d8de21d800b8003d6fa9ad48012af84354d0dcc58ee08a30bd188fe510d417604d3a035bbc4a5d56c0ab4903bdb1a02280562c24801833170368574b00a25f724433382c033b312c0d1e231604efd090097615b4290a737605c017b41342036f707c7f98872e0904d012e7789b5b717112fa4b8215f69e90c54e2ec0a685aa3c8fe70aa0e8258b3dc1b3fafba02811714029656a865580c096650a69a9da2067720dd8351be502ff0ddaa6d1090e0b1d243160ec6092780124d881a94e58529e31125d4a1b6c08ef52012ddd7202aa5543f7fe711850800ec35066f0820002ac9abdca857d52189041d8eee4907ca2004dd81beb3f660b001a954b10c003d2216c00efd47dc4d76820b6aeeb035eebda2312ee4136009a27a7e505418b1d20900a4301b44e1813ab82011402c2d5fbe0bac9049716b007e50012753866a3b8a888583ba4d0d053f1f5786cc00866b122a6fd218024935d26a1ec6024f40188b3541eb0ca20124339f86ae098249e6c02092e4120122a05a0172c5a80d457eb00306d5637236f38525400255de360edf485ec0655d6416ab1ab8221404e97a0621eb454157fd9531e829e1008a38661748602af10bc8014a041d20bbb5030fac063f1005405541acfd220234bd42892c41a8a5a09075003ba0d5c5444d9ac80909492aea2c07510da9c506a0366723ca1080ec183503d42af1038a0a2851476dad057e806001720122e6e34c42402eeec181163e3eba41034bb17165060088019292a6749bb877a6d0df6017ab1672a0e7ecb085245c023493b508f182a090e121924546e3ca250820516082c2ca1bc46c05b82a2f5d88fc6082aad010d7058a8432924324048481de3a8105f6884024a483ff005410cfe7f589bb5b005a82a921c38a8f2841a88a5c333b8de2c614eeb75b55a14b24927bcf63b086cae02e12f7b3174dbe709b51c0d5726f11c802858f5a3ff482e2ae0806a0445ba81c9043b02e0356a3c6002092ce68cfd186d08c0d1dc91a9c867874d5008f2f06686fb800507497a13e660b9656cd6605e0809350079b5e27f135c52ac48894b6040c9292a77374b778bf8c12daae537602c2010e0d2ad42557eb042812a0402e0b83529689b5b601760cc03077fe277bc290faa8a34bdda00034a455aef42778150a5800bf47daf119c580f4a6e406fa1f385214540b301b1a7afe50e52ec54012aa3866bbc2b0a93d34b50810b4930023512c4d0514df3f5e711258915760050900f51eb7824519c00915d924748090f5bb9f00fe306ddacc0d537620166762f0144252cc6d56b8f382521ec5c5d80805df7a5dd89894001428002e0d080cf0d7a35ea090407fac43fc5a5880c3bc1af488ecd5d2a35ad8f97d616c0202007d3e75b40d45c1dd3f67a442a667352ee916fac00eea70013666ac12b3033d4ff15dc5bca192ff00110926caad0428bd5988ab0ef303686629214188559daa3c7a44a59c2031a82966ab950a13d220068d55743f64c2eab696480760de845a43e9f8480189019c7ade3540ac0776daacccd1932aaa208d5a8107fd3e9a28296248dcb90c045b2817a8028c40a8e91d11577837595739839227fe58394ee7e1e6464acc3ff9e12637576a2ffe386e7555c8e64e685ceffe746d4e4b06e6df2a9831ff0011f25d35bffb7c8fd2372f69e255da079ce951751e6366869ff978f7a2edc1dafeb3f60b2f54ebacd51d44ff00aa8368c4586ea402e4d8465cd0ca60c4bd5ed18a5c8150ca55b711f2f5d5a76309faccaa24421a862460546292ec3ad223100d496b35844152ca7ad04417fb99da1b832a433005fcf78ed4763b0dda5f935a55ff00af8a4b91d30b8afc23ab324d521980a07378ed0764199a7b49f27161d3ff001c6587dc3e1b1223e9bb309be39a24bf1d4bf4e275693f0f0b7c68fd68da9ce84b73739b090e1b98f9da5c1aff00f147111c373d24a54180d27ba4de39a79d842b9c1cdb212e0f3273b620b01ff747111c3b35274d40d5a9f51346e91d7c6efefeab1f094bf49933f59af334a9950e43ac509058d3d7dd1092027bae08b82ca8be6234a88d2de637f28a496674b8218758f9e9daef0633cab1486624ea26c3c60bb85020057d92eff7431700971d7bc2b15f8171bbb5639de55ba19dee467a3b122a41a089f09d2ddd02e77862c469ab5aa18c282eee086d8aaa232cb582001c002a18b01d291002424b9492589da0d455c0f167e946880853dc9d42b51e85e166924801c80a014052a93410a0001c8d41b516da1ca43967e8480ed10062e77f363f278af90069048218d7f126201f648ee6cc5e910b50d5accd41f3de01703bc090f40ec479c4e77605ab0019c9a0d85af0f649296bbb7da262392480e3a16702000c5459eb5028d1365b808009bb0dc12c07aa432458b90900b001878400aa9d21ca03d47ca18104ed51a800e1ab1559790040a77aa4974978552069203809ef3d9a9b45c970c48005cb0668ac9776f84d0122a6913d33b0012e58b829163b5623bd0d85c93bd778247782410eff0011a1101880e58d4b04d5c4479826af858925ac6adebd788516a11467726a2225037775740c4fdf10bd198076ab9d4e7a44dfa8002594ee1207742adf28055d7bb4abd1e0dd81773bb505f782a0f4671634aed116c0142999d2c1ee55610c43bb8772fd02a02921c3d81a0258de0d6a28483560db44dfa8181a9d403b5059babc2b554d52c081f9c4abe9510e43b8143101531762135d572a6fce26f901554b32922e0eefe50849d41f4863a4ff00abe50c4864908722a3ac2164ab55dee801d86d58ae0054e0b9615a25a87d7e511859f483529bb56269254013e205a230517e9b56b12f396027c01346715da141d21b77a86a0870c1d212ab3e921a01341fc3f0bb57e758663901a95774b060e41602004d14051e897b9a0f4f0428228c47833bc30629058f550dc8dda2300a998aaaa2087d5d6d11d4a6ef3816261ee154bda8e22b20821c12dbfd4436d80c4b28b9d4e1893502901aa0312406706a7e5109406005087fe2021e818d9a8c4b94c4acdc08000a218f4048a0825cd00f0706bf28377201705c182ed5b78b338bc4618200f5a85587af5e71050024bd1aa221480685c063517722903bc49d4084ece6b1657b5d821b314936356a4072487a9dc1a110c0514c4870ee437ada026e031f32297eb11b809150526a36b0809d449a101cf741a11bd60f880a2f43d0431a020bf50008949257b8108514927ba2cc1c9de23d4848b0d2c5c7d20d7a382c4873bc4092e5ec68295fac46c3da47094b390c6af5786bb289abb3936f0850069017d74bd5bf5821cb001836e2ff002b43a00a9c386b9a3177785d0024062080ee76825f502ce19c0b11d2030676b9ab9a83056f0016172c48a125dfe70a5c12d735ef574f941208d2d50ce770f04a43821c1352c1c41ac010123a8eac5cc11de04b815bbc42e976767a822bf3866a1dd8d031783ba79044519eae76a02cf10d002e451b574886858867ddad084951555922a7bb527d7e311b0f60c9a298a81a3b9ded0c00a38bd98bb4554735a1dca6a59a192a05468c4a59c390d12934c0ca218ba980dfad9a911c92eec1ac6c6108a3a41addea7d7eb03a120b0f035ade17b3059de36a17eb4101cd457766f84dad0aa247798a486ef07a7480594ce4a802c6ac488356d8163a486b94977dbd79c156c5d86e953f7bf9c280c5838b9621c8ac3d0821cbddda89a44dbc41592e457ecb97b0b445007490a569dc91588a0e198d43955e25006d86c2910aed580ec401a8ba8b17163d1bc600500684804b07dfc20822b4554383f643f844709f10ee192e01f3862d7007bba40734b8a59e077988777becf0ea6a80aade81ebe1128ee4109346174f8c4f2b4b6c812853b800b14f482e55f11723e12d455a904a52cc028354bd5de1989054ec1ac433f879c5561dc0be67bc4d43d0d5a0101dc37c2ccf54c5952038d2451921c8f168a9c55bbe41653d22407a804bbd5bf289de490c3e77fac02ec5c50d433a4fce220b302e03b6e5e0967000f556ca058b1bc3b30a333ba4dced08012e483a4071b187660e2c6ef46f9fade197b010b8092a26a2c03830a59c6b762680dd3d22cb90e6b7ddae610b92410e01b02deb785baa03d8904a6a682b0002417d2de05be702a4ba4b11e1105882e7c41604d6d1384d821722d4146e9e27ef85234ea0a26b504ed586538152e058b3181a40770edf0a9cc57c80d4092433333d610a8900bb9fb4c61ac0d8914259dbad2143a81a38036eebc4dbc00e1dc9fb46c3e7115acb25268403761bec600d41c962ec901bc61f60ce43bbb5e0d7ce0449a17517bb1b436a484bb951675001808426ea000228fb17825dc0480dd48a1826fa81cd28349a38feb0ae1c81a9998814820a4a9989a3d9c1842f5294901daefa60bc584ee1b3e901c11a8aae2029c6a605bcef586a01fc44f835af5825c15123539b04b183b6085e4562af501405ece2269aa81ad1c815630ca0490e08617ea58c41aaa0ef42c1c888c7c849010412cc40d2092ed0c90a034a480d72ee220a060c372554788a00d0bd40722ade7136b30162ee1ecc0014bc03700b0d45ae43fafce08006a0d57677f1814702efbaac22364055125b4b52aeff000d3a43a4b6c12a3f112fe1b40530670c1dd9c92584564966b17a076689594ee0b080187cc1350ed0aeca00fc24316dfc7d74854a8a695a800eef1635d44104ecce6d1390297704331362f4aedfca1c3a7500e01b9767f0847013626ace12435625093a9c1b245c442b78821ad0dec904c404820155e8f66feb0c5882aad0b12d578375382c906ed0b3e805625d892e2897a082412c2a0b354bbf5861a9c9a0d228c36ea600af897a519836f0bf5600e58ac8aa7e6989ef29a94e36726b5a7eb0b537d4cfbc13570a0c06cec0f9413e8052ab96717077eb04d082090373d040614045ee76bc3f75c101f51b5844fb0101721c3d5d2e7bc6b0ee6ad4d469b9348ac248eeb6a2fb1008786749620e962c7a3c5a2ee071aac525208f85a9b43ea3ddf0b87a4569a2c82e000f5a82f0cb0ecad2c016a02e7e51a2ce00e7ab3bdb73fce322433743bd5bd7f28c44ddd2e00a31778c99001531f849715aecd1d3059368ec72ef25d413cdce54a94da473232524d5c7fdd0931b83b4ca92ae7f73956f7e62e681245c7f9d1b73936a079b7cad490cdcc5c9f663ff003f93ebeb1b8bb4a241e7c737cbb3f30732511d5e683f9c7bb1bfdc67fda7ec17f82cebd4c09ef3ab5746368c12d5a105f72ed1993b70c694716bc619af9efe31f31a8bf3b6612dc525ef1209dbaef1239ca8208a55c0daf005c79f9448032a5acd0000aac49de3b1fd957149c2f683e504f9859b8d30e80c4554b44d427ea540475ba59662486fc23997915992f29e73f28f3194b08385e66e45349362939a6190b0af0295a87ce3dfe035551e2da5acf68d4a6fe692674e95f2d6849f492facdc3cf4c39c373879b124a98ff8879b2d42c485e326afff007efbe3866610cc40657c22958ecbf6accbd195f689e7260129644be36c44f96f6d339089c09f92de3ad13432d9e876735b6f1ecf68a93a5c5f5749fc1ab517cd36bf51a5656ab25e6feb30a631d45d80eebbb3f58c55afbac18b80ca2035232a604a8000073bf48c451d3dd22c360efd23e625bb3092ba0129556c0877363d61541d941dcf5a9a7ab417551ea09a245842924915dddec6399e4c42414929a3a8bf91f55842fde0d4d2ce5a200001f16a0a05cfd1e0b1afc577735319e16000b94821a8054860617533121bc2822c7ee80a2f5773bd2915065151b3901c37e1156ef8058077aea01ac0b6d11d831201f2f26fca14950bbb69b835f9428a29d454aa508a400ce000c438d99c8852a15218bd5890e0c463a8904d4d18d62100000916b837f2fd2196ae0940c1d2082f52e1a09513a81bd811bc2a5a8ee4bd7607ce2c2010e2845407824dec050ee3bc025999854458e976294d0d0d942d15a403624b393d2d7870e7517b50249f88d2b6b415d600fa8e94fc3a429fa92ef084dc8087ad1ecf1039d3b0142c6a0f94070189ef115049722912b2b0c10070f4245dc80407b41704902cd7b3985d205492a0d577ac10fa4804d430f0f9c42f0b00062c1800285ea22101ddc02f404f8c14924549b103af9988c92ce4503bbd4f9c31604040ba81dc87a88055400b124b0dc9885fa778d41ebbc101812581258ee2252b0159e946350e5b78605406a012ef5513430aaafc571706c5a2390c525da841ab78457a60800726a6c0ba5ea21c3029481a833b1f2dfee856d45c120a6aaa43900024d0ee59dfca194ee482aee08727734100355c8722b563f48897003bb9a01f80f280c0921e8815e913d6f7040f6d25494fda0ce079c3d681b6b03b56908f44bb970f43f9436aa03a88162df1757682b5acc0d51de6ad813680ef521205ea59fc6210c030552e6e4f4f5e3006eef577ea219c0092eaa800352a1c5da212c36245480c4da0aa8051c1b31309bb8243d49762217695810067d276ef12c407884ea019ba15509851426ba4ec5261802eee599dbe710d814269605550492e0d36fac1b5ea59a8c7a4109d43492091b93514b7df05fba03287798817bc3ae008cf6353bec3d34316aea25dd9e8c3c60b90ee5d22819eb7db710a48a807c6b6148303b788a9e80935fe7f7c2ea20d81d9a8f04036f0a10ee2bb412402c1c280a922be512b0f208da40b546aad6003a9c6a17ee81635bb41764814725eee610b397a528059df785962c06a82eeee18d9bd5a0bbbeec3ab9680924a4b960477837ded134a9c92c2bb5d4217c580424245771d7f2804d34b81476b3411bea3a7f85eefd2df388c482ec5a8140df7ac13e800e9662e91724dcc29558bf901503c61c122a56fe0924b7888aeaab2812e6af5f9c15acc160600177a508a7dc6001aabd6b7fba11c1212491460d48b28e000e94821c3bfce174f2c03ba9268ce03d6bb41762a142f609a18868c4834dc0248b44d4039a39156a183bf500047783862186921ecf783a801a4977b9b905c5e00203904148b81f6be50183821c1d4ca677bef0bd9e013507a00183b3b13e5159abb0028ed48b34d6c0d6b7bc070920b8538b26df210b011aa038ad18eced1624b034052ece43904446d4d5662e75515e4609d94e41621bc9de1d7008a34604599f71bfaf38535624b822c2d783dd2c59c8b78d21d8d534bdd9c3417982a3525dc822877def10313a8877141630e4775c8debb931020f78b801a8771e30eb8025a87a50bb0f2870aeeb6c2e7ed12d12a40d4416beed5f285507f27a69a97f2880422b52546c188fba0914d25aa6ec1c37e5006901d892f53bfca2cef35d9fe11bc4af3056a0de2c6c0b12fd2090daa8c93b9670fd7c20ad247da05b751603ca1762972680b2853c609f280920960c3c48fac0dea414283bbb357f18897268cb637a9a7a1049a32a897b549f083c3c918412455c96151b130dac1ea54d4029a611ea54090521c3fdf00174b82435c0152217b12395692c482ece5bc6911cab49d370e5e84c56492c0aa84d3a8f4d0ce410e5f50a97788cec0b0903bee9722ceefe0d0aa3f0d123a80180840f62033b274876884eb08701c16a3fcbd78c5ae062a0f50fb92f44bc42ce0ddddaa1a0004351944d5b6a7480c48d881bbf43109b590473a4963aa836621f6857a2493f0a7601e2c20949258f79825dc1bd6233339671f0b961fa79c3a00394b369721c86715f5f7c420943a40f120506c7ca2105c801cd8bd41ac42c136218f799de21ee0854006a30a13b440a49b52aece0356154094966a976d85a058bdd454c3a5e176b20624b5748ea371ebac0501420d4dd408616a4021dcbd45b4bfdf0e7e1075501b00f139ea0048ad9c31215735bc3380280d6841d8f8c2b92bd409b3a762220d44125883d49fba26d740243d3b809aab730a4b12826db7f14162926c49341d3c60901b6528872496f94427d1020fb412c0b51ab06a94966bd5f71e778a8248d94091429fb5e70da983ed676fc7c3c222f9011762cc776b411a837992140b98809e8cfde3e47f380e1cb3a45c30ef44dc05ddaac4d0b529ebf080080a56c0d43b55e228d05d8fc4f7a082f47a956c7f07886ad801762522ae411472218da8453661dea4280b090351a1a921a19d9c122d4350d48b62e002fb9d8824102bb42b329940824380581f97e90c583bbdeafbb7ca23b9df5062955c53a42f1dba01096b0761a48bb085092a228407772c0de1d602dddca8077bc01a803e7a680b4317bbd80c800528e0b8245440002450d496ab6e21924e92a258a7ba43e980ee9a16068caa4463a80d8e914206c5a9e1e10054d59ddde8e2f001075966482ef5ebfca2205cba8034f383010490e1bcacf04dc30058025e8d5eb00924338a75703e50417be9722b5245f788ceec07502e1cb5c5431f558854480e01f90fa9804e91a4303f6402e05dc3c00a622eaa587af4d13868049a9676dc3b88014ecd42af84b447218a830aecee211aeddd2438d4e5a2d7ba03071a8807a30670f0c9d003120807cbcff48ad3a5ca89248b5b52bca0a52410a05aac2ee6213481610039a7826c7e91582cc5b50517d26a4c43f1172a0a21a81cf83c3354837029e3bc5b760bc329954703e11e3e3116ec05c2a8496f94221803a95e43657dd16821ae43d149b867a46d05925103071e1e0cf1912474b8a82e3d758a8172a6012e9a56d174a15abf4e8f6731bc55ddcd92b2398791d8638be7172aa424395f30b282c19d4138d96afca356ed28cae7d7386840ff0010731604540f781bee8d63b2ae03fb4bb42f2a70fa153132b8a138d290091fecf2a6cf7b6da01f946cde7ce669cd39d1cd9c7ea2a13f98b9ba52a1f684bc64d940ff00f538fa695271ecd2acfad692feed38b7fa46b6fbd5fcce14983bce58757348c3203d5807a1158c9986aaa173b92c631943d18f8eafeb1cb3f585b1a6d68905a84bdb6eb12302a406b605f66896f37806e77f1bc1077a1f3ac01720025ecef4168dc39063e76559b6579a6196a46232bcca466722624b290bc3ce973d2a07a82811b790c4576b11bc6a785a900b00a749a814551fef8f4744da929470d7ea35a6edb1ddeedcb819787ed13c558ec384feedc4593e53c412a624389e99f80949d40bd5ccb358e98cf41d4a2ede1d04776bb56c95e77c3bd9cb98f2ff00cdc3f17f26b0b934fc59502a9b8cc9ca644e0a6abb2dfe71d2a9c97490007152b7ef1b50c7e85dbba318769b5b529fab527de2f6554aa2fa268eed6c54755512d9bbaf96cfea6698a49b31276ad9cfde231d892d76a9eb196a04a890a0142db18c7586240a129ef5847c0548f91c6d5d58a141aa9077706a761159b035a2760e5cbd7d748bc97a24015b8a93514f28a55f1288daa3611cb25968c5ae884214cc2c521892cd119f4814a7ccc12412001a811dea805f78501940daa4e9773f58ca4ed9202402031eeeee1c24c2b0480400a0ce4bfde6269052f5503535000fe90c59dd869e8438314db29001a9f8452c49a0f5d22176005fe226ed11690a17a5e9561eb788fdd156ab752a85b2057ab0dae74900f84129620e9144d41a130cd71a5802e1ab0a49d49d9f6a1028ed0f27b8086bbb0b9043811082011a7bacefd6f12ee45126e4d5cfafc226e1c166a559cc36d8158700358863d6d0e18872a62fa689fbe0d1228cfa5c8e948426ee0b9a872fbc42f2059520871e045c988909ef16214ce45bcff38ad2edf092937768b2a5f66b28915a74895e608e154ba361d60d12cc183b8a3c4a303a407a966ac2d0b82016a820344acec06609201a9dc82cd0a039b51f617adcc58155764934ee93f7c0a124970d5770475f5e5109788000da59208ddeba4f580526a48a0a837316d006714a53ed5ebe7158a8d274a5ea29f7c4d95c0942ec9da87ed41034b2541a95ad0faeb074a5d246925df524d0c104824b393d00de1bb020772ce0333b5e18b120b3f77f0804df45424d402ef04eaa1600817043413ce41592ab9240b16020b36a727bd4f9758248a8013d350fc60776b570cc06e0b55a2ab704a24064b901816bfae90c9091526a93b58c2248e86b6e9046962e2c6d40f129df74073463b37c237785219e9b6a24dfd5a2392a6709eed05c830c1200077662546237d805243b82cc778ac824a807eb50e0c310024803538ea0341482a48d3f110e2c5da2c054a5dcdc92e091b438a8ad1ec6efebf3800d1d99fab07da2105829811648b1788766800800963de153470aeb12a49ab07fb4285e188506ae92135f1b5e0249d4054b87af81113b01003ba4122818d7e50403b801855cb7482ec4909724d1886f285b92a62ed6262336b008771a5800589378342412e0b5490efea91031b30ab281aeaaed11e8407047d97b8683c6e0667a50d1c785bc6154e40e9621aff386a33ea0904393e4d1092e0949ef24dedeb783f04081ae06ce5c30f3f380ce0b1f0736da0d4a594a674b9525811e705fad4369161f3fba166f604d20b0dd3573478944e9162af877fbe056ee4802a06d10824303b50c2f602a598e916a170007fac40189a0d245857ce229490e087721d3bd3687d41df4e9d40801830111ec02120100a4b8f8ba431007d188667f180413514203537f01112544d05425999dbc60b70123e2a52e95137f9420150120862c54d530c0a4d770a62498525bbbaac5cb815897be405c254abb1dd9fc21b615720b800073d214a9c7c4127c98988c4120100dbfeb5a0dbb58118a99e8dd3bdbdaf12b53b586e47488923e115614e87c220a558d7aa801056b82b05882cc4289f13ebf2885747a57614862351f858a4b1ad36ac4096075307340444677007622a48ead0e950d4c1c877a8d2cdfd6010cc9604277ba84300051826b504b44e52042402c012fbdc6f06a490a05209f88173b7d62064d1b6700edfd7f288ad8b58501dde26cee0526ae097760086896a0a1b90ccd10b38600a80a13b4472ea2439b15060f4ad223c2e08405060c5fe126229406c49146da212092ca0da7a39b447000a804d8900efd22161825988aa5b7b13e702841726b4f2bc06275005c16b901e0851008d4e6c9736da2526020696009a97702a3ccc148ad454167ebe7012ea2c4966bf8c1ef51dd4d467a9896d600285890e9018d19ab134b5983867d2efeb68352015061a8ea48bf8183dd1f0d3763788dd7982b006a008d3a684dde1806531003bb16a410c55b69167a5bac202ea554a8d581bc31d40ce0025cfc4d41678801720101c51c3b5e14b0290a053bb062fe3f8c3121eac1ae3683b580dbd6ecc49dcc06d2e2b5344b7952f00b35054d43115305cddeaf52438fd619c202fc3535d570df0b5e210092a7a123ced04e904126d6e87d7e50123487faf43485adb818b24926c7e1a168521418bd08734deb0c493a4029605c04ec62283a88701ae9b0aedeba44ed86042356cc3eb48040aa922d6a52f05408377003150a81e50d6146d2cc4067315b600a9a9483a89dfbad487008a33001d80a1b456e5a8abf56abf8c392541aa18312e2b07e2020fc2e035bc7e710804e972e2a1acf0a08a50065783182aa50063f138d9e25db70020b03b9f88dd9ba444540724b9a248707c7c221234a45492e5debb4441483471e26de0d04fc4103d4824b0702d10a4009249b5367260d4870cecd7a08152c14090036c1cc16e070121ec7556ff74294935142767a78430b01476a75300b02e41157ad4089e5b80358300e9707a7df0c097296140ef684720d6a087fd3d784176a800ea4f8374788406500a74b36ee4b82df840090cc0b86dc07feb10a812598817363f2f0a40b1d212d56a900da1ec00ad68757d92f41f282ea2db1141567100b241a5e85ee03ee2014bb577d4038a4475b303b325c92d470d5897058915a1fb5e3f58405c872e3c198522c604bd093dca8b0a44ddac82a2433b051bbbda0d5aeee1c55879c10815a0501b82c44290c087dfbae00825e20b007053a5b4f78b6d5fe948037f89405800cd00a407a16018d8130490435a9b6ef0f900a09aac9bd2bb53ce19aa9054c59d8d498090478021c56820b80e4873b921debd20df54083413de041340d4761580e06a5004121985e1c0d800aa6aa338eb036d89228f71e50bb7b802bbc06da43b1a926f01cbb2a9471bbc38a82540d058b457425c3a83780113b3bbdc6db109627503ac06aef052d57bfcc31f3853ddd2a20126ef6a7488e4b06040e8478c165d80df110598ea06a496b43925d9a86a4910a096000606ec18c3d056b5a751ebc22ea2ba80b1d4d4a81a4ed173310c092455aaff2854e92a70689bb9bd2b0c950504bd0a6c5abe51d10bd922d14dbc05092eca0439a307319728077a3bb10d4da289752c010a6a9a3bee633242429806157eaed1d54a2f9add4d8eeaf60bc9939af693e0f98b2812f28caf36ce6729628132b01392ff599f74750b8c332fed9e24e23ce0127fb5f8831f9b056e4627173e7027e4b11de8ec2a84e4b9cf3cf994b92959e5c722736ccb0c16a0896ac462bfc994951d9f491d58c7e7e624d01a6a0962dd400e63ebb8ac23a7ecaf0fa6d66a4f5153e4fbd534fe7a73f98de78a31c6f7fd48d2263bb062d72edd2d14359fbac5bc22f5905258317b98c531f9fd6f58e297acc9122448c4a92236fd6244802f41000a9a9b0a55a351c3953d1e95e9f48d3a5872000188dc3b46a5249040bb162d6fac776964d4926694f2ec7e89711e5abe3bf67f72f78b64a5388c7725f9bb88e14cc8a1455330797e6f29665eb1b27de270c5cef344741f108aaafaac19d9a3f44fb164c91cc2e5276acecf18a5a666238b7961fe2070a6199d6bcc7249b2a6108afc4a5a32f0c2ba4aced1f9e93a52eeb041219419883471e1d23f56ed4d38eb385f07e354ffa5d3469cffb4d3c9d177f374e34a5f2dcf4f531e6a54abf8c6df2c7d17f458d116e7e104173b131412412920b14d6ef48cd5a482c586eefb7afc63096900925c100b277f01e71f9ad58d9d91c063289d5de7d5b92e21092e40705ebd4ef12654bd49353d4fafca000ea0c5dee08a4714975466f0ee1480540598543de90ad560d7a9555a1d2c549171f64b10e622883402b6f8aaa8c64999b56dcac8d357604b06248885c27ecea0680125bab18269b5e8d7d310814f3bbfdd19e12cec0420103bc001bbd0c1ef35dc8b00209d3f136a0a3e4044034bd474001a83056c58028c17f26a9fac472a0cc4b8737220e9481b004d433fafe70017a9053461d4d2213b60112e5920901ed1610404a86ff000bec61024050254e6f535105c07773f3635789c5b1b820052483a9d9f533bfce277594010526e58d3c0c2934490a5906afb7e312c7bcc55534147b8688f600e9a0228416e84d62017b126a43d87941a10762d471417817dac2aa163e313caaf66024d6a0961d1debbc292c685890c5c1f4f1097aa4b0173d6b101054081522868c0c4657ca09777de8428b1f9442f504b6e054b74820274d41ad585c9f5f8426900853163d0b935879a0580f75c2492f41b5a1ac9a5c0727668403c36d8c450a16b00ca7352fd2196b0084d038a3d2f0fa890925d2a22e3a455b30dcf77686d21dea4801c82e22db001254486a0b8661480c5c0a804d8583ef0c5d2a24394aa84b7c5fa445024102a406481711549e502b5025d46c95696ab260a4972c9259c01e1e9a090146842524690927ca2302a04500af488b788204aaee00dc114880a8902a1ea284b56de3054960cc01777b42947c2e4bbd5a8045ac9ab8084804b9750a972c4d2083526be045b6a4561c6b0cfb1dbeee90e905215b55c7879c55d80cc4b05339ab07768003386229bbba8b41ff0050aaae4c2829762935a86aed1384f2072e5c060906aef00115a9367a16e90094ef504d887884804a881a4d290b756037d2cc1aed502154a34656f6b91e30b52183102a0581862da450120d441ddb03240625c2ba39b41d26e547aa46e6d0bbea6a37c300b31d24bb52b431369580f576ab93461430a748248a9352d74d2200598d5f77b34462544b3b860a1f6696886981c28000395246d723ce030293a58177bde2a0e0b007a28bd4f8b4384970d6fb21ed5eb0f6027c203b117a3803e50486515024d5ea7d78401521880c2a2e0c2d42989b9b6e20ee901b593a43124dd890441753920b3063434ead08e4529dddc1bc104166b10e4b33910bac02333170a2f570c7c0c3f5292497a935842429ca536f8babf5861a52286e2af0be6e00f7ef6ed6bc100a41482aaaadb5a20ab801cee9bb56f069e40104b0ac3e5002fa941a9aaa43bfe90a5a809516554b171f38259c8b9774d682d12802890e545c90c910f3b8010a04d52cce916a4324ea2fa480f73610a5aa07470497304d92450f9f4a43dbb00f5019c9af427a3c2924bd49a5129770fb3c10120914a87705f7fc215556677dc8b9a44a5b3e8025ace5241b135dab0ba6aee5201a153b4101d5a8d9f71589a49662ee6cecd78877dc0bbb9eae1810d171513a98b103e12e40ac564e9f8998d8015b445125ae5437b6f109d80e9d65aa4822c06a7a18b1218e9268cdaac7c1a28490012971e6aa88b29aba1e8cef1375d010b8724035bee6bbc0d4a621234922aeee3a4115fabdd88ac070c7ba3512db17bbc16f802fc20106f42c0de017142c4aac4d3ee87253a94e9048df500214b36a04bd9ae441826a201b96dc587ca14b865281bd0dc1862350d923704f840d3520125203f9183bb60704d14482096d245be50c03b1a96bd0b01151620dc74f18815dd62ecda5205cc1d816b124a410a73bb83685ad8901469b8689a800f714ad840490096625dc9777b43c80c03107c2aced0b5058ee1c957940292f77ad1228d5864925dc3134020bc00a2ac491bb13bc31a9743d6ff2a4020951600682e0bed47820378825db6f5d6252bee004024bb972c6e05222881dd63772d56e90e2c47d6be1f842160e00ab50fd217c8087043779c0ee9a1221495282a942580bbdbd52025c5aa4b54ed0c14a035288a78785a22d7cb03397018953e96346eadeb685ef8a972c5b4b1b7a1f798212012e69772a1dd884ea60412013dedcfca0ecd0200054120f9b8101ea5dce9a13b7e110a4380e4efa6e62307d241ea082fe50f6018a481dd3b55c3c050b294d4a3b17863605c5dfca94804b3960dd2f1360006c4a850dc8a0fe70a900a9406a76bb134ac100b809627c4522040a863a8870a0404fce22de1b00d1c51c10cf5a3d9e180d23482e01ddcd7784b51bccbd01863406d7a825843a60001504973a48a077020b162c47900febce1491de01886209da0024d1c10281567eb0daf603122da8e809ef04d40f0302a53a412da5883523c215817a06e967e86084b062a67a5dfa42ec112e19b71de068290cc14a73a9440adab6681f0e97621fcd9ee6010a6249018b863129a40b1c904853baa8968ab529c8035125c387203435c8237170180f3f5bc0569a960400c762623a5ee01a8a8104f982967825249372e1d2416f378052e1ec5d9ded581621dc00180dd5e111d016200000201046a22b04bea05cd015006a0f9c2a6b56d454180047480684528db6d589c6e0292a29709a1a5cea37ac4242a9a838a04905e14f875b9da188a3d1c57a3c30c10bbad2a2cc3a9a410ec28e474704ff003817531018339777f28092092c29b006fe0f069df20212e41a80410412d5e9135b91a857725def0490002122ef6778564924d9ab535353f385ef84024953b3902f467822a753eaa3779c110bb05035e9d479c35c0614b1afe310edb8228e9170082daaf43001090545f6a5a083a82894d8ddfbb0aa203d8b51b61d62cafb818ec6ae5dba8f0885c10cfaac09b7afd2057e26ee90fdea80d0d4352483b902d10acd8192da40eef754e4eafc2202c4ba7caa4bc280ef51dd0e0b352f487090a4d0f7ad5b18de2b3903907bd43a49d408a379c3807ed104b826ac408a53a88d34bb08c94a1c8a97fb4373f7c744237c3358ec5a904e9035006819dcf813d63330ce1601770f6a0114ca0e2a425ace091511a8c89452c5853bc54d76ac7a3a7a776a4cd12be11df5e54e8e08ec47da438d27a569c4f3278c727e566493a44d32a6197844a7198d7ea87c4ca040e863f3d710a0bd542085168fd06ed1f2bfc38ecc7d97393a847b9ccb3ccb31fce1e2c46b089aa9f994c6c26b45dbdccf948aef8450da3f3d713a9c94fc2e456f58fb0edd4568e7a1e10f13d3e9a9464bc27513af35ed4eaf2bf3474eab128d35f062be7797f59a72cb0208a6aa463907707a562f981892f47b8da2837a978fccaab6e6d1e73dc1122448c880dcd77b981b37f4890456941b8300589d200eb6ac6a3215a5ada6cef1a626e03bb97de3365a9274d5b4fc43f168de84ad257d8bc1e4ed5f648e6223965da0f95dc5f899a2565127889191f10052ca25cecbb344ab2fc58994621227a66b1de483b3c6476a1e5a1e5373d7997c0c11a307977114dccb235304cb9d97660d8dc0cc430f83ddced20ffa63add819e65aa5a90a54b524828989252a41ab1076f947e92769ec1ab9d3c89e41f6a2c0cb4ceccf0d938e49f347dd3ad7271d96198acb3133cd4ea98918895deb25124fda11fb4f6769ae35d89d7f0b82bd6d24e3aa8aebdd49468d7b7945f7336bc1499ec516aae8674f7941a92f63f465f33e567e6be25042aa4070f762634f50074b8a03526e637163242b5552e5e8e2344992d9dde9f1124b0f5d23f38d769dc24f079d2567834d28214ad49aa8d3f585667664a9378c85a5c16bbbbd479463adca94d76af44b478f28b451ab8084ea4b9672ec2a97de2152457bc3c05cd69589a55a8007482286f58425cf780666a134118c966ccc5d852545d9ace15babce203d52d4ef74f0825cbd6a2896a1bb44d441d24952fed743185ac4100a38000360f66f57805ae523ab016f3804a9a953624936824950d835694a4472abe360001c3026b7f08291b06a75ab51a0827a801ad57880ba0518ecaa8daf1092ea08c585468342c078423503d48551aa37f4d0eee3ed6914a0a0afafac0dc07a0dc8610b74608d5268cf7b81e1ebac2901c1500db55e229eae4d6ba40205a19aa28486715248a88977ea001dcb599e86a0c17f22598daffa40a528e48eedc9100860e49059e950622e9806a62c0024163471e7003070770c0350435487003bfc3d6adf483b850201342977306b390390198829a7d920eaf38466614e8e687ce1d44a80a1760c445658328b9007983e9a0ee9e00c9028010cd52f53e7103302a04d081e2d08e48482087a85170041762589d360e290be4798a96f88b10491a7f8618072492dbd2855102aa43bb17ef066f4db41d45c001c03637b44f4ba6080ba89720e9f84dd45e904901dcb5cd6d084905408205c28bd6053ba48203b80cf109a5d00c5877810090ec4560021493a85ea3c21f4f79ddb4870768453ba5443914a02e61b2c80294d41560c093734104121d8bb1720d202ac080ee5dfa7ca09153de3d4dd8fce002e350516ad1858797ada217214c5c855de8d0a090ddd04bdea36bc3316208f883aaac690b3bdc1082a141bb17abd60045417a58907bc608f88a40b5c972cd58404b3b92e6b4ada197760b140d0506aa742215983240200bbb13d62137503b324805844fb2ef40194c497dfd08257c0119c598dc03682c5bba031a93620c104a1c6ad34a56f488356c012c68e5a23d8015f050d8440400e000051cd49b412e520bb1143523d0864820004066d9cbc1670c041e868a2e2ae7eb04339156b806a9ac20648afd9a82edf382e5e82e2c68de3129b4ae8048a1200246e0697857761617276f908624d41258d43d3fa981de67d2c6a01de25d9e56e00183b3970e45da00595392901a8e69f286d4e0350a8508f010195a5eb436341d22bbec084b82520020317dbad60014634160772debee880d14432772002479c3a15aaa7bc451c258c4a58000926a12e4d08360deaf0086d89512cc08686214e3f84821c1a79342f7b502e0866605fca90c5812a92456a9f22221764876d3736820b53ba9d5fc25c8f188c5474904867748a183566089a15024172f5a931142bf6581a0bfc8c46660e7e6efeaf068485070d43bda0901583074a750a07b3c4aa5aa950dcde094b30292dbd0d7ac0605248a31aa40dbc7ee825e009dd0c1c024b9688e46ad3a74dc066fbe22850101ea0153107e9016e010d4d99d985fe50dd00d54dfe92e413e5134951adae00229782ee01a824b300ef6f4f0a4b124302cc0825cc467a81a840b1ab2be90aa6a313760e5c79442ab000170e0c39d4c75778ddc96895e0c15836660c58f8ed0ce49b691d6e6d0ac749528972680d147e50f5482ee01f85aa3c7d78c45ac0624804821854bfdaaf94202e4a8800816dbd784307d4ee5d9dacf12ba886bee5e8fb436c8025882e349670f73018692c482cf56a43bf741001502e0b97022283d0bd77a806bf7c595fc40a1c925445536b031080014866ddc5479441a81af799234822b68806a04b96343f2885e08048a243166d3e23c214848028407a11f8442f56480525838a3412e51505dfe67d7588bf88108a0afc55d24d219245580ee871a684da225208dd9c91fca210a0e5a9a680529489eb8042e2c28eeea60d583b83a5d83124bd7ac425d9dc03502b4850e689259e80ec2d487401209557ba0bb905e0beed5163b42ab5e9673a4d5deaf0751702a5add4c1dd002541dd475295f36825401725ba30b4280a05248a92e360606c5c9049a86a1f285da05ae96dc960e4dcf5f5e3003d4aadd00f388c192cc764900d61896bbdf6bbb44eceed0200e749000671b9a1dcc2ab53dac5837dc21c12154000d955061141401d3424ba9dc12df9418090e41a836b31fa40b104b51c52af049600d5f6003fcff380fa5c94a4024925c87ac43cfb011fbb5eb504c21ee97a12035ef68729a0d490011dda93b42d2c1d850b5cc4acbcb0114b9a937041001f08622a29422b514f3807e21d4d85456202e4820248f89a910d5b002010140d1b737304b35d34bd7e11003ee2cec6afe300172a0a72c6e032bc1e1b001a860da76f1f380aa1a01515a501de0b15109076a2451a0870188a0a9a11109014202581352082d686142c4d2c1c6dd5e18f7800c48151a9cb40ab92e1807a2aff00ce2cb081052ee7a16076f5580592493406e01860a2083626a031219a114ea342e976342fb442f202960593a9ced787d20315312eccd553885528960c5c16b5fce1d0181609adefdd82b78014e9b9d4cf6fb31028312e0a4160e1c887eae4b1b824b79b7abc56a1a545d240bee08f5f9446c80516240abb81048a50804d4026a45215ca411e37347a41a92eec48f306005d3a897b0b01f661e84548d3a59cd498001075518d2bbdf688c4500700380d40ef1001f60d06916d8bbd2224300ec6b41b0f9415101d26828490f483b06a26c4d5cc5b6c00d091d0528283c616aa35201218a8163e30544872402c58243f8441ba88f898801c8afafbe0ed7c8000e9617bb9348875070c29b9b986760c096005771e5058001c9a0777863a8143288a10e2a09a087d21d88049bb33c28512f771437a087412453ba40fac4af4b7022d03f8b6a0d803786a31a50803c6de8bc121801626e1dc988c1dc97484f4768bc56005aa08602c03bd3d7e30e284fc2120d082cdf285d3a59ae4b02c68f682c13706fe5a8b7f48da2aeae5e2930a40705c86340f53eab1988d2547bc0122bb37aa4628772c6971e3fd3ee8ca47c419fa02411bc755285d9a2666c841248041fe27ab758e5be4ff0002e2798fccde04e05c1ca993e6f12f12e1b2d9c8454a246b13312a7e89948985f68e30c2246b142960c08b98fd08ec5d914be07e1ee7af6a3cd65a1197f27f81e670d709cc9c42138ae21cf52a932532caa8552e42260a542f112c7da11f7bd8de0d0e2dc774da5aff008052e7aafc28d34ea557f2538cade76476e92946ad78465eaeefc92cbfa0e1bedabc7585e37ed05c6272b9a99bc3dc1b2b0bc01c3a996deea4e1f2a93eee70435349c5ccc610d71a63a7d3943551aeec2dbc6bf9a62a7e33138bc66257efa7e2a7af13889aabad6b5296b57cd4547e71b6e729a8055fe463c2ed5713adc5f8c6a78a56569569ce765b2e695d45792585e48e7d44f9aa4a7e261cca391d6bd631e2f994d40d6bf2168a4970033308f8b9fac7182241f216b9eb122a011221a9346f083b4012d17cb3616b791ac502a6ff0038b90a16fa1d845e0ed24c94ecee6b7862484eef4ab47ea0760ecd72ee6370ef397b267126264a703ce5e1a5677c013314a025655c51964b0b92504d01c4cb978772f7c081f68c7e5ae1a68041a53a9a131ca9cb8e34ce380b8b386f8d787b1064675c319c61f3acb561450854cc3ac284b5115d2b0152d5e130c7e9bee7bc7a9f03ed069f5ba85cd46ee1563f1a9545c9563e778376f3b3dd1ea682bc74fa88d4a8af1d9af18bc35f33f9caf88727cc329cc332ca735c2ccc166d93e613f2acd30735065cdc26270d357267ca503574ad0b1f48d9789945bbac5246fe51fa73dbd38578778b31bc05daaf977211fdc8ed07c3b2732cf65e1a5a44bc9789b0b2c48cca4ce090c99b3bdd15cc07fe9e5e206d1f9b189926ec0822a9378f63b6dd9c9700e355b86a973c22d384d6d3a724a54ea27e138352f96dd09d5e9a5a7ad2a4ddd2d9f8a794d7b534cdaaa052a538749dc1fbda31d490e0105ebf09ab3ef1ab4f93a15a824a6956a807a469f346e1831d448dde3f32af4dc5b385a68c66041008a25ea450456520241df554b57c0c5a500d85773d22298302eadabb0e8fd638da4bd851c7e628228c2a2c083f741d2ddda13a75174dab161486a00ef6dc75842c14594cf514fcfc639dab9908d46b55cf5b402082e03ecc2e21ee34b6ce96de15994487602e6fb452c93b014b9d3a6eda492403b868623ba501ca5b56de3014c0b94b9059c519cc32b4d96140335e215ee04d922e454a5fe2f2825ee08b77474aef087eb5ee9f0a4126a900decf07679406009d249f2601c7f3881c85281662478c10400c5d200aa8172a83403530a9a3dafe5119040430200a8ab87667834059dfa1663e10a093500002ee287ac125a81c914d37220acd5982102ca0403522ef5780c1802e6ae07eb04935a5417615309a9c7758693de2690f31ed1c90ecf54d1cd7d085d4c58b105cbc03abbae43338d3b8fa44246a3a5409776f89cc4ecf0024b8d2f46625a9bed04001243bb357a457a8025ea5c3910c8d243ee0b548fa4462f800a29c6a24a6ae7f08b01207742683c2b02972081a99adeb681fc4a20382c2ac3e50d981c12c680d2c284f8988abbaaa5a8f68ad2960e03125cab610cecef5d9219e27cd023951052f455770044342e0851ab51c0e905212012f405cd68215dc28901bc76bc45d3c3010012fa9d87d9af48562031b54ff00aa05d20b872d46b4396a507927e2310050140b0eea4f802d782aef00ddea10fba5aaf10d125944bd810cab6f052435581dc03714de2d67700228092e1a805e0904a58b0212ff000bfca1890364f95a143100d2cd53f9455dd8174ba6800a33185a1d2c19c0dab1614e9762a0496ad7e501203171a43f97d226cb7408002494b0052d5661e10a1859cd5b60e3ce1bba46c40a52a4f485d02852d67addde2337c000fb26e906bb3748b180627e1da83bb0896015b926cce6b0d6dc83651dc44adee02c54c4b063d017ade119cb024292356aa56f0ee090c4122801141b4565cbb96a50bbea306804548d835dc57d3c12c4fc40a77245078410521c3bee4d9a02882ece6b62286a622f9b816ccef4ad4be9884ea028487a13bc42c4aa8ce2cf5305940246db0dc44ed9013a58288a13a4a4d2a0c40581a313548dcc0201008709601856180a9497d228082c45ee5a0f0c04020d012e6aff008c29242e805c807d7e304a8d58b905924dcc31d219c9f9862ffa4377802a8252aa0ddcd8c40454b867209110000b8209b9721cf8180038d4349abd68041f98189ad0004540bbda21203d0bb392e1e148005c39f84748818066a8b11f0aa232d00a4925ea198a4d15e504d1c8b9ee92189ac44149f3fe1f9442a0ee960caaa474f3f578b62c9a04048090ce5d98d8c42351ee8622a188013480370e1cedd07582a76a25daa4dc8f38798082e492eecc09b1f068a897b8ef5816a2bac36a5519e858878421cd01009673671bc57200f7abb8f0714bc324b31627c4b1236b41371dd25a95a178571a83b3953bd8dfee85b17038345331362c2b04a890eaa6e1dbef8268e5a8031d8980ab03a7bdb07704437007d45c3822a08fb5ea9043848a1722b51580ec480c03025bf07fd6007002ab534e83ca25580cec09fb4a0eccfe0f1093de705414da48a14c42520b7c46a055c880492e904106a12fe27c223cc014006001147249bfcfe910160d5ad8861d5a0efb5aed48217ded4030b306fd22520333062aa9b96709fbe00003ef5a28d52a88438f8995aac454883663667f97aac4e1007c544a98dd45dc1e91055d40fd963b9fac04a454115173623cbc2039208ab33359ab7884f3901d203289a81d43bbc4530fe14bdb487dbd7d20929294d1d4f52ff8c17620002a0352d0f69021018d869ddafe51075b8259dacd04921c100921f58829161770ee6912dab64902c004826a2a1ebb42105552ce4d68d48258514eed707bb68874ea71500b31315c7501e9deb5d85e206f8892e6ba46e7c2038723490e41707f189a947bc43a46f66f289dde76031751ef6f449156ada210ea0ce0a40f33785d497649672e4df78208ad828f51f87ade23cc04a7c0b82e3761430ca01abd59cdaf02ba89762dde23c0431ea00606aff844a028702aa1e66ad089d35a8019be1a8f5f9439b5b4bdb558c02c58b806a036feab049e00a5d4a04540ea19ed049259cb8fe1a06bfdf04742452add5e032482c542b5afe704eeee0886a877f0376f4d0cc48242b6614000eb0967fe13d6ff0028776068e9d8d95e30b6d701baaacc45c5d5109aa9aa05a1424920b691d09a7ce1f5100060c4b30de255d8035dc382180b81e9e158380c6eca34606f0c096150e9f874de16baeb6b8207a7f3837777b023d587d814a342a89234eff4895530e9d3ed44342006722af4ac4780210c0778a9ae5be189a68594e0871b5609d34042856a4b106bb41091d7bacda49b5216ba4d00071452811bb548f5483a482540bf8302ff003fa5e200c9a690a27cc430ab31bd0d1feb0b37d015906828aa5030eefafce1055c3396a52822e2905a86d50efe10a0776ad7b12ef588b62e0200202941c5881410540b16b90d5604d042809002bf8ac2ed78819c9203b503d443a000d2a66163f0ef0c92421c802ba403f3825896df76a37dd0a2bf16d4491473e3164805989a120873461b75e9112cc2ee5c7df0d5650041a535171000093a5c1d8a8dbc221db2080b0771e2e2b05a87c6d40098840d21ee7715da2b24aaa080000dd4fdd13be101cd0b6aadad58620a405b3804301bbc06074bbd6e00ab7ade18bb1340c477771168abe58080c1c0a6e58520d1c39ea42401f580c0a6c413573bc150722b6a36e3ce358abb2c95dd86459449620b50521c0b0f931afaf3847709d2e482c081425af172407093551a17a01eba46f08f43451698d2e5b9001ab7c200fd7c63265ca5056970194c49ac34a42b538becc4106df48d425242d40301b97a3d63d1d2d172922f15946ad80c2cc5cc972a5cb54d98b21289481ad7354a2c94a46e49200f131fa3fdab25af909d9e391fd96b05a30fc419ce18f3a39bfee8e89e71d8d01397e0a731ae9d05452ab7f67493f6a3617609e50e4fc7dcdf3c77c75a2472b391994cde69f1ce371490301883972173f2dc0cd510da66e225a17305fdd48985a91d78ed09cddcd39ddcd8e37e6666d366899c4d9dcdc56030f3890bc160d2af778391a493a74494cb702814551fb068a87f26fb0ba8e33571a8d7b742978f714dc65a89fb27350a49f54aaae87a34e2e8e95d47bcfd15ec56bbf976f9ce06c6a80ee953d5c07f5e9e3435a81b55e9e519d8b9ba946a490768d2a616bd090febd6d1f8aebaaf3c9bb9e65469dca97721a84d2ae22b6e95863f26ddaff58029bb478ecc08c5c0663689129bc488c8044fcf6da2448903258104d05bee87493a8837b0a398424a8814f0da224b915f0104dac83351550d80ad2afea91b83058809290c006f178db09528b1660f52e1cde353c3ccef02eeff00947a9a2aee134d1b53958fd5cec4d9c643cece06e62f630e3acd6465d86e62217c5dca1ce71a4195c33c4f839466912c9a846204b0b5a45f4ce60ea8e87f19f07e79c19c45c41c23c4d974ccaf89385b36c46459de5d352cbc1e2b0d30ca9a91d524874aac52a045e36a707712675c2f9f64bc47c3f994fca33ec8335919d64d9a6115a71396e2b0d344e91391d4a5690749a283834263f55bb5070ce57da63925c3ddb4f97f95e16571165b270fc21da3786f2947bd9b92e3a425122566feec778c93aa50333ff133e4927b8a23fa2b8442976efb16f4f4f3c4f86c5b5e357477bc92f1969a6f9ad8fbd49db103df872eb741cabf0b497f7a9eff003c1e7f35f91f9158ac3a85c3b3957e51a22e5904822e5c30f558df1986119d40375a54c6d9c4c90e5a8c3ed0b98fc6789e8654e4f07915216c9a1a9dd40066a82033831482a72d7bd5c03f38ce988012c5c02aa9a06f9461949fe2a6a0e0d3503bc7ced5a4a2da460d22b51764800877213d60b58b80a49a063a60a801f0864970956e1a142352807bd8d878bc73ca2ad6466e38ba2bab9173735f5485150490ad4490d6037b45ad798a23b8001ba8c2a880c0063f112d53bfe518358c157810d46cda9e90c7e22cecdf69cd0da2b5001d3a83bb8a3b44492a27510ed471d22897520258962e027ed00c3fa412760923676a8688749203b6ab74241dcc422dd49b7e110add40a033300487042c12914866d42e469b8eb040517a3834245c7808703700920b160e042d67e40af53837f9eff3f9416a8a1059c0da0166624f7ae4f40f48249539670ddda0ad3f9455ab59b01abbb1a06a86de14171517d854fd7ac307a115ea497a4050dc0008a02f1386c014da526a1f6ab8f080a2c5e80ee486f38672024137bb8fc61092482549fe10f4a3de0bc40282a902c1b5547afd60a6a69dd777af74c2109496047420871bc1a3ddc7c40338da1d320762145ddb606adf388144bea0e01607e1683f1120390433ddfac07f853f1076b3934fd218bd90f60ae1c1650350e4c126e15523bc5e80bc33554141dc52c4085229a8b120500b185dee3720510e00704d947bc61813a54ee5e94da134825d4402ce6ae441d4c284a5c8209153e710029605812035882098650241a82f44801888a8b82f4276e9f7c582a0022ea671467820462c181622a6df48255a5dc6a60c7a87e9043390a2cab02431f9c206751dc120d2b13778b818b809be9551803058377681344b0730868c4924f40297afaf08809a126ee7c1308ef6030bb57a924337ce14804872a00daf48858b5ee7a77aa209b6902a059dbad044e7a20293a45c54dd22f41ebfac37da703666dfe50ada53467dc1b0821d8b1054d43fc3f288b3d80451cb5c6f7f55803bc19886b54d4c172fdeb10e4dc9f1894a93a4821dcd5e9bfd21ec0282ea01234906bfeaeb014d46052e5c75864b92e523c4dad04a5cdaf62e1fce22d802dd550e91466a9895d440249b52e2b0e46ad9b486760dd5e014824005d5a6a406ded13b61011852e4b072ee21d812a04966b3d47aa42a524286a25c1a00c0dbd521cb862054863d6080a0927ba144245be1883ed1009721c29eafebee83a4aa828d52e5893f9c41a812adc559bf2fac2cde00ae48d24a891d768b1d986fd4825cc021c3a0693e17302ac9d400e8ff007183b5acc01dd4c5346625aa623d486603705de0d0925c90284b51c400e6ac18efb9261d501880c6c7bcde56842a752684149b752e6097d25c54fc8b4009274a81ef3fcfca1eab036b2f549074b0d21a9b442c97530617b9e97880b30a11bf5b4400a5ea1dc900d48eb12eed58003924b12e684d1a01360a2c00a0111c6977d449dc520505cba922883b6f15f680e9724a9c38d54a0fac40134772d605d89ac01a893a4b38d4755123a4326a9a9248a3ef06024d2a0ef7a1a8b40000340ee75170c1a18d084a839507a50336f11bbcece4a98060c2bf844a4d81522a5cde805c080ce49150d776f9c120024a400db0dde080c18303fea14112f97a01125a8ce753124d4d7d7d21c8777db64f94408d458b6a672a1b429665049a82ea51110813bc1cd1be2048b440a517240d4f4277aef000553baee2a0d1ed0c6c97240352033186ec0c487ad090c45fc6002424d18a4b0f110a94a89ddc5a95f082c15537b692349f1689bded7409e2e4b07ef6cfb41a15125f55940964c1d20b9d3b93e460ee6a013e340626cae0520d0b966a0b93e700d469621ba5bc60a8385102b704c40eed7a3922bf2315041774b14a05acf02aa7d248aba417040fcef0e900d8395558584292ef63d40f8844d9bc0082f42e41b30afd223690a2f449b177300b80480c9f2ac45102a180bb8a91ebf3885bb4c0a45493648b56f04283964b976a6d0490a49203d1c03e1bc23162b4d03e93d5fd3c125704755ae09727a7840bb8b359cd61ae90a7d34a8eb0022d50012c09dbe90bd81340074b1b51cd4c369776154a684d5fe704692e404b81436dfac325542458515e3e1e50d800381d29520b930ce486d2da6cc5a1496a1219a8d72e2003b176346147ac4a56d812aa5392a6097a971e308f570cc4d88b43952a848490ec1e8f78a94c5d856cd4f08aee81602c4ba9cddc0d5f48801249ad6a459f7b7d2140b1290da9bf847586ad7490e4b5430894ec0019572c5dcf8433bb747b58416201d4ce0100dc7f2b4060a0474ad2c225dfa020a87ef3b301d478417147ee8161523d1840a24326a6cfd37786502ad218eaf89de90cdb701209d5609dda8a0478c203a59c301506fbc4626e82002ca63531025d803dd06ec1c7ca2329dd301d2e40624ec5248d34783523a920b9de23e95120d0067b93b4284a88e89dc38af9c1598207007f09a8724b440e09704fca90482406bd8b5c41097a020b8b8a44d95ae8059db6293b0b79c567baec49493502ad78202883a4a6a6a37a6ff8c1219980a9b01a40885e0811dc51c8d2fbd290565c38172d7a189b33b3d186f480a2a4970c2ac4258ef117406018004d36605879428a33548a957e307621c248a126a97fd7f580c753960a25999de9bc4ddfcc086ea04519ecd0a49291b02583ed7877014058b397168806a2030555ba2778957e8c0cc433bd46c29d2d05c358780bb8860c1c937a31abc542a48a7d016ade25256b01dd26a28682cc04000d59c8a9b383e5019ddc5855c7ca192a1a8a46a0e18ef16493dc0134a8ef02eea20b78c3a4777e1268183313bbc02aee8501bb0ad0de19d3a4d0d05435ba522ea3b216ea36a00313f0bb3ede3e7fac2ba8d1825cb3da080356a274a850a6ea35fa7ce19200243ea292e127d52378ae86b15618000074b1218a81202be519084b00427bcf4f3fd61129001a12916247de079c67c8955f0d89ac7550a4e6ef63459dcbf0f24a86a20b9a150dfe51ad61b2f9f3a64b9386933a7ce9d31326449932cccc46216b504a25a122a54a514a52372a10b8191aeb5615622f1fa4fd883967c33c31278afb5df363042772c39107f7ae1dc04f425f8d78a748565f81c2a5434cd5485ae528dd299ab97aa89547e85d90ecbea7b43c4a9f0fa4d422ef29d47ead3a715cd52a4bca114dbf1764b2cead369e55aaaa6be57e0babf90dc3da07083b257658e0fecc9226cbc2f3679c464731f9ee70ebff006cca7080a5597e453142a1952d089890d491884971314ff94d8c9e4ea3724bea678e5ee73f35789f9c9cc4e2be64f17e204fcf38ab345e3e7ca44c3370b974af86460e4135f75225a512d26ead0546aa26383f1939d46c00245f557d3c74fba0f6874dc57887270d8b86868423474f07bc68d3f55cbf2e6f9aa4df59ce4cbeb2b42a54fbce20b115e4bf5bddf9b34d9abd4556a2a803c624c2497abedb98b5641d4aa002ccc498c553d012e7a748fc8ab4f99d8f326f2055cf8509eb0b0589246e2a60473940d3a44811200218dddfade04125de81cde968967b1da21021a3805c756678840d8bf5a33414963bb6f00bd09abd8da19b81c2b6161d4d4fafce33251524a48a836db4c6002c41036b5f68c842c51dc1b11f8fe51ad3972caf7262ecee6e4c062020a495289d4f5148efa7630ed323909c7d3a471361539e728f985861c29cd4e17c427f78c3cfcbf109549fdfe54a2e954dc3098a51411fe6ca3350e0e923f3d254c622e1215f103eba46e4c16316928efb359b6f18fd0bb1bdabe23d99e2d438b70c9f2d6a524d754fa38c9758c93719278716d1e869353534d5a35e8bb49657d8fc9ac35d51de3ed7bd9f13c8de61ff00c5b9c33ae5571de1cf14f2af8a30cafde3019965f38098ac27bd143370dad2920d552d485756e95e2f0cb054a21dd5f311fa99d9179b1c0dce7e01c7f637ed038a12b87f3e9a715c92e3dc42c1c6f2ff003a215ee709ef54692a62d5aa4d74f7a6c953a66234f4ab9cfc9ce30e4af1f67dcbbe38cbce0b3ac9276a44e4cb27019c6166157eef8fc1ac869922700e950f8541482ca4911faa76cbb3ba1e2ba2a7db3ecd46dc3f5126a50eba6aef32a12fc9f85465f0a18de2cf4759429ce11d6e97f053e9d612eb17f5c5f55e699d719f8655b622bb81180a934228a02a9ab00db9fe51ba7172807074de8058f9fd234432594e485049a922a23f15d668fbb934d1e4ca3cb8668e400c9551bec8a8fe9158497297048b956fe719d365252a53248ad09350fb98c65242542a19bbd319c2a3c4ab4dc656664d5d1430353524333dbe7d7f48552403de72c28000418b43d3527ba431db50f1315288705f494d5998787a31cf2ba4652dca541d7abe1a589b7afce039d4ccef5ee9a458a4eab1fb5402cde3e3100d3de04b8550b52d1938dd152a614d20100bdc86f2862975258801d99a8d10d49d229703667fe7f7c0725ea016dc3354febf745797a80b00ed5094d7ac30245c90f77a03eba42b00424800b3102a3eb049f02433172d471f7c52dd010dc503fdcdd61195e2a22cd6f28214ca01c52e34d223d92f4d87f3de1d30024bb6c052f0855a761a49eb5dfe70eb207d92d63d616800749eb767866d603171d185cb393ebac2dcb804a5981b1bf482da93f1549a8afafeb01960a4519eca0e1fa13f388cac202b397eeb1df55e1d3a810c03172e6a40f285ee87018359eba7e9f387013425dc8622ff00310bb6c00b24925541b13bfa684a3020d496d42a03c1d4e424a54c6ee5d8410055277a8da1802925c8a8340122c7cfd6f0ce1c821b7701cedf7c202096293aba860f0e66306d357a86a3436408d4b54258905c1f55824800558bb31b400aa24861572373047c4eaaeaa824d444a7904091504d0d4b87685764b0b254fab73ebf286d49015421cb1512e0787f3889370e9f06abc43dc6c10ca2e56c19d4df6a9b402e3a924b687bf8c1760c4ea7340da5e05525dfec902aecd12de40ba89a974b7da01c0860816a170e412d71054bd44a487beecfe07d6f0a12e9009ae9a7af0fd2216410300ad85830b79fada146ab17253d4b50f5860400c541ee28cdfac1248d209049d99e0f7c810efa9c2aa451c4405455501cd1886236787ef37537f84030436ee5ea4bb10c6d049dc09a4e9d2015137ab344008090a36341b17686a80a22e4daf6eb0144b25ee2a91d6165ba031d34636a8e90a4a6c92417d55dfac1ef3d0d59c803d3c563f88061bbdbc5e213b305dd08f281b9634662fdd6f080ccc92412fb0a8b7eb00b961aea955cbb9de272980135720b0aea7a88600056a2e43757ab7f48802baa4802c0507e50ca66200a3fce0bc001c02ee7c40a01e3035062c490cd6627e50487a023bc1816a9f9c3314b0290490d6a344a52d9810a8b97f85dc11782c360083772febca1412401f103762cde22205803671d2ad118b0210dddd4014eccdf288a6a1342eeeee4797582920b92452c6ea30bf1025892f77a3416d70406ec0a8a8fc4f4f553055a812c4aaac694104020fc5dd76a86880105800e4decff00282b016a9a0352181218d075874bf82492cfa9e2258a582a96357ab51a0697a949013bbbf489bb6ee8108a065352e43342690e75548f918b7525206a0ec684519e155b26cfdee80d20ecc12b40a241ff00aae0f84103c935b0ef1806ed51ddf37867000a9b53ac45dee094ab9ff502f53018d5ab4677a407724d8d86e0f8fe3054e0d4b86f3bf8c4e2d840526c1c1536d0c4bd02988a90f51e10a6843a49352ff582cfa49602a52988ca76ea085f5000bb0620163eaf00ab49d27bcf61623f941765071434249710686e0900ddbf385dec000aaa08ab5ba4048292db1fb4de3041735a962c051a1b672cc6f5710b3b5c0b5add80a105dfce250312485014dc4310c181014cdd5bd78400924923bcc18b7748eb43138be401602803a892f5f5ead128a2403a89bd5bee83b10411b0f1f9c0b6a76276d3dd6861dae40e40209a2091b17f56842e0070f5ad69e70b5b10c03383588192e58d767bd3f385d923121a85abb4404bd03014d44b784294821c5199c6deab0c5340093d1aca536ff8c2cfa8012a236041701d9e203aad420b11607f9fe90542db00d52c690092e52ddd2031666f9c2ed61008003b97517347d20562121c9068ec1ab6688f421ea28297828a170cf750eb5fc2237b202a5c02e6d407f1809d208482ea6a9b379c31d5e0904b814f1fd615eec68a1456e0f842e96c0228ad2e4eee45555b3fd2189b1b01520d8f51e768aebb2a83edb7e10c2a0b9623e9eab136bee10480a762e155bfdf0b6006a2ed722844330a54164bbb005fa4124916d27ea4790861e4003101541b00f51780420853022b77afca00209000a0f8ab43e2f1610a5568f614a4465810240058d0976258980280873a859c439bd0015b9afca2b201248aee4bb3c5acec067243dc10e1cb31f4621db577410caf2da058692a03ad3ca21aa756c0301d483d3ad62b8c80a58a46c4eeeede31353d082925c02c4b98092010402749ef07a7487777372ec0bb8312bc2e097602e285e9000205144a9dcd1de2c0a490492401f685c188a292c05f76a397fba25a56d814937049d5761582e400c3c4b1f8be50a7502a2c353d4bdfc21b5024a7e1eed4dc98af4c80a59a80d4b9076804ecec3a8fca215004014a79bf8400a74d4a42af515312bc580b8b35e8024de27c4c6c016200778356660497b500f9447500e1801524d49eb11d40ba594daa9e34f5d201625c1af4259fc609d25cf50e5cb88014da6808219eec5f78305894b9f846a2753034a41d3524103ab9fc2225d2aa914b102dd606e2ae0d46a0f4eb16bf8b042cf54e924552092e1f7f5bc16706c00bb6fe9a1f74d3516a2ac93ebf285d3b339e806930b5ae92042406209501b598ed12c0a4b5e8c5d43c04063676eeb3f5eb0c055c0727e60da2ea370214b01d0d01735873a90540dcda97e9ebc21ee0009add49352a6fc2216041274bd0bd418b24ae895b88351d8337f1317ebf282904e9646ff174e90e901f4b9d24d010edf38762490e086f90f28d62baa45e295ee8890a512c289fa7cff28b512dd74356bc04a1ddedb11b46748944972c10ece054ff0028eca349ca4696cdc0896412fde076b831aa61b0ead2e689e9f17ccc5b8690090c3500db5846fde12e11ce78b73ec9b85f86f2bc5e719ff116672b28c9b29c0c933b19986267a82254a969b924d4ec12093404c7d170ee1b57515234e945b93b2492bb6dbc24bab7b236845e2c8e45ecf7c94e27e7d731f20e5c70b4b5cb9d994efde73acdccb2bc2f0ee5d254938cc7cf360996870907e25a909178ecb76d3e797096365f0c766ce4aa9383e48f24d072bc3e230abff2f8d73a4028c7665308ff007a133153122697f7b3553963bbeee399b9b399f0ef607e4ce65d9f381732c166bda5b9a99649c573d38e72e9a267f70b2e9b2f5c9c8303387c330a56a0c08202e6cd55552827f20b198952cac951529ea5df4fcde3f57e3ba98760f80cfb2ba792fba35d27ac9acf7714f9a1a54ff25a53af6de7cb4eed41dfd5acde8a83d245fdf25ebbf0b6d0f937979e3a18f8cc4a55a98e93b91578db5885151268523673193889b7a9236d8c69d308151570d52edebf38fc1f5dac7564dbfe363c4a932b5aba17245f7178a6ec2db3930c482ce01e8378537fe6f1e349dd9ce434243bfe7037a56279d6256fd22a09120d29bf5da24002244883d34005e8475810433d6d00d3f94011f7eb0ce5dcec28fbc2c177bbd98417883210a252eec37d87ca352c34ed2cc75002a2ca1e31a3a55a7e5f7c64cb5355d9c3d3ca3aa8567091a4256c1bf72ccc952a64b5a662e5ae5a8291325ad52d72d408214950a8218104541148fd7be04e63f09f6e6e57e57c92e6ce6181c9bb4270365d311ca5e65e346957174b42352f018e50aa96b4a13ef6587d7a7dfa07bcf7815f8b3869cb05aa002c3ebb46f6c973dc56578cc1e3b038cc4e071d80c54bc5e071f839eac3633073a5282e5cd953525d2b429214142a088fd7fb03dbdadd9cad534fa882ada2af150af464fd1ab4ef7dfe0d48bf4a9d45984bc9b4fd4d16b1e9db8ca3cd4e58945ed25fa9add3594cdf5c79c03c4fc03c539d707f18e5189c8f88f20c69c166b966252ea92aba264b58eecc95313a572e6a1d3312a0418e3cc460d8e91abf8a9b88fd7be06e25e5ff006f6e07c2f2f398d99657c19da778532c3278178fa6e1d32303cc4c3cb04feeb8d9696d4b0c4cd948758d466c94965cb8fcdfe65f2df8b3963c4f9af0771be478ac878832a9a65e270788699266a092113f0f347766c9983bc89a870a0762e23ea7b5dd8cd2e93470ed0703aaebf0bacdaa752d69425bba5592f52ac76e919af4a0da78df53a3508ad4519735296cfc1f58cbc24be9dd60e0b9f294554629034906bebcfc634b5a34a5552415500aeecff846e8c5e14824a3536e6debc6346992cd684034a81f48fc7357a3945b6d1e64a19b1a4a9240040531342d6115a85083660e0166b52331483a54d529aa459fce2829f2bbd87ce3c59c1dec64d27b98e65d94e4d5857e1bfe105234efabf889173d7d758b542c4b3bb06368ad5deee8764fc446f48c1c6e8cf94a8b05295a9cdd8ef0404a9d852d535addbe821d401208480db0a7481dd71a4317ef8b0005a33e5c60adadb8828e00d286aa48ad21140951157069a4d07a68720a4951715a03776eb0121dc13b315020855b6f568a5ac40802bc803470cf786008d8249f3a88604015bd999dc56beba400c0692a5100d1c027cda21457504294b876625c39228fd214a6afdc6d377702ff007c5aa0a0d50f7201aaab09a13614a39160d071b2bd803bb451e9f0837820b10189f1ab7940b1bb354529eab01adb927e9e114ca59402ed74beee367178249290e081677f5d60593a994c4b020ba8b41249480f448b79c4e64f1b014248f88d7e24c020925ebb3025e2cd2451c9a57a36d1282ec49b105da0a2ef802682010e52ff0011b7ca10a496670055cfaf4f1730d35b85300f785d2e1ea1492ed7fa42cef805612f7356ab1a43ff00a68ed4d41c186667a31517a77ba41059c508ddd2cd04982b51094a6ba8ea6200eeb342824d024241b751e30e520b3d2b4a071689f0b74b11488e5f10005ea03901eb57f1fe712e1c96241eed6bebf288a0c1d340cc48f5e50854ec5201ff005114f9c1ab2210c934d4aa926e4dbc225c9d45c90d761d61403a9aacfb0a08b2af56605b60616ba491200e4558b8a002b0038abd3c7cff00943390a4d1c11de058010a0a88ab0abd0778d4c4257570586b400b35fe5688141cb2aa031ea2b0ae7492407d2c3bcc1a0588252c08a1a383b43a01aaf67dba7cbd7488d717a316ac0077357a3330a7e0d0c3521d254e3622e7d52256e0525dc1a10cca22204b0242b51550bdf7fe70e5c3d8b51c1af9c4b1a8b0ab189495d31ed00a303a5ac4881507bcfde3706819bf0877677040760ad87842287c3e547b443577923da10ee0800bd1dd80852598daae4befd20105c1e977b7941048a9350e03317f9c4ac6492150d4d4723abe9f380ea709fa39a1f282e8770e9068a2683ca036ad9b486605da19bda23c8250407174d0803ac2a48ef302481b97a410e094bb849b910372e2d609b9838f402a753d0063e2efe51655833382ca36f38007c24961e548b080141ddae0b313d1fee89b62c9817e10457fed5075789526e0b3005ebbef049a1b97a1511ea90ee4d593ddeedd89ac552cdc210580a6e2d6880872a2c002ce934866d804b8ab15577fbe1492c924509d2c0014ea616ea001e9a85092d5a9b33c070e48b8a54440140921b49d9de010093464bddd9e18b0080e43dd3b8f28890585480f50ab8bc301de700d5d9850888ecf405aa5854d6166f204b508a2bbc545b788496d49040bb80f0e58b81de043b12cd0198835481620387859ac8014b0043820bd453cdbe70ae94ece4870a677ead166c6a7512ecd430a4b962c46e0d3e862795b4015371a41660abb79c4ee92007bd00a0603782ca57c659c33b50444a5a8581157ea22b64020bd02348147620fd601643b5c9dcd7ce19ea48146a3976b33c4290ee0934ab876313cb7d80b503ba492039adfac10f75331b0ddfc6230b925c774b507ca08ea5401341bbb4136b6014124d003d5eb0970549525ee55723c1be716153fc4598d3cb7f5e10a43501d448e8c18efe50b5ac09bb6ea2d67102c18176a38b8862c082ce4060198daf0875014b0a8b1f57834b1617c6056214400b208fd7d7ca0825b48491aac15e5b41ef2582492455c9b1853521f53e96ee8eb77859d8109006d5e9e17f5e10ce4f40e69e10ba480e47753401eb0c124505941c115220af8b80804a493740d4349bde2775ba17a026912b50ddd6a59cf8c330487049258d4383b344a57ca021ad0a5f48a78faac21d2fb25ef56686249620b11f215a44176207453d8f9443c6e0841008482c6cff8985a3d8a481b6f7afdf161a0d21ca945dc8e9d605694ef3b97ad6b4f5d60f6c01524bb90a2a6623ed08256c486503767fc21ba547d6ef785d2083406a0124b115866c044b3d544bf4a06ade2e26cc09f1b14c269a8d3f322a6d1121aa544bd28debfa416d80424b9a29477d36880381dd25ba50c317ef02a4f77c40850c40228c2ecf482be0037503a4775805504460129b036bb03069521aa5eb7f90825092772455db4fcfca0d3be400295a6e350a0714221bfd40fd900803bcf782d62588b006c3c5beb03ed354b97f3f9c1e30b60302c9f84107602bf3fd60275282525dcd8584105f666a382faa0e92090974825eb7f5fa412f2054a2e0d1c91e2c3c62b20e9d4ec00d2dd23234d5561bbbdff009fe90852e5cb5aa96a44b8f82003f106aad98d1e25d85090684ed4a7e711aee4dc33077bd3ca0821ea2a455838feb10a38b809ef336a606bb0544280c3ed3822aab0da21297dd89b5beffce03ecc2858826d164ba020d2582ae36555e22921c129a92e34db6870c525d36aa4c321892edd00344903d5a0a3e281504b151b86a7843048b31ef50951a43e901c12cd4667782121f490e5dea7e87f189e50402a18977f877f5f84046c0ea0450034eb410e4876d25dea5ebd20860493ddeebd06a27d7e71651f000d20e9d4fa5d9c5fc60046851fe17767f1a3c14ab487000634043edd219aa49d4092e2ae3e43d5a2ca37d89b1592da49253a4d40b8f5f9c43604312a0c3c20a83d85477ab6fe71623a3115e8f5fe71ac6372ea391800eda9d92da806f578b512c8340496a7f0404cb1473449abb38f08cf912bde16a333b59a3ae8d172782e9024c92a2c4775bff6eac6ab270eb29a798043bb6f1648c312bd2401d1c53c5fd6f1bb724ca31b9ae3f0594e5780c566599e6188460f0181c0e1d58bc763a74c2132e54a94975296a2400901cc7d270de1f2ab254d2cb765e2df4496efd874429b79b1a7e5f976227cf9187c3e1e7e27158a9f2f0d87c2e1a42b1389c4cc98a08952e54a482a5ad6a525294243a890008fd71e0ec3641ece2e5f4ae62718e5397e79daf798dc3d364f0070be3823172b93b95e213eee76618b4b9f778998fee9453fe6288549414a7df2a353e15e5ef02fb3c781329e7273972fc9f8b3b51f12604e2b955ca4998a4e2f07cbb331040ccb345a1c7be92140ad687d2b3eea512bd4b4fe51f34399dc59cd5e2fceb8eb8e73ac4679c499f624e271f8dc4299096712e54996ed2e54b4f7512d34481d5c9fd99e9e8fb96693df7a9b3e3b38fdee0d27ef38c97e12a27ffdc497e0e1fd0faf2f4f952f592870c87793cea1ac2fc5a7f09fe5bf82be0eef3636df17718673c579e671c47c459962b37cf73ecc6766b9b6698d9a66e271d889eb2b9b3167aa8934140000280471f4f9ce55dea0aab49aff00487c4cfd4eea3d00b98d256bd4ed47b8dfd7847e0bc4f89d4d55594e726db776dbbb77eadf56fc4f1aa54bf522e6072ef4f84758c65292411a99cb9a445134bdf73b4565852a58d7a47cd4e6dbb9cb2776427efdcde07d7c3c2096059dc352b68009163191503176de21a78f94125fa9ea4de0b800338735eb11902c4825b6b6dd62448041276e9bee60448020f27825b676f1880026b6eaecd1198d6b4d8c47500eb13af944f2dedbc162edbda24022c42994370d507ac293b0a35f6730b04fa835044c0fa8500b0347f4d19d271001f8aa055b68d152a2f727c05232533186efbd583fe71d946bb834cd23369e4e40c933dc5e5d8bc362f098c9f83c6e0e7a31782c5e1272b0f8ac24d96a0a97365cc490a4ad24021492083bc7eb0f2db9d5caeed8bc2396f25bb4ae3b0fc35cd8cbe51c172bf9d88968c3fef53541a561b325d12262941295cb99fe4e241749933802bfc6c933c820836dc748dc783cc8cb282090c69bfcfd7847eabd87edfebbb3b5e746518d6d1d54a35a854cd3ab0f06b7535bc2716a50794f74fd3d1eb6a699b49294258945ed25e7e6ba3dd3f94ecbf3c3b3f731390fc533785f8fb245e0d734ad792e79854aa7641c49241613f05886650218aa5969887650b13d79c5e0882a6bea7668fd0ce4a76cacb733e1097c8ced3f92af9a9ca1c40187ca736c5ea9dc6dc065b4cb9984c603ef66224de5a9fdf4b00a42a64b69630f9e1d8cb30e1ee18ff16791bc448e74725f1d8656652b3bc93dde3b88f87e4a4f7ff7f9126931327e199365a4290527deca965e3f40e37d8fe17c7b87cf8ff60a4eb6992e6a941b4f51a7f1e68afc2525d2ac1356f5d45efd75f4b4aa43df1a17cd0eb17ebc7dabaaf092f95267e6fcfc2b1240d2d5527a7aeb18265b16502ca3f16e6d1bca760c29d63bc1628a4329247cae23489d84208ee9a06adbc008fc4f59c3dd37e8a3cb946eb06df54b0752810749b6960d1592a0482904a9cb35e91a8cc92a96df1778ba8e9207ca31949513aaec1830b523c2ab46507666125d0c4005dac6a0063f842288512c3bc7714de32cca3456e1f5063de7f08a4a1b512097f9171e1d63070cdd116cdd14338ef00000e6afb42b24924fda2e00b37afc62dd2ecc92d66623688a417d4295a8168a722647278959db52433333545e012974d12373fe98b4053b9622ed762214802bb135dcd621c0a72b1082a5b800740ed0ad46649049009a284580973de276d6016f089b15004934253b5222d6d911ec142430a0243d0d8fce204392ce07db00553e10477685d807debea90c010b008212589fb415fca2391b26cee29607bae0f505923e50077a8371f16d1624100b0a0a6e483b4148274817513dd2e1e2ae29152a0927e20e086000622fbc36863523526a5c57ad62c2ad21d4c492c2b4a75880543d0167245a16b029294809b02cec4bbc0008f8a9a8dec445b566aa58ed527ca01a006ec686bf2872d9e408ee433902eab7af288438621c5fa7afe70c094d140b11f16e47e1fd202412e0856925d245d2622d8c014a4900800a9d824f4f389a08a07a9ba76bc304100024862eccdf586d4e450d43741f2838e01531003073b83e1e11000350058bec21c934043f43e50ba48a84b0bb073a9a21c6d60201b54bdc8b784335a8e47d21be2729f85fbe36bc2966d203dc3ee7a43971616217a5454d0fd042b0d4544f4096a0a411462ce49243dda90c5e80d080e0312ff3872e501145aa002f43ab68660c1d81e86d0400b60cc056b6b43692f54d5e84920c428ae805604d5c3d3c036df78805d81e95702a62c090e4d19350db5e000b7248ef585c0f5fa44a8bf01ec214f46aec6e60a430b8146ad4878806a4ad240245944314d6cf0cca006c48653b91167076c8148ee80eea3520da10b920822962cff48b48f89c83bd3ecd2df8400cc09058d030f86bf94428e304fb0af48014ec1c3b1814afc566614b458c5c51d920860e2210eced7a902ade311c9b1054521890d453e937ac1482413627e2005a2d500ff09364dea1bf380520a98d5ead676f0872ae80ac268c4065105248a93d3e50e12007777343a58a7c2199c0666167a69f211188772ee1d999ba4392eefd45b222922c0901be13bc12c53572c3cde090c05492f6b85081ab48b0000dd4c625c7a92216d234924dabbf8082f63548372da9fc6082e030ef0b93636bfade204925240b310e5dba9884922004814151573e2d1030621d8f76a1ab049f06abb5403d61d9f6a0b00193b44722b8b15350efde7d2d5f3689a412003403e15178b8806a4914e87d6d159019dcd7ad0f94438a5b002490cec082c3f94332544a9212ca1b063bc4a92a0c055d80b4324024b776ac46dbda0d3784815800bedddf88971019c396a9660189ac5a2808d2430a101f61b40297a12416a1ab5dde2ca2c948466172d4a9a8de21019dc3bef682a042594e43b9a1a33d621d4aad34d9fc1a1669902e92cd40e6e6de1e5059dec3f33eb68720298834dcd58c293d5d8d1c6c61cb7041a48228ef616fe71090496a0706f101d340c433b0fb568b0023623ed3d5e21261085a848176296aa614809762935a0b458429b773d430855249ab6f5bb86e916e4ea08053e0029e705894a4ea092031714f5fac4d42c1d4407bb8f97841a97f1d80a8f5488b780b6446172092456940dbc2948018292db6c61c102a43ea2c4ee1af10ddaa5203a410c20a2d605bc0562e452a356cea1008003b82e2e90c4168b00d4cfa52a228c6bd2d10a5d81356e97fe711ca0a0120b6a67ab6de51616d269637058911280b03501daef0589258b9b9616fe5051e800a00171b8772d0039a356a4eab5e18853d000df351f182013500a892433b6fd6252b60159014e5d882f5346ac1604826e18d3bbf745bd45ca4b1ad222817058bb59d9834397664d9dae565eeedb39b9f5f9426fa46aa0a1fd3af9c5a492e08258b824337afca2ba05070fa6aec5a165620843d881e268cd04048dc920316ad5dad043390d5b3915107492a537c4f6b3c4d834409b020873dd077f388a48a1eed6a960431e87d6f0cc400ad2492350af9fdd0c19547622950585af11cb8053a15609009ad9e00a3a6c1d981bb45ff001060490ec762a8450be9203070901cd37112a09010a451802598d438f548650034ee366eb5821812480028b92e411d60a92422ef5721ddfa4230ce09b09a4ac500e801761e022682962cc7a39ac584b8ad350b02c4fce0329e94494d3c216b8b362300007a8a903ac1241513a8120ba4757bc129751ba4eaa86a1804779f496d8310d12d35b916698ba6a0b5c5857d79c120d99dac36871f78a8a587e910b3902a5c58c412cadbc0b8a968034922a5ae69a9fd522c28ab805cd19e9bed0a0354a5ebf2348463d110401c003482f714768b023bddd00915219b4fafca26aeebdf4dfc62cd5de493aaa2ecce3a4594644d99414ea762c8b815fbe2ca3170e2c1a8a543a9eaa0da5ddc06da102544aae776e80f58ba8936bf52281d429b31ada149296a86173bc31274bdfadeb788c410ce03548b0a44f2a6ac4a8bbe404692492faab54d3e5e30c19925c02c5c350c304960d6fb2eff002feb16a457bc86a3970febac5947c117515d0a580724003a116820126b5d3ddd2e1c6c3f087d04be97538a7f0b79c3897a8259ef5bb5faf945d41bd8592c952504b8636727a0f08c844aab54167041f2f5f38b51289fb2e4eeade3365e1ca88241a8b6d1d7474f272562d66ca24c8aea3de7a31b1f5f946e0c1e11994401a838f0f28186c19040d3f17dff00ca3b4bc8aecc7c7bcee9cac7e5a991c35c079615cdcff985c400e1f8772e95253ae7fba5123dfad090494a48420075ad223ec7b3dd9de25c6b5d0d070ba12ab5e5b462b3e6df4515bb949a4965b4b27550a152acd53a51bcbc11c47c07c01c53cc3e27cab84b83b25c6f107116753c49cbf2cc04af7b3a6558cc59f8512d1754c590948a931fa889c2f293d9c791a332c7e2320e6c76c6cd32ed797e5a1b1fc21c9f44f477553502a672428925644d9e5825326502b5f137117693e5af66fe15ccb965d93a42317c4d9920e178c39ff99c9462788734501a48ca494b2122beed600928075211316d307e6c6799ee3735c662b31ccb1d8bcc31f8d9ebc56331d8dc4af178cc5cd985d7366cd512a5a9449256a24924d63f53a9c4b817b9b69dc784ce1aae39d6baf4a8e95f5542f8ab5d7e39a7083fc1a93f4cf53bca3c3d5e8b52aff1b78c3f37c65f95b2e9779374732b99fc63cd0e2acdf8db8eb88730e26e25cee799f9866b994ef793a61ae9972d03b92a5a01d28952c25080000378e27c4e2aa46ad3b794262714a5299dd26b48d3262dd4e6ad47b18fc2f8b718d46babcebea26e73936e526db6dbcb6dbddb7d5eecf16a5594db949e7c7f8ea45cc2a72431d983b450a55aa1f7dbac052cf5a35aa7ca2a2a24926e77dc47cc55abccce594af8212e6eec3eb01e8df5f1880b1b3d2d12c5831da918377792a089043ec1cfe100bef7f180275f08907c3ac017ac012241d34770df7c488c300891224480b167db7f08113fa5e24013c62413573e312c695170f0043d4335bca010d11ff1788ef00102e5d9a1c29f4855402c48de10024b0106cf622d7803290b60c077ace691972e7e9a1bb3d8469893624b354d59ff009c5ba894b0db73f1178e8a55a517b968c9a66e4c3631419cb6e08bc763f90fda4b99bc86cf7fb5b8133f9b86c262b1099f9c70ee34ab15c3d9e14d019f87d41a63504f9653300a6a2291d5244c5218a4f87808d465628a5570362418fade03da7e27c0f5b4b5fc32bca95683bc6516d35f2afa56cf6d8eca35e7464a74e4d496cd1faff2b28ecc7db3973266458bcb3b3c73f3320a9f3323c50968e04e36c514ba978500210662d46b2e484626a48913402a8e92f397b3bf34b91f9b2f2be60f0b6372ec3cd987fb3388f0493997096768165e17304032893bcb594cc4d414831d76c1e6cb9242b5fc242aff000905c17ea08041ead1ddae58f6dce63f0a64aae11e324e039b1c0389969c3e378578dd5fbdcd328306918d5256a4a9203244e4cd4ffd4bc7ebcbb51d90edad2ffeaba7ef5e21ff009aa105c937e35e82b2bdf7a946cdeee1267abef8d1eb23fed2b92a7c68ac3fce8feb8dbd8ce98e2306493aa801a0fd634b5e1c25d92e9ba5443b5fd7ce3f4b6672b7b307688933319c9de311c9ee3c9e9330f0171b050c831534bbcb94ad4b5201341330b327a0b87952ed1d54e68767ae6bf2966cc4f19f0962e465ae449e20ca1633ae1ac50a80a978c96e90f42d30255d447cc71fec1719e1fa6fba9a68c753a17b57a0fbca7ff15bd2a6ff0026a462d1857e1fa9a50efe294a9fc68e63f2f54fc9d99d7132b4972c494bb3d62b521542a21c7743d1c3efe1e31ad2b0c4a9d22f50527552918ea905dc54243282adf58fcf27a4ce0f3b971734a54b2f64eab9296bc54a944a5c5c1d6e6a6f1a92e48d3e2eec492fe114943824ed40c6a3ce3927a769dcad9f434f29d2c401aaee902978a8a49761a9ba815a563515a024209bb3b338378a552ca8b814376da399d29f8116b189a0874905ddc860deaf04249516600554090c7a345fa0b9092d4a6ab9aec614a08410a2c5dd35aef58a3a6d7422c8a03025c393f11268febf18290904963a9efd445fa0b5dcaace6152850353bddeff00a4147172395780896d2aadc3b333fd7d56168e1bbcd67bec5a2e5219c86d4cc9d926102496704048a9d4fa8fe515e5f023915ee2ba0162e6b40c3c7f9c400b13a804a7e6d0e50e0d192e6aa2c6f09a54a3a6a12ce4fcbf08851ce08e57b0aa00ba52492087d9fac46a1704915a871d21c259dd835f551e2c4cb554ee0b126d13c8dd87278328002887eee9f01f874fd2210923bafa45087f548b84b054c6a5d80109a5802d427c7a41c52c16e442b9292f500d1ead018923663f315ac5c8941892df37a180a410c43b3d892e5e23948e44211520e92c2a129eeb7842a9dca5ddc3bd9a2f090904f79c0706c214a08009aa89777a343955acc282dcc6a55bbc9b4029012351097a1376a45e65a9dc5c9701f6f088a0412c028b3bb5216b2b12e37561003f6882e6b4bda0e8abb5cd767f11162142ae412aa3da23294c09512283a0f285ba9550f12a29074d6c2be206d0c407ee96ad02aad5de1b410586a208624ede70fa4bbb16dcb96f941c71627916e53a6e0bf7892aaee6269245482c182768b1292481600b3137e9e5e71348049ef38a100b0da1c8b741455f02a505c80962923480407ad20b9034b062a2ce013478b10ec5dc36e4b130950e19c1147fce16e8472742b34729297b3e9a1b444a99d9409296a068661e3a45d8bbdad0740b81dd7a3965082824af60a37c084103a277259fe5000a12c4351e941e1160495353528508347a5a26924b162e1e87ca91362d6c58ac0704351c3ea2d0424bd68453a937de0aae053a312c4c0d0ba31a80c5cb81ebf38a3895942eee0d2490a26a90dd5dfd08629f8490c006019afb430480c1c82dddafe30ecc1214ee684dd87979c4f22c91c8cab4804b9482cd40c3eb100048a8074d68e4ff005862080c68c6e4d98da031714f006da443971664f266cc4a02cf5e96f9c10ddeef0725c801de2ed29702fe243b402d4a915601d8088704c8e4655a1cb96721812cdd2200cf50372f61163822bf20f5785d2dd0ea1463f4fc227915ac4a8e2cc422e4172a21fa7af088436a2f4b820507cbc619e8cdbb313410492f4240d2e3c6915e5bbf22ad5de115e9200018922a68db3c32430a3518dc026b114097a9f1d9aa219801504a86db1f4f13c8ba93c9b00805c0ebddabb08058124962056acfebf382ea048d2ee96625d8b4466002a806ef7f9c4f2a0a2982b6040d42e3e1a56003b30246fd60e80436c58b5c082849aa8dace0d3630714c970f0152120b0b03aa8c37afaf08841550e967b06a3fe50c906e0bb96249da21208d3561650b18722b58851cd981810521945363a6c29bc412d8e9777371b430d2036a0e4b52a0c12d61421d86e3c22395dac472bdc5608533853066158801254f404b8f0856538340d77e861d89a5df7bc392c5b93c05d2e7605ea1af02a48601c580b08b420545411e2c21822c0331df7f918b58725960a424006ae5c82081f8c2d85c126a0b00a78b8a5882055274807edd21749a5c56d720f8c428a89093b610a5e84e900f40017f1884b7c576b914de0901dcd1cb16f3863a54e949510cc01ac3950e5ba29218a9c3a5ddfca0333149660e68e9abc5d3016d2ccc5897b8e8f1129a690ec6bd62796fb1651c0a5c8218381450b5bd7d60949a0a54b3860de10e0258bea766f03782c49d4c093773688e44396f8134f911aa8a0cff388ca21810586929b90f0eda400349248700b915f2821944b12522e4163e7687222391ad8a3480c1c100d3baff7c0003006a1eac1da320a525cd41b11e5d6292080c033dba130e4561caad915418300080281203f98f5b4280e7bd62c428811757e262e6b436b5a2049d5b80ce49a0bc4a56560a2ec2eeeee9b0701edd3e710259cb806c7aed0c41d3a81f10e2febac40f4ab13521a862bcb8b0e4c9035e82ae1c8ef39a78f484292a56ab1d5d3a78c580b3d01d8ee47dd008018037b87ad22545ad8951b3c08c6874f74509a30f0782c352825812188358b34b390cc4d03c12964176648eeefbc5ad60972acec52451dea05f726224b2433072c2829d5a2deeb10dded86c3ccc428a5dc12e49a1110d5c59ec54cd5a5037400748242957372e5cbb748b1481625c93ddab8a44d34624b03400dff0094396db8e5294bd2a001de0684c30a860c6b660febac380a2e0b0209b1681a4d480a1b80433561ca872f88a4294424350d402c12f04a4820382dbd2b48734009f889704d6d0a5cb905cdc877afd223955ee3910a5c94d5201b8001dc57eb0cc9005ca88635a083a49766e80125eb78b44b0e93de7f1da2d6b92a3e057a5c0d290fa751adbe5d627c65851cb1203c6409400550b90d776a75874cb2080d72e40163bb4691a6d85148a132e8a0083a8b10cd4ad7a7f486f720ead20a810da480092df9c65a65920b377ba17a561fdca8a5253a5c6eec36bc691a3276659276c185eeb490920b9a0058317bc3892c18d5440241aed198892a2a4a89058b9ab18ca4c8200d3d43d1e91d30d3376b9651b9a72652891a40008e81fd52332548ef3955ec5a351978415ddc39ef308df1c1bcbae34e3dc7232de0ae15ce789318a58414e59833364ca24b3cc9c5a5a3cd4a023d2d1f0cafa9ab1a1a6a6e7524eca314e4dbf24b2cd21465524a30577e5b9b1d1812740d219dc00193f28df7c17c03c4fc779de1787b83f87f34e26cf718b089196e4f84562a700586b9847765a06f32614a4354c771f86fb3272d795f86471076a6e6565f909972fdf617963c158c4e6dc51989da5e231080a32de8e8912d77acc963bc3038bfb61cbe1ecaf17c19d9bf82b2fe4e7072d1fbbcfcf132e5e2b8f33d480c664f9eeb4c87bb6b9d31ff00e91168fd4347d88e1dc1a11d776df54b4f1fc442d53552c2c725f968dfc6b4935f11ecfd1a7a2a7473ad972fe4accdfea8fcb6f6337f659d9e7923d9c30384e27ed55c4b86e28e2f9b23f7bc9b917c118d4e3b1b8b50aa4667894a80129e8b5a952e450813261eec70573f3b5a71bf393072f84f0f87c070272b72d4a30d93f2db851030390cb93254f2118ad0947bfd042542594a65050d410eca8ea9e6d9fe3734c6e3331ccb1b8acc331c7ce33f1b8fc762178bc6e2e61bae6cd592a59f151b46d6c46354c4053bd1ddcc73f1df742a54b413e07d96d34747a19594e306e556b5bad7aced2a9e3c8b969ae90ea2bf10fbdbd3e9a2a9d27d165cbf3a5bbf661791aa637312a76592e6ae5c98dbd88c4925435034a35e285ce2b50482fd4ab68c75a810e589dfa47e43ace213af2bb67933a99c854b528b3dfe16118ca5396b31d2f13536f4259c1b456a2e4ff58f22a5573c9836dee42497ddfc2b10f93758113c7ac625421aa096714816f389ebce080ee7a073d6008d477f03d60416a3bfca01a1bbf8c01016b44890490d40dd77780044821c391b4488bbe809406b50ed02241003de83ea62413ad5ba52f11ade3e310b6cff003bc08009feaf00025db60f0402451aff00388ecc41368000f36822be1d2044da0020b3106a20416af4fbe051f76fbe0025a8dd2b105ea586f00f9bc1605858ee4d04016850a9722acd0e1401f13f58a06faba3826085b1045080d4de2d19b8ec4a6d6c674b9da52c49f2bed199271250410a2092cc6d1a41994617bb81d22c4aecd520deff0048eba3ab9c1dee6919e726efc3e673251410b20a541419897163e71d97e5bf6ade6f72ee5cbc0e5bc4e73ee1c32fdce2384b8ca52b88f219f2d98a1216a13e5062434a9a13d50ab4750d136800a3176eb172714a494b1ab8241b47d4706ed5715e0f5957e1ba89d29aeb1938dfc9d9e5793ba7e07551d5d5a52e6a3269f93b1fa54be67f644e6fc9d3cc9e56e67ca9e29c40217c57cb8c501977bc511df99874cbd0a4bd48561c2aadef0de368e3fb2664bc53ef315c94e72705f30f0e5267a327cc66a720e22941fba95cb7520ab6a845b68e88231ca490ca0d715b467cacd5485a26a54a973e5281953a5a8a274a20b8289808524f8a4831f5b57b6da0e30dcb8fe82955a8f7a94d77151f9b705c927e6e9bbf89d7efd85556af4e2df8af45fceb1f41cc7c5bc87e6d706226af3fe02e20938492a21798e0704acdb2da07ff007f20ad206f522387968f753172a620a56144196b065ad1502a0d4794731f0cf694e72f09a512b28e60679370e81a5386ce678cf000ccc999382a7240db4cc0db46f49dda7e6f114bf77cc4e5af01f19ad45a6e3e76568c2e64b76726694ad6e7aea8f3a543b2fab7cda6d54e8dfa54829af6735377f979119ca3a59bbc26d7b55fe95f61d6654a4822a1bab5cd62954b60f47b304b066eb1d8699c47d9e33d738be05e25e129ca2e57c3f9a2b15212eefdc5ad541b0098a870bf67fcc094e17997c45912e677928ceb215cd948a0f8a609607df1c93e01197a5a7d6509afed391fcd514190f4ead78d48bf96df4348ebb2a4905d9cee1adfca019403850215400007678ec69e51f02e3543fb0f9d3c1988d67b92f19311849e4bff00099a0fdd02672171f349fdcb8df82f1696002d39880955ea1898e797673895ef1a6a4bf267092fa24ccfded56f857f664eb99424a4f74b26940fb42682012d4772088ec67fc1df8954001c4fc1a126b5cccfff00730c7b3b711246b3c53c14ef6fed523efd3192ece7166eddc3f9d7da47bd351f159d71d15f8545b763b3c1286674a8877d4d6f08ec58ecfbc46ee38a382c11b0cd4e91f3d30abecf1c4a9000e27e0a5eeffdb1a7efd315fe4df15dbb87f47da3de9a8b5d419d715851a31235f7593f743094a98a6092da6a34bd0476213d9e789d4aff00be3e0b2914ff00e2d002f5a698cc4f673e2a235a788b838386739b103ff7582ece714bdbb87f47da4ad26a3e2b3adc9c310e0a097a06178224aee5259a8c0b08ec8ffc1f38950489dc4bc189090cc8cdcac1f13ddfc6281c82cf4a8eae28e10a83dd4e69a8a8fd29b45e3d9ae2affa17f3afb4b2d1576bd5675e13281a8497b249eeb1f3806490c0a58a4d404dcddfd78c76313d9e7890a43711707d4507f6a95247cf4b7e919927b387132804ff007a382bbc7ed66aab7fedb05d99e2f257ee1fd1f691ef2d47c567598cb3634dc109b4284877292cc46a297fa476895d9a38a4254dc51c11a5ebff007516fe1f623117d9bf8925973c4dc15a522ba734517abdb443f933c596f45fcebed1ef2d4758bc9d6a12947495024124fc3de05af01482f40e013452587ca3b1e7b3cf10a03ff79f8380b53305161e1dd851d9eb3f5d071470826a59f1cba5af48a7f26b89dace8bf9d7da3de5a8be2275b8a002ea497ba75508fe5012820b2480e0d5ab6ac76693d9bf88a60af167047fa75e6a5c7d12620eccfc42904ab8bf812c5929cd94a6a7fd583ecc717fc4bb7b57da4fbcb537c47ea3aca2592a3dc494bb2481dffa45865e96a6f50469223b1f37b3be7f2080ae2ae0a5299fb99b126e2b5118b33b3fe7fa93a389b8454ff1139890df36887d9be2b1c772fe75f694f7aea16f13af0b9648a82e3e101dc53d7d214483a58391a892e7e18ec37fc1fb3f53b713f062502bad59a37dc43c5d2f9019d4c21278ab8374eabff6983f9ef155d9ce2b24d774fe75f68f7ad75bc4eba7bb482ca059ee47af4615492345190e48223b22becf19e94809e2be0d20592332afaf08a0f679e2100ffc6ae0b0360735a0fbb6885d9ce2a9fe05fcebed1ef5ae9e63f51d74d00105b517f1a78faf181a425c07d40921839178ec70ecef9e92908e2ee082a153ff0075ca40af56ac04f673e23528253c55c0f53719da7fafca1fc9ce2cff00a17f3c7ed1ef5aebe09d71097b8ee80db820b5cc3685103ba0eadecaf068ecdcaecc3c57310549e2be040821c039d06dbc23167f672e23c329099bc59c0aefa404e75a9eae7683ecd7188c799d07f3afb497a3d4ade1f51d70f76926b4012c4228776100a14a494ecd57a2a3b0879059da41278ab83c350819a383e168ae5720f3d9ea3eeb8ab831d474b1cda9f8457f93dc516f45fcebed2bef5d47489d7ff71a40b9ddfa5e91152a9d4a83820563b2c9ecd9c4c7495f17703a42839ffbaee7ff0075ac2ccece3c452c1ff8dbc12a0fdd6cd14c455becc1f6778a7c2a2fe75f692b49a8f8aceb5896a4b16029dd0ce60e82b0fde0f76eafb7dd1d82572073b44c099dc5dc1686eb9a311d5dc0874f67ece95f0717f03e8362acdb40f5e313fc9de2a9628bf9e3f68f7a6a1bb28fd475e4ca70c75380c3bbf0d778864ab57fa74815143d63b17ff07bcf002a3c65c0ada99c67209fc2914ab9079c22fc61c0efb039c80ff7447f2738abfe85fcebed23deba85f04ebee9600694b92fb8678accbe882ef43b90fb7ada3b00ae44e669049e30e070a776fed74a89eb157f81b992880ae30e0736a8cdd2081157d9ee2ab1dcbf9d7da3ded5fe29c07eed2e74a4bbbe96a1702d0049d2a20d01a802a7caf48ec07f80f9a120a78cb821deeacdd29008f1eb1948ecfd9acc0e38d7804b0b7f6d873fac55f67b8a5b145dfdabed1ef6aefe09d74329f6a6e599fd7e7044bee81571465505beb1d83ff01b34495eae32e052906e33905beeeb18b3f91f98a589e2fe0c2402404e680edb88abe03c4ad6ee9fcebed1ef6adf17ea38126214da74806c58549f1f08509d448ba824071678e70ff0671e9042b8b3830281df354d6a232b0fc89cd712a025f18f024beebbcdcf52906fe112b807146eca97c975f690b4f5dbb28fd4703e971501c3870ed68265db51533f7925355476265f679cef4a5f8d397eeee48cfd27a6ed0cbecf59d8208e36e5f69f87bd9ea1856d5897d9ce2c95fb976f6c7ed2def5afb72fd475d1b5100100b55ac441d2084d28a0cadd348ec1afb3c672897a97c71cbe294d5939fa144dcd3c2310722b3624a55c61c0cd67feda4927a522bf70389df95d2b3f6c7ed23deb5fe27d47027b8becc41d37d5586f7234dc970eca053a7e71cfe9e43e646dc65c0e950b039c255f227f587572133448255c69c084a85bfb6c06a576895d9fe26edf7afa57da1e9abacb8fd475f7dd804d084f8dc9a4112c0662e7a9a9f9473a4de486609212ae32e07553ece749005a193c94c7dffbe1c10906808cdd247d20f80f124b34be95f691ef7adf14e0912885292a170e090ef4fbe1d28b821c5ac43473d8e476653024a78d3812a6e739093f5e913fc0cccdd5ff001d381120dc8ce8311d4f48b2e03c45ac52fa63f693ef6afd22702996e3e10962c4bb83bc432d4027f859c06a878e7dff0002f1da40fefb7019d2976fedb4de21e4663d4cdc6fc0e081619ba540fcff00187dc1e22adf7afa63f68f7b56e91fa8e00320a8020b0f1722219440214a748b9bbfdf1cf5fe05e62135e35e0622ec337048f28a66724f1d2d80e33e0d524d0919953f088fb83c496d4be98fda3ded5be2fd4704841b946a00f4f8bc22692f449a903e1aff005a4735ff008378d0b63c63c1a120d49cd457e462e1c9c9ec3fe3af068a57feea258f8de2ab817117874be95f691ef7add23f51c20a964200d2ce5b62b36852850ef1af7451d835639ce4f2631138a9f8e3821041d235e6a96f07ad23594767cc7ce09d1cc0e5d24a8392acf92142e7eb178767f8a4dfa347e98fda4fbd350f2a3f51d75d202412aa0a589310a53ba8d6b4168e7c99c83c6cb529f981cbd5049290519d0d269f48affc07c700c9e3be025105dd39c02ccd132ecef164ece8bf9e3f685a5afd23f51c0ba491dd4f5a914f0801242835c74054f1cf6ae47e3101293c75c0a6ac4ff6ab14f50f17279198b5057bbe38e0648018139b07341503f3885d9ee2b7bf73b79c7ed1ef6aff0017ea38092ce4004eeede23ef8712b55425c03725826fb7ab473cab9178b4f78f1e701209dd59c00d58c69dc989b24a41e3fe005929ef046729ee9fafdd157c03892c3a5f4c7ed2af4f597ad1fa8e0c54963549569b100c29438152a2f61431ce88e4dcd5964f1d702aff00eae728207956351c3721b11886d1c7dc012c9bebce521abe716fe4f714934a34be98fda5969abbda3f4afb4ebba9259c219fe178b132ea1c330727a476457d9e31890907989cbb6677feda02b58c6ff83fe3c12dcc0e5e9bd7fb6d21469d22dfc9ce2b15e951fa63f693ef5d43c72fd475d349d474a4bbdcb8864a1c5803b96731d81572271401238f797fdd2c149ce924dfa3c5039119882e38e7810035639b303e115fb81c4ff13f4c7ed2bef6aff17ea3814024285c0a788f5b41282a02b560cc9a9ac73f0e43e319455c7bc080a8b00335d63c6b00722f10829278fb81496aff00dd4b8ad8c1767f8a4b2a95fe58fda4ad36a3e2fd470004692a64b3d8925a182161cb824534e97023b10390eb50d4ae61f0123feb66ac0f9c21e452d00253cc5e5e9ab923394ea1f278d7f937c552e6ee7fea8ffa87bd6bf58fd5f69d7d0977775747a04f94012c804876ff0050358e7c5f24f4b83cc4e00019f57f6a8ab79454392c4395730f97e402e1b37049f134fc633fb81c4def4ffea8ff00a885a6af8c7d2bed381fdd822896a77ae5ff00943993f0e9235375702a2ff9473ba792a54544730797c1d34d59ca52030e91909e4609941cc8e5d2540383fdb69fc62ffc9de276c52ffaa3fea27deb5ef6e5fa57da75eccbd4297dee5aa7f485f742a0b1eed0805ad1d89ff01661aa798fcb923f8867c849fa3c22b90f350358e62f2f0f4233c407f9bc47f27f8a2cf75f4c7ed21e9abade3f51d7c08209776d4f67119450000fb1771b47399e48cd49091cc1e002c09514e748512ed60f5812b92ca130fbee3de0844b047f99fda8850fa6a1484780f137fd17d31ff50f7b56f0fa51c180280a87480e055c8fac5fa0920849721c12fd58473bff00843c332169198f37b81f0208db152a6696f0f7c18c660e07e4b65ee334e724bc72922b2f21ca4e375f509290b11d90e01aefe93923f9d569afae45bdef34ed2b7cebed380c4b650eeb10053c6bb758c9129099614b504b9a92a0903c0473b999d9b32c42493c7fc4f3d0c08d432ac3ccbd0964163f58ba4f3a396bc335e0ee4af0dab1485032f30e289873bc4a486ae999ef12e2f468e9870ad15057d66b6925e1172a8ffe88b5ff0051754e9c7329ab7cace29e1fe0de25e279e6470df0ee739ecca07cbb2f9b3e421cb3aa601a40f1244760f25ecadc66ac30ccb8e33ce14e5b651a02e662b88f35973712ccf4928501aaf7588d8b9f76a3e6d67489986c2e7f2386b005202303c37809580972802e0a16a0a520f8a34db68e13ccb89332ce71471f9d663986738d53038dcdb1f3733c586b01326a94a03c0103c23be96abb21a1cb855d4c97c66a943e68f3cdff007a2cd14f4b0cd9cbe85fadfd477130d23b2bf2bca26e2a6f1073b788241d49969232ce1542c59a5a4a525208fb532606fb2634ae31ed6fcc1cd305fd87c15272ae5370ccb41952f2ae08929c2e63390d69b8ed0929f2c3224deaa378e9f4ccc940972127f89dc9b4604cc7ea72fa9af467731ad5f741e23a6a0f49c15434b49e1aa31e593fcea977565e779d9f813f742b462e145f245f48e3e77bbf9cdcf9867589c66227633198a9f8bc44f515cec562a72b11899c4d495cc512a51f124de3459b8f2a172435e345562545ece4d5da9149985575774dc1fba3e1b53c52b56937296e714ab333276209b311e1184b980317218317158acac0219811b522951d4497defb98f22a6a1c8e773bec5aa5b0704872e68d152d4e5999af0a5546141d20509f0f368e7949cb7297bee10adadd1a8d008a38a8b3c08978a82417a11b3b880d47a7d6b05e8cc2eefbc46e0110fd3ca24489011b507eb04307fa06ac2c480251fa8fa44f9410056b6b0eb03ce0024b9734f2890224360489e3d6096043546fb40800bd1be9022375bf489004b4482febac47a11d60011208617aef107912768007f5860c487663b0a340200a1776ad620d8125bf088dd60108e96dbac089eab13f0e91206a91e42ff9406b33178029040dcd9eb0d8020b916a40820062e58ec200b04c554bdae1d843098e5cedf568a5f6dba0a3c4b55a2549a0652544924bdecef0e2692eca722952e230c331726bb0112b71402a3eb1a2ad245b9a46789cab16721ab478226a882eadd8d6ad1a7ea35a9afdd102c8f1f3a98da3aa9c49e766a699e00a1268c2b7f186fde1490e935a3b1627ca34c0a35ad6e035e0fbcdcee188112f5936b71cecd4d588749d5df27f886a78513659ae894490e5e5061f7469def0fd9bf95e26b5a7c010cd11efa7bb1cfe28d484c9668654b01ebfe5a7eea44332593feee590283fcb0e6be51a6fbc218bd5ba41f7a486a31a9a5e23df37dd0535e06a066cbd34422ed44023f0801687aa25374f763f48c0d63735db7a44d742df32d430f7c636279d7819e26a0172897766d097fc21bdf20820a25861fc0973f7469bac0dfe6d13de752f4a3d227df371cebc0cef7882484cb45e87dd8fd2d104c4337bb478932c3fe1183ef08b3d9bca0159a5bca23df1e4473aea8cf1390edeea5d68fa12e3ee8899886aa258ff00b09b75b460fbc23605fce20984586ff2895a8439a3e06799c805c4a9668c1903efa41f78861fe5cb7373a0003ee8d3bde10ccc7a96686d4a6a070f40d53788f7c2b6c39d7819bef502a654b2e2802053c6d10cc4547bb97d4f7006fba34fd676fac1d7f56b35223df1e439d5b6338cc48a044b2f6ff2c57ee829520b12996fd0207e91a7eb2d5fba913de11b6df3877ebc0737919e66268344b77b681fa43fbc403feee596ff00d969af85a34e727bc0122cd0def1418bd48b44fbe3c8732b6519a998853bcb401d7dda7f487136555a5cb0db9406f3b469a6628d361683ac82029e8ff387be1780e64b6466fbd439ee4a60687dda4bfdd0a662764218efa438fba313de12189a6d4a42959ab0f9c477fe43997819a6624b008960efdc07f281ad3ba50f6709053f846115a8bd6f102cb3127c37310aba5b2239bc8ce0b151a25b3515a057ee88169241d32e82ae80c7c59a30b5a8d1e0eb37777f8bc227bf5e04f378232cac12da100589d007e50e95a121ca65a80ff40af85a3042c9047d183b44d66f5041b43be5e039fc8d444d43149972c067732d23f285d682404a1054d6280df84601984d1e87ea20eb50a937a0221dfaea8732f0338a93a8008964355901ff00083ad2eda2597ad1007e518299aaddcb74abc1f7a2a7e800f0a982acadb0e75e0656b482da1043ff00003f940d690e4a50e2c9d03f48c3f78a7bdefb44f7876ab0688efd3e839fc1197ac17ee4b0f407481f9442abba658ffb029f7461eb248661582ea2e05ec6b588ef97811ceccd1305bddcb66a9f76927f08226249f825d28c109afdd183ad4c6960c7c626a2e4f4dd8b44f7f6e84f3f919e2624903ddcbad5fdda437dd014b4803b92ea0fd80ff846115b7c26c7eb7802610f57715261df5ddda239bc8cc2a0ce1283aa806803f2864adc10532e95f800fca3082d46c3e910ad40eafa529055927b052b74328cc1464201dfb81bf087d428c89646e34006fe5181a94d404d6b4783a802497ffaa0b3415649e113cfe4666b4925928005c940a1fa4452b490c25973bcb040fba3135ab4824021e9102c814634a837885556e4733e866898827e096c6afa006fbb684d753dd4102e740fd23135977347b8d8402b73e03a521df74b13ccba232c4c4ee94751dd07f2881757d092ff00e80edf48c42a2f7760c28d0429556b5c8356877c4737919c56800809976fe00ff840f78977d12fe17ff7619fe918654c7c0d69b42eb20bd3a31877cba2279eeb633f5a69dc4576d20b785a015a4a7504cba7fa07878461052aa5a8438e820fbc2c3a3f95627be5e1f411cd9d8cb1352c0144bffdb0027ee81ac3be84d6c340fd2313592f4f3616e900a8d36eac61df0e77e06705a2a74a0ffd8000fba06a4a816084b5fb803fdd186161218396a8da26a51f26ad18082afe414acad633c29043e9976fe11fa402b40769693d06815fba30759604dea457d7a1042cb136eb4710efbc50e7f14660988a3cb4071b20521b5a19f420935a2030fba303de36c1bc6f07de17a9a6c5a913dfa7ba279fc8d435a439f76863404a057ee84f7a903e0975db4871f746219ae902a086aed0a6658de8cd60227bf0a5e46699c08aa1047fd41d7ca0152080529490431ee87fc23082f6b0f289ef08f3b10d11dfdfa0e75e067058be8406b0d00bfdd0e2627ff152dc8be8493f3a4606b3521c0667eb03513b923c99bca21d61ceba23304d4ea1dc974bf71343f487134025e5cbeafa0007c6d1a7998ab74313596bd77a7d21df25d073f919c67258012e5de84a011f2a41f7a91ff472df61eed2ff0084609994605eafe0627bc200635019ba44f7f8d873af03355352df04bad5f427f489ef41009972cb1ffc5a453e9184564b96f10599e015dafd5acf0efc73f4b1a809891abbb288f0969fbe903de203f725a89343a07cf68c07096d9d34a5a205900d013e5587be316b0525d51a809c837972d9fe2f763f4882625ffddcb21efeed2df8469dac925ec6bd1a0ebb31662fe70efd780e6b6c8d435cb04ba11a5a8420127ee802623ff1481e680ff85e307de16bdac227bcdd8b8352f05a8b741cfe46a1ef904565ca0761eec7e9104d96c47ba43ffe4c57ee8c02b7b1f025a175a9c8dba35627df3e439a3e06a227236948f16963f4bc37be14ff002a5d4dfdd83f94698567a83f289ef0b5dc3d9ad0f7c790e7f235513d92740097b948d2f0153cb31512e7554dec234dd640b900f81681ef1fa96f0fc2256a9a781cecd43df92c5e8cf0ab9c48d42841fa52307de114048aef002daaec7cadf7c4bd54873bb19def8ef56f8b7784335659cd2e91b08c4d54ad9dfc6ffd214a8aa8df4de3375e5d073bb99456a2e54482776a456a590e6a40b562a048a12474ea215ea5b7a54c66eac995726f72cf797bdbeb0854a26e7e50b05e8d4f90a98a36d90473772fd5e20a9bfd62785bce2067ada2002244820b6c0c18210dead02241a378bc002241a51bef8848a30b5091bc012ee681b6811224420482d47d9da0416ea0da8d1208d77a308112240122448900489d296dfac489004891224012244890048912240122448900125c93d6044890d812244890048912240058d9ab7f1884d7a01403a4489004a537a5604489004891224013ccede712244802447f2fa4489004891224007c19cbde04489001a3789b7840f5e71224006ade16b440c4d4973e0f1224010390df93b40f0fcab1224013d5444bc489004891224012231e9122401036e5be4f12244802448912008dd2be510c489004891224005a8ff940891200911a24488780482fbd3e912244820241a5fc9e0448900483634fbc44890043b40b5b68912002f421afbf48112240068de3f8c4daaec2c5a244802352fe74b442e4026d61489120020d6acc6a68f114c6a2b4ad22448016086dced66bc489004a1adab602d0224480244bff002891200906b6614156158912009b7ceb12acdb3bc489000eb122448027cff9c134a3da24480006de0f85eb489120083716f316811224006a3e75a8811224012244890043e6f0c59aee5fa522448015e8d4fce244890017152d5fa88112240122448900488090edb8689120091224480241bd40f36b4489000f1fca0924d4f9448900083534f9b44890008671564b3f8bb4489002c4891200203efe43ac0f462448019dc126f4630b689121b00b51ebf4a44b31fca9122400097891224012092ed4660de712240022448900489122401224489004891224013d5a244890010d5a54da24489007ffd9"
            writefile(path, (hex:gsub("%x%x", function(pair) return string.char(tonumber(pair, 16)) end)))
        end
        return loader(path)
    end)
    if ok then Library.LogoAsset = asset end
end

Library.Window = function(Self, Params)
            Params = Params or {}

            local Window = {
                IsOpen = true,
                Title = tostring(Params.Title or Params.title or Params.Name or Params.name or "Panel"),
                DockButtonText = tostring(Params.ButtonName or Params.buttonName or "Main UI"),
                Pages = {},
                Items = {}
            }

    
            local Items = {}
            do
                local D = Library.Design
                Items.MainFrame = D.Box(Library.Holder.Instance,
                    UDim2.new(0.5, -410, 0.5, -280), UDim2.fromOffset(820, 560), "Background", 14)
                D.Stroke(Items.MainFrame.Instance)
                -- A dedicated title-bar drag target prevents dragging while using controls.
                Items.Header = Library:Create("Frame", {Parent = Items.MainFrame.Instance,
                    BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 66), Active = true})
                local dragging, dragStart, initial
                Items.Header:Connect("InputBegan", function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true; dragStart = input.Position; initial = Items.MainFrame.Instance.Position
                    end
                end)
                Library:Connect(UserInputService.InputChanged, function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local delta = input.Position - dragStart
                        local parentSize = Items.MainFrame.Instance.Parent.AbsoluteSize
                        local size = Items.MainFrame.Instance.AbsoluteSize
                        Items.MainFrame.Instance.Position = UDim2.fromOffset(
                            math.clamp(initial.X.Offset + delta.X, 0, math.max(0, parentSize.X - size.X)),
                            math.clamp(initial.Y.Offset + delta.Y, 0, math.max(0, parentSize.Y - size.Y)))
                    end
                end)
                Library:Connect(UserInputService.InputEnded, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
                end)
                Items.MainFrame:MakeResizeable(Vector2.new(720, 480))
                Items.Sidebar = D.Box(Items.MainFrame.Instance, UDim2.fromOffset(1, 1), UDim2.new(0, 178, 1, -2), "Section", 13)
                Items.Logo = Library:Create("ImageLabel", {Parent = Items.Sidebar.Instance,
                    Position = UDim2.fromOffset(17, 17), Size = UDim2.fromOffset(38, 38),
                    BackgroundTransparency = 1, Image = Library.LogoAsset, ScaleType = Enum.ScaleType.Fit})
                D.Round(Items.Logo.Instance, 9)
                local brand = D.Text(Items.Sidebar.Instance, "NC", UDim2.fromOffset(65, 16), UDim2.fromOffset(95, 23), "Text", 22)
                brand.Instance.TextSize = 22
                D.Text(Items.Sidebar.Instance, "CONTROL CENTER", UDim2.fromOffset(65, 40), UDim2.fromOffset(105, 14), "Inactive Text", 9).Instance.TextSize = 9
                D.Text(Items.Sidebar.Instance, "WORKSPACE", UDim2.fromOffset(19, 85), UDim2.fromOffset(140, 16), "Inactive Text", 10).Instance.TextSize = 10
                Items.PagesOutline = Library:Create("Frame", {Parent = Items.Sidebar.Instance,
                    Position = UDim2.fromOffset(12, 115), Size = UDim2.new(1, -24, 1, -185), BackgroundTransparency = 1})
                Library:Create("UIListLayout", {Parent = Items.PagesOutline.Instance,
                    Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder})
                D.Text(Items.Sidebar.Instance, "NC / DESIGN SYSTEM", UDim2.new(0, 19, 1, -47), UDim2.fromOffset(145, 16), "Inactive Text", 10).Instance.TextSize = 10
                D.Text(Items.Sidebar.Instance, "Version 3.0", UDim2.new(0, 19, 1, -28), UDim2.fromOffset(140, 16), "Accent", 11)
                Items.HeaderInnerOutline = Items.Header
                Items.HeaderTitle = D.Text(Items.Header.Instance, Window.Title, UDim2.fromOffset(200, 19), UDim2.new(1, -430, 0, 25), "Text", 18)
                Items.HeaderTitle.Instance.TextSize = 18
                Items.HeaderButtonHolder = Library:Create("Frame", {Parent = Items.Header.Instance,
                    AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -20, 0, 23),
                    Size = UDim2.fromOffset(190, 24), BackgroundTransparency = 1})
                Library:Create("UIListLayout", {Parent = Items.HeaderButtonHolder.Instance,
                    FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder})
                Items.DockOutline = Library:Create("TextButton", {Parent = Items.HeaderButtonHolder.Instance,
                    Size = UDim2.fromOffset(80, 24), Text = "", BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme.Element, AutoButtonColor = false})
                D.Round(Items.DockOutline.Instance, 6)
                Items.DockText = D.Text(Items.DockOutline.Instance, Window.DockButtonText,
                    UDim2.fromOffset(8, 0), UDim2.new(1, -16, 1, 0), "Inactive Text", 11)
                Items.ContentOutline = Library:Create("Frame", {Parent = Items.MainFrame.Instance,
                    Position = UDim2.fromOffset(194, 70), Size = UDim2.new(1, -210, 1, -106), BackgroundTransparency = 1})
                Items.Content = Library:Create("Frame", {Parent = Items.ContentOutline.Instance,
                    Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1})
                D.Text(Items.MainFrame.Instance, "PERSONAL WORKSPACE  /  NC", UDim2.new(0, 201, 1, -26), UDim2.new(1, -225, 0, 15), "Inactive Text", 10).Instance.TextSize = 10
                Window.Items = Items
                Library.MainWindowFrame = Items.MainFrame.Instance
            end

            local Debounce = false

            local function CreateHeaderButton(Text, DefaultActive)
                local ButtonData = {
                    Active = DefaultActive == true
                }

                local ButtonItems = {}

                ButtonItems["Outline"] = Library:Create("TextButton", {
                    Name = "\0",
                    Parent = Items["HeaderButtonHolder"].Instance,
                    AutoButtonColor = false,
                    Active = false,
                    Selectable = false,
                    Text = "",
                    Size = UDim2.new(0, 0, 0, 16),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({ BackgroundColor3 = function() return Library.Theme["Outline"] end })

                ButtonItems["Inline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = ButtonItems["Outline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Border"]
                }):AddToTheme({ BackgroundColor3 = function() return Library.Theme["Border"] end })

                ButtonItems["Background"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = ButtonItems["Inline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = function() return Library.Theme["Section"] end })

                ButtonItems["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    Parent = ButtonItems["Outline"].Instance,
                    FontFace = Library.Font,
                    TextSize = 9,
                    Text = tostring(Text or ""),
                    TextColor3 = ButtonData.Active and Library.Theme["Text"] or Library.Theme["Inactive Text"],
                    TextStrokeColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    ZIndex = 2,
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                }):AddToTheme({
                    TextColor3 = function()
                        return ButtonData.Active and Library.Theme["Text"] or Library.Theme["Inactive Text"]
                    end
                })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = ButtonItems["Text"].Instance,
                    LineJoinMode = Enum.LineJoinMode.Miter
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = ButtonItems["Text"].Instance,
                    PaddingLeft = UDim.new(0, 7),
                    PaddingRight = UDim.new(0, 5)
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = ButtonItems["Inline"].Instance,
                    PaddingRight = UDim.new(0, 2)
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = ButtonItems["Outline"].Instance,
                    PaddingRight = UDim.new(0, 2)
                })

                function ButtonData:SetText(Value)
                    ButtonItems["Text"].Instance.Text = tostring(Value or "")
                end

                function ButtonData:SetActive(Value)
                    ButtonData.Active = Value == true
                    ButtonItems["Text"]:Tween({
                        TextColor3 = ButtonData.Active and Library.Theme["Text"] or Library.Theme["Inactive Text"]
                    })
                end

                function ButtonData:SetVisible(Value)
                    ButtonItems["Outline"].Instance.Visible = Value == true
                end

                function ButtonData:SetCallback(Callback)
                    ButtonData.Callback = Callback
                end

                ButtonItems["Outline"]:Connect("MouseButton1Down", function()
                    if type(ButtonData.Callback) == "function" then
                        ButtonData.Callback(ButtonData)
                    end
                end)

                ButtonData.Items = ButtonItems
                return ButtonData
            end

            local function UpdateDockState()
                Items["DockText"]:Tween({
                    TextColor3 = Window.IsOpen and Library.Theme["Text"] or Library.Theme["Inactive Text"]
                })
            end

            function Window:SetOpen(Bool)
                if Debounce then
                    return
                end

                Debounce = true

                Window.IsOpen = Bool
                Items["Header"].Instance.Visible = Bool
                Library:SetWindowVisibilityState(Bool)
                Library:SetBackgroundEffectsVisible(Bool)
                UpdateDockState()

                Items["MainFrame"]:FadeDescendants(Bool, function()
                    Debounce = false
                end)
            end

            function Window:Center()
                local AbsPos = Items["MainFrame"].Instance.AbsolutePosition
                Items["MainFrame"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["MainFrame"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y)
            end

            function Window:SetTitle(Text)
                Window.Title = tostring(Text or "Panel")
                Items["HeaderTitle"].Instance.Text = Window.Title
            end

            function Window:SetDockText(Text)
                Window.DockButtonText = tostring(Text or "Main UI")
                Items["DockText"].Instance.Text = Window.DockButtonText
            end

            function Window:AddHeaderButton(Params)
                Params = Params or {}

                local Button = CreateHeaderButton(Params.Text or Params.Name or "Button", Params.Active)
                if type(Params.Callback) == "function" then
                    Button:SetCallback(Params.Callback)
                end

                return Button
            end

            Items["DockOutline"]:Connect("MouseButton1Down", function()
                Window:SetOpen(not Window.IsOpen)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            Library:Connect(RunService.RenderStepped, function()
                if Window.IsOpen then
                    Library:GlobalUpdateOpenFrames()
                end
            end)

            Library:RegisterLayout("MainWindow", {
                Instance = Items["MainFrame"].Instance,
                SaveSize = true,
                MinimumSize = Vector2.new(720, 480)
            })

            Library:RegisterLayout("MainWindowDock", {
                Instance = Items["DockOutline"].Instance
            })

            UpdateDockState()
            Window:Center()
            return setmetatable(Window, Library)
        end

        Library.Page = function(Self, Params)
            Params = Params or {}

            local Page = {
                Name = Params.Name or Params.name or "Page",

                Window = Self,
                Items = {},
                Pages = {},
                Active = false
            }

            local Items = {}
            do
                Items["Inactive"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Page.Window.Items["PagesOutline"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({ BackgroundColor3 = 'Outline' })

                Items["InactiveInline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Inactive"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({ BackgroundColor3 = 'Outline' })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["InactiveInline"].Instance,
                    Rotation = -90,
                    Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 172, 172))
                    }
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["InactiveInline"].Instance,
                    TextWrapped = true,
                    TextColor3 = Library.Theme["Text"],
                    Text = Page.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border 2"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border 2' })

                Items["Page"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.UnusedHolder.Instance,
                    BackgroundTransparency = 1,
                    Visible = false,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })

                Items["Columns"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 10),
                    Size = UDim2.new(1, 0, 1, -10),
                    BorderSizePixel = 0
                })

                Items["SubPages"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SubPages"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 15),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["SubPages"].Instance,
                    PaddingTop = UDim.new(0, 3)
                })

                Page.Items = Items
            end

            local Debounce = false

            function Page:Turn(Bool)
                if Debounce then
                    return
                end

                Debounce = true

                Page.Active = Bool

                if Bool then
                    Items["Text"]:ChangeItemTheme({ TextColor3 = "Accent" })
                    Items["Text"]:Tween({ TextColor3 = Library.Theme.Accent })
                else
                    Items["Text"]:ChangeItemTheme({ TextColor3 = "Text" })
                    Items["Text"]:Tween({ TextColor3 = Library.Theme.Text })
                end

                Items["Page"]:FadeDescendants(Bool, function()
                    Debounce = false

                    if Items["Page"].Instance.Visible then
                        Items["Page"].Instance.Parent = Page.Window.Items["Content"].Instance
                    else
                        Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
                    end
                end)
            end

            Items["InactiveInline"]:Connect("MouseButton1Down", function()
                for Index, Value in Page.Window.Pages do
                    Value:Turn(Value == Page)
                end
            end)

            if #Page.Window.Pages == 0 then
                Page:Turn(true)
            end

            table.insert(Page.Window.Pages, Page)
            return setmetatable(Page, Library)
        end

        Library.SubPage = function(Self, Params)
            Params = Params or {}

            local Page = {
                Name = Params.Name or Params.name or "Page",

                Window = Self.Window,
                Page = Self,
                ColumnsData = {},
                Items = {},
                Active = false
            }

            local Items = {}
            do
                Items["Inactive"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Page.Page.Items["SubPages"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Page.Name,
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                Items["Page"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.UnusedHolder.Instance,
                    BackgroundTransparency = 1,
                    Visible = false,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim.new(0, 12),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                })

                Items["LeftColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 100, 0, 100),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["LeftColumn"].Instance,
                    PaddingTop = UDim.new(0, 14),
                    PaddingLeft = UDim.new(0, 14),
                    PaddingBottom = UDim.new(0, 14)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["LeftColumn"].Instance,
                    Padding = UDim.new(0, 14),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["RightColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 100, 0, 100),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["RightColumn"].Instance,
                    PaddingTop = UDim.new(0, 14),
                    PaddingRight = UDim.new(0, 14),
                    PaddingBottom = UDim.new(0, 14)
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["RightColumn"].Instance,
                    Padding = UDim.new(0, 14),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Page.ColumnsData[1] = Items["LeftColumn"]
                Page.ColumnsData[2] = Items["RightColumn"]

                Page.Items = Items
            end

            local Debounce = false

            function Page:Turn(Bool)
                if Debounce then
                    return
                end

                Page.Active = Bool

                Debounce = true

                if Bool then
                    Items["Inactive"]:ChangeItemTheme({ TextColor3 = "Accent" })
                    Items["Inactive"]:Tween({ TextColor3 = Library.Theme.Accent })
                else
                    Items["Inactive"]:ChangeItemTheme({ TextColor3 = "Text" })
                    Items["Inactive"]:Tween({ TextColor3 = Library.Theme.Text })
                end

                Items["Page"]:FadeDescendants(Bool, function()
                    Debounce = false

                    if Items["Page"].Instance.Visible then
                        Items["Page"].Instance.Parent = Page.Page.Items["Columns"].Instance
                    else
                        Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
                    end
                end)
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in Page.Page.Pages do
                    Value:Turn(Value == Page)
                end
            end)

            if #Page.Page.Pages == 0 then
                Page:Turn(true)
            end

            table.insert(Page.Page.Pages, Page)
            return setmetatable(Page, Library)
        end

        Library.Section = function(Self, Params)
            Params = Params or {}

            local Section = {
                Name = Params.Name or Params.name or "Section",
                Side = Params.Side or Params.side or 1,

                Window = Self.Window,
                Page = Self,
                Items = {},
            }

            local Items = {}
            do
                Items["SectionOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Section.Page.ColumnsData[Section.Side].Instance,
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({ BackgroundColor3 = 'Outline' })

                Items["Section"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["SectionOutline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = 'Section' })

                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Section"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 36, 0, 15),
                    Size = UDim2.new(1, -72, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Padding = UDim.new(0, 7),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    PaddingBottom = UDim.new(0, 20)
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["SectionOutline"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Section.Name,
                    Size = UDim2.new(0, 0, 0, 4),
                    Position = UDim2.new(0, 6, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({ BackgroundColor3 = 'Section' })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Text"].Instance,
                    PaddingRight = UDim.new(0, 4),
                    PaddingLeft = UDim.new(0, 4)
                })

                Section.Items = Items
            end

            return setmetatable(Section, Library)
        end

        Library.Toggle = function(Self, Params)
            Params = Params or {}

            local Toggle = {
                Name = Params.Name or Params.name or "Toggle",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or false,
                Risky = Params.Risky or Params.risky or false,
                Tooltip = Params.Tooltip or Params.tooltip or nil,
                Callback = Params.Callback or Params.callback or function() end,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = false,
                Items = {}
            }

            local Parent

            if Params.Parent then
                Parent = Params.Parent
            else
                Parent = Toggle.Section.Items["Content"]
            end

            local Items = {}
            local ToggleButtonOffset = Toggle.Section.IsSettings and 0 or 20
            local ToggleTextOffset = Toggle.Section.IsSettings and 14 or 20
            do
                Items["Toggle"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, -ToggleButtonOffset, 0, 0),
                    Size = UDim2.new(1, ToggleButtonOffset, 0, 12),
                    BorderSizePixel = 0
                })

                local TooltipData = Toggle.Tooltip
                if Toggle.Risky and typeof(Toggle.Tooltip) == "table" then
                    TooltipData = table.clone(Toggle.Tooltip)
                    TooltipData.Risky = true
                end
                Items["Toggle"]:Tooltip(TooltipData)

                Items["Indicator"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Toggle"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 8, 0, 8),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({ BackgroundColor3 = 'Element' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Indicator"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({ Color = 'Border' })

                Items["Inline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Indicator"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = 'Accent' })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Toggle"].Instance,
                    TextColor3 = Color3.fromRGB(100, 100, 100),
                    Text = Toggle.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 12),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, ToggleTextOffset, 0.5, -2),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Inactive Text' })

                if Toggle.Risky then
                    Items["Text"]:ChangeItemTheme({ TextColor3 = "Risky" })
                    Items["Text"].Instance.TextColor3 = Library.Theme["Risky"]
                end

                Items["SubElements"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Toggle"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SubElements"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDim.new(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Toggle"]:OnHover(function()
                    Items["Indicator"]:Tween({ BackgroundColor3 = Library.Theme["Hovered Element"] })
                end, function()
                    Items["Indicator"]:Tween({ BackgroundColor3 = Library.Theme["Element"] })
                end)

                Toggle.Items = Items
            end

            function Toggle:Set(Bool)
                Toggle.Value = Bool

                if Bool then
                    Items["Inline"]:Tween({ BackgroundTransparency = 0, Size = UDim2.new(1, 0, 1, 0) })
                    if not Toggle.Risky then
                        Items["Text"]:ChangeItemTheme({ TextColor3 = "Text" })
                        Items["Text"]:Tween({ TextColor3 = Library.Theme.Text })
                    end
                else
                    Items["Inline"]:Tween({ BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0) })
                    if not Toggle.Risky then
                        Items["Text"]:ChangeItemTheme({ TextColor3 = "Inactive Text" })
                        Items["Text"]:Tween({ TextColor3 = Library.Theme["Inactive Text"] })
                    end
                end

                Flags[Toggle.Flag] = Bool
                Library:SafeCall(Toggle.Callback, Bool)
            end

            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool
            end

            function Toggle:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Toggle:Settings()
                local Settingss = {
                    IsSettings = true
                }

                Items["SettingsButton"] = Library:Create("ImageButton", {
                    Name = "\0",
                    Parent = Items["SubElements"].Instance,
                    ImageColor3 = Library.Theme["Text"],
                    AutoButtonColor = false,
                    Image = "rbxassetid://124244905334583",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 12, 0, 12),
                    BorderSizePixel = 0
                }):AddToTheme({ ImageColor3 = 'Text' })

                local SettingsItems = {
                    IsOpen = false,
                    Items = {},
                }
                do
                    SettingsItems["ToggleSettings"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Library.UnusedHolder.Instance,
                        Position = UDim2.new(0.5156353712081909, 0, 0.08411215990781784, 0),
                        Visible = false,
                        Size = UDim2.new(0, 254, 0, 242),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Background"]
                    }):AddToTheme({ BackgroundColor3 = 'Background' })

                    Library:Create("UIStroke", {
                        Name = "\0",
                        Parent = SettingsItems["ToggleSettings"].Instance,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        LineJoinMode = Enum.LineJoinMode.Miter,
                        Color = Library.Theme["Outline"]
                    }):AddToTheme({ Color = 'Outline' })

                    Library:Create("UIStroke", {
                        Name = "\0",
                        Parent = SettingsItems["ToggleSettings"].Instance,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        LineJoinMode = Enum.LineJoinMode.Miter,
                        Color = Library.Theme["Border"],
                        BorderOffset = UDim.new(0, 1)
                    }):AddToTheme({ Color = 'Border' })

                    SettingsItems["Text"] = Library:Create("TextLabel", {
                        Name = "\0",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = SettingsItems["ToggleSettings"].Instance,
                        TextColor3 = Library.Theme["Text"],
                        Text = Toggle.Name,
                        Size = UDim2.new(0, 0, 0, 12),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 28, 0, 9),
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.X
                    }):AddToTheme({ TextColor3 = 'Text' })

                    SettingsItems["Content"] = Library:Create("ScrollingFrame", {
                        Name = "\0",
                        Parent = SettingsItems["ToggleSettings"].Instance,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        BorderSizePixel = 0,
                        CanvasSize = UDim2.new(0, 0, 0, 0),
                        MidImage = "rbxassetid://86870199131153",
                        ClipsDescendants = true,
                        ScrollBarThickness = 2,
                        Size = UDim2.new(1, 0, 1, -30),
                        Selectable = false,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0, 30),
                        BottomImage = "rbxassetid://86870199131153",
                        TopImage = "rbxassetid://86870199131153"
                    })

                    Library:Create("UIPadding", {
                        Name = "\0",
                        Parent = SettingsItems["Content"].Instance,
                        PaddingTop = UDim.new(0, 5),
                        PaddingBottom = UDim.new(0, 5),
                        PaddingRight = UDim.new(0, 10),
                        PaddingLeft = UDim.new(0, 10)
                    })

                    Library:Create("UIListLayout", {
                        Name = "\0",
                        Parent = SettingsItems["Content"].Instance,
                        Padding = UDim.new(0, 5),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })

                    SettingsItems["SettingsButton"] = Library:Create("ImageButton", {
                        Name = "\0",
                        Parent = SettingsItems["ToggleSettings"].Instance,
                        ImageColor3 = Library.Theme["Text"],
                        AutoButtonColor = false,
                        Image = "rbxassetid://124244905334583",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0, 10),
                        Size = UDim2.new(0, 12, 0, 12),
                        BorderSizePixel = 0
                    }):AddToTheme({ ImageColor3 = 'Text' })

                    Settingss.Items = SettingsItems
                end

                local Debounce = false
                local RenderStepped
                local SettingsHolder = SettingsItems["ToggleSettings"].Instance
                local SettingsButton = Items["SettingsButton"].Instance

                Settingss.AttachedButton = SettingsButton
                Settingss.CanUpdateNow = false
                Settingss.Frame = SettingsHolder

                function Settingss:SetOpen(Bool)
                    if Debounce then
                        return
                    end

                    Settingss.IsOpen = Bool

                    Debounce = true

                    if Settingss.IsOpen then
                        SettingsHolder.Position = UDim2.new(0, SettingsButton.AbsolutePosition.X, 0,
                            SettingsButton.AbsolutePosition.Y + SettingsButton.AbsoluteSize.Y + GuiInset)

                        SettingsHolder.Parent = Library.Holder.Instance
                        SettingsHolder.Visible = true
                        SettingsItems["ToggleSettings"]:Tween({
                            Position = UDim2.new(0, SettingsButton.AbsolutePosition
                                .X, 0, SettingsButton.AbsolutePosition.Y + SettingsButton.AbsoluteSize.Y + 10 + GuiInset)
                        })

                        SettingsItems["ToggleSettings"]:FadeDescendants(true, function()
                            Debounce = false
                            Settingss.CanUpdateNow = true
                        end)

                        for Index, Value in Library.OpenFrames do
                            Value:SetOpen(false)
                        end

                        Library.OpenFrames[Settingss] = Settingss
                    else
                        for _, OpenFrame in Library.OpenFrames do
                            if OpenFrame
                                and OpenFrame ~= Settingss
                                and OpenFrame.IsOpen
                                and OpenFrame.SetOpen
                                and OpenFrame.AttachedButton
                                and OpenFrame.AttachedButton:IsDescendantOf(SettingsHolder)
                            then
                                OpenFrame:SetOpen(false)
                            end
                        end

                        for _, OpenFrame in Library.OpenFrames do
                            if OpenFrame and OpenFrame ~= Settingss and OpenFrame.IsOpen and OpenFrame.SetOpen then
                                OpenFrame:SetOpen(false)
                            end
                        end

                        SettingsItems["ToggleSettings"]:Tween({
                            Position = UDim2.new(0, SettingsButton.AbsolutePosition
                                .X, 0, SettingsButton.AbsolutePosition.Y + SettingsButton.AbsoluteSize.Y - 10 + GuiInset)
                        })
                        SettingsItems["ToggleSettings"]:FadeDescendants(false, function()
                            SettingsHolder.Parent = Library.UnusedHolder.Instance
                            Debounce = false
                            Settingss.CanUpdateNow = false
                        end)

                        if Library.OpenFrames[Settingss] then
                            Library.OpenFrames[Settingss] = nil
                        end

                        if RenderStepped then
                            RenderStepped:Disconnect()
                            RenderStepped = nil
                        end
                    end

                    local Descendants = SettingsHolder:GetDescendants()
                    table.insert(Descendants, SettingsHolder)

                    for Index, Value in Descendants do
                        if Value.ClassName:find("UI") then
                            continue
                        end

                        Value.ZIndex = Settingss.IsOpen and 2 or 1
                    end
                end

                Items["SettingsButton"]:Connect("MouseButton1Down", function()
                    Settingss:SetOpen(not Settingss.IsOpen)
                end)

                Library:Connect(UserInputService.InputBegan, function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        if Settingss.IsOpen then
                            if SettingsItems["ToggleSettings"]:IsMouseOverFrame() then
                                return
                            end

                            for _, OpenFrame in Library.OpenFrames do
                                if OpenFrame
                                    and OpenFrame ~= Settingss
                                    and OpenFrame.IsOpen
                                    and OpenFrame.Frame
                                    and OpenFrame.Frame:IsMouseOverFrame()
                                then
                                    return
                                end
                            end

                            Settingss:SetOpen(false)
                        end
                    end
                end)

                return setmetatable(Settingss, Library)
            end

            function Toggle:Colorpicker(Data)
                Data = Data or {}

                local Colorpicker = {
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Toggle.Name),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or 0,

                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Toggle:Keybind(Data)
                Data = Data or {}

                local Keybind = {
                    Name = Data.Name or Data.name or Toggle.Name,
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Toggle.Name),
                    Default = Data.Default or Data.default,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",

                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Name = Keybind.Name,
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)

            Toggle:Set(Toggle.Default)

            SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            return setmetatable(Toggle, Library)
        end

        Library.Button = function(Self, Params)
            Params = Params or {}

            local Button = {
                Name = Params.Name or Params.name or "Button",
                Callback = Params.Callback or Params.callback or function() end,
                Tooltip = Params.Tooltip or Params.tooltip or nil,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Items = {}
            }

            local Items = {}
            do
                Items["Button"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Button.Section.Items["Content"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 18),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({ BackgroundColor3 = 'Element' })

                Items["Button"]:Tooltip(Button.Tooltip)

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Button"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Button"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Button"].Instance,
                    Rotation = -90,
                    Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 172, 172))
                    }
                })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Button"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Button.Name,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, -1),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                Items["Button"]:OnHover(function()
                    Items["Button"]:Tween({ BackgroundColor3 = Library.Theme["Hovered Element"] })
                end, function()
                    Items["Button"]:Tween({ BackgroundColor3 = Library.Theme["Element"] })
                end)

                Button.Items = Items
            end

            function Button:Press()
                Items["Button"]:ChangeItemTheme({ BackgroundColor3 = "Accent" })
                Items["Button"]:Tween({ BackgroundColor3 = Library.Theme.Accent })
                task.wait(0.1)
                Items["Button"]:ChangeItemTheme({ BackgroundColor3 = "Element" })
                Items["Button"]:Tween({ BackgroundColor3 = Library.Theme.Element })

                Library:SafeCall(Button.Callback)
            end

            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end

            function Button:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            Items["Button"]:Connect("MouseButton1Down", function()
                Button:Press()
            end)

            return setmetatable(Button, Library)
        end

        Library.Slider = function(Self, Params)
            Params = Params or {}

            local Slider = {
                Name = Params.Name or Params.name or "Slider",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or 0,
                Min = Params.Min or Params.min or 0,
                Tooltip = Params.Tooltip or Params.tooltip or nil,
                Max = Params.Max or Params.max or 100,
                Callback = Params.Callback or Params.callback or function() end,
                Decimals = Params.Decimals or Params.decimals or 0,
                Suffix = Params.Suffix or Params.suffix or "",

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = 0,
                Sliding = false,
                Items = {}
            }

            local Items = {}
            do
                Items["Slider"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Slider.Section.Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 25),
                    BorderSizePixel = 0
                })

                Items["Slider"]:Tooltip(Slider.Tooltip)

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Slider.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 12),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                Items["RealSlider"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 6),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({ BackgroundColor3 = 'Element' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"]
                }):AddToTheme({ Color = 'Border' })

                Items["Accent"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({ BackgroundColor3 = 'Accent' })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Accent"].Instance,
                    Rotation = -90,
                    Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 172, 172))
                    }
                })

                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Accent"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "100%",
                    AnchorPoint = Vector2.new(1, 0),
                    Size = UDim2.new(0, 0, 0, 12),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Value"].Instance,
                    LineJoinMode = Enum.LineJoinMode.Miter
                })

                Items["RealSlider"]:OnHover(function()
                    Items["RealSlider"]:Tween({ BackgroundColor3 = Library.Theme["Hovered Element"] })
                end, function()
                    Items["RealSlider"]:Tween({ BackgroundColor3 = Library.Theme["Element"] })
                end)

                Slider.Items = Items
            end

            function Slider:Set(Value)
                Slider.Value = Library:Round(math.clamp(Value, Slider.Min, Slider.Max), Slider.Decimals)

                Items["Accent"]:Tween(
                    { Size = UDim2.new((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0) },
                    TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Items["Value"].Instance.Text = string.format("%s%s", Slider.Value, Slider.Suffix)

                Flags[Slider.Flag] = Slider.Value
                Library:SafeCall(Slider.Callback, Slider.Value)
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            function Slider:GetSize(Input)
                local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) /
                    Items["RealSlider"].Instance.AbsoluteSize.X
                local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                return Value
            end

            function Slider:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            local InputChanged

            Items["RealSlider"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider.Sliding = true

                    local Value = Slider:GetSize(Input)

                    Slider:Set(Value)

                    if InputChanged then
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Slider.Sliding = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Slider.Sliding then
                        local Value = Slider:GetSize(Input)

                        Slider:Set(Value)
                    end
                end
            end)

            Slider:Set(Slider.Default)

            SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            return setmetatable(Slider, Library)
        end

        Library.Dropdown = function(Self, Params)
            Params = Params or {}

            local Dropdown = {
                Name = Params.Name or Params.name or "Dropdown",
                OptionItems = Params.Items or Params.items or {},
                Tooltip = Params.Tooltip or Params.tooltip or nil,
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Multi = Params.Multi or Params.multi or false,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = {},
                Options = {},
                IsOpen = false,
                Items = {}
            }

            local Parent

            if Params.Parent then
                Parent = Params.Parent
            else
                Parent = Dropdown.Section.Items["Content"]
            end

            local Items = {}
            do
                Items["Dropdown"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 40),
                    BorderSizePixel = 0
                })

                Items["Dropdown"]:Tooltip(Dropdown.Tooltip)

                Items["RealDropdown"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Dropdown"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 20),
                    ClipsDescendants = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({ BackgroundColor3 = 'Element' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    Rotation = -90,
                    Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 172, 172))
                    }
                })

                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealDropdown"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "...",
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(1, -24, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0.5, -1),
                    BorderSizePixel = 0,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd
                }):AddToTheme({ TextColor3 = 'Text' })

                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    ImageColor3 = Library.Theme["Text"],
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "rbxassetid://88550711858254",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -4, 0.5, 0),
                    Size = UDim2.new(0, 14, 0, 14),
                    BorderSizePixel = 0
                }):AddToTheme({ ImageColor3 = 'Text' })

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Dropdown"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Dropdown.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 12),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                Items["OptionHolder"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.UnusedHolder.Instance,
                    Visible = false,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 210, 0, 50),
                    Position = UDim2.new(0, 1056, 0, 521),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({ BackgroundColor3 = 'Background' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    Padding = UDim.new(0, 3),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    PaddingTop = UDim.new(0, 4),
                    PaddingLeft = UDim.new(0, 8),
                    PaddingBottom = UDim.new(0, 6)
                })

                Items["RealDropdown"]:OnHover(function()
                    Items["RealDropdown"]:Tween({ BackgroundColor3 = Library.Theme["Hovered Element"] })
                end, function()
                    Items["RealDropdown"]:Tween({ BackgroundColor3 = Library.Theme["Element"] })
                end)

                Dropdown.Items = Items
            end

            function Dropdown:Set(Value)
                if Dropdown.Multi then
                    if type(Value) ~= "table" then
                        return
                    end

                    Dropdown.Value = Value

                    for Index, Value in Value do
                        local OptionData = Dropdown.Options[Value]

                        if not OptionData then
                            continue
                        end

                        OptionData.IsSelected = true
                        OptionData:ToggleState("Active")
                    end

                    Flags[Dropdown.Flag] = Value
                    Items["Value"].Instance.Text = table.concat(Value, ", ")
                else
                    if not Dropdown.Options[Value] then
                        return
                    end

                    local OptionData = Dropdown.Options[Value]

                    Dropdown.Value = Value

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.IsSelected = false
                            Value:ToggleState("Inactive")
                        else
                            Value.Selected = true
                            Value:ToggleState("Active")
                        end
                    end

                    Flags[Dropdown.Flag] = Value
                    Items["Value"].Instance.Text = Value
                end

                Library:SafeCall(Dropdown.Callback, Dropdown.Value)
            end

            function Dropdown:Add(Value)
                local OptionButton = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["OptionHolder"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Value,
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                local OptionData = {
                    Button = OptionButton,
                    Name = Value,
                    IsSelected = false
                }

                function OptionData:ToggleState(Value)
                    if Value == "Active" then
                        OptionData.Button:ChangeItemTheme({ TextColor3 = "Accent" })
                        OptionData.Button:Tween({ TextColor3 = Library.Theme.Accent })
                    else
                        OptionData.Button:ChangeItemTheme({ TextColor3 = "Text" })
                        OptionData.Button:Tween({ TextColor3 = Library.Theme.Text })
                    end
                end

                function OptionData:Set()
                    OptionData.IsSelected = not OptionData.IsSelected

                    if Dropdown.Multi then
                        local Index = table.find(Dropdown.Value, OptionData.Name)

                        if Index then
                            table.remove(Dropdown.Value, Index)
                        else
                            table.insert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:ToggleState(Index and "Inactive" or "Active")

                        Flags[Dropdown.Flag] = Dropdown.Value

                        local TextFormat = #Dropdown.Value > 0 and table.concat(Dropdown.Value, ", ") or ""
                        Items["Value"].Instance.Text = TextFormat
                    else
                        if OptionData.IsSelected then
                            Dropdown.Value = OptionData.Name
                            Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.IsSelected = true
                            OptionData:ToggleState("Active")

                            for Index, Value in Dropdown.Options do
                                if Value ~= OptionData then
                                    Value.IsSelected = false
                                    Value:ToggleState("Inactive")
                                end
                            end

                            Items["Value"].Instance.Text = OptionData.Name
                        else
                            Dropdown.Value = nil
                            Flags[Dropdown.Flag] = nil

                            OptionData.IsSelected = false
                            OptionData:ToggleState("Inactive")

                            Items["Value"].Instance.Text = "..."
                        end
                    end

                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Remove(Option)
                if Dropdown.Options[Option] then
                    Dropdown.Options[Option].Button.Instance:Destroy()
                    Dropdown.Options[Option] = nil
                end
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do
                    Dropdown:Add(Value)
                end
            end

            function Dropdown:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool
            end

            local Debounce = false
            local RenderStepped
            local OptionHolder = Items["OptionHolder"].Instance
            local RealDropdown = Items["RealDropdown"].Instance

            Dropdown.AttachedButton = RealDropdown
            Dropdown.CanUpdateNow = false
            Dropdown.Frame = OptionHolder

            function Dropdown:SetOpen(Bool)
                if Debounce then
                    return
                end

                Dropdown.IsOpen = Bool

                Debounce = true

                if Dropdown.IsOpen then
                    Items["Icon"]:Tween({ Rotation = -90 })
                    OptionHolder.Position = UDim2.new(0, RealDropdown.AbsolutePosition.X, 0,
                        RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y + GuiInset)
                    OptionHolder.Size = UDim2.new(0, RealDropdown.AbsoluteSize.X, 0, Dropdown.MaxSize)

                    OptionHolder.Parent = Library.Holder.Instance
                    OptionHolder.Visible = true
                    Items["OptionHolder"]:Tween({
                        Position = UDim2.new(0, RealDropdown.AbsolutePosition.X, 0,
                            RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y + 10 + GuiInset)
                    })

                    Items["OptionHolder"]:FadeDescendants(true, function()
                        Debounce = false
                        Dropdown.CanUpdateNow = true
                    end)

                    for Index, Value in Library.OpenFrames do
                        if not Params.Parent and not Dropdown.Section.IsSettings then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Dropdown] = Dropdown
                else
                    Items["Icon"]:Tween({ Rotation = 0 })
                    Items["OptionHolder"]:Tween({
                        Position = UDim2.new(0, RealDropdown.AbsolutePosition.X, 0,
                            RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y - 10 + GuiInset)
                    })
                    Items["OptionHolder"]:FadeDescendants(false, function()
                        OptionHolder.Parent = Library.UnusedHolder.Instance
                        Debounce = false
                        Dropdown.CanUpdateNow = false
                    end)

                    if Library.OpenFrames[Dropdown] then
                        Library.OpenFrames[Dropdown] = nil
                    end

                    if RenderStepped then
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = OptionHolder:GetDescendants()
                table.insert(Descendants, OptionHolder)

                for Index, Value in Descendants do
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if not Params.Parent then
                        Value.ZIndex = Dropdown.IsOpen and 3 or 1
                    else
                        Value.ZIndex = Dropdown.IsOpen and 6 or 1
                    end
                end
            end

            Items["RealDropdown"]:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dropdown.IsOpen then
                        if Items["OptionHolder"]:IsMouseOverFrame() then
                            return
                        end

                        Dropdown:SetOpen(false)
                    end
                end
            end)

            Items["RealDropdown"]:Connect("Changed", function(Property)
                if Property == "AbsolutePosition" and Dropdown.IsOpen then
                    local Section = Dropdown.Section
                    local SectionItem = Section and Section.Items and Section.Items["Section"]
                    local SectionInstance = SectionItem and SectionItem.Instance
                    local SectionParent = SectionInstance and SectionInstance.Parent

                    if SectionParent then
                        Dropdown.IsOpen = not Items["OptionHolder"]:IsClipped(SectionParent)
                    else
                        Dropdown.IsOpen = false
                    end
                    Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
                end
            end)

            for Index, Value in Dropdown.OptionItems do
                Dropdown:Add(Value)
            end

            Dropdown:Set(Dropdown.Default)

            SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return setmetatable(Dropdown, Library)
        end

        Library.Label = function(Self, Params)
            Params = Params or {}

            local Label = {
                Name = Params.Name or Params.name or "Label",
                Tooltip = Params.Tooltip or Params.tooltip or nil,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Items = {}
            }

            local Items = {}
            do
                Items["Label"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Label.Section.Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 12),
                    BorderSizePixel = 0
                })

                Items["Label"]:Tooltip(Label.Tooltip)

                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Label"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Label.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 12),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                Items["SubElements"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Label"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SubElements"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDim.new(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Label.Items = Items
            end

            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool
            end

            function Label:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Label:Colorpicker(Data)
                Data = Data or {}

                local Colorpicker = {
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Label.Name),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or 0,

                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Label:Keybind(Data)
                Data = Data or {}

                local Keybind = {
                    Name = Data.Name or Data.name or Label.Name,
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Label.Name),
                    Default = Data.Default or Data.default,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",

                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Name = Keybind.Name,
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Label:SetText(Label.Name)

            return setmetatable(Label, Library)
        end

        Library.Textbox = function(Self, Params)
            Params = Params or {}

            local Textbox = {
                Name = Params.Name or Params.name or "Textbox",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Tooltip = Params.Tooltip or Params.tooltip or nil,
                Finished = Params.Finished or Params.finished or false,
                Numeric = Params.Numeric or Params.numeric or false,
                Placeholder = Params.Placeholder or Params.placeholder or "...",

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Value = "",

                Items = {},
            }

            local Items = {}
            do
                Items["Textbox"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Textbox.Section.Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0
                })

                Items["Textbox"]:Tooltip(Textbox.Tooltip)

                Items["Background"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Textbox"].Instance,
                    ClipsDescendants = true,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({ BackgroundColor3 = 'Element' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, -1)
                }):AddToTheme({ Color = 'Border' })

                Items["Input"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Background"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    PlaceholderText = Textbox.Placeholder,
                    Size = UDim2.new(1, -16, 0, 15),
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 8, 0.5, -1),
                    ClearTextOnFocus = false,
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = 'Text' })

                Textbox.Items = Items
            end

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end

            function Textbox:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Textbox:Set(Value)
                if Textbox.Numeric then
                    if (not tonumber(Value)) and string.len(tostring(Value)) > 0 then
                        Value = Textbox.Value
                    end
                end

                Textbox.Value = Value
                Items["Input"].Instance.Text = Value
                Flags[Textbox.Flag] = Value

                Library:SafeCall(Textbox.Callback, Value)
            end

            if Textbox.Finished then
                Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
                    if PressedEnterQuestionMark then
                        Textbox:Set(Items["Input"].Instance.Text)
                    end
                end)
            else
                Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
                    Textbox:Set(Items["Input"].Instance.Text)
                end)
            end

            Textbox:Set(Textbox.Default)

            SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end

            return setmetatable(Textbox, Library)
        end

        Library.Searchbox = function(Self, Params) -- just the dropdown func with diff items
            Params = Params or {}

            local Dropdown = {
                OptionItems = Params.Items or Params.items or {},
                Tooltip = Params.Tooltip or Params.tooltip or nil,
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Multi = Params.Multi or Params.multi or false,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = {},
                Options = {},
                Items = {}
            }

            local Items = {}
            do
                Items["Searchbox"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Dropdown.Section.Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 173),
                    BorderSizePixel = 0
                })

                Items["Search"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Searchbox"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0
                })

                Items["SearchBackground"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Search"].Instance,
                    ClipsDescendants = true,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({ BackgroundColor3 = 'Element' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["SearchBackground"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["SearchBackground"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["SearchBackground"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, -1)
                }):AddToTheme({ Color = 'Border' })

                Items["Input"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["SearchBackground"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    PlaceholderText = "Search",
                    Size = UDim2.new(1, -16, 0, 15),
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 8, 0.5, 0),
                    ClearTextOnFocus = false,
                    BorderSizePixel = 0
                }):AddToTheme({ TextColor3 = 'Text', PlaceholderColor3 = 'Inactive Text' })

                Items["RealSearchbox"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Searchbox"].Instance,
                    Position = UDim2.new(0, 0, 0, 25),
                    Size = UDim2.new(1, 0, 1, -25),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({ BackgroundColor3 = 'Element' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["RealSearchbox"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = 'Border' })

                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["RealSearchbox"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = 'Outline' })

                Items["Holder"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["RealSearchbox"].Instance,
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarImageColor3 = Library.Theme["Accent"],
                    MidImage = "rbxassetid://129030709932941",
                    ScrollBarThickness = 1,
                    Size = UDim2.new(1, -8, 1, -8),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 4, 0, 4),
                    BottomImage = "rbxassetid://129030709932941",
                    TopImage = "rbxassetid://129030709932941"
                }):AddToTheme({ ScrollBarImageColor3 = 'Accent' })

                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    Padding = UDim.new(0, 3),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Holder"].Instance,
                    PaddingBottom = UDim.new(0, 6),
                    PaddingLeft = UDim.new(0, 6)
                })

                Dropdown.Items = Items
            end

            function Dropdown:Set(Value)
                if Dropdown.Multi then
                    if type(Value) ~= "table" then
                        return
                    end

                    Dropdown.Value = Value

                    for Index, Value in Value do
                        local OptionData = Dropdown.Options[Value]

                        if not OptionData then
                            continue
                        end

                        OptionData.IsSelected = true
                        OptionData:ToggleState("Active")
                    end

                    Flags[Dropdown.Flag] = Value
                else
                    if not Dropdown.Options[Value] then
                        return
                    end

                    local OptionData = Dropdown.Options[Value]

                    Dropdown.Value = Value

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.IsSelected = false
                            Value:ToggleState("Inactive")
                        else
                            Value.Selected = true
                            Value:ToggleState("Active")
                        end
                    end

                    Flags[Dropdown.Flag] = Value
                end

                Library:SafeCall(Dropdown.Callback, Dropdown.Value)
            end

            function Dropdown:Add(Value)
                local OptionButton = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Holder"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Value,
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({ TextColor3 = 'Text' })

                local OptionData = {
                    Button = OptionButton,
                    Name = Value,
                    IsSelected = false
                }

                function OptionData:ToggleState(Value)
                    if Value == "Active" then
                        OptionData.Button:ChangeItemTheme({ TextColor3 = "Accent" })
                        OptionData.Button:Tween({ TextColor3 = Library.Theme.Accent })
                    else
                        OptionData.Button:ChangeItemTheme({ TextColor3 = "Text" })
                        OptionData.Button:Tween({ TextColor3 = Library.Theme.Text })
                    end
                end

                function OptionData:Set()
                    OptionData.IsSelected = not OptionData.IsSelected

                    if Dropdown.Multi then
                        local Index = table.find(Dropdown.Value, OptionData.Name)

                        if Index then
                            table.remove(Dropdown.Value, Index)
                        else
                            table.insert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:ToggleState(Index and "Inactive" or "Active")

                        Flags[Dropdown.Flag] = Dropdown.Value
                    else
                        if OptionData.IsSelected then
                            Dropdown.Value = OptionData.Name
                            Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.IsSelected = true
                            OptionData:ToggleState("Active")

                            for Index, Value in Dropdown.Options do
                                if Value ~= OptionData then
                                    Value.IsSelected = false
                                    Value:ToggleState("Inactive")
                                end
                            end
                        else
                            Dropdown.Value = nil
                            Flags[Dropdown.Flag] = nil

                            OptionData.IsSelected = false
                            OptionData:ToggleState("Inactive")
                        end
                    end

                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Remove(Option)
                if Dropdown.Options[Option] then
                    Dropdown.Options[Option].Button.Instance:Destroy()
                    Dropdown.Options[Option] = nil
                end
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do
                    Dropdown:Add(Value)
                end
            end

            function Dropdown:SetVisibility(Bool)
                Items["Searchbox"].Instance.Visible = Bool
            end

            Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
                for Index, Value in Dropdown.Options do
                    if string.lower(Value.Name):find(string.lower(Items["Input"].Instance.Text)) then
                        Value.Button.Instance.Visible = true
                    else
                        Value.Button.Instance.Visible = false
                    end
                end
            end)

            for Index, Value in Dropdown.OptionItems do
                Dropdown:Add(Value)
            end

            Dropdown:Set(Dropdown.Default)

            SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return setmetatable(Dropdown, Library)
        end

        Library.OpenConfirmDialog = function(Self, Config)
            Config = Config or {}

            local Title = tostring(Config.Title or "Confirm")
            local Message = tostring(Config.Message or "Are you sure you want to continue?")
            local ConfirmText = tostring(Config.ConfirmText or "Confirm")
            local CancelText = tostring(Config.CancelText or "Cancel")
            local AccentColor = Config.AccentColor or Color3.fromRGB(255, 95, 95)
            local Callback = Config.Callback or function() end

            if Self.ActiveConfirmDialog and Self.ActiveConfirmDialog.Close then
                Self.ActiveConfirmDialog:Close(false, true)
            end

            local Items = {}
            local Connections = {}
            local IsClosed = false

            local function AddConnection(Connection)
                table.insert(Connections, Connection)
                return Connection
            end

            local function DisconnectConnections()
                for _, Connection in Connections do
                    if Connection and Connection.Connected then
                        Connection:Disconnect()
                    end
                end
            end

            local function CreateModalButton(Name, Position, Width, TextColor, BackgroundTheme)
                local ButtonItems = {}

                ButtonItems["Button"] = Library:Create("TextButton", {
                    Name = "\0",
                    Parent = Items["Panel"].Instance,
                    Position = Position,
                    Size = UDim2.new(Width, 0, 0, 18),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme[BackgroundTheme]
                }):AddToTheme({ BackgroundColor3 = BackgroundTheme })

                ButtonItems["OuterStroke"] = Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = ButtonItems["Button"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Border"],
                    BorderOffset = UDim.new(0, 1)
                }):AddToTheme({ Color = "Border" })

                ButtonItems["InnerStroke"] = Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = ButtonItems["Button"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Color = Library.Theme["Outline"]
                }):AddToTheme({ Color = "Outline" })

                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = ButtonItems["Button"].Instance,
                    Rotation = -90,
                    Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 172, 172))
                    }
                })

                ButtonItems["Label"] = Library:Create("TextLabel", {
                    Name = "\0",
                    Parent = ButtonItems["Button"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, -1),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BorderSizePixel = 0,
                    Text = Name,
                    TextColor3 = TextColor,
                    FontFace = Library.Font,
                    TextSize = Library.FontSize
                })

                ButtonItems["Button"]:OnHover(function()
                    ButtonItems["Button"]:Tween({ BackgroundColor3 = Library.Theme["Hovered Element"] })
                end, function()
                    ButtonItems["Button"]:Tween({ BackgroundColor3 = Library.Theme[BackgroundTheme] })
                end)

                return ButtonItems
            end

            do
                Items["Overlay"] = Library:Create("TextButton", {
                    Name = "\0",
                    Parent = Self.Holder.Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.new(0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    ZIndex = 9000
                })

                Items["PanelOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Overlay"].Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 10),
                    Size = UDim2.new(0, 264, 0, 124),
                    BackgroundColor3 = Library.Theme["Outline"],
                    BorderSizePixel = 0,
                    ZIndex = 9001
                }):AddToTheme({ BackgroundColor3 = "Outline" })

                Items["PanelScale"] = Library:Create("UIScale", {
                    Name = "\0",
                    Parent = Items["PanelOutline"].Instance,
                    Scale = 0.94
                })

                Items["Panel"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["PanelOutline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BackgroundColor3 = Library.Theme["Section"],
                    BorderSizePixel = 0,
                    ZIndex = 9002
                }):AddToTheme({ BackgroundColor3 = "Section" })

                Items["AccentLine"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Panel"].Instance,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = AccentColor,
                    ZIndex = 9003
                })

                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    Parent = Items["Panel"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 10),
                    Size = UDim2.new(1, -24, 0, 12),
                    BorderSizePixel = 0,
                    Text = Title,
                    TextColor3 = Library.Theme["Text"],
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 9003
                }):AddToTheme({ TextColor3 = "Text" })

                Items["Message"] = Library:Create("TextLabel", {
                    Name = "\0",
                    Parent = Items["Panel"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 29),
                    Size = UDim2.new(1, -24, 0, 50),
                    BorderSizePixel = 0,
                    Text = Message,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.25,
                    TextWrapped = true,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    ZIndex = 9003
                }):AddToTheme({
                    TextColor3 = function()
                        return Library.Theme["Text"]:Lerp(Color3.new(0, 0, 0), 0.25)
                    end
                })

                Items["Hint"] = Library:Create("TextLabel", {
                    Name = "\0",
                    Parent = Items["Panel"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 1, -49),
                    Size = UDim2.new(1, -24, 0, 10),
                    BorderSizePixel = 0,
                    Text = "Click off this window to cancel\nHit enter to confirm",
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.45,
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 9003
                }):AddToTheme({
                    TextColor3 = function()
                        return Library.Theme["Text"]:Lerp(Color3.new(0, 0, 0), 0.45)
                    end
                })

                Items["CancelButton"] = CreateModalButton(CancelText, UDim2.new(0, 12, 1, -30), 0.45,
                    Library.Theme["Text"], "Element")
                Items["ConfirmButton"] = CreateModalButton(ConfirmText, UDim2.new(0.55, 0, 1, -30), 0.45,
                    AccentColor, "Element")
            end

            local FadeItems = {
                Items["Overlay"],
                Items["PanelOutline"],
                Items["Panel"],
                Items["AccentLine"],
                Items["Title"],
                Items["Message"],
                Items["Hint"],
                Items["CancelButton"]["OuterStroke"],
                Items["CancelButton"]["InnerStroke"],
                Items["CancelButton"]["Label"],
                Items["CancelButton"]["Button"],
                Items["ConfirmButton"]["OuterStroke"],
                Items["ConfirmButton"]["InnerStroke"],
                Items["ConfirmButton"]["Label"],
                Items["ConfirmButton"]["Button"]
            }

            for _, Item in FadeItems do
                if Item.Instance:IsA("Frame") then
                    Item.Instance.BackgroundTransparency = 1
                elseif Item.Instance:IsA("TextLabel") then
                    Item.Instance.TextTransparency = 1
                elseif Item.Instance:IsA("UIStroke") then
                    Item.Instance.Transparency = 1
                elseif Item.Instance:IsA("TextButton") then
                    Item.Instance.BackgroundTransparency = 1
                end
            end

            local OpenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            local CloseInfo = TweenInfo.new(0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

            local Dialog = {}

            function Dialog:Close(Confirmed, SkipCallback)
                if IsClosed then
                    return
                end

                IsClosed = true
                Self.ActiveConfirmDialog = nil

                Items["Overlay"]:Tween({ BackgroundTransparency = 1 }, CloseInfo)
                Items["PanelOutline"]:Tween({ BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 6) },
                    CloseInfo)
                Items["Panel"]:Tween({ BackgroundTransparency = 1 }, CloseInfo)
                Items["AccentLine"]:Tween({ BackgroundTransparency = 1 }, CloseInfo)
                Items["Title"]:Tween({ TextTransparency = 1 }, CloseInfo)
                Items["Message"]:Tween({ TextTransparency = 1 }, CloseInfo)
                Items["Hint"]:Tween({ TextTransparency = 1 }, CloseInfo)
                Items["CancelButton"]["Button"]:Tween({ BackgroundTransparency = 1 }, CloseInfo)
                Items["CancelButton"]["OuterStroke"]:Tween({ Transparency = 1 }, CloseInfo)
                Items["CancelButton"]["InnerStroke"]:Tween({ Transparency = 1 }, CloseInfo)
                Items["CancelButton"]["Label"]:Tween({ TextTransparency = 1 }, CloseInfo)
                Items["ConfirmButton"]["Button"]:Tween({ BackgroundTransparency = 1 }, CloseInfo)
                Items["ConfirmButton"]["OuterStroke"]:Tween({ Transparency = 1 }, CloseInfo)
                Items["ConfirmButton"]["InnerStroke"]:Tween({ Transparency = 1 }, CloseInfo)
                Items["ConfirmButton"]["Label"]:Tween({ TextTransparency = 1 }, CloseInfo)
                Items["PanelScale"]:Tween({ Scale = 0.97 }, CloseInfo)

                task.delay(CloseInfo.Time + 0.03, function()
                    DisconnectConnections()

                    if Items["Overlay"] and Items["Overlay"].Instance.Parent then
                        Items["Overlay"].Instance:Destroy()
                    end
                end)

                if not SkipCallback then
                    task.defer(function()
                        Library:SafeCall(Callback, Confirmed)
                    end)
                end
            end

            Self.ActiveConfirmDialog = Dialog

            Items["Overlay"]:Tween({ BackgroundTransparency = 0.35 }, OpenInfo)
            Items["PanelOutline"]:Tween({ BackgroundTransparency = 0, Position = UDim2.new(0.5, 0, 0.5, 0) }, OpenInfo)
            Items["Panel"]:Tween({ BackgroundTransparency = 0 }, OpenInfo)
            Items["AccentLine"]:Tween({ BackgroundTransparency = 0 }, OpenInfo)
            Items["Title"]:Tween({ TextTransparency = 0 }, OpenInfo)
            Items["Message"]:Tween({ TextTransparency = 0.25 }, OpenInfo)
            Items["Hint"]:Tween({ TextTransparency = 0.45 }, OpenInfo)
            Items["CancelButton"]["Button"]:Tween({ BackgroundTransparency = 0 }, OpenInfo)
            Items["CancelButton"]["OuterStroke"]:Tween({ Transparency = 0 }, OpenInfo)
            Items["CancelButton"]["InnerStroke"]:Tween({ Transparency = 0 }, OpenInfo)
            Items["CancelButton"]["Label"]:Tween({ TextTransparency = 0 }, OpenInfo)
            Items["ConfirmButton"]["Button"]:Tween({ BackgroundTransparency = 0 }, OpenInfo)
            Items["ConfirmButton"]["OuterStroke"]:Tween({ Transparency = 0 }, OpenInfo)
            Items["ConfirmButton"]["InnerStroke"]:Tween({ Transparency = 0 }, OpenInfo)
            Items["ConfirmButton"]["Label"]:Tween({ TextTransparency = 0 }, OpenInfo)
            Items["PanelScale"]:Tween({ Scale = 1 }, OpenInfo)

            AddConnection(Items["Overlay"].Instance.MouseButton1Click:Connect(function()
                Dialog:Close(false)
            end))

            AddConnection(Items["CancelButton"]["Button"].Instance.MouseButton1Click:Connect(function()
                Dialog:Close(false)
            end))

            AddConnection(Items["ConfirmButton"]["Button"].Instance.MouseButton1Click:Connect(function()
                Dialog:Close(true)
            end))

            AddConnection(UserInputService.InputBegan:Connect(function(Input, Processed)
                if Processed or IsClosed then
                    return
                end

                if Input.KeyCode == Enum.KeyCode.Escape then
                    Dialog:Close(false)
                elseif Input.KeyCode == Enum.KeyCode.Return or Input.KeyCode == Enum.KeyCode.KeypadEnter then
                    Dialog:Close(true)
                end
            end))

            return Dialog
        end

        Library.CreateSettingsPage = function(Self)
            local Page = Self:Page({ Name = "Settings", Icon = "rbxassetid://0" })

            local ConfigsSubPage = Page:SubPage({ Name = "Configs" })
            local OtherSubPage = Page:SubPage({ Name = "Other" })

            do
                local ConfigName
                local ConfigSelected
                local ConfigsFolder = Library.Directory .. Library.Folders.Configs .. "/"

                local ConfigsSection = ConfigsSubPage:Section({ Name = "Configs", Side = 1 })
                do
                    local ConfigName
                    local ConfigSelected
                    local ConfigsFolder = Library.Directory .. Library.Folders.Configs .. "/"

                    local ConfigsDropdown = ConfigsSection:Dropdown({
                        Name = "Configs",
                        Flag = "ConfigsDropdown",
                        Items = {},
                        Multi = false,
                        Callback = function(Value)
                            ConfigSelected = Value
                        end
                    })

                    ConfigsSection:Textbox({
                        Name = "Config name",
                        Flag = "ConfigName",
                        Placeholder = "Config name",
                        Callback = function(Value)
                            ConfigName = Value
                        end
                    })

                    ConfigsSection:Button({
                        Name = "Create",
                        Callback = function()
                            if ConfigName then
                                if ConfigName == "" then
                                    return
                                end

                                writefile(ConfigsFolder .. ConfigName .. ".json", Library:GetConfig())
                                Library:GetConfigsList(ConfigsDropdown)
                                Library:Notification("Succesfully created config", 3, Color3.fromRGB(0, 255, 0))
                            end
                        end
                    })

                    ConfigsSection:Button({
                        Name = "Delete",
                        Callback = function()
                            if ConfigSelected then
                                if isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                    local SelectedConfig = ConfigSelected

                                    Library:OpenConfirmDialog({
                                        Title = "Delete config",
                                        Message = string.format(
                                            'Delete "%s"? This permanently removes the file from your config folder.',
                                            SelectedConfig),
                                        ConfirmText = "Delete",
                                        CancelText = "Keep",
                                        AccentColor = Color3.fromRGB(255, 95, 95),
                                        Callback = function(Confirmed)
                                            if not Confirmed then
                                                return
                                            end

                                            if not isfile(ConfigsFolder .. SelectedConfig .. ".json") then
                                                Library:Notification("Config no longer exists", 3,
                                                    Color3.fromRGB(255, 0, 0))
                                                return
                                            end

                                            delfile(ConfigsFolder .. SelectedConfig .. ".json")
                                            ConfigSelected = nil
                                            Library:GetConfigsList(ConfigsDropdown)
                                            Library:Notification("Succesfully deleted config", 3,
                                                Color3.fromRGB(0, 255, 0))
                                        end
                                    })
                                end
                            end
                        end
                    })

                    ConfigsSection:Button({
                        Name = "Load",
                        Callback = function()
                            if ConfigSelected then
                                if isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                    local ConfigContent = readfile(ConfigsFolder .. ConfigSelected .. ".json")
                                    local Success, Error = Library:LoadConfig(ConfigContent)

                                    if Success then
                                        Library:Notification("Succesfully loaded config", 3, Color3.fromRGB(0, 255, 0))
                                    else
                                        Library:Notification("Failed to load config: \n" .. Error, 3,
                                            Color3.fromRGB(255, 0, 0))
                                    end
                                end
                            else
                                Library:Notification("No config selected", 3, Color3.fromRGB(255, 0, 0))
                            end
                        end
                    })

                    ConfigsSection:Button({
                        Name = "Save",
                        Callback = function()
                            if ConfigSelected then
                                if isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                    local Success, Error = pcall(function()
                                        writefile(ConfigsFolder .. ConfigSelected .. ".json", Library:GetConfig())
                                    end)

                                    if Success then
                                        Library:Notification("Succesfully saved config", 3, Color3.fromRGB(0, 255, 0))
                                    else
                                        Library:Notification("Failed to save config: \n" .. Error, 3,
                                            Color3.fromRGB(255, 0, 0))
                                    end
                                end
                            end
                        end
                    })

                    Library:GetConfigsList(ConfigsDropdown)
                end
            end

            do
                local ThemingSection = OtherSubPage:Section({ Name = "Theming", Side = 1 })
                do
                    for Index, Value in Library.Theme do
                        ThemingSection:Label({ Name = Index }):Colorpicker({
                            Flag = Index .. "Theme",
                            Default = Value,
                            Callback = function(Value)
                                Library.Theme[Index] = Value
                                Library:ChangeTheme(Index, Value)
                            end
                        })
                    end
                end

                local SettingsSection = OtherSubPage:Section({ Name = "Settings", Side = 2 })
                do
                    SettingsSection:Label({ Name = "UI Bind" }):Keybind({
                        Flag = "UIBind",
                        Mode = "Toggle",
                        Default = Enum.KeyCode.RightShift,
                        Callback = function(Value)
                            Library.MenuKeybind = Flags["UIBind"].Key
                        end
                    })

                    SettingsSection:Toggle({
                        Name = "Background Blur",
                        Flag = "UIBackgroundBlur",
                        Default = Library.BackgroundBlurEnabled,
                        Callback = function(Value)
                            Library:SetBackgroundBlurEnabled(Value)
                        end
                    })

                    SettingsSection:Toggle({
                        Name = "Background Snow",
                        Flag = "UIBackgroundSnow",
                        Default = Library.BackgroundSnowEnabled,
                        Callback = function(Value)
                            Library:SetBackgroundSnowEnabled(Value)
                        end
                    })

                    SettingsSection:Button({
                        Name = "Unload",
                        Callback = function()
                            Library:Exit()
                        end
                    })

                    SettingsSection:Slider({
                        Name = "Animation Speed",
                        Flag = "AnimationSpeed",
                        Default = Library.Animation.Time,
                        Min = 0,
                        Max = 1.5,
                        Decimals = .01,
                        Callback = function(Value)
                            Library.Animation.Time = Value
                        end
                    })
                end

                local WidgetsSection = OtherSubPage:Section({ Name = "Widgets", Side = 2 })
                do
                    for _, WidgetData in Library.SettingsWidgets do
                        local WidgetToggle = WidgetsSection:Toggle({
                            Name = WidgetData.Name,
                            Flag = WidgetData.Flag,
                            Default = WidgetData.Default,
                            Callback = WidgetData.Callback
                        })

                        if type(WidgetData.Settings) == "function" then
                            local WidgetSettings = WidgetToggle:Settings()
                            WidgetData.Settings(WidgetSettings, WidgetToggle)
                        end
                    end
                end
            end
        end
    end
end


-- Component geometry and state visuals rebuilt for the NC workspace.
do
    local D = Library.Design
    local function instance(items, key) return items[key] and items[key].Instance end
    local function clean(object)
        if not object then return end
        for _, child in ipairs(object:GetChildren()) do
            if child:IsA("UIGradient") or child:IsA("UIStroke") then child:Destroy() end
        end
    end
    local page = Library.Page
    Library.Page = function(self, params)
        local object = page(self, params)
        local i = object.Items
        local button = i.Inactive.Instance
        button.Size = UDim2.new(1, 0, 0, 40)
        clean(button); D.Round(button, 7)
        local inner = i.InactiveInline.Instance
        clean(inner); inner.BackgroundTransparency = 1
        i.Text.Instance.AnchorPoint = Vector2.new(0, 0.5)
        i.Text.Instance.Position = UDim2.new(0, 15, 0.5, 0)
        i.Text.Instance.TextSize = 13
        local turn = object.Turn
        function object:Turn(active)
            turn(self, active)
            i.Inactive:Tween({BackgroundColor3 = active and Library.Theme.Element or Library.Theme.Section})
        end
        button.BackgroundColor3 = object.Active and Library.Theme.Element or Library.Theme.Section
        i.Columns.Instance.Position = UDim2.fromOffset(0, 42)
        i.Columns.Instance.Size = UDim2.new(1, 0, 1, -42)
        i.SubPages.Instance.Position = UDim2.fromOffset(5, 0)
        i.SubPages.Instance.Size = UDim2.new(1, -10, 0, 32)
        return object
    end
    local subpage = Library.SubPage
    Library.SubPage = function(self, params)
        local object = subpage(self, params)
        local b = object.Items.Inactive.Instance
        b.Size = UDim2.new(0, 0, 0, 27)
        b.BackgroundTransparency = 0; b.BackgroundColor3 = Library.Theme.Element
        D.Round(b, 6)
        local pad = Instance.new("UIPadding"); pad.PaddingLeft = UDim.new(0, 12); pad.PaddingRight = UDim.new(0, 12); pad.Parent = b
        return object
    end
    local section = Library.Section
    Library.Section = function(self, params)
        local object = section(self, params)
        local i = object.Items
        D.Round(i.SectionOutline.Instance, 10); D.Round(i.Section.Instance, 9)
        i.Text.Instance.BackgroundTransparency = 1
        i.Text.Instance.Position = UDim2.fromOffset(14, 12)
        i.Text.Instance.Size = UDim2.new(0, 0, 0, 20)
        i.Text.Instance.TextSize = 13
        i.Content.Instance.Position = UDim2.fromOffset(15, 45)
        i.Content.Instance.Size = UDim2.new(1, -30, 0, 0)
        local layout = i.Content.Instance:FindFirstChildOfClass("UIListLayout")
        if layout then layout.Padding = UDim.new(0, 12) end
        return object
    end
    local toggle = Library.Toggle
    Library.Toggle = function(self, params)
        local object = toggle(self, params)
        local i = object.Items
        local row, track = i.Toggle.Instance, i.Indicator.Instance
        row.Position = UDim2.fromOffset(0, 0); row.Size = UDim2.new(1, 0, 0, 26)
        i.Text.Instance.Position = UDim2.new(0, 0, 0.5, 0)
        i.Text.Instance.Size = UDim2.new(1, -95, 0, 20)
        i.Text.Instance.AutomaticSize = Enum.AutomaticSize.None
        i.Text.Instance.TextXAlignment = Enum.TextXAlignment.Left
        i.Text.Instance.TextTruncate = Enum.TextTruncate.AtEnd
        track.AnchorPoint = Vector2.new(1, 0.5)
        track.Position = UDim2.new(1, 0, 0.5, 0); track.Size = UDim2.fromOffset(30, 16)
        clean(track); D.Round(track, 8)
        i.Inline.Instance.Visible = false
        local thumb = Library:Create("Frame", {Parent = track, Size = UDim2.fromOffset(10, 10),
            Position = UDim2.fromOffset(object.Value and 17 or 3, 3), BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(245, 243, 255)})
        D.Round(thumb.Instance, 5)
        i.SubElements.Instance.AnchorPoint = Vector2.new(1, 0)
        i.SubElements.Instance.Position = UDim2.new(1, -40, 0, 0)
        local set = object.Set
        function object:Set(value)
            set(self, value)
            thumb:Tween({Position = UDim2.fromOffset(value and 17 or 3, 3)})
            i.Indicator:Tween({BackgroundColor3 = value and Library.Theme.Accent or Library.Theme.Element})
        end
        track.BackgroundColor3 = object.Value and Library.Theme.Accent or Library.Theme.Element
        return object
    end
    local button = Library.Button
    Library.Button = function(self, params)
        local object = button(self, params)
        local b = object.Items.Button.Instance
        clean(b); D.Round(b, 7); D.Stroke(b)
        b.Size = UDim2.new(1, 0, 0, 32)
        return object
    end
    local slider = Library.Slider
    Library.Slider = function(self, params)
        local object = slider(self, params)
        local i = object.Items
        i.Slider.Instance.Size = UDim2.new(1, 0, 0, 40)
        local bar = i.RealSlider.Instance
        bar.Position = UDim2.new(0, 0, 1, -3); bar.Size = UDim2.new(1, 0, 0, 5)
        clean(bar); D.Round(bar, 3); clean(i.Accent.Instance); D.Round(i.Accent.Instance, 3)
        i.Value.Instance.Parent = i.Slider.Instance
        i.Value.Instance.Position = UDim2.new(1, 0, 0, 0)
        i.Value.Instance.TextSize = 11; clean(i.Value.Instance)
        return object
    end
    local dropdown = Library.Dropdown
    Library.Dropdown = function(self, params)
        local object = dropdown(self, params)
        local i = object.Items
        i.Dropdown.Instance.Size = UDim2.new(1, 0, 0, 54)
        i.RealDropdown.Instance.Size = UDim2.new(1, 0, 0, 30)
        clean(i.RealDropdown.Instance); D.Round(i.RealDropdown.Instance, 6); D.Stroke(i.RealDropdown.Instance)
        D.Round(i.OptionHolder.Instance, 7)
        -- Original SetOpen expects a numeric MaxSize.
        object.MaxSize = 50
        return object
    end
    local textbox = Library.Textbox
    Library.Textbox = function(self, params)
        local object = textbox(self, params)
        local i = object.Items
        i.Textbox.Instance.Size = UDim2.new(1, 0, 0, 32)
        clean(i.Background.Instance); D.Round(i.Background.Instance, 6); D.Stroke(i.Background.Instance)
        return object
    end
    -- Fix stale theme-map lookup in the original implementation.
    Library.ChangeItemTheme = function(self, properties)
        local data = Library.ThemeMap[self.Instance]
        if data then data.Properties = properties end
    end
    -- Removed decorative strokes must not remain in the theme registry.
    Library.ChangeTheme = function(self, key, color)
        Library.Theme[key] = color
        for _, data in ipairs(Library.ThemingStuff) do
            if data.Item and data.Item.Parent then
                for property, value in pairs(data.Properties) do
                    if value == key then data.Item[property] = color
                    elseif type(value) == "function" then data.Item[property] = value() end
                end
            end
        end
    end
    Library.CreateTab = Library.Page
    Library.CreateSubTab = Library.SubPage
    Library.CreateWindow = Library.Window
end

_G.Library = Library
getgenv().Library = Library

return Library
