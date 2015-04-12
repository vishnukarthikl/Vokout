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

  $scope.deactivated = (member) ->
    return member.inactive

  changeInactiveStateTo = (member, inactive) ->
    memberService.get({facility_id: member.facility_id, id: member.id}, (data) ->
      member = data
      member.inactive = inactive
      member.$update((data) ->
        $scope.refreshData()
        status = if inactive then "Deactivated" else "Activated"
        $scope.renewStatus = member.name + " was " + status
      )
    )

  $scope.activate = (member) ->
    changeInactiveStateTo(member, false)

  $scope.deactivate = (member) ->
    changeInactiveStateTo(member, true)

@DashboardOverviewCtrl = ($scope, $resource, $http) ->

  $scope.refreshData()
  $scope.currentMonthRevenue = () ->
    if $scope.facility
      this_month = moment().format("MMMM YYYY")
      $scope.facility.revenues.monthly_revenue[this_month]

@DashboardMembersCtrl = ($scope, $resource, $http, $modal, $window) ->

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

  $scope.filterMembers = (name, showInactive) ->
    (member) ->
      member.name.toLowerCase().indexOf(name.toLowerCase()) isnt -1 and (!member.inactive or (member.inactive and showInactive))



RenewCtrl = ($scope, $modalInstance, memberToRenew, memberships, memberService) ->
  $scope.member = memberToRenew
  $scope.memberships = memberships
  $scope.renewMembership = {}
  $scope.renewMembership.start_date = moment().format('DD/MM/YYYY')

  $scope.open = ($event) ->
    $event.preventDefault();
    $event.stopPropagation();
    $scope.opened = true;

  $scope.submitRenewal = ->
    newSubscription = {membership_id: $scope.renewMembership.membership_id, start_date: $scope.renewMembership.start_date}
    memberService.get({facility_id: $scope.member.facility_id, id: $scope.member.id}, (data) ->
      member = data
      member.subscriptions.push(newSubscription)
      member.$update((data) ->
        $modalInstance.close(member)
      )
    )

  $scope.cancel = ->
    $modalInstance.dismiss('cancel')
