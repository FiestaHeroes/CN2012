--[[
cDebugLog("nil")                                     ���
cPlayerExist(HeroHandle, CenterNPCHandle, 500)                    HeroHandle�� ����� ���ӿ� �ִ°�?
cMobRegen_Obj("MushRoom", CenterNPCHandle)                           CenterNPCHandle ��ġ�� ������ ����
cNPCVanish(EnemyMobHandle)                                           NPC�� EnemyMobHandle�� ����
cCurSec()                                                            ���� ��(Tick / 10) ����
cGetNPCHandle("Rou", "E_PromMaster")                                 ���ʿ��� "E_PromMaster"�� ���� ã�� �ڵ� ����
cGetQuestHero_NPC(11234, CenterNPCHandle, 300)                       11234�� ����Ʈ�� ������ �ִ� ����� �� CenterNPCHandle���� 300�׸��� ���� �ִ� ���
cNPCChat(EnemyMobHandle, towhom, "�ȳ�")                             EnemyMobHandle�� "�ȳ�"�̶� ä���� ��
cGetPlayerName(HeroHandle)                                           HeroHandle�� ĳ���� ID ����
cAggroSet(EnemyMobHandle, HeroHandle)                                EnemyMobHandle�� HeroHandle�� �����ϵ��� ����
cObjectDead(EnemyMobHandle)                                          EnemyMobHandle�� �׾����� true, ���������� false
cObjectHP(EnemyMobHandle)                                            EnemyMobHandle�� ���� HP ����
cSetAbstate(EnemyMobHandle, "StaImmortal", 1, 100)                   EnemyMobHandle���� StaImmortal �ɾ���(���� 1, ���ӽð� 100��)
cDropItem("FKORDevilsS", EnemyMobHandle, HeroHandle, 1000000)        ������ FKORDevilsS�� EnemyMobHandle�� �߹ؿ� ���ñ��� HeroHandle�� ����(Ȯ�� 1�鸸����)
cDistanceSquar(HeroHandle, CenterNPCHandle)                          �Ÿ�üũ
]]

-- ������ġ(NPC)�� �ٰ����� ������ ����, �������� ������ �ӽ��� ����, �ӽ��� HP ������ ������ ������ �ְ� �����

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
    HeroHandle, party = cGetQuestHero_NPC(11234, CenterNPCHandle, 300) -- 11234�� ����Ʈ�� ������ �ִ� ����� �� CenterNPCHandle���� 300�׸��� ���� �ִ� ���
    if HeroHandle == nil then    -- ����� ��ã����
        return
    end

    cDebugLog("Quester Handle : " .. HeroHandle .. " Party : " .. party)-------------------------------------------------------------------------

    StepFunc = FirstMobRegen    -- HeroHandle�� ������� ����Ʈ�̺�Ʈ ����
end

function FirstMobRegen()
    cDebugLog("FirstMobRegen")-------------------------------------------------------------------------
    EnemyMobHandle = cMobRegen_Obj("Slime", CenterNPCHandle)    -- CenterNPCHandle ��ġ�� ������ ����
    if EnemyMobHandle ~= nil then
        cDebugLog("FirstMobRegen Handle : " .. EnemyMobHandle)-------------------------------------------------------------------------
        WaitUntil = cCurSec() + 2    -- FirstMobChat()���� 2�ʰ� ��ٸ��� �ð�
        StepFunc = FirstMobChat
    end
end

function FirstMobChat()
    cDebugLog("FirstMobChat")-------------------------------------------------------------------------
    if not InWait() then
        cNPCChat(EnemyMobHandle, -1, cGetPlayerName(HeroHandle) .. ", ������ ���� �� ���� ȯ���Ѵ�")
        cAggroSet(EnemyMobHandle, HeroHandle)
        StepFunc = WaitSlimeDead
    end
end

function WaitSlimeDead()
    cDebugLog("WaitSlimeDead")-------------------------------------------------------------------------
    if cObjectDead(EnemyMobHandle) then
        cDebugLog("Dead");
        EnemyMobHandle = cMobRegen_Obj("MushRoom", CenterNPCHandle)    -- CenterNPCHandle ��ġ�� ������ ����
        WaitUntil = cCurSec() + 2    -- FirstMobChat()���� 2�ʰ� ��ٸ��� �ð�
        StepFunc = SecondMobChat
    else
        cAggroSet(EnemyMobHandle, HeroHandle)
    end
end

function SecondMobChat()
    cDebugLog("SecondMobChat")-------------------------------------------------------------------------
    if not InWait() then
        cNPCChat(EnemyMobHandle, -1, cGetPlayerName(HeroHandle) .. ", �� ������ ���� �ʾҴ�!")
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

    cNPCChat(EnemyMobHandle, HeroHandle, "�׸�, �̰� �帱�״� ���� �뼭�� �ּ���...�̤�")
    WaitUntil = cCurSec() + 2    -- FirstMobChat()���� 2�ʰ� ��ٸ��� �ð�
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

CenterNPCHandle = nil        -- ����Ʈ��ġ�� �ִ� NPC E_PromMaster �ڵ�
HeroHandle = nil             -- �� �̺�Ʈ�� �ϴ� �÷��̾� �ڵ�
EnemyMobHandle = nil
StepFunc = NPCInit
WaitUntil = 0                -- ��ٸ��� �ð