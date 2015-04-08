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
      $scope.calculateMembershipStats()
    .error (data, status, headers, config) ->
      console.log(status)

  $scope.refreshData()
  colors = ['#5DA5DA', '#FAA43A', '#60BD68', '#DECF3F', '#F15854', '#9e9ac8']

  $scope.calculateMembershipStats = ->
    data = {}
    i = 0
    $scope.facility.members.map((x) ->
      membership = $scope.latestSubscription(x).membership.name
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
      animationEasing : "easeInQuint",
      showTooltips: true
    }

@DashboardMembersCtrl = ($scope, $resource, $http, $modal, $window) ->
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

RenewCtrl = ($scope, $modalInstance, memberToRenew, memberships, memberService) ->
  $scope.member = memberToRenew
  $scope.memberships = memberships
  $scope.renewMembership = {}
  $scope.renewMembership.start_date = moment().format('DD/MM/YYYY')

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
