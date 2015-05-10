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
  $scope.refreshData()
  $scope.currentMonthRevenue = () ->
    if $scope.facility
      this_month = moment().format("MMMM YYYY")
      $scope.facility.revenues.monthly_revenue[this_month]

@DashboardMembersCtrl = ($scope, $resource, $http, $modal, $window) ->
  $scope.refreshData()