class_name Player

var id := randi() % 50000000 
var player_name := "Player"
var color : Color= Color.BLUE
var ended_turn: bool = false

var unlocked_researches : Array[ResearchData] = []
var owned_settlements : Array[Settlement] = []

func _init(_player_name: String, _id: Variant, _color: Variant) -> void:
    GameStateService.end_of_turn_actions[self] = false
    if _id:
        id = _id
    if _color:
        color = _color
    player_name = _player_name
    PlayEventBus.start_of_turn.connect(_start_of_turn_actions)
    PlayEventBus.end_of_turn.connect(_end_of_turn_actions)
    PlayEventBus.player_end_turn.connect(_player_end_turn)

func deserialize(data: Dictionary) -> void:
    if data.has('id'):
        id = data['id']
    else:
        id = randi()

    if data.has("player_name"):
        player_name = data["player_name"]
    else:
        player_name = str(id)
    
    if data.has("color"):
        color = Color(data["color"][0],data["color"][1],data["color"][2])
    else:
        color = Color.BLACK
    for r: String in data["researches"]:
        var research_data := ResourceRegistry.get_research_by_name(r)
        if research_data:
            unlocked_researches.append(research_data)
        else:
            printerr("Player.gd: Attempted to deserialize an invalid research %s" % r)
    
    for s: int in data["settlements"]:
        var settlement : Settlement= GameStateService.get_settlement_by_id(s)
        if settlement:
            owned_settlements.append(settlement)
        else:
            printerr("Player.gd: Attempted to deserialize an invalid settlement %s" % s)
    

func serialize() -> Dictionary:
    var researches: Array[ResearchData] = []
    var settlement_ids: Array[int] = []
    for r in unlocked_researches:
        researches.append(r.research_name)
    for s in owned_settlements:
        settlement_ids.append(s.id)
    print("set %s" % str(self))
    return {
        "id": id,
        "player_name": player_name,
        "color": [color.r, color.g, color.b],
        "researches": researches,
        "settlements": settlement_ids,
        "ref": self
    }

func _start_of_turn_actions(turn_number: int) -> void:
    pass

func _end_of_turn_actions() -> void:
    PlayEventBus.object_finished_end_turn_action.emit(self)

func _player_end_turn(player: Player) -> void:
    if player == self:
        ended_turn = true
    GameStateService.game_service.check_for_next_turn()