state("CrashBandicootNSaneTrilogy", "Steam")
{
    //Steam Version
    byte loading : 0x01A8FEB8, 0xA0, 0x22C; //detects the LOADING screen
    float fade : 0x1A69598, 0xA0, 0x40, 0xF8, 0x10, 0x3AC; //detects level of the fade out (value from Grimelios' Load Remover)
    string255 stage : 0x1A5C6E7;
    bool enteringGame : 0x1A91610, 0x50, 0x50, 0x28, 0x18, 0x520;
    bool pause : 0x01A8FEB8, 0x938; //detects pause menu
    byte c1Cortex : 0x01A745B0, 0x940, 0x5C8; //C1 Any%, 105%
    bool c2SpeedShoes : 0x01A69A98, 0xE8, 0xA0, 0xA28; //C2 SpeedShoes
    float c2Cortex : 0x01AAC7E0, 0x468; //C2 Any%
    bool c3WarpPortal : 0x01A62370, 0x48, 0x3B0; //C3 Any% 108%
    float progress : 0x1AA27C0; //%
    int gems : 0x01AA27C8, 0x18; //Gems
    byte c3SuperPower1 : 0x01A69A98, 0x18, 0x70, 0xA88; //Super Charged Body Slam
    byte c3SuperPower2 : 0x01A69A98, 0xE8, 0xA0, 0x908; //Double Jump
    byte c3SuperPower3 : 0x01A69A98, 0xE8, 0xA0, 0x8A8; //Death Tornado Spin
    byte c3SuperPower4 : 0x01A69A98, 0x18, 0x70, 0x968; //Fruit Bazooka
    byte platformCrash : 0x01A9E778, 0x0, 0x268, 0x1C0, 0x450;
    byte platformCoco : 0x01A9E778, 0x10, 0x18, 0x20, 0x1B8, 0x630;
}
state("CrashBandicootNSaneTrilogy", "Gamepass")
{
    //Game Pass Version
    byte loading : 0x01AB7AE0, 0xA0, 0x22C; //detects the LOADING screen
	float fade : 0x01AB7AE0, 0x374; //detects level of the fade out 
	string255 stage : 0x1A84007;
    bool enteringGame : 0x1AB9C20, 0x30;
    bool pause : 0x1A81A08, 0x100; //detects pause menu
    byte c1Cortex : 0x01A9D0A0, 0x940, 0x608; //C1 Any%, 105%
    bool c2SpeedShoes : 0x01AD1288, 0x28, 0x18, 0x88, 0x40, 0x28, 0xA28; //C2 SpeedShoes
    float c2Cortex : 0x01AD3358, 0x558; //C2 Any%
    bool c3WarpPortal : 0x01A8B780, 0x48, 0x730; //C3 Any% 108%
    float progress : 0x1AC9BF8; //%
    int gems : 0x01AC9C00, 0x18; //Gems
    byte c3SuperPower1 : 0x01AD1288, 0x28, 0x18, 0x88, 0x40, 0x28, 0xA88; //Super Charged Body Slam
    byte c3SuperPower2 : 0x01AD1288, 0x28, 0x18, 0x88, 0x40, 0x28, 0x908; //Double Jump
    byte c3SuperPower3 : 0x01AD1288, 0x28, 0x18, 0x88, 0x40, 0x28, 0x8A8; //Death Tornado Spin
    byte c3SuperPower4 : 0x01AD1288, 0x28, 0x18, 0x88, 0x40, 0x28, 0x968; //Fruit Bazooka
    byte platformCrash : 0x01AF8628, 0x20, 0x148, 0x460;
    byte platformCoco : 0x01AF8628, 0x20, 0x570, 0x320;
}

startup
{
    settings.Add("C1", true, "Crash 1");
    settings.Add("C2", true, "Crash 2");
    settings.Add("C3", true, "Crash 3");
    settings.Add("Others", true, "Others");

    settings.CurrentDefaultParent = "C1";
    settings.Add("C1_Level", true, "Level");
    settings.Add("C1_Boss", true, "Boss");
    settings.Add("C1_Any_End", true, "[Any%] Cortex : HP0");
    settings.Add("C1_AllGems_End", true, "[All Gems] Secret Ending : Fadeout");

    settings.CurrentDefaultParent = "C2";
    settings.Add("C2_Level", true, "Level");
    settings.Add("C2_Boss", true, "Boss");
    settings.Add("C2_Any_End", true, "[Any%] Cortex : Speed Shoes");
    settings.Add("C2_100_End", true, "[100%] Secret Ending : Loading");

    settings.CurrentDefaultParent = "C3";
    settings.Add("C3_Level", true, "Level");
    settings.Add("C3_Boss", true, "Boss");
    settings.Add("C3_GateClip", true, "Gate Clip");
    settings.Add("C3_Any_End", true, "[Any%] Cortex : Portal");
    settings.Add("C3_108_End_1", true, "[108%] The last gem");
    settings.Add("C3_108_End_2", false, "[108%] Cortex : Portal (Use for non-optimized routes)");

    settings.CurrentDefaultParent = "Others";
    settings.Add("Title", true, "Title (Please uncheck the box if you're using File Fusion)");
}

