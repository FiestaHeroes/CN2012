--[[
보스 상위버전 - 후마르

9Data/Here/World/FineScript.txt 필요
9Data/Hero/Script/BH_Humar.txt 필요
]]

-- 스크립트의 리턴값
ReturnAI = {}
ReturnAI.END = 1    -- Return_AI_END = 1;//    -- 모든 AI루틴 끝
ReturnAI.CPP = 2    -- Return_AI_CPP = 2;//    -- 루아로 일부 처리한 후 cpp의 AI루틴 돌림


--BossIndex = "BH_Humar"
FellowIndex = {}
FellowIndex[1] = "BH_Looter"
FellowIndex[2] = "BH_Guardian"

HumarBuffSkill = "BH_Humar_Skill_N_APU"
HumarBuffAbState = "StaMobAPU01"
HumarBuffSec = 60

SummonSkillName = "BH_Humar_Skill_S"
SummonSkillCastSecond = 5

--어그로 제거시 부하 없애고 inactiv상태로
SummonRate = {}
SummonRate[1] = 750		-- 75%, 50%, 25%에서 한번씩 부하들 리젠
SummonRate[2] = 500
SummonRate[3] = 250
SummonRate[4] = 0		-- 마지막은 항상 0인것 추가 필요

MemBlock = {}

-- 부하들은 스크립트처리 안함 - CPP 루틴 사용

function BH_Humar(Handle, MapIndex)
cExecCheck "BH_Humar"
	local Var = MemBlock[Handle]
	if cIsObjectDead(Handle) ~= nil then
		if Var ~= nil then   -- 보스가 죽었음
			cDebugLog("Boss Dead")
			for k = 1, 2 do
				if Var.FellowHandle[k] ~= -1 then
					cNPCVanish(Var.FellowHandle[k])
					Var.FellowHandle[k] = -1
				end
			end
			MemBlock[Handle] = nil
		end
		return ReturnAI.END
	end


	if Var == nil then    -- 처음 리젠되었음
		MemBlock[Handle] = {}
		Var = MemBlock[Handle]

		Var.Handle = Handle
		Var.FellowHandle = {}
		Var.FellowHandle[1] = -1
		Var.FellowHandle[2] = -1

		Var.NextSummonIndex = 1

		Var.TargetLostSec = 0 	-- 타겟을 잃은 시간
		Var.NextBuff = 0		-- 다음번 버프받을 시간

		Var.Wait = {}
		Var.Wait.Second = 0;
		Var.Wait.NextFunc = nil

		Var.StepFunc = Boss_WaitInvader
	end

	return Var.StepFunc(Var)
end

function Boss_Wait(Var)  -- Var.Wait.Second까지 기다린 후 StepFunc을 WaitFunction으로 세팅
cExecCheck "Boss_Wait"
	if cCurSec() >= Var.Wait.Second then
		Var.StepFunc = Var.Wait.NextFunc
	end
end

function Boss_WaitInvader(Var)
cExecCheck "Boss_WaitInvader"
	local hp
	local maxhp
	hp, maxhp = cObjectHP(Var.Handle)
	if hp < maxhp then
		Var.NextBuff = cCurSec() + HumarBuffSec
		Var.StepFunc = Boss_SummonCheck
	end

	return ReturnAI.END
end

function Boss_BuffCheck(Var)
cExecCheck "Boss_BuffCheck"
	if cCurSec() >= Var.NextBuff then
		cDebugLog "Buffing"
		if cNPCSkillUse(Var.Handle, Var.Handle, HumarBuffSkill) ~= nil then
			Var.NextBuff = cCurSec() + HumarBuffSec
		else
			cDebugLog "Fail"
		end
	end

	Var.StepFunc = Boss_SummonCheck
end

function Boss_SummonCheck(Var)
cExecCheck "Boss_SummonCheck"
	local hp
	local maxhp
	hp, maxhp = cObjectHP(Var.Handle)
	if hp * 1000 < maxhp * SummonRate[Var.NextSummonIndex] and cNPCSkillUse(Var.Handle, Var.Handle, SummonSkillName) == 1 then
		Var.NextSummonIndex = Var.NextSummonIndex + 1

		Var.Wait.Second = cCurSec() + SummonSkillCastSecond
		Var.Wait.NextFunc = Boss_SummomFellow

		Var.StepFunc = Boss_Wait
		return
	end

	-- 부하들 죽었는지 확인
	for fel = 1, 2 do
		if Var.FellowHandle[fel] ~= -1 and cIsObjectDead(Var.FellowHandle[fel]) ~= nil then
			Var.FellowHandle[fel] = -1
		end
	end


	if cTargetHandle(Var.Handle) ~= nil then  -- 타겟 있음
		Var.TargetLostSec = cCurSec()
	elseif Var.TargetLostSec + 10 < cCurSec() then	-- 타겟 사라짐
		Var.StepFunc = Boss_WaitInvader

		cResetAbstate(Var.Handle, HumarBuffAbState)	-- 버프 해제

		-- Remove fallows
		for k = 1, 2 do
			if Var.FellowHandle[k] ~= -1 then
				cNPCVanish(Var.FellowHandle[k])
				Var.FellowHandle[k] = -1
			end
		end
	end

	Var.StepFunc = Boss_BuffCheck

	return ReturnAI.CPP
end

function Boss_SummomFellow(Var)
cExecCheck "Boss_SummomFellow"
	local summon = false
	for fel = 1, 2 do
		if Var.FellowHandle[fel] == -1 then
			Var.FellowHandle[fel] = cMobRegen_Obj(FellowIndex[fel], Var.Handle)
			summon = true
		end
	end
	if summon then
		cNPCChat(Var.Handle, "BH_Humar_Sum")
	end
	Var.StepFunc = Boss_SummonCheck
end
