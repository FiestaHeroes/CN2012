require( "common" )
require( "ID/Tower01/Tower01_Data" )



----------------------------------------------------------------------------------------------------
--
--										Mian function
--
----------------------------------------------------------------------------------------------------
function Main( Field )

	local Var = InstanceField[Field]
	if Var == nil then

		-- �δ� ���� ����� ���� �ʱ�ȭ
		InstanceField[Field] = {}

		Var				= InstanceField[Field]
		Var["MapIndex"]	= Field
		Var["StepFunc"]	= FieldInit

	end

	-- ������ �Լ��� ������ �Լ� ����
	if Var["StepFunc"] ~= nil then

		Var["StepFunc"]( Var )

	end

end



----------------------------------------------------------------------------------------------------
--
--										Step function
--
----------------------------------------------------------------------------------------------------

-- [ �ʵ� �ʱ�ȭ �Լ� ]
function FieldInit( Var )

	cExecCheck( "FieldInit" )

	if Var == nil then

		return

	end


	-- �δ� 1�� �ⱸ ����Ʈ
	if GateData["ReturnGate"] ~= nil then

		local GateHnd = cMobRegen_XY( Var["MapIndex"], GateData["ReturnGate"]["InxName"], GateData["ReturnGate"]["x"], GateData["ReturnGate"]["y"],
		                              GateData["ReturnGate"]["Dir"] )

		cSetAIScript( SCRIPT_MAIN, GateHnd )
		cAIScriptFunc( GateHnd, "Entrance", "DummyFunc" )
		cAIScriptFunc( GateHnd, "NPCClick", "ReturnGateClick" )

	end


	-- �� �� ��
	Var["Door"] = {}
	for i = 1, #FloorDataTable do

		-- �ش� ���� �� �����Ͱ� ������ ��ȯ
		if FloorDataTable[i]["Door"] ~= nil then
			Var["Door"][i] = cDoorBuild( Var["MapIndex"], FloorDataTable[i]["Door"]["InxName"], FloorDataTable[i]["Door"]["x"], FloorDataTable[i]["Door"]["y"],
														  FloorDataTable[i]["Door"]["Dir"], FloorDataTable[i]["Door"]["Scale"] )
			cDoorAction( Var["Door"][i], FloorDataTable[i]["Door"]["BlockInx"], "close" )
		end

	end


	Var["Floor"]	= 1			-- ��
	Var["StepFunc"] = FloorInit	-- ���� ���� �Լ� ����

end


-- [ �� �ʱ�ȭ �Լ� ]
function FloorInit( Var )

	cExecCheck( "FloorInit" )

	if Var == nil then

		return

	end


	-- �� ������
	local nFloor	= Var["Floor"]				-- ��
	local FloorData	= FloorDataTable[nFloor]	-- �� ������

	if FloorData == nil then

		return

	end


	-- �׷� ����
	if FloorData["RegenGroup"] ~= nil then

		for i = 1, #FloorData["RegenGroup"] do

			cGroupRegenInstance( Var["MapIndex"], FloorData["RegenGroup"][i] );
			cAssertLog( "GroupRegen : "..Var["MapIndex"].." - "..FloorData["RegenGroup"][i] )

		end

	end


	-- ����
	if FloorData["Boss"] ~= nil then

		if Var["Boss"] == nil then

			Var["Boss"] = {}

		end

		Var["Boss"]["SummonStep"]		= 1			-- ��ȯ �ܰ�
		Var["Boss"]["Handle"]			= cMobRegen_XY( Var["MapIndex"], FloorData["Boss"]["InxName"], FloorData["Boss"]["x"], FloorData["Boss"]["y"], FloorData["Boss"]["Dir"] )

	end


	Var["RoutineCheckDelay"]	= cCurSec() + ROUTINE_CHECK_DELAY_INIT	-- ���� üũ ���� ( ���� 10 �� )
	Var["StepFunc"] 			= FloorRoutine							-- ���� ���� �Լ� ����
	Var["Dialog"] 				= {}									-- ���̾� �α� �̸� �Ҵ�

end


