--[[
cDebugLog("nil")                                     ���
cPlayerExistNPC(HeroHandle, CenterNPCHandle, 500)                    HeroHandle�� ����� ���ӿ� �ִ°�?
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

cGetQuestHero_ItemUse(11234, "Eld", "BestLowHpPotion")               ���������� BestLowHpPotion ����� ��� ã��
cObjectLocate(HeroHandle)                                            ��ǥ����
cMobRegen_XY("Eld", "Slime", x, y + 50)                           x, y ��ġ�� ������ ����
]]

-- ������ġ(NPC)�� �ٰ����� ������ ����, �������� ������ �ӽ��� ����, �ӽ��� HP ������ ������ ������ �ְ� �����

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
    ElderineHandle = cMobRegen_XY("Eld", "Job2_YongE", x, y + 50)    -- x, y ��ġ�� ������ ����
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
        cNPCChat(ElderineHandle, -1, "���� �θ� ����� ����ΰ���?")
        WaitUntil = cCurSec() + 2
        SubStep = 1
        return
    elseif SubStep == 1 then
        cNPCChat(ElderineHandle, -1, "��ſ��Լ� ���� ������ �������±���")
        WaitUntil = cCurSec() + 2
        SubStep = 2
        return
    elseif SubStep == 2 then
        cNPCChat(ElderineHandle, -1, "��ſ��� ����... ������!")
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
    cNPCChat(EnemyMobHandle, -1, "�� ���� �����̴�!!!")
    cAggroSet(EnemyMobHandle, ElderineHandle)
    cAggroSet(ElderineHandle, EnemyMobHandle)
    StepFunc = WaitResult
end

function WaitResult()
    cDebugLog("WaitResult")-------------------------------------------------------------------------
    if cObjectDead(ElderineHandle) then    -- ����Ʈ����
        StepFunc = QuestFail
        return
    end
    if cObjectDead(EnemyMobHandle) then   -- ����Ʈ����
        StepFunc = QuestSuccess
        return
    end
end

function QuestFail()
    cNPCChat(ElderineHandle, -1, "��... �̰��� ����ΰ�...")
    cNPCChat(EnemyMobHandle, -1, "������, ��... ���̴�!!!")
    cNPCVanish(EnemyMobHandle)
    InitFunc()
end

function QuestSuccess()
    cNPCChat(EnemyMobHandle, -1, "�ȵ�!!!!!!!!")
    cNPCChat(ElderineHandle, -1, "������, ������ " .. cGetPlayerName(HeroHandle) .. "�Կ��� ����� �Բ� �� �ſ���.")
    cNPCVanish(ElderineHandle)
    InitFunc()
end

StepFunc = InitFunc