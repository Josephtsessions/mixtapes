# Mixtapes

A JSON backed CLI tool for adding and deleting playlists/mixtapes for different users.

## Running it

You can run mixtapes from the project directory with:

```
bundle install
bundle exec ./mixtapes [input.json] [changes.json] [output_filename.json]
```

The provided json input is names "mixtape.json".

## Running the tests

You can run the unit tests from the top of the project with:

`bundle exec rspec`

## Scaling this up further

In a real production system, we'd likely be using a relational database for this instead of JSON backed data. That'd solve a ton of problems as I a lot of the complexity of the MixtapeChanger is just doing things like querying for the right records, and doing that at the database level is gonna be a great deal more performant.

From there, we could parallelize the hell out of our application to get a lot more throughput. If we can move away from JSON as a backend and use a relational DB like postgres for this, the DB will become the new bottleneck and saturating it would be the new upper limit for how much bandwidth we could support.

If we COULD NOT move to a RDB and had to stick with JSON, then it's all this JSON parsing that will be the bottleneck. In that world, I might look at building this out as a small service in another language better suited to dealing with JSON and string parsing as this isn't Ruby's strong suit. 
Another option assuming we're stuck with the language we started with is to use a gem like `https://github.com/brianmario/yajl-ruby`. It's a JSON parsing library that uses C bindings for much faster (2x in some cases) parsing and uses streaming to keep the memory overhead on really large files bounded, and that's another area we could run into trouble dealing with large JSON files if we don't have the luxury of querying for only a couple of rows.

One of the places I chose not to prematurely optimize was around caching for relational validations here. It'd be easy for me to add a hash I build up with which song ids, user ids and such exist and are valid. That'd give me constant time access for determining whether a change was valid, but it does add a bit more to the code to maintain and MixtapeChanges is already rather complex. It would keep us from needing to do multiple passes on our data, though. That's probably the way to go if we stay JSON backed, though we'd use more memory to do that and as the files got larger and our scale went up that could become a real problem.
In a DB backed world, we could do that with less worry about memory as we wouldn't need to keep these large JSON files in memory. We could also consider using something like memcached or a key-value store like redis to cache these values in. We could expire on any changes to our dataset to keep the data from being stale or wrong. It wouldn't be quite as fast as a hash, but it wouldn't demand memory on the main boxes running this app, and if we're parallelizing at higher scale it keeps every instance of the app from needing to recompute which records exist, so we could see some speed gains there depending on the size of the data set and how often it changes.