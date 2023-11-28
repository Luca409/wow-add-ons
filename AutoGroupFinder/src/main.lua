-- ----------------------------------------- START CONFIG -----------------------------------------
local raids = {"naxx", "voa", "archavon"}
-- ----------------------------------------- END CONFIG -----------------------------------------

-- ----------------------------------------- START HELPER FUNCTIONS -----------------------------------------

function containsSubstring(inputString, substring)
  return string.find(inputString, substring) ~= nil
end

function removeNumbers(inputString)
  -- Use string.gsub with a pattern that matches numeric characters
  local resultString = string.gsub(inputString, "%d", "")

  return resultString
end

function isLookingForMore(msg)
  return containsSubstring(string.lower(removeNumbers(msg)), "lfm")
end

function toLowerList(inputString)
  local tokens = {}
  for token in string.gmatch(inputString, "%S+") do
    table.insert(tokens, string.lower(token))
  end
  return tokens
end

function hasIntersection(list1, list2)
  for _, value1 in ipairs(list1) do
      for _, value2 in ipairs(list2) do
          if value1 == value2 then
              return true  -- Found an intersection
          end
      end
  end
  return false  -- No intersection found
end

function printList(list)
  for _, value in ipairs(list) do
    print(value)
  end
end

function containsItem(myList, targetItem)
  for _, value in ipairs(myList) do
      if value == targetItem then
          return true  -- Found the item in the list
      end
  end
  return false  -- Item not found in the list
end
-- ----------------------------------------- END HELPER FUNCTIONS -----------------------------------------
-- ----------------------------------------- START UI COMPONENTS ------------------------------------------
StaticPopupDialogs["EXAMPLE_HELLOWORLD"] = {
  text = "Do you want to greet the world today?",
  button1 = "Yes",
  button2 = "No",
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}
-- ----------------------------------------- END UI COMPONENTS ------------------------------------------

local players = {}

local frame = CreateFrame("FRAME", "FooAddonFrame");
frame:RegisterEvent("CHAT_MSG_CHANNEL");
local function eventHandler(self, event, msg, sender, _, chanString, _, _, _, chanNumber, chanName)
  local tokens = toLowerList(msg)

  if isLookingForMore(msg) and hasIntersection(tokens, raids) and not containsItem(players, sender) then
    table.insert(players, sender)
    printList(players)
    -- StaticPopup_Show ("EXAMPLE_HELLOWORLD")
  end
end
frame:SetScript("OnEvent", eventHandler);



-- local frame = CreateFrame("FRAME", "FooAddonFrame");
-- frame:RegisterEvent("PLAYER_ENTERING_WORLD");
-- local function eventHandler(self, event, ...)
--   print("Hello world!");
-- end
-- frame:SetScript("OnEvent", eventHandler);
