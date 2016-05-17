# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create! movie
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  content = page.body
  content.index(e1).should <= content.index(e2) if content.include?(e1) & content.include?(e2)
  fail "First or second movie not found" if !(content.include?(e1) & content.include?(e2))
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  if (uncheck)
    rating_list.split(/\, /).each do |rate|
      single_rating = "ratings_" + rate
      uncheck(single_rating)
    end
  else
    rating_list.split(/\, /).each do |rate|
      single_rating = "ratings_" + rate
      check(single_rating)
    end
  end
end

Then /I should see all the movies/ do 
  # Make sure that all the movies in the app are visible in the table
  page.all('table#movies tbody tr', :count => 10)
end


Then /I should\s*(not)? see the following movies: (.*)/ do |negative, movie_list|
  movie_list.split(',').each do |movie|
    step %{I should#{negative ? " not" : ""} see "#{movie}"}
  end
end


Then(/^the director of "(.*?)" should be "(.*?)"$/) do |title, director|
   Movie.where("title = ? AND director = ?", title, director).length > 0
   # express the regexp above with the code you wish you had
end
