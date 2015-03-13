# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@DashboardOverviewCtrl = ($scope, $resource, $http) ->
  $http.get('/setupstatus')
  .success (data) ->
    $scope.facility = data
    $scope.calculateMembershipStats()
  .error (data, status, headers, config) ->
    console.log(status)

  colors = ['#5DA5DA', '#FAA43A', '#60BD68', '#DECF3F', '#F15854', '#9e9ac8']
  $scope.calculateMembershipStats = ->
    data = {}
    i = 0
    $scope.facility.members.map((x) ->
      membership = x.subscriptions[0].membership.name
      if membership of data
        data[membership].value += 1
      else
        data[membership] = {}
        data[membership].label = membership
        data[membership].value = 1
        data[membership].color = colors[i]
        i += 1
    )
    $scope.membershipStats = data
    $scope.chartOptions =
    {
      multiTooltipTemplate: "<%= label %> (<%= (value) %>)",
      onAnimationComplete: ->
        @.showTooltip(@segments, true);
      tooltipEvents: [],
      showTooltips: true
    }

@DashboardMembersCtrl = ($scope, $resource, $http) ->
  $http.get('/setupstatus')
  .success (data) ->
    $scope.facility = data
  .error (data, status, headers, config) ->
    console.log(status)