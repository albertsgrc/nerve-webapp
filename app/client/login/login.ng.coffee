import '/client/app.ng.coffee'

LoginCtrl = ($scope) ->
    $scope.albert = "Albert"
    console.log "login"

app.controller('LoginCtrl', ['$scope', LoginCtrl])