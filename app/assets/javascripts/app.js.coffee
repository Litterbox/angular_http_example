# Define App and dependencies
BookApp = angular.module("BookApp", ["ngRoute"])

# Setup the angular router
BookApp.config ["$routeProvider", "$locationProvider", ($routeProvider, $locationProvider)->
  $routeProvider
    .when "/books",
      templateUrl: "/books_templates/index",
      controller: "BooksCtrl"
    .when "/books/:id",
      templateUrl: "/books_templates/show",
      controller: "BookDetailsCtrl"
    .otherwise
      redirectTo: "/books"

  $locationProvider.html5Mode(true)
]

# Books Controller
BookApp.controller "BooksCtrl", ["$scope", "$http", ($scope, $http) ->

  $scope.books = []
  $scope.wrong = true;

  $scope.getBooks = ->
    $http.get("/books.json").success (data)->
      $scope.books = data

  $scope.addBook = ->
    $http.post("/books.json", $scope.newBook).success (data)->
      $scope.newBook = {}
      $scope.books.push(data)

  $scope.deleteBook = ->
    conf = confirm "Are you sure?"
    if conf
      $http.delete("/books/#{@book.id}.json").success (data)=>
        $scope.books.splice(@$index,1)

  $scope.getEditForm = ->
    $http.get("/books/#{@book.id}.json").success((data)->
      $scope.title = data.title
      $scope.author = data.author
      $scope.description = data.description
      )

  $scope.editBook =(book) ->
    this.checked = false
    $http.put("/books/#{@book.id}.json", book).success (data)->
]

# Define Config for CSRF token
BookApp.config ["$httpProvider", ($httpProvider)->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
]