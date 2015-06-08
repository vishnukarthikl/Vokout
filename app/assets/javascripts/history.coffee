@HistoryCtrl = ($scope, historyService) ->
  $scope.refreshData = () ->
  div = $('#data')[0]
  $scope.facility_id = div.getAttribute("data-facility-id")
  historyService.query({facility_id: $scope.facility_id}, (data) ->
    $scope.logs = data
  )

  $scope.formatDate = (date) ->
    moment(date).format('D/M/YYYY')

  $scope.logTypes = ['All', 'Addition', 'Renewal', 'Purchases', 'Activation', 'Deactivation','Extension']

  $scope.filterLogType = (logType) ->
    (log) ->
      if logType == 'All'
        true
      else if logType == 'Addition'
        'added' == log.description
      else if logType == 'Renewal'
        'renewed' == log.description
      else if logType == 'Purchases'
        'purchased' == log.description
      else if logType == 'Activation'
        'activated' == log.description
      else if logType == 'Deactivation'
        'deactivated' == log.description
      else if logType == 'Extension'
        'extended' == log.description
      else
        false