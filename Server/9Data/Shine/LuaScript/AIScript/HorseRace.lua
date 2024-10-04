--[[
	경마장 샘플
	우선은 WOOD8을 마스터로

	Horse가 출발선으로 점프하는 이유 : 	녹스에게 공격받은 후 일정시간이 지나 전투모드가 풀릴 때 현재 블럭 안에 갖혀있으면 리젠위치로 오게 됨
										ShineObjectClass::ShineMobileObject::smo_LoginAfterLogout(const ShineXYType *newloc)
										플레이어가 움직일때 모서리에 걸리는 현상 때문에 블럭체크는 공포상태일 때만 함
]]

-- 스크립트의 리턴값
ReturnAI = {}
ReturnAI.END = 1    -- Return_AI_END = 1;//    -- 모든 AI루틴 끝
ReturnAI.CPP = 2    -- Return_AI_CPP = 2;//    -- 루아로 일부 처리한 후 cpp의 AI루틴 돌림


MasterID = cMobIDFind("WOOD8")


LastRank = {}	-- 결과저장

Course = {}
Course.Dir    = 270
Course.Start  = 16000
Course.Top    = 14065
Course.Left   = 14185
Course.Right  = 17580
Course.Bottom = 12750
for k = 1, 6 do		-- 코스 갯수
	Course[k] = {}
	Course[k][1] = {X = Course.Start,                Y = Course.Top + 50 * (k - 1)}
	Course[k][2] = {X = Course.Left + 50 * (k - 1),  Y = Course.Top + 50 * (k - 1)}
	Course[k][3] = {X = Course.Left + 50 * (k - 1),  Y = Course.Bottom - 50 * (k - 1)}
	Course[k][4] = {X = Course.Right - 50 * (k - 1), Y = Course.Bottom - 50 * (k - 1)}
	Course[k][5] = {X = Course.Right - 50 * (k - 1), Y = Course.Top + 50 * (k - 1)}
	Course[k][6] = {X = Course.Start,                Y = Course.Top + 50 * (k - 1)}
end

BoothIndex = "RouItemMctPey"
BoothID = cMobIDFind(BoothIndex)
BoothLoc = {}
BoothLoc.Dir = 0
BoothLoc[1] = {X = Course.Start,       Y = Course.Top - 100}
BoothLoc[2] = {X = Course.Start + 100, Y = Course.Top - 100}
BoothLoc[3] = {X = Course.Start + 200, Y = Course.Top - 100}
BoothLoc[4] = {X = Course.Start + 300, Y = Course.Top - 100}
BoothLoc[5] = {X = Course.Start + 400, Y = Course.Top - 100}
BoothLoc[6] = {X = Course.Start + 500, Y = Course.Top - 100}


