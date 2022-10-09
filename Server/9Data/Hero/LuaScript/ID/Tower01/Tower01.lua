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

		-- 인던 최초 실행시 변수 초기화
		InstanceField[Field] = {}

		Var				= InstanceField[Field]
		Var["MapIndex"]	= Field
		Var["StepFunc"]	= FieldInit

	end

	-- 설정된 함수가 있을때 함수 실행
	if Var["StepFunc"] ~= nil then

		Var["StepFunc"]( Var )

	end

end



----------------------------------------------------------------------------------------------------
--
--										Step function
--
----------------------------------------------------------------------------------------------------

-- [ 필드 초기화 함수 ]
function FieldInit( Var )

	cExecCheck( "FieldInit" )

	if Var == nil then

		return

	end


	-- 인던 1층 출구 게이트
	if GateData["ReturnGate"] ~= nil then

		local GateHnd = cMobRegen_XY( Var["MapIndex"], GateData["ReturnGate"]["InxName"], GateData["ReturnGate"]["x"], GateData["ReturnGate"]["y"],
		                              GateData["ReturnGate"]["Dir"] )

		cSetAIScript( SCRIPT_MAIN, GateHnd )
		cAIScriptFunc( GateHnd, "Entrance", "DummyFunc" )
		cAIScriptFunc( GateHnd, "NPCClick", "ReturnGateClick" )

	end


	-- 각 층 문
	Var["Door"] = {}
	for i = 1, #FloorDataTable do

		-- 해당 층에 문 데이터가 있으면 소환
		if FloorDataTable[i]["Door"] ~= nil then
			Var["Door"][i] = cDoorBuild( Var["MapIndex"], FloorDataTable[i]["Door"]["InxName"], FloorDataTable[i]["Door"]["x"], FloorDataTable[i]["Door"]["y"],
														  FloorDataTable[i]["Door"]["Dir"], FloorDataTable[i]["Door"]["Scale"] )
			cDoorAction( Var["Door"][i], FloorDataTable[i]["Door"]["BlockInx"], "close" )
		end

	end


	Var["Floor"]	= 1			-- 층
	Var["StepFunc"] = FloorInit	-- 다음 실행 함수 설정

end


-- [ 층 초기화 함수 ]
function FloorInit( Var )

	cExecCheck( "FloorInit" )

	if Var == nil then

		return

	end


	-- 층 데이터
	local nFloor	= Var["Floor"]				-- 층
	local FloorData	= FloorDataTable[nFloor]	-- 층 데이터

	if FloorData == nil then

		return

	end


	-- 그룹 리젠
	if FloorData["RegenGroup"] ~= nil then

		for i = 1, #FloorData["RegenGroup"] do

			cGroupRegenInstance( Var["MapIndex"], FloorData["RegenGroup"][i] );
			cAssertLog( "GroupRegen : "..Var["MapIndex"].." - "..FloorData["RegenGroup"][i] )

		end

	end


	-- 보스
	if FloorData["Boss"] ~= nil then

		if Var["Boss"] == nil then

			Var["Boss"] = {}

		end

		Var["Boss"]["SummonStep"]		= 1			-- 소환 단계
		Var["Boss"]["Handle"]			= cMobRegen_XY( Var["MapIndex"], FloorData["Boss"]["InxName"], FloorData["Boss"]["x"], FloorData["Boss"]["y"], FloorData["Boss"]["Dir"] )

	end


	Var["RoutineCheckDelay"]	= cCurSec() + ROUTINE_CHECK_DELAY_INIT	-- 몬스터 체크 간격 ( 최초 10 초 )
	Var["StepFunc"] 			= FloorRoutine							-- 다음 실행 함수 설정
	Var["Dialog"] 				= {}									-- 다이얼 로그 미리 할당

end


-- [ 층 루틴 ]
function FloorRoutine( Var )

	cExecCheck( "FloorRoutine" )

	if Var == nil then

		return;

	end


	-- 층 데이터
	local nFloor	= Var["Floor"]				-- 층
	local FloorData	= FloorDataTable[nFloor]	-- 층 데이터
	local bNextStep	= false						-- 다음 진행 판단

	if FloorData == nil then

		return;

	end


	-- 층 클리어 조건 확인
	if Var["Boss"] == nil then

		-- 보스 데이터가 없을 경우
		if Var["RoutineCheckDelay"] < cCurSec() then

			Var["RoutineCheckDelay"] = cCurSec() + ROUTINE_CHECK_DELAY

			if cObjectCount( Var["MapIndex"], ObjectType["Mob"] ) <= 0 then
				-- 모든 몬스터가 죽었을 경우, 다음 함수로 진행
				bNextStep = true
			end

		end

	else

		-- 보스 데이터가 있을 경우
		if cIsObjectDead( Var["Boss"]["Handle"] ) == nil then

			lua_BossSummon( Var, FloorData )	-- 전투 중이면, 보스의 HP%를 확인 몬스터를 소환한다

		else

			-- 보스가 죽었을 경우
			cMobSuicide( Var["MapIndex"] );		-- 모든 몬스터 삭제

			-- 인던 1층 출구 게이트
			-- ( ※ cMobSuicide가 호출되면 게이트도 삭제된다 )
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


	-- 다음 진행
	if bNextStep == true then

		-- 문 열기
		if Var["Door"][nFloor] ~= nil then

			cDoorAction( Var["Door"][nFloor], FloorData["Door"]["BlockInx"], "open" )

		end

		-- 다이얼 로그 정보 설정
		if FloorData["Dialog"] ~= nil then

			Var["Dialog"]["Step"] 	= 1
			Var["Dialog"]["Time"] 	= cCurSec() + FloorData["Dialog"][1]["Delay"]

		end

		Var["StepFunc"] = FloorEnd	-- 다음 실행 함수 설정

	end

