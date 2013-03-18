root.Template.registermodal.events = {
  "click .btn-register": (e)->
    btn = e
    btn.preventDefault()
    email = $(".registerForm #email").val()
    password1 = $(".registerForm #password1").val()
    password2 = $(".registerForm #password2").val()
    deb "creating user:"
    $(".registerForm").hide()
    $(".register-msg").hide()
    $(".btn-register").hide()
    $(".register-spinner").show()
    Meteor.call "createACuser", {email: email, password1: password1, password2: password2}, (err, res) ->
      if err
        deb "user creation error: " + err.error + ": " + err.reason
        errorTag $(".register-msg"), err.reason
        $(".registerForm").show()
        $(".register-msg").show()
        $(".btn-register").show()

      if res 
        deb "user created: " + res 
        $(".registerForm").hide()
        successTag $(".register-msg"), res
        $(".register-msg").show()

      $(".register-spinner").hide()
  # after registration verification, the below html is injected into the page: 
  #    <div class="accounts-dialog accounts-centered-dialog">
  #        Email verified
  #        <div class="login-button" id="just-verified-dismiss-button">
  #            Dismiss
  #        </div>
  #    </div>
  # the below handles the "closing of the dialog."
  "click #just-verified-dismiss-button": (e)->
    $(".accounts-dialog").hide()
}

