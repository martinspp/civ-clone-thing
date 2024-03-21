class_name Player

var id := randi()
var player_name := "Player"
var color : Color= Color.BLUE

var unlocked_researches : Array[ResearchData] = []
var owned_settlements : Array[Settlement] = []

func _init(_player_name: String, _id, _color) -> void:
    if _id:
        id = _id
    if _color:
        color = _color
    player_name = _player_name

func deserialize(data: Dictionary) -> void:
    if data.has("id"):
        id = data["id"]
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
    for r in data["researches"]:
        var research_data := ResourceRegistry.get_research_by_name(r)
        if research_data:
            unlocked_researches.append(research_data)
        else:
            printerr("Player.gd: Attempted to deserialize an invalid research %s" % r)
    
    for s in data["settlements"]:
        var settlement := GameStateService.get_settlement_by_id(s)
        if settlement:
            owned_settlements.append(settlement)
        else:
            printerr("Player.gd: Attempted to deserialize an invalid settlement %s" % s)
    

func serialize() -> Dictionary:
    var researches = []
    var settlement_ids = []
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