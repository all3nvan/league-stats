An application created with Ruby on Rails using a PostgreSQL database to track League of Legends games played between my friends and I.

The database is initially seeded with a couple of accounts that will be tracked.

A background job using delayed_job as the queue adapter is queued to periodically make requests to the Riot Games API to check if custom games have been played on the tracked accounts.
