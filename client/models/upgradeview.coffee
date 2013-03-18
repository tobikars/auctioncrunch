root.Template.upgradeview.events = "click .btn-upgrade": (e)->
  btn = e
  btn.preventDefault()
  $(".upgrade-msg").hide()
  $(".btn-upgrade").hide()
  $(".upgradeForm").hide()
  $(".upgrade-spinner").show()
  Meteor.call "upgradeAccount", $(".upgradeForm #email").val(), $(".upgradeForm #username").val(), (err) ->
    if err 
      deb "Error: " + err.reason
      errorTag $(".upgrade-msg"), err.reason
      $(".upgrade-msg").show()
      $(".btn-upgrade").show()
      $(".upgradeForm").show()
    else 
      deb "upgrade success!"
      Session.set 'page_id', "search"
      navSet "search"
      Router.navigate "search", false
    $(".upgrade-spinner").hide()

root.Template.upgradeview.email = () ->
  return Meteor.user()?.emails?[0]?.address
