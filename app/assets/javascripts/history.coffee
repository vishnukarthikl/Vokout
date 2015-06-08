@HistoryCtrl = ($scope, historyService) ->
  $scope.refreshData = () ->
  div = $('#data')[0]
  $scope.facility_id = div.getAttribute("data-facility-id")
  historyService.query({facility_id: $scope.facility_id}, (data) ->
    $scope.logs = data
  )

  $scope.formatDate = (date) ->
    moment(date).format('D/M/YYYY')