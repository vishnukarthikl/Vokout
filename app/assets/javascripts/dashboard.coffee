# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@DashboardCtrl = ($scope, $resource, $http, memberService) ->
  $scope.refreshData = ->
    $http.get('/facilities/show')
    .success (data) ->
      $scope.facility = data
    .error (data, status, headers, config) ->
      console.log(status)

  $scope.renew = (member)->
    $scope.$parent.renewModalResult(member, $scope.facility.memberships).then((renewedMember)->
      $scope.result = renewedMember.name + " was renewed successfully"
      $scope.refreshData()
    )

  $scope.activate = (member) ->
    memberService.get({facility_id: $scope.facility.id, id: member.id},
      (member) ->
        $scope.$parent.changeInactiveStateTo(member, false).then((member)->
          $scope.result = member.name + " was activated"
          $scope.refreshData()
        )
    )

  $scope.deactivate = (member) ->
    memberService.get({facility_id: $scope.facility.id, id: member.id},
      (member) ->
        $scope.$parent.changeInactiveStateTo(member, true).then((member)->
          $scope.result = member.name + " was deactivated"
          $scope.refreshData()
        )
    )


@DashboardOverviewCtrl = ($scope, $resource, $http) ->
  $scope.refreshData = ->
    $http.get('/facilities/show')
    .success (data) ->
      $scope.facility = data
      $scope.revenueData = $scope.getRevenueByMonth()
    .error (data, status, headers, config) ->
      console.log(status)

  $scope.refreshData()
  $scope.currentMonthRevenue = () ->
    if $scope.facility
      this_month = moment().format("MMMM YYYY")
      $scope.facility.revenues.monthly_revenue[this_month]

  $scope.generateMonths = ->
    [0..$scope.showRevenueForMonths].map ((i)->
      moment().subtract(i, 'month').format("MMMM YYYY")
    )

  $scope.$watch('showRevenueForMonths', () ->
    $scope.revenueData = $scope.getRevenueByMonth()
  )

  $scope.getRevenueByMonth = ->
    if $scope.facility
      revenueByMonth = $scope.generateMonths().map ((month)->
        revenueThatMonth = $scope.facility.revenues.monthly_revenue[month]
        if !revenueThatMonth
          revenueThatMonth = 0
        return {
        month: month
        value: revenueThatMonth
        }
      )
      labels = revenueByMonth.map((r) ->
        r.month
      )
      data = revenueByMonth.map((r)->
        r.value
      ).reverse()
      datasets = []
      datasets[0] = {
        label: "Revenue",
        fillColor: "#337ab7",
        data: data
      }
      return {
      labels: labels
      datasets: datasets
      }

@DashboardMembersCtrl = ($scope, $resource, $http, $modal, $window) ->
  $scope.refreshData()