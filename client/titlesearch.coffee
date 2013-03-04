root.Template.titlesearch.searchTextA = ->
  Session.get "searchTextA"

root.Template.titlesearch.searchTextB = ->
  Session.get "searchTextB"   

root.Template.titlesearch.events = 
  "click input:button": () ->
    setSearch()
  "keyup": (e) ->
    if e.which is 13
      setSearch()

setSearch = () ->
  Session.set "searchTextA", $("#searchTextA").val()
  Session.set "searchTextB", $("#searchTextB").val()
  Session.set "searchOpA", $("#searchOpA :selected").val()
  Session.set "searchOpB", $("#searchOpB :selected").val()
  Session.set "searchPrice", +($("#price :selected").val())
  Session.set "searchYear", +($("#year :selected").val())
  Session.set "page",1
  deb "sa/sb:"+$("#searchTextA").val() + "/" + $("#searchTextB").val()
  deb "op_a/op_b:"+ $("#searchOpA :selected").val() + "/" + $("#searchOpB :selected").val()
  deb "price/year:"+ $("#price :selected").val() + "/" + $("#year :selected").val()

