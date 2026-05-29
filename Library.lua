--========================================================--
--  SIMPLE LINORIA‑STYLE UI LIBRARY (NO DEPENDENCIES)
--========================================================--

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Library = {}
Library.__index = Library

--========================================================--
--  WINDOW CREATION
--========================================================--

function Library:Window(Title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 550, 0, 350)
    Main.Position = UDim2.new(0.5, -275, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 30)
    Topbar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Topbar.BorderSizePixel = 0
    Topbar.Parent = Main

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -10, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.Font = Enum.Font.Code
    TitleLabel.TextSize = 18
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Topbar

    -- Dragging
    local dragging, dragStart, startPos
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    Topbar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local Tabs = Instance.new("Frame")
    Tabs.Size = UDim2.new(1, 0, 0, 30)
    Tabs.Position = UDim2.new(0, 0, 0, 30)
    Tabs.BackgroundTransparency = 1
    Tabs.Parent = Main

    local TabHolder = Instance.new("Frame")
    TabHolder.Size = UDim2.new(1, 0, 1, -60)
    TabHolder.Position = UDim2.new(0, 0, 0, 60)
    TabHolder.BackgroundTransparency = 1
    TabHolder.Parent = Main

    local UI = {
        ScreenGui = ScreenGui,
        Main = Main,
        Tabs = Tabs,
        TabHolder = TabHolder,
        CurrentTab = nil
    }

    setmetatable(UI, Library)
    return UI
end

--========================================================--
--  TABS
--========================================================--

function Library:Tab(Name)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 100, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = Name
    Button.Font = Enum.Font.Code
    Button.TextSize = 16
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.Parent = self.Tabs

    local Page = Instance.new("Frame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = self.TabHolder

    Button.MouseButton1Click:Connect(function()
        if self.CurrentTab then
            self.CurrentTab.Visible = false
        end
        Page.Visible = true
        self.CurrentTab = Page
    end)

    return Page
end

--========================================================--
--  GROUPBOX
--========================================================--

function Library:Groupbox(Parent, Name)
    local Box = Instance.new("Frame")
    Box.Size = UDim2.new(0, 250, 0, 200)
    Box.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    Box.BorderSizePixel = 0
    Box.Parent = Parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = Name
    Label.Font = Enum.Font.Code
    Label.TextSize = 16
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Parent = Box

    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1, -10, 1, -30)
    Holder.Position = UDim2.new(0, 5, 0, 25)
    Holder.BackgroundTransparency = 1
    Holder.Parent = Box

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 6)
    Layout.Parent = Holder

    return Holder
end

--========================================================--
--  BUTTON
--========================================================--

function Library:Button(Parent, Text, Callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 28)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Btn.BorderSizePixel = 0
    Btn.Text = Text
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 14
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Parent = Parent

    Btn.MouseButton1Click:Connect(function()
        if Callback then Callback() end
    end)

    return Btn
end

--========================================================--
--  TOGGLE
--========================================================--

function Library:Toggle(Parent, Text, Default, Callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 28)
    Frame.BackgroundTransparency = 1
    Frame.Parent = Parent

    local Box = Instance.new("Frame")
    Box.Size = UDim2.new(0, 20, 0, 20)
    Box.Position = UDim2.new(0, 0, 0, 4)
    Box.BackgroundColor3 = Default and Color3.fromRGB(80, 120, 255) or Color3.fromRGB(40, 40, 50)
    Box.BorderSizePixel = 0
    Box.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -30, 1, 0)
    Label.Position = UDim2.new(0, 30, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = Text
    Label.Font = Enum.Font.Code
    Label.TextSize = 14
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local State = Default

    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            State = not State
            Box.BackgroundColor3 = State and Color3.fromRGB(80, 120, 255) or Color3.fromRGB(40, 40, 50)
            if Callback then Callback(State) end
        end
    end)

    return State
end

--========================================================--
--  SLIDER
--========================================================--

function Library:Slider(Parent, Text, Min, Max, Default, Callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundTransparency = 1
    Frame.Parent = Parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 18)
    Label.BackgroundTransparency = 1
    Label.Text = Text .. ": " .. Default
    Label.Font = Enum.Font.Code
    Label.TextSize = 14
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Parent = Frame

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, 0, 0, 6)
    Bar.Position = UDim2.new(0, 0, 0, 22)
    Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Bar.BorderSizePixel = 0
    Bar.Parent = Frame

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar

    local Value = Default

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local function update()
                local pos = math.clamp((UIS:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                Value = math.floor(Min + (Max - Min) * pos)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                Label.Text = Text .. ": " .. Value
                if Callback then Callback(Value) end
            end

            update()
            local moveConn
            moveConn = UIS.InputChanged:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseMovement then
                    update()
                end
            end)

            UIS.InputEnded:Wait()
            moveConn:Disconnect()
        end
    end)

    return Value
end

return Library