init
{
    try
    {
        string hash;
        using (var md5 = System.Security.Cryptography.MD5.Create())
        using (var fs = File.OpenRead(modules.First().FileName))
        hash = string.Concat(md5.ComputeHash(fs).Select(b => b.ToString("X2")));
        
        if(hash == "F57222121DAA07B7E9D232AAEA3529BA")//Steam Version
            version = "Steam";
        else
            version = "Unknown";
    }
    catch(System.UnauthorizedAccessException)
    {
        var size = modules.First().ModuleMemorySize;
        if(size == 30883840) //Steam Version
            version = "Steam";
        else if(size == 30633984) //Gamepass Version
            version = "Gamepass";
        else
            version = "Unknown";
    }

    vars.c3Start = 0; //detects start of Crash 3
    vars.startOfLoad = 0.0; //detects start of Crash 3
    vars.setGameTime = 0.0; //value to set the game time
    vars.startOfBlack = 0; //detects start of the black screen
    vars.setGameTimeFlag = false; //indicates when to set new game time
    vars.stopTimer = 0; //indicates when to stop the timer
    vars.split = 0; //for autosplitting
    vars.hubCount = 0; //number of visits the hub for autosplit control
    vars.platform = false; //detects use of Crash3 hub platform
    vars.gateclip = false; //detects the gate clip
    vars.gameStart = 0; //prevents multiple splits at startup
    vars.pauseFlag = false; //open the pause menu
    vars.inHub = false; //when the player is in the hub
    vars.endSplitStop = false; //pause autosplit (ending)
    vars.levelSplitStop = false; //pause autosplit (level)
    vars.bossSplitStop = false; //pause autosplit (boss)
    vars.end = 0; //used to detect the end of the game (cortex etc.)
    vars.c3End108 = false; //the last gem
    vars.stageId = "";
    vars.stageIdKeep = "";
    vars.numbering = "";
    vars.hubLoading = 0;//Controls auto splitting when a save file is loaded

    vars.CheckStageId = (Action<string>)(stage =>
    {
        //stageId
    
        //title -> t000
        //level -> l???
        //boss  -> b???
        //intro -> i???
        //outro -> o???

        //example "b302" -> boss(b) crash3(3) dingodile(02)
        if(stage != null && stage.Contains("/"))
        {
            string[] parts = stage.Split('/');
            string stagePrefix = "";
            string stageName = stage.ToLower();
            switch(stageName)
            {
                case "c1_startscreen/c1_startscreen":
                    vars.stageId = "t000";
                    break;
                case "c1_intro/c1_intro":
                    vars.stageId = "i101";
                    break;
                case "l200_intro/l200_intro":
                    vars.stageId = "i201";
                    break;
                case "c3_intro/c3_intro":
                    vars.stageId = "i301";
                    break;
                case "c1_outro/c1_outro":
                    vars.stageId = "o101";
                    break;
                case "c1_outro100/c1_outro100":
                    vars.stageId = "o102";
                    break;
                case "c2_outro01/c2_outro01":
                    vars.stageId = "o201";
                    break;
                case "c2_outro02/c2_outro02":
                    vars.stageId = "o202";
                    break;
                default:
                    if(parts[0].StartsWith("l"))
                        stagePrefix = parts[0];
                    else if(parts[1].StartsWith("b"))
                        stagePrefix = parts[1];
                    
                    if(stagePrefix.Length > 4)
                        vars.stageId = stagePrefix.Substring(0, 4); //shorten stageName
                    break;
            }
            int num;
            if (int.TryParse(vars.stageId.Substring(1), out num))
                vars.stageNum = num; //extract only the numbers of the stageId
            else
                vars.stageNum = 0;

            vars.numbering = vars.stageId.Substring(1, 1);

        }
    });
}

onStart
{
    vars.c3Start = 0;
    vars.startOfLoad = 0.0;
    vars.setGameTime = 0.0;
    vars.startOfBlack = 0;
    vars.setGameTimeFlag = false;
    vars.stopTimer = 0;
    vars.split = 0;
    vars.hubCount = 0;
    vars.platform = false;
    vars.gateclip = false;
    vars.gameStart = 0;
    vars.pauseFlag = false;
    vars.inHub = false;
    vars.endSplitStop = false;
    vars.levelSplitStop = false;
    vars.bossSplitStop = false;
    vars.end = 0;
    vars.c3End108 = false;
    vars.stageId = "";
    vars.stageIdKeep = "";
    vars.numbering = "";
    vars.hubLoading = 0;

    //for practice (if the start is not the title but the hub or loading screen)
    
    if(current.stage == "l100_hub/l100_hub" || current.stage == "l200_hub/l200_hub" || current.stage == "l300_hub/l300_hub")
        vars.hubCount = 1;

    if(current.loading == 1)
    {
        vars.setGameTimeFlag = true;
		vars.hubCount = 1;
    }
}

