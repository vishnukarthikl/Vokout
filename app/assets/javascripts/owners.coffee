# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
vorkoutjs = angular.module('vorkoutjs',['ngResource'])
vorkoutjs.controller 'SetupCtrl', @SetupCtrl
vorkoutjs.config ["$httpProvider", ($httpProvider) ->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
  $httpProvider.defaults.headers.common.Accept = 'application/json'
]
