import angular from 'angular'
import angularMeteor from 'angular-meteor'
import uiRouter from 'angular-ui-router'
import ngMaterial from 'angular-material'
import ngMaterialDataTable from 'angular-material-data-table'
import 'angular/angular-csp.css'
import 'angular-material/angular-material.css'
import 'angular-material-data-table/dist/md-data-table.css'
import './lib/twilio-video'

DEPENDENCIES = [
    angularMeteor
    uiRouter
    ngMaterial
    ngMaterialDataTable
]

@app = angular.module('nerve', DEPENDENCIES)

styler = ($mdThemingProvider) ->
    $mdThemingProvider.theme('default')
        .primaryPalette('blue')
        .accentPalette('pink')

@app.config(['$mdThemingProvider', styler])