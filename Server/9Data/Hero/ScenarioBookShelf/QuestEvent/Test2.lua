--[[
cDebugLog("nil")                                     출력
cPlayerExistNPC(HeroHandle, CenterNPCHandle, 500)                    HeroHandle인 사람이 게임에 있는가?
cMobRegen_Obj("MushRoom", CenterNPCHandle)                           CenterNPCHandle 위치에 슬라임 리젠
cNPCVanish(EnemyMobHandle)                                           NPC인 EnemyMobHandle을 없앰
cCurSec()                                                            현재 초(Tick / 10) 리턴
cGetNPCHandle("Rou", "E_PromMaster")                                 루멘맵에서 "E_PromMaster"인 몹을 찾아 핸들 리턴
cGetQuestHero_NPC(11234, CenterNPCHandle, 300)                       11234번 퀘스트를 가지고 있는 사람들 중 CenterNPCHandle에서 300그리드 내에 있는 사람
cNPCChat(EnemyMobHandle, towhom, "안녕")                             EnemyMobHandle이 "안녕"이란 채팅을 함
cGetPlayerName(HeroHandle)                                           HeroHandle의 캐릭터 ID 얻어옴
cAggroSet(EnemyMobHandle, HeroHandle)                                EnemyMobHandle가 HeroHandle를 공격하도록 만듦
cObjectDead(EnemyMobHandle)                                          EnemyMobHandle가 죽었으면 true, 안족었으면 false
cObjectHP(EnemyMobHandle)                                            EnemyMobHandle의 현재 HP 얻음
cSetAbstate(EnemyMobHandle, "StaImmortal", 1, 100)                   EnemyMobHandle에게 StaImmortal 걸어줌(강도 1, 지속시간 100초)
cDropItem("FKORDevilsS", EnemyMobHandle, HeroHandle, 1000000)        아이템 FKORDevilsS을 EnemyMobHandle의 발밑에 루팅권한 HeroHandle로 떨굼(확률 1백만분율)

cGetQuestHero_ItemUse(11234, "Eld", "BestLowHpPotion")               엘더린에서 BestLowHpPotion 사용한 사람 찾기
cObjectLocate(HeroHandle)                                            좌표리턴
cMobRegen_XY("Eld", "Slime", x, y + 50)                           x, y 위치에 슬라임 리젠
]]

-- 일정위치(NPC)에 다가가면 슬라임 리젠, 슬라임을 잡으면 머쉬룸 리젠, 머쉬룸 HP 반으로 깎으면 아이템 주고 사라짐

function QuestEventRoutine()
    if HeroHandle ~= nil then
        if not cPlayerExist(HeroHandle) then
            cDebugLog("Hero Out!!!!!!!!!!!!!!!!!!!!!!")
            if ElderineHandle ~= nil then
                cVanish(ElderineHandle)
            end
            if EnemyHandle ~= nil then
                cVanish(EnemyHandle)
            end
        end
    end
    StepFunc()
end

function InitFunc()
    cDebugLog("InitFunc")-------------------------------------------------------------------------
    HeroHandle = nil
    ElderineHandle = nil
    EnemyHandle = nil
	WaitUntil = 0
    StepFunc = HeroFind
    SubStep = 0
end

function InWait()
    return cCurSec() < WaitUntil
end

function HeroFind()
    local prt;
    HeroHandle, prt = cGetQuestHero_ItemUse(11234, "Eld", "BestLowHpPotion")
    if HeroHandle ~= nil then
        cDebugLog("HeroHandle : " .. HeroHandle .. "/" .. prt)----------------------------------------------------
        StepFunc = ElderineRegen
    end
end

function ElderineRegen()
    cDebugLog("ElderineRegen")-------------------------------------------------------------------------
    local x, y
    x, y = cObjectLocate(HeroHandle)
    ElderineHandle = cMobRegen_XY("Eld", "Job2_YongE", x, y + 50)    -- x, y 위치에 슬라임 리젠
    if ElderineHandle ~= nil then
        StepFunc = ElderineSpeech
        SubStep = 0
    end
end

function ElderineSpeech()
    if InWait() then
        return
    cDebugLog("ElderineSpeech")-------------------------------------------------------------------------
    end
    if SubStep == 0 then
        cNPCChat(ElderineHandle, -1, "나를 부른 사람이 당신인가요?")
        WaitUntil = cCurSec() + 2
        SubStep = 1
        return
    elseif SubStep == 1 then
        cNPCChat(ElderineHandle, -1, "당신에게서 선한 의지가 느껴지는군요")
        WaitUntil = cCurSec() + 2
        SubStep = 2
        return
    elseif SubStep == 2 then
        cNPCChat(ElderineHandle, -1, "당신에게 힘을... 누구냐!")
        StepFunc = EnemyRegen
        return
    end
end

function EnemyRegen()
    cDebugLog("EnemyRegen")-------------------------------------------------------------------------
    EnemyMobHandle = cMobRegen_Obj("D_FlameHoneying", ElderineHandle)
    StepFunc = Engagement
end

function Engagement()
    cDebugLog("Engagement")-------------------------------------------------------------------------
    cNPCChat(EnemyMobHandle, -1, "그 힘은 내것이다!!!")
    cAggroSet(EnemyMobHandle, ElderineHandle)
    cAggroSet(ElderineHandle, EnemyMobHandle)
    StepFunc = WaitResult
end

function WaitResult()
    cDebugLog("WaitResult")-------------------------------------------------------------------------
    if cObjectDead(ElderineHandle) then    -- 퀘스트실패
        StepFunc = QuestFail
        return
    end
    if cObjectDead(EnemyMobHandle) then   -- 퀘스트성공
        StepFunc = QuestSuccess
        return
    end
end

function QuestFail()
    cNPCChat(ElderineHandle, -1, "이... 이것이 운명인가...")
    cNPCChat(EnemyMobHandle, -1, "우하하, 힘... 힘이다!!!")
    cNPCVanish(EnemyMobHandle)
    InitFunc()
end

function QuestSuccess()
    cNPCChat(EnemyMobHandle, -1, "안돼!!!!!!!!")
    cNPCChat(ElderineHandle, -1, "고마워요, 앞으로 " .. cGetPlayerName(HeroHandle) .. "님에게 행운이 함께 할 거예요.")
    cNPCVanish(ElderineHandle)
    InitFunc()
end

StepFunc = InitFunc