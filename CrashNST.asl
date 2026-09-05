state("CrashBandicootNSaneTrilogy", "Steam")
{
    // Steam version
    byte loading : 0x01A8FEB8, 0xA0, 0x22C;
    float fade : 0x1A69598, 0xA0, 0x40, 0xF8, 0x10, 0x3AC;
    string255 stage : 0x1A5C6E7;
    bool enteringGame : 0x1A91610, 0x50, 0x50, 0x28, 0x18, 0x520;
    bool pause : 0x01A5B010, 0x100;
    byte c1Cortex : 0x01A745B0, 0x940, 0x5C8;
    bool c2SpeedShoes : 0x01A69A98, 0xE8, 0xA0, 0xA28;
    float c2Cortex : 0x01AAC7E0, 0x468;
    bool c3WarpPortal : 0x01A62370, 0x48, 0x3B0;
    float progress : 0x1AA27C0;
    int gems : 0x01AA27C8, 0x18;
    int platinumRelics : 0x01AA27C8, 0x24;
    int goldRelics : 0x01AA27C8, 0x20;
    int sapphireRelics : 0x01AA27C8, 0x1C;
    byte c3SuperPower1 : 0x01A69A98, 0x18, 0x70, 0xA88;
    byte c3SuperPower2 : 0x01A69A98, 0xE8, 0xA0, 0x908;
    byte c3SuperPower3 : 0x01A69A98, 0xE8, 0xA0, 0x8A8;
    byte c3SuperPower4 : 0x01A69A98, 0x18, 0x70, 0x968;
    byte platformCrash : 0x01A9E778, 0x0, 0x268, 0x1C0, 0x450;
    byte platformCoco : 0x01A9E778, 0x10, 0x18, 0x20, 0x1B8, 0x630;
}

state("CrashBandicootNSaneTrilogy", "Gamepass")
{
    // Game Pass version
    byte loading : 0x01AB7AE0, 0xA0, 0x22C;
    float fade : 0x01AB7AE0, 0x374;
    string255 stage : 0x1A84007;
    bool enteringGame : 0x1AB9C20, 0x30;
    bool pause : 0x1A81A08, 0x100;
    byte c1Cortex : 0x01A9D0A0, 0x940, 0x608;
    bool c2SpeedShoes : 0x01AD1288, 0x28, 0x18, 0x88, 0x40, 0x28, 0xA28;
    float c2Cortex : 0x01AD3358, 0x558;
    bool c3WarpPortal : 0x01A8B780, 0x48, 0x730;
    float progress : 0x1AC9BF8;
    int gems : 0x01AC9C00, 0x18;
    int platinumRelics : 0x01AC9C00, 0x24;
    int goldRelics : 0x01AC9C00, 0x20;
    int sapphireRelics : 0x01AC9C00, 0x1C;
    byte c3SuperPower1 : 0x01AD1288, 0x28, 0x18, 0x88, 0x40, 0x28, 0xA88;
    byte c3SuperPower2 : 0x01AD1288, 0x28, 0x18, 0x88, 0x40, 0x28, 0x908;
    byte c3SuperPower3 : 0x01AD1288, 0x28, 0x18, 0x88, 0x40, 0x28, 0x8A8;
    byte c3SuperPower4 : 0x01AD1288, 0x28, 0x18, 0x88, 0x40, 0x28, 0x968;
    byte platformCrash : 0x01AF8628, 0x20, 0x148, 0x460;
    byte platformCoco : 0x01AF8628, 0x20, 0x570, 0x320;
}

