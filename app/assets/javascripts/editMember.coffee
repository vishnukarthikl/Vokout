@EditMemberCtrl = ($scope, $resource, $http, memberService, $modal) ->
  div = $('#data')[0]
  $scope.facility_id = div.getAttribute("data-facility-id")
  $scope.member_id = div.getAttribute("data-member-id")
  $scope.foo = "true"

  memberService.get({facility_id: $scope.facility_id, id: $scope.member_id}, (data) ->
    $scope.member = data
    $scope.member.is_male = "" + $scope.member.is_male if $scope.member
  )

  $scope.open = ($event, opened) ->
    $event.preventDefault();
    $event.stopPropagation();
    $scope[opened] = true;

  $scope.updateMember = ->
    $scope.member.$update afterMemberSave, memberSaveFailureCallback

  afterMemberSave = () ->
    showModalWithStatus(memberStatus($scope.member.name + ' was successfully updated.', 'success'), $scope.member)


  memberStatus = (status, type) ->
    $scope.memberStatus = {text: status, style: type}

  memberSaveFailureCallback = (err) ->
    console.log(err)
    reason = prettyError(err)
    status = "save failed"
    status += ": " + reason if reason
    showModalWithStatus(memberStatus(status, 'danger'), $scope.member)

  prettyError = (err) ->
    result = ""
    for own key, value of err.data
      result += "(" + key + ")  " + value

  showModalWithStatus = (status, member) ->
    modalInstance = $modal.open({
      templateUrl: 'editMemberStatus.html',
      controller: editMemberStatusCtrl,
      scope: $scope,
      size: 'md',
      resolve:
        status: -> status
        member: -> member
    })

editMemberStatusCtrl = ($scope, $modalInstance, status, member) ->
  $scope.status = status
  $scope.member = member

  $scope.retry = ->
    $modalInstance.dismiss('retry')

