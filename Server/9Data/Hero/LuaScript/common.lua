-- 스크립트의 리턴값

-- 몹 AIScript
ReturnAI = {}
ReturnAI.END = 1    -- Return_AI_END = 1;//    -- 모든 AI루틴 끝
ReturnAI.CPP = 2    -- Return_AI_CPP = 2;//    -- 루아로 일부 처리한 후 cpp의 AI루틴 돌림



-- 오브젝트 타입
ObjectType = {}
ObjectType.Invalid		= - 1
ObjectType.Flag			=   0
ObjectType.DropItem		=   1
ObjectType.Player		=   2
ObjectType.MiniHouse	=   3
ObjectType.NPC			=   4
ObjectType.Mob			=   5
ObjectType.MagicField	=   6
ObjectType.Door			=   7
ObjectType.Bandit		=   8
ObjectType.Effect		=   9
ObjectType.Servant		=  10
ObjectType.Max			=  11


BasicClass = {}

BasicClass.None			= 0
BasicClass.Fighter		= 1
BasicClass.Cleric		= 6
BasicClass.Archer		= 11
BasicClass.Mage			= 16
BasicClass.Joker		= 21



--인던 필드 정보
InstanceField = {}

function InstanceDungeonClear( Field )
cExecCheck "InstanceDungeonClear"

	InstanceField[Field] = nil

end
