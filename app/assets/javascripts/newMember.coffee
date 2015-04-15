@NewMemberCtrl = ($scope, $resource, $http, memberService, $modal) ->
  $http.get('/facilities/show')
  .success (data) ->
    $scope.facility = data
    $scope.setupMember()
  .error (data, status, headers, config) ->
    console.log(status)


  $scope.getMembersPhone = ->
    if $scope.facility and $scope.facility.members
      $scope.facility.members.map((x)-> x.phone_number)
    else
      []

  $scope.setupMember = () ->
    $scope.memberForm.$setUntouched()
    $scope.newMember = {}
    $scope.newMember.subscription = {}
    $scope.newMember.subscription.start_date = moment().format('DD/MM/YYYY')

  $scope.open = ($event, opened) ->
    $event.preventDefault();
    $event.stopPropagation();
    $scope[opened] = true;

  $scope.clear = () ->
    $scope.newMember.subscription.start_date = null;


  $scope.saveMember = (memberForm) ->
    $scope.newMember.facility_id = $scope.facility.id
    memberToSave = new memberService $scope.newMember
    memberToSave.$save afterMemberSave(memberToSave, memberForm), memberSaveFailureCallback


  afterMemberSave = (memberToSave, memberForm) ->
    () ->
      if memberToSave.id?
        addNewMember(memberToSave)
        showModalWithStatus(memberStatus(memberToSave.name + ' was successfully added.', 'success'))


  addNewMember = (memberToSave) ->
    $scope.facility.members = [] if !$scope.facility.members
    $scope.facility.members.push(memberToSave)

  memberStatus = (status, type) ->
    $scope.newMemberStatus = {text: status, style: type}

  memberSaveFailureCallback = (err) ->
    console.log(err)
    reason = prettyError(err)
    status = "save failed"
    status += ": " + reason if reason
    showModalWithStatus(memberStatus(status, 'danger'))

  prettyError = (err) ->
    result = ""
    for own key, value of err.data
      result += "(" + key + ")  " + value

  showModalWithStatus = (status) ->
    modalInstance = $modal.open({
      templateUrl: 'saveMemberStatus.html',
      controller: saveMemberStatusCtrl,
      scope: $scope,
      size: 'md',
      resolve:
        status: -> status
    })

    modalInstance.result.then((action) ->
      if action == 'add'
        $scope.setupMember()
    )

saveMemberStatusCtrl = ($scope, $modalInstance, status) ->
  $scope.status = status

  $scope.retry = ->
    $modalInstance.dismiss('retry')

  $scope.addAnother = ->
    $modalInstance.close('add')

