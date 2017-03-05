import './app.ng.coffee'

Router = ($stateProvider, $urlRouterProvider, $locationProvider) ->
  $stateProvider
  .state('layout',
    abstract: true
    templateUrl: 'client/layout/layout.html'
    controller: 'LayoutCtrl'
  )
  .state('main',
    url: '/'
    templateUrl: 'client/main/main.html'
    controller: 'MainCtrl'
    parent: 'layout'
  )
  .state('login',
    url: '/login'
    templateUrl: 'client/login/login.html'
    controller: 'LoginCtrl'
    parent: 'layout'
  )
  .state('register',
    url: '/register'
    templateUrl: 'client/register/register.html'
    controller: 'RegisterCtrl'
    parent: 'layout'
  )
  .state('play',
    url: '/play/:id'
    templateUrl: 'client/play/play.html'
    controller: 'PlayCtrl'
    parent: 'layout'
  )

  $urlRouterProvider.otherwise('/');

  $locationProvider.html5Mode(
    enabled: true
  )

app.config(['$stateProvider', '$urlRouterProvider', '$locationProvider', Router])