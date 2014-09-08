# Define App and dependencies
BookApp = angular.module("BookApp", [
  "ngRoute"
])

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

# Books Contrrails oller
BookApp.controller "BooksCtrl", ["$scope", "$http", ($scope, $http) ->

  $scope.books = []

  $scope.getBooks = ->
    $http.get("/books.json").success (data)->
      $scope.books = data

  $scope.addBook = ->
    console.log $scope.newBook
    $http.post("/books.json", $scope.newBook).success (data)->
      console.log "BOOK SAVED!"
      $scope.newBook = {}
      $scope.books.push(data)

  $scope.deleteBook = ->
    console.log @book
    $http.delete("/books/#{@book.id}.json").success (data)=>
      console.log "book deleted"
      $scope.books.splice(@$index,1)
]

# BookDetailsCtrl
BookApp.controller "BookDetailsCtrl", ["$scope", "$http", "$routeParams", ($scope, $http, $routeParams)->
  $scope.book_id = $routeParams.id

  $http.get("/books/#{$scope.book_id}.json").success((data)->
    $scope.book = data
    $scope.new_title = data.title
    $scope.new_author = data.author
    $scope.new_description = data.description
    )

  $scope.editBook = ->
    $scope.checked = false
    $scope.book.title = $scope.new_title
    $scope.book.author = $scope.new_author
    $scope.book.description = $scope.new_description
    $http.put("/books/#{$scope.book_id}.json", $scope.book).success (data)->
]

# Define Config
BookApp.config(["$httpProvider", ($httpProvider)->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])