-- 전체 말들(나중에 테이블에서 읽기)
HorseList =
{
	{
		Mob = "SpeedySlime",
		SkillIndex = "",
		SkillRate = 0,
		SkillWait = 0,
		RunRate = {1200, 1100, 1000,  900,  800},
	},
	{
		Mob = "MushRoom",
		SkillIndex = "",
		SkillRate = 0,
		SkillWait = 0,
		RunRate = {1200, 1100, 1000,  900,  800},
	},
	{
		Mob = "Imp",
		SkillIndex = "",
		SkillRate = 0,
		SkillWait = 0,
		RunRate = {1200, 1100, 1000,  900,  800},
	},
	{
		Mob = "Goblin",
		SkillIndex = "",
		SkillRate = 0,
		SkillWait = 0,
		RunRate = {1000, 1000, 1000, 1000, 1000},
	},
	{
		Mob = "GobleKing",
		SkillIndex = "",
		SkillRate = 0,
		SkillWait = 0,
		RunRate = {1000, 1000, 1000, 1000, 1000},
	},
	{
		Mob = "KQ_FireViVi",
		SkillIndex = "",
		SkillRate = 0,
		SkillWait = 0,
		RunRate = {1200, 1100, 1000,  900,  800},
	},
	{
		Mob = "KQ_IceViVi",
		SkillIndex = "",
		SkillRate = 0,
		SkillWait = 0,
		RunRate = {1200, 1100, 1000,  900,  800},
	},
	{
		Mob = "GoblinSwordman",
		SkillIndex = "",
		SkillRate = 0,
		SkillWait = 0,
		RunRate = {1000, 1000, 1000, 1000, 1000},
	},
	{
		Mob = "GoblinMage",
		SkillIndex = "",
		SkillRate = 0,
		SkillWait = 0,
		RunRate = {1000, 1000, 1000, 1000, 1000},
	},
	{
		Mob = "Boogy",
		SkillIndex = "",
		SkillRate = 0,
		SkillWait = 0,
		RunRate = { 900,  950, 1000, 1200, 1500},
	},
	{
		Mob = "Crab",
		SkillIndex = "",
		SkillRate = 0,
		SkillWait = 0,
		RunRate = { 900,  950, 1000, 1200, 1500},
	},
	{
		Mob = "Honeying",
		SkillIndex = "",
		SkillRate = 0,
		SkillWait = 0,
		RunRate = {1200, 1100, 1000,  900,  800},
	},
	{
		Mob = "HungryWolf",
		SkillIndex = "",
		SkillRate = 0,
		SkillWait = 0,
		RunRate = { 900,  950, 1000, 1200, 1500},
	},
	{
		Mob = "Boar",
		SkillIndex = "",
		SkillRate = 0,
		SkillWait = 0,
		RunRate = { 900,  950, 1000, 1200, 1500},
	},
	{
		Mob = "MiniPinky",
		SkillIndex = "",
		SkillRate = 0,
		SkillWait = 0,
		RunRate = {1000, 1000, 1000, 1000, 1000},
	},
	{
		Mob = "Kebing",
		SkillIndex = "",
		SkillRate = 0,
		SkillWait = 0,
		RunRate = {1200, 1100, 1000,  900,  800},
	},
	{
		Mob = "Fox",
		SkillIndex = "",
		SkillRate = 0,
		SkillWait = 0,
		RunRate = { 900,  950, 1000, 1200, 1500},
	},
	{
		Mob = "Bat",
		SkillIndex = "",
		SkillRate = 0,
		SkillWait = 0,
		RunRate = { 900,  950, 1000, 1200, 1500},
	},
	{
		Mob = "Nox",
		SkillIndex = "NoxAtkSkill1",
		SkillRate = 250,	-- 25%
		SkillWait = 1,
		RunRate = {1000, 1000, 1000, 1000, 1000},
	},
}

MemBlock = {}

RaceActivFlag = 0

function RaceActiv(act)
cExecCheck "RaceActiv"
	RaceActivFlag = tonumber(act)
end

function Dummy()
end

------------------------------------------------------------------------

function WOOD8(Handle, MapIndex)
cExecCheck "WOOD8"
	local Var = MemBlock[Handle]
	if Var == nil then
		MemBlock[Handle] = {}
		Var = MemBlock[Handle]
		Var.Handle = Handle
		Var.MapIndex = MapIndex
		Var.StepFunc = Master_Inactiv
		Var.BoothInfo = {}

		-- 부스만들기
		for b = 1, #Course do
			local BoothHandle = cMobRegen_XY(Var.MapIndex, BoothIndex, BoothLoc[b].X, BoothLoc[b].Y, BoothLoc.Dir)
			cAIScriptSet(BoothHandle, Var.Handle) -- 부스의 AI스크립트를 마스터의 AI스크립트로 세팅
			cAIScriptFunc(BoothHandle, "NPCClick", "Booth_Click")
			MemBlock[BoothHandle] = {}
			local BoothInfo = MemBlock[BoothHandle]
			BoothInfo.Handle = BoothHandle
			BoothInfo.Course = b
			BoothInfo.StepFunc = Dummy
			BoothInfo.ClickFunc = Dummy

			BoothInfo.Master = Var
			Var.BoothInfo[b] = BoothInfo
		end
	end

	Var.StepFunc(Var)

	return ReturnAI.END
end

function Master_Inactiv(Var)
cExecCheck "Master_Inactiv"
	if RaceActivFlag ~= 0 then
		Var.StepFunc = Master_HorseEntry
	end
end

