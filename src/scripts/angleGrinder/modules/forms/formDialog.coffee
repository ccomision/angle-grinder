forms = angular.module("angleGrinder.forms")

# Opens a modal dialog with embeded generic form for
# create or update an item
forms.factory "formDialog", [
  "$modal", "pathWithContext",
  ($modal, pathWithContext) ->

    open: (templateUrl, dialogOptions = {}) ->
      $modal.open
        templateUrl: pathWithContext(templateUrl)
        controller: "FormDialogCtrl"

        keyboard: false # do not close the dialog with ESC key
        backdrop: "static" # do not close on click outside of the dialog

        resolve:
          dialogOptions: -> dialogOptions
]