-- [ �� ��ƾ ]
function FloorRoutine( Var )

	cExecCheck( "FloorRoutine" )

	if Var == nil then

		return;

	end


	-- �� ������
	local nFloor	= Var["Floor"]				-- ��
	local FloorData	= FloorDataTable[nFloor]	-- �� ������
	local bNextStep	= false						-- ���� ���� �Ǵ�

	if FloorData == nil then

		return;

	end


	-- �� Ŭ���� ���� Ȯ��
	if Var["Boss"] == nil then

		-- ���� �����Ͱ� ���� ���
		if Var["RoutineCheckDelay"] < cCurSec() then

			Var["RoutineCheckDelay"] = cCurSec() + ROUTINE_CHECK_DELAY

			if cObjectCount( Var["MapIndex"], ObjectType["Mob"] ) <= 0 then
				-- ��� ���Ͱ� �׾��� ���, ���� �Լ��� ����
				bNextStep = true
			end

		end

	else

		-- ���� �����Ͱ� ���� ���
		if cIsObjectDead( Var["Boss"]["Handle"] ) == nil then

			lua_BossSummon( Var, FloorData )	-- ���� ���̸�, ������ HP%�� Ȯ�� ���͸� ��ȯ�Ѵ�

		else

			-- ������ �׾��� ���
			cMobSuicide( Var["MapIndex"] );		-- ��� ���� ����

			-- �δ� 1�� �ⱸ ����Ʈ
			-- ( �� cMobSuicide�� ȣ��Ǹ� ����Ʈ�� �����ȴ� )
			if GateData["ReturnGate"] ~= nil then

				local GateHnd = cMobRegen_XY( Var["MapIndex"], GateData["ReturnGate"]["InxName"], GateData["ReturnGate"]["x"], GateData["ReturnGate"]["y"],
											  GateData["ReturnGate"]["Dir"] )

				cSetAIScript( SCRIPT_MAIN, GateHnd )
				cAIScriptFunc( GateHnd, "Entrance", "DummyFunc" )
				cAIScriptFunc( GateHnd, "NPCClick", "ReturnGateClick" )

			end

			Var["Boss"]	= nil
			bNextStep	= true
		end

	end


	-- ���� ����
	if bNextStep == true then

		-- �� ����
		if Var["Door"][nFloor] ~= nil then

			cDoorAction( Var["Door"][nFloor], FloorData["Door"]["BlockInx"], "open" )

		end

		-- ���̾� �α� ���� ����
		if FloorData["Dialog"] ~= nil then

			Var["Dialog"]["Step"] 	= 1
			Var["Dialog"]["Time"] 	= cCurSec() + FloorData["Dialog"][1]["Delay"]

		end

		Var["StepFunc"] = FloorEnd	-- ���� ���� �Լ� ����

	end

end


-- [ �� �ӹ� �Ϸ� ]
function FloorEnd( Var )

	cExecCheck( "FloorEnd" )

	if Var == nil then

		return;

	end


	-- Data
	local nFloor		= Var["Floor"]				-- ��
	local FloorData		= FloorDataTable[nFloor]	-- �� ������
	local bNextFloor 	= false						-- ���� �� ���� �Ǵ�

	if FloorData == nil then

		return;

	end


	-- ���̾� �α�
	local DialogData = FloorData["Dialog"]
	if DialogData == nil then

		-- ���̾� �αװ� ������ ���� �� ����
		bNextFloor = true

	else


		if Var["Dialog"] ~= nil then

			local nStep = Var["Dialog"]["Step"]
			if Var["Dialog"]["Time"] <= cCurSec() then

				-- �δ� Ŭ����
				if nStep == 1 and nFloor == #FloorDataTable then

					lua_IDSuccess( Var );

				end

				-- ���̾�α� ���
				if DialogData[nStep] ~= nil then

					cMobDialog( Var["MapIndex"], DialogData[nStep]["Facecut"], DialogData[nStep]["FileName"], DialogData[nStep]["Index"] )

				end


				-- ���� ���̾�α� ����
				if nStep < #FloorData["Dialog"] then

					Var["Dialog"]["Step"] = nStep + 1
					Var["Dialog"]["Time"] = cCurSec() + DialogData[Var["Dialog"]["Step"]]["Delay"]

				else

					bNextFloor = true

				end

			end

		end

	end


	-- ���� �� ����
	if bNextFloor == true then

		if nFloor < #FloorDataTable then

			-- ������ ���� �ƴ� ���
			Var["Floor"] 	= nFloor + 1
			Var["StepFunc"]	= FloorInit

		else

			--	������ ��
			Var["StepFunc"]	= nil

		end

	end

end

----------------------------------------------------------------------------------------------------
--
--									InstanceDungeon Success function
--
----------------------------------------------------------------------------------------------------

