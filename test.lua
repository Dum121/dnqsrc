shared.AutoSell = {
    OldMethod = false, -- false thì og xài cái mới / true thì og xài cái cũ.
    Webhook = {
        Url = "",
        Delay = 900
    },
    HopSetting = {
        EverySecond = 600,
        MinPlayer = 65 --Max 65
    },
    ChatSetting = {
        Active = true,
        Delay = 15,
        List = {"Sell Upgraded Mech Cameraman 300 gem in market place"}
    },
    Unit = {
        ["Upgraded Mech Cameraman"] = 300
    },
    Friends = {
        Hop = true, -- true,false
        Id = {
            5514872149,
            3363701000,
            123,
            321,
            456,
            789}-- thêm id thì cứ xuống dòng giống vậy là đc, ko thì nhắn tôi làm giúp og.
    }
}







































repeat wait() until game:IsLoaded()

local plr = game.Players.LocalPlayer
local guiservice = game:GetService("GuiService")
local vim = game:GetService("VirtualInputManager")
local tps = game:GetService('TeleportService')
local vu = game:GetService("VirtualUser")

if game.PlaceId == 13775256536 then
    while wait() do
        tps:Teleport(14682939953)
    end
end

local getid = {}
local getlongid = {}
local a
local b
a=hookmetamethod(game,"__namecall",function(self,...)
    local args = {...}
    local method = getnamecallmethod()
    if method == "FireServer" or method == "InvokeServer" then
        if self.Name == "dataRemoteEvent" and args[1][1][2] == "Troops" then
            getid[self.Name] = args[1][2]
            return a(self,unpack(args))
        end
    end
      return a(self,...)
end)
b=hookmetamethod(game,"__namecall",function(self,...)
    local args = {...}
    local method = getnamecallmethod()
    if method == "FireServer" or method == "InvokeServer" then
        if self.Name == "dataRemoteEvent" and args[1][1][2] == "Troops" then
            getlongid[self.Name] = args[1][1][1]
            return b(self,unpack(args))
        end
    end
      return b(self,...)
end)

function serializeTable(val, name, skipnewlines, depth)
    skipnewlines = skipnewlines or false
    depth = depth or 0
 
    local tmp = string.rep("", depth)
 
    if name then tmp = tmp end
 
    if type(val) == "table" then
        tmp = tmp .. (not skipnewlines and "" or "")
 
        for k, v in pairs(val) do
            tmp =  tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. (not skipnewlines and "" or "")
        end
 
        tmp = tmp .. string.rep("", depth) 
    elseif type(val) == "number" then
        tmp = tmp .. tostring(val)
    elseif type(val) == "string" then
        tmp = tmp .. string.format("%q", val)
    elseif type(val) == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    elseif type(val) == "function" then
        tmp = tmp  .. "func: " .. debug.getinfo(val).name
    else
        tmp = tmp .. tostring(val)
    end
 
    return tmp
 end

wait(2)

plr.Idled:connect(function()
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)


function ableToSellUnit()
    for i, v in pairs(plr.PlayerGui.Lobby.MarketplaceFrame.MarketplaceMain.MainFrame.SellUnitMenu.SaleUnits.SaleUnitsList:GetChildren()) do
        if string.find(v.Name, "Row") and v.RowLocked.Visible == false then
            for e, g in pairs(v.Row:GetChildren()) do
                if string.find(g.Name, "Slot") and string.find(g.GemsFrame.BestPrice.Text, "n/a", 1, true)  then
                    return true
                end
            end
        end
    end
    return false
end

function ableToSellUnit2()
    local a, b = string.match(plr.PlayerGui.Lobby.MarketplaceFrame.MarketplaceMain.MainFrame.SellUnitMenu.TotalUnitsForSale.UnitsForSaleDisplay.DisplayFrame.UnitsAmount.Text, "([^/]+)/([^/]+)")
    return tonumber(a) < tonumber(b)
end

function canSellThisUnit(name)
    for i, v in pairs(shared.AutoSell.Unit) do
        if string.find(i, name, 1, true) then
            return shared.AutoSell.Unit[i]
        end
    end
end

local dl = false
function clickGui(path)
    if dl == false then
        dl = true
        print(path:GetFullName())
        guiservice.SelectedObject = path
        wait(.2)
        vim:SendKeyEvent(true, 13, false, game)
        wait(.1)
        vim:SendKeyEvent(false, 13, false, game)
        wait(.2)
        guiservice.SelectedObject = nil
        wait(.2)
        dl = false
    end
end

function writeGui(path, text)
    if dl == false then
        guiservice.SelectedObject = path
        wait(.2)
        path.Text = text
        wait(.2)
        vim:SendKeyEvent(true, 13, false, game)
        wait(.1)
        vim:SendKeyEvent(false, 13, false, game)
        wait(.2)
        guiservice.SelectedObject = nil
        wait(.2)
        path.Text = text
        wait(.2)
    end