update
{
    //check stage id func
    vars.CheckStageId(current.stage);

    //keep stageID

    if(vars.stageIdKeep != vars.stageId && vars.stageId != "l100" && vars.stageId != "l200" && vars.stageId != "l300")
        vars.stageIdKeep = vars.stageId; //previous stage name can be used even while loading

    //title

	if(vars.hubCount > 0 && vars.stageId == "t000")
		vars.hubCount = 0; //initialize hub on title screen
	
	if(current.enteringGame == false)
		vars.gameStart = 1;
        
	if(current.enteringGame == true && vars.gameStart == 1)
		vars.gameStart = 2;

	if(current.enteringGame == true && vars.stageId == "t000" && vars.gameStart == 2 && settings["Title"])
	{
		vars.gameStart = 0;
		vars.split = 1;
	}

    //hub

    vars.inHub = vars.stageId == "l100" || vars.stageId == "l200" || vars.stageId == "l300";

    if((vars.inHub == true && current.pause == true) || (vars.inHub == false && current.pause == false))
        vars.pauseFlag = current.pause;

    if(vars.inHub == true && vars.hubCount == 0)
        vars.hubCount = 1; //first the hub

    if(vars.inHub == false && vars.hubCount == 1)
        vars.hubCount = 2; //split from the second time

    if(vars.stageId == "i101")
        vars.hubCount = 2; //change the count for crash 1

    if(vars.inHub == true && vars.end == 1)
        vars.end = 0;

    //auto split option

    string numbering = vars.numbering;
    switch(numbering){
        case "1":
        {
            //c1 level
            if(vars.stageIdKeep.StartsWith("l1") && settings["C1_Level"] == false)
                vars.levelSplitStop = true;
            else
                vars.levelSplitStop = false;

            //c1 boss
            if(vars.stageIdKeep.StartsWith("b1") && settings["C1_Boss"] == false)
                vars.bossSplitStop = true;
            else
                vars.bossSplitStop = false;

            //c1 Any% end
            if(vars.stageId == "b106" && current.loading == 0 && current.fade == 0 && current.c1Cortex == 0 && vars.end == 0)
            {
                vars.end = 1;
                if(settings["C1_Any_End"])
                    vars.split = 1;
            }

            //c1 secret ending
            if(vars.stageId == "l127" && current.loading == 0 && old.progress < current.progress && vars.end == 0 && settings["C1_Any_End"] == false)
            {
                vars.end = 1;
                if(settings["C1_AllGems_End"])
                    vars.split = 1;
            }
        }
        break;
        case "2":
        {
            //c2 level
            if(vars.stageIdKeep.StartsWith("l2") && settings["C2_Level"] == false)
                vars.levelSplitStop = true;
            else
                vars.levelSplitStop = false;

            //c2 boss
            if(vars.stageIdKeep.StartsWith("b2") && settings["C2_Boss"] == false)
                vars.bossSplitStop = true;
            else
                vars.bossSplitStop = false;

            //c2 Any% end
            if(vars.stageId == "b205" && current.loading == 0 && current.pause == false && current.c2SpeedShoes && current.c2Cortex == 1 && vars.end == 0)
            {
                vars.end = 1;
                if(settings["C2_Any_End"])
                    vars.split = 1;
            }

            //c2 100% end
            if(vars.stageId == "o202" && current.loading == 1 && vars.split == 0)
            {
                if(settings["C2_100_End"])
                {
                    vars.split = 1;
                }
            }
        }
        break;
        case "3":
        {
            //c3 level
            if(vars.stageIdKeep.StartsWith("l3") && settings["C3_Level"] == false)
                vars.levelSplitStop = true;
            else
                vars.levelSplitStop = false;

            //c3 boss
            if(vars.stageIdKeep.StartsWith("b3") && settings["C3_Boss"] == false)
                vars.bossSplitStop = true;
            else
                vars.bossSplitStop = false;

            //gateclip
            if(vars.stageId == "l300" && current.loading == 0 && current.fade == 0)
            {	
                if((current.platformCrash >= 130 && current.platformCrash <= 180) || (current.platformCoco >= 130 && current.platformCoco <= 180 ))
                    vars.platform = true; //detects if the player was on the C3 hub platform
            }

            if(vars.stageId.StartsWith("l3") && vars.platform)
            {
                if (vars.stageNum >= 306 && vars.stageNum <= 310 && current.c3SuperPower1 == 0)
                    vars.gateclip = true; //warp 2 gateclip
                else if (vars.stageNum >= 311 && vars.stageNum <= 315 && current.c3SuperPower2 == 0)
                    vars.gateclip = true; //warp 3 gateclip
                else if (vars.stageNum >= 316 && vars.stageNum <= 320 && current.c3SuperPower3 == 0)
                    vars.gateclip = true; //warp 4 gateclip
                else if (vars.stageNum >= 321 && vars.stageNum <= 325 && current.c3SuperPower4 == 0)
                    vars.gateclip = true; //warp 5 gateclip
            }

            //c3 cortex portal
            if(vars.stageId == "b305" && current.loading == 0 && current.c3WarpPortal)
            {
                if(vars.end == 0)
                {
                    vars.end = 1;
                    if(settings["C3_Any_End"])
                        vars.split = 1;
                }

                if(vars.end == 0 && current.progress == 108)
                {
                    vars.end = 1;
                    if(settings["C3_108_End_2"])
                        vars.split = 1;
                }
            }

            //c3 108% the last gem
            if(vars.stageId == "l300" && current.progress == 108 && current.gems == 47 && vars.c3End108 == false)
            {
                if(settings["C3_108_End_1"])
                    vars.split = 1;

                vars.c3End108 = true;
            }
        }
        break;
    }

    //multi-games

    if(vars.stageIdKeep == "o101" && settings["C1_Any_End"])
        vars.endSplitStop = true;
    else if(vars.stageIdKeep == "o201" && settings["C2_Any_End"])
        vars.endSplitStop = true;
    else if(vars.stageIdKeep == "b305" && settings["C3_Any_End"])
        vars.endSplitStop = true;
    else if(vars.stageIdKeep == "b305" && settings["C3_108_End_2"])
        vars.endSplitStop = true;
    else
        vars.endSplitStop = false;

    //fadeout

    if(current.fade == 1 && vars.startOfBlack == 0)
    {
        vars.startOfLoad = timer.CurrentTime.GameTime.Value.TotalMilliseconds; //"remembering" the game time at the time of full blackscreen
        vars.startOfBlack = 1;
    }

    if(current.fade < 1)
        vars.startOfBlack = 0; //resetting the value

    //loading

    if(current.loading == 1)
    {
        if(timer.CurrentTime.GameTime.Value.TotalMilliseconds - 4500 < vars.startOfLoad) //detecting how long black screen was, for the sake of Gate Clip in Crash 3
        {
            if(vars.stageId == "i301" && vars.c3Start == 0)
            {
				vars.startOfLoad = vars.startOfLoad - 1000;
				vars.c3Start = 1;
            }
            vars.setGameTime = vars.startOfLoad; //rerolls the timer
            vars.setGameTimeFlag = true;
        }

        vars.stopTimer = 1; //stops the timer
        
        if(vars.hubLoading == 1)
        {
            if(vars.inHub)
                vars.hubLoading = 2;
            else
                vars.hubLoading = 0;
        }

        if(vars.inHub == true && vars.hubCount == 2 && vars.split == 0 && vars.pauseFlag == false && vars.endSplitStop == false && vars.levelSplitStop == false && vars.bossSplitStop == false && vars.hubLoading != 2)
            vars.split = 1; //normal autosplit

        if(vars.inHub == false && vars.gateclip == true && vars.split == 0 && settings["C3_GateClip"])
        {
            vars.platform = false;
            vars.gateclip = false;
            vars.split = 1; //gateclip autosplit
        }
    }
    else //not loading
	{
		if(vars.stopTimer == 1 && current.fade < 1)
		{
			vars.stopTimer = 0; //resumes the timer once the load is done and the screen is not black
			vars.c3Start = 0;
		}
		
		if(vars.split == 2)
		{
            vars.platform = false;
            vars.gateclip = false;
			vars.split = 0;
            if(vars.inHub)
                vars.hubLoading = 1;
		}

        if(vars.hubLoading == 2 && vars.inHub == false)
            vars.hubLoading = 0;
	}
}

start
{
    if(current.enteringGame && vars.stageId == "t000")
	{
		return true;
	}
	return false;
}

split
{
    if(vars.split == 1)
    {
        vars.split = 2;
        return true;
    }
    return false;
}

gameTime
{
	if(vars.setGameTimeFlag)
	{
		vars.setGameTimeFlag = false;
		return TimeSpan.FromMilliseconds(vars.setGameTime);
	}
}

isLoading
{
    if(vars.stopTimer == 1)
        return true;

    return false;
}
