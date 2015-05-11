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

  $scope.getTotalActiveCustomers = (members) ->
    members.reduce((prev, curr) ->
      if !curr.inactive
        return prev + 1
      return prev
    , 0) if members

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
  colors = ['#5DA5DA', '#FAA43A', '#60BD68', '#DECF3F', '#F15854', '#9e9ac8']
  $scope.options = {
    segmentShowStroke: false,
    animateRotate: true,
    animateScale: false,
    percentageInnerCutout: 50,
  }

  $scope.refreshData = ->
    $http.get('/facilities/show')
    .success (data) ->
      $scope.facility = data
      $scope.revenueData = $scope.getRevenueByMonth()
      $scope.revenueSplitData = $scope.getRevenueSplit()
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

  $scope.getRevenueSplit = ->
    if $scope.facility
      revenue_split = $scope.facility.revenues.categorized_all
      i = -1
      for own key, value of revenue_split
        i = i + 1
        {
        value: value
        label: key
        color: colors[i]
        }


  $scope.getRevenueByMonth = ->
    if $scope.facility
      revenueByMonth = ($scope.generateMonths().map ((month)->
        revenueThatMonth = $scope.facility.revenues.monthly_revenue[month]
        if !revenueThatMonth
          revenueThatMonth = 0
        return {
        month: month
        value: revenueThatMonth
        }
      )).reverse()
      labels = revenueByMonth.map((r) ->
        r.month
      )
      data = revenueByMonth.map((r)->
        r.value
      )
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