// Trigger SWAL Notification
function swalNotify(title, message) {
  console.log("IN swalNotify")
  Swal.fire({
    title: title,
    text: message,
    confirmButtonClass: 'btn btn-primary',
    buttonsStyling: false
  });
}
