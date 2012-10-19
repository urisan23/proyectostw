function Valida_changepass( form ) {
  var b=/^[^@\s]+@[^@\.\s]+(\.[^@\.\s]+)+$/
  var message = '<div class="alert alert-error"><a class="close" data-dismiss="alert">×</a>';
  var ok = true;
  if (!b.test(form.email.value)) {
    message += '<span>El email introducido no es válido.</span><br/>';
    ok = false;
  } else {
    exist = false;
    for each (var email in emails_ar) {
      if ( form.email.value == email ) {
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
function Valida_signup( form ) {
  var b=/^[^@\s]+@[^@\.\s]+(\.[^@\.\s]+)+$/
  var message = '<div class="alert alert-error"><a class="close" data-dismiss="alert">×</a>';
  var ok = true;
  if (!b.test(form.email.value)) {
    message += '<span>El email introducido no es válido.</span><br/>';
    ok = false;
  }
  for each (var email in emails_ar) {
    if ( form.email.value == email ) {
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
  for each (var user in users_ar) {
    if ( form.username.value == user ) {
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

function Valida_login( opc ) {
  var message = '<div class="alert alert-error"><a class="close" data-dismiss="alert">×</a>';
  var ok = true;
  if (opc == "1") {
    message += '<span>La contraseña es incorrecta.</span><br/>';
    ok = false;
  }
  if (opc == "2") {
    message += '<span>El email introducido no está registrado.</span><br/>';
    ok = false;
  }
  if (opc == "3") {
    message += '<span>Se ha generado una nueva contraseña. La recibirá en su correo electrónico.</span><br/>';
    ok = false;
  }
  message += '</div>';
  if (!ok) {
    $('#alert_placeholder').html(message);
    return false;
  } else {
    return true;
  }
}

function cambia_color( element ) {
  var texto = /[a-zA-Z]/;
  var num = /[0-9]/;
  var sim = /[^0-9a-zA-Z]/;
  var level = 0;
  if ((texto.test(element.value)) && (element.value.length > 5)) level++;
  if ((num.test(element.value)) && (element.value.length > 5)) level++;
  if ((sim.test(element.value)) && (element.value.length > 5)) level++;
  if (level == 0) {
    element.style.color = "#3a87ad";
    element.style.borderColor = "#3a87ad";
    element.style.WebkitBoxShadow = "inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 6px #7ab5d3";
    element.style.MozBoxShadow = "inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 6px #7ab5d3";
    element.style.boxShadow = "inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 6px #7ab5d3";
  }
  if (level == 1) {
    element.style.color = "#b94a48";
    element.style.borderColor = "#953b39";
    element.style.WebkitBoxShadow = "inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 6px #d59392";
    element.style.MozBoxShadow = "inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 6px #d59392";
    element.style.boxShadow = "inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 6px #d59392";
  }
  if (level == 2) {
    element.style.color = "#c09853";
    element.style.borderColor = "#a47e3c";
    element.style.WebkitBoxShadow = "inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 6px #dbc59e";
    element.style.MozBoxShadow = "inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 6px #dbc59e";
    element.style.boxShadow = "inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 6px #dbc59e";
  }
  if (level == 3) {
    element.style.color = "#468847";
    element.style.borderColor = "#468847";
    element.style.WebkitBoxShadow = "inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 6px #7aba7b";
    element.style.MozBoxShadow = "inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 6px #7aba7b";
    element.style.boxShadow = "inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 6px #7aba7b";
  }
}
