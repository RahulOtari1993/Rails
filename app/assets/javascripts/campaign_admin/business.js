$(document).on("turbolinks:load", function () {
  var form = $(".business-wizard");

  var stepsWizard = $(".business-wizard").steps({
    headerTag: "h6",
    bodyTag: "fieldset",
    transitionEffect: "fade",
    enableKeyNavigation: false,
    // suppressPaginationOnFocus: true,
    titleTemplate: '<span class="step">#index#</span> #title#',
    labels: {
      finish: "Submit",
    },
    onInit: function (event, currentIndex) {
      // if ($('.new_business_section').data('form-type') == 'edit') {
      //   $('.business-wizard').steps("next");
      // }
    },
    onStepChanging: function (event, currentIndex, newIndex) {
      // Disable Key Navigations for Quill Editor
      $("body").on("keydown", ".ql-editor", function (e) {
        let key = e.key; // Fetch the Key Event

        if (key == "ArrowRight" || key == "ArrowLeft") {
          return false;
        }
      });

      // Always allow previous action even if the current form is not valid!
      if ($(".new_business_section").data("form-type") == "edit") {
        // While Editing a Challenge Stop User to Jump on Step 1
        if (currentIndex == 1 && newIndex == 0) {
          return false;
        }
      }

      if (currentIndex == 1 && newIndex == 2) {
        if (
          $(".business-type-list.active").data("business-type") == "engage" &&
          ($(".business-type-list.active").data("business-parameters") ==
            "facebook" ||
            $(".business-type-list.active").data("business-parameters") ==
              "instagram")
        ) {
          console.log("SKIP THIS STEP");
          // $('#steps-uid-0-t-3').click();
          // stepsWizard.steps("next");
          // return;
        }
      }

      if (currentIndex == 3 && newIndex == 2) {
        if (
          $(".business-type-list.active").data("business-type") == "engage" &&
          ($(".business-type-list.active").data("business-parameters") ==
            "facebook" ||
            $(".business-type-list.active").data("business-parameters") ==
              "instagram")
        ) {
          console.log("SKIP THIS STEP");
          // $('.business-wizard').steps("previous");
          // return;
          // $('#steps-uid-0-t-1').click();
        }
      }

      if (currentIndex > newIndex) {
        return true;
      }

      return form.valid();
    },
    onFinishing: function (event, currentIndex) {
      return form.valid();
    },
    onFinished: function (event, currentIndex) {
      // Pass Quill Editor Details to Form
      var businessType = $("#business_business_type").val();
      var businessParameters = $("#business_parameters").val();

      if (
        $(`.${businessType}-${businessParameters}-div .question-wysiwyg-editor`)
          .length > 0
      ) {
        $(
          `.${businessType}-${businessParameters}-div .question-wysiwyg-editor`
        ).each(function (index) {
          if ($(this).hasClass("display-editor")) {
            $(
              `.details-question-wysiwyg-editor${$(this).data(
                "editor-identifire"
              )}`
            ).val(
              $(
                `.question-wysiwyg-editor${$(this).data(
                  "editor-identifire"
                )} .ql-editor`
              ).html()
            );
          }
        });
      }

      $(".business-wizard").submit();
    },
  });

  $("#business-list-table").DataTable({
    processing: true,
    paging: true,
    serverSide: true,
    responsive: false,
    ajax: {
      url:
        "/admin/campaigns/" +
        $("#business-list-table").attr("campaign_id") +
        "/businesses/fetch_businesses",
      dataSrc: "businesses",
      dataFilter: function (data) {
        var json = jQuery.parseJSON(data);
        return JSON.stringify(json);
      },
    },
    columns: [
      {
        class: "product-name",
        title: "Name",
        data: null,
        searchable: true,
        render: function (data, type, row) {
          return data.name;
        },
      },
      {
        title: "Logo",
        data: null,
        searchable: false,
        render: function (data, type, row) {
          html = "";
          html +=
            '<img src="' +
            data.logo["thumb"]["url"] +
            '" style="margin-left:25px;" class="table_image_thumb_size" />';
          return html;
        },
      },
      {
        class: "product-name",
        title: "Address",
        data: null,
        searchable: true,
        render: function (data, type, row) {
          return data.address;
        },
      },
      {
        class: "product-name",
        title: "Working Hours",
        data: null,
        searchable: true,
        render: function (data, type, row) {
          return data.working_hours;
        },
      },
    ],
    dom: '<"top"<"actions action-btns"B><"action-filters"lf>><"clear">rt<"bottom"<"actions">p>',
    oLanguage: {
      sLengthMenu: "_MENU_",
      sSearch: "",
    },
    aLengthMenu: [
      [5, 10, 15, 20],
      [5, 10, 15, 20],
    ],
    order: [[1, "asc"]],
    bInfo: false,
    pageLength: 10,
    // oLanguage: {
    //   sProcessing: "<div class='spinner-border' role='status'><span class='sr-only'></span></div>"
    // },
    aoColumnDefs: [{ bSortable: false, aTargets: [0] }],
    buttons: [
      {
        text: "<i class='feather icon-plus'></i> Add Business",
        action: function () {
          window.location.href =
            "/admin/campaigns/" +
            $("#business-list-table").attr("campaign_id") +
            "/businesses/new";
        },
        className:
          "btn btn-primary mr-sm-1 mb-1 mb-sm-0 waves-effect waves-light",
      },
    ],
    initComplete: function (settings, json) {
      $(".dt-buttons .btn").removeClass("btn-secondary");
      // $('.dataTables_filter').addClass('search-icon-placement');
    },
  });

  $(".business-tags-form").select2({
    placeholder: "Select Tags",
    tags: true,
    dropdownAutoWidth: true,
    width: "70%",
  });

  // Tags Selection With Auto Suggestion
  function initChallengeTagsSelect2() {
    $(".business-tags").select2({
      placeholder: "Select Tags",
      tags: true,
      dropdownAutoWidth: true,
      width: "50%",
    });
  }
});
