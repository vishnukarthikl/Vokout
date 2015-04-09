# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@DashboardCtrl = ($scope, $resource, $http) ->
  $scope.latestSubscription = (member)->
    member.subscriptions.reduce((latestSubscription, currentSubscription) ->
      if currentSubscription.days_left > latestSubscription.days_left
        currentSubscription
      else
        latestSubscription
    , member.subscriptions[0])

  $scope.subscriptionExpired = (member) ->
    $scope.latestSubscription(member).days_left <= 0

  $scope.orderBySubscriptionExpiry = (member) ->
    $scope.latestSubscription(member).days_left

@DashboardOverviewCtrl = ($scope, $resource, $http) ->
  $scope.refreshData = ->
    $http.get('/facilities/show')
    .success (data) ->
      $scope.facility = data
    .error (data, status, headers, config) ->
      console.log(status)

  $scope.refreshData()
  $scope.currentMonthRevenue = () ->
    if $scope.facility
      this_month = moment().format("MMMM YYYY")
      $scope.facility.revenues.monthly_revenue[this_month]

@DashboardMembersCtrl = ($scope, $resource, $http, $modal, $window, memberService) ->
  $scope.refreshData = ->
    $http.get('/facilities/show')
    .success (data) ->
      $scope.facility = data
    .error (data, status, headers, config) ->
      console.log(status)

  $scope.refreshData()


  $scope.renew = (member) ->
    modalInstance = $modal.open({
      templateUrl: 'renewMembership.html',
      controller: RenewCtrl,
      scope: $scope,
      size: 'md',
      resolve:
        memberToRenew: -> member
        memberships: -> $scope.facility.memberships
    })
    modalInstance.result.then((renewedMember) ->
      $scope.refreshData()
      $scope.renewStatus = renewedMember.name + " was renewed successfully"
    )

  $scope.deactivate = (member) ->
    memberService.get({facility_id: member.facility_id, id: member.id}, (data) ->
      member = data
      member.inactive = true
      member.$update((data) ->
        $scope.refreshData()
        $scope.renewStatus = member.name + " was deactivated"
      )
    )

  $scope.filterMembers = (name, showInactive) ->
    (member) ->
      return member.name.toLowerCase().indexOf(name.toLowerCase()) isnt -1 and (!member.inactive or (member.inactive and showInactive))



RenewCtrl = ($scope, $modalInstance, memberToRenew, memberships, memberService) ->
  $scope.renewMembership = {}
  $scope.renewMembership.start_date = moment().format('DD/MM/YYYY')

  $scope.submitRenewal = ->
    newSubscription = {membership_id: memberToRenew.membership_id, start_date: $scope.renewMembership.start_date}
    memberService.get({facility_id: memberToRenew.facility_id, id: memberToRenew.id}, (data) ->
      member = data
      member.subscriptions.push(newSubscription)
      member.$update((data) ->
        $modalInstance.close(member)
      )
    )

  $scope.cancel = ->
    $modalInstance.dismiss('cancel')
