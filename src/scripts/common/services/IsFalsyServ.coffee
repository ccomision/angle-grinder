common = angular.module "angleGrinder.common"

# Returns true is the given string is null, undefined or empty ("")
common.value "isEmpty", (str) ->
  _.isString(str) and _.isEmpty(str)

# Returns true if the given values if falsy
common.service "IsFalsyServ", [
  "isEmpty", (isEmpty) ->
    (value) ->
      return true if _.isNaN(value)
      return true if isEmpty(value)
      return true if _.isNull(value)
      return true if _.isUndefined(value)
      return true if value is false

      return false
]