root.Template.searchview.loginMessage = ->
  if not Meteor.user()
    return '<div class="alert alert-warning"><i class="icon-warning-sign"></i> you are not logged in yet. <a href="login">login here</a> or <a href="#" data-toggle="modal" data-target="#registerModal">register for an account</a></span></div>'
  else 
    email = Meteor.user()?.emails?[0]?.address
    if email
      return "<div class='alert alert-success'><i class='icon-ok'></i> you are logged in as #{email}</div>"

root.Template.titlesearch.searchTextA = ->
  Session.get "searchTextA"

root.Template.titlesearch.searchTextB = ->
  Session.get "searchTextB"   

root.Template.titlesearch.events = 
  "click .search": () ->
    setSearch()
    return false
  "click .reset": () ->
    $('#searchform')[0].reset()
    return false
  "keyup": (e) ->
    if e.which is 13
      setSearch()
      return false

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