function Master_HorseEntry(Var)
cExecCheck "Master_HorseEntry"
	Var.Horse = {}
	-- 경주마 선정
	for c = 1, #Course do
		local order = Master_HorseSelect(Var)
		Var.Horse[c] = {}
		Var.Horse[c].OrderInHorseList = order	-- HorseList에서의 위치
	end

	for c = 1, #Course do
		cDebugLog("" .. c .. " " .. Var.Horse[c].OrderInHorseList .. " " .. HorseList[Var.Horse[c].OrderInHorseList].Mob)
		local HorseHandle = cMobRegen_XY(Var.MapIndex, HorseList[Var.Horse[c].OrderInHorseList].Mob, Course[c][1].X, Course[c][1].Y, Course.Dir)
		cAIScriptSet(HorseHandle, Var.Handle) -- 경주마의 AI스크립트를 마스터의 AI스크립트로 세팅
		cAIScriptFunc(HorseHandle, "Entrance", "Horse_Main") --입구함수는 HorseMain
		Var.Horse[c].Handle = HorseHandle
		Var.Horse[c].Course = c
		Var.Horse[c].Master = Var
		Var.Horse[c].StepFunc = Dummy

		Var.BoothInfo[c].StepFunc = Booth_IntroduceStart
		Var.BoothInfo[c].ClickFunc = Booth_Click_Menu

		MemBlock[HorseHandle] = Var.Horse[c]
	end
	Var.Wait = {}
	Var.Wait.Second = cCurSec() + 60--0--3
	Var.StepFunc = Master_WaitStart
end

function Master_WaitStart(Var)		-- 경주가 끝날 때까지 기다림
cExecCheck "Master_WaitStart"
	-- 방송
	if cCurSec() > Var.Wait.Second then
		for c = 1, #Course do
			Var.Horse[c].StepFunc = Horse_Interval
			Var.Horse[c].Interval = 2

			Var.BoothInfo[c].StepFunc = Booth_InRace
			Var.BoothInfo[c].ClickFunc = Booth_Click_InRace
		end

		LastRank = {}
		Var.StepFunc = Master_WaitEnd
	end
end

function Master_WaitEnd(Var)	-- 경주 후 배당금 나눠주는 시간
cExecCheck "Master_WaitEnd"
	if #LastRank == #Course then
		for k = 1, #LastRank do
			cDebugLog("Rank " .. k .. " : " .. LastRank[k])
		end

		for c = 1, #Course do
			Var.BoothInfo[c].StepFunc = Booth_PrizeDistribute
			Var.BoothInfo[c].ClickFunc = Booth_Click_PrizeDistribute
		end

		Var.Wait = {}
		Var.Wait.Second = cCurSec() + 60----3
		Var.StepFunc = Master_WaitRaceTerminate
	end
end

function Master_WaitRaceTerminate(Var)	-- 이때 말들 로그아웃
cExecCheck "Master_WaitRaceTerminate"
	if cCurSec() > Var.Wait.Second then
		for k = 1, #Var.Horse do
			cNPCVanish(Var.Horse[k].Handle)
			cDebugLog("Vanish " .. Var.Horse[k].Handle)
			MemBlock[Var.Horse[k].Handle] = nil
		end

		for c = 1, #Course do
			Var.BoothInfo[c].StepFunc = Dummy
			Var.BoothInfo[c].ClickFunc = Dummy
		end

		Var.Wait = {}
		Var.Wait.Second = cCurSec() + 10
		Var.StepFunc = Master_WaitNextRace
	end
end

