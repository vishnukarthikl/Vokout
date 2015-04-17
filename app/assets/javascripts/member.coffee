@MemberCtrl = ($scope, memberService, $modal, membershipService) ->
  $scope.subscriptionExpired = (member) ->
    member.latest_subscription.expired if member

  $scope.orderBySubscriptionExpiry = (member) ->
    member.latest_subscription.days_left if member

  $scope.deactivated = (member) ->
    member.inactive if member

  $scope.changeInactiveStateTo = (member, inactive) ->
    member.inactive = inactive
    member.$update()

  $scope.refreshData = () ->
    div = $('#data')[0]
    $scope.facility_id = div.getAttribute("data-facility-id")
    $scope.member_id = div.getAttribute("data-member-id")
    memberService.get({facility_id: $scope.facility_id, id: $scope.member_id}, (data) ->
      $scope.member = data
    )
    membershipService.query({facility_id: $scope.facility_id}, (data) ->
      $scope.memberships = data
    )

  $scope.activate = (member) ->
    $scope.changeInactiveStateTo(member, false).then((member)->
      $scope.renewStatus = member.name + " was activated"
    )

  $scope.deactivate = (member) ->
    $scope.changeInactiveStateTo(member, true).then((member)->
      $scope.renewStatus = member.name + " was deactivated"
    )

  $scope.renew = (member, memberships) ->
    if !memberships
      memberships = $scope.memberships

    $scope.renewModalResult(member, memberships).then((renewedMember) ->
      $scope.member = renewedMember
      $scope.renewStatus = renewedMember.name + " was renewed successfully"
    )

  $scope.renewModalResult = (member, memberships) ->
    modalInstance = $modal.open({
      templateUrl: 'renewMembership.html',
      controller: RenewCtrl,
      scope: $scope,
      size: 'md',
      resolve:
        memberToRenew: -> member
        memberships: -> memberships
    })
    modalInstance.result

  $scope.filterMembers = (name, showInactive) ->
    (member) ->
      member.name.toLowerCase().indexOf(name.toLowerCase()) isnt -1 and (!member.inactive or (member.inactive and showInactive))



RenewCtrl = ($scope, $modalInstance, memberToRenew, memberships, memberService) ->
  $scope.member = memberToRenew
  $scope.memberships = memberships
  $scope.renewMembership = {}
  $scope.renewMembership.membership_id = memberToRenew.latest_subscription.membership.id

  if memberToRenew.latest_subscription
    $scope.renewMembership.start_date = moment(memberToRenew.latest_subscription.end_date).add(1,
      'days').format('DD/MM/YYYY')
  else
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
