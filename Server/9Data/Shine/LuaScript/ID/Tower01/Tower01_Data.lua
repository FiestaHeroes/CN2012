SCRIPT_MAIN = "ID/Tower01/Tower01"


ROUTINE_CHECK_DELAY			= 1
ROUTINE_CHECK_DELAY_INIT 	= 2


-- [ 類滌 等檜攪 ]
FloorDataTable =
{
	-- [ 1類 ] : 煎綠
	{
		Dialog	=
		{
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat0101",	Delay = 8 },
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat0102",	Delay = 2 },
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat0103",	Delay = 2 },
		},
	},

	-- [ 2類 ]
	{
		Door		= { InxName = "T_Gate",	BlockInx = "DOOR00",	x = 1184,	y = 3723,	Dir = 0,	Scale = 1000 },
		RegenGroup	= { "201", "202" },
		Dialog		=
		{
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat0201",	Delay = 0 },
		},
	},

	-- [ 3類 ]
	{
		Door		= { InxName = "T_Gate",	BlockInx = "DOOR01",	x = 2732,	y = 1863,	Dir = 0,	Scale = 1000 },
		RegenGroup	= { "301", "302" },
		Dialog		=
		{
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat0301",	Delay = 0 },
		},
	},

	-- [ 4類 ]
	{
		Door		= { InxName = "T_Gate",	BlockInx = "DOOR02",	x = 5069,	y = 1058,	Dir = 0,	Scale = 1000 },
		RegenGroup	= { "401", "402" },
		Dialog		=
		{
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat0401",	Delay = 0 },
		},
	},

	-- [ 5類 ] : 爾蝶 [ T_DustGolem ]
	{
		Door		= { InxName = "T_Gate",	BlockInx = "DOOR03",	x = 7556,	y = 937,	Dir = 0,	Scale = 1000 },
		RegenGroup	= { "501", "502" },
		Boss		= { InxName = "T_DustGolem",	x = 6900,	y = 963,	Dir = 0 },
		BossSummon	=
		{
			{	-- Check Step 1
				HPPercent	= 800,	-- 80 %
				MonsterData	=
				{
					{ InxName = "T_Imp",		Number = 2 },
					{ InxName = "T_GangImp",	Number = 2 },
				},
				Dialog = { Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat0501Boss" },
			},
			{	-- Check Step 2
				HPPercent = 200,	-- 20 %
				MonsterData	=
				{
					{ InxName = "T_HungryWolf",	Number = 1 },
					{ InxName = "Sum_T_Ratman",	Number = 1 },
				},
				Dialog = { Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat0502Boss" },
			},
		},
		Dialog		=
		{
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat0501",	Delay = 0 },
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat0502",	Delay = 2 },
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat0503",	Delay = 2 },
		},
	},

	-- [ 6類 ]
	{
		Door		= { InxName = "T_Gate",	BlockInx = "DOOR04",	x = 10035,	y = 951,	Dir = 0,	Scale = 1000 },
		RegenGroup	= { "601" },
		Dialog		=
		{
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat0601",	Delay = 0 },
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat0602",	Delay = 2 },
		},
	},

	-- [ 7類 ]
	{
		Door		= { InxName = "T_Gate",	BlockInx = "DOOR05",	x = 10241,	y = 3883,	Dir = 0,	Scale = 1000 },
		RegenGroup	= { "701" },
		Dialog		=
		{
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat0701",	Delay = 0 },
		},
	},

	-- [ 8類 ]
	{
		Door		= { InxName = "T_Gate",	BlockInx = "DOOR06",	x = 11531,	y = 5975,	Dir = 0,	Scale = 1000 },
		RegenGroup	= { "801", "802" },
		Dialog		=
		{
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat0801",	Delay = 0 },
		},
	},

	-- [ 9類 ]
	{
		Door		= { InxName = "T_Gate",	BlockInx = "DOOR07",	x = 11727,	y = 8426,	Dir = 0,	Scale = 1000 },
		RegenGroup	= { "901", "902", "903", "904", "905", "906" },
		Dialog		=
		{
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat0901",	Delay = 0 },
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat0902",	Delay = 2 },
		},
	},

	-- [ 10類 ] : 爾蝶 [ T_StoneGolem ]
	{
		Door		= { InxName = "T_Gate",	BlockInx = "DOOR08",	x = 10190,	y = 10335,	Dir = 0,	Scale = 1000 },
		RegenGroup	= { "1001", "1002" },
		Boss		= { InxName = "T_StoneGolem",	x = 10709,	y = 9808,	Dir = 0 },
		BossSummon	=
		{
			{	-- Check Step 1
				HPPercent	= 700,	-- 80 %
				MonsterData	=
				{
					{ InxName = "T_SkelArcher01",		Number = 2 },
				},
				Dialog = { Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat1001Boss" },
			},
			{	-- Check Step 2
				HPPercent = 200,	-- 20 %
				MonsterData	=
				{
					{ InxName = "T_SkelWarrior",	Number = 2 },
					{ InxName = "T_SkelArcher02",	Number = 1 },
				},
				Dialog = { Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat1002Boss" },
			},
		},
		Dialog		=
		{
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat1001",	Delay = 0 },
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat1002",	Delay = 2 },
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat1003",	Delay = 2 },
		},
	},

	-- [ 11類 ]
	{
		Door		= { InxName = "T_Gate",	BlockInx = "DOOR09",	x = 8139,	y = 11611,	Dir = 0,	Scale = 1000 },
		RegenGroup	= { "1101", "1102" },
		Dialog		=
		{
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat1101",	Delay = 0 },
		},
	},

	-- [ 12類 ]
	{
		Door		= { InxName = "T_Gate",	BlockInx = "DOOR10",	x = 5701,	y = 11825,	Dir = 0,	Scale = 1000 },
		RegenGroup	= { "1201", "1202" },
		Dialog		=
		{
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat1201",	Delay = 0 },
		},
	},

	-- [ 13類 ]
	{
		Door		= { InxName = "T_Gate",	BlockInx = "DOOR11",	x = 3564,	y = 10499,	Dir = 0,	Scale = 1000 },
		RegenGroup	= { "1301" },
		Dialog		=
		{
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat1301",	Delay = 0 },
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat1302",	Delay = 2 },
		},
	},

	-- [ 14類 ] : 爾蝶 [ T_PoisonGolem ]
	{
		Door		= { InxName = "T_Gate",	BlockInx = "DOOR12",	x = 3278,	y = 8097,	Dir = 0,	Scale = 1000 },
		RegenGroup	= { "1401", "1402" },
		Boss		= { InxName = "T_PoisonGolem",	x = 3262,	y = 8795,	Dir = 0 },
		BossSummon	=
		{
			{	-- Check Step 1
				HPPercent	= 700,	-- 80 %
				MonsterData	=
				{
					{ InxName = "T_OldFox",		Number = 2 },
					{ InxName = "T_DesertWolf",	Number = 2 },
				},
				Dialog = { Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat1401Boss" },
			},
			{	-- Check Step 2
				HPPercent = 200,	-- 20 %
				MonsterData	=
				{
					{ InxName = "T_Ghost",		Number = 2 },
					{ InxName = "T_IceViVi",	Number = 2 },
				},
				Dialog = { Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat1402Boss" },
			},
		},
		Dialog		=
		{
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat1401",	Delay = 0 },
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat1402",	Delay = 2 },
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat1403",	Delay = 2 },
		},
	},

	-- [ 15類 ]
	{
		Door		= { InxName = "T_Gate",	BlockInx = "DOOR13",	x = 3276,	y = 5629,	Dir = 0,	Scale = 1000 },
		RegenGroup	= { "1501", "1502" },
		Dialog		=
		{
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat1501",	Delay = 0 },
		},
	},

	-- [ 16類 ]
	{
		Door		= { InxName = "T_Gate",	BlockInx = "DOOR14",	x = 5394,	y = 4529,	Dir = 0,	Scale = 1000 },
		RegenGroup	= { "1601" },
		Dialog		=
		{
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat1601",	Delay = 0 },
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat1602",	Delay = 2 },
		},
	},

	-- [ 17類 ]
	{
		Door		= { InxName = "T_Gate",	BlockInx = "DOOR15",	x = 7902,	y = 4434,	Dir = 0,	Scale = 1000 },
		RegenGroup	= { "1701" },
		Dialog		=
		{
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat1701",	Delay = 0 },
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat1702",	Delay = 2 },
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat1703",	Delay = 2 },
		},
	},

	-- [ 18類 ]
	{
		Door		= { InxName = "T_Gate",	BlockInx = "DOOR16",	x = 8976,	y = 6493,	Dir = 0,	Scale = 1000 },
		RegenGroup	= { "1801" },
		Dialog		=
		{
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat1801",	Delay = 0 },
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat1802",	Delay = 2 },
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat1803",	Delay = 2 },
		},
	},

	-- [ 19類 ]
	{
		Door		= { InxName = "T_Gate",	BlockInx = "DOOR17",	x = 7003,	y = 7615,	Dir = 0,	Scale = 1000 },
		RegenGroup	= { "1901" },
	},

	-- [ 20類 ] : 爾蝶 [ T_IronGolem ]
	{
		RegenGroup	= { "2001", "2002", "2003" },
		Boss		= { InxName = "T_IronGolem",	x = 4950,	y = 7606,	Dir = 0 },
		BossSummon	=
		{
			{	-- Check Step 1
				HPPercent	= 700,	-- 80 %
				MonsterData	=
				{
					{ InxName = "T_Prock",		Number = 1 },
					{ InxName = "T_Spider00",	Number = 4 },
				},
				Dialog = { Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat2001Boss" },
			},
			{	-- Check Step 2
				HPPercent	= 500,	-- 80 %
				MonsterData	=
				{
					{ InxName = "T_KingCall",	Number = 2 },
				},
				Dialog = { Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat2002Boss" },
			},
			{	-- Check Step 3
				HPPercent = 200,	-- 20 %
				MonsterData	=
				{
					{ InxName = "T_FlyingStaff01",	Number = 2 },
					{ InxName = "T_IronSlime01",	Number = 2 },
				},
				Dialog = { Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat2003Boss" },
			},
		},
		Dialog		=
		{
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat2001",	Delay = 0 },
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat2002",	Delay = 2 },
			{ Facecut = "EldSpeGuard01",	FileName = "Tower01",	Index = "Chat2003",	Delay = 2 },
		},
	},
}

-- [ 啪檜お 等檜攪 ]
GateData =
{
	ReturnGate 	=
	{
		InxName = "T_Gate02",	x = 1179, 	y = 7721,	Dir = 0,
		LinkData = { Map = "RouVal01",	x = 4664,	y = 8416 },
	},

	CompleteGate 	=
	{
		InxName = "Gate_ID_Complete",	x = 4704, 	y = 7618,	Dir = 0,
		LinkData = { Map = "RouVal01",	x = 4664,	y = 8416 },
	},
}
