if not game:IsLoaded() then
    game.Loaded:Wait()
end

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local backpack = player:FindFirstChild("Backpack")
if not backpack then return end

-- Create the tool
local tool = Instance.new("Tool")
tool.Name = "Troll"
tool.RequiresHandle = false
tool.Parent = backpack

-- Toggle state
local isFloating = false
local storedPositions = {}  -- Store original positions for reset

tool.Activated:Connect(function()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not character or not humanoidRootPart then return end

    isFloating = not isFloating -- Toggle state

    if isFloating then
        -- Store original positions and move parts up for others
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                storedPositions[part] = part.CFrame  -- Store original position
                part.CFrame = part.CFrame * CFrame.new(0, 10000, 0) -- Move up for others
                part.LocalTransparencyModifier = 0 -- Ensure visibility for yourself
            end
        end
    else
        -- Restore original positions
        for part, cframe in pairs(storedPositions) do
            if part and part:IsA("BasePart") then
                part.CFrame = cframe  -- Restore position
            end
        end
        storedPositions = {}  -- Clear stored positions
    end
end)
