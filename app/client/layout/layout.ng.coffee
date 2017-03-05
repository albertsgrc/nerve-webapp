import '/client/app.ng.coffee'

LayoutCtrl = ($scope) ->
    $scope.albert = "Albert"

app.controller('LayoutCtrl', ['$scope', LayoutCtrl])