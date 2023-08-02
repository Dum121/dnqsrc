while getgenv().rice do wait(0.2)
  for i,v in pairs(workspace.StarterVillage_RiceStrings:GetChildren()) do
    if v:IsA("Part") then
if game:GetService("Players").LocalPlayer.PlayerGui.Menu.Quest.Title.Text ~= "Help Sarah pick rice" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-112, 282, -1698)
wait(0.1)
local args = {[1] = "AddQuest",[2] = "Players.LocalPlayer.PlayerGui.Npc_Dialogue.LocalScript.Functions",[3] = 22008.5244411,
[4] = game:GetService("ReplicatedStorage"):WaitForChild("Player_Data"):WaitForChild(game.Players.LocalPlayer.Name):WaitForChild("Quest"),
[5] = {["Current"] = "Help Sarah pick rice",
["List"] = {[1] = {["Name"] = "pick 4 strings of rice",["Progress"] = {[1] = 0,[2] = 4}}}}}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("To_Server"):WaitForChild("Handle_Initiate_S"):FireServer(unpack(args))
else
v.Rice_pick_proximity.HoldDuration = 0
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
wait(0.5)
fireproximityprompt(v.Rice_pick_proximity)
end
end
end
end
