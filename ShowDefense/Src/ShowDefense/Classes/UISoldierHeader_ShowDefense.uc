class UISoldierHeader_ShowDefense extends UISoldierHeader;

var string Defense;

public function PopulateData(optional XComGameState_Unit Unit, optional StateObjectReference NewItem, optional StateObjectReference ReplacedItem, optional XComGameState NewCheckGameState)
{
	local int DefenseBonus;
	local XComGameStateHistory History;
	local X2EquipmentTemplate EquipmentTemplate;
	local XComGameState_Item TmpItem;

	History = `XCOMHISTORY;
	CheckGameState = NewCheckGameState;

	if (Unit == None)
	{
		if (CheckGameState != None) Unit = XComGameState_Unit(CheckGameState.GetGameStateForObjectID(UnitRef.ObjectID));
		else Unit = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
	}

	Defense = string(int(Unit.GetCurrentStat(eStat_Defense)) + Unit.GetUIStatFromAbilities(eStat_Defense));
	DefenseBonus = Unit.GetUIStatFromInventory(eStat_Defense, CheckGameState);

	if (NewItem.ObjectID > 0)
	{
		if (CheckGameState != None) TmpItem = XComGameState_Item(CheckGameState.GetGameStateForObjectID(NewItem.ObjectID));
		else TmpItem = XComGameState_Item(History.GetGameStateForObjectID(NewItem.ObjectID));
		EquipmentTemplate = X2EquipmentTemplate(TmpItem.GetMyTemplate());

		if (EquipmentTemplate != None && EquipmentExcludedFromStatBoosts.Find(EquipmentTemplate.DataName) == INDEX_NONE)
		{
			DefenseBonus += EquipmentTemplate.GetUIStatMarkup(eStat_Defense, TmpItem);
		}
	}

	if (ReplacedItem.ObjectID > 0)
	{
		if (CheckGameState != None) TmpItem = XComGameState_Item(CheckGameState.GetGameStateForObjectID(ReplacedItem.ObjectID));
		else TmpItem = XComGameState_Item(History.GetGameStateForObjectID(ReplacedItem.ObjectID));
		EquipmentTemplate = X2EquipmentTemplate(TmpItem.GetMyTemplate());
		
		if (EquipmentTemplate != none && EquipmentExcludedFromStatBoosts.Find(EquipmentTemplate.DataName) == INDEX_NONE)
		{
			DefenseBonus -= EquipmentTemplate.GetUIStatMarkup(eStat_Defense, TmpItem);
		}
	}

	if (DefenseBonus > 0) Defense $= class'UIUtilities_Text'.static.GetColoredText("+" $ DefenseBonus, eUIState_Good);
	else if (DefenseBonus < 0) Defense $= class'UIUtilities_Text'.static.GetColoredText("" $ DefenseBonus, eUIState_Bad);

	super.PopulateData(Unit, NewItem, ReplacedItem, NewCheckGameState);
}

public function SetSoldierStats(optional string Health	 = "", 
								optional string Mobility = "", 
								optional string Aim	     = "", 
								optional string Will     = "", 
								optional string Armor	 = "", 
								optional string Dodge	 = "", 
								optional string Tech	 = "", 
								optional string Psi		 = "" )
{
	//Stats will stack to the right, and clear out any unused stats 

	mc.BeginFunctionOp("SetSoldierStats");
	
	if( Health != "" )
	{
		mc.QueueString(m_strHealthLabel);
		mc.QueueString(Health);
	}
	if( Mobility != "" )
	{
		mc.QueueString(m_strMobilityLabel);
		mc.QueueString(Mobility);
	}
	if( Aim != "" )
	{
		mc.QueueString(m_strAimLabel);
		mc.QueueString(Aim);
	}
	if( Defense != "" )
	{
		mc.QueueString(class'XLocalizedData'.default.DefenseLabel);
		mc.QueueString(Defense);
	}
	if( Armor != "" )
	{
		mc.QueueString(m_strArmorLabel);
		mc.QueueString(Armor);
	}
	if( Dodge != "" )
	{
		mc.QueueString(m_strDodgeLabel);
		mc.QueueString(Dodge);
	}
	if( Psi != "" )
	{
		mc.QueueString( class'UIUtilities_Text'.static.GetColoredText(m_strPsiLabel, eUIState_Psyonic) );
		mc.QueueString( class'UIUtilities_Text'.static.GetColoredText(Psi, eUIState_Psyonic) );
	}
	else if( Tech != "" )
	{
		mc.QueueString(m_strTechLabel);
		mc.QueueString(Tech);
	}
	if( Will != "" )
	{
		mc.QueueString(m_strWillLabel);
		mc.QueueString(Will);
	}

	mc.EndOp();
}
