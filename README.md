# Notes
Nokogiri and tzinfo-data gems were changed to make it run on my screen properly.


I never realized that reload never cleared instance vars on models, but I guess
that makes sense since that's part of ActiveRecord.


Rewind to commit d021d50c0005568dd7722d3e4501f69089840457 to see what this looked
like before I started adding things to begin using vue.

Adding vue and ajax-y interactions actually revealed a bug with how the state
association was getting cached.  Strangely wasn't getting picked up by any test,
but that might've been a result of reload calls in my tests. Though honestly, it would've
never been picked up on with the normal application, since the page reloads on update.