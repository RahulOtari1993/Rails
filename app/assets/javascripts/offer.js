$(document).on("turbolinks:load", function () {
  $("#server-side-table-offer").DataTable({
    lengthMenu: [5, 10, 15, 25, 50],
    ajax: {
      url: "/fetch_offers",
      dataSrc: "offers",
    },
    serverSide: true,
    pagination: true,
    info: false,
    columns: [
      { title: "Business", data: "business_name" },
      { title: "Title", data: "title" },
      { title: "Description", data: "description" },
      { title: "Start Time", data: "start" },
      { title: "End Time", data: "end" },
      {
        data: null,
        bSortable: false,
        mRender: function (data, type, full) {
          return (
            '<a class="btn btn-info btn-sm" href="/offers/' +
            data.id +
            "/edit" +
            '">' +
            "Edit" +
            "</a>"
          );
        },
      },
      {
        data: null,
        bSortable: false,
        mRender: function (data, type, full) {
          return (
            "<a class='btn btn-info btn-sm' href = '/offers/" +
            data.id +
            "data-confirm='Are you sure?' data-method='delete' data-toggle='tooltip' data-placement='top' data-original-title='Destroy Offers'>" +
            "Delete" +
            "</a>"
          );
        },
      },
    ],
    order: [["1", "desc"]],
  });
});