end

            local PlaceID = game.PlaceId
            local AllIDs = {}
            local foundAnything = ""
            local actualHour = os.date("!*t").hour
            local Deleted = false
            local File = pcall(function()
                AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
            end)
            if not File then
                table.insert(AllIDs, actualHour)
                writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
            end
            function TPReturner()
                local Site;
                if foundAnything == "" then
                    Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
                else
                    Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
                end
                local ID = ""
                if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
                    foundAnything = Site.nextPageCursor
                end
                local num = 0;
                for i,v in pairs(Site.data) do
                    local Possible = true
                    ID = tostring(v.id)
                    if tonumber(v.maxPlayers) > tonumber(v.playing) and tonumber(v.playing) >= shared.AutoSell.HopSetting.MinPlayer then
                        for _,Existing in pairs(AllIDs) do
                            if num ~= 0 then
                                if ID == tostring(Existing) then
                                    Possible = false
                                end
                            else
                                if tonumber(actualHour) ~= tonumber(Existing) then
                                    local delFile = pcall(function()
                                        delfile("NotSameServers.json")
                                        AllIDs = {}
                                        table.insert(AllIDs, actualHour)
                                    end)
                                end
                            end
                            num = num + 1
                        end
                        if Possible == true then
                            table.insert(AllIDs, ID)
                            wait()
                            pcall(function()
                                writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                                wait()
                                game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                            end)
                            wait(4)
                        end
                    end
                end
            end
            
            function Teleport()
                while wait() do
                    pcall(function()
                        TPReturner()
                        if foundAnything ~= "" then
                            TPReturner()
                        end
                    end)
                end
            end

