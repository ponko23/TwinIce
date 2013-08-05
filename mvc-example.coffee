# モデル1 アイスクリーム一覧
icecreamModel =
  list: [
    {id:'t1', name:"バニラ"}
    {id:'t2', name:"チョコレートチップ"}
    {id:'t3', name:"オレンジシャーベット"}
    {id:'t4', name:"チョコミント"}
    {id:'t5', name:"ストロベリー"}
    {id:'t6', name:"抹茶"}
  ]
  # 全てのアイスクリームを返す (getter)
  getAll: () ->
    @list

# IDで指定したアイスクリームオブジェクトを返す
  findById: (id) ->
    $.grep(@list, (val) ->
      id == val.id
    )[0]


# モデル2 選択されているアイスクリームの管理
selectionModel =
  # 選択されているアイスクリームが入る
  list: []

  # アイスクリームの個数
  icecreamNumber: 2

  # アイスクリームを追加する
  add: (item) ->
    list = @list
    list.push item
    if list.length > @icecreamNumber
      # アイスクリーム制限個数以上の場合は
      list.shift() # 0番目を捨てる
    @updateView() # ビューを更新

  # 指定したアイスクリムが選択されていればtrueが返る
  contain: (icecream) ->
    @list.indexOf(icecream) >= 0

  # IDで指定したアイスクリームが選択されていればtrueが返る
  containById: (id) ->
    @contain icecreamModel.findById id

  # 選択されているアイスクリームを返す (getter)
  getIcecreams: () ->
    @list

  # ビューを更新する
  updateView: () ->
    updateSelection()
    updateIcecreamList()

# ビュー: チェックボックスを更新する
updateSelection = () ->
  $('#icecreams input[type="checkbox"]').each (i, elm) ->
    elm.checked = selectionModel.containById elm.name
  return

# ビュー: 選択順序を更新するビュー
updateIcecreamList = () ->
  # 選択されたアイスクリーム一覧からアイスクリーム名を集めて' > 'で連結して表示
  $("#icecream-list").text(
    $.map(selectionModel.getIcecreams(), (val) ->
      val.name
    ).join " > "
  )
  return

# 簡単なテストチェック関数
ok = (title, expect, value) ->
  if expect is value
    console.log "OK : "+title
  else
    console.log "NG : "+title+" ["+expect+"] --> ["+value+"]"

# テスト内容
testModels = () ->
  all = icecreamModel.getAll()

  ok "icecreamModel:個数",all.length,6
  ok "icecreamModel.findById",icecreamModel.findById("t4"), all[3]

  ok "selectionModel:最初の個数",selectionModel.getIcecreams().length,0
  ok "selectionModelcontain:空の場合",false,selectionModel.contain all[0]

  selectionModel.add all[0]
  ok "selectionModel.contain:1つめを追加した時の個数",selectionModel.getIcecreams().length,1
  ok "selectionModel.contain:1つめを追加した時のチェック",true,selectionModel.contain all[0]

  selectionModel.add all[1]
  ok "selectionModel.contain:2つめを追加した時の個数",selectionModel.getIcecreams().length,2
  ok "selectionModel.contain:2つめを追加した時のチェック",true,selectionModel.contain all[1]

  selectionModel.add all[2]
  ok "selectionModel:3つめを追加した場合の",selectionModel.getIcecreams().length,2
  ok "selectionModel.contain:3つめを追加した時のチェック",true,selectionModel.contain all[2]
  ok "selectionModel.contain:3つめを追加した時の個数",false,selectionModel.contain all[0]

testModels()

# アイスクリーム一覧を構築
$ () ->
  els = $ '#icecreams'
  $.each icecreamModel.getAll(), (i,icecream) ->
    els.append(
      $("<li>")
        .append($("<input type='checkbox'>")
          .attr('name', icecream.id))
        .append($("<span>")
          .text(icecream.name))
        .click () ->
          # ここでコントローラ呼び出し(あとで書く)
    )
    return
  selectionModel.updateViews
