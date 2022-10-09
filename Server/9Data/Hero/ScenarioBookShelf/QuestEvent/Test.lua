--[[
cDebugLog("nil")                                     출력
cPlayerExist(HeroHandle, CenterNPCHandle, 500)                    HeroHandle인 사람이 게임에 있는가?
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
cDistanceSquar(HeroHandle, CenterNPCHandle)                          거리체크
]]

-- 일정위치(NPC)에 다가가면 슬라임 리젠, 슬라임을 잡으면 머쉬룸 리젠, 머쉬룸 HP 반으로 깎으면 아이템 주고 사라짐

function QuestEventRoutine()
    if HeroHandle ~= nil then
        if not cPlayerExist(HeroHandle) then
            cDebugLog("Hero Out!!!!!!!!!!!!!!!!!!!!!!")
            QuestFinish()
        end    
        if cDistanceSquar(HeroHandle, CenterNPCHandle) > 500 * 500 then
            cDebugLog("Hero Run out!!!!!!!!!!!!!!!!!!!!!!")
            QuestFinish()
        end
    end
    StepFunc()
end

function QuestFinish()
    cDebugLog("QuestFinish")-------------------------------------------------------------------------
    HeroHandle = nil
    if EnemyMobHandle ~= nil then
        cNPCVanish(EnemyMobHandle)
    end
    WaitUntil = 0
    StepFunc = HeroFind
end

function InWait()
    return cCurSec() < WaitUntil
end

function NPCInit()
    cDebugLog("NPCInit")-------------------------------------------------------------------------
    CenterNPCHandle = cGetNPCHandle("Rou", "E_PromMaster")
    if CenterNPCHandle ~= nil then
        --cDebugLog("E_PromMaster Handle : " .. CenterNPCHandle)-------------------------------------------------------------------------
        StepFunc = HeroFind
    end
end

function HeroFind()
    --cDebugLog("HeroFind")-------------------------------------------------------------------------
    local party;
    HeroHandle, party = cGetQuestHero_NPC(11234, CenterNPCHandle, 300) -- 11234번 퀘스트를 가지고 있는 사람들 중 CenterNPCHandle에서 300그리드 내에 있는 사람
    if HeroHandle == nil then    -- 대상을 못찾았음
        return
    end

    cDebugLog("Quester Handle : " .. HeroHandle .. " Party : " .. party)-------------------------------------------------------------------------

    StepFunc = FirstMobRegen    -- HeroHandle을 대상으로 퀘스트이벤트 시작
end

function FirstMobRegen()
    cDebugLog("FirstMobRegen")-------------------------------------------------------------------------
    EnemyMobHandle = cMobRegen_Obj("Slime", CenterNPCHandle)    -- CenterNPCHandle 위치에 슬라임 리젠
    if EnemyMobHandle ~= nil then
        cDebugLog("FirstMobRegen Handle : " .. EnemyMobHandle)-------------------------------------------------------------------------
        WaitUntil = cCurSec() + 2    -- FirstMobChat()에서 2초간 기다리는 시간
        StepFunc = FirstMobChat
    end
end

function FirstMobChat()
    cDebugLog("FirstMobChat")-------------------------------------------------------------------------
    if not InWait() then
        cNPCChat(EnemyMobHandle, -1, cGetPlayerName(HeroHandle) .. ", 죽음의 땅에 온 것을 환영한다")
        cAggroSet(EnemyMobHandle, HeroHandle)
        StepFunc = WaitSlimeDead
    end
end

function WaitSlimeDead()
    cDebugLog("WaitSlimeDead")-------------------------------------------------------------------------
    if cObjectDead(EnemyMobHandle) then
        cDebugLog("Dead");
        EnemyMobHandle = cMobRegen_Obj("MushRoom", CenterNPCHandle)    -- CenterNPCHandle 위치에 슬라임 리젠
        WaitUntil = cCurSec() + 2    -- FirstMobChat()에서 2초간 기다리는 시간
        StepFunc = SecondMobChat
    else
        cAggroSet(EnemyMobHandle, HeroHandle)
    end
end

function SecondMobChat()
    cDebugLog("SecondMobChat")-------------------------------------------------------------------------
    if not InWait() then
        cNPCChat(EnemyMobHandle, -1, cGetPlayerName(HeroHandle) .. ", 네 죽음이 멀지 않았다!")
        cAggroSet(EnemyMobHandle, HeroHandle)
        StepFunc = WaitMushRoomSurrender
    end
end

function WaitMushRoomSurrender()
    cDebugLog("WaitMushRoomSurrender")-------------------------------------------------------------------------
    if cObjectHP(EnemyMobHandle) < 30 then
        MushRoomSurrender()
    end
end

function MushRoomSurrender()
    cDebugLog("MushRoomSurrender")-------------------------------------------------------------------------
    cSetAbstate(EnemyMobHandle, "StaImmortal", 1, 100)

    cNPCChat(EnemyMobHandle, HeroHandle, "그만, 이걸 드릴테니 제발 용서해 주세요...ㅜㅜ")
    WaitUntil = cCurSec() + 2    -- FirstMobChat()에서 2초간 기다리는 시간
    StepFunc = MushRoomSurrenderChat
end

function MushRoomSurrenderChat()
    cDebugLog("MushRoomSurrenderChat")-------------------------------------------------------------------------
    if not InWait() then
        cDropItem("FKORDevilsA", EnemyMobHandle, HeroHandle, 1000000)
        cDropItem("FKORDevilsP", EnemyMobHandle, HeroHandle, 1000000)
        cDropItem("FKORDevilsS", EnemyMobHandle, HeroHandle, 1000000)
        QuestFinish()
    end
end

CenterNPCHandle = nil        -- 퀘스트위치에 있는 NPC E_PromMaster 핸들
HeroHandle = nil             -- 이 이벤트를 하는 플레이어 핸들
EnemyMobHandle = nil
StepFunc = NPCInit
WaitUntil = 0                -- 기다리는 시간