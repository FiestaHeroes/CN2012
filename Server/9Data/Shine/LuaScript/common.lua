-- ��ũ��Ʈ�� ���ϰ�

-- �� AIScript
ReturnAI = {}
ReturnAI.END = 1    -- Return_AI_END = 1;//    -- ��� AI��ƾ ��
ReturnAI.CPP = 2    -- Return_AI_CPP = 2;//    -- ��Ʒ� �Ϻ� ó���� �� cpp�� AI��ƾ ����



-- ������Ʈ Ÿ��
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



--�δ� �ʵ� ����
InstanceField = {}

function InstanceDungeonClear( Field )
cExecCheck "InstanceDungeonClear"

	InstanceField[Field] = nil

end