function Master_WaitNextRace(Var)		-- 다음경기 시작(운영자가 deactive시켰으면 대기)
cExecCheck "Master_WaitNextRace"
	if cCurSec() > Var.Wait.Second then
		Var.StepFunc = RaceActivFlag == 0 and Master_Inactiv or Master_HorseEntry
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function Master_HorseSelect(Var)
cExecCheck  "Master_HorseSelect"
	local order = cRandomInt(1, #HorseList)
	for k = 1, #Var.Horse do
		if Var.Horse[k].OrderInHorseList == order then
			return Master_HorseSelect(Var)
		end
	end

	return order
end

--------------------------------------------------------

function Horse_Main(Handle, MapIndex)
cExecCheck "Horse_Main"
	local Var = MemBlock[Handle]
	Var.StepFunc(Var)
	return ReturnAI.END
end

function Horse_SkillUse(Var)
cExecCheck "Horse_SkillUse"

	--cDebugLog("SkillUse " .. HorseList[Var.OrderInHorseList].Mob .. " in course " .. Var.Course)

	local targetcourse = Horse_SelectTarget(Var.Course)	-- 대상찾기
	local MasterInfo = Var.Master
	local targetinfo = MasterInfo.Horse[targetcourse]

	--cDebugLog("    Target " .. HorseList[targetinfo.OrderInHorseList].Mob .. " in course " .. targetinfo.Course)

	if cSkillBlast(Var.Handle, targetinfo.Handle, HorseList[Var.OrderInHorseList].SkillIndex) == nil then  -- 실패
		Var.StepFunc = Horse_Interval
		return
	end

	Var.Wait = {}
	Var.Wait.Second = cCurSec() + HorseList[Var.OrderInHorseList].SkillWait
	Var.StepFunc = Horse_WaitSkill
end

function Horse_Interval(Var)
cExecCheck "Horse_Interval"
	--cDebugLog("Horse_Interval " .. Var.Handle)

	local interval = cRandomInt(10, 25) * 20	-- 200~500
	local intervalsquar = interval * interval
	local cur = {}
	cur.X, cur.Y = cObjectLocate(Var.Handle)
	local goal = {}
	goal.X = Course[Var.Course][Var.Interval].X
	goal.Y = Course[Var.Course][Var.Interval].Y
	local RunRate = HorseList[Var.OrderInHorseList].RunRate[Var.Interval - 1]

	-- 거리가 interval 이하가 될 때까지 중점 찾기
	while true do
		local dx = goal.X - cur.X
		local dy = goal.Y - cur.Y
		local distsquar = dx * dx + dy * dy
		if distsquar < 100 then  -- 목적지에서 10grid 이하(루아에서는 double연산을 하므로 int인 cObjectLocate()의 리턴값과 어긋남)
			if Var.Interval >= #Course[Var.Course] then
				--cDebugLog("Goal " .. Var.Handle)
				LastRank[#LastRank + 1] = HorseList[Var.OrderInHorseList].Mob
				Var.StepFunc = Dummy
			else
				Var.Interval = Var.Interval + 1
			end
			return
		end
		if distsquar < intervalsquar then
			break
		end
		goal = Horse_CenterFunc(cur, goal)
	end

	-- goal까지 이동 예약
	--cDebugLog("MoveReserv " .. Var.Handle .. " " .. goal.X .. " " .. goal.Y .. "(" .. interval .. ")")
	cRunTo(Var.Handle, goal.X, goal.Y, RunRate)

	Var.IntervalGoal = goal
	Var.StepFunc = Horse_Step
end

function Horse_Step(Var)
cExecCheck "Horse_Step"

	if cIsMovable(Var.Handle) == nil then	-- 움직일 수 없는 상태
		--cDebugLog("Step Not movable " .. Var.Handle)
		Var.StepFunc = Horse_WaitCanMove
		return
	end

	local cur = {}
	cur.X, cur.Y = cObjectLocate(Var.Handle)

	local goal = Var.IntervalGoal
	local dx = goal.X - cur.X
	local dy = goal.Y - cur.Y
	local distsquar = dx * dx + dy * dy

	if distsquar < 100 then  -- 목적지에서 10grid 이하(0으로 해도 되지만 정확히 맞지 않을 경우가 있을 것 같아서)
		Var.StepFunc = (cPermileRate(HorseList[Var.OrderInHorseList].SkillRate) ~= nil) and Horse_SkillUse or Horse_Interval
		-- cPermileRate(HorseList[Var.Course].SkillRate확률로 1 or nil                    ?                 :
	end
end

function Horse_WaitCanMove(Var)
cExecCheck "Horse_WaitCanMove"
	--cDebugLog("Horse_WaitCanMove " .. Var.Handle)
	if cIsMovable(Var.Handle) ~= nil then	-- 움직일 수 있는 상태
		--cDebugLog("Horse_WaitCanMove esc " .. Var.Handle)
		Var.StepFunc = Horse_Interval
	end
end

function Horse_WaitSkill(Var)
cExecCheck "Horse_WaitSkill"
	-- 방송
	if cCurSec() > Var.Wait.Second then
		Var.StepFunc = Horse_Interval
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function Horse_CenterFunc(a, b)
cExecCheck "Horse_CenterFunc"
	return {X = (a.X + b.X) / 2, Y = (a.Y + b.Y) / 2,}
end

function Horse_SelectTarget(mycourse)	-- 대상찾기
cExecCheck "Horse_SelectTarget"
	local rnd = cRandomInt(1, #Course)
	if rnd == mycourse then
		return Horse_SelectTarget(mycourse)
	end
	return rnd
end

--------------------------------------------------------

function RouItemMctPey(Handle, MapIndex)
cExecCheck "RouItemMctPey"
	local Var = MemBlock[Handle]
	Var.StepFunc(Var)
	return ReturnAI.END
end

function Booth_Wait(Var)
cExecCheck "Booth_WaitIntroduce"
	if cCurSec() > Var.Wait.Second then
		Var.StepFunc = Var.Wait.Func
	end
end

function Booth_IntroduceStart(Var)
cExecCheck "Booth_IntroduceStart"
cDebugLog "Booth_IntroduceStart"
	Var.BetInfo = {}	-- 플레이어들이 돈을 건 정보
	Var.BetInfo.Summary = 0

	Var.StepFunc = Booth_Introduce
end

function Booth_Introduce(Var)
cExecCheck "Booth_Introduce"
	local MasterInfo = Var.Master
	local HorseInfo = MasterInfo.Horse[Var.Course]
	cNPCChatTest(Var.Handle, "" .. Var.Course .. "번코스 " .. HorseList[HorseInfo.OrderInHorseList].Mob)

	Var.Wait = {}
	Var.Wait.Second = cCurSec() + 5
	Var.Wait.Func = Booth_NoticeBetInfo
	Var.StepFunc = Booth_Wait
end

function Booth_NoticeBetInfo(Var)
cExecCheck "Booth_NoticeBetInfo"
	local MasterInfo = Var.Master
	local HorseInfo = MasterInfo.Horse[Var.Course]
	if Var.BetInfo.Summary == 0 then
		cNPCChatTest(Var.Handle, HorseList[HorseInfo.OrderInHorseList].Mob .. "에는 배팅이 아직 없습니다")
	else
		cNPCChatTest(Var.Handle, HorseList[HorseInfo.OrderInHorseList].Mob .. "의 총 배팅은 " .. Var.BetInfo.Summary .. "실버입니다")
	end

	Var.Wait = {}
	Var.Wait.Second = cCurSec() + 5
	Var.Wait.Func = Booth_WinRate
	Var.StepFunc = Booth_Wait
end

function Booth_WinRate(Var)
cExecCheck "Booth_WinRate"
	local MasterInfo = Var.Master
	local HorseInfo = MasterInfo.Horse[Var.Course]

	local total = 0
	for k = 1, #Course do
		total = total + MasterInfo.BoothInfo[k].BetInfo.Summary
	end

	if Var.BetInfo.Summary == 0 then
		cNPCChatTest(Var.Handle, HorseList[HorseInfo.OrderInHorseList].Mob .. "에는 배당이 없습니다")
	else
		cNPCChatTest(Var.Handle, HorseList[HorseInfo.OrderInHorseList].Mob .. "의 배당률은 " .. total / Var.BetInfo.Summary .. "입니다")
	end

	Var.Wait = {}
	Var.Wait.Second = cCurSec() + 5
	Var.Wait.Func = Booth_Introduce
	Var.StepFunc = Booth_Wait
end

function Booth_InRace(Var)
cExecCheck "Booth_InRace"
	if #LastRank == 0 then
		return
	end

	local MasterInfo = Var.Master
	local HorseInfo = MasterInfo.Horse[Var.Course]
	if LastRank[#LastRank] == HorseList[HorseInfo.OrderInHorseList].Mob then
		cNPCChatTest(Var.Handle, HorseList[HorseInfo.OrderInHorseList].Mob .. " " .. #LastRank .. "등입니다")
	end
end

function Booth_PrizeDistribute(Var)
cExecCheck "Booth_PrizeDistribute"

	local MasterInfo = Var.Master
	local HorseInfo = MasterInfo.Horse[Var.Course]
	if LastRank[1] ~= HorseList[HorseInfo.OrderInHorseList].Mob then
		Var.StepFunc = Dummy
		return
	end

	cNPCChatTest(Var.Handle, HorseList[HorseInfo.OrderInHorseList].Mob .. " 승리입니다. 배당을 받아가세요")

	Var.Wait = {}
	Var.Wait.Second = cCurSec() + 5
	Var.Wait.Func = Booth_PrizeDistribute
	Var.StepFunc = Booth_Wait
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function Booth_Click(NPCHandle, PlyHandle, RegistNumber)
cExecCheck "Booth_Click"
	local Var = MemBlock[NPCHandle]
	if Var == nil then
		cDebugLog("Booth_Click : nil NPC " .. NPCHandle)
		return 0
	end

	Var.ClickFunc(Var, PlyHandle, RegistNumber)

	cDebugLog("Clicked " .. NPCHandle .. " by " .. cGetPlayerName(PlyHandle) .. '[' .. PlyHandle .. ']')
end

function Booth_Click_Menu(Var, PlyHandle, RegistNumber)
cExecCheck "Booth_Click_Menu"


	cServerMenu(PlyHandle, Var.Handle, "베팅",
	                                   "베팅하기",      "Booth_Betting",
									   "내 베팅 보기",  "Booth_MyBetting",
									   "취소",          "Dummy")
end

function Booth_Click_InRace(Var, PlyHandle, RegistNumber)
cExecCheck "Booth_Click_InRace"

	cNPCChatTest(Var.Handle, "경주가 시작되어 베팅할 수 없습니다", PlyHandle)
end

function Booth_Click_PrizeDistribute(Var, PlyHandle, RegistNumber)
cExecCheck "Booth_Click_PrizeDistribute"
	local MasterInfo = Var.Master
	local HorseInfo = MasterInfo.Horse[Var.Course]
	if LastRank[1] ~= HorseList[HorseInfo.OrderInHorseList].Mob then
		cNPCChatTest(Var.Handle, "아쉽게 패배했습니다. 다음 기회를 이용해 주세요", PlyHandle)
		return
	end

	if Var.BetInfo[RegistNumber] == nil then
		cNPCChatTest(Var.Handle, cGetPlayerName(PlyHandle) .. "님은 " .. LastRank[1] .. "에게 베팅하지 않았습니다", PlyHandle)
		return
	end

	if Var.BetInfo[RegistNumber] == 0 then
		cNPCChatTest(Var.Handle, cGetPlayerName(PlyHandle) .. "님은 배당금을 이미 받아가셨습니다", PlyHandle)
		return
	end

	cNPCChatTest(Var.Handle, cGetPlayerName(PlyHandle) .. "님의 배당금은 " .. Var.BetInfo[RegistNumber] .. "실버입니다", PlyHandle)
	Var.BetInfo[RegistNumber] = 0
end

function Booth_Betting(NPCHandle, PlyHandle, RegistNumber)
cExecCheck "Booth_Betting"
	local Var = MemBlock[NPCHandle]
	if Var == nil then
		cDebugLog("Booth_Betting : nil NPC " .. NPCHandle)
		return 0
	end

	local MasterInfo = Var.Master
	local HorseInfo = MasterInfo.Horse[Var.Course]


	if Var.BetInfo[RegistNumber] == nil then
		Var.BetInfo[RegistNumber] = 0
	end
	Var.BetInfo[RegistNumber] = Var.BetInfo[RegistNumber] + 1	-- 1실버
	Var.BetInfo.Summary = Var.BetInfo.Summary + 1

	cNPCChatTest(Var.Handle, HorseList[HorseInfo.OrderInHorseList].Mob .. "에게 " .. Var.BetInfo[RegistNumber] .. " 실버 베팅", PlyHandle)
end

function Booth_MyBetting(NPCHandle, PlyHandle, RegistNumber)
cExecCheck "Booth_MyBetting"
	local Var = MemBlock[NPCHandle]
	if Var == nil then
		cDebugLog("Booth_Betting : nil NPC " .. NPCHandle)
		return 0
	end

	local MasterInfo = Var.Master
	local HorseInfo = MasterInfo.Horse[Var.Course]

	local Bet = false
	local Result = ""
	for k = 1, #MasterInfo.BoothInfo do
		local Booth = MasterInfo.BoothInfo[k]
		local HorseInfo = MasterInfo.Horse[Booth.Course]
		if Booth.BetInfo[RegistNumber] ~= nil then
			Result = Result .. '[' .. HorseList[HorseInfo.OrderInHorseList].Mob .. ":" .. Booth.BetInfo[RegistNumber] .. "]"
			Bet = true
		end
	end

	if Bet then
		cNPCChatTest(Var.Handle, Result, PlyHandle)
	else
		cNPCChatTest(Var.Handle, "베팅기록이 없습니다.", PlyHandle)
	end
end
