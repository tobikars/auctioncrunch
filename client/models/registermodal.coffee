root.Template.registermodal.events = "click .btn-register": (e)->
    btn = e
    btn.preventDefault()
    email = $(".registerForm #email").val()
    password1 = $(".registerForm #password1").val()
    password2 = $(".registerForm #password2").val()
    deb "creating user:"
    $(".registerForm").hide()
    $(".btn-register").hide()
    $(".register-spinner").show()
    Meteor.call "createACuser", {email: email, password1: password1, password2: password2}, (err, res) ->
      if err
        deb "user creation error: " + err.error + ": " + err.reason
        errorTag $(".register-msg"), err.reason
        $(".registerForm").show()
        $(".btn-register").show()

      if res 
        deb "user created: " + res 
        $(".registerForm").hide()
        successTag $(".register-msg"), res
      $(".register-spinner").hide()

errorTag = (target, err) ->
  $(target).addClass("alert alert-error")
  $(target).html '<i class="icon-thumbs-down icon-large"></i> ' + err

successTag = (target, msg) ->
  $(target).removeClass("alert-error").addClass("alert alert-success")
  $(target).html '<i class="icon-thumbs-up icon-large"></i> ' + msg