spawn(function()
    while wait() do
        if shared.AutoSell.ChatSetting.Active then
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(shared.AutoSell.ChatSetting.List[math.random(1, #shared.AutoSell.ChatSetting.List)], "All")
            wait(shared.AutoSell.ChatSetting.Delay)
        end
    end
end)
if game:GetService("Players").LocalPlayer.PlayerGui.Lobby:FindFirstChild("TradingFrame") then
    game:GetService("Players").LocalPlayer.PlayerGui.Lobby.TradingFrame:Destroy()
end

if shared.AutoSell.Friends.Hop then
    for i,v in pairs(game.Players:GetChildren()) do
        if table.find(shared.AutoSell.Friends.Id,v.UserId) and v.Name ~= game.Players.LocalPlayer.Name then
            print("Hop...")
            wait(math.random(1,10))
            Teleport()
        end
    end
end
spawn(function()
    while wait(shared.AutoSell.HopSetting.EverySecond) do
        pcall(function()
            Teleport()
        end)
    end
end)
repeat wait() until plr:FindFirstChild("leaderstats")

local units = 0
getgenv().checking = true
spawn(function()
    while wait(0.1) do
        pcall(function()
            if plr.PlayerGui.MainFrames.NotificationFrame.Visible then
                for i, v in pairs(plr.PlayerGui.MainFrames.NotificationFrame.BigNotification.Buttons:GetChildren()) do
                    if v.Visible then
                        clickGui(v.Btn)
                        break
                    end
                end
            elseif plr.PlayerGui.Lobby.MarketplaceFrame.Visible == false and plr.PlayerGui.Lobby.MarketplaceFrame.MarketplaceMain.MainFrame.ConfirmPopup.Visible == false then
                plr.Character.PrimaryPart.CFrame = CFrame.new(1440.1375732421875, 111.3502197265625, 2535.1767578125)
                wait(1)
                plr.Character.PrimaryPart.CFrame = CFrame.new(1436.17041015625, 112.8502426147461, 2572.00927734375)
            elseif plr.PlayerGui.Lobby.MarketplaceFrame.Visible and plr.PlayerGui.Lobby.MarketplaceFrame.MarketplaceMain.MainFrame.SellUnitMenu.Visible == false and plr.PlayerGui.Lobby.MarketplaceFrame.MarketplaceMain.MainFrame.BuyMenu.Visible == true then
                clickGui(plr.PlayerGui.Lobby.MarketplaceFrame.MarketplaceMain.MainFrame.TopBar.Sell.Button)
            end
        end)
    end
end)
repeat wait() until game:GetService("Players").LocalPlayer.PlayerGui.Lobby.MarketplaceFrame.MarketplaceMain.MainFrame.SellUnitMenu.Inventory.Inventory:FindFirstChildOfClass("Frame")
for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Lobby.MarketplaceFrame.MarketplaceMain.MainFrame.SellUnitMenu.Inventory.Inventory:GetChildren()) do
    if v:IsA("Frame") then
        units += 1
    end
end
print(plr.Name .. " \n Unit: " .. units .. "/1000 \n Gem: " .. plr.leaderstats.Gems.Value)
spawn(function()
    while wait() do
        if shared.AutoSell.Webhook.Url ~= "" then
            local Content = ''
            local Embed = {
                        ["title"] = "Notification",
                        ["description"] = "**Username: ||".. game.Players.LocalPlayer.Name .. "||\nUserId: ||" .. game.Players.LocalPlayer.UserId .. "||**\
                        Unit: ```" .. units .. "/1000``` \n Gem: ```" .. plr.leaderstats.Gems.Value.."```",
                        ["type"] = "rich",
                        ["color"] = tonumber(0xffff00),
            };
            (syn and syn.request or http_request or http.request) {
                Url = shared.AutoSell.Webhook.Url;
                Method = 'POST';
                Headers = {
                    ['Content-Type'] = 'application/json';
                };
                Body = game:GetService'HttpService':JSONEncode({content = Content; embeds = {Embed}; });
            };
        end
        wait(shared.AutoSell.Webhook.Delay)
    end
end)
local phetid = nil
local fakeid = nil
spawn(function()
    while getgenv().checking do wait(0.1)
        pcall(function()
            if plr.PlayerGui.Lobby.MarketplaceFrame.Visible and plr.PlayerGui.Lobby.MarketplaceFrame.MarketplaceMain.MainFrame.SellUnitMenu.Visible then
                for i, v in pairs(plr.PlayerGui.Lobby.MarketplaceFrame.MarketplaceMain.MainFrame.SellUnitMenu.Inventory.Inventory:GetChildren()) do
                    if v:IsA("Frame") and v.TroopPicture.CannotTrade.Visible == false and ableToSellUnit2() then
                        repeat wait()
                            clickGui(v.TroopPicture.InteractiveButton)
                        until plr.PlayerGui.Lobby.MarketplaceFrame.MarketplaceMain.MainFrame.SellUnitMenu.SellUnitPopup.Visible
                        wait(.2)
                        local priceCheck = canSellThisUnit(plr.PlayerGui.Lobby.MarketplaceFrame.MarketplaceMain.MainFrame.SellUnitMenu.SellUnitPopup.UnitName.UnitName.Text)
                        if priceCheck then
                            repeat wait()
                                writeGui(plr.PlayerGui.Lobby.MarketplaceFrame.MarketplaceMain.MainFrame.SellUnitMenu.SellUnitPopup.MiddleMenu.PriceFrame.GemsFrame.TextBox, tostring(priceCheck))
                                clickGui(plr.PlayerGui.Lobby.MarketplaceFrame.MarketplaceMain.MainFrame.SellUnitMenu.SellUnitPopup.RightMenu.PutOnSale.SellButton)
                                clickGui(plr.PlayerGui.Lobby.MarketplaceFrame.MarketplaceMain.MainFrame.SellUnitMenu.SellUnitPopup.RightMenu.PutOnSale.SellButton)
                            until plr.PlayerGui.Lobby.MarketplaceFrame.MarketplaceMain.MainFrame.ConfirmPopup.Visible
                            wait(0.5)
                            repeat wait()
                                clickGui(plr.PlayerGui.Lobby.MarketplaceFrame.MarketplaceMain.MainFrame.ConfirmPopup.Options.Confirm.ConfirmButton)
                            until plr.PlayerGui.Lobby.MarketplaceFrame.MarketplaceMain.MainFrame.ConfirmPopup.Visible == false
                            if not shared.AutoSell.OldMethod then
                                getgenv().checking = false
                                return
                                end
                        else
                            repeat wait()
                                clickGui(plr.PlayerGui.Lobby.MarketplaceFrame.MarketplaceMain.MainFrame.SellUnitMenu.SellUnitPopup.CloseButton)
                            until plr.PlayerGui.Lobby.MarketplaceFrame.MarketplaceMain.MainFrame.SellUnitMenu.SellUnitPopup.Visible == false
                            wait(.2)
                            if not shared.AutoSell.OldMethod then
                            getgenv().checking = false
                            return
                            end
                        end
                    end
                end
            end
        end)
    end
end)
if phetid == nil or fakeid == nil then
    print("Get id Trading...")
    repeat wait() until serializeTable(getid) ~= nil and serializeTable(getid) ~= "" and serializeTable(getlongid) ~= nil and serializeTable(getlongid) ~= ""
    phetid = serializeTable(getid)
    fakeid = serializeTable(getlongid)
end
local riuid = phetid
riuid = riuid:gsub('%"', ''):gsub('%"', '')
local realid = fakeid
realid = realid:gsub('%"', ''):gsub('%"', '')
   print(riuid)
   print(realid)
spawn(function()
    while wait(0.2) do
        for i, v in pairs(plr.PlayerGui.Lobby.MarketplaceFrame.MarketplaceMain.MainFrame.SellUnitMenu.Inventory.Inventory:GetChildren()) do
            if v:IsA("Frame") and v.TroopPicture.CannotTrade.Visible == false and ableToSellUnit2() then
    local args = {
        [1] = {
            [1] = {
                [1] = realid,
                [2] = "Troops",
                [3] = v.Name,
                [4] = canSellThisUnit(plr.PlayerGui.Lobby.MarketplaceFrame.MarketplaceMain.MainFrame.SellUnitMenu.SellUnitPopup.UnitName.UnitName.Text)
            },
            [2] = riuid
        }
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
end
end
repeat wait() until
game:GetService("Players").LocalPlayer.PlayerGui.Lobby.MarketplaceFrame.MarketplaceMain.MainFrame.SellUnitMenu.TotalUnitsForSale.UnitsForSaleDisplay.DisplayFrame.UnitsAmount.Text ~= "10/10"
end
end)



















































------------------ Dum1121
