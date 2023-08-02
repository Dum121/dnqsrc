function twn(targetPos, targetCFrame)
    local gay = (targetPos-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    local Tween = game:GetService('TweenService'):Create(
        game.Players.LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(
            gay / 200, 
            Enum.EasingStyle.Linear
        ),
        {CFrame = targetCFrame * CFrame.new(Vector3.new(0,0,0))}
    )
    Tween:Play()
    Tween.Completed:Wait();
end
while getgenv().cash do wait()
for i,v in pairs(workspace.Ignored.Drop:GetChildren()) do
    if v.Name == "MoneyDrop"then
game.Players.LocalPlayer.Character.Humanoid.Sit = true    
twn(v.Position,v.CFrame)
    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude <= 10 then
    pcall(function()
    wait(0.5)
    fireclickdetector(v.ClickDetector)
    end)
    end
    end
    end
end
