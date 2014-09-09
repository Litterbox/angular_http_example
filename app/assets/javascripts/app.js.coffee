# Define App and dependencies
BookApp = angular.module("BookApp", ["ngRoute", "templates"])

# Setup the angular router
BookApp.config ["$routeProvider", "$locationProvider", ($routeProvider, $locationProvider)->
  $routeProvider
    .when "/",
      templateUrl: "index.html",
      controller: "BooksCtrl"
  .otherwise
    redirectTo: "/"

  $locationProvider.html5Mode(true)
]

# Books Controller
BookApp.controller "BooksCtrl", ["$scope", "$http", ($scope, $http) ->

  $scope.books = []

  $scope.getBooks = ->
    $http.get("/books.json").success (data)->
      $scope.books = data

  $scope.addBook = ->
    $http.post("/books.json", $scope.newBook).success (data)->
      $scope.newBook = {}
      $scope.books.push(data)

  $scope.deleteBook = ->
    console.log(this.$index)
    conf = confirm "Are you sure?"
    if conf
      $http.delete("/books/#{this.book.id}.json").success (data)=>
        $scope.books.splice(this.$index,1)

  $scope.getEditForm = ->
    $http.get("/books/#{this.book.id}.json").success((data)->
      $scope.title = data.title
      $scope.author = data.author
      $scope.description = data.description
      )

  $scope.editBook =(book) ->
    this.checked = false
    $http.put("/books/#{this.book.id}.json", book).success (data)->
]

# Define Config for CSRF token
BookApp.config ["$httpProvider", ($httpProvider)->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
]