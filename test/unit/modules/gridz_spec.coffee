describe "angleGrinder.gridz", ->
  beforeEach module("angleGrinder.gridz")

  describe "directives", ->
    describe "agGrid", ->
      element = null
      gridz = null

      sampleGridOptions =
        data: []
        colModel: [
          name: "id"
          label: "Inv No"
          search: true
        ]

      beforeEach inject ($rootScope, $compile) ->
        $scope = $rootScope.$new()
        $scope.gridOptions = sampleGridOptions

        # create a spy on the gridz plugin
        gridz = spyOn($.fn, "gridz").andCallThrough()

        element = angular.element """
          <div ag-grid="gridOptions"></div>
        """

        $compile(element)($scope)
        $scope.$digest()

      it "passes valid options to the gridz plugin", ->
        expect(gridz).toHaveBeenCalledWith sampleGridOptions

      it "renders the grid", ->
        expect(element.find("div.ui-jqgrid").length).toEqual 1
        expect(element.find("table#grid").length).toEqual 1
        expect(element.find("div#gridPager").length).toEqual 1

    describe "match", ->
      formElement = null
      $scope = null
      form = null

      beforeEach inject ($rootScope, $compile) ->
        $scope = $rootScope.$new()
        formElement = angular.element """
          <form name="form">
            <input name="password" type="password"
                   ng-model="user.password" />
            <input name="passwordConfirmation" type="password"
                   ng-model="user.passwordConfirmation" match="user.password" />
          </form>
        """

        $compile(formElement)($scope)
        $scope.$digest()
        form = $scope.form

      describe "when the fileds are equal", ->
        beforeEach ->
          form.password.$setViewValue "password"
          form.passwordConfirmation.$setViewValue "password"
          $scope.$digest()

        it "marks the form as valid", ->
          expect(form.$valid).toBeTruthy()
          expect(form.$invalid).toBeFalsy()

        it "does not set errors on the input", ->
          expect(form.passwordConfirmation.$valid).toBeTruthy()
          expect(form.passwordConfirmation.$invalid).toBeFalsy()

      describe "when the fields are not equal", ->
        beforeEach ->
          form.password.$setViewValue "password"
          form.passwordConfirmation.$setViewValue "other password"
          $scope.$digest()

        it "marks the form as invalid", ->
          expect(form.$valid).toBeFalsy()
          expect(form.$invalid).toBeTruthy()

        it "sets the valid form errors", ->
          expect(form.$error).toBeDefined()
          expect(form.$error.mismatch[0].$name).toEqual "passwordConfirmation"

        it "sets the valid input errors", ->
          expect(form.passwordConfirmation.$valid).toBeFalsy()
          expect(form.passwordConfirmation.$invalid).toBeTruthy()
          expect(form.passwordConfirmation.$error.mismatch).toBeTruthy()

        it "sets errors on the field", ->
          expect(formElement.find("input[name=passwordConfirmation]")).toBeTruthy()

    describe "fieldGroup", ->
      element = null
      $scope = null
      form = null

      beforeEach inject ($rootScope, $compile) ->
        $scope = $rootScope.$new()

        element = angular.element """
          <form name="form" novalidate>
            <div class="control-group"
                 field-group for="email,password">
              <input type="text" name="email"
                     ng-model="user.email" required />
              <input type="password" name="password"
                     ng-model="user.password" required />
            </div>
          </form>
        """

        $compile(element)($scope)
        $scope.$digest()
        form = $scope.form

      describe "when one of the field is invalid", ->
        beforeEach ->
          form.email.$setViewValue "luke@rebel.com"
          form.password.$setViewValue ""
          $scope.$digest()

        it "marks the whole group as invalid", ->
          expect(form.$valid).toBeFalsy()
          expect(element.find(".control-group").hasClass("error")).toBeTruthy()

      describe "when all fields are valid", ->
        beforeEach ->
          form.email.$setViewValue "luke@rebel.com"
          form.password.$setViewValue "password"
          $scope.$digest()

        it "does not mark the group as invalid", ->
          expect(form.$valid).toBeTruthy()
          expect(element.find(".control-group").hasClass("error")).toBeFalsy()

    describe "validationMessage", ->
      element = null
      $scope = null
      form = null

      comlileTemplate = (template) ->
        beforeEach inject ($rootScope, $compile) ->
          $scope = $rootScope.$new()

          element = angular.element(template)

          $compile(element)($scope)
          $scope.$digest()
          form = $scope.form

      describe "when the validation message is provided", ->
        comlileTemplate """
          <form name="form" novalidate>
            <input type="password" name="password"
                   ng-model="user.password" required />
            <validation-error for="password"
                              required="Please fill this field" />
        """

        describe "when the field is invalid", ->
          beforeEach ->
            form.password.$setViewValue ""
            $scope.$digest()

          it "displays validation errors for the given field", ->
            expect(element.find("validation-error[for=password] span").text())
              .toEqual "Please fill this field"

        describe "when the field is valid", ->
          beforeEach ->
            form.password.$setViewValue "password"
            $scope.$digest()

          it "hides validation errors", ->
            expect(element.find("validation-error[for=password] span").text())
              .toEqual ""

      describe "when the validation messages is not provided", ->
        comlileTemplate """
          <form name="form" novalidate>
            <input type="password" name="password"
                   ng-model="user.password" required />
            <validation-error for="password" />
        """

        beforeEach ->
          form.password.$setViewValue ""
          $scope.$digest()

        it "uses the default validation message", ->
          expect(element.find("validation-error[for=password] span").text())
            .toEqual "This field is required"

  describe "services", ->

    describe "#editDialog", ->
      it "is defined", inject (editDialog) ->
        expect(editDialog).toBeDefined()

      describe "#open", ->
        beforeEach inject ($httpBackend) ->
          $httpBackend.whenGET("/views/some_template.html").respond({})

        it "opens the create dialog", inject (editDialog) ->
          item = name: "Foo"
          editDialog.open("/views/some_template.html", item)

    describe "defaultValidationMessages", ->
      messages = {}
      beforeEach inject (defaultValidationMessages) ->
        messages = defaultValidationMessages

      it "is defined", ->
        expect(messages).toBeDefined()

      it "has the default message for `required` validation", ->
        expect(messages.required).toEqual "This field is required"

      it "has the default message for `mismatch` validation", ->
        expect(messages.mismatch).toEqual "Does not match the confirmation"

      it "has the default message for `minlength` validation", ->
        expect(messages.minlength).toEqual "Too short"

    describe "#flatten", ->
      flatten = null
      beforeEach inject ($injector) ->
        flatten = $injector.get("flatten")

      it "is defined", ->
        expect(flatten).toBeDefined()

      it "flattens an object", ->
        target =
          id: 123
          consumer:
            firstName: "Luke"
            lastName: "Sywalker"
          createdAt: "2013-11-11"

        flattened = flatten(target)

        expect(flattened.id).toEqual target.id
        expect(flattened["consumer.firstName"]).toEqual target.consumer.firstName
        expect(flattened["consumer.lastName"]).toEqual target.consumer.lastName
        expect(flattened.createdAt).toEqual target.createdAt

    describe "#hasSearchFilters", ->
      describe "if filters contain at least one non-empty field", ->
        filters = foo: "  ", bar: "test", biz: null

        it "returns true", inject (hasSearchFilters) ->
          expect(hasSearchFilters(filters)).toBeTruthy()

      describe "if filters contains only empty fileds", ->
        filters = foo: "  ", bar: "", biz: null, baz: undefined

        it "returns false", inject (hasSearchFilters) ->
          expect(hasSearchFilters(filters)).toBeFalsy()
