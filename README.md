
- A simple tableview with SearchBar. Use the fields: title, author, publisher, contributor, description only from the response to populate the tableview.
- SearchBar allows to search in the current list (no network request, search only on already cached books list). User should be able to search by any of the parameters listed in table view i.e.: book title, author, publisher etc.
- Change Date option on right navigation bar item to change the date.
 
Functionality
- As soon as user lands on book list view, make an API request to fetch the books from the API for today.
- Changing the date will make the request to API.
- The search bar allows to search in already fetched books list (search in already cached book list).
