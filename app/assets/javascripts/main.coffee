vorkoutjs = angular.module('vorkoutjs', ['ngResource', 'angularUtils.directives.dirPagination'])
.controller('SetupCtrl', @SetupCtrl)
.controller('MembersCtrl', @MembersCtrl)
.factory('member', ($resource) ->
  $resource('/facilities/:facility_id/members/:id', {facility_id: "@facility_id", id: "@id"}, isArray: true)
)
.config ["$httpProvider", ($httpProvider) ->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
  $httpProvider.defaults.headers.common.Accept = 'application/json'
]
.config ["paginationTemplateProvider", (paginationTemplateProvider) ->
  paginationTemplateProvider.setPath('assets/angular-utils-pagination/dirPagination.tpl.html')
]