startup
{
    settings.Add("C1", true, "Crash 1");
    settings.Add("C2", true, "Crash 2");
    settings.Add("C3", true, "Crash 3");
    settings.Add("All_Games", true, "All Games");

    settings.CurrentDefaultParent = "C1";
    settings.Add("C1_Level", true, "Level");
    settings.Add("C1_Boss", true, "Boss");
    settings.Add("C1_Any_End", true, "[Any%] Cortex : HP0");
    settings.Add("C1_AllGems_End", true, "[All Gems] Secret Ending : Curtain");

    settings.CurrentDefaultParent = "C2";
    settings.Add("C2_Level", true, "Level");
    settings.Add("C2_Boss", true, "Boss");
    settings.Add("C2_Any_End", true, "[Any%] Cortex : Speed Shoes (Unstable)");
    settings.Add("C2_100_End", true, "[100%] Secret Ending : Loading");

    settings.CurrentDefaultParent = "C3";
    settings.Add("C3_Level", true, "Level");
    settings.Add("C3_Boss", true, "Boss");
    settings.Add("C3_GateClip", true, "Gate Clip");
    settings.Add("C3_Any_End", true, "[Any%] Cortex : Portal");
    settings.Add("C3_108_End_1", true, "[108%] The last gem");
    settings.Add("C3_108_End_2", true, "[108%] Cortex : Portal (Use for non-optimized routes)");

    settings.CurrentDefaultParent = "All_Games";
    settings.Add("Title", true, "Title screen (Except at the start)");

    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    // Asks user to change to game time if LiveSplit is currently set to Real Time.
    {        
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time.\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );
        
        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

init
{
    int moduleSize = modules.First().ModuleMemorySize;

    if (moduleSize == 30883840)
        version = "Steam";
    else if (moduleSize == 30633984)
        version = "Gamepass";
    else
    {
        version = "Unknown";
        print("CrashNST.asl: Unsupported module size: " + moduleSize);
    }

    vars.ResetState = (Action)(() =>
    {
        // Load remover state
        vars.c3IntroLoadAdjusted = false;
        vars.blackScreenStartTimeMs = 0.0;
        vars.correctedGameTimeMs = 0.0;
        vars.isBlackScreen = false;
        vars.shouldSetGameTime = false;
        vars.isLoadRemovalActive = false;

        // Autosplit state
        vars.splitRequested = false;
        vars.splitAwaitingCleanup = false;
        vars.hubVisitState = 0;
        vars.usedC3HubPlatform = false;
        vars.gateClipDetected = false;
        vars.titleStartState = 0;
        vars.wasPausedBeforeLoad = false;
        vars.inHub = false;
        vars.blockEndSplit = false;
        vars.blockLevelSplit = false;
        vars.blockBossSplit = false;
        vars.clearGame = false;
        vars.c3LastGemDetected = false;

        // Stage state
        vars.stageId = "";
        vars.previousStageId = "";
        vars.gameNumber = "";
        vars.stageNum = 0;

        // Hub load state:
        // 0 = inactive, 1 = split occurred in hub, 2 = hub load detected
        vars.hubLoadState = 0;

        // Relic state
        vars.relicCount = 0;
        vars.previousRelicCount = 0;
    });

    vars.UpdateStageInfo = (Action<string>)(stage =>
    {
        if (stage != null && stage.Contains("/"))
        {
            string[] parts = stage.Split('/');
            string stageName = stage.ToLower();
            string newStageId = "";
            string stagePrefix = "";

            switch (stageName)
            {
                case "c1_startscreen/c1_startscreen":
                    newStageId = "t000";
                    break;
                case "c1_intro/c1_intro":
                    newStageId = "i101";
                    break;
                case "l200_intro/l200_intro":
                    newStageId = "i201";
                    break;
                case "c3_intro/c3_intro":
                    newStageId = "i301";
                    break;
                case "c1_outro/c1_outro":
                    newStageId = "o101";
                    break;
                case "c1_outro100/c1_outro100":
                    newStageId = "o102";
                    break;
                case "c2_outro01/c2_outro01":
                    newStageId = "o201";
                    break;
                case "c2_outro02/c2_outro02":
                    newStageId = "o202";
                    break;
                default:
                    if (parts[0].StartsWith("l"))
                        stagePrefix = parts[0];
                    else if (parts.Length > 1 && parts[1].StartsWith("b"))
                        stagePrefix = parts[1];

                    if (stagePrefix.Length >= 4)
                        newStageId = stagePrefix.Substring(0, 4);
                    break;
            }

            // Keep the previous valid ID when the current stage string is not recognized.
            if (newStageId.Length >= 2)
            {
                vars.stageId = newStageId;

                int stageNum;
                if (int.TryParse(vars.stageId.Substring(1), out stageNum))
                    vars.stageNum = stageNum;
                else
                    vars.stageNum = 0;

                vars.gameNumber = vars.stageId.Substring(1, 1);
            }
        }
    });

    vars.ResetState();
}

onStart
{
    vars.ResetState();

    // Practice support when starting from a hub or loading screen.
    bool startsInHub =
        current.stage == "l100_hub/l100_hub" ||
        current.stage == "l200_hub/l200_hub" ||
        current.stage == "l300_hub/l300_hub";

    if (startsInHub)
        vars.hubVisitState = 1;

    if (current.loading == 1)
    {
        vars.shouldSetGameTime = true;
        vars.hubVisitState = 1;
    }
}

update
{
    // Prevent unknown builds from falling back to the first state descriptor.
    if (version == "Unknown")
        return false;

    // ---------------------------------------------------------------------
    // Stage information
    // ---------------------------------------------------------------------

    vars.UpdateStageInfo(current.stage);

    bool isHubStage =
        vars.stageId == "l100" ||
        vars.stageId == "l200" ||
        vars.stageId == "l300";

    vars.inHub = isHubStage;

    if (vars.previousStageId != vars.stageId && !vars.inHub)
        vars.previousStageId = vars.stageId;

    // ---------------------------------------------------------------------
    // Title split
    // ---------------------------------------------------------------------

    if (vars.hubVisitState > 0 && vars.stageId == "t000")
        vars.hubVisitState = 0;

    if (!current.enteringGame)
        vars.titleStartState = 1;

    if (current.enteringGame && vars.titleStartState == 1)
        vars.titleStartState = 2;

    bool shouldSplitTitle =
        settings["Title"] &&
        current.enteringGame &&
        vars.stageId == "t000" &&
        vars.titleStartState == 2;

    if (shouldSplitTitle)
    {
        vars.titleStartState = 0;
        vars.splitRequested = true;
    }

    // ---------------------------------------------------------------------
    // Hub state
    // ---------------------------------------------------------------------

    bool shouldUpdatePauseState =
        (vars.inHub && current.pause && vars.previousRelicCount == vars.relicCount) ||
        (!vars.inHub && !current.pause);

    if (shouldUpdatePauseState)
        vars.wasPausedBeforeLoad = current.pause;

    if (vars.inHub && vars.hubVisitState == 0)
        vars.hubVisitState = 1;

    if (!vars.inHub && vars.hubVisitState == 1)
        vars.hubVisitState = 2;

    // Crash 1 enters its intro before the first normal hub return.
    if (vars.stageId == "i101")
        vars.hubVisitState = 2;

    if ((vars.inHub || vars.stageId == "t000") && vars.clearGame)
        vars.clearGame = false;

    // ---------------------------------------------------------------------
    // Split settings shared by all three games
    // ---------------------------------------------------------------------

    string currentGameNumber = vars.gameNumber;

    if (currentGameNumber == "1" || currentGameNumber == "2" || currentGameNumber == "3")
    {
        vars.blockLevelSplit =
            vars.previousStageId.StartsWith("l" + currentGameNumber) &&
            !settings["C" + currentGameNumber + "_Level"];

        vars.blockBossSplit =
            vars.previousStageId.StartsWith("b" + currentGameNumber) &&
            !settings["C" + currentGameNumber + "_Boss"];
    }
    else
    {
        vars.blockLevelSplit = false;
        vars.blockBossSplit = false;
    }

    // ---------------------------------------------------------------------
    // Crash 1 specific splits
    // ---------------------------------------------------------------------

    if (currentGameNumber == "1")
    {
        bool c1AnyEndingReached =
            settings["C1_Any_End"] &&
            vars.stageId == "b106" &&
            current.loading == 0 &&
            current.fade == 0 &&
            current.c1Cortex == 0 &&
            !vars.clearGame;

        bool c1AllGemsEndingReached =
            settings["C1_AllGems_End"] &&
            !settings["C1_Any_End"] &&
            vars.stageId == "l127" &&
            current.loading == 0 &&
            old.progress < current.progress &&
            !vars.clearGame;

        if (c1AnyEndingReached || c1AllGemsEndingReached)
        {
            vars.clearGame = true;
            vars.splitRequested = true;
        }
    }

    // ---------------------------------------------------------------------
    // Crash 2 specific splits
    // ---------------------------------------------------------------------

    if (currentGameNumber == "2")
    {
        bool c2AnyEndingReached =
            settings["C2_Any_End"] &&
            vars.stageId == "b205" &&
            current.loading == 0 &&
            !current.pause &&
            current.c2SpeedShoes &&
            current.c2Cortex == 1 &&
            !vars.clearGame;

        bool c2SecretEndingReached =
            settings["C2_100_End"] &&
            vars.stageId == "o202" &&
            current.loading == 1 &&
            !vars.clearGame;

        if (c2AnyEndingReached || c2SecretEndingReached)
        {
            vars.clearGame = true;
            vars.splitRequested = true;
        }
    }

    // ---------------------------------------------------------------------
    // Crash 3 specific splits
    // ---------------------------------------------------------------------

    if (currentGameNumber == "3")
    {
        bool c3HubPlatformActive =
            vars.stageId == "l300" &&
            current.loading == 0 &&
            current.fade == 0;

        if (c3HubPlatformActive)
        {
            bool crashOnPlatform = current.platformCrash >= 130 && current.platformCrash <= 180;
            bool cocoOnPlatform = current.platformCoco >= 130 && current.platformCoco <= 180;

            if (crashOnPlatform || cocoOnPlatform)
                vars.usedC3HubPlatform = true;
        }

        if (vars.stageId.StartsWith("l3") && vars.usedC3HubPlatform)
        {
            bool gateClipWarp2 = vars.stageNum >= 306 && vars.stageNum <= 310 && current.c3SuperPower1 == 0;
            bool gateClipWarp3 = vars.stageNum >= 311 && vars.stageNum <= 315 && current.c3SuperPower2 == 0;
            bool gateClipWarp4 = vars.stageNum >= 316 && vars.stageNum <= 320 && current.c3SuperPower3 == 0;
            bool gateClipWarp5 = vars.stageNum >= 321 && vars.stageNum <= 325 && current.c3SuperPower4 == 0;

            if (gateClipWarp2 || gateClipWarp3 || gateClipWarp4 || gateClipWarp5)
                vars.gateClipDetected = true;
        }

        bool c3AnyCortexPortalReached =
            settings["C3_Any_End"] &&
            vars.stageId == "b305" &&
            current.loading == 0 &&
            current.c3WarpPortal &&
            !vars.clearGame;

        bool c3108CortexPortalReached =
            settings["C3_108_End_2"] &&
            current.progress == 108 &&
            vars.stageId == "b305" &&
            current.loading == 0 &&
            current.c3WarpPortal &&
            !vars.clearGame;

        if (c3AnyCortexPortalReached || c3108CortexPortalReached)
        {
            vars.clearGame = true;
            vars.splitRequested = true;
        }

        bool c3LastGemReached =
            settings["C3_108_End_1"] &&
            vars.stageId == "l300" &&
            current.progress == 108 &&
            current.gems == 47 &&
            !vars.c3LastGemDetected;

        if (c3LastGemReached)
        {
            vars.c3LastGemDetected = true;
            vars.splitRequested = true;
        }
    }

    // ---------------------------------------------------------------------
    // Fadeout tracking
    // ---------------------------------------------------------------------

    if (current.fade == 1 && !vars.isBlackScreen)
    {
        if (timer.CurrentTime.GameTime.HasValue)
            vars.blackScreenStartTimeMs = timer.CurrentTime.GameTime.Value.TotalMilliseconds;

        vars.isBlackScreen = true;
    }

    if (current.fade < 1)
        vars.isBlackScreen = false;

    // ---------------------------------------------------------------------
    // Relic tracking
    // ---------------------------------------------------------------------

    vars.relicCount = current.platinumRelics + current.goldRelics + current.sapphireRelics;

    if (vars.inHub && !current.pause)
        vars.previousRelicCount = vars.relicCount;

    // ---------------------------------------------------------------------
    // Load remover and load-based autosplitting
    // ---------------------------------------------------------------------

    if (current.loading == 1)
    {
        if (timer.CurrentTime.GameTime.HasValue)
        {
            double currentGameTimeMs = timer.CurrentTime.GameTime.Value.TotalMilliseconds;
            bool blackScreenStartedRecently = currentGameTimeMs - 4500 < vars.blackScreenStartTimeMs;

            if (blackScreenStartedRecently)
            {
                if (vars.stageId == "i301" && !vars.c3IntroLoadAdjusted)
                {
                    vars.blackScreenStartTimeMs -= 1000;
                    vars.c3IntroLoadAdjusted = true;
                }

                vars.correctedGameTimeMs = vars.blackScreenStartTimeMs;
                vars.shouldSetGameTime = true;
            }
        }

        vars.isLoadRemovalActive = true;

        if (vars.hubLoadState == 1)
        {
            if (vars.inHub)
                vars.hubLoadState = 2;
            else
                vars.hubLoadState = 0;
        }

        bool returnedToHub = vars.inHub && vars.hubVisitState == 2;

        vars.blockEndSplit =
            (vars.previousStageId == "o101" && settings["C1_Any_End"]) ||
            (vars.previousStageId == "o102" && settings["C1_AllGems_End"]) ||
            (vars.previousStageId == "o201" && settings["C2_Any_End"]) ||
            (vars.previousStageId == "o202" && settings["C2_100_End"]) ||
            (vars.previousStageId == "b305" && settings["C3_Any_End"]) ||
            (vars.previousStageId == "b305" && settings["C3_108_End_2"]);

        bool normalHubSplitBlocked =
            vars.wasPausedBeforeLoad ||
            vars.blockEndSplit ||
            vars.blockLevelSplit ||
            vars.blockBossSplit ||
            vars.hubLoadState == 2;

        bool canRequestNormalHubSplit =
            returnedToHub &&
            !vars.splitRequested &&
            !vars.splitAwaitingCleanup &&
            !normalHubSplitBlocked;

        if (canRequestNormalHubSplit)
            vars.splitRequested = true;

        bool canRequestGateClipSplit =
            !vars.inHub &&
            vars.gateClipDetected &&
            !vars.splitRequested &&
            !vars.splitAwaitingCleanup &&
            settings["C3_GateClip"];

        if (canRequestGateClipSplit)
        {
            vars.usedC3HubPlatform = false;
            vars.gateClipDetected = false;
            vars.splitRequested = true;
        }
    }
    else
    {
        bool loadHasFinished = vars.isLoadRemovalActive && current.fade < 1;

        if (loadHasFinished)
        {
            vars.isLoadRemovalActive = false;
            vars.c3IntroLoadAdjusted = false;
        }

        if (vars.splitAwaitingCleanup)
        {
            vars.usedC3HubPlatform = false;
            vars.gateClipDetected = false;
            vars.splitAwaitingCleanup = false;

            if (vars.inHub)
                vars.hubLoadState = 1;
        }

        if (vars.hubLoadState == 2 && !vars.inHub)
            vars.hubLoadState = 0;
    }
}

start
{
    return current.enteringGame && vars.stageId == "t000";
}

split
{
    if (!vars.splitRequested)
        return false;

    vars.splitRequested = false;
    vars.splitAwaitingCleanup = true;
    return true;
}

gameTime
{
    if (vars.shouldSetGameTime)
    {
        vars.shouldSetGameTime = false;
        return TimeSpan.FromMilliseconds(vars.correctedGameTimeMs);
    }
}

isLoading
{
    return vars.isLoadRemovalActive;
}
