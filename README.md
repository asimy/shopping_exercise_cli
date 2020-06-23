### A toy project CLI which allows a user to enter a list of shopping items and returns an itemized bill.

#### Installation, testing and running it

On a Linux or MacOS system with Ruby 2.7.x installed

1. Clone the repository 
2. cd into the directory
3. (optionally) run `bundle install`
4. (also optionally) run `rspec` to make sure tests are passing
5. run `./user_interface.rb` or `ruby user_interface.rb`
6. You can enter a comma separated list of items (see limit below), repeating any given item as many times as you'd
   like. Repeating an item ups the quantity of those items that you purchase.
7. Hit return when you're done with your list and the app will display a bill based on the current prices and sales


*Known limitations*:
This is a _really_ long list, but one of the highlights is that it only recognizes 4 items out-of-the-box (milk, bread,
banana and apple). You can add more items by adding additional entries to the price_list in user_interface. Another
limitation is that documentation is pretty much non-existent, but "the code is the documentation"?
