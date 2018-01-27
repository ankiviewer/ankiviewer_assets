var storedState = localStorage.getItem('av-search-save');
var startingState = storedState ? JSON.parse(storedState) : null;

var search_node = document.querySelector('#search');
var search_app = Elm.Search.embed(search_node, startingState);

search_app.ports.setStorage.subscribe(function(state) {
  localStorage.setItem('av-search-save', JSON.stringify(state));
});