-- [ �δ� ���� ]
function lua_IDSuccess( Var )

	cExecCheck( "Success" )

	if Var == nil then

		return;

	end


	cQuestResult( Var["MapIndex"], "Success" )


	-- �δ� 1�� �ⱸ ����Ʈ
	if GateData["ReturnGate"] ~= nil then

		local GateHnd = cMobRegen_XY( Var["MapIndex"], GateData["ReturnGate"]["InxName"], GateData["ReturnGate"]["x"], GateData["ReturnGate"]["y"],
		                              GateData["ReturnGate"]["Dir"] )

		cSetAIScript( SCRIPT_MAIN, GateHnd )
		cAIScriptFunc( GateHnd, "Entrance", "DummyFunc" )
		cAIScriptFunc( GateHnd, "NPCClick", "ReturnGateClick" )

	end


	-- ��ȯ ����Ʈ ��ȯ
	if GateData["CompleteGate"] ~= nil then

		local GateHnd = cMobRegen_XY( Var["MapIndex"], GateData["CompleteGate"]["InxName"], GateData["CompleteGate"]["x"], GateData["CompleteGate"]["y"],
		                              GateData["CompleteGate"]["Dir"] )

		cSetAIScript( SCRIPT_MAIN, GateHnd )
		cAIScriptFunc( GateHnd, "Entrance", "DummyFunc" )
		cAIScriptFunc( GateHnd, "NPCClick", "CompleteGateClick" )

	end

end



----------------------------------------------------------------------------------------------------
--
--										Gate function
--
----------------------------------------------------------------------------------------------------
function DummyFunc( Handle, MapIndex )
	cExecCheck( "DummyFunc" )
end


-- [ �δ� 1�� �ⱸ ����Ʈ �Լ� ]
function ReturnGateClick( NPCHandle, PlyHandle, PlyRegnum, String )

	cExecCheck( "GateClick" )


	if GateData == nil then
		return
	end

	if GateData["ReturnGate"] == nil then
		return
	end

	if GateData["ReturnGate"]["LinkData"] == nil then
		return
	end


	cLinkTo( PlyHandle, GateData["ReturnGate"]["LinkData"]["Map"], GateData["ReturnGate"]["LinkData"]["x"], GateData["ReturnGate"]["LinkData"]["y"] )

end


-- [ ��ȯ ����Ʈ �Լ� ]
function CompleteGateClick( NPCHandle, PlyHandle, PlyRegnum, String )

	cExecCheck( "GateClick" )


	if GateData == nil then
		return
	end

	if GateData["CompleteGate"] == nil then
		return
	end

	if GateData["CompleteGate"]["LinkData"] == nil then
		return
	end


	cLinkTo( PlyHandle, GateData["CompleteGate"]["LinkData"]["Map"], GateData["CompleteGate"]["LinkData"]["x"], GateData["CompleteGate"]["LinkData"]["y"] )

end



----------------------------------------------------------------------------------------------------
--
--										Boss function
--
----------------------------------------------------------------------------------------------------
-- [ ���� : ���� ��ȯ �Լ� ]
function lua_BossSummon( Var, FloorData )

	if Var == nil then

		return

	end

	if Var["Boss"] == nil then

		return

	end

	if FloorData == nil then

		return

	end

	if FloorData["BossSummon"] == nil then

		return

	end


	-- ���̻� ��ȯ�� ���Ͱ� ���� ���
	if Var["Boss"]["SummonStep"] > #FloorData["BossSummon"] then

		return

	end


	-- HP % ���� ���� ��ȯ
	local nCurHP
	local nMaxHP
	nCurHP, nMaxHP = cObjectHP( Var["Boss"]["Handle"] )

	if nCurHP == nil then

		return

	end

	if nMaxHP == nil then

		return

	end


	local SummonData = FloorData["BossSummon"][Var["Boss"]["SummonStep"]]
	if SummonData == nil then

		return

	end


	-- HP % Ȯ��
	if nCurHP * 1000 > nMaxHP * SummonData["HPPercent"] then

		return

	end


	-- ���̾�α� ���
	if SummonData["Dialog"] ~= nil then

		cMobDialog( Var["MapIndex"], SummonData["Dialog"]["Facecut"], SummonData["Dialog"]["FileName"],	SummonData["Dialog"]["Index"] )

	end


	-- ���� ��ȯ
	for i = 1, #SummonData["MonsterData"] do

		for j = 1, SummonData["MonsterData"][i]["Number"] do

			cMobRegen_Obj( SummonData["MonsterData"][i]["InxName"], Var["Boss"]["Handle"] )

		end

	end


	Var["Boss"]["SummonStep"] = Var["Boss"]["SummonStep"] + 1

end
