require("mysql")
driver = require("luasql.mysql");
env = driver.mysql();
con = assert (env:connect(db,username,password,server))
gm_name = "Ixiboru"

local account_max_items = 30;
local char_max_items = 30;
local tax = 0.10;
local tax_str = 10;
local shared_bank_slots = {2500, 2501, 2531, 2532, 2533, 2534, 2535, 2536, 2537, 2538, 2539, 2540, 2541, 2542, 2543, 2544, 2545, 2546, 2547, 2548, 2549, 2550};
local slot_ids1 = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45};
local slot_ids2 = {250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355};
local slot_ids3 = {2000, 2271};
local slot_ids4 = {2500, 2550};
local slot_ids = {slot_ids1, slot_ids2, slot_ids3, slot_ids4};

function split(pString, pPattern)
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
     table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
   end
   return Table
end

function format_int(number)

  local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')

  -- reverse the int-string and append a comma to all blocks of 3 digits
  int = int:reverse():gsub("(%d%d%d)", "%1,")

  -- reverse the int-string back remove an optional comma and put the 
  -- optional minus and fractional part back
  return minus .. int:reverse():gsub("^,", "") .. fraction
end

function event_say(e)
    if (e.message:findi("hail")) then
      local total_listings = 0;
      con = assert (env:connect(db,username,password,server));
      cur = assert (con:execute(tostring("SELECT id from item_auction where active = 1")));
      row = cur:fetch ({}, "a");
      while row do
        total_listings = total_listings + 1
        row = cur:fetch (row, "a");
      end
      total_listings = format_int(total_listings);
      cur:close() -- already closed because all the result set was consumed
      local total_sold = 0;
      cur = assert (con:execute(tostring("SELECT id from item_auction where active = 0 and paid_out = 1 AND Sold_to NOT LIKE '%Canceled%' AND Sold_to NOT LIKE '%Relisted%' AND Sold_To IS NOT NULL")));
      row = cur:fetch ({}, "a");
      while row do
        total_sold = total_sold + 1
        row = cur:fetch (row, "a");
      end
      total_sold = format_int(total_sold);
   local total_tax = 0;
  cur = assert (con:execute(tostring("SELECT ID,price from item_auction where active = 0 and paid_out = 1 AND Sold_to NOT LIKE '%Canceled%' AND Sold_to NOT LIKE '%Relisted%' AND Sold_To IS NOT NULL")));
  row = cur:fetch ({}, "a");
 while row do
 total_tax = (tonumber(total_tax) + (tonumber(row.price) *.10));
  row = cur:fetch (row, "a");
  end
      total_tax = format_int(total_tax);
      local total_paid = 0;
      cur = assert (con:execute(tostring("SELECT ID,price from item_auction where active = 0 and paid_out = 1 AND Sold_to NOT LIKE '%Canceled%' AND Sold_to NOT LIKE '%Relisted%' AND Sold_To IS NOT NULL")));
      row = cur:fetch ({}, "a");
     while row do
     total_paid = tonumber(total_paid) + tonumber(row.price);
      row = cur:fetch (row, "a");
      end
          total_paid = format_int(total_paid);
      cur:close() -- already closed because all the result set was consumed
      con:close();
        e.other:Message(6, "+----------------------------+");
        e.other:Message(6, "Klob Pulp Auction Ogre");
        e.other:Message(6, "+----------------------------+");
        e.other:Message(6, "~Items: "..tostring(total_listings)..", Sold: "..tostring(total_sold)..", Taxed: "..tostring(total_tax).." plat., Paid: "..tostring(total_paid).." plat.~");
        e.other:Message(6, "{Listings}: [".. eq.say_link("List",false,"show all items") .."] # [".. eq.say_link("price+1+500",false,"price 1-500") .."] # [".. eq.say_link("price+500+1000",false,"price 500-1000") .."] # [".. eq.say_link("price+1000+3000",false,"price 1000-3000") .."]");
        e.other:Message(6, "{Filters}: [".. eq.say_link("class+",false,"show items by class") .."] # [".. eq.say_link("spells+",false,"spells and tomes") .."]");
        e.other:Message(6, "{Search}: [".. eq.say_link("search+",false,"item search") .."] # [".. eq.say_link("history+",false,"sales history") .."]");
        e.other:Message(6, "{Account Management}: [".. eq.say_link("Edit",false,"edit listings") .."] # [".. eq.say_link("Cashout",false,"cashout") .."] # [".. eq.say_link("Sell",false,"sell") .."]");
    end
    if (e.message:findi("Sell")) then
    e.other:Message(8, "The command is [Commit+ItemName+PriceinPlatinum] (example: /say commit+paw of opalla+500 or use direct+ for contact only sale.) you will be taxed "..tostring(tax_str).. " percent on all sales. Post up to 20 items per character. Use item links! Items (except spells) expire after 7 days.");
    e.other:Message(8, "+-[".. eq.say_link("hail",false,"main menu") .."]-+");
  end
    
    if (e.message:findi("Check")) then
        --    item_id = string.match(e.message, "%d+")
        --    e.self:Emote("1");
            e.other:Message(6, "The Test command will check if an item can be sold [Test+ItemName] example: test+paw of opalla");
            end

            if (e.message:findi("Test+")) then
                con = assert (env:connect(db,username,password,server));
                local test_instruct = split(e.message, "+")
                link_length = string.len(test_instruct[2])
                if(tonumber(link_length) >= 50) then
                cln_item_name = test_instruct[2]:sub(58);
                end
                cln_item_name = cln_item_name:sub(1, -2);
                --e.other:Message(14, tostring(cln_item_name));
                local item_info = con:execute("SELECT id,nodrop,norent,notransfer,maxcharges,slots,attuneable FROM items WHERE name like '%"..cln_item_name.."%'");
                row = item_info:fetch ({}, "a");
                e.other:Message(3,"Code: " ..row.id.. ", " ..row.nodrop..", " ..row.norent..", " ..row.notransfer..", " ..row.maxcharges..", " ..row.slots..", "..eq.count_item(tonumber(row.id))..", "..row.attuneable);
                if (tonumber(row.nodrop)== 1 and tonumber(row.norent) == 1 and tonumber(row.notransfer) == 0 and tonumber(row.maxcharges) == 0 and e.other:HasItem(tonumber(row.id)) and tonumber(row.attuneable) == 0) then
                    e.other:Message(6, "This item is sellable.");
                else
                    e.other:Message(6, "Not sellable using Commit+! Reasons for failure include: No Drop item. No Rent item. Item has charges or is a clicky. Use Direct+ instead to list this item.");
                end
                con:close();
                return
                    end

    if (e.message:findi("commit+")) then
    con = assert (env:connect(db,username,password,server));
    in_shared = nil
    local client = e.other:CastToClient();
    local commit_instruct = split(e.message, "+");
    local listing_count1 = con:execute("SELECT COUNT(*) FROM item_auction WHERE Char_Name like '"..e.other:GetName().."' and Active = 1;");
    local listing_count2 = listing_count1:fetch();
    local account_count1 = con:execute("SELECT COUNT(*) FROM item_auction WHERE Account_ID = '"..client:AccountID().."' and Active = 1;");
    local account_count2 = account_count1:fetch();
    link_length = string.len(commit_instruct[2]);
    local item_name = commit_instruct[2];
    local item_name_dbfriend = tostring(commit_instruct[2]);
    if(tonumber(link_length) >= 50) then
    item_name = commit_instruct[2]:sub(58);
    item_name = item_name:sub(1, -2);
    item_name_dbfriend = item_name;
    end
    if(string.match(tostring(item_name_dbfriend), "'")) then
    item_name_dbfriend = item_name_dbfriend:gsub("'", "''");
    end

    local item_info = con:execute("SELECT name,id,nodrop,norent,notransfer,maxcharges,slots,attuneable,loregroup,augtype,clickeffect FROM items WHERE name like '"..item_name_dbfriend.."'");
    local row = item_info:fetch ({}, "a");
    local past_count = eq.count_item(tonumber(row.id));

  for _, slot in ipairs(slot_ids1) do
     for a = Slot.AugSocketBegin, Slot.AugSocketEnd, 1 do       
       if (tonumber(row.id) == tonumber(client:GetItemIDAt(slot)) and client:GetAugmentIDAt(slot,a) >= 1) then
         e.other:Message(3,"This item might be augmented, or you have a similar item with an augment installed. If you commit this item your augment may be lost. Please remove the augment from any identical items in your inventory before posting."); 
         return
       end
       end
     end

    for _, slot in ipairs(slot_ids2) do
      for a = Slot.AugSocketBegin, Slot.AugSocketEnd, 1 do       
        if (tonumber(row.id) == tonumber(client:GetItemIDAt(slot)) and client:GetAugmentIDAt(slot,a) >= 1) then
          e.other:Message(3,"This item might be augmented, or you have a similar item with an augment installed. If you commit this item your augment may be lost. Please remove the augment from any identical items in your inventory before posting."); 
          return
        end
        end
      end

    for _, slot in ipairs(shared_bank_slots) do
    if (tonumber(row.id) == tonumber(client:GetItemIDAt(slot))) then
    in_shared = "true"
    e.other:Message(3,"You are not allowed to list an item that you have in your shared bank. Remove the item from your shared bank and then attempt to list it again."); 
        return
    end
    end
    e.other:Message(3,"Code: " ..row.id.. ", " ..row.nodrop..", " ..row.norent..", " ..row.notransfer..", " ..row.maxcharges..", " ..row.slots..", "..eq.count_item(tonumber(row.id))..", "..row.attuneable.. ", " ..listing_count2..", "..tostring(in_shared));
    if (tonumber(row.nodrop)== 1 and tonumber(row.norent) == 1 and tonumber(row.notransfer) == 0 and (tonumber(row.maxcharges) < 0 or tonumber(row.clickeffect) <= 0) and e.other:HasItem(tonumber(row.id)) and tonumber(row.attuneable) == 0 and tonumber(listing_count2) <= 19 and tonumber(commit_instruct[3]) ~= nil) then
    local sellable = 1;
    eq.remove_item(tonumber(row.id), 1);
    if(tonumber(past_count) <= eq.count_item(tonumber(row.id))) then
        if(eq.count_item(tonumber(row.id)) == 1) then
            e.other:NukeItem(tonumber(row.id));
        else
        e.other:Message(6, "An error occurred and I am unable to post your item. This sometimes occurs if there is 2 or more items in the database with the exact same name and I was unable to determine which item you have to sell. I will email the administrator");
        con:close();
        eq.send_mail(gm_name, tostring(e.other:GetName()), "["..tostring(e.other:GetName()).."] Auction error.",item_name_dbfriend.." attempted to list but the item was not deleted.");
        con:close();
        return
        end      
    end

    con:execute([[INSERT INTO item_auction (Account_ID, Char_ID, Char_Name, Item_Name, Item_ID, Price, Aug_Num) VALUES (']]..client:AccountID().."','"..e.other:CharacterID().."','"..e.other:GetName().."','"..item_name_dbfriend.."','"..row.id.."','"..commit_instruct[3].."','"..tostring(row.augtype).."')");
    local listing_id = con:execute("SELECT id FROM item_auction WHERE Item_ID = "..tostring(row.id).." AND Price = "..tostring(commit_instruct[3]).." AND Char_ID = "..tostring(e.other:CharacterID()).." AND Active = 1 AND Paid_Out = 0 AND Expired = 0 LIMIT 1;");
    local listing_id2 = listing_id:fetch();

    local query = ("SELECT ID,Date_Listed,Char_Name,Item_Name,Item_ID,Price,Sold_To FROM item_auction WHERE Paid_Out = 1 AND Item_Name like '"..tostring(item_name_dbfriend).."'");
    cur2 = assert (con:execute(tostring(query)));
    row2 = cur2:fetch ({}, "a");
    local i = 0;
    local hist_avg_calc = 0;
    local hist_avg = 0;
    while row2 do
      --print(string.format("ID: %s, Date: %s", row.ID, row.DATE)

        if(row2.Sold_To ~= "Canceled" and row2.Sold_To ~= "Relisted" and row2.Sold_To ~= nil and row2.Price ~= nil) then
        i = i + 1;
        hist_avg_calc = hist_avg_calc + tonumber(row2.Price);
        end
            
      row2 = cur2:fetch (row2, "a");
    end
    if hist_avg_calc >= 1 then
    hist_avg = (hist_avg_calc / i);
    hist_avg = math.floor(hist_avg+0.5);
    hist_avg = (tostring(hist_avg).."p")
    else
      hist_avg = "no data";
    end

    e.other:Message(6, "Posted ["..eq.get_item_name(tonumber(row.id)).."] for "..tostring(commit_instruct[3]).. " platinum.");
    eq.get_entity_list():ChannelMessage(e.self, 4, 0, "Somebody posted ["..eq.item_link(tonumber(row.id)).."] for "..tostring(commit_instruct[3]).. "p. (avg. "..tostring(hist_avg)..") [".. eq.say_link("Purchase+"..tostring(listing_id2),false,"Buy Now") .."].");
    else
    e.other:Message(6, "Not sellable! Reasons for failure include: No Drop item. Attuneable item. No Rent item. Item has charges or is a clicky. Item is not in your inventory. You have more than one of the item in your inventory. You have not spelled the item name exactly. You have 20 existing posts. Other technical reasons to protect the integrity of the system.");
    end
    con:close();
    return
    end

    if (e.message:findi("direct+")) then
      con = assert (env:connect(db,username,password,server));
      local client = e.other:CastToClient();
      local direct_instruct = split(e.message, "+");
      local listing_count1 = con:execute("SELECT COUNT(*) FROM item_auction WHERE Char_Name like '"..e.other:GetName().."' and Active = 1;");
      local listing_count2 = listing_count1:fetch();
      local account_count1 = con:execute("SELECT COUNT(*) FROM item_auction WHERE Account_ID = '"..client:AccountID().."' and Active = 1;");
      local account_count2 = account_count1:fetch();
      link_length = string.len(direct_instruct[2]);
      local item_name = direct_instruct[2];
      local item_name_dbfriend = tostring(direct_instruct[2]);
      local item_price = direct_instruct[3]
      if(tonumber(link_length) >= 50) then
      item_name = direct_instruct[2]:sub(58);
      item_name = item_name:sub(1, -2);
      item_name_dbfriend = item_name;
      end
      if(string.match(tostring(item_name_dbfriend), "'")) then
      item_name_dbfriend = item_name_dbfriend:gsub("'", "''");
      end
  
      if (tonumber(listing_count2) <= 19 and tonumber(item_price) ~= nil and string.len(item_name) <= 36) then
      local sellable = 1;
      e.other:Message(8, "Posting as direct only, ["..item_name.."] for "..tostring(item_price).. " platinum.");
      con:execute([[INSERT INTO item_auction (Account_ID, Char_ID, Char_Name, Item_Name, Price, Sale_Type) VALUES (']]..client:AccountID().."','"..e.other:CharacterID().."','"..e.other:GetName().."','"..item_name_dbfriend.."','"..tostring(item_price).."','Direct')");
      else
        e.other:Message(8, "Please limit your item name or decription to 36 characters or less.")
      end
      con:close();
      return
      end

    if (e.message:findi("Buy")) then
        e.other:Message(13, "Use [class+] for a more refined list");
        e.other:Message(6, "The commands are [".. eq.say_link("List",false,"List") .."] (to list all items (up to 100)), spells+class to search for spells (example: spells+nec), ListByPlayer+PlayerName, Search+ItemName (case sensitive! example: search+Spell), Price+LowPrice+HighPrice (Search a price range example: price+1+500 searches between 1 and 500 platinum.), Search class and slot class+Class Acronym (example: class+MNK or class+MNK+chest)");

    end

    if (e.message:findi("ListByPlayer+")) then
        con = assert (env:connect(db,username,password,server));
        local listbyplayer_instruct = split(e.message, "+");
        cur = assert (con:execute"SELECT * FROM (SELECT ID,Date_Listed,Char_Name,Item_Name,Item_ID,Price FROM item_auction WHERE Active = 1 AND Expired = 0 ORDER BY id DESC LIMIT 300) sub ORDER BY id ASC");
        row = cur:fetch ({}, "a");
        
        while row do
          prettydateListed = split(row.Date_Listed, " ");
        if(row.Char_Name == listbyplayer_instruct[2]) then
        local i = 1;
          e.other:Message(6, string.format("[".. eq.say_link("Order+"..tostring(row.ID),false,"Buy Now") .."]{%s}{%s}" ..eq.item_link(tonumber(row.Item_ID)).."{%s plat}", row.Char_Name, prettydateListed[1], tostring(row.Price)));
        end
          -- reusing the table of results
          row = cur:fetch (row, "a");
        end
            e.other:Message(8, "+----------+End of Results+--------------------------------------------+[".. eq.say_link("hail",false,"main menu") .."]+----------+")
            cur:close();
            con:close();
            return
        end

        if (e.message:findi("Search+")) then
            con = assert (env:connect(db,username,password,server));
            local search_instruct = split(e.message, "+");
            if search_instruct[2] then
            else
              e.other:Message(8, "Use /say search+item_name or search+partial_item_name. Example: search+manastone or search+stone")
              return
            end
            if search_instruct[2] then
            item_name_dbfriend = search_instruct[2];
            link_length = string.len(search_instruct[2]);
            if(tonumber(link_length) >= 50) then
                local item_name = search_instruct[2]:sub(58);
                item_name = item_name:sub(1, -2);
                item_name_dbfriend = item_name;
                end
            if(string.match(tostring(item_name_dbfriend), "'")) then
              item_name_dbfriend = item_name_dbfriend:gsub("'", "''");
              end
            end
            e.other:Message(8, "Search query: " ..tostring(search_instruct[2]));

            local query = ("SELECT * FROM (SELECT ID,Date_Listed,Char_Name,Item_Name,Item_ID,aug_num,Price,Sale_Type FROM item_auction WHERE Active = 1 AND Expired = 0 AND Item_Name like '%"..tostring(item_name_dbfriend).."%' ORDER BY id DESC LIMIT 300) sub ORDER BY id ASC");
            cur = assert (con:execute(tostring(query)));
            row = cur:fetch ({}, "a");

            while row do
              prettydateListed = split(row.Date_Listed, " ");
            local i = 1;
            if(row.Sale_Type == "Direct") then
              e.other:Message(6, string.format("[".. eq.say_link("Contact+"..tostring(row.ID),false,"Contact Seller").."]{%s}{%s}" ..tostring(row.Item_Name).."{%s plat}", row.Char_Name, prettydateListed[1], tostring(row.Price)));
            else
              e.other:Message(6, string.format("[".. eq.say_link("Order+"..tostring(row.ID),false,"Buy Now") .."]{%s}{%s}" ..eq.item_link(tonumber(row.Item_ID)).."{%s plat}", row.Char_Name, prettydateListed[1], tostring(row.Price)));
            end-- reusing the table of results
              row = cur:fetch (row, "a");
            end
                e.other:Message(8, "+----------+End of Results+--------------------------------------------+[".. eq.say_link("hail",false,"main menu") .."]+----------+");
                cur:close();
                con:close();
                return
            end

            if (e.message:findi("History+")) then
              con = assert (env:connect(db,username,password,server));
              local history_instruct = split(e.message, "+");
              if history_instruct[2] then
              link_length = string.len(history_instruct[2]);
              item_name_dbfriend = tostring(history_instruct[2]);
             if(tonumber(link_length) >= 50) then
              local item_name = history_instruct[2]:sub(58);
              item_name = item_name:sub(1, -2);
              item_name_dbfriend = item_name;
              end
             if(string.match(tostring(item_name_dbfriend), "'")) then
             item_name_dbfriend = item_name_dbfriend:gsub("'", "''");
             end
            end
            e.other:Message(8, "Search query: " ..tostring(history_instruct[2]));
             if(item_name_dbfriend) then
             else
              e.other:Message(8, "Use /say history+item_name or history+item_link example: history+manastone");
              return
             end
              local query = ("SELECT ID,Date_Listed,Char_Name,Item_Name,Item_ID,Price,Sold_To FROM item_auction WHERE Paid_Out = 1 AND Item_Name like '%"..tostring(item_name_dbfriend).."%'");
              cur = assert (con:execute(tostring(query)));
              row = cur:fetch ({}, "a");
              
              while row do
                prettydateListed = split(row.Date_Listed, " ");
                  if(row.Sold_To ~= "Canceled" and row.Sold_To ~= "Relisted" and row.Sold_To ~= null) then
               local i = 1;
                e.other:Message(6, string.format("Sold by %s to %s, On: %s - " ..eq.item_link(tonumber(row.Item_ID)).."{%s plat}", row.Char_Name, row.Sold_To, prettydateListed[1], tostring(row.Price)));
                  end

                row = cur:fetch (row, "a");
              end
                  e.other:Message(8, "+----------+End of Results+--------------------------------------------+[".. eq.say_link("hail",false,"main menu") .."]+----------+");
                  cur:close();
                  con:close();
                  return
              end

            if (e.message:findi("Class+")) then
              con = assert (env:connect(db,username,password,server));
              local class_instruct = split(e.message, "+");
              if(class_instruct[2]) then
              class_instruct2 = class_instruct[2]:upper()
              end
              if(class_instruct[3]) then
              class_instruct3 = class_instruct[3]:upper()   
              end       
              local term;
              local term2;

              if(class_instruct[2]) then
              if string.match("WAR", class_instruct2) then
                term = 1;
              end
              if string.match("CLR", class_instruct2) then
                term = 2;
              end
              if string.match("PAL", class_instruct2) then
                term = 4;
              end
              if string.match("RNG", class_instruct2) then
                term = 8;
              end
              if string.match("SHD", class_instruct2) then
                term = 16;
              end
              if string.match("DRU", class_instruct2) then
                term = 32;
              end
              if string.match("MNK", class_instruct2) then
                term = 64;
              end
              if string.match("BRD", class_instruct2) then
                term = 128;
              end
              if string.match("ROG", class_instruct2) then
                term = 256;
              end
              if string.match("SHM", class_instruct2) then
                term = 512;
              end
              if string.match("NEC", class_instruct2) then
                term = 1024;
              end
              if string.match("WIZ", class_instruct2) then
                term = 2048;
              end
              if string.match("MAG", class_instruct2) then
                term = 4096;
              end
              if string.match("ENC", class_instruct2) then
                term = 8192;
              end
              if string.match("BST", class_instruct2) then
                term = 16384;
              end
              if string.match("BER", class_instruct2) then
                term = 32768;
              end
              if string.match("ALL", class_instruct2) then
                term = 65535;
              end
            end

            if(class_instruct[3]) then
              if string.match("CHARM", class_instruct3) then
                term2 = 1;
              end
              if string.match("EAR", class_instruct3) then
                term2 = 2;
              end
              if string.match("HEAD", class_instruct3) then
                term2 = 4;
              end
              if string.match("FACE", class_instruct3) then
                term2 = 8;
              end
              if string.match("", class_instruct3) then
                term2 = 16;
              end
              if string.match("NECK", class_instruct3) then
                term2 = 32;
              end
              if string.match("SHOULDER", class_instruct3) then
                term2 = 64;
              end
              if string.match("ARMS", class_instruct3) then
                term2 = 128;
              end
              if string.match("BACK", class_instruct3) then
                term2 = 256;
              end
              if string.match("WRIST", class_instruct3) then
                term2 = 512;
              end
              if string.match("", class_instruct3) then
                term2 = 1024;
              end
              if string.match("RANGE", class_instruct3) then
                term2 = 2048;
              end
              if string.match("HANDS", class_instruct3) then
                term2 = 4096;
              end
              if string.match("PRIMARY", class_instruct3) then
                term2 = 8192;
              end
              if string.match("SECONDARY", class_instruct3) then
                term2 = 16384;
              end
              if string.match("RING", class_instruct3) then
                term2 = 32768;
              end
              if string.match("", class_instruct3) then
                term2 = 65536;
              end
              if string.match("CHEST", class_instruct3) then
                term2 = 131072;
              end
              if string.match("LEGS", class_instruct3) then
                term2 = 262144;
              end
              if string.match("FEET", class_instruct3) then
                term2 = 524288;
              end
              if string.match("WAIST", class_instruct3) then
                term2 = 1048576;
              end
              if string.match("POWERSOURCE", class_instruct3) then
                term2 = 2097152;
              end
              if string.match("AMMO", class_instruct3) then
                term2 = 4194304;
              end
            end
            if(term) then
            else
              e.other:Message(6, "Please Choose: [".. eq.say_link("class+ALL",false,"all") .."]:[".. eq.say_link("class+BRD",false,"bard") .."]:[".. eq.say_link("class+BST",false,"beastlord") .."]:[".. eq.say_link("class+BER",false,"berserker") .."]:[".. eq.say_link("class+CLR",false,"cleric") .."]:[".. eq.say_link("class+DRU",false,"druid") .."]:[".. eq.say_link("class+ENC",false,"enchanter") .."]:[".. eq.say_link("class+MAG",false,"magician") .."]:[".. eq.say_link("class+MNK",false,"monk") .."]:[".. eq.say_link("class+NEC",false,"necro") .."]:[".. eq.say_link("class+PAL",false,"paladin") .."]:[".. eq.say_link("class+RNG",false,"ranger") .."]:[".. eq.say_link("class+ROG",false,"rogue") .."]:[".. eq.say_link("class+SHD",false,"shadowknight") .."]:[".. eq.say_link("class+SHM",false,"shaman") .."]:[".. eq.say_link("class+WAR",false,"warrior") .."]:[".. eq.say_link("class+WIZ",false,"wizard") .."]");

            --  e.other:Message(6, "You can also add a slot (class+MNK+HANDS) CHARM, EAR, HEAD, FACE, NECK, SHOULDER, ARMS, BACK, WRIST, RANGE, HANDS, PRIMARY, SECONDARY, RING, CHEST, LEGS, FEET, WAIST, POWERSOURCE, or AMMO");
              con:close();
              return
            end
            e.other:Message(8, "+----------+Results+-----------------------------------------------------------------------------------+");
            
              cur = assert (con:execute"SELECT * FROM (SELECT ID,Date_Listed,Char_Name,Item_Name,Item_ID,Price,aug_num FROM item_auction WHERE Aug_num = 0 AND Active = 1 AND Expired = 0 ORDER BY id DESC LIMIT 5000) sub ORDER BY id ASC");
              row = cur:fetch ({}, "a");
              while row do
                
                if(class_instruct[3]) then
                  if(term2) then
                  else
                    e.other:Message(6, "Sorry, That is not a valid term. CHARM, EAR, HEAD, FACE, NECK, SHOULDER, ARMS, BACK, WRIST, RANGE, HANDS, PRIMARY, SECONDARY, RING, CHEST, LEGS, FEET, WAIST, POWERSOURCE, or AMMO");
                    con:close();
                    return
                  end
                  item_info = con:execute("SELECT name,id,nodrop,norent,notransfer,maxcharges,slots,attuneable,loregroup,races FROM items WHERE ID = '"..row.Item_ID.."'AND classes & '"..term.."' AND slots & '"..term2.."'");
                  row2 = item_info:fetch ({}, "a");
                else
                  item_info = con:execute("SELECT name,id,nodrop,norent,notransfer,maxcharges,slots,attuneable,loregroup,races FROM items WHERE ID = '"..row.Item_ID.."'AND classes & '"..term.."' AND slots > 0");
                  row2 = item_info:fetch ({}, "a");
                end

                --print(string.format("ID: %s, Date: %s", row.ID, row.DATE))
                if (row2) then
                prettydateListed = split(row.Date_Listed, " ");
                e.other:Message(6, string.format("[".. eq.say_link("Order+"..tostring(row.ID),false,"Buy Now") .."]{%s}{%s}" ..eq.item_link(tonumber(row.Item_ID)).."{%s plat}", row.Char_Name, prettydateListed[1], tostring(row.Price)));
              end
                -- reusing the table of results
                row = cur:fetch (row, "a");
              end
                  e.other:Message(8, "+----------+End of Results+--------------------------------------------+[".. eq.say_link("hail",false,"main menu") .."]+----------+");
                  e.other:Message(6, "{Filter by slot}: [".. eq.say_link("class+"..class_instruct2.."",false,"all") .."]:[".. eq.say_link("class+"..class_instruct2.."+AMMO",false,"ammo") .."]:[".. eq.say_link("class+"..class_instruct2.."+ARMS",false,"arms") .."]:[".. eq.say_link("augment+",false,"augment") .."]:[".. eq.say_link("class+"..class_instruct2.."+BACK",false,"back") .."]:[".. eq.say_link("class+"..class_instruct2.."+CHARM",false,"charm") .."]:[".. eq.say_link("class+"..class_instruct2.."+CHEST",false,"chest") .."]:[".. eq.say_link("containers+",false,"containers") .."]:[".. eq.say_link("class+"..class_instruct2.."+EAR",false,"ear") .."]:[".. eq.say_link("class+"..class_instruct2.."+FACE",false,"face") .."]:[".. eq.say_link("class+"..class_instruct2.."+FEET",false,"feet") .."]:[".. eq.say_link("class+"..class_instruct2.."+HANDS",false,"hands") .."]:[".. eq.say_link("class+"..class_instruct2.."+HEAD",false,"head") .."]:[".. eq.say_link("class+"..class_instruct2.."+LEGS",false,"legs") .."]:[".. eq.say_link("class+"..class_instruct2.."+NECK",false,"neck") .."]:[".. eq.say_link("class+"..class_instruct2.."+POWERSOURCE",false,"powersource") .."]:[".. eq.say_link("class+"..class_instruct2.."+PRIMARY",false,"primary") .."]:[".. eq.say_link("class+"..class_instruct2.."+RANGE",false,"range") .."]:[".. eq.say_link("class+"..class_instruct2.."+RING",false,"ring") .."]:[".. eq.say_link("class+"..class_instruct2.."+SECONDARY",false,"secondary") .."]:[".. eq.say_link("class+"..class_instruct2.."+SHOULDER",false,"shoulder") .."]:[".. eq.say_link("class+"..class_instruct2.."+WAIST",false,"waist") .."]:[".. eq.say_link("class+"..class_instruct2.."+WRIST",false,"wrist") .."]:[".. eq.say_link("spells+"..class_instruct2.."",false,"spells and tomes") .."]");
                  e.other:Message(6, "{Filter by class}: [".. eq.say_link("class+",false,"change class") .."] currently: "..class_instruct2..".");
                  cur:close();
                  con:close();
                  return
              end

            if (e.message:findi("Spells+")) then
                 con = assert (env:connect(db,username,password,server));
                local class_instruct = split(e.message, "+");
                if(class_instruct[2]) then
                class_instruct2 = class_instruct[2]:upper()
                end
                local term1; 
                if(class_instruct[2]) then      
                if string.match("WAR", class_instruct2) then
                  term1 = 1;
                end
                if string.match("CLR", class_instruct2) then
                  term1 = 2;
                end
                if string.match("PAL", class_instruct2) then
                  term1 = 4;
                end
                if string.match("RNG", class_instruct2) then
                  term1 = 8;
                end
                if string.match("SHD", class_instruct2) then
                  term1 = 16;
                end
                if string.match("DRU", class_instruct2) then
                  term1 = 32;
                end
                if string.match("MNK", class_instruct2) then
                  term1 = 64;
                end
                if string.match("BRD", class_instruct2) then
                  term1 = 128;
                end
                if string.match("ROG", class_instruct2) then
                  term1 = 256;
                end
                if string.match("SHM", class_instruct2) then
                  term1 = 512;
                end
                if string.match("NEC", class_instruct2) then
                  term1 = 1024;
                end
                if string.match("WIZ", class_instruct2) then
                  term1 = 2048;
                end
                if string.match("MAG", class_instruct2) then
                  term1 = 4096;
                end
                if string.match("ENC", class_instruct2) then
                  term1 = 8192;
                end
                if string.match("BST", class_instruct2) then
                  term1 = 16384;
                end
                if string.match("BER", class_instruct2) then
                  term1 = 32768;
                end
                if string.match("ALL", class_instruct2) then
                  term1 = 65535;
                end
              end
                if (term1 ~= nil) then

                else
                  e.other:Message(6, "Please choose: [Spells+WAR]:[Spells+CLR]:[Spells+PAL]:[Spells+RNG]:[Spells+SHD]:[Spells+DRU]:[Spells+MNK]:[Spells+BRD]:[Spells+ROG]:[Spells+SHM]:[Spells+NEC]:[Spells+WIZ]:[Spells+MAG]:[Spells+ENC]:[Spells+BST]:[Spells+BER]:[Spells+ALL]");
                  con:close();
                  return
                end
                
                e.other:Message(8, "+----------+Results+-----------------------------------------------------------------------------------+");
                cur = assert (con:execute"SELECT * FROM (SELECT ID,Date_Listed,Char_Name,Item_Name,Item_ID,Price FROM item_auction WHERE Active = 1 AND Expired = 0 AND (Item_Name like 'Spell:%' OR Item_Name like 'Tome%') ORDER BY id DESC LIMIT 300) sub ORDER BY id ASC");
                row = cur:fetch ({}, "a");
                while row do
                  prettydateListed = split(row.Date_Listed, " ");
                  --print(string.format("ID: %s, Date: %s", row.ID, row.DATE))
                  item_info = con:execute("SELECT name,id,nodrop,norent,notransfer,maxcharges,slots,attuneable,loregroup,races FROM items WHERE ID = '"..row.Item_ID.."'AND classes & '"..term1.."'");
                  row2 = item_info:fetch ({}, "a");
                  if(row2) then
                  e.other:Message(6, string.format("[".. eq.say_link("Order+"..tostring(row.ID),false,"Buy Now") .."]{%s}{%s}" ..eq.item_link(tonumber(row.Item_ID)).."{%s plat}", row.Char_Name, prettydateListed[1], tostring(row.Price)));
                  end
                  -- reusing the table of results
                  row = cur:fetch (row, "a");
                end
                    e.other:Message(8, "+----------+End of Results+--------------------------------------------+[".. eq.say_link("hail",false,"main menu") .."]+----------+");
                    e.other:Message(6, "{Filter by items}: [".. eq.say_link("class+"..class_instruct2.."",false,"all") .."]:[".. eq.say_link("class+"..class_instruct2.."+AMMO",false,"ammo") .."]:[".. eq.say_link("class+"..class_instruct2.."+ARMS",false,"arms") .."]:[".. eq.say_link("augment+",false,"augment") .."]:[".. eq.say_link("class+"..class_instruct2.."+BACK",false,"back") .."]:[".. eq.say_link("class+"..class_instruct2.."+CHARM",false,"charm") .."]:[".. eq.say_link("class+"..class_instruct2.."+CHEST",false,"chest") .."]:[".. eq.say_link("containers+",false,"containers") .."]:[".. eq.say_link("class+"..class_instruct2.."+EAR",false,"ear") .."]:[".. eq.say_link("class+"..class_instruct2.."+FACE",false,"face") .."]:[".. eq.say_link("class+"..class_instruct2.."+FEET",false,"feet") .."]:[".. eq.say_link("class+"..class_instruct2.."+HANDS",false,"hands") .."]:[".. eq.say_link("class+"..class_instruct2.."+HEAD",false,"head") .."]:[".. eq.say_link("class+"..class_instruct2.."+LEGS",false,"legs") .."]:[".. eq.say_link("class+"..class_instruct2.."+NECK",false,"neck") .."]:[".. eq.say_link("class+"..class_instruct2.."+POWERSOURCE",false,"powersource") .."]:[".. eq.say_link("class+"..class_instruct2.."+PRIMARY",false,"primary") .."]:[".. eq.say_link("class+"..class_instruct2.."+RANGE",false,"range") .."]:[".. eq.say_link("class+"..class_instruct2.."+RING",false,"ring") .."]:[".. eq.say_link("class+"..class_instruct2.."+SECONDARY",false,"secondary") .."]:[".. eq.say_link("class+"..class_instruct2.."+SHOULDER",false,"shoulder") .."]:[".. eq.say_link("class+"..class_instruct2.."+WAIST",false,"waist") .."]:[".. eq.say_link("class+"..class_instruct2.."+WRIST",false,"wrist") .."]");
                    e.other:Message(6, "{Filter by class}: [".. eq.say_link("class+",false,"change class") .."] currently: "..class_instruct2..".");
                    cur:close();
                    con:close();
                    return
                end

                if (e.message:findi("Augment+")) then
                  con = assert (env:connect(db,username,password,server));
                  e.other:Message(8, "+----------+Results+-----------------------------------------------------------------------------------+");    
                  local query = ("SELECT ID,Date_Listed,Char_Name,Item_Name,Item_ID,aug_num,Price,Sale_Type FROM item_auction WHERE Active = 1 AND Expired = 0 AND aug_num > 0");
                  cur = assert (con:execute(tostring(query)));
                  --cur = assert (con:execute"SELECT * FROM (SELECT ID,Date_Listed,Char_Name,Item_Name,Item_ID,Price FROM item_auction WHERE Active = 1 AND Expired = 0 ORDER BY id DESC LIMIT 300) sub ORDER BY id ASC");
                  row = cur:fetch ({}, "a");
      
                  while row do
                    prettydateListed = split(row.Date_Listed, " ");
                  
                  local i = 1;
                  if(row.Sale_Type == "Direct") then
                    e.other:Message(6, string.format("[".. eq.say_link("Contact+"..tostring(row.ID),false,"Contact Seller").."]{%s}{%s}" ..tostring(row.Item_Name).."{%s plat}", row.Char_Name, prettydateListed[1], tostring(row.Price)));
                  else
                    e.other:Message(6, string.format("[".. eq.say_link("Order+"..tostring(row.ID),false,"Buy Now") .."]{%s}{%s}" ..eq.item_link(tonumber(row.Item_ID)).."{%s plat}", row.Char_Name, prettydateListed[1], tostring(row.Price)));
                  end-- reusing the table of results
                    row = cur:fetch (row, "a");
                  end
                      e.other:Message(8, "+----------+End of Results+--------------------------------------------+[".. eq.say_link("hail",false,"main menu") .."]+----------+");
                      e.other:Message(6, "{Filter by items}: [".. eq.say_link("class+"..class_instruct2.."",false,"all") .."]:[".. eq.say_link("class+"..class_instruct2.."+AMMO",false,"ammo") .."]:[".. eq.say_link("class+"..class_instruct2.."+ARMS",false,"arms") .."]:[".. eq.say_link("augment+",false,"augment") .."]:[".. eq.say_link("class+"..class_instruct2.."+BACK",false,"back") .."]:[".. eq.say_link("class+"..class_instruct2.."+CHARM",false,"charm") .."]:[".. eq.say_link("class+"..class_instruct2.."+CHEST",false,"chest") .."]:[".. eq.say_link("containers+",false,"containers") .."][".. eq.say_link("class+"..class_instruct2.."+EAR",false,"ear") .."]:[".. eq.say_link("class+"..class_instruct2.."+FACE",false,"face") .."]:[".. eq.say_link("class+"..class_instruct2.."+FEET",false,"feet") .."]:[".. eq.say_link("class+"..class_instruct2.."+HANDS",false,"hands") .."]:[".. eq.say_link("class+"..class_instruct2.."+HEAD",false,"head") .."]:[".. eq.say_link("class+"..class_instruct2.."+LEGS",false,"legs") .."]:[".. eq.say_link("class+"..class_instruct2.."+NECK",false,"neck") .."]:[".. eq.say_link("class+"..class_instruct2.."+POWERSOURCE",false,"powersource") .."]:[".. eq.say_link("class+"..class_instruct2.."+PRIMARY",false,"primary") .."]:[".. eq.say_link("class+"..class_instruct2.."+RANGE",false,"range") .."]:[".. eq.say_link("class+"..class_instruct2.."+RING",false,"ring") .."]:[".. eq.say_link("class+"..class_instruct2.."+SECONDARY",false,"secondary") .."]:[".. eq.say_link("class+"..class_instruct2.."+SHOULDER",false,"shoulder") .."]:[".. eq.say_link("class+"..class_instruct2.."+WAIST",false,"waist") .."]:[".. eq.say_link("class+"..class_instruct2.."+WRIST",false,"wrist") .."]:[".. eq.say_link("spells+"..class_instruct2.."",false,"spells and tomes") .."]");
                      e.other:Message(6, "{Filter by class}: [".. eq.say_link("class+",false,"change class") .."] currently: "..class_instruct2..".");
                      cur:close();
                      con:close();
                      return
                  end

                if (e.message:findi("Containers+")) then
                  con = assert (env:connect(db,username,password,server));  
                 e.other:Message(8, "+----------+Results+-----------------------------------------------------------------------------------+");
                 cur = assert (con:execute"SELECT * FROM (SELECT ID,Date_Listed,Char_Name,Item_Name,Item_ID,Price FROM item_auction WHERE Active = 1 AND Expired = 0 ORDER BY id) sub ORDER BY id ASC");
                 row = cur:fetch ({}, "a");
                 while row do
                   prettydateListed = split(row.Date_Listed, " ");
                   --print(string.format("ID: %s, Date: %s", row.ID, row.DATE))
                   item_info = con:execute("SELECT name,bagslots,id,nodrop,norent,notransfer,maxcharges,slots,attuneable,loregroup,races FROM items WHERE ID = '"..row.Item_ID.."'");
                   row2 = item_info:fetch ({}, "a");
                   if(row2) then
                    if(tonumber(row2.bagslots) >= 1) then
                   e.other:Message(6, string.format("[".. eq.say_link("Order+"..tostring(row.ID),false,"Buy Now") .."]{%s}{%s}" ..eq.item_link(tonumber(row.Item_ID)).."{%s plat}", row.Char_Name, prettydateListed[1], tostring(row.Price)));
                    end
                   end
                   -- reusing the table of results
                   row = cur:fetch (row, "a");
                 end
                     e.other:Message(8, "+----------+End of Results+--------------------------------------------+[".. eq.say_link("hail",false,"main menu") .."]+----------+");
                     e.other:Message(6, "{Filter by items}: [".. eq.say_link("class+"..class_instruct2.."",false,"all") .."]:[".. eq.say_link("class+"..class_instruct2.."+AMMO",false,"ammo") .."]:[".. eq.say_link("class+"..class_instruct2.."+ARMS",false,"arms") .."]:[".. eq.say_link("augment+",false,"augment") .."]:[".. eq.say_link("class+"..class_instruct2.."+BACK",false,"back") .."]:[".. eq.say_link("class+"..class_instruct2.."+CHARM",false,"charm") .."]:[".. eq.say_link("class+"..class_instruct2.."+CHEST",false,"chest") .."]:[".. eq.say_link("containers+",false,"containers") .."][".. eq.say_link("class+"..class_instruct2.."+EAR",false,"ear") .."]:[".. eq.say_link("class+"..class_instruct2.."+FACE",false,"face") .."]:[".. eq.say_link("class+"..class_instruct2.."+FEET",false,"feet") .."]:[".. eq.say_link("class+"..class_instruct2.."+HANDS",false,"hands") .."]:[".. eq.say_link("class+"..class_instruct2.."+HEAD",false,"head") .."]:[".. eq.say_link("class+"..class_instruct2.."+LEGS",false,"legs") .."]:[".. eq.say_link("class+"..class_instruct2.."+NECK",false,"neck") .."]:[".. eq.say_link("class+"..class_instruct2.."+POWERSOURCE",false,"powersource") .."]:[".. eq.say_link("class+"..class_instruct2.."+PRIMARY",false,"primary") .."]:[".. eq.say_link("class+"..class_instruct2.."+RANGE",false,"range") .."]:[".. eq.say_link("class+"..class_instruct2.."+RING",false,"ring") .."]:[".. eq.say_link("class+"..class_instruct2.."+SECONDARY",false,"secondary") .."]:[".. eq.say_link("class+"..class_instruct2.."+SHOULDER",false,"shoulder") .."]:[".. eq.say_link("class+"..class_instruct2.."+WAIST",false,"waist") .."]:[".. eq.say_link("class+"..class_instruct2.."+WRIST",false,"wrist") .."]:[".. eq.say_link("spells+"..class_instruct2.."",false,"spells and tomes") .."]");
                     e.other:Message(6, "{Filter by class}: [".. eq.say_link("class+",false,"change class") .."] currently: "..class_instruct2..".");
                     cur:close();
                     con:close();
                     return
                 end


            if (e.message:findi("Price+")) then
                con = assert (env:connect(db,username,password,server));
                local searchprice_instruct = split(e.message, "+");
                cur = assert (con:execute"SELECT * FROM (SELECT ID,Date_Listed,Char_Name,Item_Name,Item_ID,Price FROM item_auction WHERE Active = 1 AND Expired = 0 ORDER BY id DESC LIMIT 300) sub ORDER BY price ASC");
                row = cur:fetch ({}, "a");
                
                while row do
                  
                  --print(string.format("ID: %s, Date: %s", row.ID, row.DATE))
                  if (tonumber(row.Price) >= tonumber(searchprice_instruct[2]) and tonumber(row.Price) <= tonumber(searchprice_instruct[3]))  then
                local i = 1;
                prettydateListed = split(row.Date_Listed, " ");
                  e.other:Message(6, string.format("[".. eq.say_link("Order+"..tostring(row.ID),false,"Buy Now") .."]{%s}{%s}" ..eq.item_link(tonumber(row.Item_ID)).."{%s plat}", row.Char_Name, prettydateListed[1], tostring(row.Price)));
                end
                  -- reusing the table of results
                  row = cur:fetch (row, "a");
                end
                    e.other:Message(6, "+----------+End of Results+--------------------------------------------+[".. eq.say_link("hail",false,"main menu") .."]+----------+");
                    cur:close();
                    con:close();
                    return
                end


    if (e.message:findi("List")) then
    con = assert (env:connect(db,username,password,server));
    cur = assert (con:execute"SELECT ID,Date_Listed,Char_Name,Item_Name,Item_ID,Price FROM item_auction WHERE Active = 1 AND Expired = 0 ORDER BY id ASC LIMIT 20 OFFSET 0");
    row = cur:fetch ({}, "a");
    
    while row do
      prettydateListed = split(row.Date_Listed, " ");
      e.other:Message(6, string.format("[".. eq.say_link("Order+"..tostring(row.ID),false,"Buy Now") .."]{%s}{%s}" ..eq.item_link(tonumber(row.Item_ID)).."{%s plat}", row.Char_Name, prettydateListed[1], tostring(row.Price)));
      -- reusing the table of results
      row = cur:fetch (row, "a");
    end
    -- close everything
    local next = 20
    e.other:Message(6, string.format("[".. eq.say_link("show+"..next,false,"next page").."]"));
    cur:close() -- already closed because all the result set was consumed
    con:close();
    end

    if (e.message:findi("Show+")) then
      con = assert (env:connect(db,username,password,server));
        local offset_instruct = split(e.message, "+");
        local query = ("SELECT ID,Date_Listed,Char_Name,Item_Name,Item_ID,Price,Sale_Type FROM item_auction WHERE Active = 1 AND Expired = 0 ORDER BY id ASC LIMIT 20 OFFSET "..offset_instruct[2]);
        cur = assert (con:execute(tostring(query)));
        row = cur:fetch ({}, "a");
        
        local i = 0;
        while row do
          prettydateListed = split(row.Date_Listed, " ");
        i = i + 1;
        if(row.Sale_Type == "Direct") then
          e.other:Message(6, string.format("[".. eq.say_link("Contact+"..tostring(row.ID),false,"Contact Seller").."]{%s}{%s}" ..tostring(row.Item_Name).."{%s plat}", row.Char_Name, prettydateListed[1], tostring(row.Price)));
        else
          e.other:Message(6, string.format("[".. eq.say_link("Order+"..tostring(row.ID),false,"Buy Now") .."]{%s}{%s}" ..eq.item_link(tonumber(row.Item_ID)).."{%s plat}", row.Char_Name, prettydateListed[1], tostring(row.Price)));
        end
          -- reusing the table of results
          row = cur:fetch (row, "a");
        end
        next = tonumber(offset_instruct[2]) + 20;
        prev = tonumber(offset_instruct[2]) - 20;
        if(tonumber(i) <= 19) then
        e.other:Message(6, "End of results. [".. eq.say_link("show+"..prev,false,"previous page").."] +-[".. eq.say_link("hail",false,"main menu") .."]-+");
        elseif(tonumber(prev) < 0) then
        e.other:Message(6, string.format("[".. eq.say_link("show+"..next,false,"next page").."]"));
        else
        e.other:Message(6, string.format("[".. eq.say_link("show+"..prev,false,"previous page").."]  [".. eq.say_link("show+"..next,false,"next page").."]"));
        end
        cur:close();
        con:close();
        return
        end

        if (e.message:findi("contact+")) then
          con = assert (env:connect(db,username,password,server));
          local client = e.other:CastToClient();
          local contact_instruct = split(e.message, "+");
          local item_info = con:execute("SELECT ID,Item_ID,Price,Char_Name,Item_Name FROM item_auction WHERE Active = 1 AND Expired = 0 AND ID = '"..contact_instruct[2].."'");
          local row = item_info:fetch ({}, "a");
          e.other:Message(6, "Send the user "..tostring(row.Char_Name).." a tell, a mail or contact them in Discord to arrange a purchase of "..tostring(row.Item_Name)..".");
          con:close();
          end


    if (e.message:findi("Order+")) then
        con = assert (env:connect(db,username,password,server));
        local client = e.other:CastToClient();
        local order_instruct = split(e.message, "+");
        local item_info = con:execute("SELECT ID,Item_ID,Price,Char_Name,Item_Name FROM item_auction WHERE Active = 1 AND Expired = 0 AND ID = '"..order_instruct[2].."'");
        local row1 = item_info:fetch ({}, "a");
        if (row1 == nil) then
            e.other:Message(6, "Sold out.");
            return
        end
        local item_lore = con:execute("SELECT loregroup FROM items WHERE ID like '"..row1.Item_ID.."'");
        local row2 = item_lore:fetch ({}, "a");
        if(eq.count_item(tonumber(row1.Item_ID)) >= 1 and tonumber(row2.loregroup) == -1) then
        e.other:Message(6, "This item is lore and you already have one.");
        return
        end
        local buyer_money = e.other:GetCarriedMoney();
        local buyer_money_plat = (tonumber(buyer_money) *.001);
        local price_owed = tonumber(row1.Price) * 1000;
        if(buyer_money >= price_owed) then
        con:execute("UPDATE item_auction SET Active = 0 WHERE Active = 1 AND ID = '"..order_instruct[2].."'");
        con:execute("UPDATE item_auction SET Sold_To = '"..e.other:GetName().."' WHERE Active = 0 AND ID = '"..order_instruct[2].."'");
        con:execute("UPDATE item_auction SET Date_Sold = '"..tostring(dateString).."' WHERE Active = 0 AND ID = '"..order_instruct[2].."'");
        client:TakeMoneyFromPP(tonumber(price_owed),true);
        client:SummonItem(tonumber(row1.Item_ID));
        local dateString = os.date("MM/DD/YY HH:MM:SS");
        e.other:SendSound();
        eq.cross_zone_message_player_by_name(3, tostring(row1.Char_Name), "The item you listed "..tostring(row1.Item_Name).." has sold to "..e.other:GetName()..".");
        eq.send_mail(tostring(row1.Char_Name), "Ixiboru", "You have sold an item on the auction.", tostring(row1.Item_Name).. " has been sold for " ..tostring(row1.Price).. " platinum.");
        else
            e.other:Message(6, "Not enough money you have "..tostring(buyer_money_plat).. " platinum and it costs " ..tostring(row1.Price).. " platinum.");
        end
        con:close();
    end


    if (e.message:findi("Edit")) then
        local status;
        local earnings = 0;
        con = assert (env:connect(db,username,password,server));
        cur = assert (con:execute(tostring("SELECT ID,price from item_auction where active = 0 and paid_out = 1 AND Sold_to NOT LIKE '%Canceled%' AND Sold_to NOT LIKE '%Relisted%' AND Sold_To IS NOT NULL AND Char_Name like '"..e.other:GetName().."'")));
        row = cur:fetch ({}, "a");
       while row do
       earnings = tonumber(earnings) + tonumber(row.price);
        row = cur:fetch (row, "a");
        end
            earnings = format_int(earnings);
        cur:close() -- already closed because all the result set was consumed
        e.other:Message(6, "+---------+"..e.other:GetName().."+---------~Lifetime Earnings: "..tostring(earnings).." plat.~----------+");
        cur = assert (con:execute"SELECT * FROM (SELECT ID,Date_Listed,Char_Name,Item_Name,Item_ID,Price,Expired,Sale_Type FROM item_auction WHERE Active = 1) sub ORDER BY id ASC")
        row = cur:fetch ({}, "a");
        while row do
          if(tonumber(row.Expired) >= 1) then
            status = "**Expired**"
            note_color = 9
          else
            status = "Active"
            note_color = 6
          end

          prettydateListed = split(row.Date_Listed, " ");
          --print(string.format("ID: %s, Date: %s", row.ID, row.DATE))
        if(row.Char_Name == e.other:GetName()) then
          local has_item = 1;
          if(row.Sale_Type == "Direct") then
            e.other:Message(tonumber(note_color), string.format("[".. eq.say_link("Cancel "..tostring(row.ID),false,"Cancel") .."][" .. eq.say_link("Repost "..tostring(row.ID),false,"Repost") .."]{%s}{Direct}{%s}{%s}" ..tostring(row.Item_Name).."{%s plat}", tostring(status), row.Char_Name, prettydateListed[1], tostring(row.Price)));
          else
         -- e.other:Message(6, string.format("[".. eq.say_link("Cancel "..tostring(row.ID),false,"Cancel") .."],%s,[%s] Date: %s - " ..eq.item_link(tonumber(row.Item_ID)).." %s platinum.", tostring(status), row.Char_Name, row.Date_Listed, tostring(row.Price)));
          e.other:Message(tonumber(note_color), string.format("[".. eq.say_link("Cancel "..tostring(row.ID),false,"Cancel") .."][" .. eq.say_link("Repost "..tostring(row.ID),false,"Repost") .."][" .. eq.say_link("OnSale "..tostring(row.ID),false,"10perc. Off") .."]{%s}{%s}{%s}" ..eq.item_link(tonumber(row.Item_ID)).."{%s plat}", tostring(status), row.Char_Name, prettydateListed[1], tostring(row.Price)));
          end
        end
          -- reusing the table of results
          row = cur:fetch (row, "a");
        end
        -- close everything
        if (hasitem == nil) then
            e.other:Message(6, "+----------+End of Results+----------+[".. eq.say_link("edit",false,"refresh") .."]+----------+[".. eq.say_link("RepAll",false,"repost all") .."]+----------+[".. eq.say_link("hail",false,"main menu") .."]+----------+");
            return
        end
        cur:close(); -- already closed because all the result set was consumed
        con:close();
    end

    if (e.message:findi("Cancel")) then
        con = assert (env:connect(db,username,password,server));
        local cancel_instruct = split(e.message, " ");
        local cancel_info = con:execute("SELECT ID,Item_ID,Price,Char_Name,Item_Name,Sale_Type FROM item_auction WHERE Active = 1 AND ID = '"..cancel_instruct[2].."'");
        local row3 = cancel_info:fetch ({}, "a");
        if (row3 == nil) then
            e.other:Message(6, "Doesn't Exist.");
            return
        end
        local item_info = con:execute("SELECT name,id,nodrop,norent,notransfer,maxcharges,slots,attuneable,loregroup FROM items WHERE ID = '"..row3.Item_ID.."'");
        local row4 = item_info:fetch ({}, "a");
       
    if(row3.Char_Name == e.other:GetName()) then
        if(eq.count_item(tonumber(row3.Item_ID)) >= 1 and tonumber(row4.loregroup) == -1) then
            e.other:Message(6, "This item is lore and you already have one.");
            return
        end
        local client = e.other:CastToClient();
        con:execute("UPDATE item_auction SET Active = 0 WHERE Active = 1 AND ID = '"..cancel_instruct[2].."'");
        con:execute("UPDATE item_auction SET Sold_To = 'Canceled' WHERE ID = '"..cancel_instruct[2].."'");
        con:execute("UPDATE item_auction SET Date_Sold = '"..tostring(dateString).."' WHERE Active = 0 AND ID = '"..cancel_instruct[2].."'");
        con:execute("UPDATE item_auction SET Paid_Out = 1 WHERE Active = 0 AND Paid_Out = 0 AND ID = '"..cancel_instruct[2].."'");
        if(row3.Sale_Type ~= "Direct") then
        client:SummonItem(tonumber(row3.Item_ID));
        end
        e.other:Message(6, "Your auction has been cancelled.");
    else
        e.other:Message(6, "Doesn't Belong to you.");
    end
    con:close();
    end


    if (e.message:findi("Repost")) then
      con = assert (env:connect(db,username,password,server));
 
      local repost_instruct = split(e.message, " ");
      local repost_info = con:execute("SELECT ID,Item_ID,Price,Char_Name,Item_Name,Sale_Type,Aug_Num FROM item_auction WHERE Expired = 1 AND Active = 1 AND ID = '"..repost_instruct[2].."'");
      local row3 = repost_info:fetch ({}, "a");
      if (row3 == nil) then
          e.other:Message(6, "Doesn't exist or is not expired.");
          return
      end
      local item_info = con:execute("SELECT name,id,nodrop,norent,notransfer,maxcharges,slots,attuneable,loregroup,augtype,clickeffect FROM items WHERE ID like '"..row3.Item_ID.."'");
      local row4 = item_info:fetch ({}, "a");
      if(row3.Char_Name == e.other:GetName()) then
        if(row3.Aug_Num) then
          Augment = tostring(row3.Aug_Num)
        else
          Augment = 0
        end

        if(row3.Sale_Type == "Direct")then
          e.other:Message(6, "Posting ["..row3.Item_Name.."] for "..row3.Price.. " platinum.");
          local client = e.other:CastToClient();
          con:execute("UPDATE item_auction SET Active = 0 WHERE Active = 1 AND ID = '"..repost_instruct[2].."'");
          con:execute("UPDATE item_auction SET Sold_To = 'Relisted' WHERE ID = '"..repost_instruct[2].."'");
          con:execute("UPDATE item_auction SET Date_Sold = '"..tostring(dateString).."' WHERE Active = 0 AND ID = '"..repost_instruct[2].."'");
          con:execute("UPDATE item_auction SET Paid_Out = 1 WHERE Active = 0 AND Paid_Out = 0 AND ID = '"..repost_instruct[2].."'");
          con:execute([[INSERT INTO item_auction (Account_ID, Char_ID, Char_Name, Item_Name, Price, Aug_Num, Sale_Type) VALUES (']]..client:AccountID().."','"..e.other:CharacterID().."','"..e.other:GetName().."','"..row3.Item_Name.."','"..row3.Price.."','"..tostring(Augment).."','Direct')");
        end
        if(row3.Sale_Type ~= "Direct")then
      
      local client = e.other:CastToClient();
      if (tonumber(row4.attuneable) == 0) then
      con:execute("UPDATE item_auction SET Active = 0 WHERE Active = 1 AND ID = '"..repost_instruct[2].."'");
      con:execute("UPDATE item_auction SET Sold_To = 'Relisted' WHERE ID = '"..repost_instruct[2].."'");
      con:execute("UPDATE item_auction SET Date_Sold = '"..tostring(dateString).."' WHERE Active = 0 AND ID = '"..repost_instruct[2].."'");
      con:execute("UPDATE item_auction SET Paid_Out = 1 WHERE Active = 0 AND Paid_Out = 0 AND ID = '"..repost_instruct[2].."'");
      end
    local item_name_dbfriend = row3.Item_Name;
    if(string.match(tostring(item_name_dbfriend), "'")) then
    --e.other:Message(14, "Sorry, I am currently unable to process items that contain the ' symbol.");
    item_name_dbfriend = item_name_dbfriend:gsub("'", "''");
    end
    if (tonumber(row4.attuneable) == 0) then
      con:execute([[INSERT INTO item_auction (Account_ID, Char_ID, Char_Name, Item_Name, Item_ID, Price, Aug_Num) VALUES (']]..client:AccountID().."','"..e.other:CharacterID().."','"..e.other:GetName().."','"..item_name_dbfriend.."','"..row3.Item_ID.."','"..row3.Price.."','"..tostring(Augment).."')");
      e.other:Message(6, "Posting ["..row3.Item_Name.."] for "..row3.Price.. " platinum.");
    else    
      e.other:Message(6, "Item is attuned, cannot repost.");
    end
    end
  else
      e.other:Message(6, "Doesn't Belong to you.");
  end
  con:close();
end


if (e.message:findi("RepAll")) then
  con = assert (env:connect(db,username,password,server));
  cur = assert (con:execute("SELECT ID,Item_ID,Price,Char_Name,Char_ID,Item_Name,Sale_Type,Aug_Num FROM item_auction WHERE Expired = 1 AND Active = 1 AND Paid_Out = 0 and Char_ID = '"..tostring(e.other:CharacterID()).."'"));
  row3 = cur:fetch ({}, "a");
  if (row3 == nil) then
      e.other:Message(8, "No expired items found to repost.");
      return
  end
  while row3 do
  local item_info = con:execute("SELECT name,id,nodrop,norent,notransfer,maxcharges,slots,attuneable,loregroup,augtype,clickeffect FROM items WHERE ID like '"..row3.Item_ID.."'");
  local row4 = item_info:fetch ({}, "a");
  if(row3.Char_Name ~= e.other:GetName()) then
    e.other:Message(8, "Stopping, found an item that doesn't belong to you.");
    return
  end
  if(tonumber(row3.Char_ID) ~= tonumber(e.other:CharacterID())) then
    e.other:Message(8, "Stopping, found an item that doesn't belong to you.");
    return
  end
    if(row3.Aug_Num) then
      Augment = tostring(row3.Aug_Num)
    else
      Augment = 0
    end

    if(row3.Sale_Type == "Direct")then
      e.other:Message(6, "Posting ["..row3.Item_Name.."] for "..row3.Price.. " platinum.");
      local client = e.other:CastToClient();
      con:execute("UPDATE item_auction SET Active = 0 WHERE Active = 1 AND ID = '"..row3.ID.."'");
      con:execute("UPDATE item_auction SET Sold_To = 'Relisted' WHERE ID = '"..row3.ID.."'");
      con:execute("UPDATE item_auction SET Date_Sold = '"..tostring(dateString).."' WHERE Active = 0 AND ID = '"..row3.ID.."'");
      con:execute("UPDATE item_auction SET Paid_Out = 1 WHERE Active = 0 AND Paid_Out = 0 AND ID = '"..row3.ID.."'");
      con:execute([[INSERT INTO item_auction (Account_ID, Char_ID, Char_Name, Item_Name, Price, Aug_Num, Sale_Type) VALUES (']]..client:AccountID().."','"..e.other:CharacterID().."','"..e.other:GetName().."','"..row3.Item_Name.."','"..row3.Price.."','"..tostring(Augment).."','Direct')");
    end
    if(row3.Sale_Type ~= "Direct")then
  
  local client = e.other:CastToClient();
  if (tonumber(row4.attuneable) == 0) then
  con:execute("UPDATE item_auction SET Active = 0 WHERE Active = 1 AND ID = '"..row3.ID.."'");
  con:execute("UPDATE item_auction SET Sold_To = 'Relisted' WHERE ID = '"..row3.ID.."'");
  con:execute("UPDATE item_auction SET Date_Sold = '"..tostring(dateString).."' WHERE Active = 0 AND ID = '"..row3.ID.."'");
  con:execute("UPDATE item_auction SET Paid_Out = 1 WHERE Active = 0 AND Paid_Out = 0 AND ID = '"..row3.ID.."'");
  end
local item_name_dbfriend = row3.Item_Name;
if(string.match(tostring(item_name_dbfriend), "'")) then
item_name_dbfriend = item_name_dbfriend:gsub("'", "''");
end
if (tonumber(row4.attuneable) == 0) then
  con:execute([[INSERT INTO item_auction (Account_ID, Char_ID, Char_Name, Item_Name, Item_ID, Price, Aug_Num) VALUES (']]..client:AccountID().."','"..e.other:CharacterID().."','"..e.other:GetName().."','"..item_name_dbfriend.."','"..row3.Item_ID.."','"..row3.Price.."','"..tostring(Augment).."')");
else    
  e.other:Message(8, "Item is attuned, cannot repost.");
end
end
row3 = cur:fetch (row3, "a");
end
e.other:Message(8, "All expired items have been reposted.");
con:close();
end

if (e.message:findi("OnSale")) then
  con = assert (env:connect(db,username,password,server));

  local repost_instruct = split(e.message, " ");
  local repost_info = con:execute("SELECT ID,Item_ID,Price,Char_Name,Item_Name,Sale_Type,Aug_Num FROM item_auction WHERE Expired = 1 AND Active = 1 AND ID = '"..repost_instruct[2].."'");
  local row3 = repost_info:fetch ({}, "a");
  if (row3 == nil) then
      e.other:Message(6, "Doesn't exist or is not expired.");
      return
  end
  local item_info = con:execute("SELECT name,id,nodrop,norent,notransfer,maxcharges,slots,attuneable,loregroup,augtype,clickeffect FROM items WHERE ID like '"..row3.Item_ID.."'");
  local row4 = item_info:fetch ({}, "a");
  if(row3.Char_Name == e.other:GetName()) then
    if(row3.Aug_Num) then
      Augment = tostring(row3.Aug_Num)
    else
      Augment = 0
    end
    local salePrice = tonumber(row3.Price) - (tonumber(row3.Price) * .10);
    if(row3.Sale_Type == "Direct")then
      e.other:Message(6, "Posting ["..row3.Item_Name.."] for "..row3.Price.. " platinum.");
      local client = e.other:CastToClient();
      con:execute("UPDATE item_auction SET Active = 0 WHERE Active = 1 AND ID = '"..repost_instruct[2].."'");
      con:execute("UPDATE item_auction SET Sold_To = 'Relisted' WHERE ID = '"..repost_instruct[2].."'");
      con:execute("UPDATE item_auction SET Date_Sold = '"..tostring(dateString).."' WHERE Active = 0 AND ID = '"..repost_instruct[2].."'");
      con:execute("UPDATE item_auction SET Paid_Out = 1 WHERE Active = 0 AND Paid_Out = 0 AND ID = '"..repost_instruct[2].."'");
      con:execute([[INSERT INTO item_auction (Account_ID, Char_ID, Char_Name, Item_Name, Price, Aug_Num, Sale_Type, Price_Reduced) VALUES (']]..client:AccountID().."','"..e.other:CharacterID().."','"..e.other:GetName().."','"..row3.Item_Name.."','"..salePrice.."','"..tostring(Augment).."','Direct','1')");
    end
    if(row3.Sale_Type ~= "Direct")then
  
  local client = e.other:CastToClient();
  if (tonumber(row4.attuneable) == 0) then
  con:execute("UPDATE item_auction SET Active = 0 WHERE Active = 1 AND ID = '"..repost_instruct[2].."'");
  con:execute("UPDATE item_auction SET Sold_To = 'Relisted' WHERE ID = '"..repost_instruct[2].."'");
  con:execute("UPDATE item_auction SET Date_Sold = '"..tostring(dateString).."' WHERE Active = 0 AND ID = '"..repost_instruct[2].."'");
  con:execute("UPDATE item_auction SET Paid_Out = 1 WHERE Active = 0 AND Paid_Out = 0 AND ID = '"..repost_instruct[2].."'");
  end
local item_name_dbfriend = row3.Item_Name;
if(string.match(tostring(item_name_dbfriend), "'")) then
item_name_dbfriend = item_name_dbfriend:gsub("'", "''");
end
if (tonumber(row4.attuneable) == 0) then
  con:execute([[INSERT INTO item_auction (Account_ID, Char_ID, Char_Name, Item_Name, Item_ID, Price, Aug_Num, Price_Reduced) VALUES (']]..client:AccountID().."','"..e.other:CharacterID().."','"..e.other:GetName().."','"..item_name_dbfriend.."','"..row3.Item_ID.."','"..salePrice.."','"..tostring(Augment).."','1')");
  e.other:Message(6, "Posting {"..row3.Item_Name.."} for "..salePrice.. " platinum.");
else    
  e.other:Message(6, "Item is attuned, cannot repost.");
end
end
else
  e.other:Message(6, "Doesn't Belong to you.");
end
con:close();
end
  
    if (e.message:findi("Cashout")) then
        con = assert (env:connect(db,username,password,server));
        cur = assert (con:execute"SELECT * FROM (SELECT ID,Date_Listed,Char_Name,Item_Name,Item_ID,Price FROM item_auction WHERE Active = 0 AND Paid_Out = 0 ORDER BY id DESC LIMIT 300) sub ORDER BY id ASC");
        row = cur:fetch ({}, "a");
        local cash = 0;
        while row do
        if(row.Char_Name == e.other:GetName()) then
        cash = (cash + tonumber(row.Price));
        con:execute("UPDATE item_auction SET Paid_Out = 1 WHERE Active = 0 AND Paid_Out = 0 AND ID = '"..row.ID.."'");
        end    
          -- reusing the table of results
          row = cur:fetch (row, "a");
        end
        cur:close(); -- already closed because all the result set was consumed
        if(tonumber(cash) >= 1) then
            local taxed_cash = (tonumber(cash) - tonumber(cash) * tonumber(tax));
            local client = e.other:CastToClient();
            e.other:SendSound();
            client:AddMoneyToPP(0,0,0,tonumber(taxed_cash),true);
            e.other:Message(6,"Cashing out "..tostring(taxed_cash).. " platinum.");
        else
            e.other:Message(6, "You have currently have nothing to cashout.");
        end   
        con:close();    
    end
    con:close();
    return
end

