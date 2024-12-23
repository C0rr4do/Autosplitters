state("NFSHP2")
{
    // Current in-game state
    // 0 = Loading, 91 = Event tree, 101 = Event tree popup
    int gameState : "NFSHP2.exe", 0x0044BCB0;

    // Indicates state of current Hot Pursuit event
    // 0 = Event ongoing, 1 = Crossed finish line (race event) or timer ran out (cop event)
    byte hpEventState : "NFSHP2.exe", 0x00303080, 0x00000020, 0x0000070C;

    // Indicates state of current Championship event
    // 0 = Event ongoing, 1 = Crossed finish line
    byte cEventState : "NFSHP2.exe", 0x002E27A0, 0x00001F34, 0x00000254;

    // Indicates if player got busted
    // true = Player got busted
    bool playerBusted : "NFSHP2.exe", 0x003F0D5C;
}


start
{
    // Start the run when the event tree popup appears.
    if (current.gameState == 101) 
        return true;

    // If the popup is skipped quickly, fallback to detecting the event tree screen.
    if (current.gameState == 91) 
        return true;
}


split 
{
    // Split when Hot Pursuit event is completed
    if (old.hpEventState == 0 && current.hpEventState == 1) 
        return true;

    // Split when Championship event is completed
    if (old.cEventState == 0 && current.cEventState == 1) 
        return true;

    // Split when player got busted
    if (!old.playerBusted && current.playerBusted)
        return true;
}

isLoading
{
    return current.gameState == 0;
}