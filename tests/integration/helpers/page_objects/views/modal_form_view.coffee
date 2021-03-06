PageObject = require("./../../page_object")

class FormFieldView extends PageObject

  clear: -> @el.clear()
  sendKeys: (keys) -> @el.sendKeys(keys)

  hasError: -> @hasClass "ng-invalid"

  setValue: (value) ->
    @clear()
    @sendKeys(value)

    # hide all unnecessary elements like popups, pickers, dropdowns etc.
    @sendKeys(protractor.Key.ESCAPE)

  getValue: ->
    @getAttribute("value")

  @has "error", ->
    @element @By.xpath(".//..//span[contains(@class, 'help-inline')]")

class ModalFormView extends PageObject

  # dialog elements

  @has "header", ->
    @element @By.css(".modal-header h3")

  @has "form", ->
    @element @By.css("form[name='editForm']")

  # form elements

  @has "submitButton", ->
    @form.element @By.css("button[type=submit]")

  @has "deleteButton", ->
    @form.element @By.css("button.ag-delete-button")

  # custom methods

  # Find field by model name
  findField: (model) ->
    field = @form.element @By.model(model)
    new FormFieldView(field)

  setFieldValue: (model, value) ->
    field = @findField(model)
    field.setValue(value)

  getFieldValue: (model) ->
    field = @findField(model)
    field.getValue()

  # Submit the form
  submit: ->
    @submitButton.click()

  # Fill in the form fields
  fillIn: (fields = {}) ->
    @setFieldValue(name, value) for name, value of fields

  # Fill in the form with given values and submit the form
  fillInAndSubmit: (fields = {}) ->
    @fillIn(fields)
    @submit()

module.exports = ModalFormView
