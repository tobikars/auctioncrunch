root.Template.searchresults.auctionsCount = ->
  Session.get "auctionsCount"

root.Template.searchresults.activePage = ->
  Session.get "page" 

root.Template.searchresults.query = ->
  res = "for query <strong>'#{Session.get "searchTextA"} / #{Session.get "searchTextB"}'</strong>"

root.Template.searchresults.pageList = ->
  res = []   
  p = Session.get "page"
  pcount = Session.get "pages"
  p1 = p-10
  p1 = 1 if p1<1
  p2 = p+10
  p2 = pcount if p2 > pcount 
  res.push "<<" if pcount > 1
  res.push i for i in [p1..p2] by 1
  res.push ">>" if pcount > 1
  return res

root.Template.searchresults.pageListStart = ->
  return '(no results found)' if +(Session.get "pages") < 1

root.Template.pagelink.isActivePage = () ->
  return " active" if +(this) is Session.get "page"

root.Template.searchresults.events = "click .pagelink": (event) ->
  p = Session.get "page"
  goto = $(event.target).attr("id")
  goto = p-1 if goto is "<<" and p>1
  goto = p+1 if goto is ">>" and p<Session.get "pages"
  goto = +(goto)
  Session.set "page", goto 
  deb "activepage: " + Session.get "page"
  return false