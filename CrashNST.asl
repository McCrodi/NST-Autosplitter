state("CrashBandicootNSaneTrilogy")
{
    byte Loading : 0x01A8FEB8, 0xA0, 0x22C; //detects the LOADING screen
	float Fade :  0x1A69598, 0xA0, 0x40, 0xF8, 0x10, 0x3AC; //detects level of the fade out (value from Grimelios' Load Remover)
	string255 Stage : 0x1A5C6E7;
}

init
{
vars.c3start = 0; //Detects start of Crash 3
vars.startofload = 0.0; //Sets up start of the loading screen
vars.setgametime = 0.0; //Value to set the game time
vars.startofblack = 0; //Detects start of the black screen
vars.setgametimeflag = false; //Indicates when to set new game time
vars.stoptimer = 0; //Indicates when to stop the timer
}

update
{
if(current.Fade == 1 && vars.startofblack == 0)
{
vars.startofload = timer.CurrentTime.GameTime.Value.TotalMilliseconds; //"remembering" the game time at the time of full blackscreen
vars.startofblack = 1;
}

if(current.Fade < 1)
{
vars.startofblack = 0; //resetting the value
}

if(current.Loading == 1)
	{
	if(timer.CurrentTime.GameTime.Value.TotalMilliseconds - 4500 < vars.startofload) //detecting how long black screen was, for the sake of Gate Clip in Crash 3
	{
	if(current.Stage == "c3_intro/c3_intro" && vars.c3start == 0)
	{
	vars.startofload = vars.startofload - 1000;
	vars.c3start = 1;
	}
	vars.setgametime = vars.startofload; //rerolls the timer
	vars.setgametimeflag = true;
	}
	vars.stoptimer = 1; //stops the timer
	}

if(current.Loading !=1 && vars.stoptimer == 1 && current.Fade < 1)
{
vars.stoptimer = 0; //resumes the timer once the load is done and the screen is not black
vars.c3start = 0;
}

}

gameTime
{
	if(vars.setgametimeflag)
	{
		vars.setgametimeflag = false;
		return TimeSpan.FromMilliseconds(vars.setgametime); //Changing the current time to the start of the load
	}
}

isLoading 
{
    if(vars.stoptimer == 1)
        return true; //Stopping the timer

    return false;
}