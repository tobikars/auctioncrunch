class Filter
  _s1 : ""
  _s1OP : "OR"
  _s2 : ""
  _s2OP : "OR"
  _year : {}
  _price : {}
    
  buildFilter : ->
    textsearch = [{},{}]

    list = @_s1.toUpperCase().trim().split " "
    if list[0] isnt ""
      textsearch[0] = {keywords: {$in: list}} if @_s1OP is "OR"
      textsearch[0] = {keywords: {$all: list}} if @_s1OP is "AND"
    
    list2 = @_s2.toUpperCase().trim().split " "
    if list2[0] isnt "" 
      textsearch[1] = {keywords: {$in: list2}} if @_s2OP is "OR"
      textsearch[1] = {keywords: {$all: list2}} if @_s2OP is "AND"
    
    return { $and: [textsearch[0], textsearch[1] , @_year, @_price] }

  constructor: ( opts ) ->
    @_s1 = opts.search1 if opts.search1
    @_s1OP = opts.op1 if opts.op1
    @_s2 = opts.search2 if opts.search2
    @_s2OP = opts.op2 if opts.op2
    @_year = {mapYear:{$lt: opts.year }} if opts.year 
    @_price = {estimateAmountLow:{$lt: opts.price }} if opts.price
    #deb "req:" + JSON.stringify(@buildFilter())

getFilter = () ->
  return new Filter({
    search1: (Session.get "searchTextA"),
    op1: (Session.get "searchOpA"),
    search2: (Session.get "searchTextB"),
    op2: (Session.get "searchOpB"),
    year: (Session.get "searchYear"),
    price: (Session.get "searchPrice"),
    page: (Session.get "page"), 
    pagesize: (Session.get "pageSize") 
  }).buildFilter()

getFilterJSON = () ->
  return {
    search1: (Session.get "searchTextA"),
    op1: (Session.get "searchOpA"),
    search2: (Session.get "searchTextB"),
    op2: (Session.get "searchOpB"),
    year: (Session.get "searchYear"),
    price: (Session.get "searchPrice"),
    page: (Session.get "page"), 
    pagesize: (Session.get "pageSize") 
  }