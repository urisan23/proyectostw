  function Valida_signup( form, emails_ar, users_ar ) {
    var b=/^[^@\s]+@[^@\.\s]+(\.[^@\.\s]+)+$/
    var message = '<div class="alert alert-error"><a class="close" data-dismiss="alert">×</a>';
    var ok = true;
    if (!b.test(form.email.value)) {
      message += '<span>El email introducido no es válido.</span><br/>';
      ok = false;
    }
    for (i=0;i<emails_ar.length;i++) {
      if ( form.email.value == emails_ar[i] ) {
        message += '<span>El email ya está en uso</span><br/>';
        ok = false;
      }
    }
    if (form.password.value != form.passwordconfirm.value) {
      message += '<span>Las contraseñas no coinciden.</span><br/>';
      ok = false;
    }
    if (form.password.value.length < 6) {
      message += '<span>La contraseña es muy corta.</span><br/>';
      ok = false;
    }
    if (form.username.value.length < 4) {
      message += '<span>El nombre de usuario es muy corto.</span><br/>';
      ok = false;
    }
    for (i=0;i<users_ar.length;i++) {
      if ( form.username.value == users_ar[i] ) {
        message += '<span>El nombre de usuario ya está en uso</span><br/>';
        ok = false;
      }
    }
    message += '</div>';
    if (!ok) {
      $('#alert_placeholder').html(message);
      return false;
    } else {
      return true;
    }
  } 
  
  function Valida_changepass( form ) {
    var b=/^[^@\s]+@[^@\.\s]+(\.[^@\.\s]+)+$/
    var message = '<div class="alert alert-error"><a class="close" data-dismiss="alert">×</a>';
    var ok = true;
    if (!b.test(form.email.value)) {
      message += '<span>El email introducido no es válido.</span><br/>';
      ok = false;
    } else {
      exist = false;
      for (i=0;i<emails_ar.length;i++) {
        if ( form.email.value == emails_ar[i] ) {
          exist = true;
        }
      }
      if ( exist == false ) {
        message += '<span>El email introducido no está registrado.</span><br/>';
        ok = false;
      }
    }
    message += '</div>';
    if (!ok) {
      $('#alert_placeholder').html(message);
      return false;
    } else {
      return true;
    }
  }