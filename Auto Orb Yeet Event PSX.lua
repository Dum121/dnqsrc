local plr = game.Players.LocalPlayer
while getgenv().orb do wait()
for i,v in pairs(workspace.__MAP.Interactive.Orbs:GetChildren()) do
if v:IsA("Model") then
v.Orb.CFrame = plr.Character.HumanoidRootPart.CFrame
end
end
end
