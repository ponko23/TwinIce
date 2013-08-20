###
  Model
###

iceModel =
  list: [
    {id:'t1', name:"バニラ"}
    {id:'t2', name:"チョコレートチップ"}
    {id:'t3', name:"オレンジシャーベット"}
    {id:'t4', name:"チョコミント"}
    {id:'t5', name:"ストロベリー"}
    {id:'t6', name:"抹茶"}
  ]

  getAll: ->
    @list

  findById: (id) ->
    $.grep(@list, (val) ->
      id is val.id
    )[0]

selectionModel =
  list: []

  numberOfStage: 2

  add: (item) ->
    list = @list
    list.push item
    list.shift() if list.length > @numberOfStage
    @updateViews()

  contain: (ice) ->
    @list.indexOf(ice) >= 0

  containById: (id) ->
    @contain iceModel.findById id

  getIce: ->
    @list

  updateViews: ->
    updateSelection()
    updateIceList()


###
  view
###

updateSelection = ->
  $('#icecream-list').text(
    $.map(selectionModel.getIce(), (val) ->
      val.name
    ).join " > "
  )

updateIceList = ->
  $('.selected').removeClass "selected"
  for i in selectionModel.list
    if $('#'+i.id).hasClass "selected"
    else
      $('#'+i.id).addClass "selected"

$ ->
  els = $('#icecreams')
  $.each iceModel.getAll(), (i,icecream) ->
   els.append(
      $("<li>")
        .attr('id', icecream.id)
        .append($("<span>")
          .text(icecream.name))
        .click (event) ->
          onclickIce event
    )
###
  Controller
###

onclickIce = (event) ->
  icecream = $(event.currentTarget).attr 'id'
  if icecream
    selectionModel.add iceModel.findById icecream

###
  Modelテスト
###
# 簡単なテストチェック関数
ok = (title, expect, value) ->
  if expect is value
    console.log "OK : "+title
  else
    console.log "NG : "+title+" ["+expect+"] --> ["+value+"]"

# テスト内容
testModels = ->
  all = iceModel.getAll()

  ok "iceModel:個数", all.length, 6
  ok "iceModel.findById", iceModel.findById("t4"), all[3]

  ok "selectionModel:最初の個数", selectionModel.getIce().length, 0
  ok "selectionModel.contain:空の場合", false, selectionModel.contain all[0]

  selectionModel.add all[0]
  ok "selectionModel.contain:1つめを追加した時の個数", selectionModel.getIce().length, 1
  ok "selectionModel.contain:1つめを追加した時のチェック", true, selectionModel.contain all[0]

  selectionModel.add all[1]
  ok "selectionModel.contain:2つめを追加した時の個数", selectionModel.getIce().length, 2
  ok "selectionModel.contain:2つめを追加した時のチェック", true, selectionModel.contain all[1]

  selectionModel.add all[2]
  ok "selectionModel:3つめを追加した場合の", selectionModel.getIce().length, 2
  ok "selectionModel.contain:3つめを追加した時のチェック", true, selectionModel.contain all[2]
  ok "selectionModel.contain:3つめを追加した時の個数", false, selectionModel.contain all[0]

testModels()