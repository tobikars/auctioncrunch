# server
# loads the auctions from a set of json-files and inserts them into mongodb.
# assumes the following collections exist:
# - Auctions 
# - Regions
# - AuctionHouses
#
# set the clearAuctionsFlag to true to first remove all existing auctions from the DB. 
#
loadauctions = (clear) ->
  clearAuctionsFlag = clear # set to true to clear all auctions first.

  rawAuctionFiles = [
    {username: "tobi", filename: "data.json"}
  ]

  md5fields = [
    "auctionHouse"
    "title"
  ]

  keywordFields = [ 
    "description" 
    "title"
    "maker"
    "auctionHouse"
    "placeDate"
    "region"
  ]

  blacklist = [
    "THE"
    "ARE"
    "HAVE"
    "THEY"
    "THEM"
    "THEN"
    "THAN"
    "WITH"
    "WHAT"
    "AND"
    "BEFORE"
    "AFTER"
    "THERE"
  ]

  insertFile = (rawFile) ->
    fs = __meteor_bootstrap__.require('fs')   
    fs.readFile rawFile.filename, (err, data) =>
      if err
        deb "ERROR PROCESSING AUCTIONS for #{rawFile.username} from #{rawFile.filename} :  #{err}"
      else 
        parsedAuctions = JSON.parse data
        deb "PROCESSING:#{rawFile.filename} for #{rawFile.username}: #{parsedAuctions.length} records detected." 
        Fiber () -> 
          md5Codes = [] # hashcode per auction to prevent double entries
          # array to keep auctionHouses to prevent double entry (async)
          ahList = [] 
          regionList = [] 
          makerList = []
          Auctions.find({}).forEach (a) ->
            md5Codes.push a.md5
          newAuctionCount = 0;
          oldAuctionCount = 0;
          for a in parsedAuctions 
            do (a) ->
              # calculate md5 for double-entry check
              a.md5 = make_md5 md5fields, a
              #skip record if md5 already in the database
              if a.md5 in md5Codes 
                  oldAuctionCount++
              if a.md5 not in md5Codes
                do (a) ->
                  newAuctionCount++

                  m = Makers.findOne {"name": a.maker}
                  if m
                    Makers.update m._id, {$set: { "auctionCount":  m.auctionCount + 1}}
                  else 
                    if a.maker not in makerList
                      makerList.push a.maker
                      Makers.insert 
                        "name": a.maker,
                        "auctionCount": 1

                  # check if the region exist, if so, update the count if not, add the region
                  r = Regions.findOne {"name": a.region}
                  if r
                    Regions.update r._id, {$set: { "auctionCount":  r.auctionCount + 1}}
                  else 
                    if a.region not in regionList
                      regionList.push a.region
                      Regions.insert 
                        "name": a.region,
                        "auctionCount": 1

                  ah = AuctionHouses.findOne {"name": a.auctionHouse.name}
                  if ah
                    AuctionHouses.update ah._id, {$set: { "auctionCount": (ah.auctionCount + 1)}}
                  else
                    if a.auctionHouse.name not in ahList
                      ahList.push a.auctionHouse.name # store before going into async insert.
                      deb "pushed #{ahList.length})" +  a.auctionHouse.name
                      AuctionHouses.insert 
                        "name": a.auctionHouse.name,
                        "url": a.auctionHouse.URL,
                        "country": a.auctionHouse.country,
                        "auctionCount": 1

                  # add the just-inserted md5 to the md5codes to check.
                  md5Codes.push a.md5                  
                  #deb "inserting #{a.title}:"
                  Auctions.insert (buildAuction a, rawFile)

          deb "PROCESSED #{rawFile.filename} for #{rawFile.username} ."
          deb "Auctions processed: #{parsedAuctions.length}, inserted #{newAuctionCount}, skipped #{oldAuctionCount}." 
        .run()

  buildAuction = (a, rawFile) ->
    # set the source so we know from which file the entry came
    a.sourceName = rawFile.username 
    a.user = rawFile.username
    a.sourceFileName = rawFile.filename
    a.dateLoaded = Date.now()
    # detect currency, then fix amount to integer.
    a.estimateCurrency = detectCurrency a.estimateAmountLow
    a.estimateAmountLow = fixAmount a.estimateAmountLow     
    if(a.estimateCurrency is "UNKNOWN") 
      deb "ERROR UNKNONW CURRENCY: #{a.estimateCurrency} " + a.estimateAmountLow + " from #{a.estimateAmountHigh} // #{a.dateTime} // #{a.title} "                 
    #extract date if available
    a.mapYear = detectYear a.placeDate                    
    # extract all keywords from description and title etc. as listed in keywordFields
    a.keywords = extractKeywords keywordFields, a, blacklist
    return a

  if clearAuctionsFlag
    deb "purging db, removing all entries." 
    Auctions.remove {} 
    Regions.remove {}  
    AuctionHouses.remove {}
  else 
    deb "not purging db, updating entries."  
  
  insertFile rawFile for rawFile in rawAuctionFiles
