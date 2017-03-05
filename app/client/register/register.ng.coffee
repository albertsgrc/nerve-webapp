import '/client/app.ng.coffee'

RegisterCtrl = ($scope) ->
    $scope.albert = "Albert"

app.controller('RegisterCtrl', ['$scope', RegisterCtrl])