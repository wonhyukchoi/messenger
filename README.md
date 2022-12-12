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

### V0
* Multiple users
* AWS with support for user login
* Minimal UI

### V1
* Images and videos
* `MySQL`

### V2
* Search function
* Filter function
* "Response" function

### V3
* Mobile version