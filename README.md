# messenger
A one message-room messenger app with a web interface &amp; mobile app versions.

## Features
* Unicode messages
* Media: images, videos, files
* "Response" messages
* View links, images + videos, files separately
* Search function
* Dark mode

## Implementation Details

### Database details

#### `messages`
* `message_id`: Message id, could be hashed or not. `u32`
* `sender_id`: Foreign key to `users:user_id`.
* `timestamp`: Unix timestamp to the microsecond level. `timestamp`
* `is_img`: `bool`
* `is_vid`: `bool`
* `is_file`: `bool`
* `has_link`: `bool`
* `msg_body`: `text`
* `response_to`: `u32`, tagging back to `message_id`

#### `users`    
* `user_id`: User id, could be hashed or not. `u8`.
* `username`: User name, `varchar(256)`.
* `password`: Password, md5 hashed value.
* `settings`
    * `is_dark_mode`: `bool`

### Blob storage
Blob storages for images and media.

### Tech Stack
* Server: Amazon AWS EC2
* Database: `MySQL`
* Backend: `Haskell` `Yesod`
* Frontend: `TypeScript`, likely `React` (subject to change)

## Roadmap
### Prototype
* Local host with one sender
* `sqlite`
* Messages, links, dark mode
* Full Yesod

### V0
* Multiple users
* AWS with support for user login
* Minimal UI

### V1
* Images and videos
* `MySQL`
* React / Typescript

### V2
* Search function
* Filter function
* "Response" function

### V3
* Mobile version


## Developer Guide
1. The modern way to install `GHC` and `Stack` is via [`ghcup`](https://www.haskell.org/ghcup/).
2. Install the `yesod` command line tool: `stack install yesod-bin --install-ghc`
3. Build libraries: `stack build`

* Running in development mode: `stack exec -- yesod devel`
* Tests: `stack test --flag messenger:library-only --flag messenger:dev ` 
(Because `yesod devel` passes the `library-only` and `dev` flags, matching those flags means you don't need to recompile between tests and development, and it disables optimization to speed up your test compile times).
* For local documentation, use:
	* `stack haddock --open` to generate Haddock documentation for your dependencies, and open that documentation in a browser
	* `stack hoogle <function, module or type signature>` to generate a Hoogle database and search for your query