end


-- [ 층 임무 완료 ]
function FloorEnd( Var )

	cExecCheck( "FloorEnd" )

	if Var == nil then

		return;

	end


	-- Data
	local nFloor		= Var["Floor"]				-- 층
	local FloorData		= FloorDataTable[nFloor]	-- 층 데이터
	local bNextFloor 	= false						-- 다음 층 진행 판단

	if FloorData == nil then

		return;

	end


	-- 다이얼 로그
	local DialogData = FloorData["Dialog"]
	if DialogData == nil then

		-- 다이얼 로그가 없으면 다음 층 진행
		bNextFloor = true

	else


		if Var["Dialog"] ~= nil then

			local nStep = Var["Dialog"]["Step"]
			if Var["Dialog"]["Time"] <= cCurSec() then

				-- 인던 클리어
				if nStep == 1 and nFloor == #FloorDataTable then

					lua_IDSuccess( Var );

				end

				-- 다이얼로그 출력
				if DialogData[nStep] ~= nil then

					cMobDialog( Var["MapIndex"], DialogData[nStep]["Facecut"], DialogData[nStep]["FileName"], DialogData[nStep]["Index"] )

				end


				-- 다음 다이얼로그 설정
				if nStep < #FloorData["Dialog"] then

					Var["Dialog"]["Step"] = nStep + 1
					Var["Dialog"]["Time"] = cCurSec() + DialogData[Var["Dialog"]["Step"]]["Delay"]

				else

					bNextFloor = true

				end

			end

		end

	end


	-- 다음 층 진행
	if bNextFloor == true then

		if nFloor < #FloorDataTable then

			-- 마지막 층이 아닐 경우
			Var["Floor"] 	= nFloor + 1
			Var["StepFunc"]	= FloorInit

		else

			--	마지막 층
			Var["StepFunc"]	= nil

		end

	end

end

----------------------------------------------------------------------------------------------------
--
--									InstanceDungeon Success function
--
----------------------------------------------------------------------------------------------------

-- [ 인던 성공 ]
function lua_IDSuccess( Var )

	cExecCheck( "Success" )

	if Var == nil then

		return;

	end


	cQuestResult( Var["MapIndex"], "Success" )


	-- 인던 1층 출구 게이트
	if GateData["ReturnGate"] ~= nil then

		local GateHnd = cMobRegen_XY( Var["MapIndex"], GateData["ReturnGate"]["InxName"], GateData["ReturnGate"]["x"], GateData["ReturnGate"]["y"],
		                              GateData["ReturnGate"]["Dir"] )

		cSetAIScript( SCRIPT_MAIN, GateHnd )
		cAIScriptFunc( GateHnd, "Entrance", "DummyFunc" )
		cAIScriptFunc( GateHnd, "NPCClick", "ReturnGateClick" )

	end


	-- 귀환 게이트 소환
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


-- [ 인던 1층 출구 게이트 함수 ]
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


-- [ 귀환 게이트 함수 ]
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
-- [ 보스 : 몬스터 소환 함수 ]
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


	-- 더이상 소환할 몬스터가 없을 경우
	if Var["Boss"]["SummonStep"] > #FloorData["BossSummon"] then

		return

	end


	-- HP % 따른 몬스터 소환
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


	-- HP % 확인
	if nCurHP * 1000 > nMaxHP * SummonData["HPPercent"] then

		return

	end


	-- 다이얼로그 출력
	if SummonData["Dialog"] ~= nil then

		cMobDialog( Var["MapIndex"], SummonData["Dialog"]["Facecut"], SummonData["Dialog"]["FileName"],	SummonData["Dialog"]["Index"] )

	end


	-- 몬스터 소환
	for i = 1, #SummonData["MonsterData"] do

		for j = 1, SummonData["MonsterData"][i]["Number"] do

			cMobRegen_Obj( SummonData["MonsterData"][i]["InxName"], Var["Boss"]["Handle"] )

		end

	end


	Var["Boss"]["SummonStep"] = Var["Boss"]["SummonStep"] + 1

end
